package	servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet_m;
import com.sns.jdf.util.WebUtil;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * A04FamilyDetailSV_m.java
 * 가족사항 정보를 jsp로 넘겨주는 class 
 * 가족사항 정보를 가져오는 FamilyDetailRFC를 호출하여 FamilyDetail_m.jsp로 가족사항 정보를 넘겨준다.
 *
 * @author 김도신   
 * @version 1.0, 2001/12/17
 */
public class A04FamilyDetailSV_m extends EHRBaseServlet_m {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = "";
            String dest = "";
            
//          @웹취약성 추가
            if(!checkAuthorization(req, res)) return;

            A04FamilyDetailRFC func1                  = new A04FamilyDetailRFC();
            box.put("I_PERNR", user_m.empNo);
            Vector             a04FamilyDetailData_vt = func1.getFamilyDetail(box) ;
            
            Logger.debug.println(this, "a04FamilyDetailData_vt : "+ a04FamilyDetailData_vt.toString());
                
            req.setAttribute("a04FamilyDetailData_vt", a04FamilyDetailData_vt);
            dest = WebUtil.JspURL+"A/A04FamilyDetail_m.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
            
        } catch(Exception e) {
            throw new GeneralException(e);
        } 
    }
}