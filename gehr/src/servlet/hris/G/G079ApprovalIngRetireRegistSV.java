/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : HR 결재함                                               */
/*   2Depth Name  : 퇴직연금 신청 결재                                           */
/*   Program Name : 퇴직연금 신청 결재                              */
/*   Program ID   : G079ApprovalIngRetireRegistSV                                         */
/*   Description  : 퇴직연금 신청 결재진행 중                           */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E03Retire.E03RetireRegistInfoData;
import hris.E.E03Retire.rfc.E03RetireBusinessListRFC;
import hris.E.E03Retire.rfc.E03RetireMBegdaRFC;
import hris.E.E03Retire.rfc.E03RetireRegistRFC;
import hris.E.E03Retire.rfc.E03RetireRegistResnRFC;

import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.AppLineData;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.MailSendToEloffic;
import hris.common.PersInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
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

public class G079ApprovalIngRetireRegistSV extends EHRBaseServlet
{
    private String UPMU_TYPE ="51";	//업무유형코드
    private String UPMU_NAME = "퇴직연금";
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
       try{
           HttpSession session = req.getSession(false);
           WebUserData user = WebUtil.getSessionUser(req);

           Vector          vcAppLineData      = null;
           Vector          e03RetireRegistInfoData_vt = null;
           E03RetireRegistInfoData e03RetireRegistInfoData    = null;

           String dest  = "";
           String jobid = "";

           Box box = WebUtil.getBox(req);
           String  AINF_SEQN  = box.get("AINF_SEQN");

           // 처리 후 돌아 갈 페이지
           String RequestPageName = box.get("RequestPageName");
           req.setAttribute("RequestPageName", RequestPageName);

           jobid = box.get("jobid");

           if(jobid == null || jobid.equals("") ){
               jobid = "search";
           }// end if
           
           if( jobid.equals("search") ) {
	           	//시작일 입력란 유/무
	           	String m_begda = new E03RetireMBegdaRFC().getRetireMBegdaInfo(UPMU_TYPE);
	           	req.setAttribute("m_begda" ,m_begda );
           	
	            E03RetireRegistInfoData    RegistData    = new E03RetireRegistInfoData();
	            E03RetireRegistRFC      rfc       = new E03RetireRegistRFC();
	            
	            Vector E03RetireRegistData_vt  = null;
	            
	            //신청 정보
	            E03RetireRegistData_vt = rfc.detail(AINF_SEQN);
	            
	            if(E03RetireRegistData_vt.size() > 0)
	            	RegistData = (E03RetireRegistInfoData)E03RetireRegistData_vt.get(0);
	            
	            Logger.debug.println(this, "E03RetireRegistData_vt : " + E03RetireRegistData_vt.toString());
           	            
	            vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

               if(E03RetireRegistData_vt.size() < 1){
                   String msg = "조회될 항목의 데이터를 읽어들이던 중 오류가 발생했습니다.";
                   String url = "history.back();";
                   req.setAttribute("msg", msg);
                   req.setAttribute("url", url);
                   dest = WebUtil.JspURL+"common/msg.jsp";
               }else{
            	   //퇴직연금 코드 리스트
                   Vector ResnList_vt = new E03RetireRegistResnRFC().getRetireTypeList();
                  
                   // 결재자리스트
                   Logger.debug.println(this, "AppLineData_vt : "+ vcAppLineData.toString());
                   
                   PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(RegistData.PERNR).get(0);

                   req.setAttribute("PersInfoData" ,pid );
                   
                   req.setAttribute("ResnList_vt", ResnList_vt);
                   req.setAttribute("RegistInfoData", RegistData);                //변경신청 내용
                   req.setAttribute("AppLineData_vt", vcAppLineData);

   	          	//DC인 경우 선택하는 연금 사업자 리스트
                   Vector BusinessList_vt = new E03RetireBusinessListRFC().getRetireBusinessList(user.companyCode);   
                   req.setAttribute("BusinessList_vt", BusinessList_vt);      
                   
                   dest = WebUtil.JspURL+"G/G079ApprovalIngRetireRegist.jsp";
               } // end if
            } else if( jobid.equals("save") ) {

            	vcAppLineData = new Vector();
            	e03RetireRegistInfoData = new E03RetireRegistInfoData();
            	e03RetireRegistInfoData_vt = new Vector();
                AppLineData   tempAppLine;

                Vector      vcTempAppLineData = new Vector();
                AppLineData appLine           = new AppLineData();

                // 퇴직연금 신규신청 기초 자료
                box.copyToEntity(e03RetireRegistInfoData);
                e03RetireRegistInfoData_vt.add(e03RetireRegistInfoData);

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

                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData ,"T_ZSOLRP014T" ,e03RetireRegistInfoData_vt);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);

                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata = (PersonData)numfunc.getPersonInfo(e03RetireRegistInfoData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);          // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);        // 멜 발송자 사번

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);   // (피)신청자명
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);   // (피)신청자 사번

                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);           // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);          // 신청서 순번

                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "님이 ");

                String msg;
                String msg2 = "";
                String to_empNo = e03RetireRegistInfoData.PERNR;

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