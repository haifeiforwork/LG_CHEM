/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �ο���Ȳ ������ ��ȭ��                                    */
/*   Program ID   : F00DeptDetailListSV                                         */
/*   Description  : �ο���Ȳ ������ ��ȭ�� ��ȸ�� ���� ����                 */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-07 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.rfc.Global.F00DeptDetail1ListRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F02DeptPositionDutySV �ο���Ȳ ������ ��ȭ�� ������ �������� F00DeptDetailListRFC �� ȣ���ϴ� ����
 * class
 *
 * @author �����
 * @version 1.0
 */
public class F00DeptDetail1ListSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			HttpSession session = req.getSession(false);
			Box box = WebUtil.getBox(req);

			String gubun = box.get("hdn_gubun"); 		// ���а�.
			String deptId = box.get("hdn_deptId"); 	// �μ��ڵ�
			String checkYN = box.get("chck_yeno"); 	// �����μ�����.
			String paramA = box.get("hdn_paramA"); 	// �Ķ��Ÿ
			String paramB = box.get("hdn_paramB"); 	// �Ķ��Ÿ
			String paramC = box.get("hdn_paramC"); 	// �Ķ��Ÿ
			String paramD = box.get("hdn_paramD"); 	// �Ķ��Ÿ
			String paramE = box.get("hdn_paramE"); 	// �Ķ��Ÿ
			String paramF = box.get("hdn_paramF"); 	// �Ķ��Ÿ
			String excel = box.get("hdn_excel"); 		// ��������.

			Logger.debug.println(this, " [F00DeptDetail1ListSV] gubun		= 	" + gubun);
			Logger.debug.println(this, " [F00DeptDetail1ListSV] deptId		= 	" + deptId);
			Logger.debug.println(this, " [F00DeptDetail1ListSV] checkYN 	= 	" + checkYN);
			Logger.debug.println(this, " [F00DeptDetail1ListSV] paramA 	= 	" + paramA);
			Logger.debug.println(this, " [F00DeptDetail1ListSV] paramB		= 	" + paramB);
			Logger.debug.println(this, " [F00DeptDetail1ListSV] paramC 	= 	" + paramC);
			Logger.debug.println(this, " [F00DeptDetail1ListSV] paramD 	= 	" + paramD);
			Logger.debug.println(this, " [F00DeptDetail1ListSV] paramE 		= 	" + paramE);
			Logger.debug.println(this, " [F00DeptDetail1ListSV] paramF 		= 	" + paramF);

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "Failed to bring detailed information.";// �������� �������µ� �����Ͽ����ϴ�.

			F00DeptDetail1ListRFC func = null;
			Vector F00DeptDetailListData_vt = null;

			if (!gubun.equals("") && !deptId.equals("")) {
				func = new F00DeptDetail1ListRFC();
				F00DeptDetailListData_vt = new Vector();
				if (gubun.equals("16") || gubun.equals("17")
						|| gubun.equals("18")) {
				} else {
					if (paramB.equals("TOTAL"))
						checkYN = "Y";
					else
						checkYN = "";
				}
				Vector ret = func.getDeptDetailList(gubun, deptId, checkYN,
						paramA, paramB, paramC, paramD, paramE, paramF);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F00DeptDetailListData_vt = (Vector) ret.get(2);
			}
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);

			// RFC ȣ�� ������.
			if (E_RETURN != null && E_RETURN.equals("S")) {
				req.setAttribute("F00DeptDetailListData_vt",
						F00DeptDetailListData_vt);
				if (excel.equals("ED")) // ���������� ���.
					dest = WebUtil.JspURL + "F/F00DeptDetail1ListExcel_Global.jsp";
				else
					dest = WebUtil.JspURL + "F/F00DeptDetail1List_Global.jsp";

				// RFC ȣ�� ���н�.
			} else {
				Logger.debug.println(this, " E_MESSAGE = " + E_MESSAGE);
				String msg = E_MESSAGE;
				String url = "history.back();";
				req.setAttribute("msg", msg);
				req.setAttribute("url", url);
				dest = WebUtil.JspURL + "common/msg.jsp";
			}

			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
}