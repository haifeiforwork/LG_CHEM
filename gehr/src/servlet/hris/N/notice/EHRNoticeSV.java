package servlet.hris.N.notice;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

public class EHRNoticeSV  extends  EHRBaseServlet {

	
	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
            String dest  = "";
          
            // 초기 팝업 여부 
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
            box.put("I_PERNR", user.empNo);
            box.put("I_DATUM", DataUtil.getCurrentDate());
            HashMap initPop_hm = comRFC.getReturnST(box, "ZGHR_RFC_GET_POPUP_LIST", "T");
            req.setAttribute("initPop_hm", initPop_hm);
            
            dest = WebUtil.JspURL+"N/notice/notice_p.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
	}
}