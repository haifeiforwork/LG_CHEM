/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ� �űԽ�û                                           */
/*   Program Name : �����ڱ� ��û ��ȸ                                          */
/*   Program ID   : E05HouseDetailSV                                            */
/*   Description  : �����ڱݽ�û�� ���� �󼼳����� ��ȸ�� �� �ֵ��� �ϴ� Class  */
/*   Note         :                                                             */
/*   Creation     : 2001-12-13  �輺��                                          */
/*   Update       : 2005-03-04  ������                                          */
/*                  2005-11-04  @v1.2lsa :C2005102701000000578 :��û������߰�  */
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

	private String UPMU_TYPE = "12";     // ���� ����Ÿ��(���� �ڱ� )
    private String UPMU_NAME = "�����ڱ�";

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

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //��û����� ���
			String AINF_SEQN = box.get("AINF_SEQN");

            E05HouseData    firstData    = new E05HouseData();
            final E05HouseRFC      e05Rfc       = new E05HouseRFC();
            e05Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            Vector e05HouseData_vt  = null;

            e05HouseData_vt = e05Rfc.detail( AINF_SEQN );

            firstData = (E05HouseData)e05HouseData_vt.get(0);
            Logger.debug.println(this, "e05HoueData_vt : " + e05HouseData_vt.toString());

            // �븮 ��û �߰�
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

                // E05PersInfoRFC ���ּ�, �ټӳ��
                E05PersInfoRFC func1 = new E05PersInfoRFC();
                E05PersInfoData = (E05PersInfoData)func1.getPersInfo(firstData.PERNR);
                Logger.debug.println(this, "E05PersInfoData : "+ E05PersInfoData.toString());

             // �޿����� ����Ʈ�� �����Ѵ�.@v1.0
                E05HouseBankCodeRFC  rfc_bank    = new E05HouseBankCodeRFC();
                Vector          e05BankCodeData_vt = rfc_bank.getBankCode();/* [CSR ID:2097388] �޿����� ����Ʈ�� vector�� �޴´�*/

                Vector getLoanTypeList = new E05LoanCodeRFC().getLoanType();

                //�λ���������
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
                    //�Ƿ��(G006ApprovalHospitalSV)�� ���� ���� ���������, ���� �ΰ��� vector�� ������� ����
                    //Vector vcCheck = PreCheck.setApprovalStatutsList(ChKvcAppLineData ,"T_ZHRA006T" ,E21ExpenseData_vt ,"T_ZHRW005A" , E21ExpenseData_vt);
                    Vector vcCheck = PreCheck.setApprovalStatutsList(AINF_SEQN);

                    if ( vcCheck != null && vcCheck.size() > 0 ) {
                        ApprovalReturnState arsCheck = (ApprovalReturnState) vcCheck.get(0);
                        Logger.debug.println("arsCheck.E_RETURN:=="+arsCheck.E_RETURN);
                        req.setAttribute("E_COUPLEYN" ,arsCheck.E_RETURN);  //Y: �ð��� 4H(50%����), 6H(70%����)  Ȯ�� �޼��� ó��
                        req.setAttribute("E_MESSAGE"  ,arsCheck.E_MESSAGE);  //Y: �ð��� 4H(50%����), 6H(75%����) Ȯ�� �޼���
                    }else{
                        req.setAttribute("E_COUPLEYN"  ,"");  //Y: �ð��� 4H(50%����), 6H(75%����) �޼��� ó��
                        req.setAttribute("E_MESSAGE"  ,"");  //Y: �ð��� 4H(50%����), 6H(75%����) �޼���
                    }

                    E05PersLoanRFC func3 = new E05PersLoanRFC();

                    Vector E05MaxMoneyData_vt =  getMaxMoney(E05PersInfoData, user.companyCode, phonenumdata.E_PERSK);

                    Vector PersLoanData_vt 	  = func3.getPersLoan(firstData.PERNR);
                    Vector IngPersLoanData_vt  = func3.getIngPersLoan(firstData.PERNR); // �� �������ΰ� C20110808_41085  .�������� ��û �ݾ�

                    req.setAttribute("E05MaxMoneyData_vt", E05MaxMoneyData_vt);
                    req.setAttribute("PersLoanData_vt",    PersLoanData_vt);
                    req.setAttribute("IngPersLoanData_vt",    IngPersLoanData_vt); //�� �������ΰ� C20110808_41085

                }

                Vector A12Family_vt  = new A12FamilyRelationRFC().getFamilyRelation("");
                req.setAttribute("A12Family_vt", A12Family_vt);

                printJspPage(req, res, WebUtil.JspURL + "E/E05House/E05HouseDetail.jsp");

            } else if( jobid.equals("print_house") ) {  // v1.2��â���

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.E.E05House.E05HouseDetailSV?jobid=print&AINF_SEQN="+AINF_SEQN);
                Logger.debug.println(this, WebUtil.ServletURL+"hris.E.E05House.E05HouseDetailSV?jobid=print&AINF_SEQN="+AINF_SEQN);
                //dest = WebUtil.JspURL+"common/printFrame.jsp";

                printJspPage(req, res, WebUtil.JspURL + "common/printFrame.jsp");

            } else if( jobid.equals("print") ) {       // v1.2�����ڱ�������û��


                E05PersInfoData E05PersInfoData = null;

                // E05PersInfoRFC ���ּ�, �ټӳ��
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


