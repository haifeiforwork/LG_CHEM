/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �ҼӺ�/���޺� �ο���Ȳ                                      */
/*   Program ID   : F01DeptPositionClassSV                                      */
/*   Description  : �ҼӺ�/���޺� �ο���Ȳ ��ȸ�� ���� ����                   */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-28 �����                                           */
/*   Update       : 2007-08-31  huang peng xiao                                       */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.Global.F01DeptPositionClassTitleData;
import hris.F.rfc.Global.F01DeptPositionClassRFC;
import hris.common.WebUserData;
import hris.common.util.AppUtil;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F01DeptPositionClassSV �μ��� ���� �ҼӺ�/���޺� �ο���Ȳ ������ �������� F01DeptPositionClassRFC ��
 * ȣ���ϴ� ���� class
 *
 * @author �����
 * @version 1.0
 */
public class F01DeptPositionClassSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			HttpSession session = req.getSession(false);
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // �μ��ڵ�...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), ""); // �����μ�����.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
			WebUserData user = (WebUserData) session.getAttribute("user"); // ����.

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "Failed to take the department infomation.";// �μ�
			// ������
			// �������µ�
			// �����Ͽ����ϴ�.

			F01DeptPositionClassRFC func = null;
			Vector F01DeptPositionClassTitle_vt = null;
			// Vector F01DeptPositionClassNote_vt = null;

			if (!deptId.equals("")) {
				func = new F01DeptPositionClassRFC();
				F01DeptPositionClassTitle_vt = new Vector();
				// F01DeptPositionClassNote_vt = new Vector();

				Vector ret = func.getDeptPositionClass(deptId, checkYN);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F01DeptPositionClassTitle_vt = (Vector) ret.get(2);
				// F01DeptPositionClassNote_vt = (Vector)ret.get(3);
			}
			Vector result = dataFilter(F01DeptPositionClassTitle_vt);
			HashMap meta = doWithData(F01DeptPositionClassTitle_vt);
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);

			// RFC ȣ�� ������.
			// if (E_RETURN != null && E_RETURN.equals("S")) {
			req.setAttribute("checkYn", checkYN);
			req.setAttribute("F01DeptPositionClassTitle_vt", result);
			// req.setAttribute("F01DeptPositionClassNote_vt",
			// F01DeptPositionClassNote_vt);
			if (excelDown.equals("ED")) // ���������� ���.
				dest = WebUtil.JspURL + "F/F01DeptPositionClassExcel_Global.jsp";
			else
				dest = WebUtil.JspURL + "F/F01DeptPositionClass_Global.jsp";

			// Logger.debug.println(this, "F01DeptPositionClassNote_vt : "+
			// F01DeptPositionClassNote_vt.toString());
			// RFC ȣ�� ���н�.
			/*
			 * } else { String msg = E_MESSAGE; String url = "location.href = '" +
			 * WebUtil.JspURL + "F/F01DeptPositionClass.jsp?checkYn=" + checkYN +
			 * "';"; req.setAttribute("msg2", msg); req.setAttribute("url",
			 * url); dest = WebUtil.JspURL + "common/msg.jsp"; }
			 */

			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

	/**
	 * @param deptPositionClassTitle_vt
	 * @return
	 */
	private Vector dataFilter(Vector deptPositionClassTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
			F01DeptPositionClassTitleData entity = (F01DeptPositionClassTitleData) deptPositionClassTitle_vt
					.get(i);
			if (entity.ZLEVEL == null || entity.ZLEVEL.equals("1")) {// ||
																		// entity.ZLEVEL.equals("2")){
				entity = (F01DeptPositionClassTitleData) hris.common.util.AppUtil
						.initEntity(entity, "0", "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if (!flag) {
			ret = new Vector();
			for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
				F01DeptPositionClassTitleData entity = (F01DeptPositionClassTitleData) deptPositionClassTitle_vt
						.get(i);
				if (entity.ZLEVEL == null || entity.ZLEVEL.equals("2")) {// ||
																			// entity.ZLEVEL.equals("2")){
					entity = (F01DeptPositionClassTitleData) hris.common.util.AppUtil
							.initEntity(entity, "0", "");
					// flag = true;
				}
				ret.addElement(entity);
			}
		}
		// ret.addElement(deptPositionClassTitle_vt.get(deptPositionClassTitle_vt.size()
		// - 1));
		return ret;
	}

	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F01DeptPositionClassTitleData entity = (F01DeptPositionClassTitleData) deptServiceTitle_vt
					.get(i);
			if (tmp.containsKey(entity.ORGTX + entity.ORGEH)) {
				Integer tmpStr = (Integer) tmp.get(entity.ORGTX + entity.ORGEH);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.ORGTX + entity.ORGEH, val);
			} else {
				tmp.put(entity.ORGTX + entity.ORGEH, 1);
			}
		}
		return tmp;
	}
}