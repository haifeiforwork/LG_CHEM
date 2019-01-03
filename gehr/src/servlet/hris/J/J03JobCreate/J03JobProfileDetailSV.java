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
 * J03JobProfileDetailSV.java
 * Job Profile �󼼳��� ���� ��ȸ�Ѵ�. 
 *
 * @author  �赵��
 * @version 1.0, 2003/02/12
 */
public class J03JobProfileDetailSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession       session        = req.getSession(false);
            WebUserData       user           = (WebUserData)session.getAttribute("user");
            
            Box               box            = WebUtil.getBox(req);

            J01JobProfileRFC  rfc            = new J01JobProfileRFC();

            Vector            ret            = new Vector();
            Vector            j01Result_P_vt = new Vector();
            Vector            j01Result_D_vt = new Vector();
            String            E_STEXT_L      = "";

            String            jobid          = box.get("jobid");
            String            i_objid        = box.get("OBJID");              //Objective ID 
            String            i_sobid        = box.get("SOBID");              //Job ID       
            String            i_pernr        = box.get("PERNR");              //�����ȣ     
            String            i_link_chk     = box.get("i_link_chk");         //link ����
            String            i_idx          = box.get("IMGIDX");             //�޴� Index
            String            i_begda        = box.get("BEGDA");              //Job ������
						String            i_Create       = box.get("i_Create");         //����ȭ������ ��ȸ,����ȭ������ menu���� �����ϱ� ���ؼ�
            String            dest           = "";
            
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " i_begda : "+i_begda);
            
            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.
//              Job Profile ��ȸ
                ret            = rfc.getDetail( i_objid, i_sobid, "99991231" );
    
                j01Result_P_vt = (Vector)ret.get(0);
                j01Result_D_vt = (Vector)ret.get(1);
                E_STEXT_L      = (String)ret.get(3);            //Level Grade
    
//              Job Profile ����              
                req.setAttribute("j01Result_P_vt", j01Result_P_vt);
                req.setAttribute("j01Result_D_vt", j01Result_D_vt);
                req.setAttribute("E_STEXT_L",      E_STEXT_L);               //Leveling Grade
//              Objective ID, Job ID
                req.setAttribute("i_objid",        i_objid);
                req.setAttribute("i_sobid",        i_sobid);
                req.setAttribute("i_pernr",        i_pernr);
                req.setAttribute("i_link_chk",     i_link_chk);            
                req.setAttribute("i_imgidx",       i_idx);            
                req.setAttribute("i_begda",        i_begda);
    						req.setAttribute("i_Create",       i_Create);

                dest = WebUtil.JspURL+"J/J03JobCreate/J03JobProfileDetail.jsp";
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}