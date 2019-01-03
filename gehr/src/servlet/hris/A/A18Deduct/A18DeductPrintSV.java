package	servlet.hris.A.A18Deduct;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.db.*;
import hris.common.mail.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.A.A18Deduct.*;
import hris.A.A18Deduct.rfc.*;
import hris.D.D11TaxAdjust.rfc.*;

/**
 * A18DeductPrintSV.java
 * 근로소득 원천징수 영수증, 갑근세 원천징수 증명서 조회를 인쇄할 수 있도록 하는 Class
 * [CSR ID:1639484] ESS 원천징수 영수증 출력 PDF 변환 지민재 2010.04.09
 * @author  김도신   
 * @version 1.0, 2002/10/22
 */
public class A18DeductPrintSV extends EHRBaseServlet {

    private String UPMU_TYPE ="28";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
             
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }

            if( jobid.equals("print_form") ) {  // 재직증명서 내역을 인쇄하기 위한 작업      

                String sPerNR    = user.empNo;                  // 결재 요청자
                String sAinfSeqn = box.get("AINF_SEQN");        // 결재 번호 
                String sGuenType = box.get("GUEN_TYPE");        // 증명서 출력유형( 001: 근로소득 원천징수 영수증 , 002:갑근세 원천징수 영수증(한글), 003:갑근세 원천징수 영수증(영문) )
                
                if ( sGuenType.equals("01") )
                {   //2010.04.09 원천징수 영수증 출력
                    String sTargetYear = String.valueOf(DateTime.getYear() - 1);   // 귀속연도
                    
                    req.setAttribute("sPerNR",      sPerNR);
                    req.setAttribute("sTargetYear", sTargetYear);
                    req.setAttribute("sAinfSeqn",   sAinfSeqn);
                    dest = WebUtil.JspURL+"A/A18Deduct/A18DeductPrintFormEmbedGunroSoduk.jsp";
              
                } 
            } else if ( jobid.equals("preview_form")) {   // 미리보기 창을 열기 위한 작업
                
                String sAinfSeqn = box.get("AINF_SEQN");        // 결재 번호 
                String sGuenType = box.get("GUEN_TYPE");        // 증명서 출력유형( 001: 근로소득 원천징수 영수증 , 002:갑근세 원천징수 영수증(한글), 003:갑근세 원천징수 영수증(영문) ) 
                 
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A18Deduct.A18DeductPrintSV?jobid=print_form&AINF_SEQN="+sAinfSeqn+"&GUEN_TYPE="+sGuenType );
                req.setAttribute( "isPopUp", "true" );
                req.setAttribute( "isDirect", "false" );
                req.setAttribute( "sPerNR", user.empNo);         
                req.setAttribute( "sAinfSeqn", sAinfSeqn);       
                req.setAttribute( "sGuenType", sGuenType);
                req.setAttribute( "sTargetYear", String.valueOf(DateTime.getYear() - 1));
                
                dest = WebUtil.JspURL+"common/printFrame.jsp";
                
              
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
    }
}



