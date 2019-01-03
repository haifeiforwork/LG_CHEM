package servlet.hris.N.essperson;

import com.common.RFCReturnEntity;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.N.essperson.A01SelfDetailConfirmRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A01SelfDetailNeoConfirmSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            A01SelfDetailConfirmRFC confirmRfc = new A01SelfDetailConfirmRFC();
            RFCReturnEntity ret = confirmRfc.setInsaConfirmEnd(user.empNo);

            Logger.debug.println(this, "setInsaConfirmEnd : "+ ret.toString());
            //req.setAttribute("setInsaConfirmEnd", ret);
            //dest = WebUtil.JspURL+"N/essperson/A01SelfDetailNeoConfirmPop.jsp?jobid=popup";

            //msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
            moveMsgPage(req, res, ret.MSGTX, "this.close();");

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
	}



}