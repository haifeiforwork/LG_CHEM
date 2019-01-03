package servlet.hris.N.essperson;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A01SelfDetailData;
import hris.A.rfc.A01SelfDetailRFC;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.D.D05Mpay.rfc.D05ScreenControlRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * A01SelfDetailNeoSV.java
 * �����������׿� ���� ������ ��ȸ�ؿ��� Class
 *
 * @author ������   
 * @version 1.0,  2018/05/25  rdcamel //[CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��    
 */

public class A01SelfDetailNeoSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        WebUserData user = WebUtil.getSessionUser(req);
        req.setAttribute("O_CHECK_FLAG", ( new D05ScreenControlRFC() ).getScreenCheckYn(WebUtil.getSessionUser(req).empNo));
        if("popup".equals(req.getParameter("jobid"))) {
            redirect(res, WebUtil.ServletURL + "hris.N.essperson.A01SelfDetailNeoConfirmPopSV");
            return;
        }

        if(process(req, res, user, "E"))
            printJspPage(req, res, WebUtil.JspURL+"N/essperson/A01SelfDetailNeo.jsp");
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
            String I_CFORM = (String) req.getAttribute("I_CFORM");
            //[CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
            //Vector<A01SelfDetailData> a01SelfDetailData_vt = selffunc.getPersInfo(user_m.empNo, user_m.area.getMolga(), I_CFORM);
            Vector<A01SelfDetailData> a01SelfDetailData_vt = selffunc.getPersInfoLong(user_m.empNo, user_m.area.getMolga(), I_CFORM);
            req.setAttribute("resultData", Utils.indexOf(a01SelfDetailData_vt, 0));

            //����üũ
            B01ValuateDetailCheckRFC checkRFC =  new B01ValuateDetailCheckRFC();
            req.setAttribute("check_A01", checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A01", pageType, user_m.area));
            req.setAttribute("check_A03", checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A03", pageType, user_m.area));

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);


            /* ���� �ҽ��� �� �� ���� �ҽ� �ּ� ó���� 2016-08-18 */
            /* if( jobid.equals("pop") ) {
                //�������� Detail ����Ʈ
                A08LicenseDetailAlloRFC func2                   = new A08LicenseDetailAlloRFC();
                Vector                  A08LicenseDetailAllo_vt = new Vector();
                Vector                  temp_vt                 = func2.getLicenseDetailAllo(user.empNo);

                for( int i = 0 ; i < temp_vt.size() ; i++ ) {
                    A08LicenseDetailAlloData data = (A08LicenseDetailAlloData)temp_vt.get(i);
                    if( data.LICN_CODE.equals(licn_code) ) {
                        A08LicenseDetailAllo_vt.addElement(data);
                    }
                }

                req.setAttribute("A08LicenseDetailAllo_vt", A08LicenseDetailAllo_vt);
                dest = WebUtil.JspURL+"A/A08LicensePop.jsp";
            //������ function�� ���� ȣ���Ѵ�.

             //[CSR ID:2953938] ���� �λ����� Ȯ�α�� ���� �� �ݿ��� ��
            }*/

            return true;
        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }



}