/******************************************************************************/
 /*	System Name	: g-HR
 /*   	1Depth Name 	: Organization & Staffing
 /*   	2Depth Name 	: Time Management
 /*   	Program Name	: Daily Time Statement
 /*   	Program ID   	: F43DeptDayWorkConditionEurpSV.java
 /*   	Description  	: 부서별 일간 근태 집계표 조회를 위한 servlet[유럽용]
 /*   	Note         		: 없음
 /*    Creation     	: 2010-07-21 yji
 /*    Update       	: 2010-10-22 jungin @v1.0 미국법인 리턴 페이지 추가
/******************************************************************************/

package servlet.hris.F.Global;

import hris.D.BetweenDateData;
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
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import com.sns.jdf.Logger;
/**
 * F43DeptDayWorkConditionEurpSV 부서에 따른 전체 부서원의 일간 근태 집계표 정보를 가져오는
 * F42DeptMonthWorkConditionRFC 를 호출하는 서블릿 class[유럽용]
 *
 * @author yji
 * @version 1.0
 * @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32"))  2018/02/09 rdcamel
 */
public class F43DeptDayWorkConditionEurpSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		try {
			req.setCharacterEncoding("utf-8");

			HttpSession session = req.getSession(false);

			WebUserData user = (WebUserData) session.getAttribute("user"); 		// 세션

			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); 				// 부서코드
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N");		// 하위부서여부
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); 			// excelDown

			String year = WebUtil.nvl(req.getParameter("year1"));
			String month = WebUtil.nvl(req.getParameter("month1"));
			String yymmdd = "";
			String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab에서 호출되는지 여부
            String E_BUKRS = WebUtil.nvl(req.getParameter("E_BUKRS"));
			String dest_deail = "";
			String dest = "";
			Area area = null;

			// 초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}
	    	BukrsCodeByOrgehRFCEurp rfc = new BukrsCodeByOrgehRFCEurp();
	    	Vector vt = rfc.getBukrsCode(deptId);
	        E_BUKRS = (String)vt.get(1);

        	if ( E_BUKRS.equals("G290")) {
        		dest_deail ="PL";
        		area = Area.PL ;

        	} else if ( E_BUKRS.equals("G260")) {
        		dest_deail = "DE";
        		area = Area.DE ;

        	} else if (E_BUKRS.equals("G340") || E_BUKRS.equals("G400") ) {
        		dest_deail = "US";
        		area = Area.US ;
        		
        	} else if (E_BUKRS.equals("G560")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32"))  2018/02/09 rdcamel
        		dest_deail = "US";
        		area = Area.MX ;

        	} else {
        		dest_deail = "CN";
        		area = Area.CN ;
 	        }

            /**         * Start: 국가별 분기처리 */
            String fdUrl = ".";

            if (dest_deail.equals("CN")) {
        	   fdUrl = "hris.F.Global.F43DeptDayWorkConditionSV";
			}


            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }
            /**             * END: 국가별 분기처리             */

			if (year.equals("") || month.equals("")) {
				yymmdd = DataUtil.getCurrentDate();
			} else {
				yymmdd = year + month + "01";
			}


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

				Logger.debug.println(this, "#####	deptId	:	[" + deptId + "]");
				Logger.debug.println(this, "#####	yymmdd	:	[" + yymmdd.substring(0, 6) + "]");
				Logger.debug.println(this, "#####	checkYN	:	[" + checkYN + "]");

				Vector ret = func.getDeptMonthWorkCondition(deptId, "", yymmdd.substring(0, 6),"2", checkYN,user.sapType,area); // 일간 '2' set!
				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F43DeptDayTitle_vt = (Vector) ret.get(2);
				F43DeptDayData_vt = (Vector) ret.get(3);

				String BEGDA = "";
				String ENDDA = "";
				String startdate = "01";
				String lastdate = "";
				String year2 = yymmdd.substring(0, 6);

				if (yymmdd.equals("") || yymmdd.equals(null)) {
					lastdate = DataUtil.getLastDay(DataUtil.getCurrentYear(), DataUtil.getCurrentMonth());
				} else {
					lastdate = DataUtil.getLastDay(yymmdd.substring(0,4), yymmdd.substring(4,6));
				}

				BEGDA = year2 + startdate;
				ENDDA = year2 + lastdate;

				Logger.debug.println(this, "#####	BEGDA	:	[" + BEGDA + "]");
				Logger.debug.println(this, "#####	ENDDA	:	[" + ENDDA + "]");

				// days
				betweenDatefunc = new BetweenDateRFC();
				detailDataAll_vt = betweenDatefunc.BetweenDate(BEGDA, ENDDA);

				for (int i = 0 ; i < detailDataAll_vt.size() ; i ++) {
					BetweenDateData time = (BetweenDateData)detailDataAll_vt.get(i);
					//Logger.debug.println(this, "#####	day Result	:	[" + time.CAL_DATE.substring(8) + "]);
				}

				// execute data
				for (int i = 0; i < F43DeptDayTitle_vt.size(); i++) {

					F43DeptDayTitleWorkConditionData tTitle = (F43DeptDayTitleWorkConditionData) F43DeptDayTitle_vt.get(i);

					HashMap<String, String> ldata = tTitle.MAP;

					for (int j = 0; j < F43DeptDayData_vt.size(); j++) {

						F43DeptDayDataWorkConditionData tData = (F43DeptDayDataWorkConditionData) F43DeptDayData_vt.get(j);

						if (tTitle.PERNR.equals(tData.PERNR)) {

							String tmp = "";

							if (tData.DAYS.equals("0.00")||tData.DAYS.equals("0")) {
								if (tData.HOURS.equals("0.00") || tData.HOURS.equals("0")) {
									tmp = "";
								} else {
									tmp = WebUtil.printNumFormat(Double.parseDouble(tData.HOURS),2);
								}
							} else {
								tmp = ":" + WebUtil.printNumFormat(Double.parseDouble(tData.DAYS),2);
							}
							Logger.debug.println(this, "#####	tmp	:	[" + tmp + "]");

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

			//Logger.debug.println(this, "#####	E_RETURN	:	[" + E_RETURN + "]");

			// RFC 호출 성공시.
			// if (E_RETURN != null && E_RETURN.equals("S")) {
			req.setAttribute("E_BUKRS", E_BUKRS);
			req.setAttribute("checkYn", checkYN);
			req.setAttribute("detailDataAll_vt", detailDataAll_vt);
			req.setAttribute("F43DeptDayTitle_vt", F43DeptDayTitle_vt);
			req.setAttribute("E_YYYYMON", yymmdd);
			req.setAttribute("subView", subView);
        	Logger.debug.println(this, " subView = " + subView);

			if (excelDown.equals("ED")){ // 엑셀저장일 경우.

    	        //Case of Europe(Poland, Germany) and USA
                /*
                 * e_area :	46 (Poland)
                 *         		01 (Germany)
                 *				10 (USA)
                */
				dest = WebUtil.JspURL + "F/F43DeptDayWorkConditionExcel_"+dest_deail+".jsp";
			} else {
				dest = WebUtil.JspURL + "F/F43DeptDayWorkCondition_"+dest_deail+".jsp";
			}

			// RFC 호출 실패시.
			// } else {
			// String msg = E_MESSAGE;
			// String url = "history.back();";
			// req.setAttribute("msg", msg);
			// req.setAttribute("url", url);
			// dest = WebUtil.JspURL + "common/msg.jsp";
			// }

			Logger.debug.println(this, "#####	dest= " + dest);

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
