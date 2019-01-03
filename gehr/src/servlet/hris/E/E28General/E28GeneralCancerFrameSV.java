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
/*					   : 2018-03-09 cykim [CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건  */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E28General ;

import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.common.WebUserData;

import javax.servlet.http.* ;

import servlet.hris.D.D00ConductFrameSV;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

public class E28GeneralCancerFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

    	 try{

    		 //[CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건 start
    		 WebUserData user = WebUtil.getSessionUser(req);
    		 B01ValuateDetailCheckRFC checkRFC =  new B01ValuateDetailCheckRFC();
    		 req.setAttribute("check_B02", checkRFC.getValuateDetailCheck(user.empNo, user.empNo, "B02", "E",user.area));// 종합검진이월 권한체크
    		 //[CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건 end
         	printJspPage(req, res, WebUtil.JspURL + "E/E28GeneralCancer/E28GeneralCancerFrame.jsp");
         } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
