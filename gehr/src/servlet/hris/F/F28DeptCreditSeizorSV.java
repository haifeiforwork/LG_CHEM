/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� ä�� �з���
*   Program ID   : F28DeptCreditSeizorSV
*   Description  : �μ��� ä�� �з��� ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F26DeptExperiencedEmpData;
import hris.F.F26DeptExperiencedEmpGlobalData;
import hris.F.F28DeptCreditSeizorData;
import hris.F.rfc.F28DeptCreditSeizorRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Vector;

/**
 * F28DeptCreditSeizorSV
 * �μ��� ���� ��ü �μ����� ä�� �з��� ������ ��������
 * F28DeptCreditSeizorRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F28DeptCreditSeizorSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException{
    	try{
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user = WebUtil.getSessionUser(req);

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }

	        String dest    		= "";
	        boolean RfcSuccess  	= false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */

           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;

	        F28DeptCreditSeizorRFC f28Rfc = null;
	        Vector DeptCreditSeizor_vt  = null;

	        if ( !deptId.equals("") ) {
	        	f28Rfc       = new F28DeptCreditSeizorRFC();
	        	DeptCreditSeizor_vt  = new Vector();
	            Vector ret = f28Rfc.getDeptLegalAssignment(deptId, checkYN);

	            RfcSuccess   = f28Rfc.getReturn().isSuccess();
            	E_MESSAGE = f28Rfc.getReturn().MSGTX;
	            DeptCreditSeizor_vt = (Vector)ret.get(0);
	        }

	        //RFC ȣ�� ������.
	        if( RfcSuccess ){
	        	req.setAttribute("checkYn", checkYN);
		        req.setAttribute("DeptCreditSeizor_vt", DeptCreditSeizor_vt);

				HashMap<String, Integer> empCnt = new HashMap<String, Integer>();
				int cnt = 0;
				String oldPer = "";

				for (int i = 0; i < DeptCreditSeizor_vt.size(); i++) {
					F28DeptCreditSeizorData data = (F28DeptCreditSeizorData) DeptCreditSeizor_vt.get(i);
					if (oldPer.equals(data.PERNR) || (i == 0)) {
						cnt++;
					} else {
						empCnt.put(oldPer, cnt);
						cnt = 1;
					}
					if (i == DeptCreditSeizor_vt.size() - 1) {
						empCnt.put(data.PERNR, cnt);
					}
					oldPer = data.PERNR;
				}
				req.setAttribute("empCnt1", empCnt);

		        if( excelDown.equals("ED") ){ //���������� ���.
		            dest = WebUtil.JspURL+"F/F28DeptCreditSeizorExcel.jsp";
		        }else{
		        	dest = WebUtil.JspURL+"F/F28DeptCreditSeizor.jsp";
		        }
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}