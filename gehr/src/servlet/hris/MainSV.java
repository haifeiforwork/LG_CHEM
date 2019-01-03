/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  :                                                */
/*   2Depth Name  :                                                 */
/*   Program Name :                                      */
/*   Program ID   : MailAutoLoginSV.java                                    */
/*   Description  :                          */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
/********************************************************************************/
package servlet.hris;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.WebUtil;
import hris.N.WebAccessLog;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MainSV extends ExternalViewSV
{

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            performTask(req, res);
        }catch(GeneralException e){
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            process(req, res, false);

            WebUserData user = WebUtil.getSessionUser(req);
            try {
                (new WebAccessLog()).setAccessLog("MAIN", user.empNo, user.empNo, user.remoteIP);
                (new WebAccessLog()).setRoleCheckLog(user.empNo, user.e_authorization);
            } catch(Exception e) {
                Logger.error(e);
            }

            printJspPage(req, res, WebUtil.JspURL + "main.jsp");
        } catch(Exception e){
            throw new GeneralException(e);
        }// end try
    }
}