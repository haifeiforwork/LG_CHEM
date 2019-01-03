package servlet.hris;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.common.ChangePasswordResultData;
import hris.common.rfc.ChgPasswordRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ChangePasswordSV extends EHRBaseServlet {

    /* (비Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performPreTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException {
        try {

            Box box = WebUtil.getBox(req);

            ChgPasswordRFC rfc = new ChgPasswordRFC();
            ChangePasswordResultData result = rfc.chgPassword(StringUtils.upperCase(box.get("webUserId")), box.get("webUserPwd"), box.get("new_webUserPwd1"), box.get("new_webUserPwd2"));
            if("S".equals(result.MSGTY)) {
                moveMsgPage(req, res, "변경되었습니다.", "top.close();");
            } else {
                moveMsgPage(req, res, result.MSGTX, "history.back();");
            }

        } catch(Exception e) {
            Logger.error(e);
            moveMsgPage(req, res, "실패하였습니다.", "history.back();");
        }
        return;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

    }
}
