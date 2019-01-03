/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ����                                                        */
/*   Program Name : ���½�������                                                */
/*   Program ID   : D02ConductListSV_m                                          */
/*   Description  : ���� ������ ��ȸ�� �� �ֵ��� �ϴ� Class                     */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  �Ѽ���                                          */
/*   Update       : 2005-01-21  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D ;

import hris.common.WebUserData;

import javax.servlet.http.* ;
import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

public class D00TimeFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

    	 try{
    	        WebUserData user = WebUtil.getSessionUser(req);
         		String sMenuCode       = WebUtil.nvl(req.getParameter("sMenuCode"));
         		String year       = WebUtil.nvl(req.getParameter("year"));
         		String month       = WebUtil.nvl(req.getParameter("month"));
        	    req.setAttribute("sMenuCode", sMenuCode);
        	    req.setAttribute("year", year);
        	    req.setAttribute("month", month);
    	        Box box = WebUtil.getBox(req);
    	        String tabid = box.get("tabid");
    	        req.setAttribute("tabid", tabid);
            	printJspPage(req, res, WebUtil.JspURL + "D/D00TimeFrame.jsp");
         } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
