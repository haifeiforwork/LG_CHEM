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
 * E28GeneralListSV.java
 * 종합검진 실시 내역을 넘겨주는 class 
 * @author 박영락
 * @version 1.0, 2002/01/31
 */

public class E28GeneralListSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest   = "";
            String page   = "";    //paging 처리
            page  = box.get("page");
            if( page == null || page.equals("") ){ //페이지 설정
                page = "1";
            }

          //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            E28GeneralListRFC func = new E28GeneralListRFC();
            Vector E28GeneralData_vt = func.getGeneralList(user.empNo);

/*            if( E28GeneralData_vt.size() == 0 ) {
                Logger.debug.println(this, "Data Not Found");
                String msg = "msg004";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
            } else {          */
            E28GeneralData_vt = SortUtil.sort( E28GeneralData_vt , "REAL_DATE,GUEN_CODE", "desc,asc");
            req.setAttribute("E28GeneralData_vt", E28GeneralData_vt);
            req.setAttribute("page", page);
            dest = WebUtil.JspURL+"E/E28GeneralList.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            Logger.debug.println(this, E28GeneralData_vt.toString());
//            }

            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
