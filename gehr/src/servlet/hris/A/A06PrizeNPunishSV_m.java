/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 포상/징계                                                   */
/*   Program Name : 포상 및 징계내역 조회                                       */
/*   Program ID   : A06PrizeNPunishSV_m                                         */
/*   Description  : 포상 및 징계내역을 보여주는 class                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       : 20150210 이지은D [CSR ID:2703351] 징계 관련 추가 수정                                                            */
/*                      2016-03-15  //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)                                                        */
/********************************************************************************/

package servlet.hris.A;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A06PrizeNPunishSV_m extends A06PrizeNPunishSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        if(!checkAuthorization(req, res)) return;

        WebUserData user_m = WebUtil.getSessionMSSUser(req);
        WebUserData user = WebUtil.getSessionUser(req);

        B01ValuateDetailCheckRFC checkRFC =  new B01ValuateDetailCheckRFC();
        req.setAttribute("check_A02", checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A02", "M", user_m.area));

        if (process(req, res, user_m, "M"))
            printJspPage(req, res, WebUtil.JspURL + "A/A06PrizeNPunish_" + (user_m.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");
    }
}
