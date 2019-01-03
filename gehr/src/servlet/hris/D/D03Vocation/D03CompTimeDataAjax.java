/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : �ް�/����
/*   Program Name : �����ް� �߻�����
/*   Program ID   : D03CompTimeDataAjax.java
/*   Description  : �����ް� �߻����� AJAX ��ûó�� class
/*   Note         : 
/*   Creation     : 2018-07-26 [WorkTime52] ������
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.AjaxResultMap;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

@SuppressWarnings("serial")
public class D03CompTimeDataAjax extends EHRBaseServlet {

    @Override
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            // RFC ���� parameter �غ�
            Map<String, Object> params = WebUtil.getBox(req).getHashMap();
            params.put("I_PERNR", WebUtil.getSessionUser(req).empNo);
            params.put("I_DATUM", DataUtil.getCurrentDate());

            // RFC ����
            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_COMPENS_HOLIDAY", params);

            // RFC ���� ����� ������ ��� Exception ó��
            if (!RfcDataHandler.isSuccess(rfcResultData)) {
                throw new GeneralException(RfcDataHandler.getMessage(rfcResultData));
            }

            // RFC ���� ��� data JSON string���� return
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

}