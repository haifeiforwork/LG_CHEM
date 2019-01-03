package servlet.hris.D.D11TaxAdjust;

import java.util.Vector;
import javax.servlet.http.*;

import org.apache.commons.lang.StringUtils;

import com.common.Global;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.A.A01SelfDetailLicenseData;
import hris.A.A17Licence.A17LicenceData;
import hris.A.rfc.A01SelfDetailLicenseRFC;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;
/**
 * D11TaxAdjustCardSV.java
 * 연말정산 - 신용카드.현금영수증.보험료를 신청/수정/조회할 수 있도록 하는 Class
 *
 * 2012 전통시장여부추가 2012/12/13
 * CSR ID:C20140106_63914 교통카드여부 추가   2013/12/05
 * @author lsa    2006/11/23
 *
 * update:          2018.01.07 cykim  [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 *
 *
 */
public class D11TaxAdjustCardSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
        	//req.setCharacterEncoding("KSC5601");
        	//ApLog
        	String ctrl = "";
        	String cnt = "0";
        	String[] val = null;
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            String print_seq 		= (String) session.getAttribute("PNT_SEQ"); //@2014 연말정산 소득공제신고서 seq 추가
            Box         box     = WebUtil.getBox(req);
            //2016연말정산 sort  수정 start
            String sortField = box.get( "sortField" ,"SUBTY");   //sortFieldName or sortFieldIndex
            String sortValue = box.get( "sortValue" ,"desc"); //sortValue ex) desc, asc
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            //2016연말정산 sort  수정 end
            D11TaxAdjustCardRFC   rfc   = new D11TaxAdjustCardRFC();
            D11TaxAdjustYearCheckRFC rfc_o = new D11TaxAdjustYearCheckRFC();
            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();

            Vector card_vt    = new Vector();
            String dest       = "";
            String jobid      = "";
            String targetYear = box.get("targetYear");
            String o_flag     = "";
            Vector cardData_vt = new Vector();
            String tab_gubun     = "";
            Vector yearCombo = new Vector();

            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            tab_gubun = box.get("tab_gubun");


            if(jobid.equals("first")){

                cardData_vt = rfc.getCard( user.empNo, targetYear,tab_gubun );

                for( int i = 0 ; i < cardData_vt.size() ; i++ ) {
                    D11TaxAdjustCardData data = (D11TaxAdjustCardData)cardData_vt.get(i);

                    data.BETRG    = Double.toString(Double.parseDouble(data.BETRG)*100 );
                    data.BETRG_M    = Double.toString(Double.parseDouble(data.BETRG_M)*100 );
                    data.BETRG_O    = Double.toString(Double.parseDouble(data.BETRG_O)*100 );
                    data.BETRG_B    = Double.toString(Double.parseDouble(data.BETRG_B)*100 );

                    card_vt.addElement(data);
                }

                //2002.12.04. 연말정산 확정여부 조회
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );




                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "card_vt"   , replaceSort(card_vt,sortField,sortValue) ); //2016연말정산 sort  수정
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "tab_gubun" , tab_gubun  );
                req.setAttribute( "yearCombo", yearCombo);

                if( card_vt != null && card_vt.size() > 0 ) {    // 조회
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardDetail.jsp";
                } else {                                         // 입력
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardBuild.jsp";
                }

                //ApLog
                ctrl = "12";

            } else if(jobid.equals("build")){

                int card_count = box.getInt("card_count");

                for( int i = 0 ; i < card_count ; i++ ) {
                    D11TaxAdjustCardData data = new D11TaxAdjustCardData();
                    String idx = Integer.toString(i);

                    data.SUBTY = box.get("SUBTY"+idx)   ;   // 가족 관계

                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {
                        continue;
                    }

                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // 성명
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // 주민등록번호
                    data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // 회사지원분 1,  eHR신청 2, 국세청PDF 9
                    data.E_GUBUN  = box.get("E_GUBUN"+idx)  ;   // 구분
                    data.GU_NAME  = box.get("GU_NAME"+idx)  ;   // 구분명
                    data.BETRG    = box.get("BETRG"+idx)   ;   // 금액
                    data.BETRG_M  = box.get("BETRG_M"+idx)   ;   // 금액
                    data.BETRG_O  = box.get("BETRG_O"+idx)   ;   // 금액
                    data.BETRG_B  = box.get("BETRG_B"+idx)   ;   // 금액
                    data.BETRG    = Double.toString(Double.parseDouble(data.BETRG)/100 );
                    data.BETRG_M    = Double.toString(Double.parseDouble(data.BETRG_M)/100 );
                    data.BETRG_O    = Double.toString(Double.parseDouble(data.BETRG_O)/100 );
                    data.BETRG_B    = Double.toString(Double.parseDouble(data.BETRG_B)/100 );
                    data.CHNTS    = box.get("CHNTS"+idx)   ;   // 국세청자료
                    data.TRDMK    = box.get("TRDMK"+idx)   ;   // 2012 전통시장여부추가

                    data.CCTRA    = box.get("CCTRA"+idx)   ;    // CSR ID:C20140106_63914 교통카드여부 추가
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // 연말정산삭제여부
                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 start*/
                    /*
                    data.EXPRD = box.get("EXPRD_"+idx);//@2014 연말정산 사용기한 코드
                    data.EXSTX = box.get("EXSTX_"+idx);//@2014 연말정산 사용기한 텍스트
                    */
                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 end*/
                    card_vt.addElement(data);

                    //ApLog
                    if(i==0){
                    	/*[CSR ID:3569665] @2017 연말정산 사용기간 삭제*/
                    	val = new String[13];
	                    val[0] = data.SUBTY;
	                    val[1] = data.F_ENAME;
	                    val[2] = data.F_REGNO;
	                    val[3] = data.GUBUN;
	                    val[4] = data.E_GUBUN;
	                    val[5] = data.GU_NAME;
	                    val[6] = data.BETRG;
	                    val[7] = data.BETRG_M;
	                    val[8] = data.BETRG_O;
	                    val[9] = data.BETRG_B;
	                    val[10] = data.CHNTS;
	                    val[11] = data.TRDMK;
	                    val[12] = data.OMIT_FLAG;
	                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 start*/
	                    /*
	                    val[13] = data.EXPRD;
	                    val[14] = data.EXSTX;
	                    */
	                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 end*/
                    }
                }

                rfc.build( user.empNo, targetYear, card_vt ,tab_gubun);


                String FSTID     = box.get("FSTID")      ;    //세대주체크여부
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg007";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustCardSV?targetYear="+targetYear+"&tab_gubun="+tab_gubun+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";

                //ApLog
                ctrl = "11";
                cnt = String.valueOf(card_vt.size());

            } else if(jobid.equals("change_first")){

                cardData_vt = rfc.getCard( user.empNo, targetYear ,tab_gubun);

                for( int i = 0 ; i < cardData_vt.size() ; i++ ) {
                    D11TaxAdjustCardData data = (D11TaxAdjustCardData)cardData_vt.get(i);

                    data.BETRG    = Double.toString(Double.parseDouble(data.BETRG)*100 );
                    data.BETRG_M    = Double.toString(Double.parseDouble(data.BETRG_M)*100 );
                    data.BETRG_O    = Double.toString(Double.parseDouble(data.BETRG_O)*100 );
                    data.BETRG_B    = Double.toString(Double.parseDouble(data.BETRG_B)*100 );

                    card_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "card_vt"   , replaceSort(card_vt,sortField,sortValue)    );//2016연말정산 sort  수정 start
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "tab_gubun" , tab_gubun  );

                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardChange.jsp";

                //ApLog
                ctrl = "12";

            } else if(jobid.equals("change")){
                int card_count = box.getInt("card_count");

                for( int i = 0 ; i < card_count ; i++ ) {
                    D11TaxAdjustCardData data = new D11TaxAdjustCardData();
                    String idx = Integer.toString(i);

                    data.SUBTY = box.get("SUBTY"+idx)   ;   // 가족 관계

                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {
                        continue;
                    }
                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // 성명
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // 주민등록번호
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // 회사지원분 1,  eHR신청 2, 국세청PDF 9

                    //회사지원분 1,  eHR신청 2, 국세청PDF 9
                    if ( box.get("GUBUN"+idx).equals("X")|| box.get("GUBUN"+idx).equals("9")){
                        data.GUBUN = 	"9";
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| box.get("GUBUN"+idx).equals("1")){
                        	data.GUBUN = 	"1";
                        }else{
                        	data.GUBUN = 	"2";
                        }
                    }

                    data.E_GUBUN  = box.get("E_GUBUN"+idx)  ;   // 구분
                    data.GU_NAME  = box.get("GU_NAME"+idx)  ;   // 구분명
                    data.BETRG    = box.get("BETRG"+idx)   ;   // 금액
                    data.BETRG_M    = box.get("BETRG_M"+idx)   ;   // 금액
                    data.BETRG_O    = box.get("BETRG_O"+idx)   ;   // 금액
                    data.BETRG_B    = box.get("BETRG_B"+idx)   ;   // 금액
                    data.BETRG    = Double.toString(Double.parseDouble(data.BETRG)/100 );
                    data.BETRG_M    = Double.toString(Double.parseDouble(data.BETRG_M)/100 );
                    data.BETRG_O    = Double.toString(Double.parseDouble(data.BETRG_O)/100 );
                    data.BETRG_B    = Double.toString(Double.parseDouble(data.BETRG_B)/100 );
                    data.CHNTS    = box.get("CHNTS"+idx)   ;   // 국세청자료
                    data.TRDMK    = box.get("TRDMK"+idx)   ;   // 2012 전통시장여부추가
                    data.CCTRA    = box.get("CCTRA"+idx)   ;    // CSR ID:C20140106_63914 교통카드여부 추가
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // 연말정산삭제여부
                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 start*/
                    /*
                    data.EXPRD = box.get("EXPRD_"+idx);//@2014 연말정산 사용기한 코드
                    data.EXSTX = box.get("EXSTX_"+idx);//@2014 연말정산 사용기한 텍스트
                    */
                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 end*/
                    card_vt.addElement(data);

                    //ApLog
                    if(i==0){
                    	/*[CSR ID:3569665] @2017 연말정산 사용기간 삭제*/
                    	val = new String[13];
	                    val[0] = data.SUBTY;
	                    val[1] = data.F_ENAME;
	                    val[2] = data.F_REGNO;
	                    val[3] = data.GUBUN;
	                    val[4] = data.E_GUBUN;
	                    val[5] = data.GU_NAME;
	                    val[6] = data.BETRG;
	                    val[7] = data.BETRG_M;
	                    val[8] = data.BETRG_O;
	                    val[9] = data.BETRG_B;
	                    val[10] = data.CHNTS;
	                    val[11] = data.TRDMK;
	                    val[12] = data.OMIT_FLAG;
	                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 start*/
	                    /*
	                    val[13] = data.EXPRD;
	                    val[14] = data.EXSTX;
	                    */
	                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 end*/
                    }

                }//for end

                rfc.build( user.empNo, targetYear, card_vt,tab_gubun );
                String FSTID     = box.get("FSTID")      ;    //세대주체크여부
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg002";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustCardSV?targetYear="+targetYear+"&tab_gubun="+tab_gubun+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";

                //ApLog
                ctrl = "11";
                cnt = String.valueOf(card_vt.size());
            } else if(jobid.equals("AddorDel")){

                int    card_count = box.getInt("card_count");
                String curr_job   = box.getString("curr_job");
                String rowCount   = box.getString("rowCount");      //@v1.2

                //2002.12.04. 연말정산 확정여부 조회
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );
                for( int i = 0 ; i < card_count ; i++ ) {
                    D11TaxAdjustCardData data = new D11TaxAdjustCardData();
                    String idx = Integer.toString(i);

                    data.SUBTY = box.get("SUBTY"+idx)   ;   // 가족 관계
                    Logger.debug.println(this, "i:" + i + " data.SUBTY = " + data.SUBTY+" use_flag " +box.get("use_flag"+idx) );
                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {
                        continue;
                    }
                    if( box.get("use_flag"+idx).equals("N") ) continue; //@v1.2

                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // 성명
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // 주민등록번호
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // 회사지원분 1,  eHR신청 2, 국세청PDF 9
                    //회사지원분 1,  eHR신청 2, 국세청PDF 9
                    if ( box.get("GUBUN"+idx).equals("X")|| box.get("GUBUN"+idx).equals("9")){
                        data.GUBUN = 	"9";
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| box.get("GUBUN"+idx).equals("1")){
                        	data.GUBUN = 	"1";
                        }else{
                        	data.GUBUN = 	"2";
                        }
                    }

                    data.E_GUBUN  = box.get("E_GUBUN"+idx) ;   // 구분
                    data.GU_NAME  = box.get("GU_NAME"+idx) ;   // 구분명
                    data.BETRG    = box.get("BETRG"+idx)   ;   // 금액
                    data.BETRG_M  = box.get("BETRG_M"+idx) ;   // 금액
                    data.BETRG_O  = box.get("BETRG_O"+idx) ;   // 금액
                    data.BETRG_B  = box.get("BETRG_B"+idx) ;   // 금액
                    data.CHNTS    = box.get("CHNTS"+idx)   ;   // 국세청자료
                    data.TRDMK    = box.get("TRDMK"+idx)   ;   // 2012 전통시장여부추가
                    data.CCTRA    = box.get("CCTRA"+idx)   ;    // CSR ID:C20140106_63914 교통카드여부 추가
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // 연말정산삭제여부
                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 start*/
                    /*
                    data.EXPRD = box.get("EXPRD_"+idx);//@2014 연말정산 사용기한 코드
                    data.EXSTX = box.get("EXSTX_"+idx);//@2014 연말정산 사용기한 텍스트
                    */
                    /*[CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 end*/
                    card_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "card_vt"   , replaceSort(card_vt,sortField,sortValue));//2016연말정산 sort  수정 start
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , rowCount   );
                req.setAttribute( "tab_gubun" , tab_gubun  );

                if ( curr_job.equals("build") ) {    // 입력화면
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardBuild.jsp";
                } else {                             // 입력
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardChange.jsp";
                }

            } else if(jobid.equals("first_print")) {
                String print_page_name = WebUtil.ServletURL + "hris.D.D11TaxAdjust.D11TaxAdjustCardSV?jobid=print&targetYear="+"&tab_gubun="+tab_gubun;
                req.setAttribute( "print_page_name", print_page_name );
                dest =  WebUtil.JspURL + "common/printFrame2.jsp";

            } else if( jobid.equals("print") ){
                cardData_vt = rfc.getCard( user.empNo, targetYear,tab_gubun );

                for( int i = 0 ; i < cardData_vt.size() ; i++ ) {
                    D11TaxAdjustCardData data = (D11TaxAdjustCardData)cardData_vt.get(i);

                    data.BETRG = Double.toString(Double.parseDouble(data.BETRG)*100 );
                    data.BETRG_B = Double.toString(Double.parseDouble(data.BETRG_B)*100 );
                    data.BETRG_M = Double.toString(Double.parseDouble(data.BETRG_M)*100 );
                    data.BETRG_O = Double.toString(Double.parseDouble(data.BETRG_O)*100 );

                    card_vt.addElement(data);
                }
                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "card_vt"   , replaceSort(card_vt,sortField,sortValue)    );//2016연말정산 sort  수정 start
                req.setAttribute( "tab_gubun" , tab_gubun  );
                req.setAttribute( "PNT_SEQ", print_seq);////@2014 연말정산 소득공제신고서 seq 추가
                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardPrint.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            //ApLog 생성
            if(jobid.equals("first")||jobid.equals("build")||jobid.equals("change_first")||jobid.equals("change")){
            	String subMenuNm = "신용카드";
            	if(tab_gubun.equals("2")){
            		subMenuNm = "보험료";
            	}
            	ApLoggerWriter.writeApLog("연말정산", subMenuNm, "D11TaxAdjustCardSV", subMenuNm, ctrl, cnt, val, user, req.getRemoteAddr());
            }
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
  //2016연말정산 sort  수정 start
    public  Vector replaceSort(Vector card_vt,String sortField, String sortValue)    throws GeneralException {

        if( sortField.equals("BETRG")||sortField.equals("BETRG_B")) {
        	card_vt = SortUtil.sort_num( card_vt, sortField, sortValue ); // Number
        } else {
        	card_vt = SortUtil.sort( card_vt, sortField, sortValue );     // String
        }
        return card_vt;
    }
  //2016연말정산 sort  수정 end

}
