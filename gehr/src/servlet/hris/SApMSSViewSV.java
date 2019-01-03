/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ������ �α���                                                */
/*   Program Name : ������ �α���                                     */
/*   Program ID   : AdminLoginSV.java                                    */
/*   Description  : ������ �α���                           */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ����                       */
/*                :  2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
/********************************************************************************/

package servlet.hris;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.PersonalCardInterfaceData;
import hris.A.rfc.A01PersonalCardInterfaceRFC;
import org.apache.commons.lang.StringUtils;
import servlet.hris.N.mssperson.A01SelfDetailNeoSV_m;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * SAP ���� �λ��Ϻ� ��ȸ ���
 * URL : servlet.hris.SApMSSViewSV?lang=����Ű(ko,en,zh)&sysid=(0:���� or 1:�ؿ� )&I_ECRKEY=��ȣȭŰ
 * -  0  : ���� ERP (e-HR ����)
 -  1  : �ؿ� ERP (e-HR  ����)
 -  2  : ���� HR
 */
public class SApMSSViewSV extends ExternalViewSV {

    public final static String SAP_INTERFACE = "SAP_INTERFACE";

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            performTask(req, res);
        }catch(GeneralException e){
           throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        //Connection conn = null;
        try{

            Box box = WebUtil.getBox(req);


            String I_ECRKEY = req.getParameter("I_ECRKEY");

            String sysid = req.getParameter("sysid");

            SAPType sapType = SAPType.LOCAL;
            if ("0".equals(sysid)) sapType = SAPType.LOCAL;
            else if ("1".equals(sysid)) sapType = SAPType.GLOBAL;

            A01PersonalCardInterfaceRFC personalCardInterfaceRFC = new A01PersonalCardInterfaceRFC(sapType);
            PersonalCardInterfaceData interfaceData = personalCardInterfaceRFC.getPersonalCardInterfaceData(I_ECRKEY);

            String pernr = interfaceData.getMain().getLOGPER();

            if(!personalCardInterfaceRFC.getReturn().isSuccess() || StringUtils.isBlank(pernr)) {
                req.setAttribute("msg2", personalCardInterfaceRFC.getReturn().MSGTX);
                moveMsgPage(req, res, "msg004", "top.close();");
                return;
            }

            req.getSession().setAttribute("SYSTEM_ID", pernr);

            /* �α��� ó�� */
            process(req, res, true);

            req.getSession().setAttribute(SAP_INTERFACE, interfaceData);  /* ���ǿ� ����Ÿ�� ���� - RFC �� ����Ÿ�� 1ȸ�� ��ȸ �Ǵ� ������ */

            Logger.debug("viewEmpno : " + box.get("viewEmpno"));

            /* ������� ù��° ����� �����´� */
            String viewEmpno = interfaceData.getFirstPersonData().getPERNR();

            /* ������� MSS ���� ���� */
            A01SelfDetailNeoSV_m a01SelfDetailNeoSV_m = new A01SelfDetailNeoSV_m();
            a01SelfDetailNeoSV_m.setUserSession(viewEmpno, req);

            String dest = WebUtil.JspURL + "common/printFrame_insa.jsp";

            redirect(res, dest);
            //printJspPage(req, res, dest);

        }catch(Exception e){
            throw new GeneralException(e);
        }// end try
    }

}