package servlet.hris.D.D11TaxAdjust;import java.sql.*;import java.util.*;import javax.servlet.*;import javax.servlet.http.*;import com.sns.jdf.*;import com.sns.jdf.db.*;import com.sns.jdf.util.*;import com.sns.jdf.servlet.*;import hris.common.*;import hris.common.util.*;import hris.common.db.*;import hris.common.rfc.*;import hris.D.D11TaxAdjust.*;import hris.D.D11TaxAdjust.rfc.*;/** * D11TaxAdjustMedicalSV.java * 연말정산 - 특별공제 의료비를 신청/수정/조회할 수 있도록 하는 Class * * @author 윤정현 * @version  1.0, 2004/11/24 * @version v1.1, 2005/11/23    연말정산관련 C2005111701000000551 * @version v1.2, 2006/11/21    1.금액 -> 의료비총액/신용카드분/현금영수증분/현금으로 나누어 입력 *                              2.자동반영분 확인 플래그 추가 *                              3.삭제 플래그 추가 */public class D11TaxAdjustMedicalSV extends EHRBaseServlet {    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {        try{        	//ApLog        	String ctrl = "";        	String cnt = "0";        	String[] val = null;            HttpSession session = req.getSession(false);            WebUserData user    = (WebUserData)session.getAttribute("user");            String print_seq 				= (String) session.getAttribute("PNT_SEQ"); //@2014 연말정산 소득공제신고서 seq 추가            Box         box     = WebUtil.getBox(req);            D11TaxAdjustMedicalRFC   rfc   = new D11TaxAdjustMedicalRFC();            D11TaxAdjustYearCheckRFC rfc_o = new D11TaxAdjustYearCheckRFC();            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();            Vector medi_vt    = new Vector();            String dest       = "";            String jobid      = "";            String targetYear = box.get("targetYear");            String o_flag     = "";            Vector mediData_vt = new Vector();            if( targetYear.equals("") ){                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;            }            jobid = box.get("jobid");            if( jobid.equals("") ){                jobid = "first";            }            if(jobid.equals("first")){                mediData_vt = rfc.getMedical( user.empNo, targetYear );                for( int i = 0 ; i < mediData_vt.size() ; i++ ) {                    D11TaxAdjustMedicalData data = (D11TaxAdjustMedicalData)mediData_vt.get(i);                    data.CA_BETRG    = Double.toString(Double.parseDouble(data.CA_BETRG)*100 );                    medi_vt.addElement(data);                }//              2002.12.04. 연말정산 확정여부 조회                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );                req.setAttribute( "targetYear", targetYear );                req.setAttribute( "medi_vt"   , medi_vt    );                req.setAttribute( "o_flag"    , o_flag     );                req.setAttribute( "rowCount"  , "8"        );                if( medi_vt != null && medi_vt.size() > 0 ) {    // 조회                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustMedicalDetail.jsp";                } else {                                         // 입력                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustMedicalBuild.jsp";                }                //ApLog                ctrl = "12";            } else if(jobid.equals("build")){                int medi_count = box.getInt("medi_count");                //double betrg = 0.0;                for( int i = 0 ; i < medi_count ; i++ ) {                    D11TaxAdjustMedicalData data = new D11TaxAdjustMedicalData();                    String idx = Integer.toString(i);                    data.SUBTY = box.get("SUBTY"+idx)   ;   // 가족 관계                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {                        continue;                    }                    //data.GUBUN    = box.get("GUBUN"+idx)   ;   // @v1.1구분                    data.GUBUN    = box.get("GUBUN"+idx).equals("X")?"1":"2";   // @v1.1구분자동반영분                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // 성명                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // 주민등록번호                    data.CONTENT  = box.get("CONTENT"+idx) ;   // 의료비내용                    data.BIZNO    = box.get("BIZNO"+idx)   ;   // 사업자등록번호                    data.BIZ_NAME = box.get("BIZ_NAME"+idx);   // 상호                    data.CA_BETRG = box.get("CA_BETRG"+idx)   ;   // @v1.2현금사용분                    data.CA_CNT = box.get("CA_CNT"+idx)   ;   // @v1.2현금사용분                    data.CA_BETRG = Double.toString(Double.parseDouble(data.CA_BETRG)/100 );// @v1.2                    data.OLDD     = box.get("OLDD"+idx)    ;   // 경로우대 대상자여부                    data.OBST     = box.get("OBST"+idx)    ;   // 장애자여부                    data.CHNTS    = box.get("CHNTS"+idx)    ;   // 국세청자료                    data.METYP    = box.get("METYP"+idx)    ;   // 의료증빙코드                    data.OMIT_FLAG    = box.get("OMIT_FLAG"+idx); //삭제 플래그                    data.GLASS_CHK    = box.get("GLASS_CHK"+idx); //안경콘택트렌즈공제                    data.DIFPG_CHK    = box.get("DIFPG_CHK"+idx); //@2015연말정산 난임시술비                    medi_vt.addElement(data);                    //ApLog                    if(i==0){                    	val = new String[15];	                    val[0] = data.SUBTY;	                    val[1] = data.GUBUN;	                    val[2] = data.F_ENAME;	                    val[3] = data.F_REGNO;	                    val[4] = data.CONTENT;	                    val[5] = data.BIZNO;	                    val[6] = data.BIZ_NAME;	                    val[7] = data.CA_BETRG;	                    val[8] = data.OLDD;	                    val[9] = data.OBST;	                    val[10] = data.CHNTS;	                    val[11] = data.METYP;	                    val[12] = data.OMIT_FLAG;	                    val[13] = data.GLASS_CHK;	                    val[14] = data.DIFPG_CHK;//@2015 연말정산                    }                }                rfc.build( user.empNo, targetYear, medi_vt );                String FSTID     = box.get("FSTID")      ;    //세대주체크여부                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);                String msg = "msg007";                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV?targetYear="+targetYear+"';";                req.setAttribute("msg", msg);                req.setAttribute("url", url);                dest = WebUtil.JspURL+"common/msg.jsp";                //ApLog                ctrl = "11";                cnt = String.valueOf(medi_vt.size());            } else if(jobid.equals("change_first")){                mediData_vt = rfc.getMedical( user.empNo, targetYear );                for( int i = 0 ; i < mediData_vt.size() ; i++ ) {                    D11TaxAdjustMedicalData data = (D11TaxAdjustMedicalData)mediData_vt.get(i);                    data.CA_BETRG    = Double.toString(Double.parseDouble(data.CA_BETRG)*100 );                    medi_vt.addElement(data);                }    			Logger.info.println(this , "change_first  medi_vt " + medi_vt.toString());                req.setAttribute( "targetYear", targetYear );                req.setAttribute( "medi_vt"   , medi_vt    );                req.setAttribute( "rowCount"  , "8"        );                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustMedicalChange.jsp";                //ApLog                ctrl = "12";            } else if(jobid.equals("change")){                int medi_count = box.getInt("medi_count");                for( int i = 0 ; i < medi_count ; i++ ) {                    D11TaxAdjustMedicalData data = new D11TaxAdjustMedicalData();                    String idx = Integer.toString(i);                    data.SUBTY = box.get("SUBTY"+idx)   ;   // 가족 관계                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {                        continue;                    }                    data.GUBUN    = box.get("GUBUN"+idx).equals("1")?"1":"2";   // @v1.1구분자동반영분                    if(box.get("PDF"+idx).equals("X")){                    	data.GUBUN = "9";                    }                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // 성명                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // 주민등록번호                    data.CONTENT  = box.get("CONTENT"+idx) ;   // 의료비내용                    data.BIZNO    = box.get("BIZNO"+idx)   ;   // 사업자등록번호                    data.BIZ_NAME = box.get("BIZ_NAME"+idx);   // 상호                    data.CA_BETRG = box.get("CA_BETRG"+idx)   ;   // @v1.2현금사용분                    data.CA_CNT = box.get("CA_CNT"+idx)   ;   // @v1.2현금사용분                    data.CA_BETRG = Double.toString(Double.parseDouble(data.CA_BETRG)/100 );// @v1.2                    data.OLDD     = box.get("OLDD"+idx)     ;   // 경로우대 대상자여부                    data.OBST     = box.get("OBST"+idx)    ;   // 장애자여부                    data.CHNTS    = box.get("CHNTS"+idx)    ;   // 국세청자료                    data.METYP    = box.get("METYP"+idx)    ;   // 의료증빙코드                    data.OMIT_FLAG    = box.get("OMIT_FLAG"+idx); //삭제 플래그                    data.GLASS_CHK    = box.get("GLASS_CHK"+idx); //안경콘택트렌즈공제                    data.DIFPG_CHK    = box.get("DIFPG_CHK"+idx); //@2015연말정산 난임시술비                    medi_vt.addElement(data);                    //ApLog                    if(i==0){                    	val = new String[15];	                    val[0] = data.SUBTY;	                    val[1] = data.GUBUN;	                    val[2] = data.F_ENAME;	                    val[3] = data.F_REGNO;	                    val[4] = data.CONTENT;	                    val[5] = data.BIZNO;	                    val[6] = data.BIZ_NAME;	                    val[7] = data.CA_BETRG;	                    val[8] = data.OLDD;	                    val[9] = data.OBST;	                    val[10] = data.CHNTS;	                    val[11] = data.METYP;	                    val[12] = data.OMIT_FLAG;	                    val[13] = data.GLASS_CHK;	                    val[14] = data.DIFPG_CHK; //@2015 연말정산                    }                }    			Logger.info.println(this , "===change   medi_vt " + medi_vt.toString());                rfc.build( user.empNo, targetYear, medi_vt );                String FSTID     = box.get("FSTID")      ;    //세대주체크여부                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);                String msg = "msg002";                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV?targetYear="+targetYear+"';";                req.setAttribute("msg", msg);                req.setAttribute("url", url);                dest = WebUtil.JspURL+"common/msg.jsp";                //ApLog                ctrl = "11";                cnt = String.valueOf(medi_vt.size());            } else if(jobid.equals("AddorDel")){                int    medi_count = box.getInt("medi_count");                String curr_job   = box.getString("curr_job");                //String rowCount   = box.getString("medi_count");                String rowCount   = box.getString("rowCount");      //@v1.2//              2002.12.04. 연말정산 확정여부 조회                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );                for( int i = 0 ; i < medi_count ; i++ ) {                    D11TaxAdjustMedicalData data = new D11TaxAdjustMedicalData();                    String idx = Integer.toString(i);                    data.SUBTY = box.get("SUBTY"+idx)   ;   // 가족 관계                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {                        continue;                    }                    if( box.get("use_flag"+idx).equals("N") ) continue; //@v1.2                    data.GUBUN    = box.get("GUBUN"+idx).equals("1")?"1":"2";   // @v1.1구분자동반영분                    if(box.get("PDF"+idx).equals("X")){                    	data.GUBUN = "9";                    }                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // 성명                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // 주민등록번호                    data.CONTENT  = box.get("CONTENT"+idx) ;   // 의료비내용                    data.BIZNO    = box.get("BIZNO"+idx)   ;   // 사업자등록번호                    data.BIZ_NAME = box.get("BIZ_NAME"+idx);   // 상호                    data.CA_BETRG = box.get("CA_BETRG"+idx)   ;   // @v1.2현금사용분                    data.CA_CNT = box.get("CA_CNT"+idx)   ;   // @v1.2현금사용분                    data.OLDD     = box.get("OLDD"+idx)     ;   // 경로우대 대상자여부                    data.OBST     = box.get("OBST"+idx)    ;   // 장애자여부                    data.CHNTS    = box.get("CHNTS"+idx)    ;   // 국세청자료                    data.METYP    = box.get("METYP"+idx)    ;   // 의료증빙코드                    data.OMIT_FLAG    = box.get("OMIT_FLAG"+idx); //삭제 플래그                    data.GLASS_CHK    = box.get("GLASS_CHK"+idx); //안경콘택트렌즈공제                    data.DIFPG_CHK    = box.get("DIFPG_CHK"+idx); //@2015연말정산 난임시술비                    medi_vt.addElement(data);                }                req.setAttribute( "targetYear", targetYear );                req.setAttribute( "medi_vt"   , medi_vt    );                req.setAttribute( "o_flag"    , o_flag     );                req.setAttribute( "rowCount"  , rowCount );                if ( curr_job.equals("build") ) {    // 입력화면                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustMedicalBuild.jsp";                } else {                             // 입력                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustMedicalChange.jsp";                }            } else if(jobid.equals("first_print")) {                String print_page_name = WebUtil.ServletURL + "hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV?jobid=print&targetYear="+targetYear;                req.setAttribute( "print_page_name", print_page_name );                dest =  WebUtil.JspURL + "common/printFrame2.jsp";            } else if( jobid.equals("print") ){                mediData_vt = rfc.getMedical( user.empNo, targetYear );                for( int i = 0 ; i < mediData_vt.size() ; i++ ) {                    D11TaxAdjustMedicalData data = (D11TaxAdjustMedicalData)mediData_vt.get(i);                    data.CA_BETRG = Double.toString(Double.parseDouble(data.CA_BETRG)*100 );                    medi_vt.addElement(data);                }                req.setAttribute( "targetYear", targetYear );                req.setAttribute( "medi_vt"   , medi_vt    );                req.setAttribute( "PNT_SEQ", print_seq);////@2014 연말정산 소득공제신고서 seq 추가                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustMedicalPrint.jsp";            } else {                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));            }            Logger.debug.println(this, " destributed = " + dest);            //ApLog 생성            if(jobid.equals("first")||jobid.equals("build")||jobid.equals("change_first")||jobid.equals("change")){            	ApLoggerWriter.writeApLog("연말정산", "의료비", "D11TaxAdjustMedicalSV", "의료비", ctrl, cnt, val, user, req.getRemoteAddr());            }            printJspPage(req, res, dest);        } catch(Exception e) {            throw new GeneralException(e);        }	}}