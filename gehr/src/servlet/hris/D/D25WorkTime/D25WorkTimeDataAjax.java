/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 시간 입력
/*   Program ID   : D25WorkTimeDataAjax.java
/*   Description  : 근무 시간 입력 AJAX 요청처리 class
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
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

            String sPERNR = user.getEmpNo();                                                                 // 로그인 사용자 사번
            String pPERNR = StringUtils.defaultIfEmpty(ObjectUtils.toString(params.get("P_PERNR")), sPERNR); // 조회 대상 사번
            boolean isMSS = params.containsKey("MSSYN") && "Y".equals(ObjectUtils.toString(params.get("MSSYN")));

            if (isMSS) {
                // 근무 입력 현황 화면에서 MSSYN=Y parameter가 오면 MSS로 처리
                if (!isMenuAccessAutorizedUser(sPERNR, "MSS_OFW_WORK_TIME")) {
                    throw new GeneralException(g.getMessage("MSG.COMMON.0060")); // 해당 페이지에 권한이 없습니다.
                }

                String pORGEH = ObjectUtils.toString(params.get("P_ORGEH")); // 소속 코드
                String pRETIR = ObjectUtils.toString(params.get("P_RETIR")); // 퇴직자 포함 여부('X' : 포함)

                // M 권한이 없거나 사원 data 조회 권한이 없으면 오류 처리
                if (!checkAuthorization(req, res) || !checkBelong(req, res, new SysAuthInput("4", null, pPERNR, pORGEH, null, pRETIR, null, "X"))) {
                    throw new GeneralException(g.getMessage("MSG.COMMON.0060")); // 해당 페이지에 권한이 없습니다.
                }

            } else {
                // 사무직이 아닌 사용자의 경우 오류 처리 - 사무직만 메뉴 접근 권한이 부여됨
                if (!isMenuAccessAutorizedUser(pPERNR, "ESS_OFW_WORK_TIME")) {
                    throw new GeneralException(g.getMessage("MSG.D.D25.N0028")); // 사무직 근무시간 관리 입력 대상자가 아닙니다.
                }

            }

            params.put("I_PERNR", pPERNR);
            params.put("I_DATUM", DataUtil.getCurrentDate());

            String name = (String) params.get("NAME");
            String message = null;
            Map<String, Object> rfcResultData = null;

            // 비근무시간 저장
            if ("BREAK_SAVE".equals(name)) {
                params.put("I_GTYPE", "2");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_EVENT", params,
                    (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), "T_ELIST"));

                message = g.getMessage("MSG.D.D25.N0005"); // 비근무시간 정보 저장중 오류가 발생했습니다.

            }
            // 비근무시간 목록 조회
            else if ("BREAK_LIST".equals(name)) {
                params.put("I_GTYPE", "1");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_EVENT", params);

                message = g.getMessage("MSG.D.D25.N0026"); // 업무재개시간 정보 목록을 조회하지 못했습니다.

            }
            // 업무재개시간 저장
            else if ("EXTRA_SAVE".equals(name)) {
                params.put("I_GTYPE", "2");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REWORK", params,
                    (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), "T_ELIST"));

                message = g.getMessage("MSG.D.D25.N0027"); // 업무재개시간 정보 저장중 오류가 발생했습니다.

            }
            // 업무재개시간 목록 조회
            else if ("EXTRA_LIST".equals(name)) {
                params.put("I_GTYPE", "1");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REWORK", params);

                params.put("I_WKDAT", params.get("I_TOMRR"));
                ((Map<String, Object>) rfcResultData.get("EXPORT")).put("TOMORROW", getTomorrowScheduledWorkTime(params));

                message = g.getMessage("MSG.D.D25.N0004"); // 비근무시간 정보 목록을 조회하지 못했습니다.

            }
            // 근무시간 저장
            else if ("WORK_SAVE".equals(name)) {
                params.put("I_GTYPE", "2");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REQ", params,
                    (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), "T_WLIST"));

                message = g.getMessage("MSG.D.D25.N0003"); // 근무시간 정보 저장중 오류가 발생했습니다.

            }
            // 교육/출장 계획 저장
            else if ("PLAN_SAVE".equals(name)) {
                params.put("I_GTYPE", "2");

                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_TRV", params,
                    (Map<String, List<Map<String, Object>>>) JsonUtils.getMap((String) params.get("TABLES"), "T_TLIST"));

                message = g.getMessage("MSG.D.D25.N0054"); // 교육/출장 계획 정보 저장중 오류가 발생했습니다.

            }
            // 근무시간 목록 조회
            else {
                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_LIST", params);

                // 교육/출장 계획 입력 combo data 조회
                if (MapUtils.isNotEmpty(rfcResultData) && rfcResultData.containsKey("TABLES")) {
                    ((Map<String, Object>) rfcResultData.get("TABLES")).put("T_TYPES", getPlantimeComboData(params));
                }

                message = g.getMessage("MSG.D.D25.N0002"); // 근무시간 정보 목록을 조회하지 못했습니다.

            }

            if (!RfcDataHandler.isSuccess(rfcResultData)) {
                String msg = RfcDataHandler.getMessage(rfcResultData);
                throw new GeneralException(StringUtils.isBlank(msg) ? message : msg);
            }

            ((Map<String, Object>) rfcResultData.get("EXPORT")).put("PERNR", pPERNR);

            if (isMSS) {
                rfcResultData.put("MSSYN", "Y");

                /*
                 * 웹로그 추가 2015-06-19
                 * EADMIN과 EMANAG로 시작하는 사용자 제외(개발자, 운영자, 관리자는 제외)
                 * MSS 부서개인정보를 조회하는 메뉴에 모두 추가함.
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
     * 교육/출장 계획 시간 입력 combo data 조회
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
     * 업무재개시간 저장시 업무종료 시간이 익일로 넘어가는 경우 익일의 계획근무시간과 겹치는지 확인을 위해 익일의 계획근무시간을 조회하여 화면으로 반환한다.
     * 
     * @param params
     * @return
     * @throws GeneralException
     */
    private Map<String, Object> getTomorrowScheduledWorkTime(Map<String, Object> params) throws GeneralException {

        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_REQ", params);

        if (!RfcDataHandler.isSuccess(rfcResultData)) {
            String msg = RfcDataHandler.getMessage(rfcResultData);
            throw new GeneralException(StringUtils.isBlank(msg) ? g.getMessage("MSG.D.D25.N0036") : msg); // 입력된 업무재개 시간과 비교하기 위한\n익일 계획 근무 시간이 조회되지 않았습니다.
        }

        Map<String, Object> data = null;
        try {
            data = ((List<Map<String, Object>>) ((Map<String, List<Map<String, Object>>>) rfcResultData.get("TABLES")).get("T_WLIST")).get(0);
        } catch (Exception e) {
            throw new GeneralException(g.getMessage("MSG.D.D25.N0036")); // 입력된 업무재개 시간과 비교하기 위한\n익일 계획 근무 시간이 조회되지 않았습니다.
        }

        return data;
    }

    /**
     * G-Portal을 통해 진입한 사용자중 사무직이 아닌 사용자인 경우 대상이 아님을 알리고 창을 닫는다. 
     * 
     * @param PERNR 로그인 사번
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