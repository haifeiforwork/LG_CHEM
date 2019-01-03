/**
 * 2018/06/12 rdcamel [CSR ID:3701161] ����� �ʰ��ٹ� ��û/���� ���� ���� ��û ��
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
        	if(getMessageResolver().getLocale() != null)//[CSR ID:3701161] ����� �� ���, locale ���� ����. ���� ��� default �� ������ �� �ֵ��� ��.
        		locale = getMessageResolver().getLocale();
        } catch (Exception e) {
            Logger.info.println("getMessageResolver().getLocale() error! " + e.getMessage());
        }
        return locale;
    }

    /**
     * messageKey�� �ش� �ϴ� �޼����� �����´�. Locale�� �⺻ Locale
     *
     * @param messageKey
     * @return
     */
    public String getMessage(String messageKey) {
        return getMessageResolver().getMessage(messageKey, null, getLocale());
    }

    /**
     * messageKey�� �ش��ϴ� �޼����� args�� replace �Ͽ� ���� Locale�� �⺻ Locale
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
     * messageKey�� �ش��ϴ� �޼����� args�� replace �Ͽ� ����
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
     * ehr.properties���� ���� ������
     *
     * @param key
     * @return
     */
    public String getProperty(String key) {
        return getMessageResolver().getProperty(key);
    }

    /**
     * session�� ��ϵ� ����� ����
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
     * �׽�Ʈ �뵵 �ش� �ý������� ����
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
