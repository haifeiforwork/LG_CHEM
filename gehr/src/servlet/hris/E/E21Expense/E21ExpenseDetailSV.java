/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ�                                                    */
/*   Program Name : �����ڱ� ��ȸ                                               */
/*   Program ID   : E21ExpenseDetailSV                                          */
/*   Description  : ���ڱ�/���б� ��ȸ�� �� �ֵ��� �ϴ� Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �輺��                                          */
/*   Update       : 2005-03-01  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E21Expense;

import java.util.Vector;
import javax.servlet.http.*;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.CurrencyCodeRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalBaseServlet.DeleteFunction;
import hris.common.approval.ApprovalLineData;

import hris.E.E21Expense.E21ExpenseData;
import hris.E.E21Expense.rfc.*;
import hris.E.E22Expense.E22ExpenseListData;
import hris.E.E22Expense.rfc.E22ExpenseListRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalPreCheckRFC;
import hris.G.rfc.G001ApprovalProcessRFC;

public class E21ExpenseDetailSV extends ApprovalBaseServlet {

	private String UPMU_TYPE ="06";   // ���� ����Ÿ��(���ڱ�/���б�)
    private String UPMU_NAME = "�����ڱ�";

	protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
        	HttpSession session = req.getSession(false);
        	final WebUserData user = WebUtil.getSessionUser(req);

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //��û����� ���
			String AINF_SEQN = box.get("AINF_SEQN");

            //String dest  = "";
            String msgFLAG = "";
            String msgTEXT = "";

            final E21ExpenseRFC  e21Rfc        = new E21ExpenseRFC();
            E21ExpenseData firstData     = new E21ExpenseData();
            Vector         E21ExpenseData_vt = new Vector();

            e21Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            E21ExpenseData_vt = e21Rfc.detail(AINF_SEQN, "");

            //Logger.debug.println(this, "=====�����ڱ� ��ȸ  : " + E21ExpenseData_vt);

            firstData = (E21ExpenseData)E21ExpenseData_vt.get(0);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            String RequestPageName2 = box.get("RequestPageName");
            req.setAttribute("RequestPageName2", RequestPageName2);

            if( jobid.equals("first") ) {

                if( E21ExpenseData_vt.size() < 1 ){
                    msgFLAG = "C";
                    msgTEXT = "System Error! No Data.";
                }

                E21ExpenseData e21ExpenseData = new E21ExpenseData();
                e21ExpenseData = (E21ExpenseData)E21ExpenseData_vt.get(0);

                Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();

                req.setAttribute("msgFLAG", msgFLAG);
                req.setAttribute("msgTEXT", msgTEXT);
                req.setAttribute("e21ExpenseData" , e21ExpenseData);
                req.setAttribute("currency_vt" , currency_vt);
                req.setAttribute("resultData", e21ExpenseData);
                // req.setAttribute("e21ExpenseChkData" , e21ExpenseChkData);

                //Logger.debug.println(this, "=====resultData   : " +  req.getAttribute("resultData")   );

                if (!detailApporval(req, res, e21Rfc))
	                   return;

                ApprovalHeader approvalHeader = (ApprovalHeader) req.getAttribute("approvalHeader");

                if("X".equals(approvalHeader.ACCPFL)) {

                	Vector currencyCodeList = new CurrencyCodeRFC().getCurrencyCode();

                	Vector data_vt                = (new E22ExpenseListRFC()).getExpenseList( firstData.PERNR );
                    Vector data1_vt                = (new E22ExpenseListRFC()).getExpenseList1( firstData.PERNR );
                    Vector E22ExpenseListdata_vt = new Vector();
                    Vector E22ExpenseListDataFinish_vt = new Vector(); //����Ϸ�Ȱ͸�

                    E22ExpenseListData e22ExpenseListdata = new E22ExpenseListData();
                    for( int j = 0 ; j < data_vt.size() ; j++ ) {
                    	e22ExpenseListdata = (E22ExpenseListData)data_vt.get(j);
                    	E22ExpenseListdata_vt.addElement(e22ExpenseListdata);
                    	E22ExpenseListDataFinish_vt.addElement(e22ExpenseListdata);
                    }

                    for( int j = 0 ; j < data1_vt.size() ; j++ ) {
                    	e22ExpenseListdata = (E22ExpenseListData)data1_vt.get(j);
                    	E22ExpenseListdata_vt.addElement(e22ExpenseListdata);
                    }

                    req.setAttribute("E22ExpenseListDataFull_vt",   E22ExpenseListdata_vt);
                    req.setAttribute("E22ExpenseListDataFinish_vt",   E22ExpenseListDataFinish_vt);
                    req.setAttribute("currencyCodeList", currencyCodeList);

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

                    printJspPage(req, res, WebUtil.JspURL + "G/G015ApprovalExpense.jsp");
                } else {

                    printJspPage(req, res, WebUtil.JspURL + "E/E21Expense/E21ExpenseDetail.jsp");
                }

				//printJspPage(req, res, WebUtil.JspURL + "E/E21Expense/E21ExpenseDetail.jsp");

            } else if( jobid.equals("search") ) {

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.E.E21Expense.E21ExpenseDetailSV?jobid=print&AINF_SEQN="+AINF_SEQN );
                //dest = WebUtil.JspURL+"common/printFrame.jsp";

                printJspPage(req, res, WebUtil.JspURL+"common/printFrame.jsp");

                Logger.debug.println(this, WebUtil.ServletURL+"hris.E.E21Expense.E21ExpenseDetailSV?jobid=print&AINF_SEQN="+AINF_SEQN );

            } else if( jobid.equals("print") ) {
                E21ExpenseData e21ExpenseData = new E21ExpenseData();
                //AppLineData_vt = new Vector();

                if( E21ExpenseData_vt.size() < 1 ){
                    //String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    msgFLAG = "C";
                    msgTEXT = "System Error! ��ȸ�� �׸��� �����ϴ�.";
                }
                e21ExpenseData = (E21ExpenseData)E21ExpenseData_vt.get(0);

                // E21ExpenseChkData e21ExpenseChkData = getCountTable(firstData.PERNR, e21ExpenseData);

                //AppLineData_vt = AppUtil.getAppDetailVt(ainf_seqn);
                req.setAttribute("msgFLAG", msgFLAG);
                req.setAttribute("msgTEXT", msgTEXT);
                req.setAttribute("e21ExpenseData" , e21ExpenseData);
                // req.setAttribute("e21ExpenseChkData" , e21ExpenseChkData);

                //dest = WebUtil.JspURL+"E/E21Expense/E21ExpensePrint.jsp";

                printJspPage(req, res, WebUtil.JspURL+"E/E21Expense/E21ExpensePrint.jsp");

            } else if( jobid.equals("delete") ) {

            	String dest = deleteApproval(req, box, e21Rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E21ExpenseRFC deleteRFC = new E21ExpenseRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e21Rfc.getApprovalHeader().AINF_SEQN);
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

            //printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }
}