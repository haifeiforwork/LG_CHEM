/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금                                             */
/*   Program Name : 퇴직연금 신청                                */
/*   Program ID   : E03RetireRegistBuildSV                                         */
/*   Description  : 퇴직연금 신청 서블릿                                  */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                     2018/07/25 rdcamel 사용안함                                                          */
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
import hris.E.E03Retire.E03RetireRegistInfoData;
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

// 퇴직연금 신청
public class E03RetireRegistBuildSV extends EHRBaseServlet {
    private String UPMU_TYPE ="51";	//업무유형코드
    private static String UPMU_SUBTYPE ="01";	//하부유형
    private String UPMU_NAME = "퇴직연금";
        
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
                
                if(!retireType.equalsIgnoreCase("")){//DB/DC 가입이 안된경우만 해당
                	dest = WebUtil.JspURL+"E/E03Retire/E03RetireRegistBuild.jsp";
                }else{            
                	boolean retirePeriod = new E03RetirePeriodRFC().getRetirePeriodInfo(user.companyCode, UPMU_TYPE, UPMU_SUBTYPE);
    	            req.setAttribute("retirePeriod", retirePeriod+"");//신청 기간 체크
    	            
    	            if( jobid.equals("first") ) {     //제일처음 신청 화면에 들어온경우.
    	            	//퇴직연금 코드리스트
    	                Vector ResnList_vt = new E03RetireRegistResnRFC().getRetireTypeList();
    	                // 결재자리스트
    	                Vector AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
    	                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());
    	                
    	                req.setAttribute("ResnList_vt", ResnList_vt);
    	                req.setAttribute("AppLineData_vt", AppLineData_vt);

        	          	//DC인 경우 선택하는 연금 사업자 리스트
    	                Vector BusinessList_vt = new E03RetireBusinessListRFC().getRetireBusinessList(user.companyCode);      	                
    	                req.setAttribute("BusinessList_vt", BusinessList_vt);
    	                
    	                dest = WebUtil.JspURL+"E/E03Retire/E03RetireRegistBuild.jsp";
    	                
    	            } else if( jobid.equals("create") ) { // DB insert 로직부분

    	                NumberGetNextRFC func      = new NumberGetNextRFC();
    	                E03RetireRegistRFC      rfc       = new E03RetireRegistRFC();
    	                E03RetireRegistInfoData     RegistData = new E03RetireRegistInfoData();
    	                
    	                Vector RegistData_vt   = new Vector();
    	                Vector AppLineData_vt = new Vector();
    	                String ainf_seqn      = func.getNumberGetNext();
    	                
    	                box.copyToEntity(RegistData);
    	                RegistData.PERNR     = PERNR;
    	                RegistData.AINF_SEQN = ainf_seqn;
    	                RegistData.BEGDA    = DateTime.getShortDateString();              // 신청자 사번(대리신청, 본인 신청)

    	                
    	                RegistData_vt.addElement(RegistData);
    	                Logger.debug.println(this, "퇴직연금신청 RegistData_vt ="+RegistData_vt.toString());
    	                
    	                int rowcount = box.getInt("RowCount");
    	                for( int i = 0; i < rowcount; i++) {
    	                    AppLineData appLine = new AppLineData();
    	                    String      idx     = Integer.toString(i);
    	                    
    	                    // 여러행 자료 입력(Web)
    	                    box.copyToEntity(appLine ,i);
    	                    
    	                    appLine.APPL_MANDT     = user.clientNo;
    	                    appLine.APPL_BUKRS     = phonenumdata.E_BUKRS;
    	                    appLine.APPL_PERNR     = PERNR;
    	                    appLine.APPL_BEGDA     = RegistData.BEGDA;
    	                    appLine.APPL_AINF_SEQN = ainf_seqn;
    	                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
    	                    
    	                    AppLineData_vt.addElement(appLine);
    	                }
    	                
    	                con = DBUtil.getTransaction();
    	                
    	                AppLineDB appDB = new AppLineDB(con);
    	                
    	                appDB.create(AppLineData_vt);
    	                rfc.build(PERNR, ainf_seqn, RegistData_vt );
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
    	
    	                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireRegistDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
//                throw new GeneralException(e);
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireRegistBuildSV';";
                req.setAttribute("url", url);
                
                String dest = WebUtil.JspURL+"common/msg.jsp";
            	printJspPage(req, res, dest);
            } finally {
                DBUtil.close(con);
            }
        }
    }

