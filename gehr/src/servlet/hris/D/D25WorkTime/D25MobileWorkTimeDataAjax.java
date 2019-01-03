/********************************************************************************/
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : D25MobileWorkTimeDataAjax.java
/*   Description  : 근무시간입력 data 조회/저장 Class
/*   Note         : 
/*   Creation     : 2018-07-09 [WorkTime52] 유정우
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
            // RFC 실행 parameter 준비
            Map<String, Object> params = WebUtil.getBox(req).getHashMap();
            params.put("I_PERNR", WebUtil.getSessionUser(req).empNo);
            params.put("I_DATUM", DataUtil.getCurrentDate());

            // RFC 실행
            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REQ_M", params,
                (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), new String[] {"T_WLIST", "T_ELIST", "T_RLIST"}));

            // RFC 실행 결과가 실패인 경우 Exception 처리
            if (!RfcDataHandler.isSuccess(rfcResultData)) {
                throw new Exception(getExceptionMessage(rfcResultData));
            }

            // RFC 실행 결과 data JSON string으로 return
            new AjaxResultMap().addResult(rfcResultData).writeJson(res);

        } catch (Exception e) {
            throw new GeneralException(e);

        }
    }

    /**
     * <pre>
     * RFC 실행 결과 data에서 오류 message 추출
     * 
     * RFC에서 return된 message가 없는 경우 아래 message return
     *     - 조회 요청 : 근무시간 정보 목록을 조회하지 못했습니다.
     *     - 저장 요청 : 근무시간 정보 저장중 오류가 발생했습니다.
     * </pre>
     * 
     * @param rfcResultData
     * @return
     */
    private String getExceptionMessage(Map<String, Object> rfcResultData) {

        String I_GTYPE = ObjectUtils.toString(rfcResultData.get("I_GTYPE"));
        String defaultMessage = "1".equals(I_GTYPE) ? g.getMessage("MSG.D.D25.N0002") : ("2".equals(I_GTYPE) ? g.getMessage("MSG.D.D25.N0003") : ""); // 근무시간 정보 목록을 조회하지 못했습니다. : 근무시간 정보 저장중 오류가 발생했습니다.

        String resultMessage = RfcDataHandler.getMessage(rfcResultData);
        return StringUtils.isBlank(resultMessage) ? defaultMessage : resultMessage;
    }

}