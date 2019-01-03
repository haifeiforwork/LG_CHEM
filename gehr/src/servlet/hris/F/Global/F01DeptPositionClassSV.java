/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 소속별/직급별 인원현황                                      */
/*   Program ID   : F01DeptPositionClassSV                                      */
/*   Description  : 소속별/직급별 인원현황 조회를 위한 서블릿                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-28 유용원                                           */
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
 * F01DeptPositionClassSV 부서에 따른 소속별/직급별 인원현황 정보를 가져오는 F01DeptPositionClassRFC 를
 * 호출하는 서블릿 class
 *
 * @author 유용원
 * @version 1.0
 */
public class F01DeptPositionClassSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			HttpSession session = req.getSession(false);
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // 부서코드...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), ""); // 하위부서여부.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
			WebUserData user = (WebUserData) session.getAttribute("user"); // 세션.

			// 초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "Failed to take the department infomation.";// 부서
			// 정보를
			// 가져오는데
			// 실패하였습니다.

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

			// RFC 호출 성공시.
			// if (E_RETURN != null && E_RETURN.equals("S")) {
			req.setAttribute("checkYn", checkYN);
			req.setAttribute("F01DeptPositionClassTitle_vt", result);
			// req.setAttribute("F01DeptPositionClassNote_vt",
			// F01DeptPositionClassNote_vt);
			if (excelDown.equals("ED")) // 엑셀저장일 경우.
				dest = WebUtil.JspURL + "F/F01DeptPositionClassExcel_Global.jsp";
			else
				dest = WebUtil.JspURL + "F/F01DeptPositionClass_Global.jsp";

			// Logger.debug.println(this, "F01DeptPositionClassNote_vt : "+
			// F01DeptPositionClassNote_vt.toString());
			// RFC 호출 실패시.
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