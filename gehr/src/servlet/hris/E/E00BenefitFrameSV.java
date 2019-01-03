package servlet.hris.E ;

import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import servlet.hris.D.D00ConductFrameSV;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

/**
 *  E00BenefitFrameSV.java
 *  복리후생(MSS) TAB
 *
 * @author 한성덕
 * @version 1.0, 2002/02/16
 */
public class E00BenefitFrameSV extends D00ConductFrameSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        WebUserData user = WebUtil.getSessionUser(req);
        Box box = WebUtil.getBox(req);
        String RequestPageName = box.get("RequestPageName");
        req.setAttribute("RequestPageName", RequestPageName);
        String tabid = box.get("tabid");
        req.setAttribute("tabid", tabid);

        if(process(req, res, user, "B03")) {
            printJspPage(req, res, WebUtil.JspURL + "E/E00BenefitFrame.jsp");
        }
    }
}