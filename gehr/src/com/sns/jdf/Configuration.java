package com.sns.jdf;

import com.common.Utils;
import com.common.constant.Server;
import com.sns.jdf.util.WebUtil;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class Configuration extends GeneralConfiguration {

	static {
		load();
	}

	public static void load() {
		load(Server.DEFAULT);
	}

	public static void load(Server server) {
		props = Utils.getBean("prop");

		try{
			WebUtil.contextPath = StringUtils.defaultString(
					((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getContextPath());
		} catch(Exception e) {
			WebUtil.contextPath = StringUtils.defaultString(props.getProperty("com.sns.jdf.contextPath"));
		}

		WebUtil.JspPath      = props.getProperty("com.sns.jdf.JspPath");
		WebUtil.ServletPath  = WebUtil.contextPath + props.getProperty("com.sns.jdf.ServletPath");
		WebUtil.JspURL      = props.getProperty("com.sns.jdf.JspURL");
		WebUtil.ServletURL  = props.getProperty("com.sns.jdf.ServletURL");
		WebUtil.ImageURL    = WebUtil.contextPath + props.getProperty("com.sns.jdf.ImageURL");
		WebUtil.DefaultPage = props.getProperty("com.sns.jdf.DefaultPage");
		WebUtil.ErrorPage   = props.getProperty("com.sns.jdf.ErrorPage");

		Logger.debug("-------- init class : " + props);
	}

	public Configuration() throws ConfigurationException {
		super();
	}

	public Configuration(Server server) throws ConfigurationException {
		super();

		if(server == null || server == server.DEFAULT) props = Utils.getBean("prop");
		else props = Utils.getBean(server.toString() + "prop");

		try{
			WebUtil.contextPath = StringUtils.defaultString(
					((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getContextPath());
		} catch(Exception e) {
			WebUtil.contextPath = StringUtils.defaultString(props.getProperty("com.sns.jdf.contextPath"));
		}

		WebUtil.JspPath      = props.getProperty("com.sns.jdf.JspPath");
		WebUtil.ServletPath  = WebUtil.contextPath + props.getProperty("com.sns.jdf.ServletPath");
		WebUtil.JspURL      = props.getProperty("com.sns.jdf.JspURL");
		WebUtil.ServletURL  = props.getProperty("com.sns.jdf.ServletURL");
		WebUtil.ImageURL    = WebUtil.contextPath + props.getProperty("com.sns.jdf.ImageURL");
		WebUtil.DefaultPage = props.getProperty("com.sns.jdf.DefaultPage");
		WebUtil.ErrorPage   = props.getProperty("com.sns.jdf.ErrorPage");

		Logger.debug("-------- init class : " + props);
	}


}
