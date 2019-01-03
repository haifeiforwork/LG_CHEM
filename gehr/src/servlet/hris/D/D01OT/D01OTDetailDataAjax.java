/********************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : MY HR 정보
/*   2Depth Name  : 초과근무 결재
/*   Program Name : 
/*   Program ID   : D01OTDetailDataAjax.java
/*   Description  : 주52시간 근무제 초과근무 관련 체크 AJAX
/*   Note         : 
/*   Creation     : 2018-06-11 [WorkTime52] 유정우
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.AjaxResultMap;
import com.common.JsonUtils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

@SuppressWarnings("serial")
public class D01OTDetailDataAjax extends EHRBaseServlet {

    @Override
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            Map<String, Object> params = WebUtil.getBox(req).getHashMap();

            // 초과근무 신청 결재 승인 전 시간 체크
            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_AVAL_CHK_ADD",
                JsonUtils.getObject((String) params.get("IMPORT"), HashMap.class),
                (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), "T_RESULT"));

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