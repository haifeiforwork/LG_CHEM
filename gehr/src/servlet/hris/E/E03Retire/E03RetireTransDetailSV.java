/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금 제도전환                                            */
/*   Program Name : 퇴직연금 제도전환  신청 정보 조회                               */
/*   Program ID   : E03RetireTransDetailSV                                         */
/*   Description  : 퇴직연금 제도전환  신청 정보 조회 서블릿                                  */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                     2018/07/25 rdcamel 사용안함                                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E03Retire;

import hris.E.E03Retire.E03RetireTransInfoData;
import hris.E.E03Retire.rfc.E03RetireTransRFC;
import hris.E.E03Retire.rfc.E03RetireTransResnRFC;
import hris.common.AppLineData;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.MailSendToEloffic;
import hris.common.PersInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.db.AppLineDB;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

//퇴직연금 제도전환신청조회삭제
public class E03RetireTransDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="52";
    private String UPMU_NAME = "퇴직연금 제도전환";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E03RetireTransInfoData    firstData    = new E03RetireTransInfoData();
            E03RetireTransRFC      rfc       = new E03RetireTransRFC();
            
            Vector E03RetireTransData_vt  = null;
            String ainf_seqn           = box.get("AINF_SEQN");
            
            E03RetireTransData_vt = rfc.detail(ainf_seqn);
            
            if(E03RetireTransData_vt.size() > 0)
            	firstData = (E03RetireTransInfoData)E03RetireTransData_vt.get(0);
            
            Logger.debug.println(this, "E03RetireTransData_vt : " + E03RetireTransData_vt.toString());

            String PERNR = firstData.PERNR;
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // 최종 돌아갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            if( jobid.equals("first") ) {
            	//제도전환 코드리스트
                Vector ResnList_vt = new E03RetireTransResnRFC().getTransResnList();
                // 결재자리스트
                Vector AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(PERNR).get(0);
                req.setAttribute("PersInfoData" ,pid );
                
                req.setAttribute("ResnList_vt", ResnList_vt);
                req.setAttribute("TransInfoData", firstData);                //변경신청 내용	                
                req.setAttribute("AppLineData_vt", AppLineData_vt);
                
                dest = WebUtil.JspURL+"E/E03Retire/E03RetireTransDetail.jsp";
            } else if( jobid.equals("delete") ) {
                Vector AppLineData_vt = new Vector();

                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = phonenumdata.E_BUKRS;
                appLine.APPL_PERNR     = PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = ainf_seqn;

                // 2002.07.25.---------------------------------------------------------------------------
                // 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                // 결재
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx = Integer.toString(i);

//                  같은 이름으로 여러행 받을때
                    box.copyToEntity(app ,i);
                    
                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
                // 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                // 2002.07.25.---------------------------------------------------------------------------

                con                = DBUtil.getTransaction();
                AppLineDB  appDB   = new AppLineDB(con);
                
                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    rfc.delete(PERNR, ainf_seqn );
                    con.commit();

//                  신청건 삭제시 메일 보내기.
                    appLine = (AppLineData)AppLineData_vt.get(0);
                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);              // ElOffice 접속 서버
                    ptMailBody.setProperty("from_empNo" ,user.empNo);            // 멜 발송자 사번
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // 멜 수신자 사번

                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (피)신청자명
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (피)신청자 사번

                    ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);             // 문서 이름
                    ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);              // 신청서 순번
                    // 신청건 삭제시 메일 보내기.

                    // 멜 제목
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append( ptMailBody.getProperty("ename") + "님이 신청을 삭제하셨습니다.");
                    ptMailBody.setProperty("subject" ,sbSubject.toString());    // 멜 제목 설정

                    ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    String msg2 = null;
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(ainf_seqn ,user.SServer ,ptMailBody.getProperty("UPMU_NAME") 
                                ,PERNR ,appLine.APPL_APPU_NUMB);
                        
                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                    } // end try
                    
                    String msg = "msg003";
                    String url ;

                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireTransBuildSV';";
                    } // end if
                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireTransDetailSV?AINF_SEQN="+ainf_seqn+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
    }
}
