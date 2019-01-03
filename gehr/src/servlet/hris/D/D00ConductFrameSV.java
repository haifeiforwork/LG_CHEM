/********************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : My HR                                                       */
/*   2Depth Name  : 휴가/근태                                                   */
/*   Program Name : 근태                                                        */
/*   Program ID   : D00ConductFrameSV.java                                      */
/*   Description  : 근태 사항을 조회할 수 있도록 하는 Class                     */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  한성덕                                          */
/*   Update       : 2005-01-21  윤정현                                          */
/*                : 2018-06-12  강동민 [WorkTime52 PJT]                         */
/*                : 2018-06-25  성환희 [WorkTime52] 실 근무시간 레포트 탭 권한처리 */
/*                : 2018-07-24  유정우 [WorkTime52] 보상휴가 발생내역 탭 추가   */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.D.D19Duty.rfc.D19DutyEntryRFC;
import hris.common.WebUserData;

@SuppressWarnings("serial")
public class D00ConductFrameSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        WebUserData user = WebUtil.getSessionUser(req);

        Logger.debug.println(this, "#####    user.companyCode        :    [ " + user.companyCode + " ]");

        if (!g.getSapType().isLocal()) {
            req.setAttribute("s_vt", Utils.indexOf(new D19DutyEntryRFC().getDutyEntry(getPERNR(WebUtil.getBox(req), user), DataUtil.getCurrentDate()), 1));
        }

        B01ValuateDetailCheckRFC rfc = new B01ValuateDetailCheckRFC();
        req.setAttribute("check_B01", rfc.getValuateDetailCheck(user.empNo, user.empNo, "B01", "E", user.area)); // 교육출장 권한체크
        req.setAttribute("check_B04", rfc.getValuateDetailCheck(user.empNo, user.empNo, "B04", "E", user.area)); // [WorkTime52] 개인 실근로 레포트 권한체크
        req.setAttribute("check_B05", rfc.getValuateDetailCheck(user.empNo, user.empNo, "B05", "E", user.area)); // [WorkTime52] 초과근로 사후신청 권한체크
        req.setAttribute("check_B06", rfc.getValuateDetailCheck(user.empNo, user.empNo, "B06", "E", user.area)); // [WorkTime52] 보상휴가 발생내역 권한체크

        printJspPage(req, res, WebUtil.JspURL + "D/D00ConductFrame.jsp");
    }

    protected boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user, String pageType) throws GeneralException {

        try {
            B01ValuateDetailCheckRFC checkRFC = new B01ValuateDetailCheckRFC();

            if ("B01".equals(pageType)) {
                req.setAttribute("check_B01", checkRFC.getValuateDetailCheck(user.empNo, user.empNo, "B01", "E", user.area)); // 교육출장 권한체크

            } else if ("B02".equals(pageType)) {
                req.setAttribute("check_B02", checkRFC.getValuateDetailCheck(user.empNo, user.empNo, "B02", "E", user.area)); // 종합검진이월 권한체크

            } else if ("B03".equals(pageType)) {
                req.setAttribute("check_B03", checkRFC.getValuateDetailCheck(user.empNo, user.empNo, "B03", "E", user.area)); // 의료비 권한체크
            }

            return true;

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}