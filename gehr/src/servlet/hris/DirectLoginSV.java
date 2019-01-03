package servlet.hris;


import java.util.Enumeration;

import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

public class DirectLoginSV extends EHRBaseServlet {

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            performTask(req, res);
        }catch(GeneralException e){
           throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);
            if (session != null){ session.invalidate(); }

            String      dest = "";
         	
        //    Enumeration en = req.getAttributeNames();
            
        //    while (en.hasMoreElements()) {
        //    	String name = (String)en.nextElement();
        //    	String value = (String)req.getParameter(name);
            	
        //    	Logger.debug.println(this,name+" : "+value);
        //    }
            
            dest = WebUtil.JspURL+"newlogin.jsp";
            printJspPage(req, res, dest);
                        
        }catch(Exception e){
            throw new GeneralException(e);
        }		
    }
}