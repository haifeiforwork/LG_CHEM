/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청 조회                                        */
/*   Program ID   : A15CertiDetailSV                                            */
/*   Description  : 재직증명서 신청을 조회할 수 있도록 하는 Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-03-04  윤정현                                          */
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
