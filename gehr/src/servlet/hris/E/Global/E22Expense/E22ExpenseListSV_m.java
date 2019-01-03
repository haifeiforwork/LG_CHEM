/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 장학자금/입학축하금지원내역                                 */
/*   Program Name : 장학자금/입학축하금지원내역                                 */
/*   Program ID   : E22ExpenseListSV_m                                          */
/*   Description  : 입학축하금/학자금/장학금 조회 하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  최영호                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                : 2007-10-08  zhouguangwen  global e-hr update           */
/********************************************************************************/

package servlet.hris.E.Global.E22Expense;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.Global.E22Expense.rfc.E22ExpenseListRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * E22ExpenseListSV.java 을 할수 있도록 하는 Class
 *
 * @author 최영호
 * @version 1.0, 2002/01/04
 */
public class E22ExpenseListSV_m extends EHRBaseServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = -7226897471977942738L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) 	throws GeneralException {
		try {
			HttpSession session = req.getSession(false);

			WebUserData user_m = (WebUserData) session.getAttribute("user_m");

			Box box = WebUtil.getBox(req);

			String dest = "";
			String page_m = ""; // paging 처리

			String sortField = ""; // sortFieldName or sortFieldIndex
			String sortValue = ""; // sortValue ex) desc, asc

			page_m = box.get( "page_m" ,"1") ;
			/*Logger.debug.println(this, "servlet Page : " + page_m);
			if (page_m.equals("") || page_m == null) {
				page_m = "1";
			}*/

			E22ExpenseListRFC func1        = new E22ExpenseListRFC() ;
			Vector ret 						     = new Vector();
			Vector E22ExpenseListData_vt = new Vector();

			if (user_m != null) {
				ret =func1.getExpenseList( user_m.empNo ) ;
				E22ExpenseListData_vt = (Vector) Utils.indexOf(ret, 2); // (Vector)ret.get(2);
			} // if ( user_m != null ) end

			// ///////// SORT /////////////
			sortField = box.get("sortField", "PDATE");
			sortValue = box.get("sortValue", "desc");
			/*if (sortField.equals("") || sortField == null) {
				sortField = "PDATE"; // 최종결재일
			}
			if (sortValue.equals("") || sortValue == null) {
				sortValue = "desc"; // 역순
			}*/
			E22ExpenseListData_vt = SortUtil.sort(E22ExpenseListData_vt, 	sortField, sortValue); // Vector Sort
			req.setAttribute("sortField", sortField);
			req.setAttribute("sortValue", sortValue);
			// ///////// SORT /////////////

			req.setAttribute("page_m", page_m);
			Logger.debug.println(this, E22ExpenseListData_vt.toString());
			req.setAttribute("E22ExpenseListData_vt", E22ExpenseListData_vt);

			dest = WebUtil.JspURL + "E/E22Expense/E22ExpenseList_Global_m.jsp";

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
}