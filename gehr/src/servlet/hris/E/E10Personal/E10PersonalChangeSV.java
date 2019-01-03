/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금 수정                                               */
/*   Program ID   : E10PersonalChangeSV                                         */
/*   Description  : 신청한 개인연금을 수정할 수 있도록 하는 Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-02-03  이형석                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E10Personal;

import hris.E.E10Personal.E10PentionMoneyData;
import hris.E.E10Personal.E10PersonalData;
import hris.E.E10Personal.rfc.E10PentionMoneyRFC;
import hris.E.E10Personal.rfc.E10PersonalApplRFC;
import hris.E.E11Personal.E11PersonalData;
import hris.E.E11Personal.rfc.E11PersonalDetailRFC;
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

public class E10PersonalChangeSV extends EHRBaseServlet {

    private String UPMU_TYPE ="02";   // 결재 업무타입(개인연금)

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest     = "";
            String jobid    = "";
            String cautionMsg = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            String             ainf_seqn       = box.get("AINF_SEQN");
            E10PersonalApplRFC rfc             = new E10PersonalApplRFC();
            E10PersonalData    e10PersonalData = new E10PersonalData();

            Vector  Personal_vt = rfc.getPersList( ainf_seqn );
            Logger.debug.println(this, "Personal_vt : " + Personal_vt.toString());
            req.setAttribute("Personal_vt", Personal_vt);

            e10PersonalData = (E10PersonalData)Personal_vt.get(0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(e10PersonalData.PERNR);

            req.setAttribute("PersonData" , phonenumdata );

            //처리 수 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            if( jobid.equals("first") ) {

                E10PentionMoneyData  data_money_1 = new E10PentionMoneyData();
                E10PentionMoneyData  data_money_2 = new E10PentionMoneyData();
                E11PersonalDetailRFC func1        = new E11PersonalDetailRFC();
                E11PersonalData      edata        = new E11PersonalData();

                Vector  data_money_vt      = new Vector();
                Vector  E11PersonalData_vt = func1.getDetail(e10PersonalData.PERNR, "", "");
                Vector  AppLineData_vt     = null;
                boolean flag               = true;

                AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);
                req.setAttribute("AppLineData_vt", AppLineData_vt);

                for( int i=0; i< E11PersonalData_vt.size();i++) {
                    edata = (E11PersonalData)E11PersonalData_vt.get(i);
                    Logger.debug.println(this, "edata : "+ edata.toString());

                    // 2002.10.11. 만기, 해약됐을경우에는 또다시 신청 가능함. - 협의결과
                    if(edata.STATUS.equals("진행중")){
                        flag = false;
                        break;
                    }
                }

                dest = WebUtil.JspURL+"E/E10Personal/E10PersonalChange.jsp";

                if( flag ) {
                    // 개인연금 지원액을 담아간다.
                    data_money_vt  = (new E10PentionMoneyRFC()).getPentionMoney( user.companyCode, DataUtil.getCurrentDate(), "0001" );

                    if( data_money_vt.size() > 0 ) {
                        data_money_1     = (E10PentionMoneyData)data_money_vt.get(0);
                    } else {
                        cautionMsg = "개인연금 지원금액이 없습니다.";
                    }

                    // 마이라이프 지원액을 담아간다.
                    data_money_vt  = null;
                    data_money_vt  = (new E10PentionMoneyRFC()).getPentionMoney( user.companyCode, DataUtil.getCurrentDate(), "0002" );

                    if( data_money_vt.size() > 0 ) {
                        data_money_2 = (E10PentionMoneyData)data_money_vt.get(0);
                    } else {
                        Logger.debug.println(this, "마이라이프 지원금액이 없습니다.");
                    }

                    req.setAttribute("data_money_1",    data_money_1);
                    req.setAttribute("data_money_2",    data_money_2);
                    req.setAttribute("E11PersonalData", edata);
                } else {
                    cautionMsg = "신청자격이 없습니다.";
                }
                req.setAttribute("cautionMsg",      cautionMsg);

            } else if( jobid.equals("change") ) {

                E10PersonalData    personaldata = new E10PersonalData();
                Vector  personal_vt      = new Vector();
                Vector  AppLineData_vt   = new Vector();

                box.copyToEntity(personaldata);

                personaldata.MANDT      = user.companyCode;
                personaldata.PERNR      = DataUtil.fixEndZero(e10PersonalData.PERNR, 8);
                personaldata.AINF_SEQN  = ainf_seqn;
                personaldata.APPL_TYPE  = "1";
                personaldata.ENTR_TERM  = DataUtil.fixEndZero(box.get("ENTR_TERM"),1); //가입기간
                personaldata.ZPERNR     = e10PersonalData.ZPERNR;   // 신청자 사번(대리신청, 본인 신청) 
                personaldata.UNAME      = user.empNo;               // 수정자 사번(대리신청, 본인 신청)
                personaldata.AEDTM      = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                personal_vt.addElement(personaldata);

                Logger.debug.println(this, "personaldata  : " + personaldata.toString());

                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // 여러행 자료 입력(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = e10PersonalData.PERNR;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());
                con = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);

                String msg = null;
                String msg2 = null;
                
                if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {
                
//                  기존 결재자 리스트
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);
                    
                    appDB.change(AppLineData_vt);
                    // 수정 RFC Call
                    rfc.change( ainf_seqn, personal_vt );
                    con.commit();

                    AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                    AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);

                    Logger.debug.println(this ,oldAppLine);
                    Logger.debug.println(this ,newAppLine);

                    if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

                        // 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스

                        phonenumdata  =  (PersonData)numfunc.getPersonInfo(e10PersonalData.PERNR);

                        // 이메일 보내기
                        Properties ptMailBody = new Properties();
                        ptMailBody.setProperty("SServer",user.SServer);             // ElOffice 접속 서버
                        ptMailBody.setProperty("from_empNo" ,user.empNo);           // 멜 발송자 사번
                        ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);  // 멜 수신자 사번

                        ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);      // (피)신청자명
                        ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);      // (피)신청자 사번

                        ptMailBody.setProperty("UPMU_NAME" ,"개인연금");            // 문서 이름
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

                        // ElOffice 인터페이스
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
  
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E10Personal.E10PersonalDetailSV?AINF_SEQN="+ainf_seqn+"" +
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
