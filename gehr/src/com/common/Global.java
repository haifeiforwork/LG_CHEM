/**
 * 2018/06/12 rdcamel [CSR ID:3701161] 모바일 초과근무 신청/결재 로직 수정 요청 건
 */
package com.common;

import com.common.constant.Server;
import com.common.vo.BodyContainer;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.util.WebUtil;
import hris.common.WebUserData;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Locale;

public class Global {

    private MessageResolver messageResolver;

    public static String SAP_TYPE = "SAP_TYPE";

    public MessageResolver getMessageResolver() {
        if (messageResolver == null) messageResolver = Utils.getBean("messageResolver");
        return messageResolver;
    }

    public void setMessageResolver(MessageResolver messageResolver) {
        this.messageResolver = messageResolver;
    }

    public Locale getLocale() {
        Locale locale = Locale.KOREAN;

        try{
        	if(getMessageResolver().getLocale() != null)//[CSR ID:3701161] 모바일 의 경우, locale 값이 없음. 없을 경우 default 로 가져올 수 있도록 함.
        		locale = getMessageResolver().getLocale();
        } catch (Exception e) {
            Logger.info.println("getMessageResolver().getLocale() error! " + e.getMessage());
        }
        return locale;
    }

    /**
     * messageKey에 해당 하는 메세지를 가져온다. Locale은 기본 Locale
     *
     * @param messageKey
     * @return
     */
    public String getMessage(String messageKey) {
        return getMessageResolver().getMessage(messageKey, null, getLocale());
    }

    /**
     * messageKey에 해당하는 메세지에 args를 replace 하여 리턴 Locale은 기본 Locale
     * ex) hello.message = hello {0} !!
     *
     * @param messageKey
     * @param args
     * @return
     */
    public String getMessage(String messageKey, String... args) {
        return getMessageResolver().getMessage(messageKey, args, getLocale());
    }

    /**
     * messageKey에 해당하는 메세지에 args를 replace 하여 리턴
     *
     * @param messageKey
     * @param args
     * @param locale
     * @return
     */
    public String getMessage(String messageKey, String[] args, Locale locale) {
        return getMessageResolver().getMessage(messageKey, args, locale);
    }

    /**
     * ehr.properties에서 값을 가져옴
     *
     * @param key
     * @return
     */
    public String getProperty(String key) {
        return getMessageResolver().getProperty(key);
    }

    /**
     * session에 등록된 사용자 정보
     *
     * @param request
     * @return
     */
    public WebUserData getSessionUser(HttpServletRequest request) {
        return WebUtil.getSessionUser(request);
    }

    public SAPType getSapType() {
        SAPType result = SAPType.LOCAL;

        try {
            WebUserData sessionUser = getSessionUser(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
            if(sessionUser != null && sessionUser.sapType != null)  result = sessionUser.sapType;
        } catch (Exception e) {
            Logger.err.println(e);
        }

        return result;
    }

    /**
     * 테스트 용도 해당 시스템으로 접근
     * @return
     */
    public Server getServer() {
        try {
            HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession(false);
            if(session != null) {
                Server server = (Server) session.getAttribute("GEHR_CONNECT_SERVER");
                if(server != null) return server;
            }
        } catch (Exception e) {
            Logger.err.println(e);
        }

        return Server.DEFAULT;
    }

    public BodyContainer getBodyContainer() {
        return new BodyContainer();
    }

    public String getServlet() {
        return WebUtil.ServletURL;
    }

    public String getImage() {
        return WebUtil.ImageURL;
    }

    public String getJsp() {
        return WebUtil.JspURL;
    }

    public String getRequestPageName(HttpServletRequest request) {
        return getRequestPageName(request, null);
    }

    public String getRequestPageName(HttpServletRequest request, String defaultPage) {
        return ObjectUtils.toString(StringUtils.replace(request.getParameter("RequestPageName"), "|", "&"), defaultPage);
    }

    public String getCurrentURL(HttpServletRequest request) {
        String url = (String) request.getAttribute("javax.servlet.include.request_uri");

        if(StringUtils.isBlank(url)){
            if (request.getQueryString() != null) {
                url = request.getRequestURI() + "?" + request.getQueryString();
            } else {
                url = request.getRequestURI();
            }
        }

        return url;
    }
}
