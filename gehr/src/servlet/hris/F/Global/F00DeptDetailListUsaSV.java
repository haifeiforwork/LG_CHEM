/******************************************************************************/
/*		System Name	: g-HR
/*   	1Depth Name 	:
/*   	2Depth Name 	: Time ������ �ο���Ȳ
/*   	Program Name : Time ������ �ο���Ȳ������ ��ȭ��
/*   	Program ID   	: F00DeptDetailListUsaSV.java
/*  	Description  	: Time ������ �ο���Ȳ ������ ��ȭ�� ��ȸ�� ���� ����
/*   	Note         		: ����
/*   	Creation     	: 2010-11-05 jungin @v1.0
/******************************************************************************/

package servlet.hris.F.Global;

import hris.F.rfc.Global.F00DeptDetailListRFCUsa;
import hris.common.util.AppUtil;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;


/**
 * F00DeptDetailListUsaSV.java
 * Time ��Ȳ ������ ��ȭ�� ������ �������� F00DeptDetailListRFCUsa �� ȣ���ϴ� class
 *
 * @author jungin
 * @version 1.0
 */
public class F00DeptDetailListUsaSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		try {
			req.setCharacterEncoding("utf-8");

			HttpSession session = req.getSession(false);

			String pageCode = WebUtil.nvl(req.getParameter("pageCode"));
			String gubun = WebUtil.nvl(req.getParameter("gubun"));						// E : Emp / O : Org.
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId"));				// �μ��ڵ�
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N");		// �����μ�����

			Box box = WebUtil.getBox(req);

			String year = box.get("year");
			String month = box.get("month");
			String page = box.get("page");

			String PERNR = box.get("PERNR"); 		// ���
			String ORGEH = box.get("ORGEH"); 		// �μ��ڵ�
			String BEGDA = box.get("BEGDA"); 		// ������
			String ENDDA = box.get("ENDDA"); 		// ������
			String ABSTY = box.get("ABSTY"); 		// ���� ����

			if (BEGDA == null || BEGDA.equals("")) {
				BEGDA = year + month + "01";
			}
			if (ENDDA == null || ENDDA.equals("")) {
				ENDDA = year + month + DataUtil.getLastDay(year, month);
			}

			Logger.debug.println(this, "#####	PERNR	:	[" + PERNR + "]");
			Logger.debug.println(this, "#####	BEGDA	:	[" + BEGDA + "]");
			Logger.debug.println(this, "#####	ENDDA 	:	[" + ENDDA + "]");
			Logger.debug.println(this, "#####	ABSTY 	:	[" + ABSTY + "]");
			Logger.debug.println(this, "#####	ORGEH	:	[" + ORGEH + "]");
			Logger.debug.println(this, "#####	checkYN :	[" + checkYN + "]");

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "Failed to bring detailed information.";		// �� ������ �������µ� �����Ͽ����ϴ�.

			F00DeptDetailListRFCUsa func = null;
			Vector F00DeptDetailListDataUsa_vt = null;

			func = new F00DeptDetailListRFCUsa();

			F00DeptDetailListDataUsa_vt = new Vector();

			Vector ret = new Vector();
			// Emp Detail.
			if (gubun.equals("E") || gubun == "E") {
				ret = func.getDeptDetailEmpList(PERNR, BEGDA, ENDDA, ABSTY);
			// Org. Deatil
			} else {
				ret = func.getDeptDetailOrgList(ORGEH, BEGDA, ENDDA, ABSTY, checkYN);
			}
			E_RETURN = (String)ret.get(0);
			F00DeptDetailListDataUsa_vt = (Vector)ret.get(1);

			// RFC ȣ�� ������.
			if (E_RETURN != null && E_RETURN.equals("S")) {
				req.setAttribute("F00DeptDetailListDataUsa_vt", F00DeptDetailListDataUsa_vt);
				req.setAttribute("PERNR", PERNR);
				req.setAttribute("BEGDA", BEGDA);
				req.setAttribute("ENDDA", ENDDA);
				req.setAttribute("ABSTY", ABSTY);
                req.setAttribute("ORGEH", ORGEH);
                req.setAttribute("checkYN", checkYN);
                req.setAttribute("year", year);
                req.setAttribute("month", month);
                req.setAttribute("page", page);
                req.setAttribute("pageCode", pageCode);
                req.setAttribute("gubun", gubun);

                if (pageCode != null && pageCode.equals("TA")) {
                	dest = WebUtil.JspURL + "F/F00DeptDetailEmpListUsa_Global.jsp";

                } else if (pageCode != null && pageCode.equals("MT")) {
                	dest = WebUtil.JspURL + "F/F00DeptDetailOrgListUsa_Global.jsp";
                }

			// RFC ȣ�� ���н�.
			} else {
				String[] tmp = WebUtil.split(E_RETURN, "|");
				E_RETURN = tmp[0];
				E_MESSAGE = tmp[1];

				Logger.debug.println(this, "#####	E_RETURN	:	[" + E_RETURN + "]");
				Logger.debug.println(this, "#####	E_MESSAGE	:	[" + E_MESSAGE + "]");

				String msg = E_MESSAGE;
				String url = "self.close();";
				req.setAttribute("msg", msg);
				req.setAttribute("url", url);
				dest = WebUtil.JspURL + "common/msg.jsp";
			}

			Logger.debug.println(this, "#####	dest = " + dest);

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
