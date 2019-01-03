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
 * J03FileUpDownLoadDetailSV.java
 * Eloffice�� Job Unit�� KSEA, Job Process Image FileName�� ��ȸ�Ѵ�. 
 *
 * @author  �赵��
 * @version 1.0, 2003/06/26
 */
public class J03FileUpDownLoadDetailSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");
            
            Box                 box            = WebUtil.getBox(req);

            J01ImageFileNameRFC rfc            = new J01ImageFileNameRFC();

//          PPT�� ������ ��ϵǾ����� check�Ѵ�.
            Vector              ret_PPT        = new Vector();
            Vector              j01PPT_vt      = new Vector();
            String              i_PPT          = "";              //��ϵǾ��ִ°�� "Y"

            Vector              ret            = new Vector();
            Vector              j01Result_vt   = new Vector();
            Vector              j01Result_P_vt = new Vector();
            Vector              j01Result_D_vt = new Vector();

            String              jobid          = box.get("jobid");
            String              i_objid        = box.get("OBJID");
            String              i_sobid        = box.get("SOBID");
            String              i_pernr        = box.get("PERNR");
            String              i_link_chk     = box.get("i_link_chk");
            String              i_idx          = box.get("IMGIDX");
            String              i_begda        = box.get("BEGDA");
						String              i_Create       = box.get("i_Create");         //����ȭ������ ��ȸ,����ȭ������ menu���� �����ϱ� ���ؼ�
            String              dest           = "";
//          paging ó��
            String              page           = "";

//          i_ids = '3'�̸� Job Unit�� KSEA, i_ids = '4'�̸� Job Process - R/3�� �����ڿ� �����ش�.
//          - �̹���ȭ�� ��ȸ�� index���� 2�� ���ش�.
            String              i_gubun        = Integer.toString(Integer.parseInt(i_idx) - 2);

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " i_begda : "+i_begda);
            
            page  = box.get("page");
            if( page.equals("") || page == null ){
                page = "1";
            }

//          Objective ID, Job ID..
            req.setAttribute("i_objid",        i_objid);
            req.setAttribute("i_sobid",        i_sobid);
            req.setAttribute("i_pernr",        i_pernr);
            req.setAttribute("i_link_chk",     i_link_chk);            
            req.setAttribute("i_imgidx",       i_idx);
            req.setAttribute("i_begda",        i_begda);
						req.setAttribute("i_Create",       i_Create);
            req.setAttribute("page",           page );
            
            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.
//              i_gubun = '1'�̸� Job Unit�� KSEA, i_gubun = '2'�� Job Process
//              Job Unit�� KSEA, Job Process Image FileName ��ȸ
                ret            = rfc.getDetail( i_gubun, i_objid, i_sobid, i_begda );

                j01Result_vt   = (Vector)ret.get(0);
                j01Result_P_vt = (Vector)ret.get(1);
                j01Result_D_vt = (Vector)ret.get(2);

//              �̹��� ȭ���� ���°�쿡 PPT ������ ��ϵǾ������� ��ϵ��� �ʾ�����쿡 �޽����� �ٸ��� �����ֱ����ؼ�
                ret_PPT        = rfc.getDetail( i_idx, i_objid, i_sobid, i_begda );
Logger.debug.println(this, "##################### j01PPT_vt : " + j01PPT_vt);
                j01PPT_vt      = (Vector)ret_PPT.get(0);
Logger.debug.println(this, "##################### j01PPT_vt.size() : " + j01PPT_vt.size());
                if( j01PPT_vt.size() > 0 ) {
                    J01ImageFileNameData data = (J01ImageFileNameData)j01PPT_vt.get(0);
                    if( data.TASK_CODE.equals("00000000") ) {
                        i_PPT = "N";
                    } else {
                        i_PPT = "Y";
                    } 
                }
//              ---------------------------------------------------------------------------------------------------

//              Job Unit�� KSEA, Job Process Image FileName
                req.setAttribute("j01Result_vt",   j01Result_vt);
//              Job Process�ϰ�� Job Objectives�� Position
                req.setAttribute("j01Result_P_vt", j01Result_P_vt);
                req.setAttribute("j01Result_D_vt", j01Result_D_vt);

                req.setAttribute("i_PPT",          i_PPT);
                        
                dest = WebUtil.JspURL+"J/J03JobCreate/J03FileUpDownLoadDetail.jsp";
            }
            Logger.debug.println(this, " destributed = " + dest + "  page : "+ page);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
