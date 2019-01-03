package com.sns.jdf;

import org.apache.tools.ant.util.DateUtils;

import javax.servlet.http.*;
import java.util.Calendar;
import java.util.Locale;

public class DefaultLoggerWriter extends LoggerWriter {

	public DefaultLoggerWriter(int mode) {
		super(mode);
	}

	protected String getPrefixInfo(Object o) {
		StringBuffer info = new StringBuffer();
		info.append("[").append(DateUtils.format(Calendar.getInstance(Locale.KOREA).getTime(), "yyyyMMdd HH:mm:ss")).append("]");
		info.append('[');

		if ( o == null ) {
			info.append("null");
		} 
		else if ( o instanceof HttpServletRequest ) {
			HttpServletRequest req =	(HttpServletRequest)o;
			info.append(req.getRequestURI() +",");
			String user = req.getRemoteUser();
			if ( user != null ) info.append(user+",");
			info.append(req.getRemoteAddr());
		}
		else {
			Class c = o.getClass();
			String fullname = c.getName();
			String name = null;
			int index = fullname.lastIndexOf('.');
			if ( index == -1 ) name = fullname;
			else name = fullname.substring(index+1);
			info.append(name);
		}

		if ( o == null ) 
			info.append("] ");
		else 
			info.append(":" + o.hashCode() + "] ");
			
		return info.toString();
	}
}
