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
 * �����������׿� ���� �󼼳����� ��ȸ�Ͽ� A01SelfDetail.jsp ���� �Ѱ��ִ� class
 *
 * @author �輺��   
 * @version 1.0, 2001/12/17
 * A01SelfDetailNeoSV �̰� ������� �ش� JAVA�� �Ⱦ��µ�??? rdcamel(20171219)
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

            // A01SelfDetailRFC ������������ ��ȸ
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
                String imgUrl = func.getPhotoURL( user.empNo );//������ũ �߰�

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