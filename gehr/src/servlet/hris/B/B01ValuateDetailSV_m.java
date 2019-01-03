/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 사원평가                                                    */
/*   Program Name : 평가사항 조회                                               */
/*   Program ID   : B01ValuateDetailSV_m                                        */
/*   Description  : 사원의 평가 사항을 조회할 수 있도록 하는 Class              */
/*   Note         : 없음                                                        */
/*   Creation     : 2002-01-14  한성덕                                          */
/*   Update       : 2005-01-11  윤정현                                          */
/*                     2014/11/25 [CSR ID:2651528] 인사권한 추가 및 메뉴조회 기능 변경                                                        */
                        /*2015/02/10 이지은D [CSR ID:2703351] 징계 관련 추가 수정*/
/********************************************************************************/

package servlet.hris.B ;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class B01ValuateDetailSV_m extends B01ValuateDetailSV {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        if(!checkAuthorization(req, res)) return;

        WebUserData user_m = WebUtil.getSessionMSSUser(req);
        WebUserData user = WebUtil.getSessionUser(req);

        if(user_m.area == Area.KR) {
            B01ValuateDetailCheckRFC checkRFC = new B01ValuateDetailCheckRFC();
            String checkYn = checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A01", "M");//CSR ID:2703351 평가의 경우 A를 구분자로 줌.

/*      process 안에 */
            if (!"Y".equals(checkYn)) {
                //"해당 권한이 없습니다."
                moveCautionPage(req, res, g.getMessage("MSG.COMMON.0060"), "");  //return page ? -> 기존 평가 jsp에 권한 없다는 메세지 보여줌
                return;
            }
        }

        if(process(req, res, user_m, "M")) {
            printJspPage(req, res, WebUtil.JspURL + "B/B01ValuateDetail_" + req.getAttribute("evalSuffix") + ".jsp");
        }
    }
}
