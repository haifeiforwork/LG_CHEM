/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 교육이력                                                    */
/*   Program Name : 교육이력                                                    */
/*   Program ID   : C03LearnDetailSV_m                                          */
/*   Description  : 사원의 교육 이력 사항을 조회할 수 있도록 하는 Class         */
/*   Note         : 없음                                                        */
/*   Creation     : 2001-12-20  한성덕                                          */
/*   Update       : 2005-01-07  윤정현                                          */
/*                     2017-10-16  김은하  [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청                       */
/********************************************************************************/


package servlet.hris.C ;

import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;

public class C03LearnDetailSV_m extends C03LearnDetailSV {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            WebUserData user = WebUtil.getSessionMSSUser(req);

            //@웹취약성 추가
            if(!checkAuthorization(req, res)) return;
            if(process(req, res, user))
            	printJspPage(req, res, WebUtil.JspURL + "C/C03LearnDetail_m.jsp");

        } catch (Exception e) {
            throw new GeneralException(e);
        }

    }
}
