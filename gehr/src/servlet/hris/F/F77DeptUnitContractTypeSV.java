/******************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Unit/Contract Type
*   Program ID   		: F77DeptUnitContractTypeSV.java
*   Description  		: �μ��� ��� ���� ��ȸ�� ���� class (USA)
*   Note         		: ����
*   Creation     		:
*   Update       : [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ 2017-07-07 eunha
******************************************************************************/

package servlet.hris.F;

import hris.F.F77DeptUnitContractTypeTitleData;
import hris.F.F77DeptUnitContractTypeNoteData;
import hris.F.rfc.F77DeptUnitContractTypeRFC;
import hris.common.WebUserData;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * F77DeptUnitContractTypeSV
 * �μ��� ���� ��� ���� ������ �������� F77DeptUnitContractTypeSV ȣ���ϴ� ���� class
 * @version 1.0
 */
public class F77DeptUnitContractTypeSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId"));				// �μ��ڵ�
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N");		// �����μ�����
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); 			// excelDown
			WebUserData user = WebUtil.getSessionUser(req);		                            //����

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
			boolean E_RETURN = false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

			F77DeptUnitContractTypeRFC f77Rfc = null;
	        Vector F77DeptUnitContractTypeTitle_vt= null;
	        Vector F77DeptUnitContractTypeNote_vt = null;

			// [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;
            //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end

            if (!deptId.equals("")) {
				f77Rfc = new F77DeptUnitContractTypeRFC();
				F77DeptUnitContractTypeTitle_vt = new Vector();
				F77DeptUnitContractTypeNote_vt = new Vector();

				Vector ret = f77Rfc.getDeptUnitContractType(deptId, DataUtil.getCurrentDate(), checkYN, user.area.getMolga());

				E_RETURN = f77Rfc.getReturn().isSuccess();
            	E_MESSAGE = f77Rfc.getReturn().MSGTX;

				F77DeptUnitContractTypeTitle_vt = (Vector) ret.get(0);
				F77DeptUnitContractTypeNote_vt = (Vector) ret.get(1);
			}

			// RFC ȣ�� ������.
			if ( E_RETURN ) {
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("F77DeptUnitContractTypeTitle_vt", F77DeptUnitContractTypeTitle_vt);
				req.setAttribute("F77DeptUnitContractTypeNote_vt", dataFilter(F77DeptUnitContractTypeNote_vt));
				req.setAttribute("meta", doWithData(F77DeptUnitContractTypeTitle_vt));

				if (excelDown.equals("ED")) {	// ���������� ���.
					dest = WebUtil.JspURL + "F/F77DeptUnitContractTypeExcel.jsp";
				} else {
					dest = WebUtil.JspURL + "F/F77DeptUnitContractType.jsp";
				}
			// RFC ȣ�� ���н�.
			} else {
				String msg = E_MESSAGE;
				String url = "location.href = '" + WebUtil.JspURL+ "F/F77DeptUnitContractType.jsp?checkYn=" + checkYN+ "';";

				req.setAttribute("msg", msg);
				req.setAttribute("url", url);

	        	throw new GeneralException(E_MESSAGE);
			}
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

	/**
	 * @param deptPositionClassTitle_vt
	 * if ZLEVEL is 2 or null, clear data
	 * @return
	 */
	private Vector dataFilter(Vector deptPositionClassTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for(int i = 0 ; i < deptPositionClassTitle_vt.size() ; i ++){
			F77DeptUnitContractTypeNoteData entity = (F77DeptUnitContractTypeNoteData) deptPositionClassTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){// || entity.ZLEVEL.equals("2")){
				entity = (F77DeptUnitContractTypeNoteData)hris.common.util.AppUtilEurp.initEntity(entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < deptPositionClassTitle_vt.size() ; i++) {
				F77DeptUnitContractTypeNoteData entity = (F77DeptUnitContractTypeNoteData) deptPositionClassTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){// || entity.ZLEVEL.equals("2")){
					entity = (F77DeptUnitContractTypeNoteData)hris.common.util.AppUtilEurp.initEntity(entity , "0" , "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}

	private HashMap doWithData(Vector deptServiceTitle_vt) {//calculate colspan
		HashMap tmp = new HashMap();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F77DeptUnitContractTypeTitleData entity = (F77DeptUnitContractTypeTitleData) deptServiceTitle_vt.get(i);

			if (tmp.containsKey(entity.CLSFY)) {
				Integer tmpStr = (Integer) tmp.get(entity.CLSFY);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.CLSFY, val);
			} else {
				tmp.put(entity.CLSFY, 1);
			}
		}
		return tmp;
	}

}
