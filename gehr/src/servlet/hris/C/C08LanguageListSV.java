package servlet.hris.C;

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
import hris.C.C07Language.*;
import hris.C.rfc.*;

/**
 * C08LanguageListSV.java
 * 어학지원비 리스트를 조회 및 상세 조회 하는 Class
 *
 * @author  김도신   
 * @version 1.0, 2003/04/15
 */
public class C08LanguageListSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest  = "";
            String page  = "";      //paging 처리
            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc

            page  = box.get("page");
            if( page.equals("") || page == null ){
                page = "1";
            }

            Vector c07LanguageData_vt = ( new C08LanguageListRFC() ).getLangList( user.empNo );

            ///////////  SORT    /////////////
            sortField = box.get( "sortField" );
            sortValue = box.get( "sortValue" );
            if( sortField.equals("") || sortField == null) {
                sortField = "BEGDA,POST_DATE"; //신청일, 최종결재일
            }
            if( sortValue.equals("") || sortValue == null) {
                sortValue = "desc,desc";       //정렬방법
            }
            
            if( sortField.equals("SETL_WONX") || sortField.equals("CMPY_WONX") ) {
                c07LanguageData_vt = SortUtil.sort_num( c07LanguageData_vt, sortField, sortValue ); // Number
            } else {
                c07LanguageData_vt = SortUtil.sort( c07LanguageData_vt, sortField, sortValue );     // String
            }
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            ///////////  SORT    /////////////

            req.setAttribute( "page", page );
            req.setAttribute( "c07LanguageData_vt", c07LanguageData_vt );

            dest = WebUtil.JspURL+"C/C08LanguageList.jsp";
            Logger.debug.println(this, " destributed = " + dest + "  page : "+ page);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}