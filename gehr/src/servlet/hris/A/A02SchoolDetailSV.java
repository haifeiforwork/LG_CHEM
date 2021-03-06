package	servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.rfc.A02SchoolDetailRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * A02SchoolDetailSV.java
 * 학력사항을 jsp로 넘겨주는 class 
 * session에서 사원번호를 받아서 학력사항을 가져오는 A02SchoolDetailRFC를 호출하여  A02SchoolDetail.jsp로 학력사항을 넘긴다.
 * @author 박영락
 * @version 1.0, 2001/12/13
 */

public class A02SchoolDetailSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";

            A02SchoolDetailRFC func = new A02SchoolDetailRFC();
            Vector A02SchoolData_vt = func.getSchoolDetail(user.empNo, user.area.getMolga(), "");

//            if( A02SchoolData_vt.size() == 0 ) {
//                Logger.debug.println(this, "Data Not Found");
//                String msg = "msg004";
//                //String url = "history.back();";
//                req.setAttribute("msg", msg);
//                //req.setAttribute("url", url);
//                dest = WebUtil.JspURL+"common/caution.jsp";
//            } else {
            req.setAttribute("A02SchoolData_vt", A02SchoolData_vt);
            dest = WebUtil.JspURL+"A/A02SchoolDetail.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            Logger.debug.println(this, A02SchoolData_vt.toString());
//            }

            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
