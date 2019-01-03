/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Employee Data                                                            */
/*   2Depth Name  : Payroll                                                      */
/*   Program Name : Annual Salary       (유럽+미국용)                                                 */
/*   Program ID   : D06YpayDetail_to_yearEurpSV_m                                   */
/*   Description  : 2003/01/13 연말정산으로 인한 연급여 생성. (연말정산용)      */
/*                  개인의 연급여에 대한 상세내용을 조회하여 값을 넘겨주는 class[유럽용]*/
/*   Note         :                                                             */
/*   Creation     : 2010-08-01  yji                                          */
/********************************************************************************/
package servlet.hris.D.D06Ypay;

import hris.D.D06Ypay.D06YpayDetailData_to_year;
import hris.D.D06Ypay.rfc.D06YpayDetail_to_yearRFCEurp;
import hris.common.WebUserData;

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
 * D06YpayDetail_to_yearSV.java 2003/01/13 연말정산으로 인한 연급여 생성. (연말정산용) 개인의 연급여에 대한
 * 상세내용을 조회하여 D06YpayDetail.jsp 값을 넘겨주는 class[유럽용]
 * 
 * @author yji
 * @version 1.0, 2010/08/01
 */
public class D06YpayWestSV_m extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			HttpSession session = req.getSession(false);
			WebUserData user_m = (WebUserData) session.getAttribute("user_m");

            if(!"X".equals(user_m.e_mss)) {
                req.setAttribute("title", "COMMON.MENU.ESS_PY_ANNU_PAY");
                req.setAttribute("servlet", "hris.D.D06Ypay.D06YpayWestSV_m");
            	
            	 printJspPage(req, res, WebUtil.JspURL+"common/MSS_SearchPernNameOrg.jsp");
            	 return;
            }

			String dest = "";
			String jobid = "";

			Box box = WebUtil.getBox(req);
			jobid = box.get("jobid");
			
			String PERNR =  getPERNR(box, user_m); //box.get("PERNR");
			
			if( PERNR == null || PERNR.equals(""))
				PERNR = user_m.empNo;
			
			if (jobid.equals("")) {
				jobid = "first";
			}
			
			String year = "";
			year = box.get("year");
			if (year == null || year.equals("")) {
				year = DataUtil.getCurrentDate().substring(0, 4);
			}

			if (jobid != null && jobid.equals("kubya_1")) {
				req.setAttribute("print_page_name", WebUtil.ServletURL
						+ "hris.D.D06Ypay.D06YpayWestSV_m?jobid=kubya&year="
						+ year); // 5월 21일 순번 추가
				dest = WebUtil.JspURL + "common/printFrame.jsp";
				printJspPage(req, res, dest);
				return;
			}

			D06YpayDetail_to_yearRFCEurp rfc = new D06YpayDetail_to_yearRFCEurp();

			String from_year = year + "01";
			String to_year = year + "12";

			Vector D06YpayDetailData_vt = new Vector();
			Vector D06YpayDetailData_vt2 = new Vector();

			Logger.debug.println(this, "[user.empNo] "+user_m.empNo);
			Logger.debug.println(this, "[year] "+year);
			
			D06YpayDetailData_vt = rfc.getYpayDetail(user_m.empNo, year);

            req.setAttribute("year", year);
            String E_MESSAGE = (String)D06YpayDetailData_vt.get(0);
            String E_RETURN = (String)D06YpayDetailData_vt.get(1);
            D06YpayDetailData_to_year E_PERSON = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(2);
            D06YpayDetailData_vt2 = (Vector) D06YpayDetailData_vt.get(3);
            
            req.setAttribute("person", E_PERSON);
			req.setAttribute("D06YpayDetailData_vt2", D06YpayDetailData_vt2);

			dest = WebUtil.JspURL + "D/D06Ypay/D06YpayWest_m.jsp";
			
			/*
			if (jobid != null && jobid.equals("kubya")) {
				dest = WebUtil.JspURL + "D/D06Ypay/D06YpayPrint_to_year_m.jsp";
			}
			*/
			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
		}
	}
}
