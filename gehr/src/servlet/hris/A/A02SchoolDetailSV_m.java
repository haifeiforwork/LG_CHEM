package	servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet_m;
import com.sns.jdf.util.WebUtil;
import hris.A.rfc.A02SchoolDetailRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * A02SchoolDetailSV_m.java
 * �з»����� jsp�� �Ѱ��ִ� class 
 * session���� �����ȣ�� �޾Ƽ� �з»����� �������� A02SchoolDetailRFC�� ȣ���Ͽ�  A02SchoolDetail_m.jsp�� �з»����� �ѱ��.
 * @author �ڿ���
 * @version 1.0, 2001/12/13
 */

public class A02SchoolDetailSV_m extends EHRBaseServlet_m {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            
//          @����༺ �߰�
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            A02SchoolDetailRFC func = new A02SchoolDetailRFC();
            Vector A02SchoolData_vt = func.getSchoolDetail(user_m.empNo, user_m.area.getMolga(), "");

//            if( A02SchoolData_vt.size() == 0 ) {
//                Logger.debug.println(this, "Data Not Found");
//                String msg = "msg004";
//                //String url = "history.back();";
//                req.setAttribute("msg", msg);
//                //req.setAttribute("url", url);
//                dest = WebUtil.JspURL+"common/caution.jsp";
//            } else {
            req.setAttribute("A02SchoolData_vt", A02SchoolData_vt);
            dest = WebUtil.JspURL+"A/A02SchoolDetail_m.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            Logger.debug.println(this, A02SchoolData_vt.toString());
//            }

            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
