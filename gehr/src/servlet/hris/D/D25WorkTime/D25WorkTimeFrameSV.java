/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : �ް�/����
/*   Program Name : �ٹ� �ð� �Է�
/*   Program ID   : D25WorkTimeFrameSV.java
/*   Description  : �ٹ� �ð� �Է� frame JSP ��ûó�� class
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] ������
/*   Update       : 2018-06-04 rdcamel [CSR ID:3704184] �����ٷ��� ���� ���� ��� �߰� �� - Global HR Portal
/********************************************************************************/

package servlet.hris.D.D25WorkTime;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D25WorkTime.D25WorkTimeAgreeData;
import hris.D.D25WorkTime.rfc.D25WorkTimeAgreeChkRFC;
import hris.N.WebAccessLog;
import hris.common.WebUserData;
import hris.sys.SysAuthInput;

@SuppressWarnings({ "rawtypes", "serial" })
public class D25WorkTimeFrameSV extends EHRBaseServlet {

    private final String sMenuCode = "ESS_OFW_WORK_TIME";

    @Override
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        WebUserData user = WebUtil.getSessionUser(req);
        Map<String, Object> params = WebUtil.getBox(req).getHashMap();

        String jobid = ObjectUtils.toString(params.get("jobid"), "first");

        Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

        final String sPERNR = user.getEmpNo();                                                                 // �α��� ����� ���
        final String pPERNR = StringUtils.defaultIfEmpty(ObjectUtils.toString(params.get("P_PERNR")), sPERNR); // ��ȸ ��� ���

        if ("first".equals(jobid)) {
            // �ٹ� �Է� ��Ȳ ȭ�鿡�� MSSYN=Y parameter�� ���� MSS�� ó��
            boolean isMSS = params.containsKey("MSSYN") && "Y".equals(ObjectUtils.toString(params.get("MSSYN")));

	        if (isMSS) {
	            // �ٹ� �Է� ��Ȳ �޴� ���� ������ ������ ���� ó��
	            if (!isMenuAccessAutorizedUser(sPERNR, "MSS_OFW_WORK_TIME")) {
	                req.setAttribute("msg", g.getMessage("MSG.COMMON.0060")); // �ش� �������� ������ �����ϴ�.
	                req.setAttribute("url", "self.close()");

	                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
	                return;
	            }

	            String pORGEH = ObjectUtils.toString(params.get("P_ORGEH")); // �Ҽ� �ڵ�
	            String pRETIR = ObjectUtils.toString(params.get("P_RETIR")); // ������ ���� ����('X' : ����)

	            // M ������ ���ų� ��� data ��ȸ ������ ������ ���� ó��
	            if (!checkAuthorization(req, res) || !checkBelong(req, res, new SysAuthInput("4", null, pPERNR, pORGEH, null, pRETIR, null, "X"))) {
	                moveCautionPage(req, res, "msg015", ""); // �ش� �������� ������ �����ϴ�.
	                return;
	            }

	        } else {
	            // �繫���� �ƴ� ������� ��� ���� ó�� - �繫���� �޴� ���� ������ �ο���
	            if (!isMenuAccessAutorizedUser(pPERNR, sMenuCode)) {
	                req.setAttribute("msg", g.getMessage("MSG.D.D25.N0028")); // �繫�� �ٹ��ð� ���� �Է� ����ڰ� �ƴմϴ�.
	                req.setAttribute("url", "self.close()");

	                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
	                return;
	            }

	        }

	        // �ٹ��ð��Է� ��ȸ���/������� ��ȸ RFC => D25WorkTimeFrame.jsp onload event���� ��ȸ��� ������ �ش� ����� �Էµ� �ٹ��ð� ������ ��ȸ�ϰ� ��ȸ�� ������ tab iframe ���ο��� �����Ѵ�.
	        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_MONTH", new HashMap<String, Object>() {
	            {
	                put("I_PERNR", pPERNR);
	                put("I_DATUM", DataUtil.getCurrentDate());
	            }
	        });

	        if (!RfcDataHandler.isSuccess(rfcResultData)) {
	            String msg = RfcDataHandler.getMessage(rfcResultData);
	            req.setAttribute("msg", StringUtils.isBlank(msg) ? g.getMessage("MSG.D.D25.N0001") : msg); // �޷� ������ ��ȸ���� ���߽��ϴ�.
	            req.setAttribute("url", "top.window.close()");

	            printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
	            return;
	        }

	        Map<String, Object> exportData = (Map<String, Object>) rfcResultData.get("EXPORT");

	        WebUtil.setAttributes(req, exportData);

	        // ��ȸ��� �и� 
	        String yyyyMM = (String) exportData.get("E_YYMON");
	        req.setAttribute("yyyy", yyyyMM.substring(0, 4));
	        req.setAttribute("MM", yyyyMM.substring(4));

	        // ������п� ���� ��� title ����
	        req.setAttribute("title", "C".equals(ObjectUtils.toString(exportData.get("E_TPGUB"))) ? g.getMessage("LABEL.D.D25.N1002") : g.getMessage("LABEL.D.D25.N1001"));
	//        req.getSession().setAttribute("MSSYN", "Y"); // MSS �׽�Ʈ�� �� ���θ� �ּ� ����

	        // [CSR ID:3704184] �λ����� ���� ����
	        String popCheck = "";
	        if (pPERNR.equals(sPERNR)) {
	        	popCheck = "N";//���� �� ȭ�� ��ȸ �ÿ��� �ȳ�������
		        D25WorkTimeAgreeChkRFC agreeRfc = new D25WorkTimeAgreeChkRFC();
		        D25WorkTimeAgreeData d25WorkTimeAgreeData = new D25WorkTimeAgreeData();
		        Vector d25WorkTimeAgreeData_vt = new Vector();
		        Vector agreeRst = agreeRfc.getAgreeFlag( yyyyMM.substring(0, 4), pPERNR);

		        if(agreeRst.get(0).equals("S")){//���� �Ϸ�
		        	d25WorkTimeAgreeData_vt = (Vector)agreeRst.get(2);
		        	d25WorkTimeAgreeData = (D25WorkTimeAgreeData)d25WorkTimeAgreeData_vt.get(0);
		        	popCheck = d25WorkTimeAgreeData.AGRE_FLAG;//Y�� ��
		        }
		        req.setAttribute("popCheck", popCheck);
		      }
		      //[CSR ID:3704184] �λ����� ���� ��

	        if (isMSS) {
	            req.getSession().setAttribute("MSSYN", "Y");

	            /*
	             * ���α� �߰� 2015-06-19
	             * EADMIN�� EMANAG�� �����ϴ� ����� ����(������, ���, �����ڴ� ����)
	             * MSS �μ����������� ��ȸ�ϴ� �޴��� ��� �߰���.
	             */
	            if (!user.user_group.equals("01") && !user.user_group.equals("02") && !user.user_group.equals("03")) {
	                new WebAccessLog().setAccessLog(sMenuCode, sPERNR, pPERNR, user.remoteIP);
	            }
	        } else {
	            req.getSession().removeAttribute("MSSYN");
	        }

	        req.setAttribute("EdgeMode", "Y");
	        printJspPage(req, res, WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeFrame.jsp");

        } else if ("save".equals(jobid)) { // [CSR ID:3704184] �λ����� ����
            try {
                D25WorkTimeAgreeChkRFC agreeRfc = new D25WorkTimeAgreeChkRFC();
                Vector agreeRst = agreeRfc.setAgreeFlag(pPERNR);
                String msg = agreeRst.get(0) + "";
                res.getWriter().print(msg);
            } catch (Exception e) {
                Logger.error(e);
                throw new GeneralException(e);
            }
			return;
	        // [CSR ID:3704184] �λ����� ���� ��
        }
    }

    /**
     * G-Portal�� ���� ������ ������� �繫���� �ƴ� ������� ��� ����� �ƴ��� �˸��� â�� �ݴ´�.
     * 
     * @param PERNR �α��� ���
     * @return
     * @throws GeneralException
     */
    private boolean isMenuAccessAutorizedUser(final String PERNR, final String menuCode) throws GeneralException {

        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_AUTH_CHECK_MENU", new HashMap<String, Object>() {
            {
                put("I_DATUM", DataUtil.getCurrentDate());
                put("I_PERNR", PERNR);
                put("I_MENU",  menuCode);
            }
        });

        if (MapUtils.isEmpty(rfcResultData) || !rfcResultData.containsKey("EXPORT")) {
            return false;
        }

        Map<String, Object> exportData = (Map<String, Object>) rfcResultData.get("EXPORT");

        return MapUtils.isNotEmpty(exportData) && exportData.containsKey("E_AUTH") && StringUtils.equals(ObjectUtils.toString(exportData.get("E_AUTH")), "Y");
    }

}