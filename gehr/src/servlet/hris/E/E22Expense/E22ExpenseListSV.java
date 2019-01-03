package servlet.hris.E.E22Expense;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E22Expense.rfc.E22ExpenseListRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * E22ExpenseListSV.java
 * 을 할수 있도록 하는 Class
 *
 * @author 최영호
 * @version 1.0, 2002/01/04
 */
public class E22ExpenseListSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest  = "";

            String page  = "";      //paging 처리

            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc

            page  = box.get("page", "1");

          //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            Vector E22ExpenseListData_vt =  new E22ExpenseListRFC().getExpenseList( user.empNo );

            ///////////  SORT    /////////////
            sortField = box.get( "sortField", "BEGDA" );
            sortValue = box.get( "sortValue", "desc" );

            E22ExpenseListData_vt = SortUtil.sort( E22ExpenseListData_vt, sortField, sortValue ); //Vector Sort
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            ///////////  SORT    /////////////

            req.setAttribute( "page", page );
            Logger.debug.println(this, E22ExpenseListData_vt.toString());
            req.setAttribute( "E22ExpenseListData_vt", E22ExpenseListData_vt );

            dest = WebUtil.JspURL+"E/E22Expense/E22ExpenseList.jsp";

            Logger.debug.println(this, " destributed = " + dest + "  page : "+ page);
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}