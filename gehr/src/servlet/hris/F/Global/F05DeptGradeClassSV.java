/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : ��å��/���޺� �ο���Ȳ                                      */
/*   Program ID   : F05DeptGradeClassSV                                         */
/*   Description  : ��å��/���޺� �ο���Ȳ ��ȸ�� ���� ����                   */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-03 �����                                           */
/*   Update       : 2007-09-27  huang peng xiao                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.Global.F05DeptGradeClassTitleData;
import hris.F.rfc.Global.F05DeptGradeClassRFC;
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
 * F05DeptGradeClassSV �μ��� ���� ��å��/���޺� �ο���Ȳ ������ �������� F05DeptGradeClassRFC �� ȣ���ϴ�
 * ���� class
 *
 * @author �����
 * @version 1.0
 */
public class F05DeptGradeClassSV extends EHRBaseServlet {

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

			F05DeptGradeClassRFC func = null;
			Vector F05DeptGradeClassTitle_vt = null;
			// Vector F05DeptGradeClassNote_vt = null;

			if (!deptId.equals("")) {
				func = new F05DeptGradeClassRFC();
				F05DeptGradeClassTitle_vt = new Vector();
				// F05DeptGradeClassNote_vt = new Vector();
				Vector ret = func.getDeptGradeClass(deptId, checkYN);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F05DeptGradeClassTitle_vt = (Vector) ret.get(2);
				// F05DeptGradeClassNote_vt = (Vector)ret.get(3);
			}
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);
			HashMap meta = doWithData(F05DeptGradeClassTitle_vt);

			// RFC ȣ�� ������.
			// if (E_RETURN != null && E_RETURN.equals("S")) {
			req.setAttribute("checkYn", checkYN);
			req.setAttribute("F05DeptGradeClassTitle_vt",
					F05DeptGradeClassTitle_vt);
			req.setAttribute("meta", meta);
			// req.setAttribute("F05DeptGradeClassNote_vt",
			// F05DeptGradeClassNote_vt);
			if (excelDown.equals("ED")) // ���������� ���.
				dest = WebUtil.JspURL + "F/F05DeptGradeClassExcel_Global.jsp";
			else
				dest = WebUtil.JspURL + "F/F05DeptGradeClass_Global.jsp";

			// Logger.debug.println(this, "F05DeptGradeClassNote_vt : "+
			// F05DeptGradeClassNote_vt.toString());
			// RFC ȣ�� ���н�.
			/*
			 * } else { String msg = E_MESSAGE; String url = "location.href = '" +
			 * WebUtil.JspURL + "F/F05DeptGradeClass.jsp?checkYn=" + checkYN +
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
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap<String, Integer> tmp = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F05DeptGradeClassTitleData entity = (F05DeptGradeClassTitleData) deptServiceTitle_vt
					.get(i);
			if (tmp.containsKey(entity.PBTXT)) {
				Integer tmpStr = (Integer) tmp.get(entity.PBTXT);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.PBTXT, val);
			} else {
				tmp.put(entity.PBTXT, 1);
			}
		}
		return tmp;
	}

}