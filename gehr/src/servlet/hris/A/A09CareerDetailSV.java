package	servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.rfc.A09CareerDetailRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * A09CareerDetailSV.java
 * 근무경력 정보를 jsp로 넘겨주는 class
 * 근무경력 정보를 가져오는 CareerDetailRFC를 호출하여 CareerDetail.jsp로 가족사항 정보를 넘겨준다.
 *
 * @author 김도신
 * @version 1.0, 2001/12/19
 */
public class A09CareerDetailSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        if(process(req, res, WebUtil.getSessionUser(req), "E"))
            printJspPage(req, res, WebUtil.JspURL + "A/A09CareerDetail.jsp");
    }

    protected boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType) throws GeneralException {
        try {
            A09CareerDetailRFC func1 = new A09CareerDetailRFC();

            String I_CFORM = (String) req.getAttribute("I_CFORM");

            req.setAttribute("careerList", func1.getCareerDetail(user_m.empNo, I_CFORM));

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);

            return true;
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
