/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 장학자금/입학축하금지원내역                                 */
/*   Program Name : 장학자금/입학축하금지원내역                                 */
/*   Program ID   : E22ExpenseListSV                                          */
/*   Description  : 입학축하금/학자금/장학금 조회 하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  최영호                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                : 2007-10-08  zhouguangwen  global e-hr update        */
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
public class E22ExpenseListSV extends EHRBaseServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = -8212769500929901774L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			HttpSession session = req.getSession(false);

			WebUserData user = (WebUserData) session.getAttribute("user");

			Box box = WebUtil.getBox(req);

			String dest = "";

			String page = ""; // paging 처리

			String sortField = ""; // sortFieldName or sortFieldIndex
			String sortValue = ""; // sortValue ex) desc, asc

			page = box.get("page", "1");
			/*Logger.debug.println(this, "servlet Page : " + page);
			if (page.equals("") || page == null) {
				page = "1";
			}*/
			//Vector E22ExpenseListData_vt = (new E22ExpenseListRFC()).getExpenseList(user.empNo);

			E22ExpenseListRFC func1                    = null ;
            Vector             ret 						     = null ;
            Vector		      E22ExpenseListData_vt = null;

            func1                  = new E22ExpenseListRFC() ;
            ret = func1.getExpenseList( user.empNo ) ;

            String E_RETURN   = (String) Utils.indexOf(ret, 0);       //(String)ret.get(0);  // return code
            String  E_MESSAGE  = (String) Utils.indexOf(ret, 1);     //(String)ret.get(1); // return message
            E22ExpenseListData_vt = (Vector) Utils.indexOf(ret, 2); // (Vector)ret.get(2);

			// ///////// SORT /////////////
			sortField = box.get("sortField", "PDATE");
			sortValue = box.get("sortValue", "desc");
			/*if (sortField.equals("") || sortField == null) {
				sortField = "PDATE"; // 최종결재일
			}
			if (sortValue.equals("") || sortValue == null) {
				sortValue = "desc"; // 역순
			}*/
			E22ExpenseListData_vt = SortUtil.sort(E22ExpenseListData_vt, sortField, sortValue); // Vector Sort
			req.setAttribute("sortField", sortField);
			req.setAttribute("sortValue", sortValue);
			// ///////// SORT /////////////

			req.setAttribute("page", page);
			Logger.debug.println(this, E22ExpenseListData_vt.toString());
			req.setAttribute("E22ExpenseListData_vt", E22ExpenseListData_vt);

			dest = WebUtil.JspURL + "E/E22Expense/E22ExpenseList_Global.jsp";

			Logger.debug.println(this, " destributed = " + dest + " , page : " + page);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {

		}
	}
}