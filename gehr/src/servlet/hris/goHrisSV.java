package servlet.hris;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.http.HttpSession;
import java.lang.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.*;

/**
 * goHrisSV.java
 *  개인평가시스템으로 연결 할 수 있도록 하는 Class
 *
 * @author 윤정현
 * @version 1.0, 2004/11/04
 */
public class goHrisSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

			Box box = WebUtil.getBox(req);
            box.copyToEntity(user);
            String dest  = "";

			String p_empl_numb = DataUtil.fixEndZero(user.empNo,8);
			p_empl_numb = DataUtil.encodeEmpNo(p_empl_numb);

            req.setAttribute("p_empl_numb",   p_empl_numb);
            req.setAttribute("address", "http://eloffice.lgchem.com:3004/hris/owa/hripa000");

            dest = WebUtil.JspURL+"viewHidden.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        }catch(Exception e){
            throw new GeneralException(e);
        }
    }
}