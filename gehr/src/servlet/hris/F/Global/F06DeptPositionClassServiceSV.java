/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �ҼӺ�/���޺� ��ձټ�                                      */
/*   Program ID   : F06DeptPositionClassServiceSV                               */
/*   Description  : �ҼӺ�/���޺� ��ձټ� ��ȸ�� ���� ����                   */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-03 �����                                           */
/*   Update       : 2007-09-17  huang peng xiao                           */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.Global.F01DeptPositionClassTitleData;
import hris.F.Global.F06DeptPositionClassServiceTitleData;
import hris.F.rfc.Global.F06DeptPositionClassServiceRFC;
import hris.common.WebUserData;

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
 * F06DeptPositionClassServiceSV �μ��� ���� �ҼӺ�/���޺� ��ձټ� ������ ��������
 * F06DeptPositionClassServiceRFC �� ȣ���ϴ� ���� class
 *
 * @author �����
 * @version 1.0
 */
public class F06DeptPositionClassServiceSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
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
			String E_MESSAGE = "Failed to retrieve department information.";

			F06DeptPositionClassServiceRFC func = null;
			Vector F06DeptServiceTitle_vt = null;

			if (!deptId.equals("")) {
				func = new F06DeptPositionClassServiceRFC();
				F06DeptServiceTitle_vt = new Vector();
				Vector ret = func.getDeptPositionClassService(deptId, checkYN);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F06DeptServiceTitle_vt = (Vector) ret.get(2);
			}
			Vector result = dataFilter(F06DeptServiceTitle_vt);
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);
			HashMap meta = doWithData(F06DeptServiceTitle_vt);
			// RFC ȣ�� ������.
			// if (E_RETURN != null && E_RETURN.equals("S")) {
			req.setAttribute("checkYn", checkYN);
			req.setAttribute("F06DeptServiceTitle_vt", result);
			req.setAttribute("meta", meta);
			if (excelDown.equals("ED")) // ���������� ���.
				dest = WebUtil.JspURL
						+ "F/F06DeptPositionClassServiceExcel_Global.jsp";
			else
				dest = WebUtil.JspURL + "F/F06DeptPositionClassService_Global.jsp";

			// RFC ȣ�� ���н�.
			/*
			 * } else { String msg = E_MESSAGE; String url = "location.href = '" +
			 * WebUtil.JspURL + "F/F06DeptPositionClassService.jsp?checkYn=" +
			 * checkYN + "';"; req.setAttribute("msg", msg);
			 * req.setAttribute("url", url); dest = WebUtil.JspURL +
			 * "common/msg.jsp"; }
			 */

			Logger.debug.println(this, " destributed = " + dest);
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
		for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
			F06DeptPositionClassServiceTitleData entity = (F06DeptPositionClassServiceTitleData) deptPositionClassTitle_vt
					.get(i);
			if (entity.ZLEVEL == null || entity.ZLEVEL.equals("1")) {// ||
																		// entity.ZLEVEL.equals("2")){
				entity = (F06DeptPositionClassServiceTitleData) hris.common.util.AppUtil
						.initEntity(entity, "0", "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if (!flag) {
			ret = new Vector();
			for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
				F06DeptPositionClassServiceTitleData entity = (F06DeptPositionClassServiceTitleData) deptPositionClassTitle_vt
						.get(i);
				if (entity.ZLEVEL == null || entity.ZLEVEL.equals("2")) {// ||
																			// entity.ZLEVEL.equals("2")){
					entity = (F06DeptPositionClassServiceTitleData) hris.common.util.AppUtil
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
	//calculate rowspan
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F06DeptPositionClassServiceTitleData entity = (F06DeptPositionClassServiceTitleData) deptServiceTitle_vt
					.get(i);
			if (tmp.containsKey(entity.OBJID + entity.STEXT)) {
				Integer tmpStr = (Integer) tmp.get(entity.OBJID + entity.STEXT);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.OBJID + entity.STEXT, val);
			} else {
				tmp.put(entity.OBJID + entity.STEXT, 1);
			}
		}
		return tmp;
	}
}