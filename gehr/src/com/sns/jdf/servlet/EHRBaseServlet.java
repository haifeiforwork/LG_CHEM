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
        } else {      // �ӽ��׽�Ʈ�� - ���ǰ˻� ����

            if (isLogin(session)) {
                Logger.debug.println(this, "EHRBaseServlet : islogin = true");
                try {
                    performTask(req, res);

                } catch (GeneralException e) {
                    Logger.debug.println(this, "perfromTesk���� �����߻�");
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
        Logger.debug.println(this, "Exception ���� :");

        if (e instanceof com.sns.jdf.ConfigurationException) {
            Logger.debug.println(this, "ConfigurationException ���� :");
            try {
                req.setAttribute("error", new GeneralException(e));
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(WebUtil.ErrorPage);
                dispatcher.forward(req, res);
            } catch (Exception ex) {
                Logger.debug.println(this, "ErrorPage ���� :" + ex.toString());
            }
        } else if (e instanceof GeneralException) {
            Logger.debug.println(this, "GeneralException ���� :");
            try {
                req.setAttribute("error", (GeneralException) e);
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(WebUtil.ErrorPage);
                dispatcher.forward(req, res);
            } catch (Exception ex) {
                Logger.debug.println(this, "ErrorPage ���� :" + ex.toString());
            }
        } else {
            Logger.debug.println(this, "Exception ���� :");
            try {
                req.setAttribute("error", e);
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(WebUtil.ErrorPage);
                dispatcher.forward(req, res);
            } catch (Exception ex) {
                Logger.debug.println(this, "ErrorPage ���� :" + ex.toString());
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

        moveMsgPage(request, response, g.getMessage("MSG.COMMON.0060"), "history.back();");// �ش� �������� ������ �����ϴ�.

        return false;
    }

    /**
     * �α��� ����ڰ� ���� ����(deptId)�� ���õ� data ��ȸ ������ ������ �ִ��� ���� Ȯ��, ���� ���� ������ �⺻��
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
     * ����ڰ� �ش� �μ��� ������ �ִ¿��� Ȯ��
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
         * @$ ���������� rdcamel
         * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
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
     * �α��� ����ڰ� ���� ����(deptId)�� ���õ� data ��ȸ ������ ������ �ִ��� ���� Ȯ��
     * 
     * @param request
     * @param response
     * @param deptId Data�� ��ȸ�ϰ��� �ϴ� ����ID
     * @param I_GUBUN ���� ���� ����
     * @param I_AUTHOR
     * @return
     * @throws GeneralException
     */
    protected boolean checkBelongGroup(HttpServletRequest request, HttpServletResponse response, String deptId, String I_GUBUN, String I_AUTHOR) throws GeneralException {

        /*
         * @$ ���������� rdcamel
         * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
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
     * �α��� ����ڰ� ���� ���(I_PERNR)�� ���õ� data ��ȸ ������ ������ �ִ��� ���� Ȯ��
     * 
     * @param request
     * @param response
     * @param I_PERNR Data�� ��ȸ�ϰ��� �ϴ� ���
     * @param I_RETIR ������ ���� ����
     * @return
     * @throws GeneralException
     */
    protected boolean checkBelongPerson(HttpServletRequest request, HttpServletResponse response, String I_PERNR, String I_RETIR) throws GeneralException {

        /*
         * @$ ���������� rdcamel
         * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
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
     * �α��� ����ڰ� ��� ����(I_ORGEH) �Ǵ� ��� ���(I_PERNR)�� ���� data ��ȸ ������ ������ �ִ��� ���� Ȯ��
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
     * �븮��û�� �ش� ����� ��ȸ ������ �մ��� ���� Ȯ��
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
            /* ��� ����� ��û ��� �������� Ȯ�� */
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
     * 2016/12/22 ���ѿ��ܼ���; �Ʒ� ��å���� ���޿�, ���޿�, ä�ǰ��з��޴����ٱ���
     * FQ0 ������Ʈ��
     * GB1 ����
     * GD0 ����
     * GG2 ��������
     */
    protected boolean isBlocklist(WebUserData user) {
        if (user.e_jikkb.equals("FQ0") || user.e_jikkb.equals("GB1") || user.e_jikkb.equals("GD0") || user.e_jikkb.equals("GG2")) {
            return true;
        } else
            return false;
    }
    /*
    *   getContext() method �� servlet ���� ȣ���Ѵ�
    *
    *   ehr.ejbs.SubtypeEJB subtype = new ehr.ejbs.SubtypeEJB();
    *   java.util.Vector vt = subtype.getSubtype( webUserId, infty, molga, getContext() );
    *
    */

    /*
    *
    *   iPlanet������ Ȱ��ȭ....
    *
    protected com.kivasoft.IContext getContext(){
    
        return ( ( com.netscape.server.servlet.platformhttp.PlatformServletContext )
            getServletContext() ).getContext();
    }
    */
}