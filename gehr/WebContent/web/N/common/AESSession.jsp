<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.N.EHRCommonUtil"%>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
	
	try{
		
		AESgenerUtil cu = new AESgenerUtil();   	
		session.removeAttribute("AESKEY");
		String sGetkey = cu.getKey();
		//
		session.setAttribute("AESKEY",sGetkey);
		
	}catch(Exception e){
	}
	
	
%>
