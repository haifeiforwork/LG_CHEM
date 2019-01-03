/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재해야할 문서                                             */
/*   2Depth Name  :                                                             */
/*   Program Name : 휴가 결재                                                   */
/*   Program ID   : G055ApprovalVacationSV.java                                 */
/*   Description  : 휴가 결재를 위한 서블릿                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-10 유용원                                           */
/*   Update       : 2006-01-18 @v1.1 전자결재연동실패로 인해 메일발송과 위치변경*/
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D03Vocation.D03VocationData;
import hris.G.ApprovalCancelData;
import hris.G.rfc.ApprovalCancelRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import servlet.hris.D.D01OT.D01OTBuildGlobalSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;
public class G081ApprovalVacationCancelSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE = "41";
    private String UPMU_NAME = "휴가신청 취소";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            ApprovalCancelRFC appRfc = new ApprovalCancelRFC();
            Vector 		   appCancelVt = null;
//            Vector          vcAppLineData      = null;
//            Vector          orgVcAppLineData      = null;
            Vector          d03VocationData_vt = null;
            D03VocationData d03VocationData    = null;
            
            String dest  = "";
            String jobid = "";

            final Box box = WebUtil.getBox(req);
            String  AINF_SEQN  = box.get("AINF_SEQN");

            // 처리 후 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            jobid = box.get("jobid", "search");

            
/** 새로운결재 시작 **/      
        	appRfc.setRequestInput( AINF_SEQN, UPMU_TYPE);      
        	appRfc.setDetailInput(user.empNo, "1", AINF_SEQN);
        	appCancelVt = appRfc.get(user.empNo, AINF_SEQN);
    		ApprovalCancelData appData = new ApprovalCancelData();
    		appData = (ApprovalCancelData)appCancelVt.get(0);

            d03VocationData    = new D03VocationData();
            d03VocationData_vt = new Vector();
//            d03VocationData_vt = appCancelVt;
//            d03VocationData = (D03VocationData) Utils.indexOf(d03VocationData_vt, 0); //결과 데이타
            /* 승인 시 */

          
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box,  "T_ZHRA040T", appData, appRfc, new ApprovalFunction<ApprovalCancelData>() {
//               	dest = accept(req, box, null, d03VocationData, appRfc, new ApprovalFunction<D03VocationData>() {
                    public boolean porcess(ApprovalCancelData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) 
                    		throws GeneralException {

                        /* 개발자 영역 시작 */
//                        box.copyToEntity(inputData);  //사용자가 입력한 데이타로 업데이트

                        // time formatting (ksc)2016/12/21
                        final D01OTBuildGlobalSV d01sv = new D01OTBuildGlobalSV();
                        inputData.APPL_REAS = box.get("APPL_REAS");
                        inputData.UNAME     = user.empNo;
                        inputData.AEDTM     = DataUtil.getCurrentDate();

                        // [WorkTime52] 추가
                        inputData.I_NTM		= "X";

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, appCancelVt, appRfc, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, appCancelVt, appRfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            
            
/* 새로운결재 끝 
            if( jobid.equals("search") ) {
            	 //휴가취소조회            	
            	appCancelVt = appRfc.get(user.empNo, AINF_SEQN);
            	if(appCancelVt.size()>0){
            		ApprovalCancelData appData = new ApprovalCancelData();
            		appData = (ApprovalCancelData)appCancelVt.get(0);
            		//결재한 휴가조회
            		String ORG_AINF_SEQN = appData.ORG_AINF_SEQN;
            		//휴가 조회
                    D03VocationRFC  rfc = new D03VocationRFC();
                    d03VocationData_vt = rfc.getVocation(appData.PERNR, ORG_AINF_SEQN );
                    Logger.debug.println(this, "휴가결재취소요청 조회 : " + d03VocationData_vt.toString());
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

                        // ORG결재자 정보
                        orgVcAppLineData = AppUtil.getAppChangeVt(ORG_AINF_SEQN);
                        vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
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

                    dest = WebUtil.JspURL+"G/G081ApprovalVacationCancel.jsp";
                } // end if
            	
            	
            } else if( jobid.equals("A") ) {
            	
                d03VocationData    = new D03VocationData();
                d03VocationData_vt = new Vector();
                vcAppLineData      = new Vector();
                AppLineData  tempAppLine;
                Vector       vcTempAppLineData = new Vector();
                AppLineData  appLine           = new AppLineData();

                // 휴가 기초 자료
                box.copyToEntity(d03VocationData);
                d03VocationData.UNAME = user.empNo;
                d03VocationData.AEDTM = DataUtil.getCurrentDate();
                
                // 결재자 정보
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                String APPU_TYPE = box.get("APPU_TYPE");
                String APPR_SEQN = box.get("APPR_SEQN");
                String currApprNumb = "";  //ESB 오류 수정

                for (int i = 0; i < nRowCount; i++) {
                    tempAppLine = new AppLineData();
                    box.copyToEntity(tempAppLine ,i);
                    vcTempAppLineData.add(tempAppLine);
                    if (tempAppLine.APPL_APPR_STAT.equals("미결") && currApprNumb.equals("")){
                    	currApprNumb = tempAppLine.APPL_APPU_NUMB;
                    }  
                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                        appLine.APPL_BUKRS = box.getString("BUKRS");
                        appLine.APPL_PERNR = box.getString("PERNR");
                        appLine.APPL_BEGDA = box.getString("BEGDA");
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
                phonenumdata = (PersonData)numfunc.getPersonInfo(d03VocationData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);          // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);        // 멜 발송자 사번
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);   // (피)신청자명
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);   // (피)신청자 사번
                ptMailBody.setProperty("UPMU_NAME" ,"휴가결재취소");             // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);          // 신청서 순번

                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                //sbSubject.append(user.ename  + "님이 ");
                sbSubject.append(user.ename).append("님이 ");
                
                String msg;
                String msg2 = "";
                String to_empNo = d03VocationData.PERNR;
                String lastYn = "N";
                if (ars.E_RETURN.equals("S")) {

                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() -1) {
                                    // 마직막 결재자
                                	lastYn = "Y";
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailApp.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"를 승인 하셨습니다..");
                                } else {
                                    // 이후 결재자
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +" 결재를 요청 하셨습니다.");
                                    break;
                                } // end if
                            } // end if
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
                        ptMailBody.setProperty("FileName" ,"MbNoticeMailRej.html");
                        sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"를 반려 하셨습니다.");
                    } // end if

                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // 멜 수신자 사번
                    ptMailBody.setProperty("subject" ,sbSubject.toString());        // 멜 제목 설정
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof;
                        Vector vcElofficInterfaceData = new Vector(); //ESB 오류 수정
                    	//ESB 오류 수정
                    	if (!currApprNumb.equals(user.empNo)) {                    		
                        	//결재올려진 결재자 외의 테스크를 가지고 있는 결재자가 결재할때 처리:현재 전자결재에 들어가있는 DATA를 삭제후 다시 처리  
                        	ElofficInterfaceData eofD = ddfe.makeDocForDelete(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , currApprNumb);
                        	
                        	vcElofficInterfaceData.add(eofD); 
                           	ElofficInterfaceData eofI = ddfe.makeDocForInsert(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR,  ptMailBody.getProperty("UPMU_NAME")  );
                            vcElofficInterfaceData.add(eofI); 
                	    }                        
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
                                if (!currApprNumb.equals(user.empNo)) {  
                                    approvers[approvers.length-1] =user.empNo; //ESB 오류 수정 
                                }                                  
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,d03VocationData.PERNR ,approvers);
                            } // end if
                        } // end if
 
                        vcElofficInterfaceData.add(eof);
                        
                        //기존결재 반려처리
                        if(lastYn.equals("Y")){
                            appCancelVt = appRfc.get(user.empNo, AINF_SEQN);
                            ApprovalCancelData data = new ApprovalCancelData();
                            data = (ApprovalCancelData)appCancelVt.get(0);
                            orgVcAppLineData = AppUtil.getAppChangeVt(data.ORG_AINF_SEQN);
                            orgVcAppLineData.get(orgVcAppLineData.size()-1);
                            AppLineData  orgAppLine           = new AppLineData();
                            orgAppLine = (AppLineData)orgVcAppLineData.get(orgVcAppLineData.size()-1);
                            
                            //기존결재삭제
                            ElofficInterfaceData eofD = ddfe.makeDocForChange(data.ORG_AINF_SEQN ,user.SServer , phonenumdata.E_PERNR,  "휴가", orgAppLine.APPL_PERNR);
                            vcElofficInterfaceData.add(eofD);
                            
                            //신청건 만들어놓기
                            String rEmpNo = phonenumdata.E_PERNR; //요청자
                            String aEmpNo = "";	//결재자
                            String[] approvers =  new String[orgVcAppLineData.size()];
                            for(int i=0;i<orgVcAppLineData.size();i++){
                            	AppLineData app = (AppLineData)orgVcAppLineData.get(i);
                            	
                            	aEmpNo = app.APPL_PERNR;
                            	if(i==0){
                            		vcElofficInterfaceData.add(ddfe.makeDocOrg(data.ORG_AINF_SEQN ,user.SServer,"R" , "", aEmpNo, rEmpNo, "휴가", "신청" ));                            	
                            	} else {
                            		vcElofficInterfaceData.add(ddfe.makeDocOrg(data.ORG_AINF_SEQN ,user.SServer,"M" , "", aEmpNo, rEmpNo, "휴가", "진행중" )); 
                            	}
                            	rEmpNo = aEmpNo;
                            	approvers[i] = app.APPL_PERNR;
                            }                            
                            //취소
                        	vcElofficInterfaceData.add(ddfe.makeDocForReject(data.ORG_AINF_SEQN ,user.SServer, "휴가", rEmpNo , approvers));
                            Logger.debug.println("기존결재 반려처리:"+vcElofficInterfaceData.toString());
                        }
                        
                        //통합결재 잦은오류로 인해 서버실행으로 변경함  2012.11.07                         
                        try { 
                        	
                        	SendToESB esb = new SendToESB();                
                        	String esbmsg = esb.process(vcElofficInterfaceData );
                            Logger.debug.println(this ,"[esbmsg]  :"+esbmsg); 
                        	req.setAttribute("message", esbmsg);
                        	dest = WebUtil.JspURL+"common/EsbResult.jsp";
    	                } catch (Exception e) {
    	                	//Logger.error(e);
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           msg2 += "\\n" + "esb.process Eloffice 연동 실패" ;
                       }                         
    	                
                        
                    } catch (Exception e) {
                    	//Logger.error(e);
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 +=  " Eloffic 연동 실패 " ;
                    } // end try
                    //@v1.1 전자결재연동실패로 메일과 위치변경                        
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if
                    
                } else {
                    msg = ars.E_MESSAGE;
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if

                String url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";

                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if
            
 기존 결재 끝 */
            
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);


        } catch(Exception e) {
        	//Logger.error(e);
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
    }
}
