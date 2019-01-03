/******************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Job Family/Contract Type
*   Program ID   		: F78JobFamilyContractTypeSV.java
*   Description  		: ������ ��� ���� ��ȸ�� ���� class (USA)
*   Note         		: ����
*   Creation     		:
*   Update       : [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ 2017-07-07 eunha
******************************************************************************/

package servlet.hris.F;

import hris.F.F78JobFamilyContractTypeTitleData;
import hris.F.F78JobFamilyContractTypeNoteData;
import hris.F.rfc.F78JobFamilyContractTypeRFC;
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
 * F78JobFamilyContractTypeSV
 * ���� ���� ��� ���� ������ �������� F78JobFamilyContractTypeRFC�� ȣ���ϴ� ���� class
 *
 * @author jungin
 * @version 1.0 2010-10-25
 */
public class F78JobFamilyContractTypeSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); 				// �μ��ڵ�
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N");		// �����μ�����
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); 			// excelDown
			WebUserData user = WebUtil.getSessionUser(req);		                            //����

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
	        boolean E_RETURN  = false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

			F78JobFamilyContractTypeRFC f78Rfc = null;
			Vector F78JobFamilyContractTypeTitle_vt = null;
			Vector F78JobFamilyContractTypeNote_vt = null;

			// [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;
            //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end

			if (!deptId.equals("")) {
				f78Rfc = new F78JobFamilyContractTypeRFC();
				F78JobFamilyContractTypeTitle_vt = new Vector();
				F78JobFamilyContractTypeNote_vt = new Vector();

				Vector ret = f78Rfc.getDeptJobFamilyContractType(deptId,  DataUtil.getCurrentDate(), checkYN, user.area.getMolga());

				E_RETURN = f78Rfc.getReturn().isSuccess();
            	E_MESSAGE = f78Rfc.getReturn().MSGTX;
				F78JobFamilyContractTypeTitle_vt = (Vector) ret.get(0);
				F78JobFamilyContractTypeNote_vt = (Vector) ret.get(1);
			}

			// RFC ȣ�� ������.
			if ( E_RETURN ) {
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("F78JobFamilyContractTypeTitle_vt", F78JobFamilyContractTypeTitle_vt);
				req.setAttribute("F78JobFamilyContractTypeNote_vt", F78JobFamilyContractTypeNote_vt);
				req.setAttribute("metaTitle", doWithTitleData(F78JobFamilyContractTypeTitle_vt));
				req.setAttribute("metaNote", doWithData(F78JobFamilyContractTypeNote_vt));

				if (excelDown.equals("ED")) {	// ���������� ���.
					dest = WebUtil.JspURL + "F/F78JobFamilyContractTypeExcel.jsp";
				} else {
					dest = WebUtil.JspURL + "F/F78JobFamilyContractType.jsp";
				}
			// RFC ȣ�� ���н�.
			} else {
				req.setAttribute("msg", E_MESSAGE);
				req.setAttribute("url", "location.href = '" + WebUtil.JspURL+ "F/F78JobFamilyContractType.jsp?checkYn=" + checkYN+ "';");
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
			F78JobFamilyContractTypeNoteData entity = (F78JobFamilyContractTypeNoteData) deptServiceTitle_vt.get(i);
			if (tmp.containsKey(entity.PBTXT)) {
				Integer tmpStr = (Integer) tmp.get(entity.PBTXT);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.PBTXT, val);
			} else {
				tmp.put(entity.PBTXT, 1);
			}
			if (tmp1.containsKey(entity.PBTXT + entity.JIKGT)) {
				Integer tmpStr = (Integer) tmp1.get(entity.PBTXT + entity.JIKGT);
				int val = tmpStr.intValue() + 1;
				tmp1.put(entity.PBTXT + entity.JIKGT, val);
			} else {
				tmp1.put(entity.PBTXT + entity.JIKGT, 1);
			}
		}
		List<HashMap<String, Integer>> list = new ArrayList<HashMap<String, Integer>>();
		list.add(tmp);
		list.add(tmp1);
		return list;
	}

	private HashMap doWithTitleData(Vector deptServiceTitle_vt) {//calculate colspan
		HashMap tmp = new HashMap();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F78JobFamilyContractTypeTitleData entity = (F78JobFamilyContractTypeTitleData)deptServiceTitle_vt.get(i);

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
