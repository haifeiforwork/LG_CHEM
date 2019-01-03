package servlet.hris.N.ehrFAQ;

import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.WebUserData;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class EHRfaqSV   extends  EHRBaseServlet {


	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

           	String I_BIZTY = box.get("I_BIZTY");
            String I_PAGE   =  WebUtil.nvl(box.get("page"));
            String I_SEARCH = WebUtil.nvl(box.get("I_SEARCH"));
        	String I_OBJID = box.get("I_OBJID");
        	if(I_PAGE.equals("")){
        		I_PAGE ="1";
        	}

//        	Logger.debug("I_BIZTY >> "+ I_BIZTY);
//        	Logger.debug("I_PAGE >> "+ I_PAGE);
//        	Logger.debug("I_SEARCH >> "+ I_SEARCH);
//        	Logger.debug("I_OBJID >> "+ I_OBJID);


        	box.put("I_BIZTY", I_BIZTY);
        	box.put("I_PAGE", I_PAGE);
        	box.put("I_PFLAG", "X");
        	box.put("I_SEARCH", I_SEARCH);
        	box.put("I_OBJID", I_OBJID);
            String mode = box.get("mode");

            //초기화값은 LIST
            if(mode.equals("")){
            	mode = "LIST";
            }

            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
            //String functionName = "ZHRC_RFC_GET_FAQ_LIST";
           	String functionName = "ZGHR_RFC_GET_FAQ_LIST";
            String dest = "";

            if(mode.equals("LIST")){

                 dest = WebUtil.JspURL+"N/ehrFAQ/faq_list.jsp";
            }else{
            	 dest = WebUtil.JspURL+"N/ehrFAQ/faq_view.jsp";
            }

          	HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"TOTCNT");
            req.setAttribute("resultVT", resultVT);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }

	}
}
