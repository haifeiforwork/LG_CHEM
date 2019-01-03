package servlet.hris.J.J03JobCreate;

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
 * J03FileUpDownLoadChangeSV.java
 * Eloffice Server�� Job Unit�� KSEA, Job Process PPT File�� UpLoad�Ѵ�. 
 *
 * @author  �赵��
 * @version 1.0, 2003/06/20
 */
public class J03FileUpDownLoadChangeSV extends EHRBaseServlet {
    
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
            
            String              e_match        = "";
            String              jobid          = box.get("jobid");
            String              i_objid        = box.get("OBJID");            // Objective ID
            String              i_sobid        = box.get("SOBID");            // Job ID
            String              i_pernr        = box.get("PERNR");            // �����ȣ
            String              i_idx          = box.get("IMGIDX");
            String              i_link_chk     = box.get("i_link_chk");           
            String              i_begda        = box.get("BEGDA");
            String              i_Create       = box.get("i_Create");         //����ȭ������ ��ȸ,����ȭ������ menu���� �����ϱ� ���ؼ�
            String              dest           = "";

            if( jobid.equals("") ){
                jobid = "first";
            } 
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

//          Objective ID, Job ID..
            req.setAttribute("i_objid",         i_objid);
            req.setAttribute("i_sobid",         i_sobid);
            req.setAttribute("i_pernr",         i_pernr);
            req.setAttribute("i_imgidx",        i_idx);
            req.setAttribute("i_link_chk",      i_link_chk);
            req.setAttribute("i_begda",         i_begda);
            req.setAttribute("i_Create",        i_Create);

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.
//              i_idx = '3'�̸� Job Unit�� KSEA, i_idx = '4'�̸� Job Process - R/3�� �����ڿ� �����ش�.
//              �̹��� ȭ�ϸ��� ��ȸ�Ѵ�.
                ret            = rfc.getDetail( i_idx, i_objid, i_sobid, "99991231" );

                j01Result_vt   = (Vector)ret.get(0);
                j01Result_P_vt = (Vector)ret.get(1);
                j01Result_D_vt = (Vector)ret.get(2);
                e_match        = (String)ret.get(3);

//              DownLoad�� PPTȭ�ϸ�
                req.setAttribute("j01Result_vt",   j01Result_vt);
//              Job Process�ϰ�� Job Objectives�� Position
                req.setAttribute("j01Result_P_vt", j01Result_P_vt);
                req.setAttribute("j01Result_D_vt", j01Result_D_vt);
                req.setAttribute("e_match", e_match);

                dest = WebUtil.JspURL+"J/J03JobCreate/J03FileUpDownLoadChange.jsp";
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
