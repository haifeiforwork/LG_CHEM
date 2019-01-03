/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 신규신청                                           */
/*   Program Name : 주택자금 신청 수정                                          */
/*   Program ID   : E05HouseChangeSV                                            */
/*   Description  : 주택자금에 대한 신청을 수정할수 있도록 하는 Class           */
/*   Note         :                                                             */
/*   Creation     : 2001-12-13  김성일                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*   update : 2014/05/16 이지은  CSRID : 2545905      persk(시간선택제 인원을 위한 조건 추가)    */
/*                2015/07/31 [CSR ID:2834377] 주택자금 차액대출 관련 시스템 조정사항                                                                           */
/********************************************************************************/

package servlet.hris.E.E05House;

import hris.D.D03Vocation.rfc.D03VocationAReasonRFC;
import hris.E.E05House.E05HouseData;
import hris.E.E05House.E05LoanMoneyData;
import hris.E.E05House.E05MaxMoneyData;
import hris.E.E05House.E05PersInfoData;
import hris.E.E05House.E05PersLoanData;
import hris.E.E05House.rfc.E05FundCodeRFC;
import hris.E.E05House.rfc.E05HouseBankCodeRFC;
import hris.E.E05House.rfc.E05HouseRFC;
import hris.E.E05House.rfc.E05LoanCodeRFC;
import hris.E.E05House.rfc.E05LoanMoneyRFC;
import hris.E.E05House.rfc.E05PersInfoRFC;
import hris.E.E05House.rfc.E05PersLoanRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;

import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E05HouseChangeSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "12";     // 결재 업무타입(주택 자금 )
    private String UPMU_NAME = "주택자금";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{

        	HttpSession session = req.getSession(false);
        	final WebUserData user = WebUtil.getSessionUser(req);
			final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //신청대상자 사번

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
			String AINF_SEQN = box.get("AINF_SEQN");

            E05HouseData firstData = new E05HouseData();
            E05HouseRFC  e05Rfc       = new E05HouseRFC();
            e05Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            Vector e05HouseData_vt = null;

            e05HouseData_vt = e05Rfc.detail( AINF_SEQN );

            firstData = (E05HouseData)e05HouseData_vt.get(0);
            Logger.debug.println(this, "e05HoueData_vt : " + e05HouseData_vt.toString());

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.

                E05PersInfoData E05PersInfoData    = null;
                Vector          E05MaxMoneyData_vt = null;
                //Object          R_GRNT_RSGN		   = null;

                E05HouseData e05HouseData = new E05HouseData();
                e05HouseData = (E05HouseData) e05HouseData_vt.get(0);

                // PersLoan - ZHRW_RFC_GET_INFTY_0045
                E05PersLoanRFC func3 = new E05PersLoanRFC();
				//R_GRNT_RSGN		= func4.getRetirementData(firstData.PERNR,DataUtil.getCurrentDate());

                Vector PersLoanData_vt 	  = func3.getPersLoan(firstData.PERNR);
                Vector IngPersLoanData_vt  = func3.getIngPersLoan(firstData.PERNR); // ※ 진행중인건 C20110808_41085  .진행중인 신청 금액
                String  E_WERKS                = func3.getE_WERKS(firstData.PERNR);

                // E05PersInfoRFC 현주소, 근속년수
                E05PersInfoRFC func1 = new E05PersInfoRFC();
                E05PersInfoData = (E05PersInfoData)func1.getPersInfo(firstData.PERNR);

                // 대출한도 계산
                E05MaxMoneyData_vt = getMaxMoney(E05PersInfoData, user.companyCode, phonenumdata.E_PERSK);

//              2010.10.29 주택자금 대출 횟수
                //2015/07/02 시점을 기준으로 해당일 이전에 1번이라도 대출을 받았던 적이 있으면 추가 1회 가능
                //한번도 받지 않았으면 최초 대출 및 추가대출(2회) 가능
                //이전에 대출 받은 적이 있는지 확인하여(l_sysda_YN) 있고 l_sysda 이후에 대출받은 적이 있는지를 가지고 대출 신청을 통제한다.
                int      l_count = 0;
                String  l_sysda_YN = "N";  // 15년 7월 2일 이전 대출유무 //[CSR ID:2834377]
                String  addLoan_YN = "N";  // 15년 7월 2일 이후 대출유무 //[CSR ID:2834377]
                long    l_begda = 0;
                long    l_sysda = 0;
                double Old_DARBT = 0; //기존대출금액
                for ( int i = 0 ; i < PersLoanData_vt.size() ; i++ ) {
                    E05PersLoanData persLoanData = (E05PersLoanData)PersLoanData_vt.get(i);
                    l_begda = Long.parseLong(DataUtil.removeStructur(persLoanData.BEGDA, "-"));
//                  l_sysda = Long.parseLong("20050601");[CSR ID:2834377]
                    l_sysda = Long.parseLong("20150702");
                    if( l_begda < l_sysda  ) {
                    	l_sysda_YN = "Y";//2015이전에 대출이 존재함.
                    }
                    if( l_begda > l_sysda  ) {
                    	addLoan_YN = "Y";//2015이후에 대출이 존재함.
                    }
                    if (persLoanData.DLART.equals("0010")||persLoanData.DLART.equals("0020")  ){
                    	Old_DARBT = Old_DARBT + Double.parseDouble(persLoanData.DARBT)  ;
                    	if( l_begda > l_sysda  ) {
                    		l_count++;//l_sysda 이후에 받은 대출
                    	}
                    }
                }
                Logger.debug.println(this, "@@l_count "+l_count+", l_sysda_YN:"+l_sysda_YN +", addLoan_YN:"+addLoan_YN );

                // 2010.10.29 주택자금 추가 (구입대출 최대한도)
                double Loan_Max0010 = 0;
                for ( int i = 0 ; i < E05MaxMoneyData_vt.size() ; i++ ) {
                    E05MaxMoneyData E05MaxMoneyData = (E05MaxMoneyData)E05MaxMoneyData_vt.get(i);
                    if (E05MaxMoneyData.LOAN_CODE.equals("0010") ){
                    	Loan_Max0010 = Loan_Max0010 + Double.parseDouble(E05MaxMoneyData.LOAN_MONY)  ;
                    }
                }
                Logger.debug.println(this, "l_count "+l_count +"Loan_Max0010 "+Loan_Max0010+ "Old_DARBT:"+Old_DARBT);

                String FLAG = "N";
                /*
                1. 2015/07/02 이전에 1회 이상 대출한적이 있으면 2015/07/02 이후에 1회 가능
                2. 2015/07/02 이전에 대출을 한번도 받은 적이 없으면 2015/07/02 이후에 2회 가능
                */
                if((Old_DARBT>=Loan_Max0010) || ( l_sysda_YN.equals("Y") && addLoan_YN.equals("Y") ) ) {
                    FLAG = "Y";
                } else if( (Old_DARBT>=Loan_Max0010) || ( l_sysda_YN.equals("N") && addLoan_YN.equals("Y") &&  l_count>1   )  ) {
                    FLAG = "Y";
                }
                req.setAttribute("FLAG",   FLAG);
                /////////////////////////////////////////////////////////////

                Vector getLoanTypeList = new E05LoanCodeRFC().getLoanType();
                req.setAttribute("getLoanTypeList", getLoanTypeList);

                //인사하위영역
                String E_BTRTL = (new D03VocationAReasonRFC()).getE_BTRTL(phonenumdata.E_BUKRS, firstData.PERNR, "2005", DataUtil.getCurrentDate());

                Vector E05FundCode_vt  = new E05FundCodeRFC().getFundCode();

                // 급여계좌 리스트를 구성한다.@v1.0
                E05HouseBankCodeRFC  rfc_bank    = new E05HouseBankCodeRFC();
                Vector          e05BankCodeData_vt = rfc_bank.getBankCode();
               // Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                req.setAttribute("isUpdate", true); //등록 수정 여부

                req.setAttribute("E05PersInfoData",    E05PersInfoData);
                req.setAttribute("e05HouseData",    e05HouseData);
                req.setAttribute("resultData", e05HouseData);
                req.setAttribute("E05MaxMoneyData_vt", E05MaxMoneyData_vt);
                req.setAttribute("PersLoanData_vt",    PersLoanData_vt);
                req.setAttribute("IngPersLoanData_vt",    IngPersLoanData_vt); //※ 진행중인건 C20110808_41085
                req.setAttribute("E_WERKS",            E_WERKS);
				//req.setAttribute("R_GRNT_RSGN",		   R_GRNT_RSGN);
                req.setAttribute("e05BankCodeData_vt", e05BankCodeData_vt); //@v.1.0
                req.setAttribute("E05FundCode_vt", E05FundCode_vt);

                detailApporval(req, res, e05Rfc);

				printJspPage(req, res, WebUtil.JspURL + "E/E05House/E05HouseChange.jsp");

            } else if( jobid.equals("change") ) { // DB update 로직부분

            	/* 실제 신청 부분 */
				dest = changeApproval(req, box, E05HouseData.class, e05Rfc, new ChangeFunction<E05HouseData>(){

					public String porcess(E05HouseData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						inputData.MANDT  = user.clientNo;
						inputData.PERNR  = inputData.PERNR;
        				inputData.ZPERNR = inputData.ZPERNR;    // 신청자 사번(대리신청, 본인 신청)
        				inputData.UNAME  = user.empNo;          // 수정자 사번(대리신청, 본인 신청)
    	                inputData.AEDTM  = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                    	box.put("I_GTYPE", "3");

                    	/* 결재 신청 RFC 호출 */
                    	E05HouseRFC changeRFC = new E05HouseRFC();
                		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);
                        //e05Rfc.change(AINF_SEQN, houseData_vt);

                    	//Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn().isSuccess() );
                        //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn() );

                        if(!changeRFC.getReturn().isSuccess()) {
                        	 throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }
                        return inputData.AINF_SEQN;

                        /* 개발자 작성 부분 끝 */
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
