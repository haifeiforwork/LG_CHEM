/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ����/¡��                                                   */
/*   Program Name : ���� �� ¡�賻�� ��ȸ                                       */
/*   Program ID   : A06PrizeNPunishSV_m                                         */
/*   Description  : ���� �� ¡�賻���� �����ִ� class                           */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-07  ������                                          */
/*   Update       : 20150210 ������D [CSR ID:2703351] ¡�� ���� �߰� ����                                                            */
/*                      2016-03-15  //2016-03-08 [CSR ID:2995203] ������� ����(Total Compensation)                                                        */
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
