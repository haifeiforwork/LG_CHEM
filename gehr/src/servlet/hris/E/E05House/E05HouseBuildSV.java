/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 신규신청                                           */
/*   Program Name : 주택자금 신규신청                                           */
/*   Program ID   : E05HouseBuildSV                                             */
/*   Description  : 주택자금 신청을 할수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2001-12-13  김성일                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*   update : 2014/05/16 이지은  CSRID : 2545905      persk(시간선택제 인원을 위한 조건 추가)    */
/*               2015/07/31 [CSR ID:2834377] 주택자금 차액대출 관련 시스템 조정사항                                                            */
/*               R_GRNT_RSGN 다음에 CSR 할 일 있을 때 삭제해야 함.*/
/********************************************************************************/

package servlet.hris.E.E05House;

import java.util.Vector;
import javax.servlet.http.*;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.rfc.*;
import hris.E.E05House.E05HouseData;
import hris.E.E05House.E05LoanMoneyData;
import hris.E.E05House.E05MaxMoneyData;
import hris.E.E05House.E05PersInfoData;
import hris.E.E05House.E05PersLoanData;
import hris.E.E05House.rfc.*;
import hris.D.D03Vocation.rfc.D03VocationAReasonRFC;

public class E05HouseBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "12";     // 결재 업무타입(주택 자금 )
    private String UPMU_NAME = "주택자금";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException  {

        try{
        	HttpSession session = req.getSession(false);

			final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR = getPERNR(box, user); //신청대상자 사번

			box.put("PERNR",PERNR);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {     //제일처음 신청 화면에 들어온경우.

            	//결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                E05PersInfoRFC         func1 = new E05PersInfoRFC();
                E05PersLoanRFC        func3 = new E05PersLoanRFC();
                //D15RetirementSimulRFC func4 = new D15RetirementSimulRFC();

                // 급여계좌 리스트를 구성한다.@v1.0
                E05HouseBankCodeRFC  rfc_bank    = new E05HouseBankCodeRFC();
                Vector          e05BankCodeData_vt = rfc_bank.getBankCode();/* [CSR ID:2097388] 급여계좌 리스트를 vector로 받는다*/

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );

                //PersLoan - ZHRW_RFC_GET_INFTY_0045

                Vector PersLoanData_vt 	  = func3.getPersLoan(PERNR);
                Vector IngPersLoanData_vt  = func3.getIngPersLoan(PERNR); // ※ 진행중인건 C20110808_41085  .진행중인 신청 금액
                String  E_WERKS                = func3.getE_WERKS(PERNR);
                //Object R_GRNT_RSGN          = func4.getRetirementData(PERNR,DataUtil.getCurrentDate()); // 미 사용으로 인한 주석 처리

                // E05PersInfoRFC 현주소, 근속년수
                E05PersInfoData E05PersInfoData = (E05PersInfoData)func1.getPersInfo(PERNR);
                Logger.debug.println(this, "E05PersInfoData : "+ E05PersInfoData.toString());

                Vector E05MaxMoneyData_vt = getMaxMoney(E05PersInfoData, user.companyCode, phonenumdata.E_PERSK);//persk(시간선택제 인원을 위한 조건 추가)
                Logger.debug.println(this, "E05MaxMoneyData_vt : "+ E05MaxMoneyData_vt.toString());

                //인사하위영역
                String E_BTRTL = (new D03VocationAReasonRFC()).getE_BTRTL(phonenumdata.E_BUKRS,PERNR, "2005", DataUtil.getCurrentDate());
                req.setAttribute("E_BTRTL" , E_BTRTL );

                // 2010.10.29 주택자금 대출 횟수
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
                    //l_sysda = Long.parseLong("20050601");[CSR ID:2834377]
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
                Logger.debug.println(this, "==l_count "+l_count +"Loan_Max0010 "+Loan_Max0010+ "Old_DARBT:"+Old_DARBT);

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

                Vector getLoanTypeList = new E05LoanCodeRFC().getLoanType();
                req.setAttribute("getLoanTypeList", getLoanTypeList);

                Vector vcCodeData = new Vector();

                for ( int i = 0 ; i < getLoanTypeList.size() ; i++ ) {
                      com.sns.jdf.util.CodeEntity dataC = (com.sns.jdf.util.CodeEntity)getLoanTypeList.get(i);
                      vcCodeData.add(dataC);
                }

                req.setAttribute("vcCodeData", vcCodeData);

                Vector E05FundCode_vt  = new E05FundCodeRFC().getFundCode();
                req.setAttribute("E05FundCode_vt", E05FundCode_vt);

                //Logger.debug.println(this, "==E05FundCode_vt ================ "+E05FundCode_vt.toString() );
                //Logger.debug.println(this, "==E05MaxMoneyData_vt ================ "+E05MaxMoneyData_vt.toString() );
                //Logger.debug.println(this, "==PersLoanData_vt ================ "+PersLoanData_vt.toString() );

                req.setAttribute("FLAG",   FLAG);
                req.setAttribute("E05PersInfoData",    E05PersInfoData);
                req.setAttribute("E05MaxMoneyData_vt", E05MaxMoneyData_vt);
                req.setAttribute("PersLoanData_vt",    PersLoanData_vt);
                req.setAttribute("IngPersLoanData_vt",    IngPersLoanData_vt); //※ 진행중인건 C20110808_41085
                req.setAttribute("E_WERKS",            E_WERKS);
                //req.setAttribute("R_GRNT_RSGN",        R_GRNT_RSGN);
                req.setAttribute("e05BankCodeData_vt", e05BankCodeData_vt);

                dest = WebUtil.JspURL+"E/E05House/E05HouseBuild.jsp";

            } else if( jobid.equals("create") ) {

            	/* 실제 신청 부분 */
                dest = requestApproval(req, box, E05HouseData.class, new RequestFunction<E05HouseData>() {
                    public String porcess(E05HouseData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                    	 /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ******************/
                        AccountInfoRFC accountInfoRFC = new AccountInfoRFC();

                        if(!accountInfoRFC.hasPersAccount(box.get("PERNR")) ) {
                       	   throw new GeneralException(g.getMessage("MSG.COMMON.0006"));
                       }
                        /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ******************/

                        /* 결재 신청 RFC 호출 */
                        E05HouseRFC e05Rfc = new E05HouseRFC();
                        e05Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                        inputData.MANDT     = user.clientNo;
                       // inputData.PERNR     = PERNR;
                        inputData.ZPERNR    = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.UNAME     = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.AEDTM     = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                    	//Logger.debug.println(this,"====inputData==="+ inputData.toString());

        				box.put("I_GTYPE", "2");  // insert

                        // rfc.build( ainf_seqn , houseData_vt );
                        String AINF_SEQN = e05Rfc.build(Utils.asVector(inputData), box, req);

                        if(!e05Rfc.getReturn().isSuccess()) {
                        	 throw new GeneralException(e05Rfc.getReturn().MSGTX);
                        }
                        return AINF_SEQN;

                        /* 개발자 작성 부분 끝 */
                    }
                });

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }

    /**
     * 주택융자한도금액에 관한 일반정보를 가져오는 method
     * @param java.lang.Object hris.E.E05House E05PersInfoData
     * @param java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     * @CSRID : 2545905 이지은  persk(시간선택제 인원을 위한 조건 추가)
     */
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
