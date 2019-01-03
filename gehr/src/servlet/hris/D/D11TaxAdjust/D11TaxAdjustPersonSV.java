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
 * D11TaxAdjustPersonSV.java
 * 연말정산 - 인적공제를 조회할 수 있도록 하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/11/20
 * @version 2.0, 2014/02/10  CSR ID :C20140106_63914
 * 2018/01/07  rdcamel [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건
 */
public class D11TaxAdjustPersonSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
        	//req.setCharacterEncoding("KSC5601");
        	//ApLog
        	String ctrl = "";
        	String cnt = "0";
        	String[] val = null;

            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            Box         box     = WebUtil.getBox(req);

            D11TaxAdjustPersonRFC    rfc   = new D11TaxAdjustPersonRFC();
            D11TaxAdjustYearCheckRFC rfc_o = new D11TaxAdjustYearCheckRFC();
            Vector person_vt  = new Vector();
            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();

            String jobid      = "";
            String dest       = "";
            String targetYear = box.get("targetYear");
            String o_flag     = "";

            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }

            if( jobid.equals("first") ){
//              2002.12.04. 연말정산 확정여부 조회
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                // 인적공제 조회 - 생성, 수정할 정보가 아니다.
                person_vt = rfc.getPerson( user.empNo, targetYear );

                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustPerson.jsp";

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "person_vt" , person_vt  );
                req.setAttribute( "o_flag"    , o_flag     );

                //ApLog
                ctrl = "12";

            } else if ( jobid.equals("build") ){

                int rowCount = box.getInt("rowCount");

                for( int i = 0 ; i < rowCount ; i++ ) {
                    D11TaxAdjustPersonData data = new D11TaxAdjustPersonData();
                    String idx = Integer.toString(i);

                    data.SUBTY   = box.get("SUBTY"+idx) ;
                    data.STEXT   = box.get("STEXT"+idx) ;
                    data.ENAME   = box.get("ENAME"+idx)   ;
                    data.REGNO   = box.get("REGNO"+idx);
                    data.BETRG01 = Double.toString(Double.parseDouble(box.get("BETRG01"+idx))/100 );//기본공제
                    data.BETRG02 = Double.toString(Double.parseDouble(box.get("BETRG02"+idx))/100 );//경로우대
                    data.BETRG03 = Double.toString(Double.parseDouble(box.get("BETRG03"+idx))/100 );//장애자
                    data.BETRG04 = Double.toString(Double.parseDouble(box.get("BETRG04"+idx))/100 );//부녀자
                    //data.BETRG05 = Double.toString(Double.parseDouble(box.get("BETRG05"+idx))/100 );//@2014 연말정산 자녀양육비 삭제
                    //data.BETRG06 = Double.toString(Double.parseDouble(box.get("BETRG06"+idx))/100 );//@2014 연말정산 출산입양비 삭제
                    data.BETRG07 = Double.toString(Double.parseDouble(box.get("BETRG07"+idx))/100 ); //CSR ID :C20140106_63914  //한부모
                    //data.CHILD   = box.get("CHILD"+idx) ;//@2014 연말정산 자녀양육 삭제
                    data.WOMEE   = box.get("WOMEE"+idx) ;  // 부녀자공제
                    data.FSTID   = box.get("FSTID"+idx) ;  //   위탁아동 지시자
                    data.HNDEE   = box.get("HNDEE"+idx) ;  // 장애인사원 CSR ID :C20140106_63914
                    data.HNDCD   = box.get("HNDCD"+idx) ;  // 장애 코드 CSR ID :C20140106_63914
                    data.KDBSL    = box.get("KDBSL"+idx);    //[CSR ID:3569665] 2017년 자녀 수 수정 가능하도록 추가.

                    person_vt.addElement(data);

                    //ApLog
                    if(i==0){
                    	val = new String[13];
	                    val[0] = data.SUBTY;
	                    val[1] = data.STEXT;
	                    val[2] = data.ENAME;
	                    val[3] = data.REGNO;
	                    val[4] = data.BETRG01;
	                    val[5] = data.BETRG02;
	                    val[6] = data.BETRG03;
	                    val[7] = data.BETRG04;
	                    val[8] = data.BETRG05;
	                    val[9] = data.BETRG06;
	                    val[10] = data.CHILD;
	                    val[11] = data.WOMEE;
	                    val[12] = data.FSTID;
                    }
                }
                //Logger.debug.println("person_vt=========="+person_vt.toString() );

                rfc.build( user.empNo, targetYear, person_vt );

                String FSTID     = box.get("FSTID")      ;    //세대주체크여부
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg002";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustPersonSV?targetYear="+targetYear+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";

                //ApLog
                ctrl = "11";
                cnt = String.valueOf(person_vt.size());

            }

            //Logger.debug.println(this, " destributed = " + dest);

            //ApLog 생성
            ApLoggerWriter.writeApLog("연말정산", "인적공제", "D11TaxAdjustPersonSV", "인적공제", ctrl, cnt, val, user, req.getRemoteAddr());

            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
