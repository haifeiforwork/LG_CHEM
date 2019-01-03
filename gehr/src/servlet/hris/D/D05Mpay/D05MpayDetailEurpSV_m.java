/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 월급여                                                      */
/*   Program Name : 월급여                                                      */
/*   Program ID     : D05MpayDetailEurpSV_m                                           */
/*   Description     : 개인의 월급여내역 정보를 jsp로 넘겨주는 class[유럽용]               */
/*   Note             :                                                             */
/*   Creation        : 2010-07-01  yji                                        */
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
 * D05MpayDetailSV.java 개인의 월급여내역 정보를 jsp로 넘겨주는 class 개인의 월급여내역 정보를 가져오는
 * D05MpayDetailRFCGlobal를 호출하여 D04VocationDetail.jsp로 개인의 월급여내역 정보를 넘겨준다.
 * 
 * @author yji
 * @version 1.0, 2010/07/01
 */
public class D05MpayDetailEurpSV_m extends EHRBaseServlet {
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			HttpSession session = req.getSession(false);
			WebUserData user_m = (WebUserData) session.getAttribute("user_m");

            if(!"X".equals(user_m.e_mss)) {
                req.setAttribute("title", "COMMON.MENU.ESS_PY_MONT_PAY");
                req.setAttribute("servlet", "hris.D.D05Mpay.D05MpayDetailEurpSV_m");
            	
            	 printJspPage(req, res, WebUtil.JspURL+"common/MSS_SearchPernNameOrg.jsp");
            	 return;
            }

			String jobid_m = "";
			String dest = "";
			String flag = "p";
			String yymmdd = "";

			D05MpayDetailRFCGlobal rfc = new D05MpayDetailRFCGlobal();
			D05MpayDetailData4 d05MpayDetailData4 = null;
			D05MpayDetailData5 d05MpayDetailData5 = null;
			D05MpayDetailData3 data = new D05MpayDetailData3();
			D05MpayDetailData2 data4 = new D05MpayDetailData2();// 추가 2002/02/21
			D05MpayDetailData1 data6 = new D05MpayDetailData1();// 추가(해외급여)추가
																// 2002/02/21
			D05MpayDetailData1 data7 = new D05MpayDetailData1();// 추가(해외급여)추가
																// 2002/02/21
			D05LatestPaidRFC rfc_paid = null;
			D05ZocrsnTextRFC rfc_zocrsn = null;
			Vector d05ZocrsnTextData_vt = new Vector();
			Vector d05MpayDetailData1_vt = new Vector();
			Vector d05MpayDetailData2_vt = new Vector();
			Vector d05MpayDetailData3_vt = new Vector();
			Vector d05MpayDetailData4_vt = new Vector();
			Vector d05MpayDetailData5_vt = new Vector(); // 추가 2002/02/21
			Vector d05MpayDetailData6_vt = new Vector(); // 추가(해외급여)
															// 2002/02/21

			// // 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
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

			Box box = WebUtil.getBox(req);
			jobid_m = box.get("jobid_m");

			if (jobid_m.equals("")) {
				jobid_m = "first";
			}

			if (jobid_m.equals("first")) {

				if (user_m != null) {
					Logger.debug.println(this, "[jobid_m] = " + jobid_m
							+ " [user_m] : " + user_m.toString());

					rfc_paid = new D05LatestPaidRFC();

//					paydt = rfc_paid.getLatestPaid1(user_m.empNo, user_m.webUserId);
//					ocrsn = rfc_paid.getLatestPaid2(user_m.empNo, user_m.webUserId);
//					seqnr = rfc_paid.getLatestPaid3(user_m.empNo, user_m.webUserId); // 5월 21일 추가
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
						Logger.debug.println(this, "year = " + year
								+ "month = " + month);
					} else {
						yymm = yyyy + mm;
						Logger.debug.println(this, "yyyy = " + yyyy + "mm = "
								+ mm);
					}

					rfc_zocrsn = new D05ZocrsnTextRFC();

					d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(
							user_m.empNo, yymm); // 급여사유 코드와 TEXT

					if (yyyy == null || yyyy.equals("")) {
					} else {
						ocrsn = ((D05ZocrsnTextData) d05ZocrsnTextData_vt
								.get(0)).ZOCRSN;
						seqnr = ((D05ZocrsnTextData) d05ZocrsnTextData_vt
								.get(0)).SEQNR;
					}
									
					
					yymmdd = yymm + "25";
					
					Logger.debug.println("[user_m.empNo] "+ user_m.empNo  + " [yymmdd] " + yymmdd + " [ocrsn] " +  ocrsn + " [flag] " +  flag + " [seqnr] " + seqnr);
					
					d05MpayDetailData1_vt = rfc.getMpayDetail(user_m.empNo,
							yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);

					Logger.debug.println(this, " 지급내역size : "
							+ d05MpayDetailData5_vt.size());
					Logger.debug.println(this, " 지급내역text : "
							+ d05MpayDetailData5_vt.toString());

					Logger.debug.println(this, " 해외내역수정 : "
							+ d05MpayDetailData6_vt.toString());
					// //////////////////////////////////////////////////////////////////////////
					Logger.debug.println(this, "해외급여 반영내역(항목) 내역 : "
							+ d05MpayDetailData1_vt.toString());
					Logger.debug.println(this, "지급내역/공제내역  : "
							+ d05MpayDetailData2_vt.toString());
					Logger.debug.println(this, "과세추가내역2 : "
							+ d05MpayDetailData3_vt.toString());

					Logger.debug.println(this, "급여명세표 - 개인정보/환율 내역  : "
							+ d05MpayDetailData4.toString());
					Logger.debug.println(this, "지급내역/공제내역 합  : "
							+ d05MpayDetailData5.toString());
				} // if ( user_m != null ) end

				req
						.setAttribute("d05MpayDetailData1_vt",
								d05MpayDetailData1_vt);

				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);

				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("paydt", paydt);
				req.setAttribute("ocrsn", ocrsn);

				req.setAttribute("yyyy", yyyy);
				req.setAttribute("mm", mm);

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("ocrsn", ocrsn + seqnr);
				req.setAttribute("seqnr", seqnr); // 5월 21일 추가

				dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetail_EC_m.jsp";

			} else if (jobid_m.equals("getcode")) {

				year = box.get("year1");
				month = box.get("month1");
				yymm = year + month;

				if (user_m != null) {
					Logger.debug.println(this, "[jobid_m] = " + jobid_m
							+ " [user_m] : " + user_m.toString());

					rfc_zocrsn = new D05ZocrsnTextRFC();
					d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(
							user_m.empNo, yymm); // 급여사유 코드와 TEXT

				} // if ( user_m != null ) end

				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				dest = WebUtil.JspURL + "D/D05Mpay/D05Hidden_m.jsp";

			} else if (jobid_m.equals("search") || jobid_m.equals("search_back")) {
				year = box.get("year1");
				month = box.get("month1");
				ocrsn = box.get("ocrsn");
				seqnr = ocrsn.substring(2, 7); // 5월 21일 순번 추가
				yymm = year + month;
				ocrsn = ocrsn.substring(0, 2);
				if (user_m != null) {
					yymmdd = year + month + "25";
					rfc_zocrsn = new D05ZocrsnTextRFC();
					d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(
							user_m.empNo, yymm); // 급여사유 코드와 TEXT

					Logger.debug.println(this, "선택한 년도 : " + year + "선택한 월:"
							+ month + "선택한 임금유형:" + ocrsn + "yymm;" + yymm
							+ "seqnr :" + seqnr);
					Logger.debug.println(this, "급여사유 코드와 TEXT : "
							+ d05ZocrsnTextData_vt.toString());

					d05MpayDetailData1_vt = rfc.getMpayDetail(user_m.empNo,
							yymmdd, ocrsn, flag, seqnr);

					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);
				} // if ( user_m != null ) end

				req
						.setAttribute("d05MpayDetailData1_vt",
								d05MpayDetailData1_vt);
				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("ocrsn", ocrsn + seqnr);
				req.setAttribute("seqnr", seqnr); // 5월 21일 추가
           		req.setAttribute("backBtn",  jobid_m.equals("search_back")?"Y":"" );  // 되돌아가기 버튼활성

				dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetail_EC_m.jsp";

			} else if (jobid_m.equals("kubya_1")) {
				year1 = box.get("year1");
				month1 = box.get("month1");
				ocrsn1 = box.get("ocrsn");
				ocrsn = ocrsn1 + "00000";
				yymm = year1 + month1;

				req
						.setAttribute(
								"print_page_name",
								WebUtil.ServletURL
										+ "hris.D.D05Mpay.D05MpayDetailEurpSV_m?jobid_m=kubya_m&year1="
										+ year1 + "&month1=" + month1
										+ "&ocrsn=" + ocrsn); // 5월 21일 순번 추가
				dest = WebUtil.JspURL + "common/printFrame_m.jsp";
				Logger.debug
						.println(
								this,
								WebUtil.ServletURL
										+ "hris.D.D05Mpay.D05MpayDetailEurpSV_m?jobid_m=kubya_m&year1="
										+ year1 + "&month1=" + month1
										+ "&ocrsn=" + ocrsn); // 5월 21일 순번 추가.
				
			} else if (jobid_m.equals("kubya_1_m")) {
				year1 = box.get("year1");
				month1 = box.get("month1");
				ocrsn1 = box.get("ocrsn");
				ocrsn = ocrsn1 + "00000";
				yymm = year1 + month1;

				req
						.setAttribute(
								"print_page_name",
								WebUtil.ServletURL
										+ "hris.D.D05Mpay.D05MpayDetailEurpSV_m?jobid_m=kubya_m&year1="
										+ year1 + "&month1=" + month1
										+ "&ocrsn=" + ocrsn); // 5월 21일 순번 추가
				dest = WebUtil.JspURL + "common/printFrame_m.jsp";
				Logger.debug
						.println(
								this,
								WebUtil.ServletURL
										+ "hris.D.D05Mpay.D05MpayDetailEurpSV_m?jobid_m=kubya_m&year1="
										+ year1 + "&month1=" + month1
										+ "&ocrsn=" + ocrsn); // 5월 21일 순번 추가.
				/*
			} else if (jobid_m.equals("kubya_m")) {
				year = box.get("year1");
				month = box.get("month1");
				ocrsn = box.get("ocrsn");
				seqnr = ocrsn.substring(2, 7); // 5월 21일 순번 추가
				yymm = year + month;

				if (user_m != null) {
					Logger.debug.println(this, "[jobid_m] = " + jobid_m
							+ " [user_m] : " + user_m.toString());

					mapfunc = new MappingPernrRFC();
					mapData_vt = mapfunc.getPernr(user_m.empNo);
					mapDate = "";

					// /-----------------------------------------------------------------------------------

					rfc_zocrsn = new D05ZocrsnTextRFC();
					d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr,
							yymm); // 급여사유 코드와 TEXT

					Logger.debug.println(this, "선택한 년도 : " + year + "선택한 월:"
							+ month + "선택한 임금유형:" + ocrsn + "yymm;" + yymm
							+ "순번:" + seqnr);
					Logger.debug.println(this, "급여사유 코드와 TEXT : "
							+ d05ZocrsnTextData_vt.toString());

					rfc = new D05MpayDetailRFCGlobal();
					d05MpayDetailData4 = null;
					d05MpayDetailData5 = null;
					data = new D05MpayDetailData3();
					data4 = new D05MpayDetailData2();// 추가 2002/02/21
					data6 = new D05MpayDetailData1();// 추가(해외급여)추가 2002/02/21
					data7 = new D05MpayDetailData1();// 추가(해외급여)추가 2002/02/21

					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData4_vt = new Vector();
					d05MpayDetailData5_vt = new Vector();// 추가 2002/02/21
					d05MpayDetailData6_vt = new Vector();// 추가(해외급여)
															// 2002/02/21

					Logger.debug.println(this, " 변형 과세추가내역 : "
							+ d05MpayDetailData4_vt.toString());

					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
							mapPernr, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
																	// 추가
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
							mapPernr, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
																	// 추가

					// 지급내역 text 2002/02/21

					Logger.debug.println(this, " 지급내역size : "
							+ d05MpayDetailData5_vt.size());
					Logger.debug.println(this, " 지급내역text : "
							+ d05MpayDetailData5_vt.toString());

					Logger.debug.println(this, " 해외내역수정 : "
							+ d05MpayDetailData6_vt.toString());
					// //////////////////////////////////////////////////////////////////////////
					Logger.debug.println(this, "해외급여 반영내역(항목) 내역 : "
							+ d05MpayDetailData1_vt.toString());
					Logger.debug.println(this, "지급내역/공제내역  : "
							+ d05MpayDetailData1_vt.toString());
					Logger.debug.println(this, "과세추가내역 : "
							+ d05MpayDetailData1_vt.toString());

					Logger.debug.println(this, "급여명세표 - 개인정보/환율 내역  : "
							+ d05MpayDetailData4.toString());
					Logger.debug.println(this, "지급내역/공제내역 합  : "
							+ d05MpayDetailData5.toString());
				} // if ( user_m != null ) end

				req
						.setAttribute("d05MpayDetailData1_vt",
								d05MpayDetailData1_vt);
				req
						.setAttribute("d05MpayDetailData2_vt",
								d05MpayDetailData2_vt);
				req
						.setAttribute("d05MpayDetailData3_vt",
								d05MpayDetailData3_vt);
				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				req
						.setAttribute("d05MpayDetailData4_vt",
								d05MpayDetailData4_vt);
				req
						.setAttribute("d05MpayDetailData5_vt",
								d05MpayDetailData5_vt); // 추가 2002/02/21
				req
						.setAttribute("d05MpayDetailData6_vt",
								d05MpayDetailData6_vt); // 해외지급내역수정 추가
														// 2002/02/21

				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("ocrsn", ocrsn);
				req.setAttribute("seqnr", seqnr); // 5월 21일 순번 추가

				dest = WebUtil.JspURL + "D/D06Ypay/D06Mpayhwahak_m.jsp";
				*/
			} else if (jobid_m.equals("kubya_m")) {

				year = box.get("year1");
				month = box.get("month1");
				ocrsn = box.get("ocrsn");
				seqnr = ocrsn.substring(2, 7); // 5월 21일 순번 추가
				yymm = year + month;
				yymmdd = year + month + "25";
				ocrsn = ocrsn.substring(0, 2);

				rfc_zocrsn = new D05ZocrsnTextRFC();
				d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(
						user_m.empNo, yymm); // 급여사유 코드와 TEXT

				Logger.debug.println(this, "선택한 년도 : " + year + "선택한 월:"
						+ month + "선택한 임금유형:" + ocrsn + "yymm;" + yymm + "순번:"
						+ seqnr);

				 rfc = new D05MpayDetailRFCGlobal();
				 d05MpayDetailData4 = null;
				 d05MpayDetailData5 = null;
				 data = new D05MpayDetailData3();
				 data4 = new D05MpayDetailData2();// 추가
				// 2002/02/21
				 data6 = new D05MpayDetailData1();// 추가(해외급여)추가
				// 2002/02/21
				 data7 = new D05MpayDetailData1();// 추가(해외급여)추가
				// 2002/02/21

				Logger.debug.println(this, "user.empNo:" + user_m.empNo  + "  년도 : " + yymmdd 
						 + "선택한 임금유형:" + ocrsn + "flag;" + flag + "seqnr:"
						+ seqnr);
				
				 d05MpayDetailData1_vt = rfc.getMpayDetail(user_m.empNo,
						yymmdd, ocrsn, flag, seqnr);
				 d05MpayDetailData4_vt = new Vector();
				 d05MpayDetailData5_vt = new Vector();// 추가 2002/02/21
				 d05MpayDetailData6_vt = new Vector();// 추가(해외급여)

				d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
						user_m.empNo, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
				// 추가
				d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
						user_m.empNo, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
				// 추가

				req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);

				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("ocrsn", ocrsn);
				req.setAttribute("seqnr", seqnr); // 5월 21일 순번 추가

				dest = WebUtil.JspURL + "D/D05Mpay/D05MpayhwahakGlobal_m.jsp";
				
				/*
				year = box.get("year1");
				month = box.get("month1");
				ocrsn = box.get("ocrsn");
				seqnr = ocrsn.substring(2, 7); // 5월 21일 순번 추가
				yymm = year + month;

				if (user_m != null) {
					Logger.debug.println(this, "[jobid_m] = " + jobid_m
							+ " [user_m] : " + user_m.toString());

					// lg화학과 석유화학을 구별(휴가일수)
					if (user_m.companyCode.equals("C100")) {
						yymmdd = year + month + "20";
					} else {
						yymmdd = year + month + "15";
					}

					/*mapfunc = new MappingPernrRFC();
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
					}*/
					// /-----------------------------------------------------------------------------------
/*
					rfc_zocrsn = new D05ZocrsnTextRFC();
					//d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm); // 급여사유 코드와 TEXT
					d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user_m.empNo, yymm); // 급여사유 코드와 TEXT

					Logger.debug.println(this, "선택한 년도 : " + year + "선택한 월:"
							+ month + "선택한 임금유형:" + ocrsn + "yymm;" + yymm
							+ "순번:" + seqnr);
					Logger.debug.println(this, "급여사유 코드와 TEXT : "
							+ d05ZocrsnTextData_vt.toString());

					rfc = new D05MpayDetailRFCGlobal();
					d05MpayDetailData4 = null;
					d05MpayDetailData5 = null;
					data = new D05MpayDetailData3();
					data4 = new D05MpayDetailData2();// 추가 2002/02/21
					data6 = new D05MpayDetailData1();// 추가(해외급여)추가 2002/02/21
					data7 = new D05MpayDetailData1();// 추가(해외급여)추가 2002/02/21

					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData4_vt = new Vector();
					d05MpayDetailData5_vt = new Vector();// 추가 2002/02/21
					d05MpayDetailData6_vt = new Vector();// 추가(해외급여)
															// 2002/02/21

					Logger.debug.println(this, "과세추가내역1 : "
							+ d05MpayDetailData3_vt.toString());
					for (int i = 0; i < d05MpayDetailData3_vt.size(); i++) {
						data = (D05MpayDetailData3) d05MpayDetailData3_vt
								.get(i);
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
					Logger.debug.println(this, " 변형 과세추가내역 : "
							+ d05MpayDetailData4_vt.toString());

					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
							mapPernr, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
																	// 추가
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
							mapPernr, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
																	// 추가

					// 지급내역 text 2002/02/21
					for (int i = 0; i < d05MpayDetailData2_vt.size(); i++) {
						data4 = (D05MpayDetailData2) d05MpayDetailData2_vt
								.get(i);
						D05MpayDetailData2 data5 = new D05MpayDetailData2();

						if (!data4.LGTXT.equals("")) {
							data5.LGTXT = data4.LGTXT;
							data5.ANZHL = data4.ANZHL;
							data5.BET01 = data4.BET01;

							d05MpayDetailData5_vt.addElement(data5);
						}
					}
					Logger.debug.println(this, " 지급내역size : "
							+ d05MpayDetailData5_vt.size());
					Logger.debug.println(this, " 지급내역text : "
							+ d05MpayDetailData5_vt.toString());

					for (int i = 0; i < d05MpayDetailData1_vt.size(); i++) {
						data6 = (D05MpayDetailData1) d05MpayDetailData1_vt
								.get(i);
						D05MpayDetailData1 data8 = new D05MpayDetailData1();
						String LGT = (String) data6.LGTXT + "(현지화)";

						for (int j = 0; j < d05MpayDetailData1_vt.size(); j++) {
							data7 = (D05MpayDetailData1) d05MpayDetailData1_vt
									.get(j);

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

						Logger.debug.println(this, "통과");
						d05MpayDetailData6_vt.addElement(data8);
					}
					Logger.debug.println(this, " 해외내역수정 : "
							+ d05MpayDetailData6_vt.toString());
					// //////////////////////////////////////////////////////////////////////////
					Logger.debug.println(this, "해외급여 반영내역(항목) 내역 : "
							+ d05MpayDetailData1_vt.toString());
					Logger.debug.println(this, "지급내역/공제내역  : "
							+ d05MpayDetailData1_vt.toString());
					Logger.debug.println(this, "과세추가내역 : "
							+ d05MpayDetailData1_vt.toString());

					Logger.debug.println(this, "급여명세표 - 개인정보/환율 내역  : "
							+ d05MpayDetailData4.toString());
					Logger.debug.println(this, "지급내역/공제내역 합  : "
							+ d05MpayDetailData5.toString());
				} // if ( user_m != null ) end

				req
						.setAttribute("d05MpayDetailData1_vt",
								d05MpayDetailData1_vt);
				req
						.setAttribute("d05MpayDetailData2_vt",
								d05MpayDetailData2_vt);
				req
						.setAttribute("d05MpayDetailData3_vt",
								d05MpayDetailData3_vt);
				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				req
						.setAttribute("d05MpayDetailData4_vt",
								d05MpayDetailData4_vt);
				req
						.setAttribute("d05MpayDetailData5_vt",
								d05MpayDetailData5_vt); // 추가 2002/02/21
				req
						.setAttribute("d05MpayDetailData6_vt",
								d05MpayDetailData6_vt); // 해외지급내역수정 추가
														// 2002/02/21

				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("ocrsn", ocrsn);
				req.setAttribute("seqnr", seqnr); // 5월 21일 순번 추가

				dest = WebUtil.JspURL + "D/D05Mpay/D05MpayhwahakGlobal_m.jsp";
*/
			} else if (jobid_m.equals("month_kubyo")) {

				zyymm = box.get("zyymm");
				year = zyymm.substring(0, 4);
				month = zyymm.substring(4);
				ocrsn = "ZZ";
				seqnr = "";
				yymm = year + month;

				if (user_m != null) {
					Logger.debug.println(this, "[jobid_m] = " + jobid_m
							+ " [user_m] : " + user_m.toString());

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

					rfc_zocrsn = new D05ZocrsnTextRFC();
					d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr,
							yymm); // 급여사유 코드와 TEXT

					Logger.debug.println(this, "선택한 년도 : " + year + "선택한 월:"
							+ month + "선택한 임금유형:" + ocrsn + "yymm;" + yymm);
					Logger.debug.println(this, "급여사유 코드와 TEXT : "
							+ d05ZocrsnTextData_vt.toString());

					rfc = new D05MpayDetailRFCGlobal();
					d05MpayDetailData4 = null;
					d05MpayDetailData5 = null;
					data = new D05MpayDetailData3();
					data4 = new D05MpayDetailData2();// 추가 2002/02/21
					data6 = new D05MpayDetailData1();// 추가(해외급여)추가 2002/02/21
					data7 = new D05MpayDetailData1();// 추가(해외급여)추가 2002/02/21

					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
							user_m.empNo, yymmdd, ocrsn, flag, seqnr);
					d05MpayDetailData4_vt = new Vector();
					d05MpayDetailData5_vt = new Vector();// 추가 2002/02/21
					d05MpayDetailData6_vt = new Vector();// 추가(해외급여)
															// 2002/02/21

					Logger.debug.println(this, "과세추가내역1 : "
							+ d05MpayDetailData3_vt.toString());
					for (int i = 0; i < d05MpayDetailData3_vt.size(); i++) {
						data = (D05MpayDetailData3) d05MpayDetailData3_vt
								.get(i);
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
					Logger.debug.println(this, " 변형 과세추가내역 : "
							+ d05MpayDetailData4_vt.toString());

					d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
							mapPernr, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
																	// 추가
					d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
							mapPernr, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
																	// 추가

					// 지급내역 text 2002/02/21
					for (int i = 0; i < d05MpayDetailData2_vt.size(); i++) {
						data4 = (D05MpayDetailData2) d05MpayDetailData2_vt
								.get(i);
						D05MpayDetailData2 data5 = new D05MpayDetailData2();

						if (!data4.LGTXT.equals("")) {
							data5.LGTXT = data4.LGTXT;
							data5.ANZHL = data4.ANZHL;
							data5.BET01 = data4.BET01;

							d05MpayDetailData5_vt.addElement(data5);
						}
					}
					Logger.debug.println(this, " 지급내역size : "
							+ d05MpayDetailData5_vt.size());
					Logger.debug.println(this, " 지급내역text : "
							+ d05MpayDetailData5_vt.toString());

					for (int i = 0; i < d05MpayDetailData1_vt.size(); i++) {
						data6 = (D05MpayDetailData1) d05MpayDetailData1_vt
								.get(i);
						D05MpayDetailData1 data8 = new D05MpayDetailData1();
						String LGT = (String) data6.LGTXT + "(현지화)";

						for (int j = 0; j < d05MpayDetailData1_vt.size(); j++) {
							data7 = (D05MpayDetailData1) d05MpayDetailData1_vt
									.get(j);

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
						Logger.debug.println(this, "통과");
						d05MpayDetailData6_vt.addElement(data8);
					}
					Logger.debug.println(this, " 해외내역수정 : "
							+ d05MpayDetailData6_vt.toString());

					Logger.debug.println(this, "해외급여 반영내역(항목) 내역 : "
							+ d05MpayDetailData1_vt.toString());
					Logger.debug.println(this, "지급내역/공제내역  : "
							+ d05MpayDetailData1_vt.toString());
					Logger.debug.println(this, "과세추가내역 : "
							+ d05MpayDetailData1_vt.toString());

					Logger.debug.println(this, "급여명세표 - 개인정보/환율 내역  : "
							+ d05MpayDetailData4.toString());
					Logger.debug.println(this, "지급내역/공제내역 합  : "
							+ d05MpayDetailData5.toString());
				} // if ( user_m != null ) end

				req
						.setAttribute("d05MpayDetailData1_vt",
								d05MpayDetailData1_vt);
				req
						.setAttribute("d05MpayDetailData2_vt",
								d05MpayDetailData2_vt);
				req
						.setAttribute("d05MpayDetailData3_vt",
								d05MpayDetailData3_vt);
				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				req
						.setAttribute("d05MpayDetailData4_vt",
								d05MpayDetailData4_vt);
				req
						.setAttribute("d05MpayDetailData5_vt",
								d05MpayDetailData5_vt); // 추가 2002/02/21
				req
						.setAttribute("d05MpayDetailData6_vt",
								d05MpayDetailData6_vt); // 해외지급내역수정 추가
														// 2002/02/21

				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);

				dest = WebUtil.JspURL + "D/D06Ypay/D06MpayDetail_m.jsp";
			}
			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
}
