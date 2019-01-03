package servlet.hris.N.common;

import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.WebUserData;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class CommonFAQListSV    extends  EHRBaseServlet {

	
	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
            
            String dest = box.get("returnUrl");
            
            String I_PAGE   =  WebUtil.nvl(box.get("page"));
        	String I_OBJID = box.get("I_OBJID"); 
        	if(I_PAGE.equals("")){
        		I_PAGE ="1";
        	}
        	
//        	Logger.debug("I_BIZTY >> "+ I_BIZTY);
//        	Logger.debug("I_PAGE >> "+ I_PAGE);
//        	Logger.debug("I_SEARCH >> "+ I_SEARCH);
//        	Logger.debug("I_OBJID >> "+ I_OBJID);
        	// I_CODE ='0002' : Green Letter
        	String I_CODE   =  WebUtil.nvl(box.get("I_CODE"));
        	
        	box.put("I_PERNR", user.empNo);
        	box.put("I_PAGE", I_PAGE);
        	box.put("I_PFLAG", "X");
        	box.put("I_CODE", I_CODE);
        	box.put("I_OBJID", I_OBJID);
        	box.put("I_DATUM",DataUtil.getCurrentDate());
            String mode = box.get("mode");
            
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
           	String functionName = "ZHRC_RFC_GET_BOARD_LIST";
            
          	HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"TOTCNT");   
            req.setAttribute("resultVT", resultVT);
            printJspPage(req, res, dest); 

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}
