package servlet.hris.N.mssperson;

import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;
import servlet.hris.N.essperson.A01SelfDetailNeoExtraSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A01SelfDetailNeoExtraSV_m extends A01SelfDetailNeoExtraSV {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

	    if(!checkAuthorization(req, res)) return;

        if(process(req, res, WebUtil.getSessionMSSUser(req), "M"))
            printJspPage(req, res, WebUtil.JspURL+"N/essperson/A01SelfDetailNeoExtra.jsp");
	}

}