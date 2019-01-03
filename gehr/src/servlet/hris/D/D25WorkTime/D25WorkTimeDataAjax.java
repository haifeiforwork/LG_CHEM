/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : �ް�/����
/*   Program Name : �ٹ� �ð� �Է�
/*   Program ID   : D25WorkTimeDataAjax.java
/*   Description  : �ٹ� �ð� �Է� AJAX ��ûó�� class
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] ������
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D25WorkTime;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.common.AjaxResultMap;
import com.common.JsonUtils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.N.WebAccessLog;
import hris.common.WebUserData;
import hris.sys.SysAuthInput;

@SuppressWarnings("serial")
public class D25WorkTimeDataAjax extends EHRBaseServlet {

    private final String sMenuCode = "ESS_OFW_WORK_TIME";

    @Override
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            WebUserData user = WebUtil.getSessionUser(req);
            Map<String, Object> params = WebUtil.getBox(req).getHashMap();

            String sPERNR = user.getEmpNo();                                                                 // �α��� ����� ���
            String pPERNR = StringUtils.defaultIfEmpty(ObjectUtils.toString(params.get("P_PERNR")), sPERNR); // ��ȸ ��� ���
            boolean isMSS = params.containsKey("MSSYN") && "Y".equals(ObjectUtils.toString(params.get("MSSYN")));

            if (isMSS) {
                // �ٹ� �Է� ��Ȳ ȭ�鿡�� MSSYN=Y parameter�� ���� MSS�� ó��
                if (!isMenuAccessAutorizedUser(sPERNR, "MSS_OFW_WORK_TIME")) {
                    throw new GeneralException(g.getMessage("MSG.COMMON.0060")); // �ش� �������� ������ �����ϴ�.
                }

                String pORGEH = ObjectUtils.toString(params.get("P_ORGEH")); // �Ҽ� �ڵ�
                String pRETIR = ObjectUtils.toString(params.get("P_RETIR")); // ������ ���� ����('X' : ����)

                // M ������ ���ų� ��� data ��ȸ ������ ������ ���� ó��
                if (!checkAuthorization(req, res) || !checkBelong(req, res, new SysAuthInput("4", null, pPERNR, pORGEH, null, pRETIR, null, "X"))) {
                    throw new GeneralException(g.getMessage("MSG.COMMON.0060")); // �ش� �������� ������ �����ϴ�.
                }

            } else {
                // �繫���� �ƴ� ������� ��� ���� ó�� - �繫���� �޴� ���� ������ �ο���
                if (!isMenuAccessAutorizedUser(pPERNR, "ESS_OFW_WORK_TIME")) {
                    throw new GeneralException(g.getMessage("MSG.D.D25.N0028")); // �繫�� �ٹ��ð� ���� �Է� ����ڰ� �ƴմϴ�.
                }

            }

            params.put("I_PERNR", pPERNR);
            params.put("I_DATUM", DataUtil.getCurrentDate());

            String name = (String) params.get("NAME");
            String message = null;
            Map<String, Object> rfcResultData = null;

            // ��ٹ��ð� ����
            if ("BREAK_SAVE".equals(name)) {
                params.put("I_GTYPE", "2");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_EVENT", params,
                    (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), "T_ELIST"));

                message = g.getMessage("MSG.D.D25.N0005"); // ��ٹ��ð� ���� ������ ������ �߻��߽��ϴ�.

            }
            // ��ٹ��ð� ��� ��ȸ
            else if ("BREAK_LIST".equals(name)) {
                params.put("I_GTYPE", "1");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_EVENT", params);

                message = g.getMessage("MSG.D.D25.N0026"); // �����簳�ð� ���� ����� ��ȸ���� ���߽��ϴ�.

            }
            // �����簳�ð� ����
            else if ("EXTRA_SAVE".equals(name)) {
                params.put("I_GTYPE", "2");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REWORK", params,
                    (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), "T_ELIST"));

                message = g.getMessage("MSG.D.D25.N0027"); // �����簳�ð� ���� ������ ������ �߻��߽��ϴ�.

            }
            // �����簳�ð� ��� ��ȸ
            else if ("EXTRA_LIST".equals(name)) {
                params.put("I_GTYPE", "1");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REWORK", params);

                params.put("I_WKDAT", params.get("I_TOMRR"));
                ((Map<String, Object>) rfcResultData.get("EXPORT")).put("TOMORROW", getTomorrowScheduledWorkTime(params));

                message = g.getMessage("MSG.D.D25.N0004"); // ��ٹ��ð� ���� ����� ��ȸ���� ���߽��ϴ�.

            }
            // �ٹ��ð� ����
            else if ("WORK_SAVE".equals(name)) {
                params.put("I_GTYPE", "2");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REQ", params,
                    (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), "T_WLIST"));

                message = g.getMessage("MSG.D.D25.N0003"); // �ٹ��ð� ���� ������ ������ �߻��߽��ϴ�.

            }
            // ����/���� ��ȹ ����
            else if ("PLAN_SAVE".equals(name)) {
                params.put("I_GTYPE", "2");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_TRV", params,
                    (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), "T_TLIST"));

                message = g.getMessage("MSG.D.D25.N0054"); // ����/���� ��ȹ ���� ������ ������ �߻��߽��ϴ�.

            }
            // �ٹ��ð� ��� ��ȸ
            else {
                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_LIST", params);

                // ����/���� ��ȹ �Է� combo data ��ȸ
                if (MapUtils.isNotEmpty(rfcResultData) && rfcResultData.containsKey("TABLES")) {
                    ((Map<String, Object>) rfcResultData.get("TABLES")).put("T_TYPES", getPlantimeComboData(params));
                }

                message = g.getMessage("MSG.D.D25.N0002"); // �ٹ��ð� ���� ����� ��ȸ���� ���߽��ϴ�.

            }

            if (!RfcDataHandler.isSuccess(rfcResultData)) {
                String msg = RfcDataHandler.getMessage(rfcResultData);
                throw new GeneralException(StringUtils.isBlank(msg) ? message : msg);
            }

            ((Map<String, Object>) rfcResultData.get("EXPORT")).put("PERNR", pPERNR);

            if (isMSS) {
                rfcResultData.put("MSSYN", "Y");

                /*
                 * ���α� �߰� 2015-06-19
                 * EADMIN�� EMANAG�� �����ϴ� ����� ����(������, ���, �����ڴ� ����)
                 * MSS �μ����������� ��ȸ�ϴ� �޴��� ��� �߰���.
                 */
                if (!user.user_group.equals("01") && !user.user_group.equals("02") && !user.user_group.equals("03")) {
                    new WebAccessLog().setAccessLog(sMenuCode, sPERNR, pPERNR, user.remoteIP);
                }
            }

            new AjaxResultMap().addResult(rfcResultData).writeJson(res);

        } catch (Exception e) {
            Logger.error(e);

            try {
                new AjaxResultMap().setErrorMessage(e.getMessage()).writeJson(res);
            } catch (Exception ie) {
                Logger.error(ie);

                throw new GeneralException(ie);
            }

        }
    }

    /**
     * ����/���� ��ȹ �ð� �Է� combo data ��ȸ
     * 
     * @param params
     * @return
     * @throws GeneralException
     */
    private List<Map<String, Object>> getPlantimeComboData(Map<String, Object> params) throws GeneralException {

        params.put("I_GTYPE", "1");

        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_TRV", params);
        if (!RfcDataHandler.isSuccess(rfcResultData) || !rfcResultData.containsKey("TABLES")) {
            return null;
        }

        Map<String, Object> tablesData = (Map<String, Object>) rfcResultData.get("TABLES");
        if (MapUtils.isEmpty(tablesData) || !tablesData.containsKey("T_WKTYP")) {
            return null;
        }

        return (List<Map<String, Object>>) tablesData.get("T_WKTYP");
    }

    /**
     * �����簳�ð� ����� �������� �ð��� ���Ϸ� �Ѿ�� ��� ������ ��ȹ�ٹ��ð��� ��ġ���� Ȯ���� ���� ������ ��ȹ�ٹ��ð��� ��ȸ�Ͽ� ȭ������ ��ȯ�Ѵ�.
     * 
     * @param params
     * @return
     * @throws GeneralException
     */
    private Map<String, Object> getTomorrowScheduledWorkTime(Map<String, Object> params) throws GeneralException {

        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REQ", params);

        if (!RfcDataHandler.isSuccess(rfcResultData)) {
            String msg = RfcDataHandler.getMessage(rfcResultData);
            throw new GeneralException(StringUtils.isBlank(msg) ? g.getMessage("MSG.D.D25.N0036") : msg); // �Էµ� �����簳 �ð��� ���ϱ� ����\n���� ��ȹ �ٹ� �ð��� ��ȸ���� �ʾҽ��ϴ�.
        }

        Map<String, Object> data = null;
        try {
            data = ((List<Map<String, Object>>) ((Map<String, List<Map<String, Object>>>) rfcResultData.get("TABLES")).get("T_WLIST")).get(0);
        } catch (Exception e) {
            throw new GeneralException(g.getMessage("MSG.D.D25.N0036")); // �Էµ� �����簳 �ð��� ���ϱ� ����\n���� ��ȹ �ٹ� �ð��� ��ȸ���� �ʾҽ��ϴ�.
        }

        return data;
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