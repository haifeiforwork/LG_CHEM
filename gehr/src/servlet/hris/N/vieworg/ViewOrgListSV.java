package servlet.hris.N.vieworg;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

public class ViewOrgListSV   extends  EHRBaseServlet {

	
	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
            String orgCode = box.get("I_ORGEH");
            
            
        	/**
           	 * @$ ���������� marco257
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ 
           	 */
        	box.put("I_ORGEH", orgCode);
         	box.put("I_PERNR", user.empNo);
           	box.put("I_AUTHOR", "M");
           	box.put("I_GUBUN", "");
           	
            /*******************
             * ���α� �޴� �ڵ��
             *******************/
            String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));

			if(!checkBelongGroup(req, res, orgCode, "", "M")) {
				return;
			}

			EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
			String functionName = "ZGHR_RFC_ORGPER_PHOTO";

			//����� ����Ʈ
			box.put("I_ORGEH", orgCode);
			box.put("I_PERNR", user.empNo);
			box.put("I_AUTHOR", "M");

			HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"E_UPORG");

			Logger.debug("resultVT : >>>>>>>>>>>>>>>>>>>"+resultVT);
			req.setAttribute("resultVT", resultVT);
	            
	            
            printJspPage(req, res, WebUtil.JspURL+"N/vieworg/ViewOrgList.jsp");

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}
