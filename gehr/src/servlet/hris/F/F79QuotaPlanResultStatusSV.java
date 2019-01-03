/******************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Quota Plan/Result Status
*   Program ID   		: F79QuotaPlanResultStatusSV.java
*   Description  		: ����/������ �ο���ȹ ��� ���� ��Ȳ ��ȸ�� ���� class (USA - LGCPI(G400))
*   Note         		: ����
*   Creation     		:
*   Update       : [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ 2017-07-07 eunha
******************************************************************************/

package servlet.hris.F;

import hris.F.F79QuotaPlanResultStatusData;
import hris.F.rfc.F79QuotaPlanResultStatusRFC;
import hris.common.WebUserData;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * F79QuotaPlanResultStatusSV
 * ����/������ �ο���ȹ ��� ���� ��Ȳ ������ �������� F79QuotaPlanResultStatusRFC�� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F79QuotaPlanResultStatusSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); 				// �μ��ڵ�
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N");		// �����μ�����
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); 			// excelDown
			String searchYear = WebUtil.nvl(req.getParameter("searchYear"));		// �ش� �⵵

			WebUserData user = WebUtil.getSessionUser(req);		                            //����

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			// �ʱ�ȭ�� ���½� ���� Year ����
			if (searchYear.equals("")) {
				searchYear = DataUtil.getCurrentYear();
			}

			String dest = "";
	        boolean E_RETURN  = false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

			F79QuotaPlanResultStatusRFC f79Rfc = null;
			Vector F79QuotaPlanResultStatusData_vt = null;

			// [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;
            //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end

			if (!deptId.equals("")) {
				f79Rfc = new F79QuotaPlanResultStatusRFC();
				F79QuotaPlanResultStatusData_vt = new Vector();

				Vector ret = f79Rfc.getQuotaPlanResultStatus(deptId, searchYear, checkYN, user.area.getMolga());

				E_RETURN = f79Rfc.getReturn().isSuccess();
            	E_MESSAGE = f79Rfc.getReturn().MSGTX;
				F79QuotaPlanResultStatusData_vt = (Vector) ret.get(0);
			}

			// RFC ȣ�� ������.
			if (E_RETURN ) {
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("F79QuotaPlanResultStatusData_vt", F79QuotaPlanResultStatusData_vt);
				req.setAttribute("metaNote", doWithData(F79QuotaPlanResultStatusData_vt));
				req.setAttribute("searchYear", searchYear);

				if (excelDown.equals("ED")) {	// ���������� ���.
					dest = WebUtil.JspURL + "F/F79QuotaPlanResultStatusExcel.jsp";

				} else {
					dest = WebUtil.JspURL + "F/F79QuotaPlanResultStatus.jsp";
				}

			// RFC ȣ�� ���н�.
			} else {
				req.setAttribute("msg", E_MESSAGE);
				req.setAttribute("url", "location.href = '" + WebUtil.JspURL+ "F/F79QuotaPlanResultStatus.jsp?checkYn=" + checkYN+ "';");

	        	throw new GeneralException(E_MESSAGE);
			}
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

	//calculate rowspan
	private List<HashMap<String, Integer>> doWithData(Vector deptServiceTitle_vt) {
		HashMap<String, Integer> tmp = new HashMap<String, Integer>();
		HashMap<String, Integer> tmp1 = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F79QuotaPlanResultStatusData entity = (F79QuotaPlanResultStatusData) deptServiceTitle_vt.get(i);

			if (tmp.containsKey(entity.ORGTX)) {
				Integer tmpStr = (Integer) tmp.get(entity.ORGTX);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.ORGTX, val);

			} else {
				tmp.put(entity.ORGTX, 1);
			}
			if (tmp1.containsKey(entity.ORGTX + entity.CTTXT)) {
				Integer tmpStr = (Integer) tmp1.get(entity.ORGTX + entity.CTTXT);
				int val = tmpStr.intValue() + 1;
				tmp1.put(entity.ORGTX + entity.CTTXT, val);
			} else {
				tmp1.put(entity.ORGTX + entity.CTTXT, 1);
			}
		}
		List<HashMap<String, Integer>> list = new ArrayList<HashMap<String, Integer>>();
		list.add(tmp);
		list.add(tmp1);
		return list;
	}

}
