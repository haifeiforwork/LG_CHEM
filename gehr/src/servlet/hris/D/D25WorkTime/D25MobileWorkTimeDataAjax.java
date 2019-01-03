/********************************************************************************/
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : D25MobileWorkTimeDataAjax.java
/*   Description  : �ٹ��ð��Է� data ��ȸ/���� Class
/*   Note         : 
/*   Creation     : 2018-07-09 [WorkTime52] ������
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D25WorkTime;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.common.AjaxResultMap;
import com.common.JsonUtils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.MobileJsonBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

@SuppressWarnings("serial")
public class D25MobileWorkTimeDataAjax extends MobileJsonBaseServlet {

    @Override
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            // RFC ���� parameter �غ�
            Map<String, Object> params = WebUtil.getBox(req).getHashMap();
            params.put("I_PERNR", WebUtil.getSessionUser(req).empNo);
            params.put("I_DATUM", DataUtil.getCurrentDate());

            // RFC ����
            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REQ_M", params,
                (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), new String[] {"T_WLIST", "T_ELIST", "T_RLIST"}));

            // RFC ���� ����� ������ ��� Exception ó��
            if (!RfcDataHandler.isSuccess(rfcResultData)) {
                throw new Exception(getExceptionMessage(rfcResultData));
            }

            // RFC ���� ��� data JSON string���� return
            new AjaxResultMap().addResult(rfcResultData).writeJson(res);

        } catch (Exception e) {
            throw new GeneralException(e);

        }
    }

    /**
     * <pre>
     * RFC ���� ��� data���� ���� message ����
     * 
     * RFC���� return�� message�� ���� ��� �Ʒ� message return
     *     - ��ȸ ��û : �ٹ��ð� ���� ����� ��ȸ���� ���߽��ϴ�.
     *     - ���� ��û : �ٹ��ð� ���� ������ ������ �߻��߽��ϴ�.
     * </pre>
     * 
     * @param rfcResultData
     * @return
     */
    private String getExceptionMessage(Map<String, Object> rfcResultData) {

        String I_GTYPE = ObjectUtils.toString(rfcResultData.get("I_GTYPE"));
        String defaultMessage = "1".equals(I_GTYPE) ? g.getMessage("MSG.D.D25.N0002") : ("2".equals(I_GTYPE) ? g.getMessage("MSG.D.D25.N0003") : ""); // �ٹ��ð� ���� ����� ��ȸ���� ���߽��ϴ�. : �ٹ��ð� ���� ������ ������ �߻��߽��ϴ�.

        String resultMessage = RfcDataHandler.getMessage(rfcResultData);
        return StringUtils.isBlank(resultMessage) ? defaultMessage : resultMessage;
    }

}