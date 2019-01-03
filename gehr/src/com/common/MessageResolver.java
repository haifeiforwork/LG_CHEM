package com.common;

import java.util.Locale;
import java.util.Properties;

import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.util.WebUtils;

public class MessageResolver { 

	public Locale getLocale() {
		return (Locale) WebUtils.getSessionAttribute(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest(), 
				SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);
	}
	/**
	 * messageKey�� �ش� �ϴ� �޼����� �����´�. Locale�� �⺻ Locale
	 * @param messageKey
	 * @return
	 */
	public String getMessage(String messageKey) {
		return getMessage(messageKey, null, getLocale());
	}
	
	/**
	 * messageKey�� �ش��ϴ� �޼����� args�� replace �Ͽ� ���� Locale�� �⺻ Locale
	 * ex) hello.message = hello {0} !!
	 * @param messageKey
	 * @param args
	 * @return
	 */
	public String getMessage(String messageKey, String[] args) {
		return getMessage(messageKey, args, getLocale());
	}
	
	/**
	 * messageKey�� �ش��ϴ� �޼����� args�� replace �Ͽ� ����
	 * @param messageKey
	 * @param args
	 * @param locale
	 * @return
	 */
	public String getMessage(String messageKey, String[] args, Locale locale) {
		return Utils.getWebApplicationContext().getMessage(messageKey, args, locale);
	}
	
	
	/**
	 * ehr.properties���� ���� ������
	 * @param key
	 * @return
	 */
	public String getProperty(String key) {
    	return ((Properties) Utils.getBean("prop")).getProperty(key);
	}
}
