package servlet.hris;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class LogoutSV extends EHRBaseServlet {

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            performTask(req, res);
        }catch(GeneralException e){
           throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            if (session != null){ session.invalidate(); }
                
            String url = "parent.location.href= '" +WebUtil.JspPath + "logout.jsp';";
            // req.setAttribute("msg", msg);
            req.setAttribute("url", url);
            printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
        }catch(Exception e){
            throw new GeneralException(e);
        }		
    }
}