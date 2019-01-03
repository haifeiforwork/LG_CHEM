/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : ���б�/���ڱ�  ��û                                         */
/*   Program ID   : G015ApprovalExpenseSV                                       */
/*   Description  : ���б�/���ڱ� ���� ����� ,���μ��� ����/�ݷ�             */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.Global.E21Expense.E21ExpenseData;
import hris.E.Global.E21Expense.rfc.E21ExpenseRFC;

import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ApprovalFunction;
import hris.common.rfc.CurrencyChangeRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G015ApprovalExpenseGlobalSV extends ApprovalBaseServlet{

	private String UPMU_TYPE = "12"; // ���� ����Ÿ��(���ڱ�/���б�- ����� )
	private String UPMU_NAME = "Tuition Fee";

	protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
        	HttpSession session = req.getSession(false);

            final WebUserData user  = (WebUserData)session.getAttribute("user");
            final Box box = WebUtil.getBox(req);

            String dest	= "";

            String jobid	= box.get("jobid");
			String AINF_SEQN  = box.get("AINF_SEQN");

			String PERNR = box.get("APPL_PERNR");
			Logger.debug.println(this, "#####	PERNR PERNR**===" + PERNR );
	        //box.put("PERNR", PERNR);

			final E21ExpenseData e21ExpenseData;
            Vector         vcE21ExpenseData;
            E21ExpenseRFC  e21Rfc =  new E21ExpenseRFC();

            e21Rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            vcE21ExpenseData = e21Rfc.detail(PERNR, AINF_SEQN);

            //Logger.debug.println(this, "#####	vcE21ExpenseData**===" + vcE21ExpenseData );

            e21ExpenseData = (E21ExpenseData) vcE21ExpenseData.get(0);

            /* ���� �� */
            if("A".equals(jobid)) {

                /* ������ ���� �� */
                dest = accept(req, box, "T_ZHR0039T", e21ExpenseData, e21Rfc, new ApprovalFunction<E21ExpenseData>() {
                    public boolean porcess(E21ExpenseData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* ������ ���� ���� */
                        //if(approvalHeader.isEditManagerArea()) {

                            box.copyToEntity(inputData);  //����ڰ� �Է��� ����Ÿ�� ������Ʈ
                            inputData.UNAME			= user.empNo;
                            inputData.AEDTM   		= DataUtil.getCurrentDate();
                            inputData.PDATE     =  DataUtil.getCurrentDate();
                            inputData.REIM_AMT  = box.get("SCHL_TEXT");
                            inputData.OBJPS = box.get("OBJPS");

                            CurrencyChangeRFC rfc2 = new CurrencyChangeRFC();

                            inputData.CERT_BETG_C = rfc2.getCurrencyChange(inputData.WAERS, inputData.REIM_WAERS, inputData.CERT_BETG);
                            inputData.REIM_AMTH = Double.toString(Double.parseDouble(inputData.REIM_AMTH)+Double.parseDouble(inputData.CERT_BETG_C));

                           // Logger.debug.println(this, "#####	inputData CERT_BETG**===" + inputData.CERT_BETG );
                           // Logger.debug.println(this, "#####	inputData**===" + inputData );

                        //}

                        return true;
                    }
                });
            /* �ݷ��� */
            } else if("R".equals(jobid)) {

            	dest = reject(req, box, null, e21ExpenseData, e21Rfc, null);

            } else if("C".equals(jobid)) {

            	dest = cancel(req, box, null, e21ExpenseData, e21Rfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {

        }
	}
}