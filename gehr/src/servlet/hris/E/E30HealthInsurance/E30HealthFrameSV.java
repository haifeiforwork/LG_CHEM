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

package servlet.hris.E.E30HealthInsurance ;

import javax.servlet.http.* ;
import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

public class E30HealthFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

    	 try{
         	printJspPage(req, res, WebUtil.JspURL + "E/E30HealthFrame.jsp");
         } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
