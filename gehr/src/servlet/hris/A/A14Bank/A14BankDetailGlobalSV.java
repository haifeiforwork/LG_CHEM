/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 급여계좌정보                                                */
/*   Program Name : 급여계좌 조회                                               */
/*   Program ID   : A14BankDetailSV                                             */
/*   Description  : 급여계좌를 조회할 수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A14Bank;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.A.A14Bank.A14BankStockFeeData;
import hris.A.A14Bank.rfc.A14BankCodeRFC;
import hris.A.A14Bank.rfc.A14BankStockFeeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

public class A14BankDetailGlobalSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="10";     // 결재 업무타입(급여)
    private String UPMU_NAME = "Salary Account ";

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
            final WebUserData user  = (WebUserData)session.getAttribute("user");

            String dest      = "";
            String jobid     = "";
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");
            
            
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            final A14BankStockFeeRFC   rfc       = new A14BankStockFeeRFC();
            //A14BankStockFeeData  firstData = new A14BankStockFeeData();
            
            A14BankCodeRFC rfc_bank = new A14BankCodeRFC();
            Vector a14BankValueData_vt = rfc_bank.getBankValue(user.empNo);
            
            Vector             a14BankStockFeeData_vt  = null;
           
            final String             ainf_seqn               = box.get("AINF_SEQN");
            final String bankflag = box.get("BNKSA");
            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn);
            a14BankStockFeeData_vt = rfc.getBankStockFee( "", ainf_seqn, bankflag );
            String PERNR = rfc.getApprovalHeader().PERNR;//box.get("PERNR", user.empNo);
            Logger.debug.println(this, "급여계좌 상세조회 : " + a14BankStockFeeData_vt.toString());

            final A14BankStockFeeData firstData = (A14BankStockFeeData)Utils.indexOf(a14BankStockFeeData_vt, 0);

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


            if( jobid.equals("first") ) {
                
                req.setAttribute("a14BankValueData_vt", a14BankValueData_vt);
                req.setAttribute("a14BankStockFeeData_vt", a14BankStockFeeData_vt);

                if (!detailApporval(req, res, rfc))                    return;

                dest = WebUtil.JspURL+"A/A14Bank/A14BankDetail_"+ (user.area == Area.KR ? "KR" : "Global") + ".jsp";

            } else if( jobid.equals("delete") ) {

                // 급여계좌 삭제..
                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	A14BankStockFeeRFC deleteRFC = new A14BankStockFeeRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete(firstData.PERNR, ainf_seqn, bankflag);

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });
            	/*
                AppLineData_vt = new Vector();

                // 결재정보 삭제..
                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = firstData.PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = ainf_seqn;

                // 2002.07.25.---------------------------------------------------------------------------
                // 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                // 결재
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // 같은 이름으로 여러행 받을때
                    box.copyToEntity(app ,i);

                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
                //              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                // 2002.07.25.---------------------------------------------------------------------------

                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);

                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    //String msg2 = rfc.delete( firstData.PERNR, ainf_seqn, bankflag  );
                    con.commit();

                    // 신청건 삭제시 메일 보내기.
                    appLine = (AppLineData)AppLineData_vt.get(0);
                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);              // ElOffice 접속 서버
                    ptMailBody.setProperty("from_empNo" ,user.empNo);            // 멜 발송자 사번
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // 멜 수신자 사번

                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (피)신청자명
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (피)신청자 사번

                    ptMailBody.setProperty("UPMU_NAME" ,"Bank Account Change");             // 문서 이름
                    ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);              // 신청서 순번
                    // 신청건 삭제시 메일 보내기.

                    // 멜 제목
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append( ptMailBody.getProperty("ename") + " deleted an application of " + ptMailBody.getProperty("UPMU_NAME") + ".");
                    ptMailBody.setProperty("subject" ,sbSubject.toString());    // 멜 제목 설정

                   ptMailBody.setProperty("FileName" ,"NoticeMail5.html");
                    
                   	// String msg2 = null;
                    
//                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
//
//                    if (!maTe.process()) {   
//                        msg2 = maTe.getMessage();
//                    } // end if
                    

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(ainf_seqn ,user.SServer ,ptMailBody.getProperty("UPMU_NAME") 
                                ,firstData.PERNR ,appLine.APPL_APPU_NUMB);
                        
                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface_Global.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        //msg2 = msg2 + "\\n" + " Eloffic Connection Failed." ;
                    } // end try
                    String msg = "msg003";
                    String url ;

                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.A.A03AccountDetailSV"+"?PERNR=" + firstData.PERNR + "';";
                    } // end if
                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);

                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A14Bank.A14BankDetailSV?AINF_SEQN="+ainf_seqn+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }
            	*/
            	
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));//내부명령(jobid)이 올바르지 않습니다.
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