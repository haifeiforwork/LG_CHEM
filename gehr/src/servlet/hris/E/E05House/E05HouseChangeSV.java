/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ� �űԽ�û                                           */
/*   Program Name : �����ڱ� ��û ����                                          */
/*   Program ID   : E05HouseChangeSV                                            */
/*   Description  : �����ڱݿ� ���� ��û�� �����Ҽ� �ֵ��� �ϴ� Class           */
/*   Note         :                                                             */
/*   Creation     : 2001-12-13  �輺��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*   update : 2014/05/16 ������  CSRID : 2545905      persk(�ð������� �ο��� ���� ���� �߰�)    */
/*                2015/07/31 [CSR ID:2834377] �����ڱ� ���״��� ���� �ý��� ��������                                                                           */
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

	private String UPMU_TYPE = "12";     // ���� ����Ÿ��(���� �ڱ� )
    private String UPMU_NAME = "�����ڱ�";

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
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //��û����� ���

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
			String AINF_SEQN = box.get("AINF_SEQN");

            E05HouseData firstData = new E05HouseData();
            E05HouseRFC  e05Rfc       = new E05HouseRFC();
            e05Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            Vector e05HouseData_vt = null;

            e05HouseData_vt = e05Rfc.detail( AINF_SEQN );

            firstData = (E05HouseData)e05HouseData_vt.get(0);
            Logger.debug.println(this, "e05HoueData_vt : " + e05HouseData_vt.toString());

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.

                E05PersInfoData E05PersInfoData    = null;
                Vector          E05MaxMoneyData_vt = null;
                //Object          R_GRNT_RSGN		   = null;

                E05HouseData e05HouseData = new E05HouseData();
                e05HouseData = (E05HouseData) e05HouseData_vt.get(0);

                // PersLoan - ZHRW_RFC_GET_INFTY_0045
                E05PersLoanRFC func3 = new E05PersLoanRFC();
				//R_GRNT_RSGN		= func4.getRetirementData(firstData.PERNR,DataUtil.getCurrentDate());

                Vector PersLoanData_vt 	  = func3.getPersLoan(firstData.PERNR);
                Vector IngPersLoanData_vt  = func3.getIngPersLoan(firstData.PERNR); // �� �������ΰ� C20110808_41085  .�������� ��û �ݾ�
                String  E_WERKS                = func3.getE_WERKS(firstData.PERNR);

                // E05PersInfoRFC ���ּ�, �ټӳ��
                E05PersInfoRFC func1 = new E05PersInfoRFC();
                E05PersInfoData = (E05PersInfoData)func1.getPersInfo(firstData.PERNR);

                // �����ѵ� ���
                E05MaxMoneyData_vt = getMaxMoney(E05PersInfoData, user.companyCode, phonenumdata.E_PERSK);

//              2010.10.29 �����ڱ� ���� Ƚ��
                //2015/07/02 ������ �������� �ش��� ������ 1���̶� ������ �޾Ҵ� ���� ������ �߰� 1ȸ ����
                //�ѹ��� ���� �ʾ����� ���� ���� �� �߰�����(2ȸ) ����
                //������ ���� ���� ���� �ִ��� Ȯ���Ͽ�(l_sysda_YN) �ְ� l_sysda ���Ŀ� ������� ���� �ִ����� ������ ���� ��û�� �����Ѵ�.
                int      l_count = 0;
                String  l_sysda_YN = "N";  // 15�� 7�� 2�� ���� �������� //[CSR ID:2834377]
                String  addLoan_YN = "N";  // 15�� 7�� 2�� ���� �������� //[CSR ID:2834377]
                long    l_begda = 0;
                long    l_sysda = 0;
                double Old_DARBT = 0; //��������ݾ�
                for ( int i = 0 ; i < PersLoanData_vt.size() ; i++ ) {
                    E05PersLoanData persLoanData = (E05PersLoanData)PersLoanData_vt.get(i);
                    l_begda = Long.parseLong(DataUtil.removeStructur(persLoanData.BEGDA, "-"));
//                  l_sysda = Long.parseLong("20050601");[CSR ID:2834377]
                    l_sysda = Long.parseLong("20150702");
                    if( l_begda < l_sysda  ) {
                    	l_sysda_YN = "Y";//2015������ ������ ������.
                    }
                    if( l_begda > l_sysda  ) {
                    	addLoan_YN = "Y";//2015���Ŀ� ������ ������.
                    }
                    if (persLoanData.DLART.equals("0010")||persLoanData.DLART.equals("0020")  ){
                    	Old_DARBT = Old_DARBT + Double.parseDouble(persLoanData.DARBT)  ;
                    	if( l_begda > l_sysda  ) {
                    		l_count++;//l_sysda ���Ŀ� ���� ����
                    	}
                    }
                }
                Logger.debug.println(this, "@@l_count "+l_count+", l_sysda_YN:"+l_sysda_YN +", addLoan_YN:"+addLoan_YN );

                // 2010.10.29 �����ڱ� �߰� (���Դ��� �ִ��ѵ�)
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
                1. 2015/07/02 ������ 1ȸ �̻� ���������� ������ 2015/07/02 ���Ŀ� 1ȸ ����
                2. 2015/07/02 ������ ������ �ѹ��� ���� ���� ������ 2015/07/02 ���Ŀ� 2ȸ ����
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

                //�λ���������
                String E_BTRTL = (new D03VocationAReasonRFC()).getE_BTRTL(phonenumdata.E_BUKRS, firstData.PERNR, "2005", DataUtil.getCurrentDate());

                Vector E05FundCode_vt  = new E05FundCodeRFC().getFundCode();

                // �޿����� ����Ʈ�� �����Ѵ�.@v1.0
                E05HouseBankCodeRFC  rfc_bank    = new E05HouseBankCodeRFC();
                Vector          e05BankCodeData_vt = rfc_bank.getBankCode();
               // Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                req.setAttribute("isUpdate", true); //��� ���� ����

                req.setAttribute("E05PersInfoData",    E05PersInfoData);
                req.setAttribute("e05HouseData",    e05HouseData);
                req.setAttribute("resultData", e05HouseData);
                req.setAttribute("E05MaxMoneyData_vt", E05MaxMoneyData_vt);
                req.setAttribute("PersLoanData_vt",    PersLoanData_vt);
                req.setAttribute("IngPersLoanData_vt",    IngPersLoanData_vt); //�� �������ΰ� C20110808_41085
                req.setAttribute("E_WERKS",            E_WERKS);
				//req.setAttribute("R_GRNT_RSGN",		   R_GRNT_RSGN);
                req.setAttribute("e05BankCodeData_vt", e05BankCodeData_vt); //@v.1.0
                req.setAttribute("E05FundCode_vt", E05FundCode_vt);

                detailApporval(req, res, e05Rfc);

				printJspPage(req, res, WebUtil.JspURL + "E/E05House/E05HouseChange.jsp");

            } else if( jobid.equals("change") ) { // DB update �����κ�

            	/* ���� ��û �κ� */
				dest = changeApproval(req, box, E05HouseData.class, e05Rfc, new ChangeFunction<E05HouseData>(){

					public String porcess(E05HouseData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						inputData.MANDT  = user.clientNo;
						inputData.PERNR  = inputData.PERNR;
        				inputData.ZPERNR = inputData.ZPERNR;    // ��û�� ���(�븮��û, ���� ��û)
        				inputData.UNAME  = user.empNo;          // ������ ���(�븮��û, ���� ��û)
    	                inputData.AEDTM  = DataUtil.getCurrentDate();  // ������(���糯¥)

                    	box.put("I_GTYPE", "3");

                    	/* ���� ��û RFC ȣ�� */
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

                        /* ������ �ۼ� �κ� �� */
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

            Vector E05LoanMoneyData_vt = function.getLoanMoney(persk);//persk(�ð������� �ο��� ���� ���� �߰�)
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
