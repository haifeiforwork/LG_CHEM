package servlet.hris.B.B05JobProfile;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;

import hris.B.B05JobProfile.*;
import hris.B.B05JobProfile.rfc.*;

/**
 * B05JobProfileSV.java
 * Job Profile 상세내역 등을 조회한다. 
 *
 * @author 김도신
 * @version 1.0, 2003/02/12
 */
public class B05JobProfileSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession      session        = req.getSession(false);
            WebUserData      user           = (WebUserData)session.getAttribute("user");
            
            Box              box            = WebUtil.getBox(req);

            B05JobProfileRFC rfc            = new B05JobProfileRFC();

            Vector           ret            = new Vector();
            Vector           b05Result_vt   = new Vector();
            Vector           b05Result_P_vt = new Vector();
            Vector           b05Result_D_vt = new Vector();

            String           jobid          = "";
            String           i_objid        = "";
            String           i_sobid        = "";
            String           dest           = "";
            
            jobid    = box.get("jobid");
            i_objid  = box.get("OBJID");
            i_sobid  = box.get("SOBID");
            
            if( jobid.equals("") ) {
                jobid = "first";
            }

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : " + user.toString());

            if( jobid.equals("first") ){
                if( !i_objid.equals("") && !i_sobid.equals("") ) {
                  
                    ret            = rfc.getDetail( i_objid, i_sobid );

                    b05Result_vt   = (Vector)ret.get(0);
                    b05Result_P_vt = (Vector)ret.get(1);
                    b05Result_D_vt = (Vector)ret.get(2);
                  
                }
    
                req.setAttribute("b05Result_vt",   b05Result_vt);
                req.setAttribute("b05Result_P_vt", b05Result_P_vt);
                req.setAttribute("b05Result_D_vt", b05Result_D_vt);
                req.setAttribute("i_objid",        i_objid);
                req.setAttribute("i_sobid",        i_sobid);
                
                dest = WebUtil.JspURL+"B/B05JobProfile/B05JobProfile.jsp";
                Logger.debug.println(this, " destributed = " + dest);
                printJspPage(req, res, dest);
            }
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
