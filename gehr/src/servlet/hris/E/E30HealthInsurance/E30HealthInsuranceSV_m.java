/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 건강보험                                                    */
/*   Program Name : 건강보험                                                    */
/*   Program ID   : E30HealthInsuranceSV_m                                      */
/*   Description  : 건강보험 관련 정보를 jsp로 넘겨주는 class                   */
/*   Note         :                                                             */
/*   Creation     : 2003-02-19  김도신                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E30HealthInsurance;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.E.E30HealthInsurance.rfc.*;
import hris.common.WebUserData;


public class E30HealthInsuranceSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String jobid_m = "";
            String dest    = "";

            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            Box box = WebUtil.getBox(req);

            jobid_m = box.get("jobid_m");

            if( jobid_m.equals("") ){
                jobid_m = "first";
            }

            E30HealthInsuranceRFC rfc = new E30HealthInsuranceRFC();
            Vector ret            = new Vector();
            Vector e30Health01_vt = new Vector();
            Vector e30Health02_vt = new Vector();

            String E_MINUM = "";
            String E_MICNR = "";

            if(jobid_m.equals("first")) {

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    ret = rfc.getDetail( user_m.empNo );
                    e30Health01_vt = (Vector)ret.get(0);
                    e30Health02_vt = (Vector)ret.get(1);

                    E_MINUM = rfc.getE_MINUM( user_m.empNo );
                    E_MICNR = rfc.getE_MICNR( user_m.empNo );
                } // if ( user_m != null ) end

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            req.setAttribute("e30Health01_vt", e30Health01_vt);
            req.setAttribute("e30Health02_vt", e30Health02_vt);
            req.setAttribute("E_MINUM",        E_MINUM);
            req.setAttribute("E_MICNR",        E_MICNR);

            dest = WebUtil.JspURL+"E/E30HealthInsurance_m.jsp";
            printJspPage(req, res, dest);

            Logger.debug.println(this, " destributed = " + dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}