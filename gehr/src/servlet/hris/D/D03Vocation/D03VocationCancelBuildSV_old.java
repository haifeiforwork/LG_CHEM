/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재완료 문서                                               */
/*   2Depth Name  :                                                             */
/*   Program Name : 휴가 결재완료                                               */
/*   Program ID   : F02DeptPositionDutySV                                       */
/*   Description  : 휴가 결재완료 조회를 위한 서블릿                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-10 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.G.ApprovalCancelData;
import hris.G.rfc.ApprovalCancelRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.db.AppLineDB;
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

public class D03VocationCancelBuildSV_old extends ApprovalBaseServlet
{
	private String UPMU_TYPE ="41";            // 휴가결재취소신청
	private String UPMU_NAME = "휴가 결재취소요청";
	private static String ORG_UPMU_TYPE = "18";   // 결재 업무타입(휴가신청)

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	Connection con = null;
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector          vcAppLineData      = null;
            Vector          d03VocationData_vt = null;
            D03VocationData d03VocationData    = null;

            String dest = WebUtil.JspURL+"D/D03Vocation/D03VocationCancelBuild.jsp";
            String jobid = "";
            String PERNR;
            
            Box box = WebUtil.getBox(req);
            String  AINF_SEQN  = box.get("AINF_SEQN");

            jobid = box.get("jobid", "search");

            PERNR =  getPERNR(box, user); //box.get("PERNR");
            
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if
            
            if( jobid.equals("search") || jobid.equals("after")) {
            	if(jobid.equals("after")){
            		req.setAttribute("jobid", "create");
            	}
                //휴가 조회
                D03VocationRFC  rfc = new D03VocationRFC();
                rfc.setRequestInput(user.empNo, UPMU_TYPE);
                d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );
                Logger.debug.println(this, "휴가결재 조회 : " + d03VocationData_vt.toString());
                //결재자리스트
                //Vector AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                Vector AppLineData_vt = AppUtil.getAppVector( PERNR, "18" );
                
                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());
                
                req.setAttribute("AppLineData_vt",        AppLineData_vt);
                
                if( d03VocationData_vt.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 휴가
                    d03VocationData  = (D03VocationData)d03VocationData_vt.get(0);

                    // 잔여휴가일수, 장치교대근무조 체크
                    D03RemainVocationRFC  rfcRemain                = null;
                    D03RemainVocationData d03RemainVocationData    = new D03RemainVocationData();

                    rfcRemain             = new D03RemainVocationRFC();
                    d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(user.empNo, DataUtil.getCurrentDate());

                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                    //결재라인, 결재 헤더 정보 조회
                    UPMU_TYPE ="18"; 
                    getApprovalInfo(req, PERNR);    //<-- 반드시 추가
                    UPMU_TYPE ="41"; 

                    // 결재 정보.
                    PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                    PersInfoData      pid   = (PersInfoData) piRfc.getApproval(d03VocationData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                    req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
                } // end if
                
            } else if( jobid.equals("create") ) {
            	NumberGetNextRFC  func              = new NumberGetNextRFC();
            	ApprovalCancelRFC    rfc               = new ApprovalCancelRFC();
            	Vector approvalCancelVt = new Vector();
            	Vector appLineDataVt = new Vector();
            	ApprovalCancelData data = new ApprovalCancelData();
            	data.AINF_SEQN = func.getNumberGetNext();
            	data.PERNR = PERNR;
            	data.BEGDA = DataUtil.getCurrentDate();
            	data.CANC_REASON = box.get("CANC_REASON");
            	data.ORG_AINF_SEQN = AINF_SEQN;
            	data.ORG_UPMU_TYPE = ORG_UPMU_TYPE;
            	data.AEDTM = DataUtil.getCurrentDate();    
            	data.ZPERNR = PERNR;
            	data.UNAME = PERNR;
            	
            	approvalCancelVt.addElement(data);
            	int rowcount = box.getInt("RowCount");
            	for( int i = 0; i < rowcount; i++) {
            		AppLineData appLine = new AppLineData();
                    //String      idx     = Integer.toString(i);

                    // 여러행 자료 입력(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT    = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = data.BEGDA;
                    appLine.APPL_AINF_SEQN = data.AINF_SEQN;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    appLineDataVt.addElement(appLine);
            	}
            	Logger.debug.println( this, approvalCancelVt.toString() );
                Logger.debug.println( this, "결제라인 : "+appLineDataVt.toString() );
                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(appLineDataVt);

                Vector          vcRet             = new Vector(); 
                Logger.debug.println(this, "rfc.build before" );
                //vcRet =  rfc.build(data.PERNR, data.AINF_SEQN,  approvalCancelVt);
                String E_RETURN    = (String)vcRet.get(0);
                String E_MESSAGE = (String)vcRet.get(1);

                Logger.debug.println(this, "E_RETURN : " +E_RETURN );
                Logger.debug.println(this, "E_MESSAGE : " +E_MESSAGE );
                if ( E_RETURN.equals("") ) {
                	con.commit();
//                	 메일 수신자 사람 ,
                    AppLineData appLine = (AppLineData)appLineDataVt.get(0);

                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                    ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                    ptMailBody.setProperty("to_empNo", appLine.APPL_APPU_NUMB);     // 멜 수신자 사번

                    ptMailBody.setProperty("ename" ,user.ename);          // (피)신청자명
                    ptMailBody.setProperty("empno" ,user.empNo);          // (피)신청자 사번

                    ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);                 // 문서 이름
                    ptMailBody.setProperty("AINF_SEQN", data.AINF_SEQN);
                    // 신청서 순번
                    // 멜 제목
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append(ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");

                    ptMailBody.setProperty("subject" ,sbSubject.toString());
                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");
                    
                    String msg = "msg001";
                    String msg2 = "";

                    MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();

                        ElofficInterfaceData eof = ddfe.makeDocContents(data.AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        //req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        //dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                        //통합결재 잦은오류로 인해 서버실행으로 변경함  2012.11.07                         
                        try {                         	
                        	SendToESB esb = new SendToESB();                
                        	String esbmsg = esb.process(vcElofficInterfaceData );
                            Logger.debug.println(this ,"[esbmsg]  :"+esbmsg); 
                        	req.setAttribute("message", esbmsg);
                        	dest = WebUtil.JspURL+"common/EsbResult.jsp";
    	                } catch (Exception e) {
    	                	Logger.error(e);
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                       }           
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        //msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                        msg = msg + "\\n" + " Eloffic 연동 실패" ;
                    } // end try
                    
                    String url = "location.href = \'" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationCancelBuildSV?AINF_SEQN="+AINF_SEQN+"&jobid=after\'";
                    req.setAttribute("msg", msg);
                    req.setAttribute("msg2", msg2);
                    req.setAttribute("url", url);
                } else {
                	con.rollback();
                	String msg = E_MESSAGE; 
                	req.setAttribute("", jobid);
                    req.setAttribute("message", msg);
                    dest = WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationCancelBuildSV?AINF_SEQN="+AINF_SEQN+"';";
                }

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
        	Logger.error(e);
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
            try{ con.close(); } catch(Exception e){
                Logger.err.println(e, e);
            }
        }
    }
}
