package servlet.hris.D.D03Vocation;

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
import hris.D.D03Vocation.*;
import hris.D.D03Vocation.rfc.*;

/**
 * D03CongraListPopSV.java
 * 경조내역 리스트를 팝업에서 조회 하는 Class
 *
 * @author lsa   
 * @version 1.0, 2008/03/11 
 */
public class D03CongraListPopSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest  = "";
            String page  = "";      //paging 처리
            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc
            String PERNR;

            page  = box.get("page");
            if( page.equals("") || page == null ){
                page = "1";
            }

            PERNR =  getPERNR(box, user); //box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if            
            Vector D03CondolHolidaysData_dis = ( new D03CondolHolidaysRFC() ).getCongDisplay( PERNR ,"1",DataUtil.getCurrentDate(),"","");

            ///////////  SORT    /////////////
            sortField = box.get( "sortField" );
            sortValue = box.get( "sortValue" );
            if( sortField.equals("") || sortField == null) {
                sortField = "CONG_DATE"; //신청일
            }
            if( sortValue.equals("") || sortValue == null) {
                sortValue = "desc"; //정렬방법
            }
            
            D03CondolHolidaysData_dis = SortUtil.sort( D03CondolHolidaysData_dis, sortField, sortValue );     // String
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            ///////////  SORT    /////////////

            req.setAttribute( "page", page );
            req.setAttribute( "D03CondolHolidaysData_dis", D03CondolHolidaysData_dis );

            dest = WebUtil.JspURL+"D/D03Vocation/D03CongraListPop.jsp";

            Logger.debug.println(this, " destributed = " + dest + "  page : "+ page);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}