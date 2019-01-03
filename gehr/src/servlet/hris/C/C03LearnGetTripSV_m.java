/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� ��û                                             */
/*   Program Name : �������� ��û ��ȸ                                        */
/*   Program ID   : A15CertiDetailSV                                            */
/*   Description  : �������� ��û�� ��ȸ�� �� �ֵ��� �ϴ� Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �ڿ���                                          */
/*   Update       : 2005-03-04  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.C;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class C03LearnGetTripSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        printJspPage(req, res, WebUtil.JspURL + "C/C03LearnGetTrip_m.jsp");
    }
}
