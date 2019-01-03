/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeLeaderDataAjax.java
/*   Description  : 근무 입력 현황 AJAX 요청처리 class
/*   Note         : 
/*   Creation     : 2018-05-14 [WorkTime52] 유정우
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D25WorkTime;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.common.AjaxResultMap;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

@SuppressWarnings("serial")
public class D25WorkTimeLeaderDataAjax extends EHRBaseServlet {

    @Override
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            Box box = WebUtil.getBox(req);

            final Map<String, Object> params = box.getHashMap();
            params.put("I_LOGPER", WebUtil.getSessionUser(req).getEmpNo());
            params.put("I_DATUM", DataUtil.getCurrentDate());

            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_ORGEH_RWKD_LIST", params);
            String message = g.getMessage("MSG.D.D25.N0002"); // 근무시간 정보 목록을 조회하지 못했습니다.

            if (!RfcDataHandler.isSuccess(rfcResultData)) {
                String msg = RfcDataHandler.getMessage(rfcResultData);
                throw new GeneralException(StringUtils.isEmpty(msg) ? message : msg);
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

}