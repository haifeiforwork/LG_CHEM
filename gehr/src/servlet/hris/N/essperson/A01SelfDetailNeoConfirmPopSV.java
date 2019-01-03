package servlet.hris.N.essperson;

import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A01SelfDetailNeoConfirmPopSV extends A01SelfDetailNeoSV {

    /**
     * 개인 인사 정보 확인
     * @param req
     * @param res
     * @throws GeneralException
     */
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        WebUserData user = WebUtil.getSessionUser(req);

        req.setAttribute("pageType", "C");

        if(super.process(req, res, user, "E"))
            printJspPage(req, res, WebUtil.JspURL+"N/essperson/A01SelfDetailNeoConfirmPop.jsp");
	}

}