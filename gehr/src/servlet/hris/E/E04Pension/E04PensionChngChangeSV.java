/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 국민연금 자격변경                                           */
/*   Program Name : 국민연금 자격변경사항 신청 수정                             */
/*   Program ID   : E04PensionChngChangeSV                                      */
/*   Description  : 국민연금 자격변경을 수정할 수 있도록 하는 Class             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  최영호                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E04Pension;

import hris.E.E04Pension.E04PensionChngData;
import hris.E.E04Pension.rfc.E04PensionChngRFC;
import hris.common.*;
import hris.common.PersonData;
import hris.common.db.AppLineDB;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E04PensionChngChangeSV extends EHRBaseServlet {

    private String UPMU_TYPE ="22";    // 결재 업무타입(국민연금 자격변경)

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest     = "";
            String jobid    = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E04PensionChngRFC  rfc       = new E04PensionChngRFC();
            E04PensionChngData firstData = new E04PensionChngData();

            Vector e04PensionChngData_vt = null;
            Vector AppLineData_vt        = null;
            String ainf_seqn             = box.get("AINF_SEQN");

            e04PensionChngData_vt = rfc.getPensionChng( "", ainf_seqn );
            Logger.debug.println(this, "국민연금 자격변경 수정 : " + e04PensionChngData_vt.toString());

            firstData = (E04PensionChngData)e04PensionChngData_vt.get(0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // 최종 돌아갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            if( jobid.equals("first") ) {     //제일처음 수정 화면에 들어온경우.

                AppLineData_vt = new Vector();

                // 결재자리스트
                AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                req.setAttribute("AppLineData_vt", AppLineData_vt);
                req.setAttribute("e04PensionChngData_vt", e04PensionChngData_vt);

                dest = WebUtil.JspURL+"E/E04Pension/E04PensionChngChange.jsp";

            } else if( jobid.equals("change") ) {

                E04PensionChngData e04PensionChngData = new E04PensionChngData();
                AppLineData_vt     = new Vector();

                // 국민연금 자격변경수정..
                e04PensionChngData.AINF_SEQN   = ainf_seqn;              // 결재정보 일련번호
                e04PensionChngData.PERNR       = firstData.PERNR;        // 사원번호
                e04PensionChngData.BEGDA       = box.get("BEGDA");       // 신청일자
                e04PensionChngData.CHNG_TYPE   = box.get("CHNG_TYPE");   // 자격사항변경항목코드
                e04PensionChngData.CHNG_TEXT   = box.get("CHNG_TEXT");   // 자격사항변경항목코드 text
                e04PensionChngData.CHNG_BEFORE = box.get("CHNG_BEFORE"); // 자격사항변경전데이타
                e04PensionChngData.CHNG_AFTER  = box.get("CHNG_AFTER");  // 자격사항변경후데이타
                e04PensionChngData.ZPERNR      = firstData.ZPERNR;       // 신청자 사번(대리신청, 본인 신청)
                e04PensionChngData.UNAME       = user.empNo;             // 수정자 사번(대리신청, 본인 신청)
                e04PensionChngData.AEDTM       = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                Logger.debug.println(this, "국민연금 자격변경 수정 : " + e04PensionChngData.toString());

                // 결재정보 저장..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // 같은 이름으로 여러행 받을때
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = firstData.PERNR;
                    appLine.APPL_BEGDA     = e04PensionChngData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);

                String msg;
                String msg2 = null;

                if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {

                    // 기존 결재자 리스트
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                    appDB.change(AppLineData_vt);
                    rfc.change( firstData.PERNR, ainf_seqn, e04PensionChngData );
                    con.commit();

                    msg = "msg002";

                    AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                    AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);

                    Logger.debug.println(this ,oldAppLine);
                    Logger.debug.println(this ,newAppLine);

                    if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

                        // 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
                        phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);

                        // 이메일 보내기
                        Properties ptMailBody = new Properties();
                        ptMailBody.setProperty("SServer",user.SServer);             // ElOffice 접속 서버
                        ptMailBody.setProperty("from_empNo" ,user.empNo);           // 멜 발송자 사번
                        ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);  // 멜 수신자 사번

                        ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);      // (피)신청자명
                        ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);      // (피)신청자 사번

                        ptMailBody.setProperty("UPMU_NAME" ,"국민연금 자격변경");   // 문서 이름
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
                            ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") ,oldAppLine.APPL_PERNR);
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

                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E04Pension.E04PensionChngDetailSV?AINF_SEQN="+ainf_seqn+"" +
                "&RequestPageName=" + RequestPageName + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, "destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
    }
}
