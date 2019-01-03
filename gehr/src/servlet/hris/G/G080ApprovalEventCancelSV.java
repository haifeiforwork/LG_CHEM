/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 교육신청                                                    */
/*   Program ID   : G080ApprovalEventCancelSV                                    */
/*   Description  : 교육신청취소  부서장 결재/반려                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2013-006-12 lsa교육취소신청 결재 추가 | [요청번호]C20130627_58399  */
/*   Update       :                                                                 */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.C.C02Curri.C02CurriInfoData;
import hris.C.C03EventCancel.C03EventCancelData; 
import hris.C.C03EventCancel.C03GetEventChargeListData;
import hris.C.C03EventCancel.C03bapiReturnData;
import hris.C.C03EventCancel.rfc.C03EventCancelApplRFC; 
import hris.C.C03EventCancel.rfc.C03GetEventChargeListRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.EducationInfoRFC;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.AppLineData; 
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

public class G080ApprovalEventCancelSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector vcC03EventCancelData;
            Vector vcAppLineData;
            
            C03EventCancelData c03EventCancelData;
            
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
                  
                C03EventCancelApplRFC func = new C03EventCancelApplRFC();
                vcC03EventCancelData = func.getDetail( AINF_SEQN );
                
                Logger.debug.println(this ,vcC03EventCancelData);

                if( vcC03EventCancelData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 교육취소신청
                    c03EventCancelData = (C03EventCancelData)vcC03EventCancelData.get(0);
                    
                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(c03EventCancelData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                       
                    // 교육 정보
                    C02CurriInfoData c02CurriInfoData = (C02CurriInfoData)(new EducationInfoRFC()).getEducationInfo(c03EventCancelData.GWAID ,c03EventCancelData.CHAID);
                    
                    req.setAttribute("c03EventCancelData", c03EventCancelData);
                    req.setAttribute("c02CurriInfoData", c02CurriInfoData); 
                    req.setAttribute("vcAppLineData" , vcAppLineData);

                    dest = WebUtil.JspURL+"G/G080ApprovalEventCancel.jsp";
                } // end if
            } else if( jobid.equals("save") ) {
                
                c03EventCancelData     = new C03EventCancelData();
                vcC03EventCancelData   = new Vector();
                
                // 건강보험 재발급 신청 
                box.copyToEntity(c03EventCancelData);
                c03EventCancelData.CHENAME     = user.empNo; 
                
                vcC03EventCancelData.add(c03EventCancelData);
                
                // 결재자 정보
                vcAppLineData       = new Vector();
                AppLineData    appLine     = new AppLineData();
                
                Vector vcTempAppLineData   = new Vector();
                AppLineData         tempAppLine;
                 
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
                        appLine.APPL_BEGDA = box.getString("BEGDA1");
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
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData );
                
                Logger.debug.println(this ,vcRet);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);
                 
                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(c03EventCancelData.PERNR);
                
                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명 
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번
                
                ptMailBody.setProperty("UPMU_NAME" ,"교육취소신청");            // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번
                
                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);
                
                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "님이 ");
                
                String msg;
                String msg2 = "";
                String to_empNo = c03EventCancelData.PERNR; 
                if (ars.E_RETURN.equals("S")) { 
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() -1) {
                                    // 마직막 결재자
                                    ptMailBody.setProperty("FileName" ,"NoticeMail2_Hrd.html");  //HRD 로 바로가기
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"을 승인 하셨습니다.");
                                } else {
                                    // 이후 결재자
                                    ptMailBody.setProperty("FileName" ,"NoticeMail2.html");   //EHR 의결재 함으로 바로가기
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    sbSubject.append("결재를 요청 하셨습니다.");
                                    break;
                                } // end if
                            }// end if
                        } // end for
                    } else {
                        msg = "msg010";
                        if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            for (int i = 0; i < vcTempAppLineData.size(); i++) {
                                tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                if (tempAppLine.APPL_APPU_TYPE.equals("02") && tempAppLine.APPL_APPR_SEQN.equals("01")) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                } // end if
                            } // end for
                        } // end if
                        ptMailBody.setProperty("FileName" ,"NoticeMail3_Hrd.html");
                        sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"를 반려 하셨습니다.");
                    } // end if
                   
                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // 멜 수신자 사번
                    ptMailBody.setProperty("subject" ,sbSubject.toString());        // 멜 제목 설정
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if
                    

                   //----------------- 결재완료시 이벤트담당자에게 메일통보     
                   if (ars.E_RETURN.equals("S") &&  appLine.APPL_APPR_STAT.equals("A")) { 
	                         
	                    Properties ptMailBodyT = new Properties();
	                    ptMailBodyT.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
	                    ptMailBodyT.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번                    
	                    ptMailBodyT.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명 
	                    ptMailBodyT.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번                    
	                    ptMailBodyT.setProperty("UPMU_NAME" ,"교육취소신청(통보자용)");            // 문서 이름
	                    ptMailBodyT.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번                    
	                    // 멜 제목
	                    StringBuffer sbSubjectT = new StringBuffer(512);
	                    
	                    sbSubjectT.append("[" + ptMailBodyT.getProperty("UPMU_NAME") + "] ");
	                    sbSubjectT.append(user.ename  + "님이 ");
	                    
	                    ptMailBodyT.setProperty("FileName" ,"NoticeMail2_Inform.html");
	                    sbSubjectT.append("교육취소신청을 승인 하였음을 통보드립니다.");
	                        
	                    ptMailBodyT.setProperty("to_empNo" ,to_empNo);                   // 멜 수신자 사번
	                    ptMailBodyT.setProperty("subject" ,sbSubjectT.toString());        // 멜 제목 설정
	                    MailSendToEloffic   maTeT = new MailSendToEloffic(ptMailBodyT);
	  
	                    //-------------통보자리스트--------------
				        C03GetEventChargeListRFC func = new C03GetEventChargeListRFC();         
				        Vector ret = func.getChargeList(  c03EventCancelData.CHAID );
	                    Vector c03GetEventChargeListData_vt = new Vector();
	
	                    C03bapiReturnData c03bapiReturnData = new C03bapiReturnData();  // RETURN CODE
	                    c03GetEventChargeListData_vt = (Vector)ret.get(0);
	                    c03bapiReturnData  = (C03bapiReturnData)ret.get(1); 
	
		                C03GetEventChargeListData         tempChargeList;
				        if ( c03bapiReturnData.CODE.equals("S")) {		
	                        for (int i = 0; i < c03GetEventChargeListData_vt.size(); i++) {
	                        	tempChargeList = (C03GetEventChargeListData) c03GetEventChargeListData_vt.get(i);
	                            if ( !tempChargeList.CHPERNR.equals("")  ) {  
	                                ptMailBodyT.setProperty("to_empNo" ,tempChargeList.CHPERNR);                   // 멜 수신자 사번
	                                ptMailBodyT.setProperty("GWAJUNG" ,c03EventCancelData.GWAJUNG);        // 과정명  CSRID:
	                                ptMailBodyT.setProperty("CHASU" ,c03EventCancelData.CHASU); // 차수명 CSRID: 
	                                ptMailBodyT.setProperty("CHASUID" ,c03EventCancelData.CHAID); // 차수ID CSRID: 
	                                
	                                
	                            } // end if
	                            if (!maTeT.process()) {
	                            	msg2  += maTeT.getMessage() + "\\n";
	                            }
	    			            Logger.debug.println(this, "통보자메일  to_empNo = " +tempChargeList.CHPERNR);
	                        } // end for
	                    }
	                     
			            Logger.debug.println(this, " c03GetEventChargeListData_vt = " + c03GetEventChargeListData_vt.toString());
			            Logger.debug.println(this, " c03bapiReturnData = " + c03bapiReturnData.toString());
		            }
                    //----------------- 결재완료시 이벤트담당자에게 메일통보 END
                    
                    
/*
                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof;
                        
                        if (appLine.APPL_APPR_STAT.equals("A")) {
                            eof = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                        } else {
                            if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                                eof = ddfe.makeDocForMangerReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,vcTempAppLineData);
                            } else {
                                int nRejectLength = 0;
                                for (int i = vcTempAppLineData.size() - 1; i >= 0; i--) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                        nRejectLength = i + 1;
                                        break;
                                    } // end if
                                } // end for
                                
                                String approvers[] = new String[nRejectLength];
                                for (int i = 0; i < approvers.length; i++) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    approvers[i]    =   tempAppLine.APPL_APPU_NUMB;
                                } // end for
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,c03EventCancelData.PERNR ,approvers);
                            } // end if
                        } // end if
                        
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
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           msg2 += "\\n" + "esb.process Eloffice 연동 실패" ;
                       }   
                        
                       
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 +  " Eloffic 연동 실패 " ;
                    } // end try
                    */
		            

	                dest = WebUtil.JspURL+"common/msg.jsp";
	                
                } else {
                     msg = ars.E_MESSAGE; 
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if
                
                String url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";

                Logger.debug.println(this, " url = " + url);
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