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
/*                      2016-03-15 //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)                                                        */
/********************************************************************************/

package servlet.hris.E.E22Expense;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.E.E22Expense.rfc.*;


public class E22ExpenseListSV_m extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);

            WebUserData user_m = WebUtil.getSessionMSSUser(req);
            Box box = WebUtil.getBox(req);

            String dest  = "";
            String page_m  = "";      //paging 처리

            String sortField = "";  //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc

            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            page_m  = box.get("page_m", "1");
            /*Logger.debug.println(this, "servlet Page : " + page_m);
            if( page_m.equals("")  ){
                page_m = "1";
            }*/

          //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            Vector E22ExpenseListData_vt = new Vector();

            if ( user_m != null ) {
                E22ExpenseListData_vt = ( new E22ExpenseListRFC() ).getExpenseList( user_m.empNo );
            } // if ( user_m != null ) end

            ///////////  SORT    /////////////
            sortField = box.get( "sortField", "BEGDA" );
            sortValue = box.get( "sortValue", "desc" );
            /*if( sortField.equals("") ) {
                sortField = "BEGDA"; //최종결재일
            }
            if( sortValue.equals("") ) {
                sortValue = "desc"; //역순
            }*/
            E22ExpenseListData_vt = SortUtil.sort( E22ExpenseListData_vt, sortField, sortValue ); //Vector Sort
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            ///////////  SORT    /////////////

            req.setAttribute( "page_m", page_m );
            Logger.debug.println(this, E22ExpenseListData_vt.toString());
            req.setAttribute( "E22ExpenseListData_vt", E22ExpenseListData_vt );

            dest = WebUtil.JspURL+"E/E22Expense/E22ExpenseList_m.jsp";

            Logger.debug.println(this, " destributed = " + dest + "  page_m : "+ page_m);
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
	}
}