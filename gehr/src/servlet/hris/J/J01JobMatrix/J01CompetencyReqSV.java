package servlet.hris.J.J01JobMatrix;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;

import hris.J.J01JobMatrix.*;
import hris.J.J01JobMatrix.rfc.*;

/**
 * J01CompetencyReqSV.java
 * Competency Requirements 상세내역 등을 조회한다. 
 *
 * @author  김도신
 * @version 1.0, 2003/02/13
 */
public class J01CompetencyReqSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");
            
            Box                 box            = WebUtil.getBox(req);

            J01CompetencyReqRFC rfc            = new J01CompetencyReqRFC();

            Vector              ret            = new Vector();
            Vector              j01Result_Q_vt = new Vector();
            Vector              j01Result_D_vt = new Vector();

            String              i_objid        = "";
            String              i_sobid        = "";
            String              i_pernr        = "";
            String              i_link_chk     = "";           
            String              i_idx          = "";
            String              i_begda        = "";
            String              dest           = "";

            i_objid    = box.get("OBJID");
            i_sobid    = box.get("SOBID");
            i_pernr    = box.get("PERNR");   
            i_link_chk = box.get("i_link_chk");                     
            i_idx      = box.get("IMGIDX");
//          적용일자(조회기준일) 추가
            i_begda    = box.get("BEGDA");

//          Competency Requirements 조회
            ret            = rfc.getDetail( i_objid, i_sobid, i_begda );

            j01Result_Q_vt = (Vector)ret.get(0);
            j01Result_D_vt = (Vector)ret.get(1);
                  
//          Competency Requirements
            req.setAttribute("j01Result_Q_vt", j01Result_Q_vt);
            req.setAttribute("j01Result_D_vt", j01Result_D_vt);
//          Objective ID, Job ID
            req.setAttribute("i_objid",        i_objid);
            req.setAttribute("i_sobid",        i_sobid);
            req.setAttribute("i_pernr",        i_pernr); 
            req.setAttribute("i_link_chk",     i_link_chk);                                       
            req.setAttribute("i_imgidx",       i_idx);
            req.setAttribute("i_begda",        i_begda);

            dest = WebUtil.JspURL+"J/J01JobMatrix/J01CompetencyReq.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
