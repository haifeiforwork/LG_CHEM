package servlet.hris.E.E28General;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;
import hris.E.E28General.*;
import hris.E.E28General.rfc.*;

/**
 * E28GeneralCancerListSV.java
 * 7종암검진 실시 내역을 넘겨주는 class
 * @author lsa C20130805_81825
 * @version 1.0, 2013/08/05
 */

public class E28GeneralCancerListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest   = "";
            String page   = "";    //paging 처리
            page  = box.get("page","1");

            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            E28GeneralCancerListRFC func = new E28GeneralCancerListRFC();
            Vector E28GeneralCancerData_vt = func.getGeneralList(user.empNo);

            E28GeneralCancerData_vt = SortUtil.sort( E28GeneralCancerData_vt , "REAL_DATE,GUEN_CODE", "desc,asc");
            req.setAttribute("E28GeneralCancerData_vt", E28GeneralCancerData_vt);
            req.setAttribute("page", page);
            dest = WebUtil.JspURL+"E/E28GeneralCancer/E28GeneralCancerList.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            Logger.debug.println(this, E28GeneralCancerData_vt.toString());
//            }

            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
