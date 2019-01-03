/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 관리자 로그인                                                */
/*   Program Name : 관리자 로그인                                     */
/*   Program ID   : AdminLoginSV.java                                    */
/*   Description  : 관리자 로그인                           */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정                       */
/*                :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
/*                   2018/01/22  rdcamel [CSR ID:3594900] 사무직 육성면담 재구축 시스템 HR-Portal    */
/* 				  2018/05/03  rdcamel //[CSR ID:3678263] LG화학 사무직 실근로시간 입력 시스템 반영  */
/********************************************************************************/

package servlet.hris;

import com.common.constant.Area;
import com.lgcns.encypt.EncryptUtil;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.N.AES.AESgenerUtil;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.EmpListRFC;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.TimeZone;

/**
 *
 * URL : servlet.hris.ExternalViewSV?lang=국가키(ko,en,zh)empNo=로그인사번&empNoKey=로그인사번암호화키&sysid=0(국내)
 *      기타 조회시 &requestPage
 *
 */
public class ExternalViewSV extends EHRBaseServlet {

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            performTask(req, res);
        }catch(GeneralException e){
           throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        //Connection conn = null;
        try{

            process(req, res, false);

            WebUserData user = WebUtil.getSessionUser(req);

            String dest = WebUtil.JspURL + "main.jsp";
            String requestPage = req.getParameter("requestPage");

            if("selfConfirm".equals(requestPage)) dest = WebUtil.ServletURL + "hris.N.essperson.A01SelfDetailNeoConfirmPopSV";
            else if("rule".equals(requestPage)) dest = WebUtil.JspURL + "help_online/help/html/"+req.getParameter("param");
            else if("faq".equals(requestPage)) dest = WebUtil.ServletURL + "hris.N.ehrFAQ.EHRfaqSV?I_PFLAG=X";
            else if("charge".equals(requestPage)) dest = WebUtil.JspURL + "common/HRChargePop.jsp?I_BUKRS=" + user.companyCode + "&I_GRUP_NUMB=" + user.e_grup_numb;
            else if("board".equals(requestPage)) dest = WebUtil.ServletURL + "hris.N.notice.EHRNoticeSV?OBJID=" + req.getParameter("OBJID");
            //육성면담 발령 탭 조회 [CSR ID:3594900]
            else if("raise".equals(requestPage)) dest = WebUtil.ServletURL + "hris.A.A05AppointDetailSV";
            //[CSR ID:3678263] LG화학 사무직 실근로시간 입력 시스템 반영
            else if("workTime".equals(requestPage)) dest = WebUtil.ServletURL + "hris.D.D25WorkTime.D25WorkTimeFrameSV";
            
            /*else (new WebAccessLog()).setAccessLog("MAIN", user.empNo, user.empNo, user.remoteIP);*/

            redirect(res, dest);

        }catch(Exception e){
            throw new GeneralException(e);
        }// end try
    }

    /**
     * 외부 접근시 로그인 공통
     * @param req
     * @param res
     * @throws GeneralException
     */
    protected void process(HttpServletRequest req, HttpServletResponse res, boolean isSSO) throws GeneralException {
        //Connection conn = null;
        try{

            WebUserData user = new WebUserData();
            Box box = WebUtil.getBox(req);
            box.copyToEntity(user);

            HttpSession session = req.getSession(false);


            /* 파라메터로 넘어온 값*/
            try {
                Enumeration params = req.getParameterNames();
                while (params.hasMoreElements()) {
                    String param = (String) params.nextElement();
                    String str = req.getParameter(param);

                    Logger.debug("[" + param + "]" + req.getParameter(param)  + "[" + (str == null ? "-NULL-" :  str.getClass()) + "]");
                }
            } catch (Exception e) {
                Logger.error(e);
            }

            if(isSSO) {
                user.empNo = DataUtil.fixEndZero((String) session.getAttribute("SYSTEM_ID"), 8);
            } else {
                try {
                /*String key = "sshr" + box.get("empNoKey", box.get("empkey"));
                String decryptEmpNo = AESgenerUtil.decryptAES(box.get("empNo", box.get("empno")), key);*/
                    //[CSR ID:3678263]String decryptEmpNo = decryptEmpno(box.get("empNo", box.get("empno")));
                	//[CSR ID:3678263]g-portal 에서 넘어오는 암호사번은 encryptEmpNo 로 넘어옴. box 의 변수 하나 추가함.
                	String decryptEmpNo = decryptEmpno(box.get("encryptEmpNo", box.get("empNo", box.get("empno"))));
                    if(StringUtils.isBlank(decryptEmpNo)) throw new Exception();

                    user.empNo = DataUtil.fixEndZero(decryptEmpNo, 8);
                } catch(Exception e) {
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0084"), "history.back();");//해당 사번에 대한 유효성 검증에 실패하였습니다.
                    return;
                }
            }
//            viewEmpnoKey

            //기존 세션 연결 여부 확인
            WebUserData sessionUser = WebUtil.getSessionUser(req);

            //기존 세션이 존재하지 않거나 세션 empno 값이 틀리면 세션 새로 생성
            if(sessionUser == null || !StringUtils.equals(sessionUser.empNo, user.empNo) ) {

            /* sap연결 정보 셋팅 */
                EmpListRFC empListRFC = new EmpListRFC(SAPType.LOCAL);
                if (!empListRFC.setSapTypeFromParameter(req, user)) {
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0083"), "window.close();"); //해당 사원 정보가 없습니다.
                    return;
//                throw new GeneralException("접속 중 오류가 발생하였습니다.");
                }

                Logger.debug("user.empNo ?????????????????>> " + user.empNo); //00034122

                //[CSR ID:2685916] 웹취약성 수정 1차@웹취약성 취약한 요청/응답처리 20150117
                user.remoteIP = req.getRemoteAddr();

                //if (webUserPwd.trim().equalsIgnoreCase(originPwd.trim())) {
                if (session != null){ session.invalidate(); }

                PersonData personData;
                PersonInfoRFC personInfoRFC = new PersonInfoRFC(user.sapType);
                try {
                    personData = personInfoRFC.getPersonInfo(user.empNo, "X");
                } catch (Exception ex) {
                    Logger.error(ex);
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0083"), "window.close();"); //해당 사원 정보가 없습니다.
                    return;
//                throw new GeneralException(ex);
                }

                user.login_stat = "Y";
                Config conf = new Configuration();
                user.clientNo = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                personInfoRFC.setSessionUserData(personData, user);

                if (WebUtil.isLocal(req) && StringUtils.isBlank(user.e_area)) user.e_area = "41";
                user.area = Area.fromMolga(user.e_area);

                Logger.debug.println(this, personData);

                DataUtil.fixNull(user);
                session = req.getSession(true);
                int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                session.setMaxInactiveInterval(maxSessionTime);

                session.setAttribute("user", user);
                session.setAttribute("user_m", user);

                AESgenerUtil cu = new AESgenerUtil();
                session.setAttribute("AESKEY", cu.getKey());

            }

            /* 파라메터로 넘어온 값*/
            Logger.debug("---------- 2nd Log -------- ");
            try {
                Enumeration params = req.getParameterNames();
                while (params.hasMoreElements()) {
                    String param = (String) params.nextElement();
                    Logger.debug("[" + param + "]" + req.getParameter(param));
                }
            } catch (Exception e) {
                Logger.error(e);
            }

            WebUtil.setLang(req, user);

            user.locale = g.getLocale();
            Logger.debug("------ Spring Locale : " + WebUtils.getSessionAttribute(req, SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME));
            Logger.debug.println(this, "ok login.. user : " + user.toString());
//                    String dest = WebUtil.JspURL+"main.jsp";
        }catch(Exception e){
            Logger.error(e);
            throw new GeneralException(e);
        }// end try
    }

    protected String decryptEmpno(String encryptEmpNo) throws Exception {


        /**************************************************************/
		/* URL Parameter통해 전달 받은 경우 예제                                                                         */
        /**************************************************************/
        // G-Portal에서 넘겨주는 파라미터 명 ( GET 방식의 경우 URLEncoder/URLDecoder 를 활용하여야 함.
        // 사번 : encryptEmpNo --> (String)request.getParameter(“encryptEmpNo”);
        // 메일주소 : encryptMail --> (String)request.getParameter(“encryptMail”);
        // 유저 ID : encryptUserId --> (String)request.getParameter(“encryptUserId”);

        // 복호화
        String decryptStr = EncryptUtil.decryptText(encryptEmpNo,"ThisIsIkepSecurityKey");
        Logger.debug("Decrypt datetime+empNo : " + decryptStr);

        String[] decryptArr = decryptStr.split("\\|",0);
        if(decryptArr.length < 2) {
            new GeneralException("Error Decrypt length < 0");
        }

        Logger.debug("Decrypt datetime : " + decryptArr[0]); // yyyyMMddHHmmss 포맷의 Datetime (GMT+0), 파리미터 유효성 검증에 활용
        Logger.debug("Decrypt empNo : " + decryptArr[1]); // 복호화된 EmpNo

        /**************************************************************/
        // 아래는 암호화 데이터 생성 시간을 확인하는 예제 임.
        // | 를 구분자로 datetime ( GMT+0 기준임, date format-"yyyyMMddHHmmss" )가 있으니 암호화 데이터 유효성 확인하세요.
        /**************************************************************/

        TimeZone jst2 = TimeZone.getTimeZone ("GMT+0");
        Calendar receiveServerTimeMinus = Calendar.getInstance (jst2);
        Calendar receiveServerTimePlus = Calendar.getInstance (jst2);

        receiveServerTimeMinus.add(Calendar.HOUR_OF_DAY, -12);
        receiveServerTimePlus.add(Calendar.HOUR_OF_DAY, 12);

        Date minusLimit = receiveServerTimeMinus.getTime();
        Date plusLimit =  receiveServerTimePlus.getTime();

        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMddHHmmss");
        sdf2.setTimeZone(receiveServerTimeMinus.getTimeZone());

        try {
            Date paramDateTime = sdf2.parse(decryptArr[0]); // 복화화 데이터중 dateTime 부분
            //Date paramDateTime = sdf2.parse("20140305204256"); // 오류 발생을 위한 임의 값 설정

            if(paramDateTime.before(minusLimit)) {
                throw new Exception("Error! 암호화가 오래전에 됨 ");
            }

            if(paramDateTime.after(plusLimit)) {
                throw new Exception("Error! 암호화 된 시간이 미래임");
            }

        } catch (Exception e) {
            throw new Exception(e);
        }

        return decryptArr[1];
    }

}