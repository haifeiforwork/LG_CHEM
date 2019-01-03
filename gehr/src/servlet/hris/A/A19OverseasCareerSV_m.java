/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 해외경험                                                    */
/*   Program Name : 해외경험 조회                                               */
/*   Program ID   : A19OverseasCareerSV_m                                       */
/*   Description  : 해외경험 정보를 jsp로 넘겨주는 class                        */
/*   Note         : [관련 RFC] : ZHRA_RFC_TRIP_LIST                             */
/*   Creation     : 2005-01-10  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package	servlet.hris.A;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.A.rfc.*;
import hris.common.WebUserData;

public class A19OverseasCareerSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String jobid = "";
            String dest  = "";
            String E_RETURN  = "";
            String E_MESSAGE = "";
            
            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }
            
            A19OverseasCareerRFC func1 = null;
            Vector a19OverseasData_vt = new Vector();

            if ( user_m != null ) {
                func1      = new A19OverseasCareerRFC();
                Vector ret = func1.getOverseasDetail(user_m.empNo);


                E_RETURN  = (String)ret.get(0);
                E_MESSAGE = (String)ret.get(1);

                a19OverseasData_vt = (Vector)ret.get(2);
            }

            Logger.debug.println(this, "a19OverseasData_vt : "+ a19OverseasData_vt.toString());
            req.setAttribute("E_RETURN",           E_RETURN);
            req.setAttribute("E_MESSAGE",          E_MESSAGE);
            req.setAttribute("a19OverseasData_vt", a19OverseasData_vt);
            dest = WebUtil.JspURL+"A/A19OverseasDetail_m.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}