/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 조직관리	                                              		*/
/*   2Depth Name  : 조직/인원형황	                                               	*/
/*   Program Name : 실근무 실적현황			                                  	*/
/*   Program ID   : D25WorkTimeLeaderReportSV                                   */
/*   Description  : 리더 실근무 관리 레포트를 조회하는 Class                    		*/
/*   Note         :                                                             */
/*   Creation     : 2018-05-28  성환희	[WorkTime52] 리더 실근무 관리 레포트 		*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/
package servlet.hris.D.D25WorkTime;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D25WorkTime.D25WorkTimeListData;
import hris.D.D25WorkTime.D25WorkTimeResultData;
import hris.D.D25WorkTime.D25WorkTimeTweeksData;
import hris.D.D25WorkTime.rfc.D25WorkTimeLeaderReportRFC;
import hris.common.WebUserData;

/**
 * D25WorkTimeLeaderReportSV.java
 * 리더 실근무 관리 레포트 정보를 jsp로 넘겨주는 class
 *
 */
public class D25WorkTimeLeaderReportSV extends EHRBaseServlet {
	
	protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {
		
		try {
			
			String dest = "";
			WebUserData user = WebUtil.getSessionUser(req);
			
			String LOGPER = user.empNo;

			Box box = WebUtil.getBox(req);

			String viewMode = box.get("viewMode");
			String SEARCH_EMPGUBUN = box.get("SEARCH_EMPGUBUN", "S"); 	// S:사무직, H:현장직
			String SEARCH_GUBUN = box.get("SEARCH_GUBUN", "W"); 		// W:주간, M:월간
			String SEARCH_DATE = box.get("SEARCH_DATE");				// 조회기준일
			String SEARCH_DEPTID = box.get("SEARCH_DEPTID");					// 부서
			String SEARCH_INCLUDE_SUBDEPT = box.get("SEARCH_INCLUDE_SUBDEPT");	// 하위부서포함
			String SEARCH_PERNR = box.get("SEARCH_PERNR");						// 대상자사번
			
			D25WorkTimeLeaderReportRFC reportRFC = new D25WorkTimeLeaderReportRFC();
			
            Vector export = null;
            Vector<D25WorkTimeListData> T_LIST = new Vector<D25WorkTimeListData>();
            Vector<D25WorkTimeTweeksData> T_TWEEKS = new Vector<D25WorkTimeTweeksData>();
            Vector<D25WorkTimeResultData> T_RESULT = new Vector<D25WorkTimeResultData>();
            String DISPLAY_YEAR = "";
            String DISPLAY_MONTH = "";
            
            if("S".equals(SEARCH_EMPGUBUN)) {
            	if(SEARCH_DATE == null || SEARCH_DATE.equals("")) SEARCH_DATE = DataUtil.getCurrentDate();
	            if("W".equals(SEARCH_GUBUN)) {
	            	export = reportRFC.getSWeekReport(LOGPER, SEARCH_DATE, SEARCH_DEPTID, SEARCH_INCLUDE_SUBDEPT, SEARCH_PERNR);
	            	
	            	T_LIST = (Vector<D25WorkTimeListData>) export.get(0);
	            	T_TWEEKS = (Vector<D25WorkTimeTweeksData>) export.get(1);
	            } else {
	            	export = reportRFC.getSMonthReport(LOGPER, DataUtil.removeStructur(SEARCH_DATE, "."), SEARCH_DEPTID, SEARCH_INCLUDE_SUBDEPT, SEARCH_PERNR);
	            	
	            	T_LIST = (Vector<D25WorkTimeListData>) export.get(0);
	            }
	            
	            if(viewMode.equals("excel")) {
                	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeLeaderReportExcel.jsp";
                } else {
                	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeLeaderReport.jsp";
                }
            } else {
            	if(SEARCH_DATE == null || SEARCH_DATE.equals("")) SEARCH_DATE = DataUtil.getCurrentDate();
            	
            	export = reportRFC.getHReport(LOGPER, SEARCH_DATE, SEARCH_DEPTID, SEARCH_INCLUDE_SUBDEPT, SEARCH_PERNR);
            	
            	T_RESULT = (Vector<D25WorkTimeResultData>) export.get(0);
            	
            	if(viewMode.equals("excel")) {
                	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeLeaderHReportExcel.jsp";
                } else {
                	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeLeaderHReport.jsp";
                }
            }
	            
            if(reportRFC.getReturn().isSuccess()) {
                req.setAttribute("T_LIST", T_LIST);
                req.setAttribute("T_TWEEKS", T_TWEEKS);
                req.setAttribute("T_RESULT", T_RESULT);
                req.setAttribute("DISPLAY_YEAR", DISPLAY_YEAR);
                req.setAttribute("DISPLAY_MONTH", DISPLAY_MONTH);

                req.setAttribute("SEARCH_EMPGUBUN", SEARCH_EMPGUBUN);
                req.setAttribute("SEARCH_GUBUN", SEARCH_GUBUN);
                req.setAttribute("SEARCH_DATE", SEARCH_DATE);
                req.setAttribute("SEARCH_DEPTID", SEARCH_DEPTID);
                req.setAttribute("SEARCH_INCLUDE_SUBDEPT", SEARCH_INCLUDE_SUBDEPT);
                req.setAttribute("SEARCH_PERNR", SEARCH_PERNR);
            } else {
            	String msg = reportRFC.getReturn().MSGTX;
                String url = "history.back();";
		        req.setAttribute("msg", msg);
		        req.setAttribute("url", url);
		        dest = WebUtil.JspURL+"common/caution.jsp";
            }

			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
			
		} catch (Exception e) {
			throw new GeneralException(e);
		}
		
	}

}
