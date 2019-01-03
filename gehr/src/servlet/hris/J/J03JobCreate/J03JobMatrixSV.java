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
 * J03JobMatrixSV.java
 * Objective ID�� ���� �Ѱܹ޾Ƽ� JobMatrix�� ��ȸ�Ѵ�. << Job ���� >>
 *
 * @author  �赵��
 * @version 1.0, 2003/06/12
 */
public class J03JobMatrixSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession       session          = req.getSession(false);
            WebUserData       user             = (WebUserData)session.getAttribute("user");
            
            Box               box              = WebUtil.getBox(req);

            J01LevelListRFC   rfc_Level        = new J01LevelListRFC();
            J01JobMatrixRFC   rfc_Matrix       = new J01JobMatrixRFC();

//          Header Stext RFC ����
            J01HeaderStextRFC rfc_Stext        = new J01HeaderStextRFC();
            Vector            j01Stext_vt      = new Vector();

            Vector            ret              = new Vector();
            Vector            j01LevelList_vt  = new Vector();
            Vector            j01DgubunList_vt = new Vector();
            Vector            j01JobProfile_vt = new Vector();

            String            i_pernr          = box.get("i_pernr");
            String            i_sobid          = box.get("i_sobid");
            String            E_PER_INFO       = "";
            String            i_begda          = box.get("BEGDA");      //Job ������
            String            dest             = "";
            
//          Header Stext ��ȸ
            j01Stext_vt      = rfc_Stext.getDetail( i_sobid, "", i_pernr, "99991231" );

//          Level List ��ȸ(������)            
            j01LevelList_vt  = rfc_Level.getDetail( "99991231" );

//          JobMatrix ��ȸ
            ret              = rfc_Matrix.getDetail( i_pernr, i_sobid, "99991231" );

            j01JobProfile_vt = (Vector)ret.get(0);
            j01DgubunList_vt = (Vector)ret.get(1);
            E_PER_INFO       = (String)ret.get(2);

//          Job Matrix ����
            req.setAttribute("j01LevelList_vt",  j01LevelList_vt);
            req.setAttribute("j01DgubunList_vt", j01DgubunList_vt);
            req.setAttribute("j01JobProfile_vt", j01JobProfile_vt);
//          Header Stext ��ȸ
            req.setAttribute("j01Stext_vt",      j01Stext_vt);
//          ��� ����, ����
            req.setAttribute("E_PER_INFO",       E_PER_INFO);
//          �����ȣ, Objective ID
            req.setAttribute("i_sobid",          i_sobid);
            req.setAttribute("i_pernr",          i_pernr);
            req.setAttribute("i_begda",          i_begda);

            dest = WebUtil.JspURL+"J/J03JobCreate/J03JobMatrix.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
