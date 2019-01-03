package servlet.hris.C.C10Education;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.C.C10Education.*;
import hris.C.C10Education.rfc.*;

/**
 * C10EducationCourseListSV.java
 * ���� ���� List ��ȸ �ϴ� Class
 *
 * @author  �赵��   
 * @version 1.0, 2004/05/27
 */
public class C10EducationCourseListSV extends EHRBaseServlet {
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest      = "";
            String page      = "";      //paging ó��
            String i_objid_L = "";      //����Ͻ� �̺�Ʈ �׷� ID
            String idx_Radio = "";

//          Page�� Interface �߰�
            idx_Radio = box.get("idx_Radio");         // ���� ��Ͽ��� ���õ� ����� ��ư

            page  = box.get("page");
            if( page.equals("") || page == null ){
                page = "1";
            }

            i_objid_L = box.get("OBJID_L");
            Vector c10CourseListData_vt = ( new C10EducationCourseListRFC() ).getList( i_objid_L );

            req.setAttribute("page",                 page);
            req.setAttribute("idx_Radio",            idx_Radio);
            req.setAttribute("i_objid_L",            i_objid_L);
            req.setAttribute("c10CourseListData_vt", c10CourseListData_vt);

            dest = WebUtil.JspURL+"C/C10Education/C10EducationCourseList.jsp";
            Logger.debug.println(this, " destributed = " + dest + "  page : "+ page);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}