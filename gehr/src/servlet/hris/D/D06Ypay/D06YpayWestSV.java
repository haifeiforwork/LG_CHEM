/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  :                                                             */
/*   2Depth Name  : 연급여  (유럽+미국용)                                                    */
/*   Program Name : 연급여                                                      */
/*   Program ID   : D06YpayDetail_to_yearSV                                   */
/*   Description  : 2003/01/13 연말정산으로 인한 연급여 생성. (연말정산용)            */
/*                  개인의 연급여에 대한 상세내용을 조회하여 값을 넘겨주는 class[유럽용] */
/*   Note         :                                                             */
/*   Creation     : 2010-07-16  yji                                          */
/********************************************************************************/
package servlet.hris.D.D06Ypay;

import hris.D.D05Mpay.rfc.D05LatestPaidRFC;
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
 * D06YpayDetail_to_yearEurpSV.java 
 * 2003/01/13 연말정산으로 인한 연급여 생성. (연말정산용) 개인의 연급여에 대한
 * 상세내용을 조회하여 D06YpayDetail.jsp 값을 넘겨주는 class[유럽용]
 * 
 * @author yji
 * @version 1.0, 2010/07/16
 */
public class D06YpayWestSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		try {
			HttpSession session = req.getSession(false);
			WebUserData user = (WebUserData) session.getAttribute("user");

			String dest = "";
			String jobid = "";

			Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");
			Logger.debug.println(this, "[jobid] = " + jobid + " [user] : "					+ user.toString());

			String year = "";
			year = box.get("year");
			if (year == null || year.equals("")) {
                // 최종가능년도를 가져온다- ksc
                D05LatestPaidRFC rfc_paid = new D05LatestPaidRFC();
                String paydt = rfc_paid.getLatestPaid1(user.empNo,user.webUserId);//[CSR ID:2353407]
                year  = paydt.substring(0,4);
			}

			if (jobid != null && jobid.equals("kubya_1")) {
				req.setAttribute("print_page_name", WebUtil.ServletURL
						+ "hris.D.D06Ypay.D06YpayDetail_to_yearEurpSV?jobid=kubya&year="
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

			Logger.debug.println(this, "[user.empNo] "+user.empNo);
			Logger.debug.println(this, "[year] "+year);
			
			D06YpayDetailData_vt = rfc.getYpayDetail(user.empNo, year);

            req.setAttribute("year", year);
            //req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
            
            String E_MESSAGE = (String)D06YpayDetailData_vt.get(0);
            String E_RETURN = (String)D06YpayDetailData_vt.get(1);
            D06YpayDetailData_to_year E_PERSON = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(2);
            D06YpayDetailData_vt2 = (Vector) D06YpayDetailData_vt.get(3);
            
            //req.setAttribute("message", E_MESSAGE);
            //req.setAttribute("return", E_RETURN);
            req.setAttribute("person", E_PERSON);
			req.setAttribute("D06YpayDetailData_vt2", D06YpayDetailData_vt2);
			req.setAttribute("from_year", year);
			
			dest = WebUtil.JspURL + "D/D06Ypay/D06YpayWest.jsp";

			if (jobid != null && jobid.equals("kubya")) {
				dest = WebUtil.JspURL + "D/D06Ypay/D06YpayPrint_to_year.jsp";
			}
			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			
		}
	}
}
