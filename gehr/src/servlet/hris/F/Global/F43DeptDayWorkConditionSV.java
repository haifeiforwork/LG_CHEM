/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 일간 근태 집계표                                            */
/*   Program ID   : F43DeptDayWorkConditionSV                                   */
/*   Description  : 부서별 일간 근태 집계표 조회를 위한 서블릿                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-17 유용원                                           */
/*   Update       : 2007-09-21  huang peng xiao                           */
/*                         : 2017-11-06  eunha  [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건     */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.D.rfc.BetweenDateRFC;
import hris.F.Global.F43DeptDayDataWorkConditionData;
import hris.F.Global.F43DeptDayTitleWorkConditionData;
import hris.F.rfc.F42DeptMonthWorkConditionRFC;
import hris.common.WebUserData;
import hris.common.rfc.BukrsCodeByOrgehRFCEurp;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * F43DeptDayWorkConditionSV 부서에 따른 전체 부서원의 일간 근태 집계표 정보를 가져오는
 * F42DeptMonthWorkConditionRFC 를 호출하는 서블릿 class
 *
 * @author 유용원
 * @version 1.0
 */
public class F43DeptDayWorkConditionSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			HttpSession session = req.getSession(false);
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // 부서코드...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); // 하위부서여부.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
			String year = WebUtil.nvl(req.getParameter("year1"));
			String month = WebUtil.nvl(req.getParameter("month1"));
			String yymmdd = "";
			WebUserData user = (WebUserData) session.getAttribute("user"); // 세션.
			String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab에서 호출되는지 여부


			// 초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}


			if (year.equals("") || month.equals("")) {
				yymmdd = DataUtil.getCurrentDate();
			} else {
				yymmdd = year + month + "20";
			}

			String dest = "";
			String E_RETURN = "";
	        //String E_MESSAGE 	= "부서 정보를 가져오는데 실패하였습니다.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;

			F42DeptMonthWorkConditionRFC func = null;
			BetweenDateRFC betweenDatefunc = null;
			Vector F43DeptDayTitle_vt = null;
			Vector F43DeptDayData_vt = null;
			Vector detailDataAll_vt = null;

	        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));

	        if(sMenuCode.equals("ESS_HRA_DAIL_STATE")){                            //개인인사정보 > 신청 > 부서근태
	        	if(!checkTimeAuthorization(req, res)) return;
	        }else{                                                               //부서인사정보
//	    	 @웹취약성 추가
	        	if ( user.e_authorization.equals("E")) {
	        		if(!checkTimeAuthorization(req, res)) return;
	        	}
	        }

			if (!deptId.equals("")) {
				func = new F42DeptMonthWorkConditionRFC();
				F43DeptDayTitle_vt = new Vector();
				F43DeptDayData_vt = new Vector();
				Vector ret = func.getDeptMonthWorkCondition(deptId,"", yymmdd.substring(0, 6), "2", checkYN,user.sapType,Area.CN); // 일간 '2' set!

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F43DeptDayTitle_vt = (Vector) ret.get(2);
				F43DeptDayData_vt = (Vector) ret.get(3);

				// days
				betweenDatefunc = new BetweenDateRFC();

				String yyyy = yymmdd.substring(0, 4);
				String mm = yymmdd.substring(4, 6);
				String BEGDA = "";
				String ENDDA = "";

				// [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건   start
				if(user.area == Area.TH){
					if (mm.equals("01")) {
						BEGDA = Integer.parseInt(yyyy) - 1 + "1216";
					} else {
						BEGDA = yyyy
								+ ((Integer.parseInt(mm) - 1) < 10 ? "0"
										+ (Integer.parseInt(mm) - 1) : (Integer
										.parseInt(mm) - 1)) + "16";
					}
					ENDDA = yyyy + mm + "15";
					// [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건   end
				}else {
					if (mm.equals("01")) {
					BEGDA = Integer.parseInt(yyyy) - 1 + "1221";
					} else {
						BEGDA = yyyy
							+ ((Integer.parseInt(mm) - 1) < 10 ? "0"
									+ (Integer.parseInt(mm) - 1) : (Integer
									.parseInt(mm) - 1)) + "21";
				}
				ENDDA = yyyy + mm + "20";
				}

				detailDataAll_vt = betweenDatefunc.BetweenDate(BEGDA, ENDDA);
		        Logger.debug.println(this, "detailDataAll_vt : "+ detailDataAll_vt);


				// execute data

				for (int i = 0; i < F43DeptDayTitle_vt.size(); i++) {

					F43DeptDayTitleWorkConditionData tTitle = (F43DeptDayTitleWorkConditionData) F43DeptDayTitle_vt
							.get(i);
					Logger.debug.println(this, "tTitle : "+ tTitle.toString());
					HashMap<String, String> ldata = tTitle.MAP;

					for (int j = 0; j < F43DeptDayData_vt.size(); j++) {

						F43DeptDayDataWorkConditionData tData = (F43DeptDayDataWorkConditionData) F43DeptDayData_vt
								.get(j);

						if (tTitle.PERNR.equals(tData.PERNR)) {

							String tmp = ":"
									+ ((tData.DAYS.equals("0.00")||tData.DAYS.equals("0")) ? tData.HOURS
											: tData.DAYS);

							if (ldata.containsKey(tData.BEGDA)) {

								String tVal = ldata.get(tData.BEGDA);

								tVal += "<br>" + tData.FLAG + tmp;

								ldata.put(tData.BEGDA, tVal);

							} else {

								ldata.put(tData.BEGDA, tData.FLAG + tmp);

							}
						}
					}

				}

			}
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);

			// RFC 호출 성공시.
			// if (E_RETURN != null && E_RETURN.equals("S")) {
			req.setAttribute("checkYn", checkYN);

			req.setAttribute("detailDataAll_vt", detailDataAll_vt);
			req.setAttribute("F43DeptDayTitle_vt", F43DeptDayTitle_vt);
			req.setAttribute("E_YYYYMON", yymmdd);
			req.setAttribute("subView", subView);
        	Logger.debug.println(this, " subView = " + subView);
			if (excelDown.equals("ED")) // 엑셀저장일 경우.
				dest = WebUtil.JspURL + "F/F43DeptDayWorkConditionExcel_CN.jsp";
			else
				dest = WebUtil.JspURL + "F/F43DeptDayWorkCondition_CN.jsp";

			// RFC 호출 실패시.
			// }
			// else {
			// String msg = E_MESSAGE;
			// String url = "history.back();";
			// req.setAttribute("msg", msg);
			// req.setAttribute("url", url);
			// dest = WebUtil.JspURL + "common/msg.jsp";
			// }

			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
}