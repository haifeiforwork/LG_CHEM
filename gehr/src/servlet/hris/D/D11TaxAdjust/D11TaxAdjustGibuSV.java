package servlet.hris.D.D11TaxAdjust;

import java.util.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.*;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;
/**
 * D11TaxAdjustGibuSV.java
 * 연말정산 - 특별공제 기부금를 신청/수정/조회할 수 있도록 하는 Class
 *
 * @author lsa
 * @version 1.0, 2005/11/17    
 * @version 1.0, 2013/12/10 CSR ID:C20140106_63914  
 * 2018/01/05 rdcamel [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건
 */
public class D11TaxAdjustGibuSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
        	//ApLog
        	String ctrl = "";
        	String cnt = "0";
        	String[] val = null;
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            String print_seq 		= (String) session.getAttribute("PNT_SEQ"); //@2014 연말정산 소득공제신고서 seq 추가
            Box         box     = WebUtil.getBox(req);

            D11TaxAdjustGibuRFC   rfc   = new D11TaxAdjustGibuRFC();
            D11TaxAdjustYearCheckRFC rfc_o = new D11TaxAdjustYearCheckRFC();
            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();
            
            D11TaxAdjustGibuCarriedRFC rfc_carried = new D11TaxAdjustGibuCarriedRFC();//[CSR ID:3569665]
           

            Vector gibu_vt    = new Vector();
            Vector gibuCarried_vt = new Vector();
            String dest       = "";
            String jobid      = "";
            String targetYear = box.get("targetYear"); 
            String o_flag     = "";
            Vector gibuData_vt = new Vector();

            String GUBUN="";
            //대리 신청 추가
            String PERNR = box.get("PERNR"); 
            
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            Logger.debug.println(this,"PERNR:"+PERNR+"phonenumdata:"+  phonenumdata.toString());
            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            
            gibuCarried_vt = rfc_carried.getGibuCarried(PERNR, targetYear);//[CSR ID:3569665]

            if(jobid.equals("first")){

                gibuData_vt = rfc.getGibu( PERNR, targetYear );

                for( int i = 0 ; i < gibuData_vt.size() ; i++ ) {
                    D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibuData_vt.get(i);

                    data.DONA_AMNT    = Double.toString(Double.parseDouble(data.DONA_AMNT)*100 );
                    data.DONA_DEDPR    = Double.toString(Double.parseDouble(data.DONA_DEDPR)*100 );  // @2011 전년까지 공제된 금액

                    gibu_vt.addElement(data);
                }

//              2002.12.04. 연말정산 확정여부 조회
                o_flag = rfc_o.getO_FLAG( PERNR, targetYear );

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "gibu_vt"   , gibu_vt    );
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "gibuCarried_vt"  , gibuCarried_vt  );//[CSR ID:3569665]
                
                if( gibu_vt != null && gibu_vt.size() > 0 ) {    // 조회
            	
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuDetail.jsp";
                } else {                                         // 입력
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuBuild.jsp";
                }
                //ApLog
                ctrl = "12";
            } else if(jobid.equals("build")){

                int gibu_count = box.getInt("gibu_count"); 

                for( int i = 0 ; i < gibu_count ; i++ ) {
                    D11TaxAdjustGibuData data = new D11TaxAdjustGibuData();
                    String idx = Integer.toString(i);

                    data.DONA_CODE = box.get("DONA_CODE"+idx)   ;   // 기부금유형

                    if ( data.DONA_CODE.equals("") || data.DONA_CODE.equals(" ") ) {
                        continue;
                    }

                    data.SUBTY  = box.get("SUBTY"+idx) ;          // 가족 관계 CSR ID:1361257
                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // 성명CSR ID:1361257
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // 주민등록번호CSR ID:1361257
                    //data.GUBUN      = box.get("GUBUN"+idx);       // 구분
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // 회사지원분 1,  eHR신청 2, 국세청PDF 9
                    
                    GUBUN = box.get("GUBUN"+idx);
                    // C20140106_63914 회사지원분 1,  eHR신청 2, 국세청PDF 9
                    if ( GUBUN.equals("X")|| GUBUN.equals("9")){
                        data.GUBUN = 	"9";   
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| GUBUN.equals("1")){
                        	data.GUBUN = 	"1";     
                        }else{
                        	data.GUBUN = 	"2";   
                        }
                    }
                    
                    
                    data.DONA_YYMM  = box.get("DONA_YYMM"+idx);   // 기부연월
                    data.DONA_DESC  = box.get("DONA_DESC"+idx);   // 기부금내용
                    data.DONA_NUMB  = box.get("DONA_NUMB"+idx);   // 사업자등록번호
                    data.DONA_COMP  = box.get("DONA_COMP"+idx);   // 상호
                    data.CHNTS      = box.get("CHNTS"+idx)    ;   // @v1.2국세청증빙여부
                    data.DONA_SEQN  = box.get("DONA_SEQN"+idx);   // 기부금 일련번호
                    data.DONA_AMNT  = box.get("DONA_AMNT"+idx);   // 금액
                    data.DONA_AMNT  = Double.toString(Double.parseDouble(data.DONA_AMNT)/100 );
                    data.DONA_DEDPR  = box.get("DONA_DEDPR"+idx);   //@2011 전년까지 공제된 금액
                    data.DONA_DEDPR = Double.toString(Double.parseDouble(data.DONA_DEDPR)/100 );  // @2011 전년까지 공제된 금액
                    data.DONA_CRVYR  = box.get("DONA_CRVYR"+idx);   //@2011  이월공제 연도
                    data.DONA_CRVIN  = box.get("DONA_CRVIN"+idx);   //@2011  이월공제체크 
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // 연말정산삭제여부
                    gibu_vt.addElement(data);
                    //ApLog
                    if(i==0){
                    	val = new String[16];
	                    val[0] = data.DONA_CODE;
	                    val[1] = data.SUBTY;
	                    val[2] = data.F_ENAME;
	                    val[3] = data.F_REGNO;
	                    val[4] = data.GUBUN;
	                    val[5] = data.DONA_YYMM;
	                    val[6] = data.DONA_DESC;
	                    val[7] = data.DONA_NUMB;
	                    val[8] = data.DONA_COMP;
	                    val[9] = data.CHNTS;
	                    val[10] = data.DONA_SEQN;
	                    val[11] = data.DONA_AMNT;
	                    val[12] = data.DONA_DEDPR;
	                    val[13] = data.DONA_CRVYR;
	                    val[14] = data.DONA_CRVIN;
	                    val[15] = data.OMIT_FLAG;
                    }
                }

                Logger.debug.println(this, " gibu_vt:"+  gibu_vt.toString());
                rfc.build( PERNR, targetYear, gibu_vt );
                String FSTID     = box.get("FSTID")      ;    //세대주체크여부
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg007";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustGibuSV?targetYear="+targetYear+"&PERNR="+PERNR+"';";
                
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
                //ApLog                
                ctrl = "11";
                cnt = String.valueOf(gibu_vt.size());
            } else if(jobid.equals("change_first")){

                gibuData_vt = rfc.getGibu(PERNR, targetYear );

                for( int i = 0 ; i < gibuData_vt.size() ; i++ ) {
                    D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibuData_vt.get(i);

                    data.DONA_AMNT    = Double.toString(Double.parseDouble(data.DONA_AMNT)*100 );

                    data.DONA_DEDPR    = Double.toString(Double.parseDouble(data.DONA_DEDPR)*100 );
                    gibu_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "gibu_vt"   , gibu_vt    );
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "gibuCarried_vt"  , gibuCarried_vt  );//[CSR ID:3569665]

                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuChange.jsp";
                //ApLog                
                ctrl = "12";
            } else if(jobid.equals("change")){
                int gibu_count = box.getInt("gibu_count");

                for( int i = 0 ; i < gibu_count ; i++ ) {
                    D11TaxAdjustGibuData data = new D11TaxAdjustGibuData();
                    String idx = Integer.toString(i);

                    data.DONA_CODE = box.get("DONA_CODE"+idx)   ;   // 기부금유형

                    if ( data.DONA_CODE.equals("") || data.DONA_CODE.equals(" ") ) {
                        continue;
                    }
                    data.SUBTY  = box.get("SUBTY"+idx) ;          // 가족 관계 CSR ID:1361257
                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // 성명CSR ID:1361257
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // 주민등록번호CSR ID:1361257

                    Logger.debug.println(this, " GUBUN = " +idx + "GUBUN:"+box.get("GUBUN"+idx)) ;
                    
                    //data.GUBUN         = box.get("GUBUN"+idx)        ;   // 구분
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // 회사지원분 1,  eHR신청 2, 국세청PDF 9
                    
                   // data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":	box.get("GUBUN"+idx).equals("1")?"1":"2";   // 회사지원분 1,  eHR신청 2, 국세청PDF 9

                    GUBUN = box.get("GUBUN"+idx);
                    //회사지원분 1,  eHR신청 2, 국세청PDF 9
                    if ( GUBUN.equals("X")|| GUBUN.equals("9")){
                        data.GUBUN = 	"9";   
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| GUBUN.equals("1")){
                        	data.GUBUN = 	"1";     
                        }else{
                        	data.GUBUN = 	"2";   
                        }
                    }

                    Logger.debug.println(this, "[[[ ===GUBUN:"+GUBUN+"===== idx= " +idx + "data.GUBUN:"+data.GUBUN) ;

                    Logger.debug.println(this, "[[[ idx= " +idx + "box.GUBUN:"+box.get("GUBUN"+idx)) ;
                    Logger.debug.println(this, "[[[ idx= " +idx + "box.GUBUN_SAP:"+box.get("GUBUN_SAP"+idx)) ;
                    data.DONA_YYMM     = box.get("DONA_YYMM"+idx)    ;   // 기부연월
                    data.DONA_DESC     = box.get("DONA_DESC"+idx)    ;   // 기부금내용
                    data.DONA_NUMB     = box.get("DONA_NUMB"+idx)    ;   // 사업자등록번호
                    data.DONA_COMP     = box.get("DONA_COMP"+idx)    ;   // 상호
                    data.CHNTS         = box.get("CHNTS"+idx)        ;   // @v1.2국세청증빙여부
                    data.DONA_SEQN     = box.get("DONA_SEQN"+idx);   // 기부금 일련번호
                    data.DONA_AMNT     = box.get("DONA_AMNT"+idx)    ;   // 금액
                    data.DONA_AMNT     = Double.toString(Double.parseDouble(data.DONA_AMNT)/100 );
                    data.DONA_DEDPR     = box.get("DONA_DEDPR"+idx)    ;   // @2011 전년까지 공제된 금액 
                    data.DONA_DEDPR     = Double.toString(Double.parseDouble(data.DONA_DEDPR)/100 );// @2011 전년까지 공제된 금액 
                    data.DONA_CRVYR  = box.get("DONA_CRVYR"+idx);   //@2011  이월공제 연도
                    data.DONA_CRVIN  = box.get("DONA_CRVIN"+idx);   //@2011  이월공제체크 
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // 연말정산삭제여부
                    gibu_vt.addElement(data);
                    //ApLog
                    if(i==0){
                    	val = new String[16];
	                    val[0] = data.DONA_CODE;
	                    val[1] = data.SUBTY;
	                    val[2] = data.F_ENAME;
	                    val[3] = data.F_REGNO;
	                    val[4] = data.GUBUN;
	                    val[5] = data.DONA_YYMM;
	                    val[6] = data.DONA_DESC;
	                    val[7] = data.DONA_NUMB;
	                    val[8] = data.DONA_COMP;
	                    val[9] = data.CHNTS;
	                    val[10] = data.DONA_SEQN;
	                    val[11] = data.DONA_AMNT;
	                    val[12] = data.DONA_DEDPR;
	                    val[13] = data.DONA_CRVYR;
	                    val[14] = data.DONA_CRVIN;
	                    val[15] = data.OMIT_FLAG;
                    }
                }
                
                Logger.debug.println(this, "CHANGE gibu_vt:"+  gibu_vt.toString());
                
                rfc.build( PERNR, targetYear, gibu_vt );
                String FSTID     = box.get("FSTID")      ;    //세대주체크여부
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg002";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustGibuSV?targetYear="+targetYear+"&PERNR="+PERNR+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
                //ApLog                
                ctrl = "11";
                cnt = String.valueOf(gibu_vt.size());
            } else if(jobid.equals("AddorDel")){

                int    gibu_count = box.getInt("gibu_count");
                String curr_job   = box.getString("curr_job");
                String rowCount   = box.getString("gibu_count");

//              2002.12.04. 연말정산 확정여부 조회
                o_flag = rfc_o.getO_FLAG( PERNR, targetYear );

                for( int i = 0 ; i < gibu_count ; i++ ) {
                    D11TaxAdjustGibuData data = new D11TaxAdjustGibuData();
                    String idx = Integer.toString(i);
          
                    data.DONA_CODE = box.get("DONA_CODE"+idx)   ;   // 기부금유형

                    if ( data.DONA_CODE.equals("") || data.DONA_CODE.equals(" ") ) {
                        continue;
                    }

                    if( box.get("use_flag"+idx).equals("N") ) continue; //@v1.2    
                    
                    
                    data.SUBTY  = box.get("SUBTY"+idx) ;          // 가족 관계 CSR ID:1361257
                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // 성명CSR ID:1361257
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // 주민등록번호CSR ID:1361257             
                    //data.GUBUN         = box.get("GUBUN"+idx)     ;   // 구분
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // 회사지원분 1,  eHR신청 2, 국세청PDF 9
                    GUBUN = box.get("GUBUN"+idx);
                    //회사지원분 1,  eHR신청 2, 국세청PDF 9
                    if ( GUBUN.equals("X")|| GUBUN.equals("9")){
                        data.GUBUN = 	"9";   
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| GUBUN.equals("1")){
                        	data.GUBUN = 	"1";     
                        }else{
                        	data.GUBUN = 	"2";   
                        }
                    }
                    data.DONA_YYMM     = box.get("DONA_YYMM"+idx) ;   // 기부연월
                    data.DONA_DESC     = box.get("DONA_DESC"+idx) ;   // 기부금내용
                    data.DONA_NUMB     = box.get("DONA_NUMB"+idx) ;   // 사업자등록번호
                    data.DONA_COMP     = box.get("DONA_COMP"+idx) ;   // 상호
                    data.CHNTS         = box.get("CHNTS"+idx)     ;   // @v1.2국세청증빙여부
                    data.DONA_SEQN     = box.get("DONA_SEQN"+idx);    // 기부금 일련번호
                    data.DONA_AMNT     = box.get("DONA_AMNT"+idx) ;   // 금액
                    data.DONA_DEDPR     = box.get("DONA_DEDPR"+idx) ;   // @2011 전년까지 공제된 금액 
                    data.DONA_CRVYR  = box.get("DONA_CRVYR"+idx);   //@2011  이월공제 연도
                    data.DONA_CRVIN  = box.get("DONA_CRVIN"+idx);   //@2011  이월공제체크 
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // 연말정산삭제여부
                    gibu_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "gibu_vt"   , gibu_vt    );
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , rowCount );
                req.setAttribute( "gibuCarried_vt"  , gibuCarried_vt  );//[CSR ID:3569665]

                if ( curr_job.equals("build") ) {    // 입력화면
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuBuild.jsp";
                } else {                             // 입력
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuChange.jsp";
                }

            } else if(jobid.equals("first_print")) {
                String print_page_name = WebUtil.ServletURL + "hris.D.D11TaxAdjust.D11TaxAdjustGibuSV?jobid=print&targetYear="+targetYear+"&PERNR="+PERNR;
                req.setAttribute( "print_page_name", print_page_name );
                dest =  WebUtil.JspURL + "common/printFrame2.jsp";

            } else if( jobid.equals("print") ){
                gibuData_vt = rfc.getGibu( PERNR, targetYear );

                for( int i = 0 ; i < gibuData_vt.size() ; i++ ) {
                    D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibuData_vt.get(i);

                    data.DONA_AMNT = Double.toString(Double.parseDouble(data.DONA_AMNT)*100 );
                    data.DONA_DEDPR = Double.toString(Double.parseDouble(data.DONA_DEDPR)*100 ); // @2011 전년까지 공제된 금액 

                    gibu_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "gibu_vt"   , gibu_vt    );
                req.setAttribute( "PNT_SEQ", print_seq);////@2014 연말정산 소득공제신고서 seq 추가
                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuPrint.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            req.setAttribute("PersonData",phonenumdata);
            req.setAttribute("PERNR",PERNR);
            Logger.debug.println(this, " destributed = " + dest);
            //ApLog 생성
            if(jobid.equals("first")||jobid.equals("build")||jobid.equals("change_first")||jobid.equals("change")){
            	ApLoggerWriter.writeApLog("연말정산", "기부금", "D11TaxAdjustGibuSV", "기부금", ctrl, cnt, val, user, req.getRemoteAddr());
            }
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
