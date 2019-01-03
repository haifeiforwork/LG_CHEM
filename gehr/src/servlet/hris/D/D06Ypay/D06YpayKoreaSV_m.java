/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 연급여                                                      */
/*   Program Name : 연급여                                                      */
/*   Program ID   : D06YpayDetail_to_yearSV_m                                   */
/*   Description  : 2003/01/13 연말정산으로 인한 연급여 생성. (연말정산용)      */
/*                  개인의 연급여에 대한 상세내용을 조회하여 값을 넘겨주는 class*/
/*   Note         :                                                             */
/*   Creation     : 2003-01-13  최영호                                          */
/*   Update       : 2005-01-20  최영호                                          */
/*   Update       : 2007-01-22  @v1.0 lsa 변수 clear 안되어 오류로 수정         */
/*   Update       : 2013-06-24 [CSR ID:2353407] sap에 추가암검진 추가 건  */
/*                      2016-03-23 [CSR ID:2995203] 보상명세서 적용(Total Compensation)                                                        */
/*						//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel */
/*                     2018-03-29 [요청번호]C20180329_48084 | [서비스번호]3648084  태국법인(회사코드 G530) MSS 화면 수정 */
/*                     //@PJ.베트남 하이퐁 법인 RollOut 프로젝트 추가  2018/04/17 Kang */
/********************************************************************************/


package servlet.hris.D.D06Ypay;

import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D06Ypay.D06FpayDetailData;
import hris.D.D06Ypay.D06FpayDetailData1;
import hris.D.D06Ypay.D06YpayDetailData;
import hris.D.D06Ypay.D06YpayDetailData2_to_year;
import hris.D.D06Ypay.D06YpayDetailData3_to_year;
import hris.D.D06Ypay.D06YpayDetailData4_to_year;
import hris.D.D06Ypay.D06YpayDetailData_to_year;
import hris.D.D06Ypay.D06YpayTaxDetailData;
import hris.D.D06Ypay.D06YpayTaxDetailData_to_year;
import hris.D.D06Ypay.rfc.D06FpayDetailRFC;
import hris.D.D06Ypay.rfc.D06YpayDetail2_to_yearRFC;
import hris.D.D06Ypay.rfc.D06YpayDetailRFC;
import hris.D.D06Ypay.rfc.D06YpayDetail_to_yearRFC;
import hris.D.D06Ypay.rfc.D06YpayTaxDetailRFC;
import hris.D.D06Ypay.rfc.D06YpayTaxDetail_to_yearRFC;
import hris.common.MappingPernrData;
import hris.common.WebUserData;
import hris.common.rfc.MappingPernrRFC;


public class D06YpayKoreaSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String dest  = "";
            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E") || isBlocklist(user) ) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
                return;
            }
            if(!"X".equals(user_m.e_mss)) {
                req.setAttribute("title", "COMMON.MENU.ESS_PY_ANNU_PAY");
                req.setAttribute("servlet", "hris.D.D06Ypay.D06YpayKoreaSV_m");

            	 printJspPage(req, res, WebUtil.JspURL+"common/MSS_SearchPernNameOrg.jsp");
            	 return;
            }

            /**
             * Start: 국가별 분기처리
             * //@PJ.태국법인 Rollout 프로젝트 추가 관련 (Area = TH) 추가 ([요청번호]C20180329_48084 | [서비스번호]3648084  )
             * //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
             * //@PJ.베트남 하이퐁 법인    Rollout 프로젝트 추가 관련(Area = OT("99")/G580) 2018/04/19 Kang
             */
            String fdUrl = ".";

           if (user_m.area.equals(Area.CN) || user_m.area.equals(Area.TW) || user_m.area.equals(Area.HK)|| user.area.equals(Area.TH)||(user_m.area.equals(Area.OT) && user_m.companyCode.equals("G580")) ) {	// 타이완,홍콩은 중국화면으로
               fdUrl = "hris.D.D06Ypay.D06YpayEastSV_m";
			} else if (user_m.area.equals(Area.PL) || user_m.area.equals(Area.DE) || user_m.area.equals(Area.US) || user_m.area.equals(Area.MX) ) { // PL 폴랜드, DE 독일 은 유럽화면으로
        	   fdUrl = "hris.D.D06Ypay.D06YpayWestSV_m";
			} else if(user_m.area.getMolga().equals("")){
	            req.setAttribute("url", "history.back();");
	            req.setAttribute("msg2", g.getMessage("MSG.COMMON.0029")); //국가코드가 바르지 못합니다
	            user_m.e_mss="";
                session.setAttribute("user_m", user_m);
				printJspPage(req, res,  WebUtil.JspURL + "common/msg.jsp");
				return;
			}

           Logger.debug.println(this, "-------------[user_m.area] = "+user_m.area + " fdUrl: " + fdUrl );

            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }
            /**
             * END: 국가별 분기처리
             */

            String jobid_m = "";
            String flag  = " ";
            String seqnr = "00000";


            Box box = WebUtil.getBox(req);
            jobid_m = box.get("jobid_m");

          //[CSR ID:2995203] 보상명세서 용 뒤로가기.
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            if( jobid_m.equals("") ){
                jobid_m = "first";
            }

            D06YpayDetail_to_yearRFC rfc = null;  //연말 정산 2003.01.13

            D06YpayDetailData2_to_year d06YpayDetailData2 = null;
            D06YpayDetailData3_to_year d06YpayDetailData3 = null;  // 11월 13일 노조비 추가사항 CYH.
            D06YpayDetailData4_to_year d06YpayDetailData4 = null;  // 11월 13일 생산직비과세 추가사항 CYH.
            Vector d06YpayDetailData2_vt = new Vector();
            Vector d06YpayDetailData3_vt = new Vector();
            Vector d06YpayDetailData4_vt = new Vector();  // 11월 13일 노조비 추가사항 CYH.
            Vector d06YpayDetailData5_vt = new Vector();  // 2003.01.02 과세반영으로 인한 추가.
            Vector d06YpayDetailData6_vt = new Vector();  // 2003.01.02 과세반영으로 인한 추가.
            Vector D06YpayTaxDetailData_vt = new Vector();

            Vector d06FpayDetailData_vt  = new Vector();
            Vector D06YpayDetailData_vt = new Vector();


            int sum1  = 0;
            double sum2  = 0;
            int sum3  = 0;
            double sum4  = 0;
            int sum5  = 0;
            int sum6  = 0;
            int sum7  = 0;
            int sum8  = 0;
            int sum9  = 0;
            int sum13 = 0;  // 과세반영금액 4월 15일 추가
            int sum14 = 0;  // 공제계 5월 5일 추가
            int sum15 = 0;  // 차감지급액 5월 5일 추가

            int sum10 = 0;
            int sum11 = 0;
            int sum12 = 0;
            int sum21 = 0;  // 5월 22일 세액조정액 추가
            int sum30 = 0;  // 2003.01.15 고용보험료 환급액 추가
            int sum90 = 0;

            int sum16 = 0;  // 급여총액   5월 13일
            int sum17 = 0;  // 상여총액   5월 13일
            int sum18 = 0;  // 국내생계비 총액   5월 13일
            int sum19 = 0;  // 국내주택비 총액   5월 13일
            int sum20 = 0;  // 국내주택비 총액   5월 13일
            int sumBet13 = 0; //노조비 합계[CSR ID:2995203]

            if( jobid_m.equals("first") ) {

                String year  = DataUtil.getCurrentDate().substring(0,4);
                String month = DataUtil.getCurrentDate().substring(4,6);

                Logger.debug.println(this, "현재날짜 = "+year);

                String from_year  = year;
                String from_month = "01";
                String to_year    = year;
                String to_month   = month;

                int year_be    = Integer.parseInt(from_year) + 1;
                int year_be_to = Integer.parseInt(to_year) + 1;

                String from_yymm = from_year + from_month;
                String to_yymm   = to_year + to_month;

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    // D06YpayDetailRFC 개인의 연급여 내역을 조회
                    // 연말 정산 2003.01.13
                    rfc = new D06YpayDetail_to_yearRFC();
                    D06YpayDetailData_vt = rfc.getYpayDetail(user_m.empNo, from_yymm, to_yymm,user_m.webUserId);
                    // 연말 정산 2003.01.13
                    D06YpayDetail2_to_yearRFC rfc_tax2 = new D06YpayDetail2_to_yearRFC(); // 11월 13일 생산직비과세 및 노조비 추가 cyh.
                    // 연말 정산 2003.01.13

                    /*------ 7월 23일 과세반영액 추가 --------*/
                    int w_yymm = Integer.parseInt(from_yymm);
                    int x_yymm = Integer.parseInt(to_yymm);

                    for(int i = w_yymm; i < x_yymm+1 ; i++){

                        String yymmdd_tax = Integer.toString(i) + "20";
                        d06YpayDetailData2_vt = null; // 20161018_연급여오류 반영(KSC)
                        d06YpayDetailData2_vt = rfc_tax2.getYpayDetail2(user_m.empNo, yymmdd_tax, "ZZ", flag, seqnr,user_m.webUserId); //[CSR ID:2353407]
                        d06YpayDetailData5_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 과세반영으로 인한 추가.
                        d06YpayDetailData6_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 과세반영으로 인한 추가.
                        //---------------------------------------------------------------------------------------------------------------//
                        //   11월 13일 생산직비과세 및 노조비를 위한 로직추가 CYH.
                        d06YpayDetailData4_vt = rfc_tax2.getYpayDetail3(user_m.empNo, yymmdd_tax, "ZZ", flag, seqnr,user_m.webUserId);//  [CSR ID:2353407]
                        // 연말 정산 2003.01.13
                        d06YpayDetailData4 = (D06YpayDetailData4_to_year)rfc_tax2.getPerson(user_m.empNo, yymmdd_tax, "ZZ", flag, seqnr,user_m.webUserId);
                        Logger.debug.println(this, "d06YpayDetailData4_vt. : "+ d06YpayDetailData4_vt.toString());
                        Logger.debug.println(this, "d06YpayDetailData4 : "+ d06YpayDetailData4.toString());
                        //----------------------------------------------------------------------------------------------------------------//
                        // 연말 정산 2003.01.13
                        D06YpayDetailData2_to_year data9  = new D06YpayDetailData2_to_year();
                        D06YpayDetailData3_to_year data10 = new D06YpayDetailData3_to_year(); //11월 13일 추가사항 생산직비과세 및 노조비 추가 cyh
                        D06YpayDetailData2_to_year data11 = new D06YpayDetailData2_to_year(); // 2003.01.02 과세반영으로 인한 추가.
                        D06YpayDetailData2_to_year data12 = new D06YpayDetailData2_to_year(); // 2003.01.02 과세반영으로 인한 추가.
                        double kase = 0;
                        if(d06YpayDetailData2_vt.size() == 0) {
                            data9.BET02 = d06YpayDetailData4.BET19;
                            data9.YYMMDD = Integer.toString(i);
                            //----  11월 13일 추가사항 생산직비과세 및 노조비 추가 cyh.
                            for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                                // 연말 정산 2003.01.13
                                data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                                Logger.debug.println(this, "w_yymm:"+w_yymm+"x_yymm"+x_yymm+"===data10 : "+ data10.toString());
                                if(data10.LGTX1.equals("LG화학노동조합") || data10.LGTX1.equals("여수나주노동조합") || data10.LGTX1.equals("노조비")) {

                                    data9.LGTX4  = "생산직비과세";
                                    data9.BET04 = data10.BET02;
                                }
                            }
                            d06YpayDetailData3_vt.addElement(data9);
                            //----------------------------------------------------------------------------------------------------------------//
                        }else{
                            for( int j = 0 ; j < d06YpayDetailData2_vt.size() ; j++ ){
                                // 연말 정산 2003.01.13
                                data9 = (D06YpayDetailData2_to_year)d06YpayDetailData2_vt.get(j);
                                data9.YYMMDD = Integer.toString(i);
                                data9.BET02 = d06YpayDetailData4.BET19;  // 11월 13일 추가 생산직비과세.
                                for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                                    // 연말 정산 2003.01.13
                                    data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                                    if(data10.LGTX1.equals("LG화학노동조합") || data10.LGTX1.equals("여수나주노동조합") || data10.LGTX1.equals("노조비")) {
                                    	data9.LGTX4  = "생산직비과세";
                                        data9.BET04 = data10.BET02;
                                    }
                                }
                                kase = Double.parseDouble(data9.BET01);
                                data9.BET01 = Double.toString(kase);
                                sum90 += Double.parseDouble(data9.BET01.equals("") ? "0" : data9.BET01);

                                d06YpayDetailData3_vt.addElement(data9);
                            }
                            // 2002.01.02 과세반영으로 인한 추가 cyh. --------------------------------------------------//
                            for( int j = 0 ; j < d06YpayDetailData5_vt.size() ; j++ ){
                                // 연말 정산 2003.01.13
                                data11 = (D06YpayDetailData2_to_year)d06YpayDetailData5_vt.get(j);
                                data11.YYMMDD = Integer.toString(i);

                                kase = Double.parseDouble(data11.BET02);
                                data11.BET01 = Double.toString(kase);
                                data11.LGTX1 = data11.LGTX2;
                                sum90 += Double.parseDouble(data11.BET01.equals("") ? "0" : data11.BET01);
                                d06YpayDetailData3_vt.addElement(data11);
                            }
                            for( int j = 0 ; j < d06YpayDetailData6_vt.size() ; j++ ){
                                data12 = (D06YpayDetailData2_to_year)d06YpayDetailData6_vt.get(j);
                                data12.YYMMDD = Integer.toString(i);

                                kase = Double.parseDouble(data12.BET03);
                                data12.BET01 = Double.toString(kase);
                                data12.LGTX1 = data12.LGTX3;
                                sum90 += Double.parseDouble(data12.BET01.equals("") ? "0" : data12.BET01);
                                d06YpayDetailData3_vt.addElement(data12);
                            }
                            //-------------------------------------------------------------------------------------------//
                        }
                    }

                    //----------------------------------------------------------------------------------------------------------------//
                    // 연말 정산 2003.01.13
                    D06YpayTaxDetail_to_yearRFC  rfc_tax              = new D06YpayTaxDetail_to_yearRFC();
                    D06YpayTaxDetailData_to_year d06YpayTaxDetailData = null;
                    D06YpayTaxDetailData_to_year data2                = new D06YpayTaxDetailData_to_year();

                    for( int i = year_be ; i < year_be_to+1 ; i++ ){
                        String year_af = Integer.toString(i);
                        Logger.debug.println(this, "i의 값 : "+ i);
                        // 연말 정산 2003.01.13
                        d06YpayTaxDetailData = (D06YpayTaxDetailData_to_year)rfc_tax.getTaxDetail(user_m.empNo, year_af, user.area);
                        D06YpayTaxDetailData_vt.addElement(d06YpayTaxDetailData);
                    }
                    Logger.debug.println(this, "D06YpayTaxDetailData_vt : "+ D06YpayTaxDetailData_vt.toString());
                    Logger.debug.println(this, "D06YpayTaxDetailData_vt.size() : "+ D06YpayTaxDetailData_vt.size());
                    for( int i = 0 ; i < D06YpayTaxDetailData_vt.size() ; i++ ){
                        // 연말 정산 2003.01.13
                        data2 = (D06YpayTaxDetailData_to_year)D06YpayTaxDetailData_vt.get(i);
                        Logger.debug.println(this, "data2 : "+ data2.toString());

                        sum10 += Double.parseDouble(data2.YAI == null ? "0" : data2.YAI);
                        sum11 += Double.parseDouble(data2.YAR == null ? "0" : data2.YAR);
                        sum12 += Double.parseDouble(data2.YAS == null ? "0" : data2.YAS);
                        sum21 += Double.parseDouble(data2.TAX == null ? "0" : data2.TAX);  // 5월 22일 세액조정액 추가
                        sum30 += Double.parseDouble(data2.YFE == null ? "0" : data2.YFE);  // 5월 22일 세액조정액 추가
                    }
                    Logger.debug.println(this, "sum10 : "+ sum10+"sum11 :"+sum11+"sum12 :"+sum12+"sum21 :"+sum21);
                    // 연말 정산 2003.01.13
                    D06YpayDetailData_to_year data1 = new D06YpayDetailData_to_year();

                    for( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ){
                        // 연말 정산 2003.01.13
                        data1 = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);

                        sum1  += Double.parseDouble(data1.BET01);
                        sum2  += Double.parseDouble(data1.BET02);
                        sum3  += Double.parseDouble(data1.BET03);
                        sum4  += Double.parseDouble(data1.BET04);
                        sum5  += Double.parseDouble(data1.BET05);
                        sum6  += Double.parseDouble(data1.BET06);
                        sum7  += Double.parseDouble(data1.BET07);
                        sum8  += Double.parseDouble(data1.BET08);
                        sum9  += Double.parseDouble(data1.BET09);
                        sum13 += Double.parseDouble(data1.BET10);   // 과세반영금액 4월 15일 추가
                        sum14 += Double.parseDouble(data1.BET11);   // 공제계 5월 5일 추가
                        sum15 += Double.parseDouble(data1.BET12);   // 차감지급액 5월 5일 추가
                        sumBet13 += Double.parseDouble(data1.BET13);  //노조비 합계[CSR ID:2995203]
                        Logger.debug.println(this, "first i:"+i+"==>sum2 : "+ sum2 + "sum4:"+sum4+"data1.BET04:"+data1.BET04+"data1.BET02:"+data1.BET02+" Double.parseDouble(data1.BET02):"+ Double.parseDouble(data1.BET02)+" Double.parseDouble(data1.BET04):"+ Double.parseDouble(data1.BET04));
                    }
                    Logger.debug.println(this, "sum1 : "+ sum1 + "sum9:"+sum9);
                    Logger.debug.println(this, "D06YpayDetailData_vt : "+ D06YpayDetailData_vt.toString());
                    //              Logger.debug.println(this, "d06YpayTaxDetailData : "+ d06YpayTaxDetailData.toString());
                } // if ( user_m != null ) end

                req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
                req.setAttribute("D06YpayTaxDetailData_vt", D06YpayTaxDetailData_vt);
                req.setAttribute("from_year", from_year);
                req.setAttribute("total1", Integer.toString(sum1));
                req.setAttribute("total2", Double.toString(sum2));
                req.setAttribute("total3", Integer.toString(sum3));
                req.setAttribute("total4", Double.toString(sum4));
                req.setAttribute("total5", Integer.toString(sum5));
                req.setAttribute("total6", Integer.toString(sum6));
                req.setAttribute("total7", Integer.toString(sum7));
                req.setAttribute("total8", Integer.toString(sum8));
                req.setAttribute("total9", Integer.toString(sum9));
                req.setAttribute("total10", Integer.toString(sum10));
                req.setAttribute("total11", Integer.toString(sum11));
                req.setAttribute("total12", Integer.toString(sum12));
                req.setAttribute("total13", Integer.toString(sum13));  // 과세반영금액 4월 15일 추가
                req.setAttribute("total14", Integer.toString(sum14));  // 공제계 5월 05일 추가
                req.setAttribute("total15", Integer.toString(sum15));  // 차감지급액 5월 05일 추가
                req.setAttribute("total30", Integer.toString(sum30));  // 고용보험료 환급액 2003.01.15 추가
                req.setAttribute("total21", Integer.toString(sum21));  // 세액조정액 5월 22일 추가
                req.setAttribute("total90", Integer.toString(sum90));  // 과세반영 총액  7월 23일 추가
                req.setAttribute("D06YpayDetailData3_vt", d06YpayDetailData3_vt);  // 월별 과세반영액 7월 23일  추가
                req.setAttribute("totalBet13", Integer.toString(sumBet13));  // 노조비 합계[CSR ID:2995203]

                dest = WebUtil.JspURL+"D/D06Ypay/D06YpayKorea_m.jsp";
                //            }

            }else if(jobid_m.equals("search")){
                String from_year  = box.get("from_year1");
                String from_month = box.get("from_month1");
                String to_year    = box.get("to_year1");
                String year       = DataUtil.getCurrentDate().substring(0,4);
                String to_month = "";
                if (!from_year.equals(year)){
                    to_month = "12";
                }else{
                    to_month = box.get("to_month1");
                }

                int year_be    = Integer.parseInt(from_year) + 1;
                int year_be_to = Integer.parseInt(to_year) + 1;

                String from_yymm = from_year + from_month;
                String to_yymm   = to_year + to_month;

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());
                    Logger.debug.println(this, "선택한 시작년도 : "+ from_year + "선택한 시작월:"+from_month);
                    Logger.debug.println(this, "선택한 끝년도 : "+ to_year + "선택한 끝월:"+to_month);
                    // 연말 정산 2003.01.13
                    D06YpayDetailData_to_year data1 = new D06YpayDetailData_to_year();

                    // 연말 정산 2003.01.13
                    D06YpayDetail2_to_yearRFC  rfc_tax2           = new D06YpayDetail2_to_yearRFC();

                    /*------ 7월 23일 과세반영액 추가 --------*/
                    int w_yymm = Integer.parseInt(from_yymm);
                    int x_yymm = Integer.parseInt(to_yymm);

                    for(int i = w_yymm; i < x_yymm+1 ; i++){

                        String yymmdd_tax = Integer.toString(i) + "20";

                        //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH /////////////////////////////////////////
                        MappingPernrRFC  mapfunc    = null ;
                        MappingPernrData mapData    = new MappingPernrData();
                        Vector           mapData_vt = new Vector() ;
                        String           mapPernr = "";

                        mapfunc    = new MappingPernrRFC() ;
                        mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                        String mapDate = "";
                        int    cnt     = 0;

                        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                            cnt = mapData_vt.size();
                            for ( int a=0; a < mapData_vt.size(); a++) {
                                mapData = (MappingPernrData)mapData_vt.get(a);
                                mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                                mapDate = mapDate.substring(0,6);

                                if ( i >= Integer.parseInt(mapDate) ) {
                                    cnt--;
                                }
                            }

                            if ( cnt == mapData_vt.size() ) {
                                mapPernr = user_m.empNo;
                            } else {
                                mapData = (MappingPernrData)mapData_vt.get(cnt);
                                mapPernr = mapData.PERNR;
                            }
                        } else {
                            mapPernr = user_m.empNo;
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////////
                        d06YpayDetailData2_vt = null; // 20161018_연급여오류 반영(KSC)
                        d06YpayDetailData2_vt = rfc_tax2.getYpayDetail2(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user_m.webUserId);
                        d06YpayDetailData5_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 과세반영으로 인한 추가.
                        d06YpayDetailData6_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 과세반영으로 인한 추가.

                        //---------------------------------------------------------------------------------------------------------------//
                        //   11월 13일 생산직비과세 및 노조비를 위한 로직추가 CYH.
                        d06YpayDetailData4_vt = rfc_tax2.getYpayDetail3(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user_m.webUserId);
                        // 연말 정산 2003.01.13
                        d06YpayDetailData4 = (D06YpayDetailData4_to_year)rfc_tax2.getPerson(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user_m.webUserId);
                        Logger.debug.println(this, "d06YpayDetailData4_vt. : "+ d06YpayDetailData4_vt.toString());
                        Logger.debug.println(this, "d06YpayDetailData4 : "+ d06YpayDetailData4.toString());
                        //----------------------------------------------------------------------------------------------------------------//
                        Logger.debug.println(this, "[d06YpayDetailData2_vt. : "+ d06YpayDetailData2_vt+"yymmdd_tax:"+yymmdd_tax);
                        // 연말 정산 2003.01.13
                        D06YpayDetailData2_to_year data9  = new D06YpayDetailData2_to_year();
                        D06YpayDetailData3_to_year data10 = new D06YpayDetailData3_to_year(); //11월 13일 추가사항 생산직비과세 및 노조비 추가 cyh
                        D06YpayDetailData2_to_year data11 = new D06YpayDetailData2_to_year(); // 2003.01.02 과세반영으로 인한 추가.
                        D06YpayDetailData2_to_year data12 = new D06YpayDetailData2_to_year(); // 2003.01.02 과세반영으로 인한 추가.
                        double kase = 0;
                        if(d06YpayDetailData2_vt.size() == 0) {
                            data9.BET02 = d06YpayDetailData4.BET19;
                            data9.YYMMDD = Integer.toString(i);
                            //----  11월 13일 추가사항 생산직비과세 및 노조비 추가 cyh.
                            for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                                // 연말 정산 2003.01.13
                                data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                                Logger.debug.println(this, "===data10-1 : "+ data10.toString());

                                if(data10.LGTX1.equals("LG화학노동조합") || data10.LGTX1.equals("여수나주노동조합") || data10.LGTX1.equals("노조비")) {
                                    data9.LGTX4  = "생산직비과세";
                                    data9.BET04 = data10.BET02;
                                }
                                //else {  data9.BET03 = "0";   }  //@v1.0 오류로 인해 추가

                            }
                            d06YpayDetailData3_vt.addElement(data9);
                            Logger.debug.println(this, "data9_1-1 : "+ data9.toString());
                            //----------------------------------------------------------------------------------------------------------------//
                        }else{
                            for( int j = 0 ; j < d06YpayDetailData2_vt.size() ; j++ ){
                                // 연말 정산 2003.01.13
                                data9 = (D06YpayDetailData2_to_year)d06YpayDetailData2_vt.get(j);
                                data9.YYMMDD = Integer.toString(i);
                                data9.BET02 = d06YpayDetailData4.BET19;  // 11월 13일 추가 생산직비과세.
                                for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                                    // 연말 정산 2003.01.13
                                    data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);

                                    if(data10.LGTX1.equals("LG화학노동조합") || data10.LGTX1.equals("여수나주노동조합") || data10.LGTX1.equals("노조비")) {
                                    	data9.LGTX4  = "생산직비과세"; //@v1.2추가
                                        data9.BET04 = data10.BET02;
                                    }
                                    //else {  data9.BET03 = "0";   }  //@v1.0 오류로 인해 추가
                                }
                                Logger.debug.println(this, "data9.YYMMDD : "+ data9.YYMMDD);
                                Logger.debug.println(this, "data9_2 : "+ data9.toString());

                                kase = Double.parseDouble(data9.BET01);
                                data9.BET01 = Double.toString(kase);
                                sum90 += Double.parseDouble(data9.BET01.equals("") ? "0" : data9.BET01);
                                d06YpayDetailData3_vt.addElement(data9);
                            }
                            // 2002.01.02 과세반영으로 인한 추가 cyh. --------------------------------------------------//
                            for( int j = 0 ; j < d06YpayDetailData5_vt.size() ; j++ ){
                                // 연말 정산 2003.01.13
                                data11 = (D06YpayDetailData2_to_year)d06YpayDetailData5_vt.get(j);
                                data11.YYMMDD = Integer.toString(i);

                                kase = Double.parseDouble(data11.BET02);
                                data11.BET01 = Double.toString(kase);
                                data11.LGTX1 = data11.LGTX2;
                                sum90 += Double.parseDouble(data11.BET01.equals("") ? "0" : data11.BET01);
                                d06YpayDetailData3_vt.addElement(data11);
                            }
                            for( int j = 0 ; j < d06YpayDetailData6_vt.size() ; j++ ){
                                data12 = (D06YpayDetailData2_to_year)d06YpayDetailData6_vt.get(j);
                                data12.YYMMDD = Integer.toString(i);

                                kase = Double.parseDouble(data12.BET03);
                                data12.BET01 = Double.toString(kase);
                                data12.LGTX1 = data12.LGTX3;
                                sum90 += Double.parseDouble(data12.BET01.equals("") ? "0" : data12.BET01);
                                d06YpayDetailData3_vt.addElement(data12);
                            }
                            //-------------------------------------------------------------------------------------------//
                        }
                    }
                    Logger.debug.println(this, "d06YpayDetailData3_vt.wwwww : "+ d06YpayDetailData3_vt);
                    Logger.debug.println(this, "D06YpayDetailData3_vt.SIZE : "+ d06YpayDetailData3_vt.size());

                    //----------------------------------------------------------------------------------------------------------------//
                    // 연말 정산 2003.01.13
                    D06YpayTaxDetail_to_yearRFC  rfc_tax              = new D06YpayTaxDetail_to_yearRFC();
                    D06YpayTaxDetailData_to_year d06YpayTaxDetailData = null;
                    D06YpayTaxDetailData_to_year data2                = new D06YpayTaxDetailData_to_year();

                    for( int i = year_be ; i < year_be_to+1 ; i++ ){

                        //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH /////////////////////////////////////////
                        MappingPernrRFC  mapfunc    = null ;
                        MappingPernrData mapData    = new MappingPernrData();
                        Vector           mapData_vt = new Vector() ;
                        String           mapPernr = "";

                        mapfunc    = new MappingPernrRFC() ;
                        mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                        String mapDate = "";
                        int    cnt     = 0;

                        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                            cnt = mapData_vt.size();
                            for ( int a=0; a < mapData_vt.size(); a++) {
                                mapData = (MappingPernrData)mapData_vt.get(a);
                                mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                                mapDate = mapDate.substring(0,4);

                                if ( (i-1) >= Integer.parseInt(mapDate) ) {
                                    cnt--;
                                }
                            }

                            if ( cnt == mapData_vt.size() ) {
                                mapPernr = user_m.empNo;
                            } else {
                                mapData = (MappingPernrData)mapData_vt.get(cnt);
                                mapPernr = mapData.PERNR;
                            }
                        } else {
                            mapPernr = user_m.empNo;
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////////

                        String year_af = Integer.toString(i);
                        Logger.debug.println(this, "i의 값 : "+ i);
                        // 연말 정산 2003.01.13
                        d06YpayTaxDetailData = (D06YpayTaxDetailData_to_year)rfc_tax.getTaxDetail(mapPernr, year_af, user.area);
                        D06YpayTaxDetailData_vt.addElement(d06YpayTaxDetailData);
                    }
                    Logger.debug.println(this, "D06YpayTaxDetailData_vt : "+ D06YpayTaxDetailData_vt.toString());
                    Logger.debug.println(this, "D06YpayTaxDetailData_vt.size() : "+ D06YpayTaxDetailData_vt.size());
                    for( int i = 0 ; i < D06YpayTaxDetailData_vt.size() ; i++ ){
                        // 연말 정산 2003.01.13
                        data2 = (D06YpayTaxDetailData_to_year)D06YpayTaxDetailData_vt.get(i);
                        Logger.debug.println(this, "data2 : "+ data2.toString());

                        sum10 += Double.parseDouble(data2.YAI == null ? "0" : data2.YAI);
                        sum11 += Double.parseDouble(data2.YAR == null ? "0" : data2.YAR);
                        sum12 += Double.parseDouble(data2.YAS == null ? "0" : data2.YAS);
                        sum21 += Double.parseDouble(data2.TAX == null ? "0" : data2.TAX);  // 5월 22일 세액조정액 추가
                        sum30 += Double.parseDouble(data2.YFE == null ? "0" : data2.YFE);  // 5월 22일 세액조정액 추가
                    }
                    Logger.debug.println(this, "sum10 : "+ sum10+"sum11 :"+sum11+"sum12 :"+sum12+"sum21 :"+sum21);


                    //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH ////////////////////////////////////////
                    MappingPernrRFC  mapfunc    = null ;
                    MappingPernrData mapData    = new MappingPernrData();
                    Vector           mapData_vt = new Vector() ;
                    String           mapPernr = "";
                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                    Vector           mapD06Data_vt = null;
                    D06YpayDetailData_to_year mdata = new D06YpayDetailData_to_year();
                    D06YpayDetail_to_yearRFC mrfc = null;

                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);

                        mrfc = new D06YpayDetail_to_yearRFC();
                        mapD06Data_vt = new Vector();
                        mapD06Data_vt = mrfc.getYpayDetail(mapData.PERNR, from_yymm, to_yymm,user_m.webUserId);

                        if(mrfc.getReturn().isSuccess()){
	                        for( int j = 0 ; j < mapD06Data_vt.size() ; j++ ) {
	                            mdata = (D06YpayDetailData_to_year)mapD06Data_vt.get(j);
	                            D06YpayDetailData_vt.addElement(mdata);

	                            Logger.debug.println(this, "search mdata j:"+j+"mapData.PERNR:"+mapData.PERNR+" from_yymm:"+ from_yymm+" to_yymm:" +to_yymm+"==>mdata : "+ mdata.toString());
	                        }
                        }
                    }
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    // D06YpayDetailRFC 개인의 연급여 내역을 조회
                    // 연말 정산 2003.01.13
                    //                rfc = new D06YpayDetail_to_yearRFC();
                    //                D06YpayDetailData_vt = rfc.getYpayDetail(user_m.empNo, from_yymm, to_yymm);

                    for( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ){
                        // 연말 정산 2003.01.13
                        data1 = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);

                        sum1  += Double.parseDouble(data1.BET01);
                        sum2  += Double.parseDouble(data1.BET02);
                        sum3  += Double.parseDouble(data1.BET03);
                        sum4  += Double.parseDouble(data1.BET04);
                        sum5  += Double.parseDouble(data1.BET05);
                        sum6  += Double.parseDouble(data1.BET06);
                        sum7  += Double.parseDouble(data1.BET07);
                        sum8  += Double.parseDouble(data1.BET08);
                        sum9  += Double.parseDouble(data1.BET09);
                        sum13 += Double.parseDouble(data1.BET10);
                        sum14 += Double.parseDouble(data1.BET11);   // 공제계 5월 5일 추가
                        sum15 += Double.parseDouble(data1.BET12);   // 차감지급액 5월 5일 추가
                        sumBet13 += Double.parseDouble(data1.BET13);  //노조비 합계[CSR ID:2995203]

                        Logger.debug.println(this, "search [[[[[i:"+i+"==>sum2 : "+ sum2 + "sum4:"+sum4+"data1.BET02:"+data1.BET02+"data1.BET04:"+data1.BET04);
                    }
                    Logger.debug.println(this, "sum1 : "+ sum1 + "sum9:"+sum9);
                    Logger.debug.println(this, "D06YpayDetailData_vt : "+ D06YpayDetailData_vt.toString());
                } // if ( user_m != null ) end

                req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
                req.setAttribute("D06YpayTaxDetailData_vt", D06YpayTaxDetailData_vt);
                req.setAttribute("from_year", from_year);
                req.setAttribute("total1", Integer.toString(sum1));
                req.setAttribute("total2", Double.toString(sum2));
                req.setAttribute("total3", Integer.toString(sum3));
                req.setAttribute("total4", Double.toString(sum4));
                req.setAttribute("total5", Integer.toString(sum5));
                req.setAttribute("total6", Integer.toString(sum6));
                req.setAttribute("total7", Integer.toString(sum7));
                req.setAttribute("total8", Integer.toString(sum8));
                req.setAttribute("total9", Integer.toString(sum9));
                req.setAttribute("total10", Integer.toString(sum10));
                req.setAttribute("total11", Integer.toString(sum11));
                req.setAttribute("total12", Integer.toString(sum12));
                req.setAttribute("total13", Integer.toString(sum13));
                req.setAttribute("total14", Integer.toString(sum14));  // 공제계 5월 05일 추가
                req.setAttribute("total15", Integer.toString(sum15));  // 차감지급액 5월 05일 추가
                req.setAttribute("total21", Integer.toString(sum21));  // 세액조정액 5월 22일 추가
                req.setAttribute("total30", Integer.toString(sum30));  // 고용보험료 환급액 2003.01.15 추가
                req.setAttribute("total90", Integer.toString(sum90));  // 과세반영 총액  7월 23일 추가
                req.setAttribute("D06YpayDetailData3_vt", d06YpayDetailData3_vt);  // 월별 과세반영액 7월 23일  추가
                req.setAttribute("totalBet13", Integer.toString(sumBet13));  // 노조비 합계[CSR ID:2995203]

                dest = WebUtil.JspURL+"D/D06Ypay/D06YpayKorea_m.jsp";
                //          }
            }else if(jobid_m.equals("foriegn")){
                String from_year  = box.get("from_year1");
                String from_month = box.get("from_month1");
                String to_year    = box.get("to_year1");
                String to_month   = box.get("to_month1");

                //연말정산 연도를 만들어줌
                int year_be    = Integer.parseInt(from_year) + 1;
                int year_be_to = Integer.parseInt(to_year) + 1;

                String from_yymm = from_year + from_month;
                String to_yymm   = to_year + to_month;

                if ( user_m != null ) {

                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());
                    Logger.debug.println(this, "선택한 시작년도 : "+ from_year + "선택한 시작월:"+from_month);
                    Logger.debug.println(this, "선택한 끝년도 : "+ to_year + "선택한 끝월:"+to_month);

                    // 해외근무자 국내급여내역
                    int s_yymm = Integer.parseInt(from_yymm);
                    int e_yymm = Integer.parseInt(to_yymm);

                    D06FpayDetailRFC  rfc_fpay          = new D06FpayDetailRFC();
                    D06FpayDetailData d06FpayDetailData = null;
                    D06FpayDetailData1 data10 = new D06FpayDetailData1();

                    for(int i = s_yymm; i < e_yymm+1 ; i++){

                        String yymm1 = Integer.toString(i);
                        if(yymm1.substring(4).equals("13")){ i = i+100-12 ; }
                        Logger.debug.println(this, "i의 값 : "+ i);
                        String yymm = Integer.toString(i) + "25";

                        //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH /////////////////////////////////////////
                        MappingPernrRFC  mapfunc    = null ;
                        MappingPernrData mapData    = new MappingPernrData();
                        Vector           mapData_vt = new Vector() ;
                        String           mapPernr = "";

                        mapfunc    = new MappingPernrRFC() ;
                        mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                        String mapDate = "";
                        int    cnt     = 0;

                        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                            cnt = mapData_vt.size();
                            for ( int a=0; a < mapData_vt.size(); a++) {
                                mapData = (MappingPernrData)mapData_vt.get(a);
                                mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                                mapDate = mapDate.substring(0,6);

                                if ( i >= Integer.parseInt(mapDate) ) {
                                    cnt--;
                                }
                            }

                            if ( cnt == mapData_vt.size() ) {
                                mapPernr = user_m.empNo;
                            } else {
                                mapData = (MappingPernrData)mapData_vt.get(cnt);
                                mapPernr = mapData.PERNR;
                            }
                        } else {
                            mapPernr = user_m.empNo;
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////////

                        d06FpayDetailData = (D06FpayDetailData)rfc_fpay.getFpayDetail(mapPernr, yymm, "ZZ", " ");

                        Vector d05MpayDetailData5_vt = rfc_fpay.getMpayDetail(mapPernr, yymm, "ZZ", " ");
                        Logger.debug.println(this, "d05MpayDetailData5_vt.size() : "+ d05MpayDetailData5_vt.size());

                        for(int j=0 ; j < d05MpayDetailData5_vt.size() ; j++) {

                            D06FpayDetailData data11 = new D06FpayDetailData();
                            data10  = (D06FpayDetailData1)d05MpayDetailData5_vt.get(j);

                            if( data10.LGTXT.equals("상여금(해외급여자)") ) {
                                d06FpayDetailData.BET15 = data10.BET01;  // 상여금.
                                sum4 += Double.parseDouble(data10.BET01);
                            }
                        }
                        sum1 += Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET01,"0"));
                        sum2 += Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET07,"0"));
                        sum3 += Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET08,"0"));
                        sum16 += Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET16,"0"));
                        sum17 += Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET17,"0"));
                        sum18 += Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET04,"0"));  // 국내생계비 총액 5월 13일
                        sum19 += Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET05,"0"));  // 국내주택비 총액 5월 13일
                        sum20 += Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET16,"0")) +
                        		Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET17,"0")) +
                        		Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET04,"0")) +
                        		Double.parseDouble(WebUtil.nvl(d06FpayDetailData.BET05,"0"));

                        d06FpayDetailData.FYYMM = yymm;
                        d06FpayDetailData_vt.addElement(d06FpayDetailData);
                    }
                    Logger.debug.println(this, "d06FpayDetailData_vt : "+ d06FpayDetailData_vt.toString());

                    //연말정산 RFC
                    D06YpayTaxDetailRFC  rfc_tax              = new D06YpayTaxDetailRFC();
                    D06YpayTaxDetailData d06YpayTaxDetailData = null;
                    D06YpayTaxDetailData data2                = new D06YpayTaxDetailData();

                    for( int i = year_be ; i < year_be_to+1 ; i++ ){

                        //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH /////////////////////////////////////////
                        MappingPernrRFC  mapfunc    = null ;
                        MappingPernrData mapData    = new MappingPernrData();
                        Vector           mapData_vt = new Vector() ;
                        String           mapPernr = "";

                        mapfunc    = new MappingPernrRFC() ;
                        mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                        String mapDate = "";
                        int    cnt     = 0;

                        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                            cnt = mapData_vt.size();
                            for ( int a=0; a < mapData_vt.size(); a++) {
                                mapData = (MappingPernrData)mapData_vt.get(a);
                                mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                                mapDate = mapDate.substring(0,4);

                                if ( (i-1) >= Integer.parseInt(mapDate) ) {
                                    cnt--;
                                }
                            }

                            if ( cnt == mapData_vt.size() ) {
                                mapPernr = user_m.empNo;
                            } else {
                                mapData = (MappingPernrData)mapData_vt.get(cnt);
                                mapPernr = mapData.PERNR;
                            }
                        } else {
                            mapPernr = user_m.empNo;
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////////

                        String year_af = Integer.toString(i);
                        Logger.debug.println(this, "i의 value : "+ i);
                        d06YpayTaxDetailData = (D06YpayTaxDetailData)rfc_tax.getTaxDetail(mapPernr, year_af, user.area);
                        D06YpayTaxDetailData_vt.addElement(d06YpayTaxDetailData);
                    }
                    Logger.debug.println(this, "D06YpayTaxDetailData_vt : "+ D06YpayTaxDetailData_vt.toString());
                    Logger.debug.println(this, "D06YpayTaxDetailData_vt.size() : "+ D06YpayTaxDetailData_vt.size());
                    for( int i = 0 ; i < D06YpayTaxDetailData_vt.size() ; i++ ){

                        data2 = (D06YpayTaxDetailData)D06YpayTaxDetailData_vt.get(i);
                        Logger.debug.println(this, "data2 : "+ data2.toString());

                        sum10 += Double.parseDouble(data2.YAI == null ? "0" : data2.YAI);
                        sum11 += Double.parseDouble(data2.YAR == null ? "0" : data2.YAR);
                        sum12 += Double.parseDouble(data2.YAS == null ? "0" : data2.YAS);
                        sum21 += Double.parseDouble(data2.TAX == null ? "0" : data2.TAX);  // 5월 22일 세액조정액 추가
                    }
                    Logger.debug.println(this, "sum10 : "+ sum10+"sum11 :"+sum11+"sum12 :"+sum12);

                    //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH ////////////////////////////////////////
                    MappingPernrRFC  mapfunc    = null ;
                    MappingPernrData mapData    = new MappingPernrData();
                    Vector           mapData_vt = new Vector() ;
                    String           mapPernr = "";
                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                    Vector           mapD06Data_vt = null;
                    D06YpayDetailData mdata = new D06YpayDetailData();
                    D06YpayDetailRFC mrfc = null;

                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);

                        mrfc = new D06YpayDetailRFC();
                        mapD06Data_vt = new Vector();
                        mapD06Data_vt = mrfc.getYpayDetail(mapData.PERNR, from_yymm, to_yymm,user_m.webUserId);

                        if(mrfc.getReturn().isSuccess()){
	                        for( int j = 0 ; j < mapD06Data_vt.size() ; j++ ) {
	                            mdata = (D06YpayDetailData)mapD06Data_vt.get(j);
	                            D06YpayDetailData_vt.addElement(mdata);
	                        }
                        }
                    }
                    ////////////////////////////////////////////////////////////////////////////////////////////

                    // D06YpayDetailRFC 개인의 연급여 내역을 조회
                    //                D06YpayDetailRFC  rfc                  = null;
                    //                Vector            D06YpayDetailData_vt = null;
                    //                D06YpayDetailData data1                = new D06YpayDetailData();

                    //                rfc = new D06YpayDetailRFC();
                    //                D06YpayDetailData_vt = rfc.getYpayDetail(user_m.empNo, from_yymm, to_yymm);

                } // if ( user_m != null ) end

                if ( D06YpayDetailData_vt.size() == 0 ) {
                    Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";

                } else {
                    Logger.debug.println(this, "D06YpayDetailData_vt : "+ D06YpayDetailData_vt.toString());

                    req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
                    req.setAttribute("d06FpayDetailData_vt", d06FpayDetailData_vt);
                    req.setAttribute("D06YpayTaxDetailData_vt", D06YpayTaxDetailData_vt);
                    req.setAttribute("from_year", from_year);
                    req.setAttribute("from_month", from_month);
                    req.setAttribute("to_year", to_year);
                    req.setAttribute("to_month", to_month);
                    req.setAttribute("total1", Integer.toString(sum1));
                    req.setAttribute("total2", Double.toString(sum2));
                    req.setAttribute("total3", Integer.toString(sum3));
                    req.setAttribute("total4", Double.toString(sum4));
                    req.setAttribute("total10", Integer.toString(sum10));
                    req.setAttribute("total11", Integer.toString(sum11));
                    req.setAttribute("total12", Integer.toString(sum12));
                    req.setAttribute("total16", Integer.toString(sum16));
                    req.setAttribute("total17", Integer.toString(sum17));
                    req.setAttribute("total18", Integer.toString(sum18));
                    req.setAttribute("total19", Integer.toString(sum19));
                    req.setAttribute("total20", Integer.toString(sum20));
                    req.setAttribute("total21", Integer.toString(sum21));  // 세액조정액 5월 22일 추가

                    dest = WebUtil.JspURL+"D/D06Ypay/D06FpayDetail_m.jsp";
                }

            }else if(jobid_m.equals("print")){
                String from_year  = box.get("from_year1");
                String from_month = box.get("from_month1");
                String to_year    = box.get("to_year1");
                String year       = DataUtil.getCurrentDate().substring(0,4);
                String to_month = "";
                if (!from_year.equals(year)){
                    to_month = "12";
                }else{
                    to_month = box.get("to_month1");
                }
                int year_be    = Integer.parseInt(from_year) + 1;
                int year_be_to = Integer.parseInt(to_year) + 1;

                String from_yymm = from_year + from_month;
                String to_yymm   = to_year + to_month;

                if ( user_m != null ) {

                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());
                    Logger.debug.println(this, "선택한 시작년도 : "+ from_year + "선택한 시작월:"+from_month);
                    Logger.debug.println(this, "선택한 끝년도 : "+ to_year + "선택한 끝월:"+to_month);
                    Logger.debug.println(this, "선택한 시작년도1 : "+ from_yymm + "선택한 끝월1:"+to_yymm);
                    // 연말 정산 2003.01.13
                    D06YpayDetailData_to_year data1 = new D06YpayDetailData_to_year();

                    // 연말 정산 2003.01.13
                    D06YpayDetail2_to_yearRFC  rfc_tax2           = new D06YpayDetail2_to_yearRFC();

                    /*------ 7월 23일 과세반영액 추가 --------*/
                    int w_yymm = Integer.parseInt(from_yymm);
                    int x_yymm = Integer.parseInt(to_yymm);

                    for(int i = w_yymm; i < x_yymm+1 ; i++){

                        String yymmdd_tax = Integer.toString(i) + "20";

                        //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH /////////////////////////////////////////
                        MappingPernrRFC  mapfunc    = null ;
                        MappingPernrData mapData    = new MappingPernrData();
                        Vector           mapData_vt = new Vector() ;
                        String           mapPernr = "";

                        mapfunc    = new MappingPernrRFC() ;
                        mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                        String mapDate = "";
                        int    cnt     = 0;

                        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                            cnt = mapData_vt.size();
                            for ( int a=0; a < mapData_vt.size(); a++) {
                                mapData = (MappingPernrData)mapData_vt.get(a);
                                mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                                mapDate = mapDate.substring(0,6);

                                if ( i >= Integer.parseInt(mapDate) ) {
                                    cnt--;
                                }
                            }

                            if ( cnt == mapData_vt.size() ) {
                                mapPernr = user_m.empNo;
                            } else {
                                mapData = (MappingPernrData)mapData_vt.get(cnt);
                                mapPernr = mapData.PERNR;
                            }
                        } else {
                            mapPernr = user_m.empNo;
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////////
                        d06YpayDetailData2_vt = null; // 20161018_연급여오류 반영(KSC)
                        d06YpayDetailData2_vt = rfc_tax2.getYpayDetail2(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user_m.webUserId);
                        d06YpayDetailData5_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 과세반영으로 인한 추가.
                        d06YpayDetailData6_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 과세반영으로 인한 추가.
                        //---------------------------------------------------------------------------------------------------------------//
                        //   11월 13일 생산직비과세 및 노조비를 위한 로직추가 CYH.
                        d06YpayDetailData4_vt = rfc_tax2.getYpayDetail3(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user_m.webUserId);
                        // 연말 정산 2003.01.13
                        d06YpayDetailData4 = (D06YpayDetailData4_to_year)rfc_tax2.getPerson(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user_m.webUserId);
                        Logger.debug.println(this, "d06YpayDetailData4_vt. : "+ d06YpayDetailData4_vt.toString());
                        Logger.debug.println(this, "d06YpayDetailData4 : "+ d06YpayDetailData4.toString());
                        //----------------------------------------------------------------------------------------------------------------//
                        Logger.debug.println(this, "d06YpayDetailData2_vt. : "+ d06YpayDetailData2_vt);
                        // 연말 정산 2003.01.13
                        D06YpayDetailData2_to_year data9  = new D06YpayDetailData2_to_year();
                        D06YpayDetailData3_to_year data10 = new D06YpayDetailData3_to_year(); //11월 13일 추가사항 생산직비과세 및 노조비 추가 cyh
                        D06YpayDetailData2_to_year data11 = new D06YpayDetailData2_to_year(); // 2003.01.02 과세반영으로 인한 추가.
                        D06YpayDetailData2_to_year data12 = new D06YpayDetailData2_to_year(); // 2003.01.02 과세반영으로 인한 추가.
                        double kase = 0;
                        if(d06YpayDetailData2_vt.size() == 0) {
                            data9.BET02 = d06YpayDetailData4.BET19;
                            data9.YYMMDD = Integer.toString(i);
                            //----  11월 13일 추가사항 생산직비과세 및 노조비 추가 cyh.
                            for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                                // 연말 정산 2003.01.13
                                data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                                Logger.debug.println(this, "===data10-3 : "+ data10.toString());

                                if(data10.LGTX1.equals("LG화학노동조합") || data10.LGTX1.equals("여수나주노동조합") || data10.LGTX1.equals("노조비")) {

                                    data9.LGTX4  = "생산직비과세";
                                    data9.BET04 = data10.BET02;
                                }
                               // else {  data9.BET03 = "0";   }  //@v1.0 오류로 인해 추가

                            }
                            d06YpayDetailData3_vt.addElement(data9);
                            Logger.debug.println(this, "data9_1-3 : "+ data9.toString());
                            //----------------------------------------------------------------------------------------------------------------//
                        }else{
                            for( int j = 0 ; j < d06YpayDetailData2_vt.size() ; j++ ){
                                // 연말 정산 2003.01.13
                                data9 = (D06YpayDetailData2_to_year)d06YpayDetailData2_vt.get(j);
                                data9.YYMMDD = Integer.toString(i);
                                data9.BET02 = d06YpayDetailData4.BET19;  // 11월 13일 추가 생산직비과세.
                                for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                                    // 연말 정산 2003.01.13
                                    data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                                    if(data10.LGTX1.equals("LG화학노동조합") || data10.LGTX1.equals("여수나주노동조합") || data10.LGTX1.equals("노조비")) {
                                    	data9.LGTX4  = "생산직비과세"; //@v1.2 lsa추가
                                        data9.BET04 = data10.BET02;
                                    }
                                   // else {  data9.BET03 = "0";   }  //@v1.0 오류로 인해 추가

                                }
                                Logger.debug.println(this, "data9.YYMMDD : "+ data9.YYMMDD);
                                Logger.debug.println(this, "data9_2 : "+ data9.toString());

                                kase = Double.parseDouble(data9.BET01);

                                data9.BET01 = Double.toString(kase);
                                sum90 += Double.parseDouble(data9.BET01.equals("") ? "0" : data9.BET01);

                                d06YpayDetailData3_vt.addElement(data9);
                            }
                            // 2002.01.02 과세반영으로 인한 추가 cyh. --------------------------------------------------//
                            for( int j = 0 ; j < d06YpayDetailData5_vt.size() ; j++ ){
                                // 연말 정산 2003.01.13
                                data11 = (D06YpayDetailData2_to_year)d06YpayDetailData5_vt.get(j);
                                data11.YYMMDD = Integer.toString(i);

                                kase = Double.parseDouble(data11.BET02);
                                data11.BET01 = Double.toString(kase);
                                data11.LGTX1 = data11.LGTX2;
                                sum90 += Double.parseDouble(data11.BET01.equals("") ? "0" : data11.BET01);
                                d06YpayDetailData3_vt.addElement(data11);
                            }

                            for( int j = 0 ; j < d06YpayDetailData6_vt.size() ; j++ ){
                                data12 = (D06YpayDetailData2_to_year)d06YpayDetailData6_vt.get(j);
                                data12.YYMMDD = Integer.toString(i);

                                kase = Double.parseDouble(data12.BET03);
                                data12.BET01 = Double.toString(kase);
                                data12.LGTX1 = data12.LGTX3;
                                sum90 += Double.parseDouble(data12.BET01.equals("") ? "0" : data12.BET01);
                                d06YpayDetailData3_vt.addElement(data12);
                            }
                            //-------------------------------------------------------------------------------------------//
                        }
                    }
                    Logger.debug.println(this, "d06YpayDetailData3_vt. : "+ d06YpayDetailData3_vt);
                    Logger.debug.println(this, "D06YpayDetailData3_vt.SIZE : "+ d06YpayDetailData3_vt.size());

                    //----------------------------------------------------------------------------------------------------------------//
                    // 연말 정산 2003.01.13
                    D06YpayTaxDetail_to_yearRFC  rfc_tax              = new D06YpayTaxDetail_to_yearRFC();
                    D06YpayTaxDetailData_to_year d06YpayTaxDetailData = null;
                    D06YpayTaxDetailData_to_year data2                = new D06YpayTaxDetailData_to_year();

                    for( int i = year_be ; i < year_be_to+1 ; i++ ){

                        //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH /////////////////////////////////////////
                        MappingPernrRFC  mapfunc    = null ;
                        MappingPernrData mapData    = new MappingPernrData();
                        Vector           mapData_vt = new Vector() ;
                        String           mapPernr = "";

                        mapfunc    = new MappingPernrRFC() ;
                        mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                        String mapDate = "";
                        int    cnt     = 0;

                        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                            cnt = mapData_vt.size();
                            for ( int a=0; a < mapData_vt.size(); a++) {
                                mapData = (MappingPernrData)mapData_vt.get(a);
                                mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                                mapDate = mapDate.substring(0,4);

                                if ( i >= Integer.parseInt(mapDate) ) {
                                    cnt--;
                                }
                            }

                            if ( cnt == mapData_vt.size() ) {
                                mapPernr = user_m.empNo;
                            } else {
                                mapData = (MappingPernrData)mapData_vt.get(cnt);
                                mapPernr = mapData.PERNR;
                            }
                        } else {
                            mapPernr = user_m.empNo;
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////////

                        String year_af = Integer.toString(i);
                        Logger.debug.println(this, "i의 값 : "+ i);
                        // 연말 정산 2003.01.13
                        d06YpayTaxDetailData = (D06YpayTaxDetailData_to_year)rfc_tax.getTaxDetail(mapPernr, year_af, user.area);
                        D06YpayTaxDetailData_vt.addElement(d06YpayTaxDetailData);
                    }
                    Logger.debug.println(this, "D06YpayTaxDetailData_vt : "+ D06YpayTaxDetailData_vt.toString());
                    Logger.debug.println(this, "D06YpayTaxDetailData_vt.size() : "+ D06YpayTaxDetailData_vt.size());
                    for( int i = 0 ; i < D06YpayTaxDetailData_vt.size() ; i++ ){
                        // 연말 정산 2003.01.13
                        data2 = (D06YpayTaxDetailData_to_year)D06YpayTaxDetailData_vt.get(i);
                        Logger.debug.println(this, "data2 : "+ data2.toString());

                        sum10 += Double.parseDouble(data2.YAI == null ? "0" : data2.YAI);
                        sum11 += Double.parseDouble(data2.YAR == null ? "0" : data2.YAR);
                        sum12 += Double.parseDouble(data2.YAS == null ? "0" : data2.YAS);
                        sum21 += Double.parseDouble(data2.TAX == null ? "0" : data2.TAX);  // 5월 22일 세액조정액 추가
                        sum30 += Double.parseDouble(data2.YFE == null ? "0" : data2.YFE);  // 5월 22일 세액조정액 추가
                    }
                    Logger.debug.println(this, "sum10 : "+ sum10+"sum11 :"+sum11+"sum12 :"+sum12);

                    //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH ////////////////////////////////////////
                    MappingPernrRFC  mapfunc    = null ;
                    MappingPernrData mapData    = new MappingPernrData();
                    Vector           mapData_vt = new Vector() ;
                    String           mapPernr = "";
                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                    Vector           mapD06Data_vt = null;
                    D06YpayDetailData_to_year mdata = new D06YpayDetailData_to_year();
                    D06YpayDetail_to_yearRFC mrfc = null;
                    D06YpayDetailData_vt = new Vector();

                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);

                        mrfc = new D06YpayDetail_to_yearRFC();
                        mapD06Data_vt = new Vector();
                        mapD06Data_vt = mrfc.getYpayDetail(mapData.PERNR, from_yymm, to_yymm,user_m.webUserId);

                        for( int j = 0 ; j < mapD06Data_vt.size() ; j++ ) {
                            mdata = (D06YpayDetailData_to_year)mapD06Data_vt.get(j);
                            D06YpayDetailData_vt.addElement(mdata);
                        }

                    }
                    ////////////////////////////////////////////////////////////////////////////////////////////

                    // D06YpayDetailRFC 개인의 연급여 내역을 조회
                    // 연말 정산 2003.01.13
                    //                rfc = new D06YpayDetail_to_yearRFC();
                    //                D06YpayDetailData_vt = rfc.getYpayDetail(user_m.empNo, from_yymm, to_yymm);

                    for( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ){
                        // 연말 정산 2003.01.13
                        data1 = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);

                        sum1  += Double.parseDouble(data1.BET01);
                        sum2  += Double.parseDouble(data1.BET02);
                        sum3  += Double.parseDouble(data1.BET03);
                        sum4  += Double.parseDouble(data1.BET04);
                        sum5  += Double.parseDouble(data1.BET05);
                        sum6  += Double.parseDouble(data1.BET06);
                        sum7  += Double.parseDouble(data1.BET07);
                        sum8  += Double.parseDouble(data1.BET08);
                        sum9  += Double.parseDouble(data1.BET09);
                        sum13 += Double.parseDouble(data1.BET10);
                        sum14 += Double.parseDouble(data1.BET11);   // 공제계 5월 5일 추가
                        sum15 += Double.parseDouble(data1.BET12);   // 차감지급액 5월 5일 추가
                        sumBet13 += Double.parseDouble(data1.BET13);  //노조비 합계[CSR ID:2995203]
                    }
                    Logger.debug.println(this, "sum1 : "+ sum1 + "sum9:"+sum9);

                } // if ( user_m != null ) end

                if ( D06YpayDetailData_vt.size() == 0 ) {
                    Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                } else {
                    Logger.debug.println(this, "D06YpayDetailData_vt : "+ D06YpayDetailData_vt.toString());

                    req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
                    req.setAttribute("D06YpayTaxDetailData_vt", D06YpayTaxDetailData_vt);
                    req.setAttribute("from_year", from_year);
                    req.setAttribute("from_month", from_month);
                    req.setAttribute("to_year", to_year);
                    req.setAttribute("to_month", to_month);
                    req.setAttribute("total1", Integer.toString(sum1));
                    req.setAttribute("total2", Double.toString(sum2));
                    req.setAttribute("total3", Integer.toString(sum3));
                    req.setAttribute("total4", Double.toString(sum4));
                    req.setAttribute("total5", Integer.toString(sum5));
                    req.setAttribute("total6", Integer.toString(sum6));
                    req.setAttribute("total7", Integer.toString(sum7));
                    req.setAttribute("total8", Integer.toString(sum8));
                    req.setAttribute("total9", Integer.toString(sum9));
                    req.setAttribute("total10", Integer.toString(sum10));
                    req.setAttribute("total11", Integer.toString(sum11));
                    req.setAttribute("total12", Integer.toString(sum12));
                    req.setAttribute("total13", Integer.toString(sum13));
                    req.setAttribute("total14", Integer.toString(sum14));  // 공제계 5월 05일 추가
                    req.setAttribute("total15", Integer.toString(sum15));  // 차감지급액 5월 05일 추가
                    req.setAttribute("total21", Integer.toString(sum21));  // 세액조정액 5월 22일 추가
                    req.setAttribute("total30", Integer.toString(sum30));  // 고용보험료 환급액 2003.01.15 추가
                    req.setAttribute("total90", Integer.toString(sum90));  // 과세반영 총액  7월 23일 추가
                    req.setAttribute("D06YpayDetailData3_vt", d06YpayDetailData3_vt);  // 월별 과세반영액 7월 23일  추가
                    req.setAttribute("totalBet13", Integer.toString(sumBet13));  // 노조비 합계[CSR ID:2995203]

                    dest = WebUtil.JspURL+"D/D06Ypay/D06YpayPrint_to_year_m.jsp";
                }
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
    }
}
