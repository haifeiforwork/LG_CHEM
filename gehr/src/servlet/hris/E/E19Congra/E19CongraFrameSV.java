/********************************************************************************/
/*   System Name  : MSS                                                                                                              */
/*   1Depth Name  : Manaer's Desk                                                                                                 */
/*   2Depth Name  : ����                                                        																	*/
/*   Program Name : ���½�������                                                																*/
/*   Program ID   : D02ConductListSV_m                                          													*/
/*   Description  : ���� ������ ��ȸ�� �� �ֵ��� �ϴ� Class                     													*/
/*   Note         :                                                             																*/
/*   Creation     : 2002-02-16  �Ѽ���                                          																*/
/*   Update       : 2005-01-21  ������   																							*/
 /* 	                 2017-08-02  eunha [CSR ID:3443440] ����ȭȯ ��û �޴� ������û�� ��                                   */
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
    	      //CSR ID:3443440] ����ȭȯ ��û �޴� ������û�� �� start
    	        String isFlower = box.get("isFlower","N");
    	        req.setAttribute("isFlower", isFlower);
    	      //CSR ID:3443440] ����ȭȯ ��û �޴� ������û�� �� end

    	        printJspPage(req, res, WebUtil.JspURL + "E/E19Congra/E19CongraFrame.jsp");
         } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
