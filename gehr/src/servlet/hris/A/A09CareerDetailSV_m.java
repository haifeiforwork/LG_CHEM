/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ��»���                                                    */
/*   Program Name : ��»��� ��ȸ                                               */
/*   Program ID   : A09CareerDetailSV_m                                         */
/*   Description  : �ٹ���� ������ jsp�� �Ѱ��ִ� class                        */
/*   Note         : ����                                                        */
/*   Creation     : 2001-12-19  �赵��                                          */
/*   Update       : 2005-01-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A09CareerDetailSV_m extends A09CareerDetailSV {

    public void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        if(!checkAuthorization(req, res)) return;

        if(process(req, res, WebUtil.getSessionMSSUser(req), "M"))
            printJspPage(req, res, WebUtil.JspURL + "A/A09CareerDetail.jsp") ;

    }
}