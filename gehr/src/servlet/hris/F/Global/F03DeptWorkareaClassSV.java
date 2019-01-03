/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 근무지별/직급별 인원현황                                    */
/*   Program ID   : F03DeptWorkareaClassSV                                      */
/*   Description  : 근무지별/직급별 인원현황 조회를 위한 서블릿                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-02 유용원                                           */
/*   Update       : 2007-09-27  huang peng xiao                        */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.Global.F03DeptWorkareaClassTitleData;
import hris.F.rfc.Global.F03DeptWorkareaClassRFC;
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
 * F03DeptWorkareaClassSV 부서에 따른 근무지별/직급별 인원현황 정보를 가져오는 F03DeptWorkareaClassRFC
 * 를 호출하는 서블릿 class
 *
 * @author 유용원
 * @version 1.0
 */
public class F03DeptWorkareaClassSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			HttpSession session = req.getSession(false);
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // 부서코드...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); // 하위부서여부.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
			WebUserData user = (WebUserData) session.getAttribute("user"); // 세션.

			// 초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "부서 정보를 가져오는데 실패하였습니다.";

			F03DeptWorkareaClassRFC func = null;
			Vector F03DeptWorkareaClassTitle_vt = null;
			Vector F03DeptWorkareaClassNote_vt = null;

			if (!deptId.equals("")) {
				func = new F03DeptWorkareaClassRFC();
				F03DeptWorkareaClassTitle_vt = new Vector();
				F03DeptWorkareaClassNote_vt = new Vector();
				Vector ret = func.getDeptWorkareaClass(deptId, checkYN);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F03DeptWorkareaClassTitle_vt = (Vector) ret.get(2);

				// F03DeptWorkareaClassNote_vt = (Vector)ret.get(3);
			}
			HashMap meta = doWithData(F03DeptWorkareaClassTitle_vt);
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);

			// RFC 호출 성공시.
			//if (E_RETURN != null && E_RETURN.equals("S")) {
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("F03DeptWorkareaClassTitle_vt",
						F03DeptWorkareaClassTitle_vt);
				req.setAttribute("F03DeptWorkareaClassNote_vt",
						F03DeptWorkareaClassNote_vt);
				req.setAttribute("meta", meta);
				if (excelDown.equals("ED")) // 엑셀저장일 경우.
					dest = WebUtil.JspURL + "F/F03DeptWorkareaClassExcel_Global.jsp";
				else
					dest = WebUtil.JspURL + "F/F03DeptWorkareaClass_Global.jsp";

				// RFC 호출 실패시.
			/*} else {
				String msg = E_MESSAGE;
				String url = "location.href = '" + WebUtil.JspURL
						+ "F/F03DeptWorkareaClass.jsp?checkYn=" + checkYN
						+ "';";
				req.setAttribute("msg", msg);
				req.setAttribute("url", url);
				dest = WebUtil.JspURL + "common/msg.jsp";
			}*/

			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
	//calculate colspan
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F03DeptWorkareaClassTitleData entity = (F03DeptWorkareaClassTitleData) deptServiceTitle_vt
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