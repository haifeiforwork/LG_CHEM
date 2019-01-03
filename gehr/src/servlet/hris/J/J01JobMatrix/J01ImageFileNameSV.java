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
 * J01ImageFileNameSV.java
 * Eloffice의 Job Unit별 KSEA, Job Process Image FileName을 조회한다. 
 *
 * @author  김도신
 * @version 1.0, 2003/05/14
 */
public class J01ImageFileNameSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");
            
            Box                 box            = WebUtil.getBox(req);

            J01ImageFileNameRFC rfc            = new J01ImageFileNameRFC();

            Vector              ret            = new Vector();
            Vector              j01Result_vt   = new Vector();
            Vector              j01Result_P_vt = new Vector();
            Vector              j01Result_D_vt = new Vector();

            String              i_objid        = box.get("OBJID");
            String              i_sobid        = box.get("SOBID");
            String              i_pernr        = box.get("PERNR");
            String              i_link_chk     = box.get("i_link_chk");
            String              i_idx          = box.get("IMGIDX");
            String              i_begda        = box.get("BEGDA");
            String              dest           = "";
//          paging 처리
            String              page           = "";

//          i_idx = '3'이면 Job Unit별 KSEA, i_idx = '4'이면 Job Process - R/3의 구분자와 맞춰준다.
//          - 이미지화일 조회시 index에서 2를 빼준다.
            String              i_gubun        = Integer.toString(Integer.parseInt(i_idx) - 2);

            page  = box.get("page");
            if( page.equals("") || page == null ){
                page = "1";
            }
            
//          Job Unit별 KSEA, Job Process Image FileName 조회
            ret            = rfc.getDetail( i_gubun, i_objid, i_sobid, i_begda );

            j01Result_vt   = (Vector)ret.get(0);
            j01Result_P_vt = (Vector)ret.get(1);
            j01Result_D_vt = (Vector)ret.get(2);

//          Job Unit별 KSEA, Job Process Image FileName
            req.setAttribute("j01Result_vt",   j01Result_vt);
//          Job Process일경우 Job Objectives와 Position
            req.setAttribute("j01Result_P_vt", j01Result_P_vt);
            req.setAttribute("j01Result_D_vt", j01Result_D_vt);
//          Objective ID, Job ID
            req.setAttribute("i_objid",        i_objid);
            req.setAttribute("i_sobid",        i_sobid);
            req.setAttribute("i_pernr",        i_pernr);
            req.setAttribute("i_link_chk",     i_link_chk);            
            req.setAttribute("i_imgidx",       i_idx);
            req.setAttribute("i_begda",        i_begda);
            req.setAttribute("page",           page );
                        
            dest = WebUtil.JspURL+"J/J01JobMatrix/J01ImageFileName.jsp";
            Logger.debug.println(this, " destributed = " + dest + "  page : "+ page);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
