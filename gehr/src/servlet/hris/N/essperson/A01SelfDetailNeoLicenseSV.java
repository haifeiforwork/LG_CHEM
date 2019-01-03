package servlet.hris.N.essperson;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.rfc.A01SelfDetailLicenseRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A01SelfDetailNeoLicenseSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        //Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            /* 자격 사항 조회 */
            A01SelfDetailLicenseRFC licenseRFC = new A01SelfDetailLicenseRFC();
            req.setAttribute("resultList",  licenseRFC.getLicenseList(user.empNo, user.area.getMolga(), ""));

            printJspPage(req, res, WebUtil.JspURL+"N/essperson/A01SelfDetailNeoLicense.jsp");
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
	}

}