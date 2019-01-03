/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 발령사항                                                    */
/*   Program Name : 발령사항                                                    */
/*   Program ID   : A05AppointDetailSV_m                                        */
/*   Description  : 발령사항 내역과 승급사항 내역을 조회                        */
/*   Note         : A05AppointDetail_m.jsp.delete                                      */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
package	servlet.hris.A ;

import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A05AppointDetailSV_m extends A05AppointDetailSV {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        if(!checkAuthorization(req, res)) return;

        if(process(req, res, WebUtil.getSessionMSSUser(req), "M", null))
            printJspPage(req, res, WebUtil.JspURL + "A/A05AppointDetail.jsp") ;


    }
}
