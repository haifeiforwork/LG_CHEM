/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근태실적정보                                                */
/*   Program ID   : D02ConductListSV_m                                          */
/*   Description  : 근태 사항을 조회할 수 있도록 하는 Class                     */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  한성덕                                          */
/*   Update       : 2005-01-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D04Vocation ;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D04VocationFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

    	 try{
             Box         box     = WebUtil.getBox( req ) ;

 	        String RequestPageName = box.get("RequestPageName");
 	        req.setAttribute("RequestPageName", RequestPageName);
         	printJspPage(req, res, WebUtil.JspURL + "D/D00VocationFrame.jsp");
         } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
