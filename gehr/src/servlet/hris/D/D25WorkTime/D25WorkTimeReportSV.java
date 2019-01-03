/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  		*/
/*   2Depth Name  : 근태	                                                       	*/
/*   Program Name : 실 근로시간 레포트			                                  	*/
/*   Program ID   : D25WorkTimeReportSV                                         */
/*   Description  : 실 근로시간 레포트를 조회하는 Class                          	*/
/*   Note         :                                                             */
/*   Creation     : 2018-05-24  성환희	[WorkTime52] 실 근로시간 레포트 			*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/
package servlet.hris.D.D25WorkTime;

import java.io.PrintWriter;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D25WorkTime.D25WorkTimeAwartData;
import hris.D.D25WorkTime.D25WorkTimeBodyData;
import hris.D.D25WorkTime.D25WorkTimeHeaderData;
import hris.D.D25WorkTime.D25WorkTimeNwktypData;
import hris.D.D25WorkTime.D25WorkTimeP9810Data;
import hris.D.D25WorkTime.rfc.D25WorkTimeP9810RFC;
import hris.D.D25WorkTime.rfc.D25WorkTimeReportRFC;
import hris.common.EmpGubunData;
import hris.common.WebUserData;
import hris.common.rfc.GetEmpGubunRFC;

/**
 * D25WorkTimeReportSV.java
 * 개인의 실 근로시간 레포트 정보를 jsp로 넘겨주는 class
 *
 */
public class D25WorkTimeReportSV extends EHRBaseServlet {
	
	protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {
		
		try {
			
			String dest = "";
			WebUserData user = WebUtil.getSessionUser(req);
			
			Box box = WebUtil.getBox(req);
			
			final String jobid = box.get("jobid", "first");
			
			if(jobid.equals("first")) {

				String viewMode = box.get("viewMode");
				String isPop = box.get("isPop");
				String SEARCH_GUBUN = box.get("SEARCH_GUBUN", "W"); // W:주간, M:월간
				String SEARCH_DATE = box.get("SEARCH_DATE");
				String SEARCH_YEAR = box.get("SEARCH_YEAR");
				String SEARCH_MONTH = box.get("SEARCH_MONTH");
				String PARAM_PERNR = box.get("PARAM_PERNR", "");
				String PARAM_ORGTX = box.get("PARAM_ORGTX", "");
				
				String PERNR = (isPop.equals("Y")) ? PARAM_PERNR : user.empNo;
				
				D25WorkTimeReportRFC reportRFC = new D25WorkTimeReportRFC();
				
				// 사원근무 구분값 S:사무직 H:현장직
	            String EMPGUB = "";
	            GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
	            Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);
	            if(empGubunRFC.getReturn().isSuccess()) EMPGUB = tpInfo.get(0).getEMPGUB();
	            
	            Vector export = null;
	            String E_NAME = "";
	            String E_BEGDA = "";
	            String E_ENDDA = "";
	            String E_WTCATTX = "";
	            String E_WKAVR = "";
	            D25WorkTimeHeaderData ES_HEADER = new D25WorkTimeHeaderData();
	            Vector<D25WorkTimeBodyData> T_BODY = new Vector<D25WorkTimeBodyData>();
	            Vector<D25WorkTimeNwktypData> T_NWKTYP = new Vector<D25WorkTimeNwktypData>();
	            Vector<D25WorkTimeAwartData> T_AWART = new Vector<D25WorkTimeAwartData>();
	            Vector<D25WorkTimeHeaderData> T_HEADER = new Vector<D25WorkTimeHeaderData>();
	            
	            if("W".equals(SEARCH_GUBUN)) {
	            	if(SEARCH_DATE == null || SEARCH_DATE.equals("")) SEARCH_DATE = DataUtil.getCurrentDate();
	            	
	            	if("S".equals(EMPGUB)) {
	            		export = reportRFC.getSWeekReport(PERNR, SEARCH_DATE);
	                	
	                	E_NAME = (String) export.get(0);
	                	T_BODY = (Vector<D25WorkTimeBodyData>) export.get(1);
	                	T_NWKTYP = (Vector<D25WorkTimeNwktypData>) export.get(2);
	                	T_AWART = (Vector<D25WorkTimeAwartData>) export.get(3);
	                	T_HEADER = (Vector<D25WorkTimeHeaderData>) export.get(4);
	                	
	                	if(viewMode.equals("excel")) {
	                    	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeReportSWeekExcel.jsp";
	                    } else {
	                    	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeReportSWeek.jsp";
	                    }
	            	} else {
	            		export = reportRFC.getHWeekReport(PERNR, SEARCH_DATE);
	            		
	            		E_NAME = (String) export.get(0);
	            		E_WTCATTX = (String) export.get(1);
	            		E_BEGDA = (String) export.get(2);
	            		E_ENDDA = (String) export.get(3);
	            		E_WKAVR = (String) export.get(4);
	            		T_BODY = (Vector<D25WorkTimeBodyData>) export.get(5);
	            		T_NWKTYP = (Vector<D25WorkTimeNwktypData>) export.get(6);
	            		T_HEADER = (Vector<D25WorkTimeHeaderData>) export.get(7);
	            		
	            		D25WorkTimeP9810RFC rfc = new D25WorkTimeP9810RFC();
	    			    Vector<D25WorkTimeP9810Data> T_P9810 = rfc.getP9810(PERNR, SEARCH_DATE);
	    			    String WTCAT = ((D25WorkTimeP9810Data)T_P9810.get(0)).getWTCAT();
	    			    req.setAttribute("WTCAT", WTCAT);
	            		
	            		if(viewMode.equals("excel")) {
	                    	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeReportHWeekExcel.jsp";
	                    } else {
	                    	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeReportHWeek.jsp";
	                    }
	            	}
	            	
	            	SEARCH_YEAR = DataUtil.getCurrentYear();
	            	SEARCH_MONTH = DataUtil.getCurrentMonth();
	            } else {
	            	if("S".equals(EMPGUB)) {
	            		if(SEARCH_YEAR == null || SEARCH_YEAR.equals("")) SEARCH_YEAR = DataUtil.getCurrentYear();
	                	if(SEARCH_MONTH == null || SEARCH_MONTH.equals("")) {
	                		SEARCH_MONTH = DataUtil.getCurrentMonth();
	                		
	                		String curDay = DataUtil.getCurrentDate().substring(6, 8);
	                		if(EMPGUB.equals("H") && Integer.parseInt(curDay) > 20) {
	                			SEARCH_MONTH = String.format("%02d", Integer.parseInt(SEARCH_MONTH) + 1);
	                		}
	                	} else if(SEARCH_MONTH.length() == 1) {
	                		SEARCH_MONTH = "0" + SEARCH_MONTH;
	                	}
	                	
	            		export = reportRFC.getSMonthReport(PERNR, SEARCH_YEAR + SEARCH_MONTH);
	                	
	                	E_NAME = (String) export.get(0);
	                	E_BEGDA = (String) export.get(1);
	                	E_ENDDA = (String) export.get(2);
	                	ES_HEADER = (D25WorkTimeHeaderData) export.get(3);
	                	T_BODY = (Vector<D25WorkTimeBodyData>) export.get(4);
	                	T_NWKTYP = (Vector<D25WorkTimeNwktypData>) export.get(5);
	                	T_AWART = (Vector<D25WorkTimeAwartData>) export.get(6);
	                	T_HEADER = (Vector<D25WorkTimeHeaderData>) export.get(7);
	                	
	            		if(viewMode.equals("excel")) {
	                    	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeReportSMonthExcel.jsp";
	                    } else {
	                    	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeReportSMonth.jsp";
	                    }
	            	} else {
	            		export = reportRFC.getHMonthReport(PERNR, SEARCH_DATE);
	            		
	                	E_NAME = (String) export.get(0);
	                	E_WTCATTX = (String) export.get(1);
	                	E_BEGDA = (String) export.get(2);
	                	E_ENDDA = (String) export.get(3);
	                	T_BODY = (Vector<D25WorkTimeBodyData>) export.get(4);
	                	T_NWKTYP = (Vector<D25WorkTimeNwktypData>) export.get(5);
	                	T_HEADER = (Vector<D25WorkTimeHeaderData>) export.get(6);
	                	
	            		if(viewMode.equals("excel")) {
	                    	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeReportHMonthExcel.jsp";
	                    } else {
	                    	dest = WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeReportHMonth.jsp";
	                    }
	            	}
	            }
	            
	            if(reportRFC.getReturn().isSuccess()) {
	            	req.setAttribute("EMPGUB", EMPGUB);
	            	req.setAttribute("PERNR", PERNR);
	                req.setAttribute("E_NAME", E_NAME);
	                req.setAttribute("E_BEGDA", E_BEGDA);
	                req.setAttribute("E_ENDDA", E_ENDDA);
	                req.setAttribute("E_WTCATTX", E_WTCATTX);
	                req.setAttribute("E_WKAVR", E_WKAVR);
	                req.setAttribute("ES_HEADER", ES_HEADER);
	                req.setAttribute("T_BODY", T_BODY);
	                req.setAttribute("T_NWKTYP", T_NWKTYP);
	                req.setAttribute("T_AWART", T_AWART);
	                req.setAttribute("T_HEADER", T_HEADER);
	                
	                req.setAttribute("SEARCH_GUBUN", SEARCH_GUBUN);
	                req.setAttribute("SEARCH_DATE", SEARCH_DATE);
	                req.setAttribute("SEARCH_YEAR", SEARCH_YEAR);
	                req.setAttribute("SEARCH_MONTH", SEARCH_MONTH);
	                req.setAttribute("CURRENT_YEAR", DataUtil.getCurrentYear());
	                req.setAttribute("PARAM_ORGTX", PARAM_ORGTX);
	                req.setAttribute("isPop", isPop);
	            } else {
	            	String msg = reportRFC.getReturn().MSGTX;
	                String url = "history.back();";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        dest = WebUtil.JspURL+"common/caution.jsp";
	            }
	
				Logger.debug.println(this, " destributed = " + dest);
				printJspPage(req, res, dest);
				
			} else if(jobid.equals("p9810")) {
				String PERNR  = req.getParameter("PERNR");
			    String DATUM  = req.getParameter("DATUM");
			    
			    D25WorkTimeP9810RFC rfc = new D25WorkTimeP9810RFC();
			    
			    Vector<D25WorkTimeP9810Data> T_P9810 = rfc.getP9810(PERNR, DATUM);
			    
			    PrintWriter out = res.getWriter();
			    
			    if(!rfc.getReturn().isSuccess()) {
			    	String flag = rfc.getReturn().MSGTY ;
					String msg = rfc.getReturn().MSGTX ;

					out.println(flag + "," + msg); // fail
			    } else {
			    	String WTCAT = ((D25WorkTimeP9810Data) T_P9810.get(0)).WTCAT;
			    	
			    	out.println(WTCAT + ",");
			    }
			    
			    return;
			}
			
		} catch (Exception e) {
			throw new GeneralException(e);
		}
		
	}

}
