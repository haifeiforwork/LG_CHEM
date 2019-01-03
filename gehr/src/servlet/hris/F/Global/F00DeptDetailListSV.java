/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 인원현황 각각의 상세화면                                    */
/*   Program ID   : F00DeptDetailListSV                                         */
/*   Description  : 인원현황 각각의 상세화면 조회를 위한 서블릿                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-07 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.rfc.Global.F00DeptDetailListRFC;
import hris.common.util.AppUtil;

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
 * F02DeptPositionDutySV 인원현황 각각의 상세화면 정보를 가져오는 F00DeptDetailListRFC 를 호출하는 서블릿
 * class
 *
 * @author 유용원
 * @version 1.0
 */
public class F00DeptDetailListSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");

			HttpSession session = req.getSession(false);

			Box box = WebUtil.getBox(req);

			String gubun 		= box.get("hdn_gubun"); 		// 구분값.
			String deptId 		= box.get("hdn_deptId"); 		// 부서코드
			String checkYN 	= box.get("chck_yeno"); 		// 하위부서여부.
			String paramA 		= box.get("hdn_paramA"); 		// 파라메타
			String paramB 		= box.get("hdn_paramB"); 		// 파라메타
			String paramC 		= box.get("hdn_paramC"); 		// 파라메타
			String paramD 		= box.get("hdn_paramD"); 		// 파라메타
			String paramE 		= box.get("hdn_paramE"); 		// 파라메타
			String paramF 		= box.get("hdn_paramF"); 		// 파라메타
			String excel 		= box.get("hdn_excel"); 		// 엑셀여부.

			Logger.debug.println(this, "#####	gubun	:	" + gubun);
			Logger.debug.println(this, "#####	deptId 	:	" + deptId);
			Logger.debug.println(this, "#####	checkYN	:	" + checkYN);
			Logger.debug.println(this, "#####	paramA	:	" + paramA);
			Logger.debug.println(this, "#####	paramB	:	" + paramB);
			Logger.debug.println(this, "#####	paramC 	:	" + paramC);
			Logger.debug.println(this, "#####	paramD 	:	" + paramD);
			Logger.debug.println(this, "#####	paramE 	:	" + paramE);
			Logger.debug.println(this, "#####	paramF 	:	" + paramF);

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "Failed to bring detailed information.";		//상세 정보를 가져오는데 실패하였습니다.

			F00DeptDetailListRFC func = null;
			Vector F00DeptDetailListData_vt = null;

			if (!gubun.equals("") && !deptId.equals("")) {
				func = new F00DeptDetailListRFC();
				F00DeptDetailListData_vt = new Vector();
				/*if (gubun.equals("16") || gubun.equals("17")
						|| gubun.equals("18") || gubun.equals("21") || gubun.equals("10") || gubun.equals("11")) {
				} else {
					if (paramB.equals("TOTAL"))
						checkYN = "Y";
					else
						checkYN = "";
				}*/

				Logger.debug.println(
						"gubun:" + gubun + " deptId:" + deptId + " checkYN:" +  checkYN + " paramA :" + 	paramA + " paramB:" +  paramB + " paramC:"
						+  paramC + " paramD: " +  paramD + " paramE: " +  paramE + " paramF:" +  paramF);

				Vector ret = func.getDeptDetailList(gubun, deptId, checkYN,
						paramA, paramB, paramC, paramD, paramE, paramF);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F00DeptDetailListData_vt = (Vector) ret.get(2);
			}
			Logger.debug.println(this, "#####	E_RETURN	:	" + E_RETURN);

			// RFC 호출 성공시.
			if (E_RETURN != null && E_RETURN.equals("S")) {
				req.setAttribute("F00DeptDetailListData_vt",
						F00DeptDetailListData_vt);
				if (excel.equals("ED")) // 엑셀저장일 경우.
					dest = WebUtil.JspURL + "F/F00DeptDetailListExcel_Global.jsp";
				else
					dest = WebUtil.JspURL + "F/F00DeptDetailList_Global.jsp";

				// RFC 호출 실패시.
			} else {
				Logger.debug.println(this, " E_MESSAGE = " + E_MESSAGE);
				String msg = E_MESSAGE;
				String url = "history.back();";
				req.setAttribute("msg", msg);
				req.setAttribute("url", url);
				dest = WebUtil.JspURL + "common/msg.jsp";
			}

			Logger.debug.println(this, "#####	destributed = " + dest);
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
}