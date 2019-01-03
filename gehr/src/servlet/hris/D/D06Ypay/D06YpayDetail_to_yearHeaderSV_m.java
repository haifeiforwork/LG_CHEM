/********************************************************************************/
/*	System Name	: g-HR
/*   	1Depth Name 	: Employee Data
/*   	2Depth Name 	: Payroll
/*   	Program Name	: Annual Salary                                           
/*   	Program ID   	: D06YpayDetail_to_yearHeaderSV_m.java
/*   	Description  	: 개인의 연급여내역 정보를 jsp로 넘겨주는 class [Non china - 국내사용자용 페이지]                                                 
/*   	Note         		:                                                         
/*    Creation     		: 2010-08-04 yji
/*    Update			: 2010-11-01 jungin @v1.0 미국법인 리턴페이지 추가                          
/********************************************************************************/

package servlet.hris.D.D06Ypay;

import hris.D.D06Ypay.D06YpayDetailData_to_year;
import hris.D.D06Ypay.D06YpayDetailData_to_year;
import hris.D.D06Ypay.rfc.D06YpayDetail_to_yearRFC;
import hris.D.D06Ypay.rfc.D06YpayDetail_to_yearRFCEurp;
import hris.common.WebUserData;
import hris.common.util.AppUtil;

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
 * D06YpayDetail_to_yearHeaderSV_m.java 
 * 개인의 연급여에 대한 상세내용을 조회하여 D06YpayDetail.jsp 값을 넘겨주는 class [Non china - 국내사용자용 페이지]
 * 2018/02/21 rdcamel @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  
 * @author yji
 * @version 1.0, 2010/08/04
 */
public class D06YpayDetail_to_yearHeaderSV_m extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		
		try {
			HttpSession session = req.getSession(false);
			
	        WebUserData user = (WebUserData) session.getAttribute("user");
			WebUserData user_m = (WebUserData) session.getAttribute("user_m");

			Logger.debug.println(this, "#####	user.e_area		:	[" + user.e_area + "]");
			Logger.debug.println(this, "#####	user_m.e_area	:	[" + user_m.e_area + "]");

			String dest = "";
			String jobid = "";
			String PERNR = "";
			String year = "";
			
			Box box = WebUtil.getBox(req);
			
			jobid = box.get("jobid");
			if (jobid.equals("")) {
				jobid = "first";
			}
			
			PERNR=  getPERNR(box, user); //box.get("PERNR");
			if (PERNR == null || PERNR.equals(""))
				PERNR = user_m.empNo;

			year = box.get("from_year");
			if (year == null || year.equals("")) {
				year = DataUtil.getCurrentDate().substring(0, 4);
			}

	        //Case of Europe(Poland, Germany) and USA
            /*
             * e_area :	46 (Poland)
             *         		01 (Germany) 
             *				10 (USA) 
            */
			/** 유럽 사용자를 선택했을 경우, 유럽용 로직을 실행한다. **/
			if (user_m.e_area.equals("46") || user_m.e_area.equals("01")) {
			
				if (jobid != null && jobid.equals("kubya_1")) {
					req.setAttribute("print_page_name", WebUtil.ServletURL
																	+ "hris.D.D06Ypay.D06YpayDetail_to_yearEurpSV_m?jobid=kubya&year=" + year);
					
					dest = WebUtil.JspURL + "common/printFrame.jsp";
					
					printJspPage(req, res, dest);
					return;
				}
			
				D06YpayDetail_to_yearRFCEurp rfc = new D06YpayDetail_to_yearRFCEurp();
			
				String from_year = year + "01";
				String to_year = year + "12";
			
				Vector D06YpayDetailData_vt = new Vector();
				Vector D06YpayDetailData_vt2 = new Vector();
			
				Logger.debug.println(this, "#####	[EURP] user.empNo	:	[" + user.empNo + "]");
				Logger.debug.println(this, "#####	[EURP] year	:	[" + year + "]");
				
				D06YpayDetailData_vt = rfc.getYpayDetail(user_m.empNo, year);			
			    
			    String E_MESSAGE = (String)D06YpayDetailData_vt.get(0);
			    String E_RETURN = (String)D06YpayDetailData_vt.get(1);
			    D06YpayDetailData_to_year E_PERSON = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(2);
			    D06YpayDetailData_vt2 = (Vector) D06YpayDetailData_vt.get(3);
			    
			    req.setAttribute("person", E_PERSON);
				req.setAttribute("D06YpayDetailData_vt2", D06YpayDetailData_vt2);
				req.setAttribute("year", year);
			
				if (user_m.e_area.equals("46") || user_m.e_area.equals("01")) { 
					dest = WebUtil.JspURL + "D/D06Ypay/D06YpayWest_m.jsp";	
				}
				
				if (jobid != null && jobid.equals("kubya")) {
					dest = WebUtil.JspURL + "D/D06Ypay/D06YpayPrint_to_year_m.jsp";
				}	
				
			/** 미국 사용자를 선택했을 경우, 미국용 로직을 실행한다. **/
			} else if (user_m.e_area.equals("10")||user_m.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel	
				
				if (jobid != null && jobid.equals("kubya_1")) {
					req.setAttribute("print_page_name", WebUtil.ServletURL
																	+ "hris.D.D06Ypay.D06YpayDetail_to_yearUsaSV_m?jobid=kubya&year=" + year);
					
					dest = WebUtil.JspURL + "common/printFrame.jsp";
					
					printJspPage(req, res, dest);
					return;
				}
			
				D06YpayDetail_to_yearRFCEurp rfc = new D06YpayDetail_to_yearRFCEurp();
			
				String from_year = year + "01";
				String to_year = year + "12";
			
				Vector D06YpayDetailData_vt = new Vector();
				Vector D06YpayDetailData_vt2 = new Vector();
			
				Logger.debug.println(this, "#####	[USA] user.empNo	:	[" + user.empNo + "]");
				Logger.debug.println(this, "#####	[USA] year	:	[" + year + "]");
				
				D06YpayDetailData_vt = rfc.getYpayDetail(user_m.empNo, year);
			
			    String E_MESSAGE = (String)D06YpayDetailData_vt.get(0);
			    String E_RETURN = (String)D06YpayDetailData_vt.get(1);
			    D06YpayDetailData_to_year E_PERSON = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(2);
			    D06YpayDetailData_vt2 = (Vector) D06YpayDetailData_vt.get(3);
			    
			    req.setAttribute("person", E_PERSON);
				req.setAttribute("D06YpayDetailData_vt2", D06YpayDetailData_vt2);
				req.setAttribute("year", year);
			
				if (user_m.e_area.equals("10")||user_m.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
					dest = WebUtil.JspURL + "D/D06Ypay/D06YpayWest_m.jsp";	
				}
				
				if (jobid != null && jobid.equals("kubya")) {
					dest = WebUtil.JspURL + "D/D06Ypay/D06YpayPrint_to_year_m.jsp";
				}

			// Case of China &  Korea
			/** 국내/중국 사용자를 선택했을 경우, 기존 중국로직을 실행한다. **/
			} else {
			
				if (jobid != null && jobid.equals("kubya_1")) {
					req.setAttribute("print_page_name", WebUtil.ServletURL
																	+ "hris.D.D06Ypay.D06YpayDetail_to_yearHeaderSV_m?jobid=kubya&year=" + year);
					
					dest = WebUtil.JspURL + "common/printFrame.jsp";
					
					printJspPage(req, res, dest);
					return;
				}
	
				D06YpayDetail_to_yearRFC rfc = new D06YpayDetail_to_yearRFC();
	
				String from_year = year + "01";
				String to_year = year + "12";
	
				Logger.debug.println(this, "#####	[CN & KR] user.empNo	:	[" + user.empNo + "]");
				Logger.debug.println(this, "#####	[CN & KR] year	:	[" + year + "]");
				
				Vector D06YpayDetailData_vt = rfc.getYpayDetail(PERNR, from_year, to_year, user.webUserId);
	
				D06YpayDetailData_to_year total = new D06YpayDetailData_to_year();
				
				AppUtil.initEntity(total, "0");
				
				for (int i = 0; i < D06YpayDetailData_vt.size(); i++) {
					
					D06YpayDetailData_to_year data = (D06YpayDetailData_to_year) D06YpayDetailData_vt.get(i);
					
					total.BET01 = String.valueOf(Double.parseDouble(total.BET01) + Double.parseDouble(data.BET01));
					total.BET02 = String.valueOf(Double.parseDouble(total.BET02) + Double.parseDouble(data.BET02));
					total.BET03 = String.valueOf(Double.parseDouble(total.BET03) + Double.parseDouble(data.BET03));
					total.BET04 = String.valueOf(Double.parseDouble(total.BET04) + Double.parseDouble(data.BET04));
					total.BET05 = String.valueOf(Double.parseDouble(total.BET05) + Double.parseDouble(data.BET05));
					total.BET06 = String.valueOf(Double.parseDouble(total.BET06) + Double.parseDouble(data.BET06));
					total.BET07 = String.valueOf(Double.parseDouble(total.BET07) + Double.parseDouble(data.BET07));
					total.BET08 = String.valueOf(Double.parseDouble(total.BET08) + Double.parseDouble(data.BET08));
					total.BET09 = String.valueOf(Double.parseDouble(total.BET09) + Double.parseDouble(data.BET09));
					total.BET10 = String.valueOf(Double.parseDouble(total.BET10) + Double.parseDouble(data.BET10));
					total.BET11 = String.valueOf(Double.parseDouble(total.BET11) + Double.parseDouble(data.BET11));
					total.BET12 = String.valueOf(Double.parseDouble(total.BET12) + Double.parseDouble(data.BET12));
					total.BET13 = String.valueOf(Double.parseDouble(total.BET13) + Double.parseDouble(data.BET13));
					total.BET14 = String.valueOf(Double.parseDouble(total.BET14) + Double.parseDouble(data.BET14));
					total.BET15 = String.valueOf(Double.parseDouble(total.BET15) + Double.parseDouble(data.BET15));
					total.BET16 = String.valueOf(Double.parseDouble(total.BET16) + Double.parseDouble(data.BET16));
					total.BET17 = String.valueOf(Double.parseDouble(total.BET17) + Double.parseDouble(data.BET17));
				}
	
				total.ZYYMM = "TOTAL";
				
				D06YpayDetailData_vt.addElement(total);
				
				req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
				req.setAttribute("from_year", year);
				
				dest = WebUtil.JspURL + "D/D06Ypay/D06YpayDetail_to_yearHeader_m.jsp";
				
				/*
				if (jobid != null && jobid.equals("kubya")) {
					dest = WebUtil.JspURL + "D/D06Ypay/D06YpayPrint_to_year_m.jsp";
				}
				*/
			}

			Logger.debug.println(this, "#####	dest = " + dest);
			
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			
		}
		
	}
	
}
