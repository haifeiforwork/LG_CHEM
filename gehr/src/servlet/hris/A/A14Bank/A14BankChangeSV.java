/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 급여계좌정보                                                */
/*   Program Name : 급여계좌 수정                                               */
/*   Program ID   : A14BankChangeSV                                             */
/*   Description  : 급여계좌를 수정할 수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                  : 2016-09-20 통합구축 - 김승철                     */
/*                      //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel                                                         */
/********************************************************************************/

package	servlet.hris.A.A14Bank;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.A.A14Bank.A14BankCodeData;
import hris.A.A14Bank.A14BankStockFeeData;
import hris.A.A14Bank.rfc.A14BankCodeRFC;
import hris.A.A14Bank.rfc.A14BankStockFeeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class A14BankChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="10";     // 결재 업무타입(급여계좌)
    private String UPMU_NAME = "급여계좌 ";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
//        Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            /**         * Start: 국가별 분기처리             */
            String fdUrl = ".";
            
            ////@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel 
           if (user.area.equals(Area.CN) || user.area.equals(Area.TW) || user.area.equals(Area.HK) || user.area.equals(Area.US) || user.area.equals(Area.MX)) {	// 타이완,홍콩은 중국화면으로
               fdUrl = "hris.A.A14Bank.A14BankChangeGlobalSV";
//			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL 폴랜드, DE 독일 은 유럽화면으로 
//        	   fdUrl = "hris.A.A14Bank.A14BankChangeEurpSV";
			} 

           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );
           
            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }
            /**             * END: 국가별 분기처리             */
            
            String dest     = WebUtil.JspURL+"common/msg.jsp";
            String jobid    = "";
            final String bankflag = "01";

            final Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            A14BankStockFeeRFC  rfc       = new A14BankStockFeeRFC();
            //A14BankStockFeeData firstData = new A14BankStockFeeData();

            Vector a14BankStockFeeData_vt = null;
            final String AINF_SEQN              = box.get("AINF_SEQN");


            //**********수정 끝.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            // 현재 수정할 레코드..
            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // 결재란설정
            
            a14BankStockFeeData_vt = rfc.getBankStockFee( "", AINF_SEQN, bankflag );
            if(!rfc.getReturn().isSuccess()){
                req.setAttribute("msg", rfc.getReturn().MSGTX);                    
                req.setAttribute("url", "history.back();");
                printJspPage(req, res, dest);
                return;
            }
            
            Logger.debug.println(this, "급여계좌 상세조회 : " + a14BankStockFeeData_vt.toString());

            req.setAttribute("a14BankStockFeeData_vt", a14BankStockFeeData_vt);

            final A14BankStockFeeData firstData = (A14BankStockFeeData)Utils.indexOf(a14BankStockFeeData_vt,0);

            // 대리 신청 추가
            if(firstData!=null){
	            PersonInfoRFC numfunc = new PersonInfoRFC();
	            PersonData phonenumdata;
	            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
	            req.setAttribute("PersonData" , phonenumdata );
            }

            if( jobid.equals("first") ) {    //제일처음 신청 화면에 들어온경우.

//                Vector AppLineData_vt = null;

                // 급여계좌 리스트를 구성한다.
                A14BankCodeRFC  rfc_bank           = new A14BankCodeRFC();
                A14BankCodeData data               = new A14BankCodeData();
                Vector          a14BankCodeData_vt = rfc_bank.getBankCode(firstData.PERNR);
                

                if( a14BankCodeData_vt.size() == 0 ) {  // 수정이기때문에 이 조건을 만족하기는 힘들겠다.
                    String msg = "개인의 급여계좌 정보가 존재하지 않습니다.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } else {
                    // 급여계좌 리스트
                    req.setAttribute("a14BankCodeData_vt", a14BankCodeData_vt);

                    // 결재자리스트
                    //AppLineData_vt = AppUtil.getAppChangeVt(AINF_SEQN);
                    req.setAttribute("isUpdate", true); //등록 수정 여부   <- 수정쪽에는 반드시 필요함
                    //req.setAttribute("AppLineData_vt", AppLineData_vt);
                    
                    detailApporval(req, res, rfc);
                    dest = WebUtil.JspURL+"A/A14Bank/A14BankBuild_KR.jsp";	// 신청+수정
                }

            } else if( jobid.equals("change") ) {

                /* 실제 수정 부분 */
                dest = changeApproval(req, box, A14BankStockFeeData.class, rfc, new ChangeFunction<A14BankStockFeeData>(){

                    public String porcess(A14BankStockFeeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas)
                			throws GeneralException {
                        /* 결재 신청 RFC 호출 */
                    	A14BankStockFeeRFC changeRFC = new A14BankStockFeeRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(firstData.PERNR, AINF_SEQN, bankflag, Utils.asVector(inputData), box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            req.setAttribute("msg", "수정에 실패 하였습니다.\n" + changeRFC.getReturn().MSGTX);   //실패 메세지 처리 - 임시
                            return null;
                        }

                        return inputData.AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
                
  /*
                
                A14BankStockFeeData a14BankStockFeeData = new A14BankStockFeeData();
                Vector              AppLineData_vt      = new Vector();

                // 급여계좌 수정..
                a14BankStockFeeData.AINF_SEQN = AINF_SEQN;             // 결재정보 일련번호
                a14BankStockFeeData.PERNR     = firstData.PERNR;       // 사원번호
                a14BankStockFeeData.BEGDA     = box.get("BEGDA");      // 신청일
                a14BankStockFeeData.BANK_FLAG = box.get("BANK_FLAG");  // 구분(은행/증권)
                a14BankStockFeeData.BANK_CODE = box.get("BANK_CODE");  // 은행/증권 회사
                a14BankStockFeeData.BANK_NAME = box.get("BANK_NAME");  // 은행/증권 회사명
                a14BankStockFeeData.BANKN     = box.get("BANKN");      // 은행/증권 계좌
                a14BankStockFeeData.ZPERNR    = user.empNo;            // 신청자 사번 설정(대리신청 ,본인 신청)

                Logger.debug.println(this, "급여계좌 수정 : " + a14BankStockFeeData.toString());

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
                    appLine.APPL_BEGDA     = a14BankStockFeeData.BEGDA;
                    appLine.APPL_AINF_SEQN = AINF_SEQN;
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
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(AINF_SEQN);

                    appDB.change(AppLineData_vt);
                    Vector ret =  rfc.change( firstData.PERNR, AINF_SEQN, bankflag, a14BankStockFeeData );
                     
                    A14BankMessageData a14BankMessageData = new A14BankMessageData();  //return message

                    a14BankMessageData = (A14BankMessageData)ret.get(0); 

                	if(a14BankMessageData.CODE.equals("S")){
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
	
	                        ptMailBody.setProperty("UPMU_NAME" ,"급여계좌");            // 문서 이름
	                        ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);             // 신청서 순번
	
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
	                            ElofficInterfaceData eof = ddfe.makeDocForChange(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") ,oldAppLine.APPL_PERNR);
	                            Vector vcElofficInterfaceData = new Vector();
	                            vcElofficInterfaceData.add(eof);
	
	                            ElofficInterfaceData eofD = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
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

                    	con.rollback();                    	
                        msg = a14BankMessageData.MESSAGE; 
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if
                    
                } else {
                    msg = "msg005";
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if
*/
               
               

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, "destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
//            DBUtil.close(con);
//            if (con != null) try {con.close();} catch (Exception e){
//                Logger.debug.println(this, "finally   "+e  );
//                Logger.err.println(e, e);
//            }
        }
    }
}
