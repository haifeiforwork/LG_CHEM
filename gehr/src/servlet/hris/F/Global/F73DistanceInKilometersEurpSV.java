/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                                              */
/*   2Depth Name  : Headcount                                                    */
/*   Program Name : Org.Unit/Distance                                    */
/*   Program ID   : F73DistanceInKilometersEurpSV                                      */
/*   Description  : 근무지별/직급별 인원현황 조회를 위한 서블릿                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-08-02 yji                                           */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.Global.F02DeptPositionDutyNoteData;
import hris.F.Global.F73DistanceInKilometersDataEurp;
import hris.F.rfc.Global.F73DistanceInKilometersRFCEurp;
import hris.common.WebUserData;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * F73DistanceInKilometersEurpSV
 * 부서에 따른 거주지 출/퇴근거리 정보를 가져오는 F73DistanceInKilometersRFCEurp를 호출하는 서블릿 class
 *
 * @author yji
 * @version 1.0
 */
public class F73DistanceInKilometersEurpSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			HttpSession session = req.getSession(false);
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // 부서코드...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); // 하위부서여부.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
			WebUserData user = (WebUserData) session.getAttribute("user"); // 세션.
			String i_datum = DataUtil.getCurrentDate();

			// 초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "부서 정보를 가져오는데 실패하였습니다.";

			F73DistanceInKilometersRFCEurp func = null;
			Vector F73DistanceInKilometersTitle_vt = null;

			if (!deptId.equals("")) {
				func = new F73DistanceInKilometersRFCEurp();
				F73DistanceInKilometersTitle_vt = new Vector();

				Logger.debug.println("deptId::" + deptId + ": checkYN: "  +  checkYN  + " : i_datum: " + i_datum);
				Vector ret = func.getDistanceInKilometers(deptId, checkYN, i_datum);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F73DistanceInKilometersTitle_vt = (Vector) ret.get(2);
			}

			//HashMap meta = doWithData(F73DistanceInKilometersTitle_vt);
			Logger.debug.println(this, " F73DistanceInKilometersTitle_vt 결과 값============= " + F73DistanceInKilometersTitle_vt);
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);

			F73DistanceInKilometersTitle_vt = dataFilter(F73DistanceInKilometersTitle_vt); //추가

			// RFC 호출 성공시.
			//if (E_RETURN != null && E_RETURN.equals("S")) {
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("F73DistanceInKilometersTitle_vt",
						F73DistanceInKilometersTitle_vt);
				if (excelDown.equals("ED")) // 엑셀저장일 경우.
					dest = WebUtil.JspURL + "F/F73DistanceInKilometersExcelEurp.jsp";
				else
					dest = WebUtil.JspURL + "F/F73DistanceInKilometersEurp.jsp";

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
	/*calculate colspan

	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F73DistanceInKilometersDataEurp entity = (F73DistanceInKilometersDataEurp) deptServiceTitle_vt
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
	 */

	private Vector dataFilter(Vector F73DistanceInKilometersTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for(int i = 0 ; i < F73DistanceInKilometersTitle_vt.size() ; i ++){
			F73DistanceInKilometersDataEurp entity = (F73DistanceInKilometersDataEurp) F73DistanceInKilometersTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){
				entity = (F73DistanceInKilometersDataEurp)hris.common.util.AppUtilEurp.initEntity( entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < F73DistanceInKilometersTitle_vt.size() ; i++) {
				F73DistanceInKilometersDataEurp entity = (F73DistanceInKilometersDataEurp) F73DistanceInKilometersTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){
					entity = (F73DistanceInKilometersDataEurp)hris.common.util.AppUtilEurp.initEntity( entity , "0" , "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}


}