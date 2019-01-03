/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 주택자금 신규신청 결재                                      */
/*   Program Name : 주택자금 신규신청 결재                                      */
/*   Program ID   : G053ApprovalIngHouseSV                                      */
/*   Description  : 주택자금 신규신청 결재 취소                                 */
/*   Note         :                                                             */
/*   Creation     : 2005-03-10  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E05House.*;
import hris.E.E05House.rfc.*;

import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.PersonData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G053ApprovalIngHouseSV extends EHRBaseServlet
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
       try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector       vcAppLineData;
            E05HouseData e05HouseData;
            Vector       vc05HouseData;

            String dest  = "";
            String jobid = "";
            Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            jobid = box.get("jobid");
            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if

            if( jobid.equals("search") ) {

                E05HouseRFC       rfc   = new E05HouseRFC();
                PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();

                vc05HouseData = rfc.detail(AINF_SEQN);
                Logger.debug.println(this, " vc05HouseData=["+vc05HouseData);

                vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                if(vc05HouseData.size() < 1){
                    String msg = "조회될 항목의 데이터를 읽어들이던 중 오류가 발생했습니다.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                    e05HouseData = (E05HouseData)vc05HouseData.get(0);

                    E05PersInfoData E05PersInfoData = null;

                    // E05PersInfoRFC 현주소, 근속년수
                    E05PersInfoRFC func1 = new E05PersInfoRFC();
                    E05PersInfoData = (E05PersInfoData)func1.getPersInfo(e05HouseData.PERNR);
                    Logger.debug.println(this, "E05PersInfoData : "+ E05PersInfoData.toString());

                    PersInfoData  pid = (PersInfoData)piRfc.getApproval(e05HouseData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("e05HouseData"       , e05HouseData);
                    req.setAttribute("vcAppLineData"     , vcAppLineData);
                    req.setAttribute("E05PersInfoData", E05PersInfoData);

                    dest = WebUtil.JspURL+"G/G053ApprovalIngHouse.jsp";
                } // end if

            } else if( jobid.equals("save") ) {

                e05HouseData  = new E05HouseData();
                vcAppLineData = new Vector();
                vc05HouseData = new Vector();
                AppLineData   tempAppLine;

                Vector      vcTempAppLineData = new Vector();
                AppLineData appLine           = new AppLineData();

                // 주택자금 신규신청 기초 자료
                box.copyToEntity(e05HouseData);
                e05HouseData.TILBG = box.get("REFN_BEGDA");
                e05HouseData.DLEND = box.get("REFN_ENDDA");
                e05HouseData.UNAME = user.empNo;
                e05HouseData.AEDTM = DataUtil.getCurrentDate();
                
                vc05HouseData.add(e05HouseData);;

                // 결재자 정보
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                String APPU_TYPE   =  box.get("APPU_TYPE");
                String APPR_SEQN   =  box.get("APPR_SEQN");

                for (int i = 0; i < nRowCount; i++) {
                    tempAppLine = new AppLineData();
                    box.copyToEntity(tempAppLine ,i);
                    vcTempAppLineData.add(tempAppLine);

                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                        appLine.APPL_BUKRS = box.getString("BUKRS");
                        appLine.APPL_PERNR = box.getString("PERNR");
                        appLine.APPL_BEGDA = box.getString("BEGDA");
                        appLine.APPL_AINF_SEQN = box.getString("AINF_SEQN");
                        appLine.APPL_APPU_TYPE = APPU_TYPE;
                        appLine.APPL_APPR_SEQN = APPR_SEQN;
                        appLine.APPL_APPU_NUMB = user.empNo;
                        appLine.APPL_APPR_STAT = box.getString("APPR_STAT");
                        appLine.APPL_BIGO_TEXT = box.getString("BIGO_TEXT");
                        appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
                    } // end if
                } // end for
                Logger.debug.println(this ,vcTempAppLineData);
                Logger.debug.println(this ,appLine);
                vcAppLineData.add(appLine);

                G001ApprovalProcessRFC  Apr = new G001ApprovalProcessRFC();
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData ,"T_ZHRA014T" ,vc05HouseData );

                Logger.debug.println(this ,vcRet);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);

                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata = (PersonData)numfunc.getPersonInfo(e05HouseData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);          // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);        // 멜 발송자 사번

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);   // (피)신청자명
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);   // (피)신청자 사번

                ptMailBody.setProperty("UPMU_NAME" ,"주택자금");           // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);          // 신청서 순번

                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "님이 ");

                String msg;
                String msg2 = "";
                String to_empNo = e05HouseData.PERNR;

                if (ars.E_RETURN.equals("S")) {

                    ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                    msg = "msg011";

                    for (int i = 0; i < vcTempAppLineData.size(); i++) {
                        tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                        if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                            // 이후 결재자
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                            to_empNo = tempAppLine.APPL_APPU_NUMB;
                            break;
                        } else {

                        } // end if
                    } // end for

                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +" 삭제 하셨습니다.");

                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // 멜 수신자 사번
                    ptMailBody.setProperty("subject"  ,sbSubject.toString());       // 멜 제목 설정
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();

                        ElofficInterfaceData eof = ddfe.makeDocForCancel(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,to_empNo);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 +  " Eloffic 연동 실패 " ;
                    } // end try
                } else {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg = ars.E_MESSAGE;
                } // end if

                String url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";

                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {

        }
    }
}