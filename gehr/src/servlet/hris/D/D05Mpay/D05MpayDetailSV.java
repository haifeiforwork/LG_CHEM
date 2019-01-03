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
import hris.D.D05Mpay.rfc.D05MpayDetailRFC;
import hris.D.D05Mpay.rfc.D05ZocrsnTextRFC;
import hris.common.MappingPernrData;
import hris.common.WebUserData;
import hris.common.rfc.MappingPernrRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * D05MpayDetailSV.java
 * 개인의 월급여내역 정보를 jsp로 넘겨주는 class
 * 개인의 월급여내역 정보를 가져오는 D05MpayDetailRFC를 호출하여 D04VocationDetail.jsp로 개인의 월급여내역 정보를 넘겨준다.(x)
 * 개인의 월급여내역 정보를 가져오는 D05MpayDetailRFC를 호출하여 D05MpayDetail.jsp로 개인의 월급여내역 정보를 넘겨준다.
 * @author chldudgh
 * @version 1.0, 2002/01/28
 *   Update       : 2013-06-24 [CSR ID:2353407] sap에 추가암검진 추가 건
 *                    : 2017-10-20 [CSR ID:3447340] 급여 수정 상태(PA03) 급여명세표 출력 문구 수정 요청
 *                     2017-11-06  eunha  [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건
 *                     @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32"))  2018/02/09 rdcamel
 *                     @PJ.베트남 하이퐁 법인 Rollout 프로젝트 추가 관련(Area = OT("99") && companyCode(G580) ) 2018/04/02 Kang DM
 */
public class D05MpayDetailSV extends EHRBaseServlet {
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
    		throws GeneralException {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user   = (WebUserData)session.getValue("user");

            Logger.debug.println(this, "-------------[user.area] = "+user.area  );
            Logger.debug.println(this, "-------------[user.companyCode] = "+user.companyCode  );

            /**
             * Start: 국가별 분기처리
             */
            String fdUrl = ".";

          //[CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 Area.TH 추가
          //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32"))  2018/02/09 rdcamel
          //@PJ.베트남 하이퐁 법인 Rollout 프로젝트 추가 관련(Area = OT("99") && companyCode(G580) ) 2018/04/02 Kang DM
            if (user.area.equals(Area.CN) || user.area.equals(Area.TW) || user.area.equals(Area.HK) || user.area.equals(Area.US)|| user.area.equals(Area.TH) || user.area.equals(Area.MX) || (user.area.equals(Area.OT) && user.companyCode.equals("G580")) ) {	// 타이완,홍콩은 중국화면으로
               fdUrl = "hris.D.D05Mpay.D05MpayDetailGlobalSV";
			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL 폴랜드, DE 독일 은 유럽화면으로
        	   fdUrl = "hris.D.D05Mpay.D05MpayDetailEurpSV";
			} else if(user.area.getMolga().equals("")){
	            req.setAttribute("url", "history.back();");
	            req.setAttribute("msg2", g.getMessage("MSG.COMMON.0029")); //국가코드가 바르지 못합니다
				printJspPage(req, res,  WebUtil.JspURL + "common/msg.jsp");
				return;
			}

           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );

            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }

            /**
             * END: 국가별 분기처리
             */
            String jobid = "";
            String dest = "";
            String flag = " ";
            String yymmdd = "";
            String ymd = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid","first");

            String paydt  = box.get("paydt");
            String ocrsn  = "";
            String seqnr  = "";


            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

/****************************************************************************
 * 			first 최초접속시 조회화면구성          => D05MpayDetail_KR.jsp
 */
            if( jobid.equals("first") ) {

                D05LatestPaidRFC rfc_paid = new D05LatestPaidRFC();

//                String paydt = rfc_paid.getLatestPaid1(user.empNo, user.webUserId);
//                String ocrsn = rfc_paid.getLatestPaid2(user.empNo, user.webUserId);
//                String seqnr = rfc_paid.getLatestPaid3(user.empNo, user.webUserId);  // 5월 21일 추가

                Vector v = rfc_paid.getLatestPaid(user.empNo, user.webUserId);  // 5월 21일 추가
				 paydt = (String) Utils.indexOf(v, 0);
				 ocrsn = (String)Utils.indexOf(v, 1);;
				 seqnr = (String)Utils.indexOf(v, 2);;  // 5월 21일 추가

                String year  = paydt.substring(0,4);
                String month = paydt.substring(5,7);
                String yymm  = year + month ;
                if(user.companyCode.equals("C100")) {
               	    ymd = year + month + "20";
                }else{
                    ymd = year + month + "15";
                }
           //     Logger.debug.println(this, "최종급여지급일 = "+paydt+ "급여사유코드 = "+ocrsn+"순번 = "+seqnr);
           //     Logger.debug.println(this, "최종급여지급년도 = "+year+ "최종급여지급월 = "+month);

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user.empNo, yymm);  // 급여사유 코드와 TEXT

                if (ocrsn.equals("") && (d05ZocrsnTextData_vt.size()>0)){
                	ocrsn = ((D05ZocrsnTextData)d05ZocrsnTextData_vt.get(0)).ZOCRSN;
                }
         //      Logger.debug.println(this, "급여사유 코드와 TEXT : "+ d05ZocrsnTextData_vt.toString());
          //      Logger.debug.println(this, "급여사유 코드와 TEXT : "+ d05ZocrsnTextData_vt.size());

                D05MpayDetailRFC   rfc                = new D05MpayDetailRFC();
                D05MpayDetailData4 d05MpayDetailData4 = null;
                D05MpayDetailData5 d05MpayDetailData5 = null;
                D05MpayDetailData3 data               = new D05MpayDetailData3();
                D05MpayDetailData2 data4              = new D05MpayDetailData2();//추가 2002/02/21
                D05MpayDetailData1 data6              = new D05MpayDetailData1();//추가(해외급여)추가 2002/02/21
                D05MpayDetailData1 data7              = new D05MpayDetailData1();//추가(해외급여)추가 2002/02/21

                Logger.debug.println(this,"Step1");
                Vector sum = rfc.getMpayDetail(user.empNo, ymd, ocrsn, flag,  seqnr, user.webUserId);

                Vector d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // 해외급여 반영내역(항목) 내역  5월 21일 순번 추가

                Logger.debug.println(this, "급여사유  d05MpayDetailData1_vt1 : " );
                Vector d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // 지급내역/공제내역 5월 21일 순번 추가

                Logger.debug.println(this, "급여사유  d05MpayDetailData1_vt2 : " );
                Vector d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 과세추가내역  5월 21일 순번 추가

                Logger.debug.println(this, "급여사유  d05MpayDetailData1_vt3 : " );
                Vector d05MpayDetailData4_vt = new Vector();
                Vector d05MpayDetailData5_vt = new Vector();//추가 2002/02/21
                Vector d05MpayDetailData6_vt = new Vector();//추가(해외급여) 2002/02/21

                Logger.debug.println(this, "과세추가내역1 : "+ d05MpayDetailData3_vt.toString());
                for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
            	    data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
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
                Logger.debug.println(this, " 변형 과세추가내역 : "+ d05MpayDetailData4_vt.toString());

                d05MpayDetailData4 = (D05MpayDetailData4)Utils.indexOf(sum, 3);  //rfc.getPerson(user.empNo, ymd, ocrsn, flag, seqnr, user.webUserId);  // 5월 21일 순번 추가
                d05MpayDetailData5 = (D05MpayDetailData5)Utils.indexOf(sum, 4);  //rfc.getPaysum(user.empNo, ymd, ocrsn, flag, seqnr, user.webUserId);  // 5월 21일 순번 추가

                //              지급내역 text 2002/02/21
                for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                    data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                    D05MpayDetailData2 data5 = new D05MpayDetailData2();

                    if(!data4.LGTXT.equals("")) {
                        data5.LGTXT = data4.LGTXT ;
                        data5.ANZHL = data4.ANZHL ;
                        data5.BET01 = data4.BET01 ;

                        d05MpayDetailData5_vt.addElement(data5);
                    }
                }
       //         Logger.debug.println(this, " 지급내역size : "+ d05MpayDetailData5_vt.size());
       //         Logger.debug.println(this, " 지급내역text : "+ d05MpayDetailData5_vt.toString());

                for( int i = 0 ; i < d05MpayDetailData1_vt.size() ; i++ ) {
                    data6  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(i);
                    D05MpayDetailData1 data8 = new D05MpayDetailData1();
                    String LGT = (String)  data6.LGTXT+"(현지화)";

                    for ( int j = 0 ; j < d05MpayDetailData1_vt.size() ; j++ ) {
                        data7  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(j);

                        if(LGT.equals((String) data7.LGTX1)) {
                            data8.LGTXT = data6.LGTXT;
                            data8.LGTX1 = data7.LGTX1;
                            data8.BET01 = data6.BET01;
                            data8.BET02 = data6.BET02;
                            data8.BET03 = data7.BET03;
                            break;
                        }else{
                            data8.LGTXT = data6.LGTXT;
                            data8.LGTX1 = "";
                            data8.BET01 = data6.BET01;
                            data8.BET02 = data6.BET02;
                            data8.BET03 = "0";
                        }
                    }

             //       Logger.debug.println(this,"통과" );
                    d05MpayDetailData6_vt.addElement(data8);
                }
                Logger.debug.println(this, " 해외내역수정 : "+ d05MpayDetailData6_vt.toString());
//              if( d05MpayDetailData1_vt.size() == 0 && d05MpayDetailData2_vt.size() == 0 && d05MpayDetailData3_vt.size() == 0 ) {
//                  Logger.debug.println(this, "Data Not Found");
//                  String msg = "msg004";
//                     req.setAttribute("msg", msg);
//                  dest = WebUtil.JspURL+"common/caution.jsp";
//              } else {
                ////////////////////////////////////////////////////////////////////////////
      //          Logger.debug.println(this, "해외급여 반영내역(항목) 내역 : "+ d05MpayDetailData1_vt.toString());
     //           Logger.debug.println(this, "지급내역/공제내역  : "+ d05MpayDetailData2_vt.toString());
      //          Logger.debug.println(this, "과세추가내역2 : "+ d05MpayDetailData3_vt.toString());

       //         Logger.debug.println(this, "급여명세표 - 개인정보/환율 내역  : "+ d05MpayDetailData4.toString());
         //       Logger.debug.println(this, "지급내역/공제내역 합  : "+ d05MpayDetailData5.toString());

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //추가 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //해외지급내역수정 추가 2002/02/21

                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

                req.setAttribute("paydt", paydt);
                req.setAttribute("ocrsn", ocrsn);

                req.setAttribute("year", year);
                req.setAttribute("month", month);
                req.setAttribute("ocrsn", ocrsn+seqnr);
                req.setAttribute("seqnr", seqnr);  // 5월 21일 추가

                //[CSR ID:3447340] 급여 수정 상태(PA03) 급여명세표 출력 문구 수정 요청
                req.setAttribute("E_CODE", rfc.getReturn().MSGTY ); //      급여 종료상태가 아니면   M   데이터가 없으면 F

                dest = WebUtil.JspURL+"D/D05Mpay/D05MpayDetail_KR.jsp";
//           }

/****************************************************************************
 * 			getcode   급여사유코드가져오기            => D05Hidden.jsp
 */

            }else if(jobid.equals("getcode")){
                String year   = box.get("year1");
                String month  = box.get("month1");
                String yymm   = year + month;

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = new Vector() ;

                //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH ----------------------------------------
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
                String           mapPernr = "";

                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                String mapDate = "";
                int    cnt     = 0;

                if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                    cnt = mapData_vt.size();
                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);
                        mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                        mapDate = mapDate.substring(0,6);

                        if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
                            cnt--;
                        }
                    }

                    if ( cnt == mapData_vt.size() ) {
                        mapPernr = user.empNo;
                    } else {
                        mapData = (MappingPernrData)mapData_vt.get(cnt);
                        mapPernr = mapData.PERNR;
                    }
                } else {
                    mapPernr = user.empNo;
                }
                ///-----------------------------------------------------------------------------------

                rfc_zocrsn           = new D05ZocrsnTextRFC();
                d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // 급여사유 코드와 TEXT

                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
                dest = WebUtil.JspURL+"D/D05Mpay/D05Hidden.jsp";

/******************************************************************************
 * 조회작업
 */
            } else if(jobid.equals("search") || jobid.equals("search_back")){ // add search_back
                String year   = box.get("year1");
                String month  = box.get("month1");
                 ocrsn  = box.get("ocrsn");
                 paydt  = box.get("paydt");
                 seqnr  = ocrsn.substring(2,7);  // 5월 21일 순번 추가
                String yymm   = year + month;

//              lg화학과 석유화학을 구별(휴가일수)
                if(user.companyCode.equals("C100")) {
                    yymmdd = year + month + "20";
                } else  {
        	        yymmdd = year + month + "15";
                }

                //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH ----------------------------------------
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
                String           mapPernr = "";

                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                String mapDate = "";
                int    cnt     = 0;

                if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                    cnt = mapData_vt.size();
                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);
                        mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                        mapDate = mapDate.substring(0,6);

                        if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
                            cnt--;
                        }
                    }

                    if ( cnt == mapData_vt.size() ) {
                        mapPernr = user.empNo;
                    } else {
                        mapData = (MappingPernrData)mapData_vt.get(cnt);
                        mapPernr = mapData.PERNR;
                    }
                } else {
                    mapPernr = user.empNo;
                }
                ///-----------------------------------------------------------------------------------

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = new Vector() ;

                rfc_zocrsn           = new D05ZocrsnTextRFC();
                d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // 급여사유 코드와 TEXT

        //        Logger.debug.println(this, "선택한 년도 : "+ year+"선택한 월:"+month+"선택한 임금유형:"+ocrsn+"yymm;"+yymm+"seqnr :"+seqnr);
     //           Logger.debug.println(this, "급여사유 코드와 TEXT : "+ d05ZocrsnTextData_vt.toString());

                D05MpayDetailRFC   rfc                = new D05MpayDetailRFC();
                D05MpayDetailData4 d05MpayDetailData4 = null;
                D05MpayDetailData5 d05MpayDetailData5 = null;
                D05MpayDetailData3 data               = new D05MpayDetailData3();
                D05MpayDetailData2 data4              = new D05MpayDetailData2();//추가 2002/02/21
                D05MpayDetailData1 data6              = new D05MpayDetailData1();//추가(해외급여)추가 2002/02/21
                D05MpayDetailData1 data7              = new D05MpayDetailData1();//추가(해외급여)추가 2002/02/21

                Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);

                Vector d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // 5월 21일 순번 추가
                Vector d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // 5월 21일 순번 추가
                Vector d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5월 21일 순번 추가
                Vector d05MpayDetailData4_vt = new Vector();
                Vector d05MpayDetailData5_vt = new Vector();//추가 2002/02/21
                Vector d05MpayDetailData6_vt = new Vector();//추가(해외급여) 2002/02/21

    //            Logger.debug.println(this, "과세추가내역1 : "+ d05MpayDetailData3_vt.toString());
                for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
            	    data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
            	    D05MpayDetailData3 data1 = new D05MpayDetailData3();
            	    D05MpayDetailData3 data2 = new D05MpayDetailData3();
            	    D05MpayDetailData3 data3 = new D05MpayDetailData3();

				    data1.LGTX1 = data.LGTX1 ;
				    data1.BET01 = data.BET01 ;
				    data2.LGTX1 = data.LGTX2 ;
				    data2.BET01 = data.BET02 ;
				    data3.LGTX1 = data.LGTX3 ;
				    data3.BET01 = data.BET03 ;

            	    d05MpayDetailData4_vt.addElement(data1);
            	    d05MpayDetailData4_vt.addElement(data2);
            	    d05MpayDetailData4_vt.addElement(data3);
                }
      //          Logger.debug.println(this, " 변형 과세추가내역 : "+ d05MpayDetailData4_vt.toString());

                d05MpayDetailData4 = (D05MpayDetailData4)Utils.indexOf(sum, 3);  //rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5월 21일 순번 추가
                d05MpayDetailData5 = (D05MpayDetailData5)Utils.indexOf(sum, 4);  //rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5월 21일 순번 추가

//              지급내역 text 2002/02/21
                for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                    data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                    D05MpayDetailData2 data5  = new D05MpayDetailData2();

                    if(!data4.LGTXT.equals("")) {
                        data5.LGTXT = data4.LGTXT ;
                        data5.ANZHL = data4.ANZHL ;
                        data5.BET01 = data4.BET01 ;

                        d05MpayDetailData5_vt.addElement(data5);
                    }
                }
      //          Logger.debug.println(this, " 지급내역size : "+ d05MpayDetailData5_vt.size());
      //          Logger.debug.println(this, " 지급내역text : "+ d05MpayDetailData5_vt.toString());

                for( int i = 0 ; i < d05MpayDetailData1_vt.size() ; i++ ) {
                    data6  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(i);
                    D05MpayDetailData1 data8 = new D05MpayDetailData1();
                    String LGT = (String)  data6.LGTXT+"(현지화)";

                    for ( int j = 0 ; j < d05MpayDetailData1_vt.size() ; j++ ) {
                      data7  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(j);

                      if(LGT.equals((String) data7.LGTX1)) {
                          data8.LGTXT = data6.LGTXT;
                          data8.LGTX1 = data7.LGTX1;
                          data8.BET01 = data6.BET01;
                          data8.BET02 = data6.BET02;
                          data8.BET03 = data7.BET03;
                          break;
                      }else{
                          data8.LGTXT = data6.LGTXT;
                          data8.LGTX1 = "";
                          data8.BET01 = data6.BET01;
                          data8.BET02 = data6.BET02;
                          data8.BET03 = "0";
                      }
                   }
        //           Logger.debug.println(this,"통과" );
                   d05MpayDetailData6_vt.addElement(data8);
                }
      //          Logger.debug.println(this, " 해외내역수정 : "+ d05MpayDetailData6_vt.toString());
      //          Logger.debug.println(this, "해외급여 반영내역(항목) 내역 : "+ d05MpayDetailData1_vt.toString());
      //          Logger.debug.println(this, "지급내역/공제내역  : "+ d05MpayDetailData1_vt.toString());
      //          Logger.debug.println(this, "과세추가내역 : "+ d05MpayDetailData1_vt.toString());

     //           Logger.debug.println(this, "급여명세표 - 개인정보/환율 내역  : "+ d05MpayDetailData4.toString());
     //           Logger.debug.println(this, "지급내역/공제내역 합  : "+ d05MpayDetailData5.toString());

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //추가 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //해외지급내역수정 추가 2002/02/21

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

                req.setAttribute("year", year);
                req.setAttribute("month", month);
                req.setAttribute("ocrsn", ocrsn);
                req.setAttribute("seqnr", seqnr);  // 5월 21일 추가

           		req.setAttribute("backBtn",  jobid.equals("search_back")?"Y":"" );  // 되돌아가기 버튼활성
                req.setAttribute("paydt", paydt);

                //[CSR ID:3447340] 급여 수정 상태(PA03) 급여명세표 출력 문구 수정 요청
                req.setAttribute("E_CODE", rfc.getReturn().MSGTY ); //      급여 종료상태가 아니면   M   데이터가 없으면 F


                dest = WebUtil.JspURL+"D/D05Mpay/D05MpayDetail_KR.jsp";

/****************************************************************************
 *           kubya_1 급여명세서 (D05MpayDetail.jsp에서 호출)  jobid=kubya로 재호출   => printFrame.jsp
 *****************************************************************************/
            } else if(jobid.equals("kubya_1")){
                String year1   = box.get("year1");
                String month1 = box.get("month1");
                String ocrsn1  = box.get("ocrsn");
                 ocrsn  = ocrsn1 + "00000";
//              String seqnr  = "00000";  // 5월 21일 순번 추가
                String yymm   = year1 + month1;

//              lg화학과 석유화학을 구별(휴가일수)
                if(user.companyCode.equals("C100")) {
                    yymmdd = year1 + month1 + "20";
                } else {
        	          yymmdd = year1 + month1 + "15";
                }

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.D.D05Mpay.D05MpayDetailSV?jobid=kubya&year1="+year1+"&month1="+month1+"&ocrsn="+ocrsn);  // 5월 21일 순번 추가
                dest = WebUtil.JspURL+"common/printFrame.jsp";
     //           Logger.debug.println(this, WebUtil.ServletURL+"hris.D.D05Mpay.D05MpayDetailSV?jobid=kubya&year1="+year1+"&month1="+month1+"&ocrsn="+ocrsn);  // 5월 21일 순번 추가.


/******************************************************************************
 *        kubya 급여명세서     => printFrame.jsp
********************************************************************************/
            }else if(jobid.equals("kubya")){
                String year  = box.get("year1");
                String month = box.get("month1");
                 ocrsn = box.get("ocrsn");
                 seqnr = ocrsn.substring(2,7);  // 5월 21일 순번 추가
                String yymm  = year + month;
//              lg화학과 석유화학을 구별(휴가일수)
                if(user.companyCode.equals("C100")) {
                    yymmdd = year + month + "20";
                } else {
        	          yymmdd = year + month + "15";
                }

                //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH ----------------------------------------
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
                String           mapPernr = "";

                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                String mapDate = "";
                int    cnt     = 0;

                if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                    cnt = mapData_vt.size();
                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);
                        mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                        mapDate = mapDate.substring(0,6);

                        if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
                            cnt--;
                        }
                    }

                    if ( cnt == mapData_vt.size() ) {
                        mapPernr = user.empNo;
                    } else {
                        mapData = (MappingPernrData)mapData_vt.get(cnt);
                        mapPernr = mapData.PERNR;
                    }
                } else {
                    mapPernr = user.empNo;
                }
                ///-----------------------------------------------------------------------------------

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // 급여사유 코드와 TEXT

     //           Logger.debug.println(this, "선택한 년도 : "+ year+"선택한 월:"+month+"선택한 임금유형:"+ocrsn+"yymm;"+yymm+"순번:"+seqnr);
     //           Logger.debug.println(this, "급여사유 코드와 TEXT : "+ d05ZocrsnTextData_vt.toString());

                D05MpayDetailRFC   rfc                = new D05MpayDetailRFC();
                D05MpayDetailData4 d05MpayDetailData4 = null;
                D05MpayDetailData5 d05MpayDetailData5 = null;
                D05MpayDetailData3 data               = new D05MpayDetailData3();
                D05MpayDetailData2 data4              = new D05MpayDetailData2();//추가 2002/02/21
                D05MpayDetailData1 data6              = new D05MpayDetailData1();//추가(해외급여)추가 2002/02/21
                D05MpayDetailData1 data7              = new D05MpayDetailData1();//추가(해외급여)추가 2002/02/21

                Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);

                Vector d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // 5월 21일 순번 추가
                Vector d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);;  // 5월 21일 순번 추가
                Vector d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5월 21일 순번 추가
                Vector d05MpayDetailData4_vt = new Vector();
                Vector d05MpayDetailData5_vt = new Vector();//추가 2002/02/21
                Vector d05MpayDetailData6_vt = new Vector();//추가(해외급여) 2002/02/21

      //          Logger.debug.println(this, "과세추가내역1 : "+ d05MpayDetailData3_vt.toString());
                for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
              	    data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
              	    D05MpayDetailData3 data1 = new D05MpayDetailData3();
              	    D05MpayDetailData3 data2 = new D05MpayDetailData3();
              	    D05MpayDetailData3 data3 = new D05MpayDetailData3();

  				    data1.LGTX1 = data.LGTX1 ;
  				    data1.BET01 = data.BET01 ;
  				    data2.LGTX1 = data.LGTX2 ;
  				    data2.BET01 = data.BET02 ;
  				    data3.LGTX1 = data.LGTX3 ;
  				    data3.BET01 = data.BET03 ;

              	    d05MpayDetailData4_vt.addElement(data1);
              	    d05MpayDetailData4_vt.addElement(data2);
              	    d05MpayDetailData4_vt.addElement(data3);
                }
       //         Logger.debug.println(this, " 변형 과세추가내역 : "+ d05MpayDetailData4_vt.toString());

                d05MpayDetailData4 = (D05MpayDetailData4)Utils.indexOf(sum, 3);  //rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5월 21일 순번 추가
                d05MpayDetailData5 = (D05MpayDetailData5)Utils.indexOf(sum, 4);  //rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5월 21일 순번 추가

//              지급내역 text 2002/02/21
                for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                    data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                    D05MpayDetailData2 data5               = new D05MpayDetailData2();

                    if(!data4.LGTXT.equals("")) {
                        data5.LGTXT = data4.LGTXT ;
                        data5.ANZHL = data4.ANZHL ;
                        data5.BET01 = data4.BET01 ;

                        d05MpayDetailData5_vt.addElement(data5);
                    }
                }
       //         Logger.debug.println(this, " 지급내역size : "+ d05MpayDetailData5_vt.size());
      //          Logger.debug.println(this, " 지급내역text : "+ d05MpayDetailData5_vt.toString());

                for( int i = 0 ; i < d05MpayDetailData1_vt.size() ; i++ ) {
                    data6  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(i);
                    D05MpayDetailData1 data8 = new D05MpayDetailData1();
                    String LGT = (String)  data6.LGTXT+"(현지화)";

                    for( int j = 0 ; j < d05MpayDetailData1_vt.size() ; j++ ) {
                        data7  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(j);

                        if(LGT.equals((String) data7.LGTX1)) {
                            data8.LGTXT = data6.LGTXT;
                            data8.LGTX1 = data7.LGTX1;
                            data8.BET01 = data6.BET01;
                            data8.BET02 = data6.BET02;
                            data8.BET03 = data7.BET03;
                            break;
                        }else{
                            data8.LGTXT = data6.LGTXT;
                            data8.LGTX1 = "";
                            data8.BET01 = data6.BET01;
                            data8.BET02 = data6.BET02;
                            data8.BET03 = "0";
                        }
                    }

        //            Logger.debug.println(this,"통과" );
                    d05MpayDetailData6_vt.addElement(data8);
                }
    //            Logger.debug.println(this, " 해외내역수정 : "+ d05MpayDetailData6_vt.toString());
//              if( d05MpayDetailData1_vt.size() == 0 && d05MpayDetailData2_vt.size() == 0 && d05MpayDetailData3_vt.size() == 0 ) {
//                  Logger.debug.println(this, "Data Not Found");
//                  String msg = "msg004";
//                     req.setAttribute("msg", msg);
//                  dest = WebUtil.JspURL+"common/caution.jsp";
//              } else {
                ////////////////////////////////////////////////////////////////////////////
         //       Logger.debug.println(this, "해외급여 반영내역(항목) 내역 : "+ d05MpayDetailData1_vt.toString());
           //     Logger.debug.println(this, "지급내역/공제내역  : "+ d05MpayDetailData1_vt.toString());
         //       Logger.debug.println(this, "과세추가내역 : "+ d05MpayDetailData1_vt.toString());

       //         Logger.debug.println(this, "급여명세표 - 개인정보/환율 내역  : "+ d05MpayDetailData4.toString());
       //         Logger.debug.println(this, "지급내역/공제내역 합  : "+ d05MpayDetailData5.toString());

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //추가 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //해외지급내역수정 추가 2002/02/21

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

                req.setAttribute("year", year);
                req.setAttribute("month", month);
                req.setAttribute("ocrsn", ocrsn);
                req.setAttribute("seqnr", seqnr);  // 5월 21일 순번 추가

               	dest = WebUtil.JspURL+"D/D05Mpay/D05Mpayhwahak.jsp";

 /****************************************************************************
 *   month_kubyo => 월급여  => D06Ypay/D06MpayDetail.jsp 연급여의 월급여조회
 *****************************************************************************/
            }else if(jobid.equals("month_kubyo")){

                String zyymm = box.get("zyymm");
                String year  = zyymm.substring(0,4);
                String month = zyymm.substring(4);
                 ocrsn = "ZZ";
                 seqnr = "";
                String yymm  = year + month;

//              lg화학과 석유화학을 구별(휴가일수)
                if(user.companyCode.equals("C100")) {
                    yymmdd = year + month + "20";
                } else {
          	        yymmdd = year + month + "15";
                }

                //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH ----------------------------------------
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
                String           mapPernr = "";

                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                String mapDate = "";
                int    cnt     = 0;

                if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                    cnt = mapData_vt.size();
                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);
                        mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                        mapDate = mapDate.substring(0,6);

                        if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
                            cnt--;
                        }
                    }

                    if ( cnt == mapData_vt.size() ) {
                        mapPernr = user.empNo;
                    } else {
                        mapData = (MappingPernrData)mapData_vt.get(cnt);
                        mapPernr = mapData.PERNR;
                    }
                } else {
                    mapPernr = user.empNo;
                }
                ///-----------------------------------------------------------------------------------

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // 급여사유 코드와 TEXT

       //         Logger.debug.println(this, "선택한 년도 : "+ year+"선택한 월:"+month+"선택한 임금유형:"+ocrsn+"yymm;"+yymm);
       //         Logger.debug.println(this, "급여사유 코드와 TEXT : "+ d05ZocrsnTextData_vt.toString());

                D05MpayDetailRFC   rfc                = new D05MpayDetailRFC();
                D05MpayDetailData4 d05MpayDetailData4 = null;
                D05MpayDetailData5 d05MpayDetailData5 = null;
                D05MpayDetailData3 data               = new D05MpayDetailData3();
                D05MpayDetailData2 data4              = new D05MpayDetailData2();//추가 2002/02/21
                D05MpayDetailData1 data6              = new D05MpayDetailData1();//추가(해외급여)추가 2002/02/21
                D05MpayDetailData1 data7              = new D05MpayDetailData1();//추가(해외급여)추가 2002/02/21

                Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);

                Vector d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // 5월 21일 순번 추가
                Vector d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // 5월 21일 순번 추가
                Vector d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5월 21일 순번 추가
                Vector d05MpayDetailData4_vt = new Vector();
                Vector d05MpayDetailData5_vt = new Vector();//추가 2002/02/21
                Vector d05MpayDetailData6_vt = new Vector();//추가(해외급여) 2002/02/21

       //         Logger.debug.println(this, "과세추가내역1 : "+ d05MpayDetailData3_vt.toString());
                for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
              	    data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
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
     //           Logger.debug.println(this, " 변형 과세추가내역 : "+ d05MpayDetailData4_vt.toString());

                d05MpayDetailData4 = (D05MpayDetailData4)Utils.indexOf(sum, 3);  //rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5월 21일 순번 추가
                d05MpayDetailData5 = (D05MpayDetailData5)Utils.indexOf(sum, 4);  //rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5월 21일 순번 추가

//              지급내역 text 2002/02/21
                for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                    data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                    D05MpayDetailData2 data5               = new D05MpayDetailData2();

                    if(!data4.LGTXT.equals("")) {
                        data5.LGTXT = data4.LGTXT ;
                        data5.ANZHL = data4.ANZHL ;
                        data5.BET01 = data4.BET01 ;

                        d05MpayDetailData5_vt.addElement(data5);
                    }
                }
      //          Logger.debug.println(this, " 지급내역size : "+ d05MpayDetailData5_vt.size());
     //           Logger.debug.println(this, " 지급내역text : "+ d05MpayDetailData5_vt.toString());

                for( int i = 0 ; i < d05MpayDetailData1_vt.size() ; i++ ) {
                    data6  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(i);
                    D05MpayDetailData1 data8 = new D05MpayDetailData1();
                    String LGT = (String)  data6.LGTXT+"(현지화)";

                    for ( int j = 0 ; j < d05MpayDetailData1_vt.size() ; j++ ) {
                        data7  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(j);

                        if(LGT.equals((String) data7.LGTX1)) {
                            data8.LGTXT = data6.LGTXT;
                            data8.LGTX1 = data7.LGTX1;
                            data8.BET01 = data6.BET01;
                            data8.BET02 = data6.BET02;
                            data8.BET03 = data7.BET03;
                            break;
                        }else{
                            data8.LGTXT = data6.LGTXT;
                            data8.LGTX1 = "";
                            data8.BET01 = data6.BET01;
                            data8.BET02 = data6.BET02;
                            data8.BET03 = "0";
                        }
                    }
     //               Logger.debug.println(this,"통과" );
                    d05MpayDetailData6_vt.addElement(data8);
                }
      //          Logger.debug.println(this, " 해외내역수정 : "+ d05MpayDetailData6_vt.toString());

//                if( d05MpayDetailData1_vt.size() == 0 && d05MpayDetailData2_vt.size() == 0 && d05MpayDetailData3_vt.size() == 0 ) {
//                    Logger.debug.println(this, "Data Not Found");
//                    String msg = "msg004";
//                    req.setAttribute("msg", msg);
//                    dest = WebUtil.JspURL+"common/caution.jsp";
//                } else {
     //           Logger.debug.println(this, "해외급여 반영내역(항목) 내역 : "+ d05MpayDetailData1_vt.toString());
     //           Logger.debug.println(this, "지급내역/공제내역  : "+ d05MpayDetailData1_vt.toString());
     //           Logger.debug.println(this, "과세추가내역 : "+ d05MpayDetailData1_vt.toString());

     //           Logger.debug.println(this, "급여명세표 - 개인정보/환율 내역  : "+ d05MpayDetailData4.toString());
     //           Logger.debug.println(this, "지급내역/공제내역 합  : "+ d05MpayDetailData5.toString());

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //추가 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //해외지급내역수정 추가 2002/02/21

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

                req.setAttribute("year", year);
                req.setAttribute("month", month);

                dest = WebUtil.JspURL+"D/D06Ypay/D06MpayDetail.jsp";
//                }

/******************************************************************************
 * load 연급여?                => D06YpayDetail_to_year2.jsp
 */
//            }else if(jobid.equals("load")){
//            	dest = WebUtil.JspURL+"D/D06Ypay/D06YpayDetail_to_year2.jsp";
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
