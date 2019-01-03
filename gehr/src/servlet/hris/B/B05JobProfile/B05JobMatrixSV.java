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
 * B05JobMatrixSV.java
 * Objective ID와 명을 넘겨받아서 JobMatrix를 조회한다. 
 *
 * @author 김도신
 * @version 1.0, 2003/02/12
 */
public class B05JobMatrixSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession     session          = req.getSession(false);
            WebUserData     user             = (WebUserData)session.getAttribute("user");
            
            Box             box              = WebUtil.getBox(req);

            B05LevelListRFC rfc_Level        = new B05LevelListRFC();
            B05JobMatrixRFC rfc_Matrix       = new B05JobMatrixRFC();

            Vector          b05LevelList_vt  = new Vector();
            Vector          b05DgubunList_vt = new Vector();
            Vector          b05JobProfile_vt = new Vector();

            String          jobid            = "";
            String          i_sobid          = "";
            String          i_stext          = "";
            String          dest             = "";
            
            jobid    = box.get("jobid");
            i_sobid  = box.get("i_sobid");
            
            if( jobid.equals("") ) {
                jobid = "first";
            }

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : " + user.toString());

            if( jobid.equals("first") ){
                b05LevelList_vt  = rfc_Level.getDetail();

                if( !i_sobid.equals("") ) {
                  
                    b05DgubunList_vt = rfc_Matrix.getDetail(i_sobid, "P_RESULT_D");
                    b05JobProfile_vt = rfc_Matrix.getDetail(i_sobid, "P_RESULT");
                    i_stext          = rfc_Matrix.getE_STEXT(i_sobid);
    
                }
    
                req.setAttribute("b05LevelList_vt",  b05LevelList_vt);
                req.setAttribute("b05DgubunList_vt", b05DgubunList_vt);
                req.setAttribute("b05JobProfile_vt", b05JobProfile_vt);
                req.setAttribute("i_sobid",          i_sobid);
                req.setAttribute("i_stext",          i_stext);
                
                dest = WebUtil.JspURL+"B/B05JobProfile/B05JobMatrix.jsp";
                Logger.debug.println(this, " destributed = " + dest);
                printJspPage(req, res, dest);
            }
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
