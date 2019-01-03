/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재완료 문서                                               		*/
/*   2Depth Name  :                                                             */
/*   Program Name : 휴가 결재완료                                               		*/
/*   Program ID   : F02DeptPositionDutySV                                       */
/*   Description  : 휴가 결재완료 조회를 위한 서블릿                            		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2005-03-10 유용원                                           		*/
/*   Update       :                                                             */
/*                : 2016-10-10 FD-038 GEHR통합작업-KSC 							*/
/*                : 2018-05-17 성환희 [WorkTime52] 보상휴가 추가 건 				*/
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationOfficeRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.G.ApprovalCancelData;
import hris.G.rfc.ApprovalCancelRFC;
import hris.common.PersInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.AuthCheckNTMRFC;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationCancelChangeSV extends ApprovalBaseServlet
{
	private String UPMU_TYPE ="41";            // 휴가결재취소신청
	private String UPMU_NAME = "휴가 결재취소";
	private static String ORG_UPMU_TYPE = "18";   // 결재 업무타입(휴가신청)

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	Connection con = null;
    	
        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);
            final ApprovalCancelRFC appRfc = new ApprovalCancelRFC();
            
            Vector          vcAppLineData      = null;
            Vector          orgVcAppLineData      = null;
            Vector 		   appCancelVt = null;
            Vector          d03VocationData_vt = null;
            D03VocationData d03VocationData    = null;
            Vector appLineVt = new Vector();
          
            String dest = WebUtil.JspURL+"D/D03Vocation/D03VocationCancelChange.jsp";
            String jobid = "";
            
            
            final Box box = WebUtil.getBox(req);
            final String  AINF_SEQN  = box.get("AINF_SEQN");

            
            jobid = box.get("jobid", "first");
            Logger.debug.println("++ jobid:"+jobid);
            //대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(user.empNo);

            final String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            appRfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);        	
            appCancelVt = appRfc.get(user.empNo, AINF_SEQN);	// 결재해더를 읽어야함.
            final String PERNR = appRfc.getApprovalHeader().PERNR; //box.get("PERNR", user.empNo);
            
            req.setAttribute("isUpdate", false); //조회상태
            
            if( jobid.equals("changeMode")) {
                req.setAttribute("isUpdate", true); //수정상태
            	
            }
            
           	if( jobid.equals("first") || jobid.equals("changeMode")) {

            	
            	req.setAttribute("PersonData" , phonenumdata );
                //휴가취소조회           	
            	if(appCancelVt.size()>0){
            		ApprovalCancelData appData = new ApprovalCancelData();
            		appData = (ApprovalCancelData)appCancelVt.get(0);
            		//결재한 휴가조회
            		String ORG_AINF_SEQN = appData.ORG_AINF_SEQN;
            		//휴가 조회
                    D03VocationRFC  rfc = new D03VocationRFC();
                    rfc.setDetailInput(PERNR, I_APGUB, ORG_AINF_SEQN);
                    d03VocationData_vt = rfc.getVocation(PERNR, ORG_AINF_SEQN );
                    
                    if (!detailApporval(req, res, appRfc))                    return; //** 주의: 반드시 취소결재번호의 결재상태 **/
                    
                    Logger.debug.println(this, "휴가결재 조회 : " + d03VocationData_vt.toString());
                    if( d03VocationData_vt.size() < 1 ){
                        String msg = "조회할 항목이 없습니다.";
                        req.setAttribute("msg", msg);
                        dest = WebUtil.JspURL+"common/caution.jsp";
                    }else{
                        // 휴가
                        d03VocationData  = (D03VocationData)Utils.indexOf(d03VocationData_vt, 0);
                        
                        // 보상휴가 권한체크
                        AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
                    	String E_AUTH = authCheckNTMRFC.getAuth(d03VocationData.PERNR, "S_ESS");
                    	req.setAttribute("E_AUTH", E_AUTH);
                    	
                        // 잔여휴가일수, 장치교대근무조 체크
                        D03RemainVocationData d03RemainVocationData    = new D03RemainVocationData();
                        
                        if("Y".equals(E_AUTH)) {	//사무직
                        	String vocaType = (d03VocationData.AWART.equals("0111") 
                        						|| d03VocationData.AWART.equals("0112") 
                        						|| d03VocationData.AWART.equals("0113")) ? "B" : "A";
                        	D03RemainVocationOfficeRFC  rfcRemain = new D03RemainVocationOfficeRFC();
                        	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(d03VocationData.PERNR, d03VocationData.APPL_TO, vocaType);
                        } else {
                        	D03RemainVocationRFC rfcRemain             = new D03RemainVocationRFC();
                        	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(d03VocationData.PERNR, d03VocationData.APPL_TO);
                        }

                        // ORG결재자 정보
                        //orgVcAppLineData = AppUtil.getAppChangeVt(ORG_AINF_SEQN);
                        orgVcAppLineData = appRfc.getApprovalLine();
                        //vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                        vcAppLineData = rfc.getApprovalLine();    //결재라인
                        // 결재 정보.
                       PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                       PersInfoData      pid   = (PersInfoData) piRfc.getApproval(d03VocationData.PERNR).get(0);
                       
                        req.setAttribute("PersInfoData" ,pid );
                        req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
                        req.setAttribute("orgVcAppLineData" , orgVcAppLineData);
                        req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                        req.setAttribute("vcAppLineData" , vcAppLineData);
                        req.setAttribute("appCancelVt", appCancelVt);
                    } // end if
            	}else{

                    String msg = "조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
            	}
            	
            	
            	
            	
            } else if(jobid.equals("change")){
            	

//            	ApprovalCancelData cngData = new ApprovalCancelData();

            	
            	
                dest = changeApproval(req, box, ApprovalCancelData.class, appRfc, new ChangeFunction<ApprovalCancelData>(){
                    public String porcess(ApprovalCancelData cngData, ApprovalHeader approvalHeader, 
                    		Vector<ApprovalLineData> approvalLineDatas)                			throws GeneralException {
                    	
	            	//수정
                    box.copyToEntity(cngData);
	            	cngData.AINF_SEQN = AINF_SEQN;
	            	cngData.PERNR = PERNR;
	            	cngData.BEGDA = box.get("BEGDA");
	            	cngData.ORG_AINF_SEQN = box.get("ORG_AINF_SEQN");
	            	cngData.ORG_BEGDA = box.get("ORG_BEGDA");
	            	cngData.ORG_UPMU_TYPE = box.get("ORG_UPMU_TYPE");
	            	cngData.AEDTM = DataUtil.getCurrentDate();
	            	cngData.ZPERNR = PERNR;
	            	cngData.UNAME = PERNR;
	            	// 결재프로세스에 맞춰 추가라인
	            	cngData.APPL_TO = box.get("ORG_BEGDA");
	            	cngData.APPL_FROM = box.get("ORG_BEGDA");
	            	cngData.APPL_REAS =  box.get("CANC_REASON");
	            	
	            	cngData.CANC_REASON = box.get("CANC_REASON");
	            	Vector changeVt = new Vector();
	            	changeVt.add(cngData);
	            	appRfc.setChangeInput(user.empNo, UPMU_TYPE, AINF_SEQN); 
	            	appRfc.change(PERNR, AINF_SEQN, changeVt, box, req );
	            	
	                if(!appRfc.getReturn().isSuccess()) {
	                    req.setAttribute("msg", appRfc.getReturn().MSGTX);   //실패 메세지 처리 - 임시
	                    return null;
	                }
	                return AINF_SEQN;
                }});
                
            	
            	

          /*
            	int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);
                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_AINF_SEQN = AINF_SEQN;
                    appLine.APPL_UPMU_FLAG = box.get("APPL_UPMU_FLAG"+idx);
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                    appLine.APPL_APPR_TYPE = box.get("APPL_APPR_TYPE"+idx);
                    appLine.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    appLine.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    appLine.APPL_OTYPE     = box.get("APPL_OTYPE"+idx);
                    appLine.APPL_OBJID     = box.get("APPL_OBJID"+idx);
                    appLine.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);
                    //**********수정 시작 (20050223:유용원)**********
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = cngData.BEGDA;
                    //**********수정 끝.****************************
                    appLine.APPL_BEGDA = appLine.APPL_BEGDA.replaceAll("-","");     
                    appLineVt.addElement(appLine);
                }
                Logger.debug.println( this, cngData.toString() );
                Logger.debug.println( this, "결제라인 : "+appLineVt.toString() );

                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);
                String msg  = null;
                String msg2 = null;
                if( appDB.canUpdate((AppLineData)appLineVt.get(0)) ) {
                	Logger.debug.println( this, " D03VocationCancel appDB.change :appLineVt "+appLineVt.toString() );
                    // 기존 결재자 리스트
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(AINF_SEQN);
                    appDB.change(appLineVt);
                    Vector          ret             = new Vector(); 
                    ret = appRfc.change(PERNR, AINF_SEQN, changeVt);
                    Logger.debug.println( this, " D03VocationCancel appRfc.change :changeVt "+changeVt.toString() );
                    //C20111025_86242 체크메세지 추가 
                    String E_RETURN    = (String)ret.get(0);
                    String E_MESSAGE = (String)ret.get(1);
                    
                    Logger.debug.println(this, "E_RETURN : " +E_RETURN );
                    Logger.debug.println(this, "E_MESSAGE : " +E_MESSAGE );
                    
                    if ( E_RETURN.equals("") ) {
                        con.commit();
                        msg = "msg002";
                        AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                        AppLineData newAppLine = (AppLineData) appLineVt.get(0);
                       Logger.debug.println(this ,oldAppLine);
                        Logger.debug.println(this ,newAppLine);

                        if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {
                            // 이메일 보내기
                            Properties ptMailBody = new Properties();
                            ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                            ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                            ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);      // 멜 수신자 사번
                            ptMailBody.setProperty("ename" ,user.ename);          // (피)신청자명
                            ptMailBody.setProperty("empno" ,user.empNo);          // (피)신청자 사번
                            ptMailBody.setProperty("UPMU_NAME" , UPMU_NAME );                    // 문서 이름
                            ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번
                            
                            //                          멜 제목
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
                                ElofficInterfaceData eof = ddfe.makeDocForChange(AINF_SEQN ,user.SServer , PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);

                                Logger.debug.println(this, "makeDocForChange AINF_SEQN:"+AINF_SEQN+"oldAppLine.APPL_PERNR = " + oldAppLine.APPL_PERNR);
                                Vector vcElofficInterfaceData = new Vector();
                                vcElofficInterfaceData.add(eof);

                                ElofficInterfaceData eofD = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                                vcElofficInterfaceData.add(eofD);
//                              통합결재 잦은오류로 인해 서버실행으로 변경함  2012.11.07                         
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
                                msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                            } // end try
                        } else {
                            msg = "msg002";
                            dest = WebUtil.JspURL+"common/msg.jsp";
                        } // end if

                    } else {
                    	con.rollback();
                        msg = E_MESSAGE;
                        dest = WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationCancelChangeSV?AINF_SEQN="+AINF_SEQN+"&msg="+msg+"&RequestPageName=" + RequestPageName + "';";
                 } 
                } else {
                    msg = "msg005";
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if

                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationCancelChangeSV?AINF_SEQN="+AINF_SEQN+
                "&RequestPageName=" + RequestPageName + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
    */
    
            			
            	
/**
 * 삭제                
 */
                
                
        	} else if(jobid.equals("delete")){
        		

                dest = deleteApproval(req, box, appRfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	//D01OTRFC deleteRFC = new D01OTRFC();
                    	appRfc.setDeleteInput(user.empNo, UPMU_TYPE, appRfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = appRfc.delete(PERNR, AINF_SEQN);

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });
/*                
                
//              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
//              결재
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    app.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    app.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    app.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);

                    appLineVt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + appLineVt.toString());
//              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);
//              결재정보 삭제..
                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = box.get("AINF_SEQN");
                
                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
//                  삭제
            		appRfc.delete(PERNR, AINF_SEQN);
                    con.commit();

                    //**********수정 시작 (20050223:유용원)**********
                    // 신청건 삭제시 메일 보내기.
                    appLine = (AppLineData)appLineVt.get(0);

                    //결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
                    Properties ptMailBody = new Properties();

                    ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                    ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);     // 멜 수신자 사번
                    ptMailBody.setProperty("ename" ,user.ename);          // (피)신청자명
                    ptMailBody.setProperty("empno" ,user.empNo);          // (피)신청자 사번
                    ptMailBody.setProperty("UPMU_NAME" , UPMU_NAME);                    // 문서 이름
                    ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번

                    //멜 제목
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
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(AINF_SEQN ,user.SServer ,ptMailBody.getProperty("UPMU_NAME")
                                ,PERNR ,appLine.APPL_APPU_NUMB);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
//                      통합결재 잦은오류로 인해 서버실행으로 변경함  2012.11.07                         
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
                        msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                    } // end try

                    String msg = "msg003";
                    String url ;

                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationCancelChangeSV?AINF_SEQN="+AINF_SEQN+"&RequestPageName=" + RequestPageName + "';";
                    } // end if
                    //**********수정 끝.****************************

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationCancelChangeSV?AINF_SEQN="+AINF_SEQN+"&RequestPageName=" + RequestPageName + "';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }
        		
*/        		
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
//            DBUtil.close(con);
//            try{con.close(); } catch(Exception e){
//                Logger.err.println(e, e);
//            }
        }
    }
}
