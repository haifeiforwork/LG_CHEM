/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 보상휴가 발생내역
/*   Program ID   : D03CompTimeDataAjax.java
/*   Description  : 보상휴가 발생내역 AJAX 요청처리 class
/*   Note         : 
/*   Creation     : 2018-07-26 [WorkTime52] 유정우
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
            // RFC 실행 parameter 준비
            Map<String, Object> params = WebUtil.getBox(req).getHashMap();
            params.put("I_PERNR", WebUtil.getSessionUser(req).empNo);
            params.put("I_DATUM", DataUtil.getCurrentDate());

            // RFC 실행
            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_COMPENS_HOLIDAY", params);

            // RFC 실행 결과가 실패인 경우 Exception 처리
            if (!RfcDataHandler.isSuccess(rfcResultData)) {
                throw new GeneralException(RfcDataHandler.getMessage(rfcResultData));
            }

            // RFC 실행 결과 data JSON string으로 return
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