package servlet.hris.E.E28General ;

import java.io.* ;
import java.sql.* ;
import java.util.Vector ;
import javax.servlet.* ;
import javax.servlet.http.* ;

import servlet.hris.D.D00ConductFrameSV;

import com.sns.jdf.* ;
import com.sns.jdf.db.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.D.* ;
import hris.D.rfc.* ;

/**
 *  E28GeneralFrameSV.java
 *  종합검진(ESS) TAB
 *
 * @author 한성덕
 * @version 1.0, 2002/02/16
 */
public class E28GeneralFrameSV extends D00ConductFrameSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        WebUserData user = WebUtil.getSessionUser(req);
        Box box = WebUtil.getBox(req);
        String RequestPageName = box.get("RequestPageName");
        req.setAttribute("RequestPageName", RequestPageName);

        if(process(req, res, user, "B02")) {
            printJspPage(req, res, WebUtil.JspURL + "E/E28GeneralFrame.jsp");
        }
    }
}