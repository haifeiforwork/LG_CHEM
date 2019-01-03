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
 * J01LevelingSheetSV.java
 * Job Leveling Sheet�� ��ȸ�Ѵ�. 
 *
 * @author  �赵��
 * @version 1.0, 2003/05/13
 */
public class J01LevelingSheetSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");
            
            Box                 box            = WebUtil.getBox(req);

            J01LevelingSheetRFC rfc            = new J01LevelingSheetRFC();

            Vector              ret            = new Vector();
            Vector              j01Result_vt   = new Vector();
            Vector              j01Result_D_vt = new Vector();
            Vector              j01Result_L_vt = new Vector();
            String              E_LEVEL        = "";

            String              i_objid        = "";
            String              i_sobid        = "";
            String              i_pernr        = "";
            String              i_link_chk     = "";                        
            String              i_idx          = "";            
            String              i_begda        = "";
            String              dest           = "";
            
            i_objid    = box.get("OBJID");                // Objective ID
            i_sobid    = box.get("SOBID");                // Job ID
            i_pernr    = box.get("PERNR");                // �����ȣ
            i_link_chk = box.get("i_link_chk");           // link ���� 
            i_idx      = box.get("IMGIDX");               // �޴� Index
//          ��������(��ȸ������) �߰�
            i_begda    = box.get("BEGDA");

//          Leveling Sheet ��ȸ
            ret            = rfc.getDetail( i_objid, i_sobid, i_begda );

            j01Result_vt   = (Vector)ret.get(0);        // ��з�, �򰡿��, Level
            j01Result_D_vt = (Vector)ret.get(1);        // �����򰡿�� ����
            j01Result_L_vt = (Vector)ret.get(2);        // Leveling ��� List
            E_LEVEL        = (String)ret.get(3);        // Job Leveling ���

//          Job Leveling Sheet
            req.setAttribute("j01Result_vt",   j01Result_vt);
            req.setAttribute("j01Result_D_vt", j01Result_D_vt);
            req.setAttribute("j01Result_L_vt", j01Result_L_vt);
//          Job Leveling ���
            req.setAttribute("E_LEVEL",        E_LEVEL);
//          Objective ID, Job ID
            req.setAttribute("i_objid",        i_objid);
            req.setAttribute("i_sobid",        i_sobid);
            req.setAttribute("i_pernr",        i_pernr);
            req.setAttribute("i_link_chk",     i_link_chk);                        
            req.setAttribute("i_imgidx",       i_idx);
            req.setAttribute("i_begda",        i_begda);

            dest = WebUtil.JspURL+"J/J01JobMatrix/J01LevelingSheet.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}