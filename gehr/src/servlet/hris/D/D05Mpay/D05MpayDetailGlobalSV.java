/******************************************************************************/
 /*	System Name	: g-HR
 /*   	1Depth Name 	: Personal HR Info
 /*   	2Depth Name 	: Payroll
 /*   	Program Name	: Monthly Salary
 /*   	Program ID   	: D05MpayDetailUsaSV.java
 /*   	Description  	: 개인의 월급여내역 정보를 jsp로 넘겨주는 class (Global)=China, USA
 /*   	Note         		:
 /*    Creation     	: 2010-10-29 jungin @v1.0			
  * 						//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel 									
  */
/******************************************************************************/

package servlet.hris.D.D05Mpay;

import com.common.Utils;
import com.common.constant.Area;
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
 * @author chldudgh
 * @version 1.0, 2002/01/28
 */
public class D05MpayDetailGlobalSV extends EHRBaseServlet {
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			HttpSession session = req.getSession(false);
			WebUserData user = (WebUserData) session.getAttribute("user");

			if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL 폴랜드, DE 독일 은 유럽화면으로 
				printJspPage(req, res, WebUtil.ServletURL+ "hris.D.D05Mpay.D05MpayDetailEurpSV");
			} 
	            
			String jobid = "";
			String dest = "";
			String flag = "p";
			String yymmdd = "";
			String ymd = "";
			////@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel 
			final String PAYDAY = (user.area.equals(Area.US)||user.area.equals(Area.MX))?"01":"25";
			
		
			// Annual Salary 에서 넘겨주는 parameter.
			String zocrsn = "";
			String zseqnr = "";

			Box box = WebUtil.getBox(req);
			jobid = box.get("jobid","first");

			zocrsn = box.get("zocrsn");
			zseqnr = box.get("zseqnr");

			Logger.debug.println(this, "[jobid] = " + jobid + " [user] : "					+ user.toString());
			Logger.debug.println(this, "#####	zocrsn	:	[" + zocrsn + "]");
			Logger.debug.println(this, "#####	zseqnr	:	[" + zseqnr + "]");
			//Logger.debug.println(this, "#####	user	:	[ " + user.toString() + " ]");
			//Logger.debug.println(this, "#####	jobid	:	[ " + jobid + " ]	/	PERNR :	[ " + PERNR + " ]");

			if (jobid.equals("first")) {

				String yyyy = box.get("yyyy");
				String mm = box.get("mm");
				String oo = box.get("oo");
				
				D05LatestPaidRFC rfc_paid = new D05LatestPaidRFC();

//				String paydt = rfc_paid.getLatestPaid1(user.empNo, user.webUserId);
//				String ocrsn = rfc_paid.getLatestPaid2(user.empNo, user.webUserId);
//				String seqnr = rfc_paid.getLatestPaid3(user.empNo, user.webUserId); // 5월 21일 추가
                Vector v = rfc_paid.getLatestPaid(user.empNo, user.webUserId);  // 5월 21일 추가
				String paydt = (String) Utils.indexOf(v, 0);
				String ocrsn = (String) Utils.indexOf(v, 1);;
				String seqnr = (String) Utils.indexOf(v, 2);;  // 5월 21일 추가


				String year = paydt.substring(0, 4);
				String month = paydt.substring(5, 7);
				
				String yymm;
				
				if (yyyy == null || yyyy.equals("")) {
					yymm = year + month;
					Logger.debug.println(this, "year = " + year + "month = "
							+ month);
				} else {
					yymm = yyyy + mm;
					Logger.debug.println(this, "yyyy = " + yyyy + "mm = " + mm);
				}

				D05ZocrsnTextRFC rfc_zocrsn = new D05ZocrsnTextRFC();

				Vector d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(	user.empNo, yymm); // 급여사유 코드와 TEXT
				
				if (yyyy == null || yyyy.equals("")) {
					
				} else {
					if (oo == null || oo.equals("")){
						ocrsn = ((D05ZocrsnTextData) d05ZocrsnTextData_vt.get(0)).ZOCRSN;
						seqnr = ((D05ZocrsnTextData) d05ZocrsnTextData_vt.get(0)).SEQNR;
					}else{
						ocrsn = oo.substring(0,2);
						seqnr = oo.substring(2,7);
//						ocrsn = zocrsn;
//						seqnr = zseqnr;
					}
				}
				
				Logger.debug.println(this, "최종급여지급일 = " + paydt + "급여사유코드 = "
						+ ocrsn + "순번 = " + seqnr);

				D05MpayDetailRFCGlobal rfc = new D05MpayDetailRFCGlobal();
				D05MpayDetailData4 d05MpayDetailData4 = null;
				D05MpayDetailData5 d05MpayDetailData5 = null;
				
				yymmdd = yymm + PAYDAY;

				Vector d05MpayDetailData1_vt = rfc.getMpayDetail(user.empNo, yymmdd, ocrsn, flag, seqnr);

				d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(user.empNo, yymmdd, ocrsn, flag, seqnr);
				d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(user.empNo, yymmdd, ocrsn, flag, seqnr);

				req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);

				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("paydt", paydt);
				req.setAttribute("ocrsn", ocrsn);
				req.setAttribute("seqnr", seqnr); // 5월 21일 추가

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("yyyy", yyyy);
				req.setAttribute("mm", mm);

				dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetail_Global.jsp";
				// }
			} else if (jobid.equals("getcode")) {
				String year = box.get("year1");
				String month = box.get("month1");
				String yymm = year + month;

				D05ZocrsnTextRFC rfc_zocrsn = new D05ZocrsnTextRFC();
				Vector d05ZocrsnTextData_vt = new Vector();

				// //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
				// ----------------------------------------
				// MappingPernrRFC mapfunc = null ;
				// MappingPernrData mapData = new MappingPernrData();
				// Vector mapData_vt = new Vector() ;
				// String mapPernr = "";
				//
				// mapfunc = new MappingPernrRFC() ;
				// mapData_vt = mapfunc.getPernr( user.empNo ) ;
				// String mapDate = "";
				// int cnt = 0;
				//
				// if ( user.companyCode.equals("C100") && mapData_vt != null &&
				// mapData_vt.size() > 0 ) {
				// cnt = mapData_vt.size();
				// for ( int i=0; i < mapData_vt.size(); i++) {
				// mapData = (MappingPernrData)mapData_vt.get(i);
				// mapDate = DataUtil.delDateGubn(mapData.BEGDA);
				// mapDate = mapDate.substring(0,6);
				//
				// if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
				// cnt--;
				// }
				// }
				//
				// if ( cnt == mapData_vt.size() ) {
				// mapPernr = user.empNo;
				// } else {
				// mapData = (MappingPernrData)mapData_vt.get(cnt);
				// mapPernr = mapData.PERNR;
				// }
				// } else {
				// mapPernr = user.empNo;
				// }
				// /-----------------------------------------------------------------------------------

				rfc_zocrsn = new D05ZocrsnTextRFC();
				d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user.empNo,
						yymm); // 급여사유 코드와 TEXT

				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				dest = WebUtil.JspURL + "D/D05Mpay/D05Hidden.jsp";

			} else if (jobid.equals("search")  || jobid.equals("search_back") ) {
				String year = box.get("year1");
				String month = box.get("month1");
				String ocrsn = box.get("ocrsn");
				String seqnr = ocrsn.substring(2, 7); // 5월 21일 순번 추가
				String yymm = year + month;
				ocrsn = ocrsn.substring(0, 2);

				// // 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
				// ----------------------------------------
				// MappingPernrRFC mapfunc = null ;
				// MappingPernrData mapData = new MappingPernrData();
				// Vector mapData_vt = new Vector() ;
				// String mapPernr = "";
				//
				// mapfunc = new MappingPernrRFC() ;
				// mapData_vt = mapfunc.getPernr( user.empNo ) ;
				// String mapDate = "";
				// int cnt = 0;
				//
				// if ( user.companyCode.equals("C100") && mapData_vt != null &&
				// mapData_vt.size() > 0 ) {
				// cnt = mapData_vt.size();
				// for ( int i=0; i < mapData_vt.size(); i++) {
				// mapData = (MappingPernrData)mapData_vt.get(i);
				// mapDate = DataUtil.delDateGubn(mapData.BEGDA);
				// mapDate = mapDate.substring(0,6);
				//
				// if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
				// cnt--;
				// }
				// }
				//
				// if ( cnt == mapData_vt.size() ) {
				// mapPernr = user.empNo;
				// } else {
				// mapData = (MappingPernrData)mapData_vt.get(cnt);
				// mapPernr = mapData.PERNR;
				// }
				// } else {
				// mapPernr = user.empNo;
				// }
				// /-----------------------------------------------------------------------------------

				D05ZocrsnTextRFC rfc_zocrsn = new D05ZocrsnTextRFC();
				Vector d05ZocrsnTextData_vt = new Vector();
				yymmdd = year + month + PAYDAY;
				rfc_zocrsn = new D05ZocrsnTextRFC();
				d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user.empNo,
						yymm); // 급여사유 코드와 TEXT

				Logger.debug.println(this, "#####	[search]	선택 년도	:	[" + year + "]");
				Logger.debug.println(this, "#####	[search]	선택 월	:	[" + month + "]");
				Logger.debug.println(this, "#####	[search]	선택 임금유형	:	[" + ocrsn + "]");
				Logger.debug.println(this, "#####	[search]	yymm	:	[" + yymm + "]");
				Logger.debug.println(this, "#####	[search]	seqnr	:	[" + seqnr + "]");
				
				D05MpayDetailRFCGlobal rfc = new D05MpayDetailRFCGlobal();
				D05MpayDetailData4 d05MpayDetailData4 = null;
				D05MpayDetailData5 d05MpayDetailData5 = null;
				D05MpayDetailData3 data = new D05MpayDetailData3();
				D05MpayDetailData2 data4 = new D05MpayDetailData2();// 추가
				// 2002/02/21
				D05MpayDetailData1 data6 = new D05MpayDetailData1();// 추가(해외급여)추가
				// 2002/02/21
				D05MpayDetailData1 data7 = new D05MpayDetailData1();// 추가(해외급여)추가
				// 2002/02/21

				Vector d05MpayDetailData1_vt = rfc.getMpayDetail(user.empNo,
						yymmdd, ocrsn, flag, seqnr);

				d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
						user.empNo, yymmdd, ocrsn, flag, seqnr);
				d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
						user.empNo, yymmdd, ocrsn, flag, seqnr);

				req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("ocrsn", ocrsn);
				req.setAttribute("seqnr", seqnr); // 5월 21일 추가
           		req.setAttribute("backBtn",  jobid.equals("search_back")?"Y":"" );  // 되돌아가기 버튼활성

				dest = WebUtil.JspURL + "D/D05Mpay/D05MpayDetail_Global.jsp";

			} else if (jobid.equals("kubya_1")) {
				String year1 = box.get("year1");
				String month1 = box.get("month1");
				String ocrsn1 = box.get("ocrsn");
				String ocrsn = ocrsn1 + "00000";
				// String seqnr = "00000"; // 5월 21일 순번 추가
				String yymm = year1 + month1;
				//
				// // lg화학과 석유화학을 구별(휴가일수)
				// if(user.companyCode.equals("C100")) {
				// yymmdd = year1 + month1 + "20";
				// } else {
				// yymmdd = year1 + month1 + "15";
				// }

				req.setAttribute("print_page_name", WebUtil.ServletURL
						+ "hris.D.D05Mpay.D05MpayDetailSV?jobid=kubya&year1="
						+ year1 + "&month1=" + month1 + "&ocrsn=" + ocrsn); // 5월
				// 21일
				// 순번
				// 추가
				Logger.debug(WebUtil.ServletURL
						+ "hris.D.D05Mpay.D05MpayDetailSV?jobid=kubya&year1="
						+ year1 + "&month1=" + month1 + "&ocrsn=" + ocrsn);
				dest = WebUtil.JspURL + "common/printFrame.jsp";
				Logger.debug.println(this, WebUtil.ServletURL
						+ "hris.D.D05Mpay.D05MpayDetailSV?jobid=kubya&year1="
						+ year1 + "&month1=" + month1 + "&ocrsn=" + ocrsn); // 5월
				// 21일
				// 순번
				// 추가.
			} else if (jobid.equals("kubya")) {
				String year = box.get("year1");
				String month = box.get("month1");
				String ocrsn = box.get("ocrsn");
				String seqnr = ocrsn.substring(2, 7); // 5월 21일 순번 추가
				String yymm = year + month;
				yymmdd = year + month + PAYDAY;
				ocrsn = ocrsn.substring(0, 2);
				// // 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
				// ----------------------------------------
				// MappingPernrRFC mapfunc = null ;
				// MappingPernrData mapData = new MappingPernrData();
				// Vector mapData_vt = new Vector() ;
				// String mapPernr = "";
				//
				// mapfunc = new MappingPernrRFC() ;
				// mapData_vt = mapfunc.getPernr( user.empNo ) ;
				// String mapDate = "";
				// int cnt = 0;
				//
				// if ( user.companyCode.equals("C100") && mapData_vt != null &&
				// mapData_vt.size() > 0 ) {
				// cnt = mapData_vt.size();
				// for ( int i=0; i < mapData_vt.size(); i++) {
				// mapData = (MappingPernrData)mapData_vt.get(i);
				// mapDate = DataUtil.delDateGubn(mapData.BEGDA);
				// mapDate = mapDate.substring(0,6);
				//
				// if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
				// cnt--;
				// }
				// }
				//
				// if ( cnt == mapData_vt.size() ) {
				// mapPernr = user.empNo;
				// } else {
				// mapData = (MappingPernrData)mapData_vt.get(cnt);
				// mapPernr = mapData.PERNR;
				// }
				// } else {
				// mapPernr = user.empNo;
				// }
				// /-----------------------------------------------------------------------------------

				D05ZocrsnTextRFC rfc_zocrsn = new D05ZocrsnTextRFC();
				Vector d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(
						user.empNo, yymm); // 급여사유 코드와 TEXT


				Logger.debug.println(this, "#####	[kubya]	선택 년도	:	[" + year + "]");
				Logger.debug.println(this, "#####	[kubya]	선택 월	:	[" + month + "]");
				Logger.debug.println(this, "#####	[kubya]	선택 임금유형	:	[" + ocrsn + "]");
				Logger.debug.println(this, "#####	[kubya]	yymm	:	[" + yymm + "]");
				Logger.debug.println(this, "#####	[kubya]	seqnr	:	[" + seqnr + "]");
				Logger.debug.println(this, "#####	[kubya]	flag	:	[" + flag + "]");

				D05MpayDetailRFCGlobal rfc = new D05MpayDetailRFCGlobal();
				D05MpayDetailData4 d05MpayDetailData4 = null;
				D05MpayDetailData5 d05MpayDetailData5 = null;
				D05MpayDetailData3 data = new D05MpayDetailData3();
				D05MpayDetailData2 data4 = new D05MpayDetailData2();// 추가
				// 2002/02/21
				D05MpayDetailData1 data6 = new D05MpayDetailData1();// 추가(해외급여)추가
				// 2002/02/21
				D05MpayDetailData1 data7 = new D05MpayDetailData1();// 추가(해외급여)추가
				// 2002/02/21

				Vector d05MpayDetailData1_vt = rfc.getMpayDetail(user.empNo,
						yymmdd, ocrsn, flag, seqnr);
				Vector d05MpayDetailData4_vt = new Vector();
				Vector d05MpayDetailData5_vt = new Vector();// 추가 2002/02/21
				Vector d05MpayDetailData6_vt = new Vector();// 추가(해외급여)
				// 2002/02/21


				d05MpayDetailData4 = (D05MpayDetailData4) rfc.getPerson(
						user.empNo, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
				// 추가
				d05MpayDetailData5 = (D05MpayDetailData5) rfc.getPaysum(
						user.empNo, yymmdd, ocrsn, flag, seqnr); // 5월 21일 순번
				// 추가

				// if( d05MpayDetailData1_vt.size() == 0 &&
				// d05MpayDetailData2_vt.size() == 0 &&
				// d05MpayDetailData3_vt.size() == 0 ) {
				// Logger.debug.println(this, "Data Not Found");
				// String msg = "msg004";
				// req.setAttribute("msg", msg);
				// dest = WebUtil.JspURL+"common/caution.jsp";
				// } else {
				// //////////////////////////////////////////////////////////////////////////

				req
						.setAttribute("d05MpayDetailData1_vt",
								d05MpayDetailData1_vt);

				req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
				// req.setAttribute("d05MpayDetailData4_vt",
				// d05MpayDetailData4_vt);
				// req.setAttribute("d05MpayDetailData5_vt",
				// d05MpayDetailData5_vt); //추가 2002/02/21
				// req.setAttribute("d05MpayDetailData6_vt",
				// d05MpayDetailData6_vt); //해외지급내역수정 추가 2002/02/21

				req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
				req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

				req.setAttribute("year", year);
				req.setAttribute("month", month);
				req.setAttribute("ocrsn", ocrsn);
				req.setAttribute("seqnr", seqnr); // 5월 21일 순번 추가


                if(user.area.equals(Area.KR)){
                	dest = WebUtil.JspURL+"D/D05Mpay/D05Mpayhwahak.jsp";
            	}else if(user.area.equals(Area.DE) || user.area.equals(Area.PL)){
                	dest = WebUtil.JspURL+"D/D05Mpay/D05MpayhwahakGlobal.jsp";
            	}else {
                	dest = WebUtil.JspURL+"D/D05Mpay/D05MpayhwahakGlobal.jsp";
            	}
				// }
			} else if (jobid.equals("month_kubyo")) {

				String zyymm = box.get("zyymm");
				String year = zyymm.substring(0, 4);
				String month = zyymm.substring(4);
				String ocrsn = "ZZ";
				String seqnr = "";
				String yymm = year + month;

				// lg화학과 석유화학을 구별(휴가일수)
				if (user.companyCode.equals("C100")) {
					yymmdd = year + month + "20";
				} else {
					yymmdd = year + month + "15";
				}

				// // 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
				// ----------------------------------------
				MappingPernrRFC mapfunc = null;
				MappingPernrData mapData = new MappingPernrData();
				Vector mapData_vt = new Vector();
				String mapPernr = "";

				mapfunc = new MappingPernrRFC();
				mapData_vt = mapfunc.getPernr(user.empNo);
				String mapDate = "";
				int cnt = 0;

				if (user.companyCode.equals("C100") && mapData_vt != null
						&& mapData_vt.size() > 0) {
					cnt = mapData_vt.size();
					for (int i = 0; i < mapData_vt.size(); i++) {
						mapData = (MappingPernrData) mapData_vt.get(i);
						mapDate = DataUtil.delDateGubn(mapData.BEGDA);
						mapDate = mapDate.substring(0, 6);

						if (Integer.parseInt(yymm) >= Integer.parseInt(mapDate)) {
							cnt--;
						}
					}

					if (cnt == mapData_vt.size()) {
						mapPernr = user.empNo;
					} else {
						mapData = (MappingPernrData) mapData_vt.get(cnt);
						mapPernr = mapData.PERNR;
					}
				} else {
					mapPernr = user.empNo;
				}
				// /-----------------------------------------------------------------------------------

				D05ZocrsnTextRFC rfc_zocrsn = new D05ZocrsnTextRFC();
				Vector d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(
						mapPernr, yymm); // 급여사유 코드와 TEXT

				Logger.debug.println(this, "#####	[month_kubyo]	선택 년도	:	[" + year + "]");
				Logger.debug.println(this, "#####	[month_kubyo]	선택 월	:	[" + month + "]");
				Logger.debug.println(this, "#####	[month_kubyo]	선택 임금유형	:	[" + ocrsn + "]");
				Logger.debug.println(this, "#####	[month_kubyo]	yymm	:	[" + yymm + "]");
				Logger.debug.println(this, "#####	[month_kubyo]	seqnr	:	[" + seqnr + "]");

				D05MpayDetailRFCGlobal rfc = new D05MpayDetailRFCGlobal();
				D05MpayDetailData4 d05MpayDetailData4 = null;
				D05MpayDetailData5 d05MpayDetailData5 = null;
				D05MpayDetailData3 data = new D05MpayDetailData3();
				D05MpayDetailData2 data4 = new D05MpayDetailData2();// 추가
				// 2002/02/21
				D05MpayDetailData1 data6 = new D05MpayDetailData1();// 추가(해외급여)추가
				// 2002/02/21
				D05MpayDetailData1 data7 = new D05MpayDetailData1();// 추가(해외급여)추가
				// 2002/02/21

				Vector d05MpayDetailData1_vt = rfc.getMpayDetail(mapPernr,
						yymmdd, ocrsn, flag, seqnr);

				Vector d05MpayDetailData4_vt = new Vector();
				Vector d05MpayDetailData5_vt = new Vector();// 추가 2002/02/21
				Vector d05MpayDetailData6_vt = new Vector();// 추가(해외급여)
				// 2002/02/21

				req
						.setAttribute("d05MpayDetailData1_vt",
								d05MpayDetailData1_vt);

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
				// }
			}
			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
}
