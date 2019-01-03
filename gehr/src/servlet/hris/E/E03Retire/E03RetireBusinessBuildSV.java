/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 연금사업자변경                                                 */
/*   Program Name : 연금사업자변경  신청                                 */
/*   Program ID   : E03RetireBusinessBuildSV                                         */
/*   Description  : 연금사업자변경  신청 서블릿                                  */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                     2018/07/25 rdcamel 사용안함                                                         */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E03Retire;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DateTime;
import com.sns.jdf.util.WebUtil;
import hris.E.E03Retire.E03RetireBusinessInfoData;
import hris.E.E03Retire.rfc.*;
import hris.common.*;
import hris.common.db.AppLineDB;
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

public class E03RetireBusinessBuildSV extends EHRBaseServlet {
    
    private String UPMU_TYPE ="50";	//업무유형코드
    private static String UPMU_SUBTYPE ="01";	//하부유형    
    private String UPMU_NAME = "퇴직연금 사업자변경";
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;
        
        try{
            HttpSession session = req.getSession(false);
            
            WebUserData user    = (WebUserData)session.getAttribute("user");
            
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
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if
            
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            String retireType = new E03RetireGubunRFC().getRetireGubunInfo(user.empNo);
        	req.setAttribute("retireType", retireType);   
            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
            
            if(retireType.equalsIgnoreCase("DB") || retireType.equalsIgnoreCase("")){
            	dest = WebUtil.JspURL+"E/E03Retire/E03RetireBusinessBuild.jsp";
            }else{            
            	boolean retirePeriod = new E03RetirePeriodRFC().getRetirePeriodInfo(user.companyCode, UPMU_TYPE, UPMU_SUBTYPE);
	            req.setAttribute("retirePeriod", retirePeriod+"");//신청 기간 체크  
	            
	            if( jobid.equals("first") ) {     //제일처음 신청 화면에 들어온경우.
	            	//연금 사업자 리스트
	                Vector BusinessList_vt = new E03RetireBusinessListRFC().getRetireBusinessList(user.companyCode);
	                //현재 사용자의 연금사업자 정보
	                E03RetireBusinessInfoData businessInfo = new E03RetireBusinessInfoRFC().getRetireBusinessInfo(user.empNo);
	                // 결재자리스트
	                Vector AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
	                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());
	                
	                req.setAttribute("BusinessList_vt", BusinessList_vt);
	                req.setAttribute("cur_insu_code", businessInfo.E_INSU_CODE);
	                req.setAttribute("AppLineData_vt", AppLineData_vt);
	                
	                dest = WebUtil.JspURL+"E/E03Retire/E03RetireBusinessBuild.jsp";
	                
	            } else if( jobid.equals("create") ) { // DB insert 로직부분
//	            	@웹취약성 결재자 인위적 변경 체크 2015-08-25-------------------------------------------------------
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
//	@웹취약성 결재자 인위적 변경 체크 끝-------------------------------------------------------
	                NumberGetNextRFC func      = new NumberGetNextRFC();
	                E03RetireBusinessRFC      rfc       = new E03RetireBusinessRFC();
	                E03RetireBusinessInfoData     businessData = new E03RetireBusinessInfoData();
	                
	                Vector businessData_vt   = new Vector();
	                Vector AppLineData_vt = new Vector();
	                String ainf_seqn      = func.getNumberGetNext();
	                
	                box.copyToEntity(businessData);
	                businessData.PERNR     = PERNR;
	                businessData.AINF_SEQN = ainf_seqn;
	                businessData.BEGDA    = DateTime.getShortDateString();              // 신청자 사번(대리신청, 본인 신청)

	                
	                businessData_vt.addElement(businessData);
	                Logger.debug.println(this, "퇴직연금사업자변경신청 businessData_vt ="+businessData_vt.toString());
	                
	                int rowcount = box.getInt("RowCount");
	                for( int i = 0; i < rowcount; i++) {
	                    AppLineData appLine = new AppLineData();
	                    String      idx     = Integer.toString(i);
	                    
	                    // 여러행 자료 입력(Web)
	                    box.copyToEntity(appLine ,i);
	                    
	                    appLine.APPL_MANDT     = user.clientNo;
	                    appLine.APPL_BUKRS     = phonenumdata.E_BUKRS;
	                    appLine.APPL_PERNR     = PERNR;
	                    appLine.APPL_BEGDA     = businessData.BEGDA;
	                    appLine.APPL_AINF_SEQN = ainf_seqn;
	                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
	                    
	                    AppLineData_vt.addElement(appLine);
	                }
	                
	                con = DBUtil.getTransaction();
	                
	                AppLineDB appDB = new AppLineDB(con);
	                
	                appDB.create(AppLineData_vt);
	                rfc.build(PERNR, ainf_seqn, businessData_vt );
	                con.commit();
	                
	                // 메일 수신자 사람 ,
	                AppLineData appLine = (AppLineData)AppLineData_vt.get(0);
	                
	                Properties ptMailBody = new Properties();
	                ptMailBody.setProperty("SServer",user.SServer);              // ElOffice 접속 서버
	                ptMailBody.setProperty("from_empNo" ,user.empNo);            // 멜 발송자 사번
	                ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // 멜 수신자 사번
	                
	                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (피)신청자명
	                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (피)신청자 사번
	                
	                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);              // 문서 이름
	                ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);
	                // 신청서 순번
	                
	                // 멜 제목
	                StringBuffer sbSubject = new StringBuffer(512);
	                
	                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
	                sbSubject.append(ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");
	                
	                ptMailBody.setProperty("subject" ,sbSubject.toString());
	                
	                MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);
	                
	                String msg = "msg001";	//신청되었습니다.
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
	
	                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireBusinessDetailSV?AINF_SEQN="+ainf_seqn+"';";
	                req.setAttribute("msg", msg);
	                req.setAttribute("msg2", msg2);
	                req.setAttribute("url", url);
	                
	            } else {
	                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
	            }
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
            
        } catch(Exception e) {
//            throw new GeneralException(e);
            String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireBusinessBuildSV';";
            req.setAttribute("url", url);
            
            String dest = WebUtil.JspURL+"common/msg.jsp";
        	printJspPage(req, res, dest);
        } finally {
            DBUtil.close(con);
        }
    }
}
