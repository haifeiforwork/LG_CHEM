package servlet.hris.D.D11TaxAdjust;

import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.db.*;
import hris.common.rfc.*;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;
/**
 * D11TaxAdjustEduSV.java
 * 연말정산 - 특별공제 교육비를 신청/수정/조회할 수 있도록 하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/11/20
 */
public class D11TaxAdjustEduSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession              session    = req.getSession(false);
            WebUserData              user       = (WebUserData)session.getAttribute("user");
            Box                      box        = WebUtil.getBox(req);
            
            D11TaxAdjustEduRFC       rfc        = new D11TaxAdjustEduRFC();
            D11TaxAdjustYearCheckRFC rfc_o      = new D11TaxAdjustYearCheckRFC();
            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();
            Vector                   edu_vt     = new Vector(); 

            String                   dest       = "";
            String                   jobid      = "";
            String                   targetYear = box.get("targetYear");
            String                   flag       = "";
            String                   o_flag     = "";

            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            
            if(jobid.equals("first")){
              
                flag   = rfc.getE_FLAG( user.empNo, targetYear );
                edu_vt = rfc.getEdu( user.empNo, targetYear );

//              2002.12.04. 연말정산 확정여부 조회
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                 // if( flag.equals("X") ) {          // 조회
                if( edu_vt != null && edu_vt.size() > 0 ) {    // 조회
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduDetail.jsp";
                } else {                          // 신규
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduBuild.jsp";
                }

                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "edu_vt"    , edu_vt     );
                req.setAttribute( "flag"      , flag       );
                req.setAttribute( "o_flag"    , o_flag     );
                
            } else if(jobid.equals("build")){
              
                int rowCount = box.getInt("rowCount");
                for( int i = 0 ; i < rowCount ; i++ ) {
                    D11TaxAdjustDeductData data = new D11TaxAdjustDeductData();
                    String          idx             = Integer.toString(i);

                    data.GUBN_CODE  = box.get("GUBN_CODE"+idx) ;   // 연말정산 구분               
                    data.GOJE_CODE  = box.get("GOJE_CODE"+idx) ;   // 공제코드                        
                    data.GUBN_TEXT  = box.get("GUBN_TEXT"+idx) ;   // 구분 텍스트                     
                    data.SUBTY      = box.get("SUBTY"+idx)     ;   // 하부유형                        
                    data.STEXT      = box.get("STEXT"+idx)     ;   // 하부유형이름                    
                    data.ENAME      = box.get("ENAME"+idx)     ;   // 사원 또는 지원자의 포맷이름     
                    data.REGNO      = box.get("REGNO"+idx)     ;   // 주민등록번호                    
                    data.FASAR      = box.get("FASAR"+idx)     ;   // 가족구성원의 학력               
                    data.ADD_BETRG  = box.get("ADD_BETRG"+idx) ;   // HR 급여관리: 금액               
                    data.ACT_BETRG  = box.get("ACT_BETRG"+idx) ;   // HR 급여관리: 금액               
                    data.AUTO_BETRG = box.get("AUTO_BETRG"+idx);   // HR 급여관리: 금액               
                    data.AUTO_TEXT  = box.get("AUTO_TEXT"+idx) ;   // 자동분내역                      
                    data.GOJE_FLAG  = box.get("GOJE_FLAG")     ;   // 플래그                          
                    data.FTEXT      = box.get("FTEXT"+idx)     ;   // 필드텍스트                      
                    data.FLAG       = box.get("FLAG"+idx)      ;    
                    data.CHNTS      = box.get("CHNTS"+idx)    ;   // @v1.2국세청증빙여부
                    data.OMIT_FLAG    = box.get("OMIT_FLAG"+idx); //삭제 플래그
                    data.EXSTY    = box.get("EXSTY"+idx); //@2011 교복구입비용
                  
                    edu_vt.addElement(data);
                }
                
                rfc.change( user.empNo, targetYear, edu_vt );

                String FSTID     = box.get("FSTID")      ;    //세대주체크여부
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);
                String msg = "msg007";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustEduSV?targetYear="+targetYear+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                
                dest = WebUtil.JspURL+"common/msg.jsp";
                
            } else if(jobid.equals("change_first")){
              
                edu_vt = rfc.getEdu( user.empNo, targetYear );
                
                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduChange.jsp";
                
                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "edu_vt"    , edu_vt     );
                req.setAttribute( "rowCount"  , "8"        );
                
            } else if(jobid.equals("change")){
              
                int rowCount = box.getInt("rowCount");
                for( int i = 0 ; i < rowCount ; i++ ) {
                    D11TaxAdjustDeductData data = new D11TaxAdjustDeductData();
                    String          idx             = Integer.toString(i);

                    data.GUBN_CODE  = box.get("GUBN_CODE"+idx) ;   // 연말정산 구분               
                    data.GOJE_CODE  = box.get("GOJE_CODE"+idx) ;   // 공제코드                        
                    data.GUBN_TEXT  = box.get("GUBN_TEXT"+idx) ;   // 구분 텍스트                     
                    data.SUBTY      = box.get("SUBTY"+idx)     ;   // 하부유형                        
                    data.STEXT      = box.get("STEXT"+idx)     ;   // 하부유형이름                    
                    data.ENAME      = box.get("ENAME"+idx)     ;   // 사원 또는 지원자의 포맷이름     
                    data.REGNO      = box.get("REGNO"+idx)     ;   // 주민등록번호                    
                    data.FASAR      = box.get("FASAR"+idx)     ;   // 가족구성원의 학력               
                    data.ADD_BETRG  = box.get("ADD_BETRG"+idx) ;   // HR 급여관리: 금액               
                    data.ACT_BETRG  = box.get("ACT_BETRG"+idx) ;   // HR 급여관리: 금액               
                    data.AUTO_BETRG = box.get("AUTO_BETRG"+idx);   // HR 급여관리: 금액               
                    data.AUTO_TEXT  = box.get("AUTO_TEXT"+idx) ;   // 자동분내역                      
                    data.GOJE_FLAG  = box.get("GOJE_FLAG")     ;   // 플래그                          
                    data.FTEXT      = box.get("FTEXT"+idx)     ;   // 필드텍스트                      
                    data.FLAG       = box.get("FLAG"+idx)      ;    
                    data.CHNTS      = box.get("CHNTS"+idx)    ;   // @v1.2국세청증빙여부
                    data.OMIT_FLAG    = box.get("OMIT_FLAG"+idx); //삭제 플래그
                    data.EXSTY    = box.get("EXSTY"+idx); //@2011 교복구입비용

                    edu_vt.addElement(data);
                }
                
                rfc.change( user.empNo, targetYear, edu_vt );
                String FSTID     = box.get("FSTID")      ;    //세대주체크여부
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);
                req.setAttribute( "rowCount"  , "8"        );

                String msg = "msg002";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustEduSV?targetYear="+targetYear+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                
                dest = WebUtil.JspURL+"common/msg.jsp";
            } else if(jobid.equals("AddorDel")){

                int    edu_count = box.getInt("edu_count");
                String curr_job   = box.getString("curr_job");
                String rowCount   = box.getString("rowCount");      //@v1.2

//              2002.12.04. 연말정산 확정여부 조회
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                for( int i = 0 ; i < edu_count ; i++ ) {
                	D11TaxAdjustDeductData data = new D11TaxAdjustDeductData();
                    String idx = Integer.toString(i);

                    data.SUBTY = box.get("SUBTY"+idx)   ;   // 가족 관계
                    String GOJE_FLAG = box.get("GOJE_FLAG");
                    if ( GOJE_FLAG.equals("")  ) {
                    	 data.GOJE_FLAG = "1"   ;   // 가족 관계 
                    }                   
                    else            
                        data.GOJE_FLAG  = GOJE_FLAG;   // 플래그                     
                    
                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {
                        continue;
                    }
                    if( box.get("use_flag"+idx).equals("N") ) continue; // 

                    data.GUBN_CODE  = box.get("GUBN_CODE"+idx) ;   // 연말정산 구분               
                    data.GOJE_CODE  = box.get("GOJE_CODE"+idx) ;   // 공제코드                        
                    data.GUBN_TEXT  = box.get("GUBN_TEXT"+idx) ;   // 구분 텍스트                     
                    data.SUBTY      = box.get("SUBTY"+idx)     ;   // 하부유형                        
                    data.STEXT      = box.get("STEXT"+idx)     ;   // 하부유형이름                    
                    data.ENAME      = box.get("ENAME"+idx)     ;   // 사원 또는 지원자의 포맷이름     
                    data.REGNO      = box.get("REGNO"+idx)     ;   // 주민등록번호                    
                    data.FASAR      = box.get("FASAR"+idx)     ;   // 가족구성원의 학력               
                    data.ADD_BETRG  = box.get("ADD_BETRG"+idx) ;   // HR 급여관리: 금액               
                    data.ACT_BETRG  = box.get("ACT_BETRG"+idx) ;   // HR 급여관리: 금액               
                    data.AUTO_BETRG = box.get("AUTO_BETRG"+idx);   // HR 급여관리: 금액               
                    data.AUTO_TEXT  = box.get("AUTO_TEXT"+idx) ;   // 자동분내역                
                    data.FTEXT      = box.get("FTEXT"+idx)     ;   // 필드텍스트                      
                    data.FLAG       = box.get("FLAG"+idx)      ;    
                    data.CHNTS      = box.get("CHNTS"+idx)    ;   // @v1.2국세청증빙여부
                    data.OMIT_FLAG    = box.get("OMIT_FLAG"+idx); //삭제 플래그
                    data.EXSTY    = box.get("EXSTY"+idx); //@2011 교복구입비용

                    edu_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "edu_vt"   , edu_vt    );
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , rowCount );

                if ( curr_job.equals("build") ) {    // 입력화면
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduBuild.jsp";
                } else {                             // 입력
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduChange.jsp";
                }

            } else {
              
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
                
            }
            
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}