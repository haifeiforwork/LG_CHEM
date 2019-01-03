/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 국민연금 자격변경                                           */
/*   Program Name : 국민연금 자격변경사항 신청                                  */
/*   Program ID   : E04PensionChngBuildSV                                       */
/*   Description  : 국민연금 자격변경사항을 신청할 수 있도록 하는 Class         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  최영호                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                     2018/07/25 rdcamel 사용안함                                                          */
/********************************************************************************/

package servlet.hris.E.E04Pension;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.db.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.E.E04Pension.E04PensionChngData;
import hris.E.E04Pension.rfc.*;

public class E04PensionChngBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="22";    // 결재 업무타입(국민연금 자격변경등록)
    private String UPMU_NAME = "국민연금 자격변경";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";
            String PERNR;

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            PERNR = box.get("PERNR");
            
            //          @웹보안진단 20151124
            String reSabunCk = user.e_representative;
            if (PERNR.equals("") || !reSabunCk.equals("Y")) {
                PERNR = user.empNo;
            } // end if
            Logger.debug.println(this, "[PERNR] = "+PERNR);
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {   //제일처음 신청 화면에 들어온경우.

                Vector AppLineData_vt = null;

                // 결재자리스트
                AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                req.setAttribute("AppLineData_vt",  AppLineData_vt);
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("PERNR" , PERNR );

                dest = WebUtil.JspURL+"E/E04Pension/E04PensionChngBuild.jsp";

            } else if( jobid.equals("create") ) {
//            	@웹취약성 결재자 인위적 변경 체크 2015-08-25-------------------------------------------------------
            	Vector   AppLine_vt     = null;
            	String		appLineCheck = "Y";
            	AppLine_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
            	
            	for (int i = 0; i < AppLine_vt.size(); i++){
            		AppLineData appLine = new AppLineData();
            		appLine = (AppLineData)AppLine_vt.get(i);
            		if(!appLine.APPL_APPU_TYPE.equals("01")){//변경 가능한 결재자 제외
            			Logger.debug.println(this, "appLine.APPL_PERNR : " + appLine.APPL_PERNR.toString());
            			Logger.debug.println(this, "box.get(APPL_APPU_NUMBi) : " + box.get("APPL_APPU_NUMB"+i));
            			if(!appLine.APPL_PERNR.equals(box.get("APPL_APPU_NUMB"+i))){
            				appLineCheck = "N";
            			}
            		}
            	}
            	
            	if(appLineCheck.equals("N")){
            		String msg = "msg020";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                    Logger.debug.println(this, " destributed = " + dest);
                    printJspPage(req, res, dest);
                    return;
            	}
//@웹취약성 결재자 인위적 변경 체크 끝-------------------------------------------------------
                NumberGetNextRFC    func = new NumberGetNextRFC();
                E04PensionChngRFC   rfc  = new E04PensionChngRFC();
                E04PensionChngData  e04PensionChngData  = new E04PensionChngData();

                Vector AppLineData_vt = new Vector();
                String ainf_seqn      = func.getNumberGetNext();

                /////////////////////////////////////////////////////////////////////////////
                // 국민연금 자격변경사항 입력..
                e04PensionChngData.AINF_SEQN   = ainf_seqn;               // 결재정보 일련번호
                e04PensionChngData.PERNR       = PERNR;                   // 사원번호
                e04PensionChngData.BEGDA       = box.get("BEGDA");        // 신청일자
                e04PensionChngData.CHNG_TYPE   = box.get("CHNG_TYPE");    // 자격사항변경항목코드
                e04PensionChngData.CHNG_TEXT   = box.get("CHNG_TEXT");
                e04PensionChngData.CHNG_BEFORE = box.get("CHNG_BEFORE");  // 자격사항변경전데이타
                e04PensionChngData.CHNG_AFTER  = box.get("CHNG_AFTER");   // 자격사항변경후데이타
                e04PensionChngData.ZPERNR      = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                e04PensionChngData.UNAME       = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                e04PensionChngData.AEDTM       = DataUtil.getCurrentDate();  // 변경일(현재날짜)
                Logger.debug.println(this, e04PensionChngData.toString());

                // 결재정보 저장..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // 여러행 자료 입력(Web)
                    box.copyToEntity(appLine ,i);
                    
                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = e04PensionChngData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build( PERNR, ainf_seqn , e04PensionChngData );
                con.commit();

                // 메일 수신자 사람 ,
                AppLineData appLine = (AppLineData)AppLineData_vt.get(0);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);     // 멜 수신자 사번

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번

                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);                 // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);
                // 신청서 순번

                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");
                
                ptMailBody.setProperty("subject" ,sbSubject.toString());

                MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);

                String msg = "msg001";;
                String msg2 = "";

                if (!maTe.process()) {
                    msg2 = maTe.getMessage();
                } // end if

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    
                    ElofficInterfaceData eof = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));

                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                } // end try  
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E04Pension.E04PensionChngDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
