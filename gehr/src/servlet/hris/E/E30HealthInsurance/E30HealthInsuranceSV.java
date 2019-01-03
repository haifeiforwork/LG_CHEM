package servlet.hris.E.E30HealthInsurance;

import java.io.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.E.E30HealthInsurance.*;
import hris.E.E30HealthInsurance.rfc.*;
import hris.common.WebUserData;

/**
 * E30HealthInsuranceSV.java
 * 건강보험 관련 정보를 jsp로 넘겨주는 class 
 *
 * @author  김도신
 * @version 1.0, 2003/02/19
 */
public class E30HealthInsuranceSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");

            String jobid = "";
            String dest = "";

            Box box = WebUtil.getBox(req);
            
            jobid   = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E30HealthInsuranceRFC rfc            = new E30HealthInsuranceRFC(); 
            Vector                ret            = new Vector();
            Vector                e30Health01_vt = new Vector();
            Vector                e30Health02_vt = new Vector();
            
            String                E_MINUM        = "";
            String                E_MICNR        = "";

            if(jobid.equals("first")) { 
                ret            = rfc.getDetail( user.empNo );
                E_MINUM        = rfc.getE_MINUM( user.empNo );
                E_MICNR        = rfc.getE_MICNR( user.empNo );

                e30Health01_vt = (Vector)ret.get(0);
                e30Health02_vt = (Vector)ret.get(1);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            req.setAttribute("e30Health01_vt", e30Health01_vt);
            req.setAttribute("e30Health02_vt", e30Health02_vt);
            req.setAttribute("E_MINUM",        E_MINUM);
            req.setAttribute("E_MICNR",        E_MICNR);
            
            dest = WebUtil.JspURL+"E/E30HealthInsurance.jsp";
            printJspPage(req, res, dest);
            
            Logger.debug.println(this, " destributed = " + dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } 
    }
}