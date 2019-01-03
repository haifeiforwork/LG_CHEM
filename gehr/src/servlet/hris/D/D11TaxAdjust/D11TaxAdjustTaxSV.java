package servlet.hris.D.D11TaxAdjust;import java.sql.*;import java.util.Vector;import javax.servlet.*;import javax.servlet.http.*;import com.sns.jdf.*;import com.sns.jdf.db.*;import com.sns.jdf.util.*;import com.sns.jdf.servlet.*;import hris.common.*;import hris.common.util.*;import hris.common.db.*;import hris.common.rfc.*;import hris.D.D11TaxAdjust.*;import hris.D.D11TaxAdjust.rfc.*;/** * D11TaxAdjustTaxSV.java * 연말정산 - 특별공제 교육비를 신청/수정/조회할 수 있도록 하는 Class * * @author 김도신 * @version 1.0, 2002/11/20 */public class D11TaxAdjustTaxSV extends EHRBaseServlet {    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {        try{        	//ApLog        	String ctrl = "";        	String cnt = "0";        	String[] val = null;            HttpSession              session    = req.getSession(false);            WebUserData              user       = (WebUserData)session.getAttribute("user");            Box                      box        = WebUtil.getBox(req);                        D11TaxAdjustTaxRFC       rfc        = new D11TaxAdjustTaxRFC();            D11TaxAdjustYearCheckRFC rfc_o      = new D11TaxAdjustYearCheckRFC();            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();            Vector                   tax_vt     = new Vector();             String                   dest       = "";            String                   jobid      = "";            String                   targetYear = box.get("targetYear");            String                   flag       = "";            String                   o_flag     = "";            if( targetYear.equals("") ){                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;            }            jobid = box.get("jobid");            if( jobid.equals("") ){                jobid = "first";            }                        if(jobid.equals("first")){                flag   = rfc.getE_FLAG( user.empNo, targetYear );                tax_vt = rfc.getTax( user.empNo, targetYear ,"");//              2002.12.04. 연말정산 확정여부 조회                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );                                if( flag.equals("X") ) {          // 조회                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustTaxDetail.jsp";                } else {                          // 신규                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustTaxBuild.jsp";                }                                req.setAttribute( "targetYear", targetYear );                req.setAttribute( "tax_vt"    , tax_vt     );                req.setAttribute( "flag"      , flag       );                req.setAttribute( "o_flag"    , o_flag     );                //ApLog                ctrl = "12";            } else if(jobid.equals("build")){                              int rowCount = box.getInt("rowCount");                for( int i = 0 ; i < rowCount ; i++ ) {                    D11TaxAdjustDeductData data = new D11TaxAdjustDeductData();                    String          idx             = Integer.toString(i);                                        data.ADD_BETRG  = box.get("ADD_BETRG"+idx) ;   // HR 급여관리: 금액                                   data.ACT_BETRG  = box.get("ACT_BETRG"+idx) ;   // HR 급여관리: 금액                                   data.AUTO_BETRG = box.get("AUTO_BETRG"+idx);   // HR 급여관리: 금액                         data.GUBN_CODE  = box.get("GUBN_CODE"+idx) ;   // 연말정산 구분                                   data.GOJE_CODE  = box.get("GOJE_CODE"+idx) ;   // 공제코드                                            data.GUBN_TEXT  = box.get("GUBN_TEXT"+idx) ;   // 구분 텍스트                                         data.SUBTY      = box.get("SUBTY"+idx)     ;   // 하부유형                                            data.STEXT      = box.get("STEXT"+idx)     ;   // 하부유형이름                                        data.ENAME      = box.get("ENAME"+idx)     ;   // 사원 또는 지원자의 포맷이름                         data.REGNO      = box.get("REGNO"+idx)     ;   // 주민등록번호                                        data.FASAR      = box.get("FASAR"+idx)     ;   // 가족구성원의 학력                                       data.AUTO_TEXT  = box.get("AUTO_TEXT"+idx) ;   // 자동분내역                                          data.GOJE_FLAG  = box.get("GOJE_FLAG")     ;   // 플래그                                              data.FTEXT      = box.get("FTEXT"+idx)     ;   // 필드텍스트                                          data.FLAG       = box.get("FLAG"+idx)      ;                        tax_vt.addElement(data);                    //ApLog                    if(i==0){                    	val = new String[15];	                    val[0] = data.ADD_BETRG;	                    val[1] = data.ACT_BETRG;	                    val[2] = data.AUTO_BETRG;	                    val[3] = data.GUBN_CODE;	                    val[4] = data.GOJE_CODE;	                    val[5] = data.GUBN_TEXT;	                    val[6] = data.SUBTY;	                    val[7] = data.STEXT;	                    val[8] = data.ENAME;	                    val[9] = data.REGNO;	                    val[10] = data.FASAR;	                    val[11] = data.AUTO_TEXT;	                    val[12] = data.GOJE_FLAG;	                    val[13] = data.FTEXT;	                    val[14] = data.FLAG;                    }                }                                rfc.change( user.empNo, targetYear, tax_vt );                String FSTID     = box.get("FSTID")      ;    //세대주체크여부                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);                String msg = "msg007";                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustTaxSV?targetYear="+targetYear+"';";                req.setAttribute("msg", msg);                req.setAttribute("url", url);                                dest = WebUtil.JspURL+"common/msg.jsp";                //ApLog                                ctrl = "11";                cnt = String.valueOf(tax_vt.size());            } else if(jobid.equals("change_first")){                              tax_vt = rfc.getTax( user.empNo, targetYear,"" );                                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustTaxChange.jsp";                                req.setAttribute( "targetYear", targetYear );                req.setAttribute( "tax_vt"    , tax_vt     );                //ApLog                                ctrl = "12";            } else if(jobid.equals("change")){                              int rowCount = box.getInt("rowCount");                for( int i = 0 ; i < rowCount ; i++ ) {                    D11TaxAdjustDeductData data = new D11TaxAdjustDeductData();                    String          idx             = Integer.toString(i);                                        data.ADD_BETRG  = box.get("ADD_BETRG"+idx) ;   // HR 급여관리: 금액                                   data.ACT_BETRG  = box.get("ACT_BETRG"+idx) ;   // HR 급여관리: 금액                                   data.AUTO_BETRG = box.get("AUTO_BETRG"+idx);   // HR 급여관리: 금액                                                data.GUBN_CODE  = box.get("GUBN_CODE"+idx) ;   // 연말정산 구분                                   data.GOJE_CODE  = box.get("GOJE_CODE"+idx) ;   // 공제코드                                            data.GUBN_TEXT  = box.get("GUBN_TEXT"+idx) ;   // 구분 텍스트                                         data.SUBTY      = box.get("SUBTY"+idx)     ;   // 하부유형                                            data.STEXT      = box.get("STEXT"+idx)     ;   // 하부유형이름                                        data.ENAME      = box.get("ENAME"+idx)     ;   // 사원 또는 지원자의 포맷이름                         data.REGNO      = box.get("REGNO"+idx)     ;   // 주민등록번호                                        data.FASAR      = box.get("FASAR"+idx)     ;   // 가족구성원의 학력                                     data.AUTO_TEXT  = box.get("AUTO_TEXT"+idx) ;   // 자동분내역                                          data.GOJE_FLAG  = box.get("GOJE_FLAG")     ;   // 플래그                                              data.FTEXT      = box.get("FTEXT"+idx)     ;   // 필드텍스트                                          data.FLAG       = box.get("FLAG"+idx)      ;                        tax_vt.addElement(data);                    //ApLog                    if(i==0){                    	val = new String[15];	                    val[0] = data.ADD_BETRG;	                    val[1] = data.ACT_BETRG;	                    val[2] = data.AUTO_BETRG;	                    val[3] = data.GUBN_CODE;	                    val[4] = data.GOJE_CODE;	                    val[5] = data.GUBN_TEXT;	                    val[6] = data.SUBTY;	                    val[7] = data.STEXT;	                    val[8] = data.ENAME;	                    val[9] = data.REGNO;	                    val[10] = data.FASAR;	                    val[11] = data.AUTO_TEXT;	                    val[12] = data.GOJE_FLAG;	                    val[13] = data.FTEXT;	                    val[14] = data.FLAG;                    }                }                                rfc.change( user.empNo, targetYear, tax_vt );                String FSTID     = box.get("FSTID")      ;    //세대주체크여부                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);                String msg = "msg002";                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustTaxSV?targetYear="+targetYear+"';";                req.setAttribute("msg", msg);                req.setAttribute("url", url);                                dest = WebUtil.JspURL+"common/msg.jsp";                //ApLog                                ctrl = "11";                cnt = String.valueOf(tax_vt.size());            } else {                              throw new BusinessException(g.getMessage("MSG.COMMON.0016"));                            }                        Logger.debug.println(this, " destributed = " + dest);            //ApLog 생성            ApLoggerWriter.writeApLog("연말정산", "기타세액공제", "D11TaxAdjustTaxSV", "기타세액공제", ctrl, cnt, val, user, req.getRemoteAddr());            printJspPage(req, res, dest);        } catch(Exception e) {            throw new GeneralException(e);        }	}}