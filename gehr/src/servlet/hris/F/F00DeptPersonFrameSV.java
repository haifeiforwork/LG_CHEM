/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �ο���Ȳ ������ ��ȭ��                                    */
/*   Program ID   : F00DeptDetailListSV                                         */
/*   Description  : �ο���Ȳ ������ ��ȭ�� ��ȸ�� ���� ������                 */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-07 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F;

import hris.A.A01SelfDetailData;
import hris.A.rfc.A01SelfDetailRFC;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class F00DeptPersonFrameSV extends EHRBaseServlet {
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        WebUserData user = WebUtil.getSessionUser(req);

        if(process(req, res, user, "E"))
            printJspPage(req, res, WebUtil.JspURL+"F/F00DeptPersonFrame.jsp");
	}

    /**
     * ESS, MSS ���� ���� ����
     * user_m �� �ش� �ϴ� ����Ÿ�� ���� �Ѵ�.
     * @param req
     * @param res
     * @param user_m   ��ȸ ����� ����
     * @param pageType "E" ESS, "M" MSS tab ���� üũ ��
     */
	protected boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType) throws GeneralException {
        try{

            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);
            String jobid = box.get("jobid", "HEAD");

            req.setAttribute("jobid", jobid);

            A01SelfDetailRFC selffunc = new A01SelfDetailRFC();
            Logger.debug("---- user_m : " + user_m);
            Vector<A01SelfDetailData> a01SelfDetailData_vt = selffunc.getPersInfo(user_m.empNo, user_m.area.getMolga(), "");
            req.setAttribute("resultData", Utils.indexOf(a01SelfDetailData_vt, 0));

            //����üũ
            B01ValuateDetailCheckRFC checkRFC =  new B01ValuateDetailCheckRFC();
            req.setAttribute("check_A01", checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A01", pageType, user_m.area));
            req.setAttribute("check_A03", checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A03", pageType, user_m.area));

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);

            return true;
        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}