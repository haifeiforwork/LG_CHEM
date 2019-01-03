/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 시간 입력
/*   Program ID   : D25WorkTimeFrameSV.java
/*   Description  : 근무 시간 입력 frame JSP 요청처리 class
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
/*   Update       : 2018-06-04 rdcamel [CSR ID:3704184] 유연근로제 동의 관련 기능 추가 건 - Global HR Portal
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

        final String sPERNR = user.getEmpNo();                                                                 // 로그인 사용자 사번
        final String pPERNR = StringUtils.defaultIfEmpty(ObjectUtils.toString(params.get("P_PERNR")), sPERNR); // 조회 대상 사번

        if ("first".equals(jobid)) {
            // 근무 입력 현황 화면에서 MSSYN=Y parameter가 오면 MSS로 처리
            boolean isMSS = params.containsKey("MSSYN") && "Y".equals(ObjectUtils.toString(params.get("MSSYN")));

	        if (isMSS) {
	            // 근무 입력 현황 메뉴 접근 권한이 없으면 오류 처리
	            if (!isMenuAccessAutorizedUser(sPERNR, "MSS_OFW_WORK_TIME")) {
	                req.setAttribute("msg", g.getMessage("MSG.COMMON.0060")); // 해당 페이지에 권한이 없습니다.
	                req.setAttribute("url", "self.close()");

	                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
	                return;
	            }

	            String pORGEH = ObjectUtils.toString(params.get("P_ORGEH")); // 소속 코드
	            String pRETIR = ObjectUtils.toString(params.get("P_RETIR")); // 퇴직자 포함 여부('X' : 포함)

	            // M 권한이 없거나 사원 data 조회 권한이 없으면 오류 처리
	            if (!checkAuthorization(req, res) || !checkBelong(req, res, new SysAuthInput("4", null, pPERNR, pORGEH, null, pRETIR, null, "X"))) {
	                moveCautionPage(req, res, "msg015", ""); // 해당 페이지에 권한이 없습니다.
	                return;
	            }

	        } else {
	            // 사무직이 아닌 사용자의 경우 오류 처리 - 사무직만 메뉴 접근 권한이 부여됨
	            if (!isMenuAccessAutorizedUser(pPERNR, sMenuCode)) {
	                req.setAttribute("msg", g.getMessage("MSG.D.D25.N0028")); // 사무직 근무시간 관리 입력 대상자가 아닙니다.
	                req.setAttribute("url", "self.close()");

	                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
	                return;
	            }

	        }

	        // 근무시간입력 조회년월/사원구분 조회 RFC => D25WorkTimeFrame.jsp onload event에서 조회년월 정보로 해당 년월에 입력된 근무시간 정보를 조회하고 조회된 정보는 tab iframe 내부에서 참조한다.
	        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_RECORD_MONTH", new HashMap<String, Object>() {
	            {
	                put("I_PERNR", pPERNR);
	                put("I_DATUM", DataUtil.getCurrentDate());
	            }
	        });

	        if (!RfcDataHandler.isSuccess(rfcResultData)) {
	            String msg = RfcDataHandler.getMessage(rfcResultData);
	            req.setAttribute("msg", StringUtils.isBlank(msg) ? g.getMessage("MSG.D.D25.N0001") : msg); // 달력 정보를 조회하지 못했습니다.
	            req.setAttribute("url", "top.window.close()");

	            printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
	            return;
	        }

	        Map<String, Object> exportData = (Map<String, Object>) rfcResultData.get("EXPORT");

	        WebUtil.setAttributes(req, exportData);

	        // 조회년월 분리 
	        String yyyyMM = (String) exportData.get("E_YYMON");
	        req.setAttribute("yyyy", yyyyMM.substring(0, 4));
	        req.setAttribute("MM", yyyyMM.substring(4));

	        // 사원구분에 따른 상단 title 설정
	        req.setAttribute("title", "C".equals(ObjectUtils.toString(exportData.get("E_TPGUB"))) ? g.getMessage("LABEL.D.D25.N1002") : g.getMessage("LABEL.D.D25.N1001"));
	//        req.getSession().setAttribute("MSSYN", "Y"); // MSS 테스트시 이 라인만 주석 해제

	        // [CSR ID:3704184] 인사제도 합의 시작
	        String popCheck = "";
	        if (pPERNR.equals(sPERNR)) {
	        	popCheck = "N";//남이 내 화면 조회 시에는 안나오도록
		        D25WorkTimeAgreeChkRFC agreeRfc = new D25WorkTimeAgreeChkRFC();
		        D25WorkTimeAgreeData d25WorkTimeAgreeData = new D25WorkTimeAgreeData();
		        Vector d25WorkTimeAgreeData_vt = new Vector();
		        Vector agreeRst = agreeRfc.getAgreeFlag( yyyyMM.substring(0, 4), pPERNR);

		        if(agreeRst.get(0).equals("S")){//합의 완료
		        	d25WorkTimeAgreeData_vt = (Vector)agreeRst.get(2);
		        	d25WorkTimeAgreeData = (D25WorkTimeAgreeData)d25WorkTimeAgreeData_vt.get(0);
		        	popCheck = d25WorkTimeAgreeData.AGRE_FLAG;//Y가 들어감
		        }
		        req.setAttribute("popCheck", popCheck);
		      }
		      //[CSR ID:3704184] 인사제도 합의 끝

	        if (isMSS) {
	            req.getSession().setAttribute("MSSYN", "Y");

	            /*
	             * 웹로그 추가 2015-06-19
	             * EADMIN과 EMANAG로 시작하는 사용자 제외(개발자, 운영자, 관리자는 제외)
	             * MSS 부서개인정보를 조회하는 메뉴에 모두 추가함.
	             */
	            if (!user.user_group.equals("01") && !user.user_group.equals("02") && !user.user_group.equals("03")) {
	                new WebAccessLog().setAccessLog(sMenuCode, sPERNR, pPERNR, user.remoteIP);
	            }
	        } else {
	            req.getSession().removeAttribute("MSSYN");
	        }

	        req.setAttribute("EdgeMode", "Y");
	        printJspPage(req, res, WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeFrame.jsp");

        } else if ("save".equals(jobid)) { // [CSR ID:3704184] 인사제도 합의
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
	        // [CSR ID:3704184] 인사제도 합의 끝
        }
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