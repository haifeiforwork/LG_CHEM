/********************************************************************************/
/*                                                                              																*/
/*   System Name  : ESS                                                         														*/
/*   1Depth Name  : 휴가/근태                                                        															*/
/*   2Depth Name  : Flextime                                                        													*/
/*   Program Name : Flextime  상세                                                 															*/
/*   Program ID   : D20FlextimeFrameSV                                        													*/
/*   Description  : Flextime Frame Class                            												                */
/*   Note         :                                                             																*/
/*   Creation     : 2017-08-01  eunha    [CSR ID:3438118] flexible time 시스템 요청                                            */
/*   Update       :                                           																				*/
/********************************************************************************/

package servlet.hris.D.D20Flextime ;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D20FlextimeFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

    	 try{
             Box         box     = WebUtil.getBox( req ) ;

 	        String RequestPageName = box.get("RequestPageName");
 	        req.setAttribute("RequestPageName", RequestPageName);
         	printJspPage(req, res, WebUtil.JspURL + "D/D00FlextimeFrame.jsp");
         } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
