/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 경조금지원내역                                              */
/*   Program Name : 경조금지원내역                                              */
/*   Program ID   : E20ReportDetailSV_m                                         */
/*   Description  : 재해 피해 신고서 조회 하는 Class                            */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  박영락                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E20Congra;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.E.E20Congra.rfc.*;


public class E20ReportDetailSV_m extends EHRBaseServlet {

    //private String UPMU_TYPE ="12";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);
            String dest  = "";
            Box box = WebUtil.getBox(req);
            String CONG_DATE = box.get("CONG_DATE");
            
            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            Vector E20DisasterData_vt = new Vector();

            if ( user_m != null ) {
                Logger.debug.println( this, "[user_m] : " + user_m.toString() + " CONG_DATE " + CONG_DATE );
                E20DisasterData_vt = ( new E20DisaDisplayRFC() ).getDisaDisplay( user_m.empNo, CONG_DATE );
            } // if ( user_m != null ) end

            req.setAttribute( "E20DisasterData_vt", E20DisasterData_vt );
            dest = WebUtil.JspURL+"E/E20Congra/E20ReportDetail_m.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
    }
}
