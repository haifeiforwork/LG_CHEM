package com.sns.jdf.servlet;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.WebUtil;

import hris.common.WebUserData;
import hris.sys.MenuCodeData;
import hris.sys.MenuInputData;
import hris.sys.SysAuthInput;
import hris.sys.rfc.SysAuthRFC;
import hris.sys.rfc.SysMenuListRFC;

@SuppressWarnings("serial")
public abstract class EHRBaseServlet extends JDFBaseServlet {

    public static final String GO_HOME = "GO_HOME";
    public static final String GO_LOGIN = "GO_LOGIN";
    public static final String GO_BACK = "GO_BACK";
    public static final String GO_BACK_ALERT = "GO_BACK_ALERT";
    public static final String GO_BACK_POPUP_AUTO = "GO_BACK_POPUP_AUTO";
    public static final String GO_BACK_POPUP = "GO_BACK_POPUP";
    public static final String RELOAD = "RELOAD";
    public static final String RELOAD_ALRET = "RELOAD_ALERT";
    public static final String RELOAD_POPUP_AUTO = "RELOAD_POPUP_AUTO";
    public static final String RELOAD_POPUP = "RELOAD_POPUP";

    public EHRBaseServlet() {
        super();
    }

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        // session check & authority check
        HttpSession session = req.getSession(false);

        try {
            SessionLocaleResolver localeResolver = Utils.getBean("localeResolver");
            localeResolver.setLocale(req, res, g.getLocale());
            req.setAttribute(DispatcherServlet.LOCALE_RESOLVER_ATTRIBUTE, localeResolver);
            req.setAttribute("g", g);
            req.setAttribute("currentURL", g.getCurrentURL(req));
        } catch (Exception e) {
            Logger.error(e);
        }

        if (session == null) {
            Logger.debug.println(this, "session is null");

            // String msg = g.getMessage("MSG.COMMON.0064");
            String url = "parent.location.href= '" + WebUtil.JspPath + "logout.jsp';";
            // req.setAttribute("msg", msg);
            req.setAttribute("url", url);
            printJspPage(req, res, WebUtil.JspURL + "common/msg.jsp");

            return;
            // throw new GeneralException("GOLOGIN");
        } else {      // 임시테스트용 - 세션검사 중지

            if (isLogin(session)) {
                Logger.debug.println(this, "EHRBaseServlet : islogin = true");
                try {
                    performTask(req, res);

                } catch (GeneralException e) {
                    Logger.debug.println(this, "perfromTesk에서 에러발생");
                    throw new GeneralException(e);
                }
            } else {
                Logger.debug.println(this, "EHRBaseServlet : islogin = false");

                String msg = g.getMessage("MSG.COMMON.0064");
                String url = "top.window.close();";
                // String url = "parent.location.href= '" +WebUtil.JspPath + "logout.jsp';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                printJspPage(req, res, WebUtil.JspURL + "common/msg.jsp");
            }
        }
    }

    protected abstract void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException;

    protected void printExceptionPage(HttpServletRequest req, HttpServletResponse res, Exception e) {
        Logger.debug.println(this, "Exception 오류 :");

        if (e instanceof com.sns.jdf.ConfigurationException) {
            Logger.debug.println(this, "ConfigurationException 오류 :");
            try {
                req.setAttribute("error", new GeneralException(e));
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(WebUtil.ErrorPage);
                dispatcher.forward(req, res);
            } catch (Exception ex) {
                Logger.debug.println(this, "ErrorPage 오류 :" + ex.toString());
            }
        } else if (e instanceof GeneralException) {
            Logger.debug.println(this, "GeneralException 오류 :");
            try {
                req.setAttribute("error", (GeneralException) e);
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(WebUtil.ErrorPage);
                dispatcher.forward(req, res);
            } catch (Exception ex) {
                Logger.debug.println(this, "ErrorPage 오류 :" + ex.toString());
            }
        } else {
            Logger.debug.println(this, "Exception 오류 :");
            try {
                req.setAttribute("error", e);
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(WebUtil.ErrorPage);
                dispatcher.forward(req, res);
            } catch (Exception ex) {
                Logger.debug.println(this, "ErrorPage 오류 :" + ex.toString());
            }
        }
    }

    protected boolean isLogin(HttpSession session) {

        WebUserData user = (WebUserData) session.getAttribute("user");

        if (user == null)
            return false;

        String login_stat = user.login_stat;
        Logger.debug.println(this, "isLogin login_stat : " + login_stat);

        if (login_stat == null || !login_stat.equals("Y")) {
            return false;
        } else {
            return true;
        }
    }

    protected boolean checkMenuAuth(HttpServletRequest request, HttpServletResponse response, String sHLFCD) throws GeneralException {

        WebUserData user = WebUtil.getSessionUser(request);

        MenuInputData menuInputData = WebUtil.getBox(request).createEntity(MenuInputData.class);
        menuInputData.I_PERNR = user.empNo;
        menuInputData.I_IP = user.remoteIP;
        menuInputData.setI_BUKRS(user.companyCode);

        for (MenuCodeData menu : new SysMenuListRFC().getMenuList(menuInputData)) {
            if (menu != null && menu.FCODE != null && !StringUtils.isEmpty(menu.FCODE) && sHLFCD.equals(menu.FCODE)) {
                Logger.debug.println(menu.FCODE);
                return true;
            }
        }

        moveMsgPage(request, response, g.getMessage("MSG.COMMON.0060"), "history.back();");// 해당 페이지에 권한이 없습니다.

        return false;
    }

    /**
     * 로그인 사용자가 지정 조직(deptId)에 관련된 data 조회 권한을 가지고 있는지 여부 확인, 조직 선택 구분은 기본값
     * 
     * @param request
     * @param response
     * @param deptId
     * @return
     * @throws GeneralException
     */
    protected boolean checkBelongGroup(HttpServletRequest request, HttpServletResponse response, String deptId) throws GeneralException {

        WebUserData user = WebUtil.getSessionUser(request);

        String I_AUTHOR = null;
        if (user.e_authorization.indexOf("M") > -1)
            I_AUTHOR = "M";
        else if (user.e_authorization.indexOf("H") > -1)
            I_AUTHOR = "H";
        else if (user.e_authorization.indexOf("S") > -1)
            I_AUTHOR = "S";
        else
            I_AUTHOR = "";

        return checkBelongGroup(request, response, deptId, "", I_AUTHOR);
    }

    /**
     * 사용자가 해당 부서에 권한이 있는여부 확인
     * 
     * @param request
     * @param response
     * @param deptId
     * @param I_GUBUN
     * @return
     * @throws GeneralException
     */
    protected boolean checkBelongGroup(HttpServletRequest request, HttpServletResponse response, String deptId, String I_GUBUN) throws GeneralException {

        /*
         * @$ 웹보안진단 rdcamel
         * 해당 사번이 조직을 조회 할수 있는지 체크
         */
        WebUserData user = WebUtil.getSessionUser(request);
        String I_AUTHOR = "";

        if (user.e_authorization.indexOf("M") > -1)
            I_AUTHOR = "M";
        else if (user.e_authorization.indexOf("H") > -1)
            I_AUTHOR = "H";
        else if (user.e_authorization.indexOf("S") > -1)
            I_AUTHOR = "S";

        return checkBelongGroup(request, response, deptId, I_GUBUN, I_AUTHOR);
    }

    /**
     * 로그인 사용자가 지정 조직(deptId)에 관련된 data 조회 권한을 가지고 있는지 여부 확인
     * 
     * @param request
     * @param response
     * @param deptId Data를 조회하고자 하는 조직ID
     * @param I_GUBUN 조직 선택 구분
     * @param I_AUTHOR
     * @return
     * @throws GeneralException
     */
    protected boolean checkBelongGroup(HttpServletRequest request, HttpServletResponse response, String deptId, String I_GUBUN, String I_AUTHOR) throws GeneralException {

        /*
         * @$ 웹보안진단 rdcamel
         * 해당 사번이 조직을 조회 할수 있는지 체크
         */
        SysAuthInput inputData = new SysAuthInput();
        inputData.I_CHKGB = "3";
        // inputData.I_DEPT = WebUtil.getSessionUser(request).empNo;
        inputData.I_PERNR = WebUtil.getSessionUser(request).empNo;
        inputData.I_ORGEH = deptId;
        inputData.I_AUTHOR = I_AUTHOR;
        inputData.I_GUBUN = I_GUBUN;

        if (!new SysAuthRFC().isAuth(inputData)) {
            moveMsgPage(request, response, g.getMessage("MSG.F.F46.0002"), "history.back();");
            return false;
        }
        return true;
    }

    /**
     * 로그인 사용자가 지정 사번(I_PERNR)에 관련된 data 조회 권한을 가지고 있는지 여부 확인
     * 
     * @param request
     * @param response
     * @param I_PERNR Data를 조회하고자 하는 사번
     * @param I_RETIR 퇴직자 포함 여부
     * @return
     * @throws GeneralException
     */
    protected boolean checkBelongPerson(HttpServletRequest request, HttpServletResponse response, String I_PERNR, String I_RETIR) throws GeneralException {

        /*
         * @$ 웹보안진단 rdcamel
         * 해당 사번이 조직을 조회 할수 있는지 체크
         */
        SysAuthInput inputData = new SysAuthInput();
        inputData.I_CHKGB = "2";
        inputData.I_DEPT = WebUtil.getSessionUser(request).empNo;
        inputData.I_PERNR = I_PERNR;
        inputData.I_RETIR = I_RETIR;

        if (!new SysAuthRFC().isAuth(inputData)) {
            moveMsgPage(request, response, g.getMessage("MSG.D.D12.0024"), "history.back();");
            return false;
        }
        return true;
    }

    /**
     * 로그인 사용자가 대상 조직(I_ORGEH) 또는 대상 사번(I_PERNR)에 대한 data 조회 권한을 가지고 있는지 여부 확인
     * 
     * @param request
     * @param response
     * @param inputData
     * @return
     * @throws GeneralException
     */
    protected boolean checkBelong(HttpServletRequest request, HttpServletResponse response, SysAuthInput inputData) throws GeneralException {

        inputData.setI_DEPT(WebUtil.getSessionUser(request).empNo);

        if (!new SysAuthRFC().isAuth(inputData)) {
            moveMsgPage(request, response, g.getMessage("MSG.D.D12.0024"), "history.back();");
            return false;
        }
        return true;
    }

    protected void moveMsgPage(HttpServletRequest request, HttpServletResponse response, String msg, String url) throws GeneralException {
        request.setAttribute("msg", msg);
        request.setAttribute("url", url);
        printJspPage(request, response, WebUtil.JspURL + "common/msg.jsp");
    }

    protected void moveCautionPage(HttpServletRequest request, HttpServletResponse response, String msg, String url) throws GeneralException {
        request.setAttribute("msg", msg);
        request.setAttribute("url", url);
        printJspPage(request, response, WebUtil.JspURL + "common/caution.jsp");
    }

    /**
     * 대리신청시 해당 사번에 조회 권한이 잇는지 여부 확인
     * 
     * @param box
     * @param loginUser
     * @return
     * @throws GeneralException
     */
    protected String getPERNR(Box box, WebUserData loginUser) throws GeneralException {
        String PERNR = box.get("PERNR", loginUser.empNo);
        if (!"Y".equals(loginUser.e_representative))
            PERNR = loginUser.empNo;

        if (!loginUser.empNo.equals(PERNR)) {
            /* 대상 사번이 신청 대상 가능인지 확인 */
            SysAuthInput inputData = new SysAuthInput();
            inputData.I_CHKGB = "2";
            inputData.I_DEPT = loginUser.empNo;
            inputData.I_PERNR = PERNR;

            SysAuthRFC sysAuthRFC = new SysAuthRFC();
            if (!sysAuthRFC.isAuth(inputData))
                PERNR = loginUser.empNo;

        }
        return PERNR;
    }

    /**
     * 2016/12/22 권한예외설정; 아래 직책들은 월급여, 연급여, 채권가압류메뉴접근금지
     * FQ0 생산파트장
     * GB1 실장
     * GD0 반장
     * GG2 전문과장
     */
    protected boolean isBlocklist(WebUserData user) {
        if (user.e_jikkb.equals("FQ0") || user.e_jikkb.equals("GB1") || user.e_jikkb.equals("GD0") || user.e_jikkb.equals("GG2")) {
            return true;
        } else
            return false;
    }
    /*
    *   getContext() method 는 servlet 에서 호출한다
    *
    *   ehr.ejbs.SubtypeEJB subtype = new ehr.ejbs.SubtypeEJB();
    *   java.util.Vector vt = subtype.getSubtype( webUserId, infty, molga, getContext() );
    *
    */

    /*
    *
    *   iPlanet에서만 활성화....
    *
    protected com.kivasoft.IContext getContext(){
    
        return ( ( com.netscape.server.servlet.platformhttp.PlatformServletContext )
            getServletContext() ).getContext();
    }
    */
}