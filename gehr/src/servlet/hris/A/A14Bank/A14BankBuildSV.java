/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 급여계좌정보                                                */
/*   Program Name : 급여계좌 신청                                               */
/*   Program ID   : A14BankBuildSV                                              */
/*   Description  : 급여계좌를 신청할 수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                  : 2016-09-21 통합구축(Eurp 포함) - 김승철                      */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A14Bank;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.A.A03AccountDetail1Data;
import hris.A.A14Bank.A14BankCodeData;
import hris.A.A14Bank.A14BankStockFeeData;
import hris.A.A14Bank.rfc.A14BankCodeRFC;
import hris.A.A14Bank.rfc.A14BankStockFeeRFC;
import hris.A.rfc.A03AccountDetailRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class A14BankBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="10";            // 결재 업무타입(급여계좌)
    private String UPMU_NAME = "Bank Account ";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	
        //Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);
            final String bankflag = "01";
            final Box box = WebUtil.getBox(req);

            /***********     Start: 국가별 분기처리       **********************************************************/
            
            		String fdUrl = ".";
		            
//		           if (user.area.equals(Area.CN) || user.area.equals(Area.TW) || user.area.equals(Area.HK) || user.area.equals(Area.US)) {	// 타이완,홍콩은 중국화면으로
		           if (!user.area.equals(Area.KR)) {	// 타이완,홍콩은 중국화면으로
		               printJspPage(req, res,  WebUtil.ServletURL+"hris.A.A14Bank.A14BankBuildGlobalSV");
		               return;
		//			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL 폴랜드, DE 독일 은 유럽화면으로 
		//        	   fdUrl = "hris.A.A14Bank.A14BankBuildEurpSV";
					} 
		
		       
		            
            /**************    END: 국가별 분기처리        *********************************************************/
            
            String dest     = "";
            String jobid    = "";
            String PERNR;

            jobid =  box.get("jobid", "first");
           
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            Logger.debug.println(this, "[box] = "+box );

            PERNR = getPERNR(box, user); //신청대상자 사번
            
//          @웹보안진단 20151124
            String reSabunCk = user.e_representative;
            if (PERNR.equals("") || !reSabunCk.equals("Y")) {
                PERNR = user.empNo;
            } // end if

            // 대리 신청 추가
//            if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL 폴랜드, DE 독일
//    			PhoneNumRFC numfunc = new PhoneNumRFC();
//    			PhoneNumData phonenumdata;
//    			phonenumdata = (PhoneNumData) numfunc.getPhoneNum(PERNR);
//    			req.setAttribute("PhoneNumData", phonenumdata);
//            }else{
	            PersonInfoRFC numfunc = new PersonInfoRFC();
	            PersonData phonenumdata;
	            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
	            req.setAttribute("PersonData" , phonenumdata );
//            }

            req.setAttribute("PERNR" , PERNR );

/*************************************************
 *                 급여계좌신청: First
 *************************************************/
            if( jobid.equals("first") ) {   //제일처음 신청 화면에 들어온경우.

//                Vector  AppLineData_vt = null;

                //**********  결재라인, 결재 헤더 정보 조회 ****************
                getApprovalInfo(req, PERNR);    //<-- 반드시 추가
                
                // 급여계좌 리스트를 구성한다.
                A14BankCodeRFC  rfc_bank           = new A14BankCodeRFC();
//                if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL 폴랜드, DE 독일
//                	Vector a14BankValueData_vt = rfc_bank.getBankValue(PERNR);
//					req.setAttribute("a14BankValueData_vt", a14BankValueData_vt);
//                }
                A14BankCodeData data               = new A14BankCodeData();
				
                Vector          a14BankCodeData_vt = rfc_bank.getBankCode(PERNR);

                if( a14BankCodeData_vt.size() == 0 ) {		
                    String msg = g.getMessage("MSG.A.A14.0011");
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } else {
                    Logger.debug.println(this, "급여계좌 리스트 : "+ a14BankCodeData_vt.toString());

                    // 현재 등록된 급여계좌를 초기에 셋팅해주기 위해서..
                    A03AccountDetailRFC func1    = new A03AccountDetailRFC();
                    Vector              adata_vt = 
                    		(user.area == Area.KR) ? func1.getAccountDetail(PERNR, "10") : func1.getAccountDetail(PERNR) ;  // 급여계좌 국내용, 해외용

                    if( adata_vt.size() > 0 ) {
                        A03AccountDetail1Data adata = (A03AccountDetail1Data)Utils.indexOf(adata_vt,0);
                        adata.PERNR = PERNR;
                        Logger.debug.println(this,"이전데이터"+adata.toString());
                        req.setAttribute("A03AccountDetail1Data", adata);
                    }

                    req.setAttribute("a14BankCodeData_vt", a14BankCodeData_vt);

                    // 결재자리스트
                    //AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                    //Logger.debug.println(this, "결재자 리스트 : "+ AppLineData_vt.toString());

                    //req.setAttribute("AppLineData_vt",  AppLineData_vt);

                    dest = WebUtil.JspURL+"A/A14Bank/A14BankBuild_KR.jsp";
                }

/*************************************************
 *                 급여계좌신청: Create
 *************************************************/
            } else if( jobid.equals("create") ) {       //

                dest = requestApproval(req, box,  A14BankStockFeeData.class, new RequestFunction<A14BankStockFeeData>() {
                                    public String porcess(A14BankStockFeeData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                           /* 체크 로직 필요한 경우 
                           if(checkDup(user, inputData))
                               throw new GeneralException("이미 중복된 신청건이 있습니다.");*/

                            /* 결재 신청 RFC 호출 */                    
                            A14BankStockFeeRFC  rfc                 = new A14BankStockFeeRFC();
                            // 급여계좌 저장..
                            box.copyToEntity(inputData);
                            inputData.ZPERNR    = user.empNo;            // 신청자 사번 설정(대리신청 ,본인 신청)

                            rfc.setRequestInput(user.empNo, UPMU_TYPE);
                            String ainf_seqn =  rfc.build( user.empNo, null, bankflag, inputData ,box, req); 
                            Logger.debug.println(this,"결재번호  ainf_seqn="+ainf_seqn.toString());
                            if(!rfc.getReturn().isSuccess() || ainf_seqn==null) {
                                throw new GeneralException(rfc.getReturn().MSGTX);
                            };
                            
                            /* 신청 후 msg 처리 후 이동 페이지 지정 */
                            req.setAttribute("url", "location.href = '" + WebUtil.ServletURL+"hris.A.A14Bank.A14BankDetailSV?AINF_SEQN="+ainf_seqn+"';");

                            return ainf_seqn;
                            /* 개발자 작성 부분 끝 */
                        }
                    });
            	
            	
//            	@웹취약성 결재자 인위적 변경 체크 2015-08-25-------------------------------------------------------
                /*            	
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
*/
//@웹취약성 결재자 인위적 변경 체크 끝-------------------------------------------------------
            	
            	
            	/*
                NumberGetNextRFC    func                = new NumberGetNextRFC();
                A14BankStockFeeRFC  rfc                 = new A14BankStockFeeRFC();
                A14BankStockFeeData a14BankStockFeeData = new A14BankStockFeeData();
                Vector              AppLineData_vt      = new Vector();
                String              ainf_seqn           = func.getNumberGetNext();
                // 급여계좌 저장..
                a14BankStockFeeData.AINF_SEQN = ainf_seqn;             // 결재정보 일련번호
                a14BankStockFeeData.PERNR     = PERNR;    // 사원번호
                a14BankStockFeeData.BEGDA     = box.get("BEGDA");      // 신청일
                a14BankStockFeeData.BANK_FLAG = box.get("BANK_FLAG");  // 구분(은행/증권)
                a14BankStockFeeData.BANK_CODE = box.get("BANK_CODE");  // 은행/증권 회사
                a14BankStockFeeData.BANK_NAME = box.get("BANK_NAME");  // 은행/증권 회사명
                a14BankStockFeeData.BANKN     = box.get("BANKN");      // 은행/증권 계좌
                a14BankStockFeeData.ZPERNR    = user.empNo;            // 신청자 사번 설정(대리신청 ,본인 신청)

                Logger.debug.println(this, "급여계좌 신청 : " + a14BankStockFeeData.toString());

                // 결재정보 저장..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // 여러행 자료 입력(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = a14BankStockFeeData.PERNR;
                    appLine.APPL_BEGDA     = a14BankStockFeeData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);

                appDB.create(AppLineData_vt);
                Vector ret =  rfc.build( user.empNo, ainf_seqn, bankflag, a14BankStockFeeData ); 
                A14BankMessageData a14BankMessageData = new A14BankMessageData();  //return message
                a14BankMessageData = (A14BankMessageData)ret.get(0); 

            	if(a14BankMessageData.CODE.equals("S")){
	            		
		                con.commit();
		
		//              메일 수신자 사람 ,
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
		                
		                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A14Bank.A14BankDetailSV?AINF_SEQN="+ainf_seqn+"';";
		                req.setAttribute("msg", msg);
		                req.setAttribute("msg2", msg2);
		                req.setAttribute("url", url);
		                
	                
            	}else{ 
	                	
	                	con.rollback();
	                	
	                    String msg = a14BankMessageData.MESSAGE; 
	                    // 급여계좌 리스트를 구성한다.
	                    A14BankCodeRFC  rfc_bank           = new A14BankCodeRFC(); 
	                    Vector          a14BankCodeData_vt = rfc_bank.getBankCode(PERNR);
	
	
	                    // 현재 등록된 급여계좌를 초기에 셋팅해주기 위해서..
	                    A03AccountDetailRFC func1    = new A03AccountDetailRFC();
	                    Vector              adata_vt = func1.getAccountDetail(PERNR, "10");  // 급여계좌
	
	                    if( adata_vt.size() > 0 ) {
	                        A03AccountDetail1Data adata = (A03AccountDetail1Data)adata_vt.get(0);
	                        adata.PERNR = PERNR; 
	                        req.setAttribute("A03AccountDetail1Data", adata);
	                    }
	
	                    req.setAttribute("a14BankCodeData_vt", a14BankCodeData_vt);
	
	                    // 결재자리스트
	                    AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE ); 
	
	                    req.setAttribute("AppLineData_vt",  AppLineData_vt);
	
	                    req.setAttribute("message", msg);
	                    dest = WebUtil.JspURL+"A/A14Bank/A14BankBuild_KR.jsp"; 
        
            	}
*/
            	
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);

        } finally {
//            DBUtil.close(con);
//            if (con != null) try {con.close();} catch (Exception e){
//                Logger.err.println(e, e);
//            }
        }
    }
}
