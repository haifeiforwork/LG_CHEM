package servlet.hris.A.A13Address;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import hris.common.rfc.ZipcodeCheckRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * A13AddressAjax.java
 * USA ZipCode 유효성을 체크하는 Class
 *
 * @author jungin
 * @version 1.0, 2010/10/05
 */
public class A13AddressAjax extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {		
			String LAND1 = req.getParameter("LAND1");
			String STATE = req.getParameter("STATE");
			String PSTLZ = req.getParameter("PSTLZ");
			
			//Logger.debug.println(this, "#####	LAND1	:	[" + LAND1 + "]");
			//Logger.debug.println(this, "#####	STATE	:	[" + STATE + "]");
			//Logger.debug.println(this, "#####	PSTLZ	:	[" + PSTLZ + "]");
	
			ZipcodeCheckRFC rfc = new ZipcodeCheckRFC();
			Vector zipcode = rfc.getZipcodeCheck(LAND1, STATE, PSTLZ);
			
			String dest = "";
			
		    String E_RETURN = "";
		    String E_MESSAGE = "";
		    
			E_RETURN = zipcode.get(0).toString();
			E_MESSAGE = zipcode.get(1).toString();
			
			//Logger.debug.println(this, "#####	E_RETURN	:	[" + E_RETURN + "]");
			//Logger.debug.println(this, "#####	E_MESSAGE	:	[" + E_MESSAGE + "]");
	        
	    	req.setAttribute("E_RETURN", E_RETURN);
	    	req.setAttribute("E_MESSAGE", E_MESSAGE);
	    	
			if (E_RETURN.equals("E")) {
				
				String msg = E_MESSAGE;
				
				Logger.debug.println(this, "#####	msg	:	[" + msg + "]");
				
				req.setAttribute("msg", msg);
				res.getWriter().print(msg);
			}
	
        } catch( Exception e ) {
            throw new GeneralException(e);
		}
	}
	
}
