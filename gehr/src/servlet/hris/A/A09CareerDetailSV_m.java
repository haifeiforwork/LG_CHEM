/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 경력사항                                                    */
/*   Program Name : 경력사항 조회                                               */
/*   Program ID   : A09CareerDetailSV_m                                         */
/*   Description  : 근무경력 정보를 jsp로 넘겨주는 class                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2001-12-19  김도신                                          */
/*   Update       : 2005-01-07  윤정현                                          */
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