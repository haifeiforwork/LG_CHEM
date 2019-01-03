/******************************************************************************/
/*		System Name	: g-HR
/*   	1Depth Name 	:
/*   	2Depth Name 	: Time 유형별 인원현황
/*   	Program Name : Time 유형별 인원현황각각의 상세화면
/*   	Program ID   	: F00DeptDetailListUsaSV.java
/*  	Description  	: Time 유형별 인원현황 각각의 상세화면 조회를 위한 서블릿
/*   	Note         		: 없음
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
 * Time 현황 각각의 상세화면 정보를 가져오는 F00DeptDetailListRFCUsa 를 호출하는 class
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
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId"));				// 부서코드
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N");		// 하위부서여부

			Box box = WebUtil.getBox(req);

			String year = box.get("year");
			String month = box.get("month");
			String page = box.get("page");

			String PERNR = box.get("PERNR"); 		// 사번
			String ORGEH = box.get("ORGEH"); 		// 부서코드
			String BEGDA = box.get("BEGDA"); 		// 시작일
			String ENDDA = box.get("ENDDA"); 		// 종료일
			String ABSTY = box.get("ABSTY"); 		// 유형 구분

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
			String E_MESSAGE = "Failed to bring detailed information.";		// 상세 정보를 가져오는데 실패하였습니다.

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

			// RFC 호출 성공시.
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

			// RFC 호출 실패시.
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
