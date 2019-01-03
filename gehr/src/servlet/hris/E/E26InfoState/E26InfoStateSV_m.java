/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �����ְ�����Ȳ                                              */
/*   Program Name : �����ְ�����Ȳ                                              */
/*   Program ID   : E26InfoStateSV_m                                            */
/*   Description  : ������ ������ �����ֿ� ���� ������ ��ȸ�ϴ� Class           */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  ������                                          */
/*   Update       : 2005-01-25  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E26InfoState;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.E.E26InfoState.rfc.*;


public class E26InfoStateSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

        try{
            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String dest  = "";
            String jobid_m = "";

            WebUserData user = WebUtil.getSessionUser(req);
//          @����༺ �߰�
            /*if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }*/

            if(!checkAuthorization(req, res)) return;

            Box box = WebUtil.getBox(req);
            jobid_m = box.get("jobid_m", "first");

            /*if( jobid_m.equals("") ){
                jobid_m = "first";
            }*/

            if( jobid_m.equals("first") ) {

                Vector E26InfofirstData_vt = new Vector();

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    E26InfofirstData_vt = (new E26InfoFirstRFC()).getInfoFirst(user_m.empNo);
                } // if ( user_m != null ) end

                Logger.debug.println(this,"E26InfofirstData_vt" + E26InfofirstData_vt.toString());

                req.setAttribute("E26InfofirstData_vt", E26InfofirstData_vt);
                dest = WebUtil.JspURL+"E/E26InfoState/E26InfoState_m.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }
}
