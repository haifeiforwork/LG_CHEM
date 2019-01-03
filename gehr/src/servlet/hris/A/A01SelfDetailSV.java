package	servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.rfc.A01SelfDetailRFC;
import hris.common.WebUserData;
import hris.common.rfc.GetPhotoURLRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * A01SelfDetailSV.java
 * 개인인적사항에 대한 상세내용을 조회하여 A01SelfDetail.jsp 값을 넘겨주는 class
 *
 * @author 김성일   
 * @version 1.0, 2001/12/17
 * A01SelfDetailNeoSV 이거 사용하지 해당 JAVA는 안쓰는듯??? rdcamel(20171219)
 **/
public class A01SelfDetailSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);

            A01SelfDetailRFC  rfc                  = null;
            Vector            A01SelfDetailData_vt = null;

            // A01SelfDetailRFC 개인인적사항 조회
            rfc = new A01SelfDetailRFC();
            A01SelfDetailData_vt = rfc.getPersInfo(user.empNo, user.area.getMolga(), "");

            if ( A01SelfDetailData_vt.size() == 0 ) {
                Logger.debug.println(this, "Data Not Found");
                String msg = "msg004";
                //String url = "history.back();";
                req.setAttribute("msg", msg);
                //req.setAttribute("url", url);
                dest = WebUtil.JspURL+"common/caution.jsp";

            } else {
                GetPhotoURLRFC func = new GetPhotoURLRFC();
                String imgUrl = func.getPhotoURL( user.empNo );//사진링크 추가

                Logger.debug.println(this, "A01SelfDetailData_vt : "+ A01SelfDetailData_vt.toString());
                req.setAttribute("imgUrl", imgUrl);
                req.setAttribute("A01SelfDetailData_vt", A01SelfDetailData_vt);
                dest = WebUtil.JspURL+"A/A01SelfDetail.jsp";
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}