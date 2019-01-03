/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �ް���������                                                */
/*   Program Name : �ް���������                                                */
/*   Program ID   :D04VocationDetailDiretSV_m.java                                    */
/*   Description  : ������ �ް���Ȳ ������ �������� �б�����ִ� class                 */

/********************************************************************************/

package servlet.hris.D.D04Vocation;


import hris.common.WebUserData;

import javax.servlet.http.*;

import com.common.constant.Area;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

public class D04VocationDetailDiretSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
        	WebUserData user = WebUtil.getSessionUser(req);
        	if(g.getSapType().isLocal()) {
        		printJspPage(req, res, WebUtil.ServletURL + "hris.D.D04Vocation.D04VocationDetailSV_m");
        	}else {
        		printJspPage(req, res, WebUtil.ServletURL + "hris.D.D04Vocation.D04VocationDetailGlobalSV_m");
        	}
          } catch(Exception e) {
        	  throw new GeneralException(e);
        }
    }
}