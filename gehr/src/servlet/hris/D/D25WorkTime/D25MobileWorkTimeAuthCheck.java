/********************************************************************************/
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : D25MobileWorkTimeAuthCheck.java
/*   Description  : �ٹ��ð��Է� Menu ���� ���� üũ
/*   Note         : 
/*   Creation     : 2018-07-10 [WorkTime52] ������
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D25WorkTime;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.AjaxResultMap;
import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.MobileJsonBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

@SuppressWarnings("serial")
public class D25MobileWorkTimeAuthCheck extends MobileJsonBaseServlet {

    @Override
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            // RFC ���� parameter �غ� �� RFC ����
            final String today = DataUtil.getCurrentDate();
            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_PRECHK_M", new HashMap<String, Object>() {
                {
                    put("I_PERNR", WebUtil.getSessionUser(req).empNo);
                    put("I_WKDAT", today);
                    put("I_DATUM", today);
                }
            });

            // RFC ���� ��� data JSON string���� return
            new AjaxResultMap().addResult(rfcResultData).writeJson(res);

        } catch (Exception e) {
            throw new GeneralException(e);

        }
    }

}