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
 * 교육 과정 List 조회 하는 Class
 *
 * @author  김도신   
 * @version 1.0, 2004/05/27
 */
public class C10EducationCourseListSV extends EHRBaseServlet {
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest      = "";
            String page      = "";      //paging 처리
            String i_objid_L = "";      //비즈니스 이벤트 그룹 ID
            String idx_Radio = "";

//          Page별 Interface 추가
            idx_Radio = box.get("idx_Radio");         // 과정 목록에서 선택된 래디오 버튼

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