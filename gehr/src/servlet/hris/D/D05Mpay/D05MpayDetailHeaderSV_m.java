/********************************************************************************/
/*	  System Name  	: g-HR                                                  
/*	  1Depth Name  	: Employee Data                                            
/*	  2Depth Name  	: Payroll                                                     
/*	  Program Name	: Monthly Salary                                                     
/*	  Program ID   		: D05MpayDetailHeaderSV_m.java                                         
/*	  Description  		: 개인의 월급여내역 정보를 jsp로 넘겨주는 class [Non china - 국내사용자용 페이지]            
/*	  Note         		:                                                            
/*	  Creation     		: 2010-08-03 yji
/*   Update				: 2010-10-29 jungin	@v1.0 미국법인 리턴페이지 추가               
 *                           2018/02/21 rdcamel @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel            
 */
/********************************************************************************/

package servlet.hris.D.D05Mpay;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D05Mpay.*;
import hris.D.D05Mpay.rfc.D05LatestPaidRFC;
import hris.D.D05Mpay.rfc.D05MpayDetailRFCGlobal;
import hris.D.D05Mpay.rfc.D05ZocrsnTextRFC;
import hris.common.MappingPernrData;
import hris.common.WebUserData;
import hris.common.rfc.MappingPernrRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * D05MpayDetailHeaderSV_m.java
 * [Non china - 국내사용자용 페이지]
 * 
 * @author yji
 * @version 1.0, 2010-07-14  yji
 */
public class D05MpayDetailHeaderSV_m extends EHRBaseServlet {
	
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			HttpSession session = req.getSession(false);

	        WebUserData user = (WebUserData) session.getAttribute("user");
			WebUserData user_m = (WebUserData) session.getAttribute("user_m");
			
			Logger.debug.println(this, "#####	user.e_area		:	[" + user.e_area + "]");
			Logger.debug.println(this, "#####	user_m.e_area	:	[" + user_m.e_area + "]");
			
			String jobid_m = "";
			String dest = "";
			String flag = "p";
			String yymmdd = "";

			D05MpayDetailRFCGlobal rfc = new D05MpayDetailRFCGlobal();
			
			D05MpayDetailData4 d05MpayDetailData4 = null;
			D05MpayDetailData5 d05MpayDetailData5 = null;
			
			D05MpayDetailData3 data = new D05MpayDetailData3();
			D05MpayDetailData2 data4 = new D05MpayDetailData2();
			D05MpayDetailData1 data6 = new D05MpayDetailData1();	
			D05MpayDetailData1 data7 = new D05MpayDetailData1();	
			
			D05LatestPaidRFC rfc_paid = null;
			D05ZocrsnTextRFC rfc_zocrsn = null;
			
			Vector d05ZocrsnTextData_vt = new Vector();
			Vector d05MpayDetailData1_vt = new Vector();
			Vector d05MpayDetailData2_vt = new Vector();
			Vector d05MpayDetailData3_vt = new Vector();
			Vector d05MpayDetailData4_vt = new Vector();
			Vector d05MpayDetailData5_vt = new Vector();	
			Vector d05MpayDetailData6_vt = new Vector(); 

			// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
			// ----------------------------------------
			MappingPernrRFC mapfunc = null;
			MappingPernrData mapData = new MappingPernrData();
			Vector mapData_vt = new Vector();
			
			String mapPernr = "";
			String mapDate = "";

			String paydt = "";
			String ocrsn = "";
			String seqnr = "";

			String year = "";
			String month = "";
			String yymm = "";

			String year1 = "";
			String month1 = "";
			String ocrsn1 = "";
			String zyymm = "";

			String yyyy = "";
			String mm = "";

			// Annual Salary 에서 넘겨주는 parameter.
			String zocrsn = "";
			String zseqnr = "";
			
			Box box = WebUtil.getBox(req);
			jobid_m = box.get("jobid_m");

			if (jobid_m.equals("")) {
				jobid_m = "first";
			}
			
			zocrsn = box.get("zocrsn");
			zseqnr = box.get("zseqnr");
			
			Logger.debug.println(this, "#####	box	:	[ " + box.toString() + " ]");
			Logger.debug.println(this, "#####	zocrsn	:	[" + zocrsn + "]");
			Logger.debug.println(this, "#####	zseqnr	:	[" + zseqnr + "]");

			if (jobid_m.equals("first")) {

				if (user_m != null) {
					
					rfc_paid = new D05LatestPaidRFC();

//					paydt = rfc_paid.getLatestPaid1(user_m.empNo, user_m.webUserId);
//					ocrsn = rfc_paid.getLatestPaid2(user_m.empNo, user_m.webUserId);
//					seqnr = rfc_paid.getLatestPaid3(user_m.empNo, user_m.webUserId);
	                Vector v = rfc_paid.getLatestPaid(user_m.empNo, user_m.webUserId);  // 5월 21일 추가
					 paydt = (String)Utils.indexOf(v, 0);
					 ocrsn = (String)Utils.indexOf(v, 1);;
					 seqnr = (String)Utils.indexOf(v, 2);;  // 5월 21일 추가

					yyyy = box.get("yyyy");
					mm = box.get("mm");

					year = paydt.substring(0, 4);
					month = paydt.substring(5, 7);
					if (yyyy == null || yyyy.equals("")) {
						yymm = year + month;
						Logger.debug.println(this, "#####	1) yymm		:	[" + year + "] 년	[" + month + "] 월");
					} else {
						yymm = yyyy + mm;
						Logger.debug.println(this, "#####	2) yymm		:	[" + yyyy + "] 년	[" + mm + "] 월");
					}

					// 급여사유 코드와 TEXT
					
					
					rfc_zocrsn = new D05ZocrsnTextRFC();
					d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user_m.empNo, yymm); 	
					

					if (yyyy == null || yyyy.equals("")) {
						
					} else {
						if ((zocrsn == null || zocrsn.equals("")) && (zseqnr == null || zseqnr.equals(""))) {
							ocrsn = ((D05ZocrsnTextData)d05ZocrsnTextData_vt.get(0)).ZOCRSN;
							seqnr = ((D05ZocrsnTextData)d05ZocrsnTextData_vt.get(0)).SEQNR;
						} else {
							ocrsn = zocrsn;
							seqnr = zseqnr;
						}
					}
					yymmdd = yymm + "01";
					
					d05MpayDetailData1_vt = rfc.getMpayDetail(user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					
					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(user_m.empNo, yymmdd, ocrsn, flag, seqnr);

				} // if ( user_m != null ) end

				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);
				
				req.setAttribute("paydt", paydt);
				req.setAttribute("ocrsn", ocrsn);
				req.setAttribute("seqnr", seqnr);
				
				req.setAttribute("yyyy", yyyy);
				req.setAttribute("mm", mm);
				
				req.setAttribute("year", year);
				req.setAttribute("month", month);
				
				// Case of Europe(Poland, Germany)
				if (user_m.e_area.equals("46") || user_m.e_area.equals("01")) {
					dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetail_EC_m.jsp";
				
				// Case of USA
				} else if (user_m.e_area.equals("10")||user_m.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
					dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetail_Global_m.jsp";

				// Case of China & Korea
				} else {
					dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetailHeader_m.jsp";
				}
				
			} else if (jobid_m.equals("getcode")) {

				year = box.get("year1");
				month = box.get("month1");
				yymm = year + month;

				if (user_m != null) {
					
					// 급여사유 코드와 TEXT
						rfc_zocrsn = new D05ZocrsnTextRFC();
						d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user_m.empNo, yymm); 	
					

				} // if ( user_m != null ) end

				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				
				dest = WebUtil.JspURL + "D/D05Mpay/D05Hidden_m.jsp";

				
			} else if (jobid_m.equals("search")) {
				
				year = box.get("year1");
				month = box.get("month1");
				ocrsn = box.get("ocrsn");
				seqnr = ocrsn.substring(2, 7); 
				yymm = year + month;
				ocrsn = ocrsn.substring(0, 2);
				
				if (user_m != null) {
					
					yymmdd = year + month + "25";
					
					// 급여사유 코드와 TEXT
					//rfc_zocrsn = new D05ZocrsnTextRFC();
					//d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user_m.empNo, yymm);

					Logger.debug.println(this, "#####	[search]	선택 년도	:	[" + year + "]");
					Logger.debug.println(this, "#####	[search]	선택 월	:	[" + month + "]");
					Logger.debug.println(this, "#####	[search]	선택 임금유형	:	[" + ocrsn + "]");
					Logger.debug.println(this, "#####	[search]	yymm	:	[" + yymm + "]");
					Logger.debug.println(this, "#####	[search]	seqnr	:	[" + seqnr + "]");
					Logger.debug.println(this, "#####	[search]	flag	:	[" + flag + "]");

					d05MpayDetailData1_vt = rfc.getMpayDetail(user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					
					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					
				} // if ( user_m != null ) end

				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);

				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("ocrsn", ocrsn);
				req.setAttribute("seqnr", seqnr); // 5월 21일 추가

				// Case of Europe(Poland, Germany)
				if (user_m.e_area.equals("46") || user_m.e_area.equals("01")) {
					dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetail_EC_m.jsp";
				
				// Case of USA
				} else if (user_m.e_area.equals("10")||user_m.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
					dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetail_US_m.jsp";

				// Case of China & Korea
				} else {
					dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetailHeader_m.jsp";
				}

				
			} else if (jobid_m.equals("kubya_1")) {
				
				year1 = box.get("year1");
				month1 = box.get("month1");
				ocrsn1 = box.get("ocrsn");
				ocrsn = ocrsn1 + "00000";
				yymm = year1 + month1;

				// Case of Europe(Poland, Germany)
				if (user_m.e_area.equals("46") || user_m.e_area.equals("01")) {
				
					req.setAttribute("print_page_name", 
											WebUtil.ServletURL 
											+ "hris.D.D05Mpay.D05MpayDetailEurpSV_m?jobid_m=kubya_m&year1=" + year1 																
											+ "&month1=" + month1 + "&ocrsn=" + ocrsn);
					
					Logger.debug.println(this, "#####	[EURP] " 
														+ WebUtil.ServletURL 
														+ "hris.D.D05Mpay.D05MpayDetailEurpSV_m?jobid_m=kubya_m&year1=" + year1 
														+ "&month1=" + month1 + "&ocrsn=" + ocrsn);
					
				// Case of USA
				} else if (user_m.e_area.equals("10")||user_m.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
					
						req.setAttribute("print_page_name", 
												WebUtil.ServletURL 
												+ "hris.D.D05Mpay.D05MpayDetailGlobalSV_m?jobid_m=kubya_m&year1=" + year1 																
												+ "&month1=" + month1 + "&ocrsn=" + ocrsn);
						
						Logger.debug.println(this, "#####	[USA] " 
															+ WebUtil.ServletURL 
															+ "hris.D.D05Mpay.D05MpayDetailGlobalSV_m?jobid_m=kubya_m&year1=" + year1 
															+ "&month1=" + month1 + "&ocrsn=" + ocrsn);
	
				// Case of China & Korea	
				} else {
					req.setAttribute("print_page_name", 
											WebUtil.ServletURL 
											+ "hris.D.D05Mpay.D05MpayDetailSV_m?jobid_m=kubya_m&year1=" + year1 
											+ "&month1=" + month1 + "&ocrsn=" + ocrsn);
					
					Logger.debug.println(this,	"#####	[CN & KR] " 
														+ WebUtil.ServletURL 
														+ "hris.D.D05Mpay.D05MpayDetailSV_m?jobid_m=kubya_m&year1=" + year1 
														+ "&month1=" + month1 + "&ocrsn=" + ocrsn);
				}
				
				dest = WebUtil.JspURL + "common/printFrame_m.jsp";
		
			} else if (jobid_m.equals("kubya_1_m")) {
				
				year1 = box.get("year1");
				month1 = box.get("month1");
				ocrsn1 = box.get("ocrsn");
				ocrsn = ocrsn1 + "00000";
				yymm = year1 + month1;

				// Case of Europe(Poland, Germany)
				if (user_m.e_area.equals("46") || user_m.e_area.equals("01")) {
					
					req.setAttribute("print_page_name",
											WebUtil.ServletURL
											+ "hris.D.D05Mpay.D05MpayDetailEurpSV_m?jobid_m=kubya_m&year1=" + year1 
											+ "&month1=" + month1+ "&ocrsn=" + ocrsn); 

					Logger.debug.println(this, "#####	[EURP] "
														+ WebUtil.ServletURL
														+ "hris.D.D05Mpay.D05MpayDetailEurpSV_m?jobid_m=kubya_m&year1=" + year1 
														+ "&month1=" + month1+ "&ocrsn=" + ocrsn);

				// Case of USA
				} else if (user_m.e_area.equals("10")||user_m.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
						
						req.setAttribute("print_page_name",
												WebUtil.ServletURL
												+ "hris.D.D05Mpay.D05MpayDetailGlobalSV_m?jobid_m=kubya_m&year1=" + year1 
												+ "&month1=" + month1+ "&ocrsn=" + ocrsn); 

						Logger.debug.println(this, "#####	[USA] "
															+ WebUtil.ServletURL
															+ "hris.D.D05Mpay.D05MpayDetailGlobalSV_m?jobid_m=kubya_m&year1=" + year1 
															+ "&month1=" + month1 + "&ocrsn=" + ocrsn);
						
				// Case of China & Korea		
				} else {
				
					req.setAttribute("print_page_name",
											WebUtil.ServletURL
											+ "hris.D.D05Mpay.D05MpayDetailSV_m?jobid_m=kubya_m&year1=" + year1 
											+ "&month1=" + month1 + "&ocrsn=" + ocrsn);
					
					
					Logger.debug.println(this, "#####	[CN & KR] "
														+ WebUtil.ServletURL
														+ "hris.D.D05Mpay.D05MpayDetailSV_m?jobid_m=kubya_m&year1=" + year1 
														+ "&month1=" + month1 + "&ocrsn=" + ocrsn);
					
					dest = WebUtil.JspURL + "common/printFrame_m.jsp";
				}
				
			} else if (jobid_m.equals("kubya_m")) {

				year = box.get("year1");
				month = box.get("month1");
				ocrsn = box.get("ocrsn");
				seqnr = ocrsn.substring(2, 7);
				yymm = year + month;
				yymmdd = year + month + "25";
				ocrsn = ocrsn.substring(0, 2);

				// 급여사유 코드와 TEXT
					rfc_zocrsn = new D05ZocrsnTextRFC();
					d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user_m.empNo, yymm); 	
				

				Logger.debug.println(this, "#####	[kubya_m]	선택 년도	:	[" + year + "]");
				Logger.debug.println(this, "#####	[kubya_m]	선택 월	:	[" + month + "]");
				Logger.debug.println(this, "#####	[kubya_m]	선택 임금유형	:	[" + ocrsn + "]");
				Logger.debug.println(this, "#####	[kubya_m]	yymm	:	[" + yymm + "]");
				Logger.debug.println(this, "#####	[kubya_m]	seqnr	:	[" + seqnr + "]");
				Logger.debug.println(this, "#####	[kubya_m]	flag	:	[" + flag + "]");

				 rfc = new D05MpayDetailRFCGlobal();
				 
				 d05MpayDetailData4 = null;
				 d05MpayDetailData5 = null;
				 data = new D05MpayDetailData3();
				 data4 = new D05MpayDetailData2();
				 data6 = new D05MpayDetailData1();
				 data7 = new D05MpayDetailData1();
				
				d05MpayDetailData1_vt = rfc.getMpayDetail(user_m.empNo, yymmdd, ocrsn, flag, seqnr);
				 
				d05MpayDetailData4_vt = new Vector();
				d05MpayDetailData5_vt = new Vector();
				d05MpayDetailData6_vt = new Vector();

				d05MpayDetailData4 = (D05MpayDetailData4)rfc.getPerson(user_m.empNo, yymmdd, ocrsn, flag, seqnr); 
				d05MpayDetailData5 = (D05MpayDetailData5)rfc.getPaysum(user_m.empNo, yymmdd, ocrsn, flag, seqnr); 

				req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("ocrsn", ocrsn);
				req.setAttribute("seqnr", seqnr); 
			
				// Case of Europe(Poland, Germany)
				if (user_m.e_area.equals("46") || user_m.e_area.equals("01")) {
					dest = WebUtil.JspURL + "D/D05Mpay/D05MpayhwahakGlobal_m.jsp";
				
				// Case of USA
				} else if (user_m.e_area.equals("10")||user_m.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
					dest = WebUtil.JspURL + "D/D05Mpay/D05MpayhwahakUsa_m.jsp";
					
				// Case of China & Korea
				} else {
					dest = WebUtil.JspURL + "D/D05Mpay/D05Mpayhwahak_m.jsp";
				}

			} else if (jobid_m.equals("month_kubyo")) {

				zyymm = box.get("zyymm");
				year = zyymm.substring(0, 4);
				month = zyymm.substring(4);
				ocrsn = "ZZ";
				seqnr = "";
				yymm = year + month;

				if (user_m != null) {
					
					// lg화학과 석유화학을 구별(휴가일수)
					if (user_m.companyCode.equals("C100")) {
						yymmdd = year + month + "20";
					} else {
						yymmdd = year + month + "15";
					}

					mapfunc = new MappingPernrRFC();
					mapData_vt = mapfunc.getPernr(user_m.empNo);
					mapDate = "";
					int cnt = 0;

					if (user_m.companyCode.equals("C100") && mapData_vt != null
							&& mapData_vt.size() > 0) {
						cnt = mapData_vt.size();
						for (int i = 0; i < mapData_vt.size(); i++) {
							mapData = (MappingPernrData) mapData_vt.get(i);
							mapDate = DataUtil.delDateGubn(mapData.BEGDA);
							mapDate = mapDate.substring(0, 6);

							if (Integer.parseInt(yymm) >= Integer
									.parseInt(mapDate)) {
								cnt--;
							}
						}

						if (cnt == mapData_vt.size()) {
							mapPernr = user_m.empNo;
						} else {
							mapData = (MappingPernrData) mapData_vt.get(cnt);
							mapPernr = mapData.PERNR;
						}
					} else {
						mapPernr = user_m.empNo;
					}
					// /-----------------------------------------------------------------------------------

					// 급여사유 코드와 TEXT
					rfc_zocrsn = new D05ZocrsnTextRFC();
					d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user_m.empNo, yymm); 	
					

					Logger.debug.println(this, "#####	[month_kubyo]	선택 년도	:	[" + year + "]");
					Logger.debug.println(this, "#####	[month_kubyo]	선택 월	:	[" + month + "]");
					Logger.debug.println(this, "#####	[month_kubyo]	선택 임금유형	:	[" + ocrsn + "]");
					Logger.debug.println(this, "#####	[month_kubyo]	yymm	:	[" + yymm + "]");
					Logger.debug.println(this, "#####	[month_kubyo]	seqnr	:	[" + seqnr + "]");
					Logger.debug.println(this, "#####	[month_kubyo]	flag	:	[" + flag + "]");
					
					rfc = new D05MpayDetailRFCGlobal();
					d05MpayDetailData4 = null;
					d05MpayDetailData5 = null;
					data = new D05MpayDetailData3();
					data4 = new D05MpayDetailData2();	
					data6 = new D05MpayDetailData1();	
					data7 = new D05MpayDetailData1();

					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData4_vt = new Vector();
					d05MpayDetailData5_vt = new Vector();	
					d05MpayDetailData6_vt = new Vector();	
					
					for (int i = 0; i < d05MpayDetailData3_vt.size(); i++) {
						data = (D05MpayDetailData3) d05MpayDetailData3_vt.get(i);
						D05MpayDetailData3 data1 = new D05MpayDetailData3();
						D05MpayDetailData3 data2 = new D05MpayDetailData3();
						D05MpayDetailData3 data3 = new D05MpayDetailData3();

						data1.LGTX1 = data.LGTX1;
						data1.BET01 = data.BET01;
						data2.LGTX1 = data.LGTX2;
						data2.BET01 = data.BET02;
						data3.LGTX1 = data.LGTX3;
						data3.BET01 = data.BET03;

						d05MpayDetailData4_vt.addElement(data1);
						d05MpayDetailData4_vt.addElement(data2);
						d05MpayDetailData4_vt.addElement(data3);
					}

					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr); 
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr); 

					// 지급내역 text 2002/02/21
					for (int i = 0; i < d05MpayDetailData2_vt.size(); i++) {
						data4 = (D05MpayDetailData2) d05MpayDetailData2_vt.get(i);
						D05MpayDetailData2 data5 = new D05MpayDetailData2();

						if (!data4.LGTXT.equals("")) {
							data5.LGTXT = data4.LGTXT;
							data5.ANZHL = data4.ANZHL;
							data5.BET01 = data4.BET01;

							d05MpayDetailData5_vt.addElement(data5);
						}
					}

					for (int i = 0; i < d05MpayDetailData1_vt.size(); i++) {
						data6 = (D05MpayDetailData1) d05MpayDetailData1_vt.get(i);
						D05MpayDetailData1 data8 = new D05MpayDetailData1();
						
						String LGT = (String) data6.LGTXT + "(현지화)";

						for (int j = 0; j < d05MpayDetailData1_vt.size(); j++) {
							
							data7 = (D05MpayDetailData1) d05MpayDetailData1_vt.get(j);

							if (LGT.equals((String) data7.LGTX1)) {
								data8.LGTXT = data6.LGTXT;
								data8.LGTX1 = data7.LGTX1;
								data8.BET01 = data6.BET01;
								data8.BET02 = data6.BET02;
								data8.BET03 = data7.BET03;
								break;
								
							} else {
								data8.LGTXT = data6.LGTXT;
								data8.LGTX1 = "";
								data8.BET01 = data6.BET01;
								data8.BET02 = data6.BET02;
								data8.BET03 = "0";
							}
						}
						d05MpayDetailData6_vt.addElement(data8);
					}
					
				} // if ( user_m != null ) end

				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
				req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
				req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
				req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
				req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt);		
				req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); 	

				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);

				dest = WebUtil.JspURL + "D/D06Ypay/D06MpayDetail_m.jsp";
			}
			
			Logger.debug.println(this, "#####	dest = " + dest);
			
			printJspPage(req, res, dest);
			
		} catch (Exception e) {
			throw new GeneralException(e);
		}
		
	}
	
}
