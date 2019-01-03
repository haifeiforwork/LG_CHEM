/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ���հ����ǽó���                                            */
/*   Program Name : ���հ����ǽó���                                            */
/*   Program ID   : E28GeneralListSV_m                                          */
/*   Description  : ���հ��� �ǽ� ������ �Ѱ��ִ� class                         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-31  �ڿ���                                          */
/*   Update       : 2005-01-25  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E28General;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E28General.rfc.E28GeneralListRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * E28GeneralListSV_m.java
 * ���հ��� �ǽ� ������ �Ѱ��ִ� class
 * @author �ڿ���
 * @version 1.0, 2002/01/31
 *                      2016-03-15 //2016-03-08 [CSR ID:2995203] ������� ����(Total Compensation)
 */

public class E28GeneralListSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            Box box = WebUtil.getBox(req);

            String dest   = "";
            String page_m = "";    //paging ó��

            WebUserData user = WebUtil.getSessionUser(req);
//          @����༺ �߰�
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            page_m  = box.get("page");
            if( page_m.equals("")  ){ //������ ����
                page_m = "1";
            }

          //2016-03-08 [CSR ID:2995203] ������� ����(Total Compensation)
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);


            E28GeneralListRFC func = new E28GeneralListRFC();
            Vector E28GeneralData_vt = new Vector();

            if ( user_m != null ) {
                E28GeneralData_vt = func.getGeneralList(user_m.empNo);
            } // if ( user_m != null ) end


            E28GeneralData_vt = SortUtil.sort( E28GeneralData_vt , "REAL_DATE,GUEN_CODE", "desc,asc");
            req.setAttribute("E28GeneralData_vt", E28GeneralData_vt);
            req.setAttribute("page_m", page_m);
            dest = WebUtil.JspURL+"E/E28GeneralList_m.jsp";

            Logger.debug.println(this, "E28GeneralData_vt="+E28GeneralData_vt.toString());
            Logger.debug.println(this, " destributed = " + dest);

            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
