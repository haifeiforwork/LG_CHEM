package servlet.hris.C;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.C.C03LearnDetailData;
import hris.C.rfc.C04HrdLearnDetailRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * A05AppointDetailSV.java
 * 사원의 교육 이력 사항을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2001/12/20
 */
public class C03LearnDetailHistoryPopSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            WebUserData user = WebUtil.getSessionMSSUser(req);

            Box box = WebUtil.getBox(req);

            //@웹취약성 추가
            if(!checkAuthorization(req, res)) return;

            if(user.area != Area.PL) {
                moveMsgPage(req, res, g.getMessage("MSG.COMMON.0060"), "window.close();");
            }

            C04HrdLearnDetailRFC func1 = new C04HrdLearnDetailRFC();
            Vector<C03LearnDetailData> resultList = func1.getTrainingList(user.empNo, box.get("I_BEGDA"), box.get("I_ENDDA"), "X", "");

            req.setAttribute("resultList", resultList);

            printJspPage(req, res, WebUtil.JspURL + "C/C03LearnDetailHistoryPop.jsp");

        } catch (Exception e) {
            throw new GeneralException(e);
        } finally {
        }

    }

}
