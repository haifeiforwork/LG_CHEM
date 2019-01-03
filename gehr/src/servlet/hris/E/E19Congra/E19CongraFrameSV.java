/********************************************************************************/
/*   System Name  : MSS                                                                                                              */
/*   1Depth Name  : Manaer's Desk                                                                                                 */
/*   2Depth Name  : 근태                                                        																	*/
/*   Program Name : 근태실적정보                                                																*/
/*   Program ID   : D02ConductListSV_m                                          													*/
/*   Description  : 근태 사항을 조회할 수 있도록 하는 Class                     													*/
/*   Note         :                                                             																*/
/*   Creation     : 2002-02-16  한성덕                                          																*/
/*   Update       : 2005-01-21  윤정현   																							*/
 /* 	                 2017-08-02  eunha [CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건                                   */
/********************************************************************************/

package servlet.hris.E.E19Congra ;

import javax.servlet.http.* ;
import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

public class E19CongraFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

    	 try{
    	        Box box = WebUtil.getBox(req);
    	        String RequestPageName = box.get("RequestPageName");
    	        req.setAttribute("RequestPageName", RequestPageName);
    	      //CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건 start
    	        String isFlower = box.get("isFlower","N");
    	        req.setAttribute("isFlower", isFlower);
    	      //CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건 end

    	        printJspPage(req, res, WebUtil.JspURL + "E/E19Congra/E19CongraFrame.jsp");
         } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
