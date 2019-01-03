/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : ������/���޺� �ο���Ȳ                                      */
/*   Program ID   : F04DeptDutyClassSV                                          */
/*   Description  : ������/���޺� �ο���Ȳ ��ȸ�� ���� ����                   */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-02 �����                                           */
/*   Update       : 2007-09-27  huang peng xiao                               */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.Global.F04DeptDutyClassTitleData;
import hris.F.rfc.Global.F04DeptDutyClassRFC;
import hris.common.WebUserData;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F04DeptDutyClassSV �μ��� ���� ������/���޺� �ο���Ȳ ������ �������� F04DeptDutyClassRFC �� ȣ���ϴ�
 * ���� class
 *
 * @author �����
 * @version 1.0
 */
public class F04DeptDutyClassSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			HttpSession session = req.getSession(false);
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // �μ��ڵ�...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); // �����μ�����.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
			WebUserData user = (WebUserData) session.getAttribute("user"); // ����.

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "�μ� ������ �������µ� �����Ͽ����ϴ�.";

			F04DeptDutyClassRFC func = null;
			Vector F04DeptDutyClassTitle_vt = null;
			// Vector F04DeptDutyClassNote_vt = null;

			if (!deptId.equals("")) {
				func = new F04DeptDutyClassRFC();
				F04DeptDutyClassTitle_vt = new Vector();
				// F04DeptDutyClassNote_vt = new Vector();
				Vector ret = func.getDeptDutyClass(deptId, checkYN);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F04DeptDutyClassTitle_vt = (Vector) ret.get(2);
				// F04DeptDutyClassNote_vt = (Vector)ret.get(3);
			}
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);
			List<HashMap<String, Integer>> meta = doWithData(F04DeptDutyClassTitle_vt);

			// RFC ȣ�� ������.
			// if (E_RETURN != null && E_RETURN.equals("S")) {
			req.setAttribute("checkYn", checkYN);
			req.setAttribute("F04DeptDutyClassTitle_vt",
					F04DeptDutyClassTitle_vt);
			req.setAttribute("meta", meta);
			// req.setAttribute("F04DeptDutyClassNote_vt",
			// F04DeptDutyClassNote_vt);
			if (excelDown.equals("ED")) // ���������� ���.
				dest = WebUtil.JspURL + "F/F04DeptDutyClassExcel_Global.jsp";
			else
				dest = WebUtil.JspURL + "F/F04DeptDutyClass_Global.jsp";

			// Logger.debug.println(this, "F04DeptDutyClassNote_vt : "+
			// F04DeptDutyClassNote_vt.toString());
			// RFC ȣ�� ���н�.
			/*
			 * } else { String msg = ""; String url = "location.href = '" +
			 * WebUtil.JspURL + "F/F04DeptDutyClass.jsp?checkYn=" + checkYN +
			 * "';"; req.setAttribute("msg", msg); req.setAttribute("url", url);
			 * dest = WebUtil.JspURL + "common/msg.jsp"; }
			 */

			Logger.debug.println(this, " destributed = " + dest);
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
			F04DeptDutyClassTitleData entity = (F04DeptDutyClassTitleData) deptServiceTitle_vt
					.get(i);
			if (tmp.containsKey(entity.PBTXT)) {
				Integer tmpStr = (Integer) tmp.get(entity.PBTXT);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.PBTXT, val);
			} else {
				tmp.put(entity.PBTXT, 1);
			}
			if (tmp1.containsKey(entity.PBTXT + entity.JIKGT)) {
				Integer tmpStr = (Integer) tmp1
						.get(entity.PBTXT + entity.JIKGT);
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

}