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

package servlet.hris.A;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A15CertificateBuildSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        final WebUserData user = WebUtil.getSessionUser(req);

        if(user.area == Area.KR) {
            printJspPage(req, res, WebUtil.JspURL + "A/A15CertificateBuild.jsp");
        } else {
            printJspPage(req, res, WebUtil.ServletURL + "hris.A.A15Certi.A15CertiBuildSV");
        }


    }
}
