/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 신규신청                                           */
/*   Program Name : 주택자금 신청 조회                                          */
/*   Program ID   : E05HouseDetailSV                                            */
/*   Description  : 주택자금신청에 대한 상세내용을 조회할 수 있도록 하는 Class  */
/*   Note         :                                                             */
/*   Creation     : 2001-12-13  김성일                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                  2005-11-04  @v1.2lsa :C2005102701000000578 :신청서출력추가  */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E05House;

import java.util.Vector;
import javax.servlet.http.*;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalBaseServlet.DeleteFunction;
import hris.common.rfc.PersonInfoRFC;

import hris.A.A12Family.rfc.A12FamilyRelationRFC;
import hris.D.D03Vocation.rfc.D03VocationAReasonRFC;
import hris.E.E05House.E05HouseData;
import hris.E.E05House.E05LoanMoneyData;
import hris.E.E05House.E05MaxMoneyData;
import hris.E.E05House.E05PersInfoData;
import hris.E.E05House.rfc.*;
import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalPreCheckRFC;

public class E05HouseDetailSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "12";     // 결재 업무타입(주택 자금 )
    private String UPMU_NAME = "주택자금";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException  {

        try{
        	HttpSession session = req.getSession(false);
			final WebUserData user = WebUtil.getSessionUser(req);

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //신청대상자 사번
			String AINF_SEQN = box.get("AINF_SEQN");

            E05HouseData    firstData    = new E05HouseData();
            final E05HouseRFC      e05Rfc       = new E05HouseRFC();
            e05Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            Vector e05HouseData_vt  = null;

            e05HouseData_vt = e05Rfc.detail( AINF_SEQN );

            firstData = (E05HouseData)e05HouseData_vt.get(0);
            Logger.debug.println(this, "e05HoueData_vt : " + e05HouseData_vt.toString());

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            String RequestPageName2 = box.get("RequestPageName");
            req.setAttribute("RequestPageName2", RequestPageName2);

            //Logger.debug.println(this, "E05HouseDetailSV==>PersonData : "+ phonenumdata.toString());

            if( jobid.equals("first") ) {

                E05PersInfoData E05PersInfoData = null;

                E05HouseData e05HouseData = new E05HouseData();
                e05HouseData = (E05HouseData) e05HouseData_vt.get(0);

                // E05PersInfoRFC 현주소, 근속년수
                E05PersInfoRFC func1 = new E05PersInfoRFC();
                E05PersInfoData = (E05PersInfoData)func1.getPersInfo(firstData.PERNR);
                Logger.debug.println(this, "E05PersInfoData : "+ E05PersInfoData.toString());

             // 급여계좌 리스트를 구성한다.@v1.0
                E05HouseBankCodeRFC  rfc_bank    = new E05HouseBankCodeRFC();
                Vector          e05BankCodeData_vt = rfc_bank.getBankCode();/* [CSR ID:2097388] 급여계좌 리스트를 vector로 받는다*/

                Vector getLoanTypeList = new E05LoanCodeRFC().getLoanType();

                //인사하위영역
                String E_BTRTL = (new D03VocationAReasonRFC()).getE_BTRTL(phonenumdata.E_BUKRS,firstData.PERNR, "2005", DataUtil.getCurrentDate());

                Vector E05FundCode_vt  = new E05FundCodeRFC().getFundCode();

                req.setAttribute("E05PersInfoData", E05PersInfoData);
                //req.setAttribute("e05HouseData_vt", e05HouseData_vt);
                req.setAttribute("e05HouseData", e05HouseData);
                req.setAttribute("resultData", e05HouseData);
                req.setAttribute("e05BankCodeData_vt", e05BankCodeData_vt);
                req.setAttribute("getLoanTypeList", getLoanTypeList);
                req.setAttribute("E05FundCode_vt", E05FundCode_vt);

                req.setAttribute("E_BTRTL" , E_BTRTL );
                req.setAttribute("I_APGUB" , I_APGUB );

                if (!detailApporval(req, res, e05Rfc))
	                   return;

                ApprovalHeader approvalHeader = (ApprovalHeader) req.getAttribute("approvalHeader");
                if("X".equals(approvalHeader.ACCPFL)) {

                	G001ApprovalPreCheckRFC PreCheck = new G001ApprovalPreCheckRFC();
                    //의료비(G006ApprovalHospitalSV)를 보고 따라 만들었으나, 뒤의 두개의 vector는 사용하지 않음
                    //Vector vcCheck = PreCheck.setApprovalStatutsList(ChKvcAppLineData ,"T_ZHRA006T" ,E21ExpenseData_vt ,"T_ZHRW005A" , E21ExpenseData_vt);
                    Vector vcCheck = PreCheck.setApprovalStatutsList(AINF_SEQN);

                    if ( vcCheck != null && vcCheck.size() > 0 ) {
                        ApprovalReturnState arsCheck = (ApprovalReturnState) vcCheck.get(0);
                        Logger.debug.println("arsCheck.E_RETURN:=="+arsCheck.E_RETURN);
                        req.setAttribute("E_COUPLEYN" ,arsCheck.E_RETURN);  //Y: 시간제 4H(50%지급), 6H(70%지급)  확인 메세지 처리
                        req.setAttribute("E_MESSAGE"  ,arsCheck.E_MESSAGE);  //Y: 시간제 4H(50%지급), 6H(75%지급) 확인 메세지
                    }else{
                        req.setAttribute("E_COUPLEYN"  ,"");  //Y: 시간제 4H(50%지급), 6H(75%지급) 메세지 처리
                        req.setAttribute("E_MESSAGE"  ,"");  //Y: 시간제 4H(50%지급), 6H(75%지급) 메세지
                    }

                    E05PersLoanRFC func3 = new E05PersLoanRFC();

                    Vector E05MaxMoneyData_vt =  getMaxMoney(E05PersInfoData, user.companyCode, phonenumdata.E_PERSK);

                    Vector PersLoanData_vt 	  = func3.getPersLoan(firstData.PERNR);
                    Vector IngPersLoanData_vt  = func3.getIngPersLoan(firstData.PERNR); // ※ 진행중인건 C20110808_41085  .진행중인 신청 금액

                    req.setAttribute("E05MaxMoneyData_vt", E05MaxMoneyData_vt);
                    req.setAttribute("PersLoanData_vt",    PersLoanData_vt);
                    req.setAttribute("IngPersLoanData_vt",    IngPersLoanData_vt); //※ 진행중인건 C20110808_41085

                }

                Vector A12Family_vt  = new A12FamilyRelationRFC().getFamilyRelation("");
                req.setAttribute("A12Family_vt", A12Family_vt);

                printJspPage(req, res, WebUtil.JspURL + "E/E05House/E05HouseDetail.jsp");

            } else if( jobid.equals("print_house") ) {  // v1.2새창띠움

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.E.E05House.E05HouseDetailSV?jobid=print&AINF_SEQN="+AINF_SEQN);
                Logger.debug.println(this, WebUtil.ServletURL+"hris.E.E05House.E05HouseDetailSV?jobid=print&AINF_SEQN="+AINF_SEQN);
                //dest = WebUtil.JspURL+"common/printFrame.jsp";

                printJspPage(req, res, WebUtil.JspURL + "common/printFrame.jsp");

            } else if( jobid.equals("print") ) {       // v1.2주택자금지원신청서


                E05PersInfoData E05PersInfoData = null;

                // E05PersInfoRFC 현주소, 근속년수
                E05PersInfoRFC func1 = new E05PersInfoRFC();
                E05PersInfoData = (E05PersInfoData)func1.getPersInfo(firstData.PERNR);
                Logger.debug.println(this, "E05PersInfoData : "+ E05PersInfoData.toString());

                req.setAttribute("E05PersInfoData", E05PersInfoData);
                req.setAttribute("e05HouseData_vt", e05HouseData_vt);

                printJspPage(req, res, WebUtil.JspURL + "E/E05House/E05HousePrintpage.jsp");


            } else if( jobid.equals("delete") ) {

                String dest = deleteApproval(req, box, e05Rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E05HouseRFC deleteRFC = new E05HouseRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e05Rfc.getApprovalHeader().AINF_SEQN);
                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }
                        return true;
                    }
                });

				printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }

    private Vector getMaxMoney(E05PersInfoData pers, String companyCode, String persk) throws GeneralException {
        try {
            E05LoanMoneyRFC function  = new E05LoanMoneyRFC();
            Vector          ret       = new Vector();
            E05MaxMoneyData data = null;

            Vector E05LoanMoneyData_vt = function.getLoanMoney(persk);//persk(시간선택제 인원을 위한 조건 추가)
            E05LoanMoneyData money = (E05LoanMoneyData)E05LoanMoneyData_vt.get(0);

            String loanCode   = money.LOAN_CODE;
            int    years      = Integer.parseInt(pers.E_YEARS);
            double loan_money = 0;

            for( int i = 0; i < E05LoanMoneyData_vt.size(); i++) {
                money = (E05LoanMoneyData)E05LoanMoneyData_vt.get(i);
                if( !companyCode.equals(money.BUKRS) ) {
                    E05LoanMoneyData_vt.remove(i);
                    i--;
                }
            }

            for( int i = 0; i < E05LoanMoneyData_vt.size(); i++) {
                money = (E05LoanMoneyData)E05LoanMoneyData_vt.get(i);
                if( loanCode.equals(money.LOAN_CODE) ) {
                    if( years >= Integer.parseInt(money.MIN_YEAR) ) {
                        loan_money = Double.parseDouble(money.LOAN_MONY);
                    }
                } else {
                    data = new E05MaxMoneyData();
                    data.LOAN_CODE = loanCode;
                    data.LOAN_MONY = Double.toString(loan_money);
                    ret.addElement(data);

                    loanCode = money.LOAN_CODE;
                    loan_money = 0;
                    i--;
                }
            }

            data = new E05MaxMoneyData();
            data.LOAN_CODE = loanCode;
            data.LOAN_MONY = Double.toString(loan_money);
            ret.addElement(data);

            Logger.debug.println(this, "max money : " +  ret.toString() );
            return ret;

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}


