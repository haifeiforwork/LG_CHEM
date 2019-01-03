/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 7���ϰ����ǽó���                                            */
/*   Program Name : 7���ϰ����ǽó���                                            */
/*   Program ID   : E28GeneralCancerListSV_m                                          */
/*   Description  : 7���ϰ��� �ǽ� ������ �Ѱ��ִ� class                         */
/*   Note         :                                                             */
/*   Creation     : 2013-08-05  lsa                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E28General;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;
import hris.E.E28General.rfc.*;

/**
 * E28GeneralCancerListSV_m.java
 * 7���ϰ��� �ǽ� ������ �Ѱ��ִ� class
 * @author lsa C20130805_81825
 * @version 1.0, 2013/08/05
 */

public class E28GeneralCancerListSV_m extends EHRBaseServlet {

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
            if(page_m == null  || page_m.equals("")   ){ //������ ����
                page_m = "1";
            }

            E28GeneralCancerListRFC func = new E28GeneralCancerListRFC();
            Vector E28GeneralCancerData_vt = new Vector();

            if ( user_m != null ) {
                E28GeneralCancerData_vt = func.getGeneralList(user_m.empNo);
            } // if ( user_m != null ) end


            E28GeneralCancerData_vt = SortUtil.sort( E28GeneralCancerData_vt , "REAL_DATE,GUEN_CODE", "desc,asc");
            req.setAttribute("E28GeneralCancerData_vt", E28GeneralCancerData_vt);
            req.setAttribute("page_m", page_m);
            dest = WebUtil.JspURL+"E/E28GeneralCancer/E28GeneralCancerList_m.jsp";

            Logger.debug.println(this, "E28GeneralCancerData_vt="+E28GeneralCancerData_vt.toString());
            Logger.debug.println(this, " destributed = " + dest);

            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
