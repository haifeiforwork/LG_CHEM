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
/*					   : 2018-03-09 cykim [CSR ID:3624548] e-HR ���հ��� ��ûȭ�� ��Ȱ��ȭ ��û�� ��  */
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

    		 //[CSR ID:3624548] e-HR ���հ��� ��ûȭ�� ��Ȱ��ȭ ��û�� �� start
    		 WebUserData user = WebUtil.getSessionUser(req);
    		 B01ValuateDetailCheckRFC checkRFC =  new B01ValuateDetailCheckRFC();
    		 req.setAttribute("check_B02", checkRFC.getValuateDetailCheck(user.empNo, user.empNo, "B02", "E",user.area));// ���հ����̿� ����üũ
    		 //[CSR ID:3624548] e-HR ���հ��� ��ûȭ�� ��Ȱ��ȭ ��û�� �� end
         	printJspPage(req, res, WebUtil.JspURL + "E/E28GeneralCancer/E28GeneralCancerFrame.jsp");
         } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
