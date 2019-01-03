/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금 제도전환                                            */
/*   Program Name : 퇴직연금 제도전환  신청 정보 변경                               */
/*   Program ID   : E03RetireTransChangeSV                                         */
/*   Description  : 퇴직연금 제도전환  신청 정보 변경 서블릿                                  */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E03Retire;

import hris.E.E03Retire.E03RetireTransInfoData;
import hris.E.E03Retire.rfc.E03RetireTransRFC;
import hris.E.E03Retire.rfc.E03RetireTransResnRFC;
import hris.common.*;
import hris.common.PersonData;
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
import com.sns.jdf.util.DateTime;
import com.sns.jdf.util.WebUtil;

public class E03RetireTransChangeSV extends EHRBaseServlet {

    private String UPMU_TYPE ="52";
    private String UPMU_NAME = "퇴직연금 제도전환";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E03RetireTransRFC  rfc       = new E03RetireTransRFC();
            
            Vector E03RetireTransData_vt = null;
            String ainf_seqn       = box.get("AINF_SEQN");
            
            E03RetireTransData_vt = rfc.detail(ainf_seqn);
            
            E03RetireTransInfoData firstData = (E03RetireTransInfoData)E03RetireTransData_vt.get(0);
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
            
            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.
            	//제도전환 코드리스트
                Vector ResnList_vt = new E03RetireTransResnRFC().getTransResnList();
                // 결재자리스트
                Vector AppLineData_vt = new Vector();
                AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());
                
                PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(PERNR).get(0);
                req.setAttribute("PersInfoData" ,pid );                

                req.setAttribute("ResnList_vt", ResnList_vt);
                req.setAttribute("TransInfoData", firstData);                //변경신청 내용	                
                req.setAttribute("AppLineData_vt", AppLineData_vt);

                dest = WebUtil.JspURL+"E/E03Retire/E03RetireTransChange.jsp";

            } else if( jobid.equals("change") ) { // DB update 로직부분
                E03RetireTransInfoData TransData    = new E03RetireTransInfoData();
                Vector AppLineData_vt = new Vector();
                Vector TransData_vt   = new Vector();

                box.copyToEntity(TransData);
                TransData.PERNR     = PERNR;
                TransData.BEGDA    = DateTime.getShortDateString();              

                
                TransData_vt.addElement(TransData);
                
                Logger.debug.println(this, TransData.toString());

                TransData_vt.addElement(TransData);
                Logger.debug.println(this, "제도전환 신청 수정 TransData_vt ="+TransData_vt.toString());
                
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // 같은 이름으로 여러행 받을때
                    box.copyToEntity(appLine ,i);
                    
                    appLine.APPL_MANDT      = user.clientNo;
                    appLine.APPL_BUKRS      = phonenumdata.E_BUKRS;
                    appLine.APPL_PERNR      = PERNR;
                    appLine.APPL_BEGDA      = TransData.BEGDA;
                    appLine.APPL_AINF_SEQN  = TransData.AINF_SEQN;
                    appLine.APPL_UPMU_TYPE  = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }

                con = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);
                
                String msg;
                String msg2 = null;
                
                if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {
                    
                    // 기존 결재자 리스트
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);
                    
                    appDB.change(AppLineData_vt);
                    rfc.change(PERNR, ainf_seqn, TransData_vt);
                    con.commit();
                    
                    msg = "msg002";

                    AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                    AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);

                    Logger.debug.println(this ,oldAppLine);
                    Logger.debug.println(this ,newAppLine);

                    if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

                        // 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
                        phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

                        // 이메일 보내기
                        Properties ptMailBody = new Properties();
                        ptMailBody.setProperty("SServer",user.SServer);             // ElOffice 접속 서버
                        ptMailBody.setProperty("from_empNo" ,user.empNo);           // 멜 발송자 사번
                        ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);  // 멜 수신자 사번

                        ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);      // (피)신청자명
                        ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);      // (피)신청자 사번

                        ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);            // 문서 이름
                        ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);             // 신청서 순번

                        // 멜 제목
                        StringBuffer sbSubject = new StringBuffer(512);

                        sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                        sbSubject.append( ptMailBody.getProperty("ename") + "님이 신청을 삭제하셨습니다.");
                        ptMailBody.setProperty("subject" ,sbSubject.toString());

                        ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                        MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
                        // 기존 결재자 멜 전송
                        if (!maTe.process()) {
                            msg2 = msg2 + " 삭제 " + maTe.getMessage();
                        } // end if

                        // 멜 제목
                        sbSubject = new StringBuffer(512);
                        sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                        sbSubject.append(ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");
                        
                        ptMailBody.setProperty("subject" ,sbSubject.toString());
                        ptMailBody.remove("FileName");
                        ptMailBody.setProperty("to_empNo" ,newAppLine.APPL_APPU_NUMB);

                        maTe = new MailSendToEloffic(ptMailBody);
                        // 신규 결재자 멜 전송
                        if (!maTe.process()) {
                            msg2 = msg2 +" \\n 신청 " + maTe.getMessage();
                        } // end if

//                      ElOffice 인터페이스
                        try {
                            DraftDocForEloffice ddfe = new DraftDocForEloffice();
                            ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);
                            Vector vcElofficInterfaceData = new Vector();
                            vcElofficInterfaceData.add(eof);

                            ElofficInterfaceData eofD = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                            vcElofficInterfaceData.add(eofD);
                            
                            req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                            dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                        } catch (Exception e) {
                            dest = WebUtil.JspURL+"common/msg.jsp";
                            msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                        } // end try
                    } else {
                        msg = "msg002";
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if
                } else {
                    msg = "msg005";
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if

                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireTransDetailSV?AINF_SEQN="+ainf_seqn+"" +
                "&RequestPageName=" + RequestPageName + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
                    
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
