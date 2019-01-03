/*
 * �ۼ��� ��¥: 2005. 1. 28.
 *
 */
package servlet.hris;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.N.WebAccessLog;
import hris.common.WebUserData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LogSV extends EHRBaseServlet {

    /* (��Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException {
        try {
            WebUserData user = WebUtil.getSessionUser(req);
            WebUserData user_m = null;  // ess �� ��� �ڽ� ���

            if(StringUtils.indexOfIgnoreCase(user.webUserId, "admin") > -1 ||
                    StringUtils.indexOfIgnoreCase(user.webUserId, "emana") > -1) {
                return;
            }

            String sMenuCode = req.getParameter("sMenuCode");

            /* MSS �� ��� �Ǵ� Ư�� �޴��� ��� mss ������ �ִ´� */
            if(StringUtils.indexOf(sMenuCode, "MSS_PA") == 0) user_m = WebUtil.getSessionMSSUser(req);

            /* user_m �⺻���� user */
            if(user_m == null) user_m = user;

            (new WebAccessLog()).setAccessLog(sMenuCode, user.empNo, user_m.empNo, user.remoteIP);

        } catch(Exception e) {
            Logger.error(e);
        }
    }
}
