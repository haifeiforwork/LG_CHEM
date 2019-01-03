/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  :                                                             */
/*   2Depth Name  : 연급여                                                      */
/*   Program Name : 연급여                                                      */
/*   Program ID   : D06YpayDetail_to_yearSV                                   */
/*   Description  : 2003/01/13 연말정산으로 인한 연급여 생성. (연말정산용)      */
/*                  개인의 연급여에 대한 상세내용을 조회하여 값을 넘겨주는 class*/
/*   Note         :                                                             */
/*   Creation     : 2003-01-13  최영호                                          */
/*   Update       : 2005-01-20  최영호                                          */
/*   Update       : 2007-01-22  @v1.0 lsa 변수 clear 안되어 오류로 수정         */
/*                  2007-10-22	huang peng xiao globalehr update               */
/********************************************************************************/
package servlet.hris.D.D06Ypay;

import hris.D.D05Mpay.rfc.D05LatestPaidRFC;
import hris.D.D06Ypay.D06YpayDetailData_to_year;
import hris.D.D06Ypay.rfc.D06YpayDetail_to_yearRFC;
import hris.common.WebUserData;
import hris.common.util.AppUtil;

import java.util.ArrayList;
import java.util.List;
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
 * 상세내용을 조회하여 D06YpayDetail.jsp 값을 넘겨주는 class
 * 
 * @author 최영호
 * @version 1.0, 2003/01/13
 * 				 2007-10-22	globalehr update by huang peng xiao 
 */
public class D06YpayEastSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		// Connection con = null;
		try {
			HttpSession session = req.getSession(false);
			WebUserData user = (WebUserData) session.getAttribute("user");

			String dest = "";
			String jobid = "";
			// String flag = " ";
			// String seqnr = "00000";

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
						+ "hris.D.D06Ypay.D06YpayDetail_to_yearSV?jobid=kubya&year="
						+ year); // 5월 21일 순번 추가
				dest = WebUtil.JspURL + "common/printFrame.jsp";
				printJspPage(req, res, dest);
				return;
			}

			D06YpayDetail_to_yearRFC rfc = new D06YpayDetail_to_yearRFC();

			String from_year = year + "01";
			String to_year = year + "12";
			
			Vector D06YpayDetailData_vt = new Vector();

			D06YpayDetailData_vt = rfc.getYpayDetail(user.empNo, from_year, to_year,user.webUserId);
			
			Logger.debug.println(this, "D06YpayDetailData_vt================>" + D06YpayDetailData_vt.toString());

			// /List sumList = new ArrayList();
			D06YpayDetailData_to_year total = new D06YpayDetailData_to_year();
			AppUtil.initEntity(total, "0");
			for (int i = 0; i < D06YpayDetailData_vt.size(); i++) {
				D06YpayDetailData_to_year data = (D06YpayDetailData_to_year) D06YpayDetailData_vt
						.get(i);
				total.BET01 = String.valueOf(Double.parseDouble(total.BET01)
						+ Double.parseDouble(data.BET01));
				total.BET02 = String.valueOf(Double.parseDouble(total.BET02)
						+ Double.parseDouble(data.BET02));
				total.BET03 = String.valueOf(Double.parseDouble(total.BET03)
						+ Double.parseDouble(data.BET03));
				total.BET04 = String.valueOf(Double.parseDouble(total.BET04)
						+ Double.parseDouble(data.BET04));
				total.BET05 = String.valueOf(Double.parseDouble(total.BET05)
						+ Double.parseDouble(data.BET05));
				total.BET06 = String.valueOf(Double.parseDouble(total.BET06)
						+ Double.parseDouble(data.BET06));
				total.BET07 = String.valueOf(Double.parseDouble(total.BET07)
						+ Double.parseDouble(data.BET07));
				total.BET08 = String.valueOf(Double.parseDouble(total.BET08)
						+ Double.parseDouble(data.BET08));
				total.BET09 = String.valueOf(Double.parseDouble(total.BET09)
						+ Double.parseDouble(data.BET09));
				total.BET10 = String.valueOf(Double.parseDouble(total.BET10)
						+ Double.parseDouble(data.BET10));
				total.BET11 = String.valueOf(Double.parseDouble(total.BET11)
						+ Double.parseDouble(data.BET11));
				total.BET12 = String.valueOf(Double.parseDouble(total.BET12)
						+ Double.parseDouble(data.BET12));
				total.BET13 = String.valueOf(Double.parseDouble(total.BET13)
						+ Double.parseDouble(data.BET13));
				total.BET14 = String.valueOf(Double.parseDouble(total.BET14)
						+ Double.parseDouble(data.BET14));
				total.BET15 = String.valueOf(Double.parseDouble(total.BET15)
						+ Double.parseDouble(data.BET15));
				total.BET16 = String.valueOf(Double.parseDouble(total.BET16)
						+ Double.parseDouble(data.BET16));
				total.BET17 = String.valueOf(Double.parseDouble(total.BET17)
						+ Double.parseDouble(data.BET17));
			}

			total.ZYYMM = "TOTAL";
			D06YpayDetailData_vt.addElement(total);
			req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
			req.setAttribute("from_year", year);
			
			Logger.debug.println(this, "D06YpayDetailData_vt.size()================>" + D06YpayDetailData_vt.size());
			Logger.debug.println(this, "D06YpayDetailData_vt*********================>" + D06YpayDetailData_vt.toString());
			
			dest = WebUtil.JspURL + "D/D06Ypay/D06YpayEast.jsp";
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
