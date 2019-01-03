<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.CORBA.iiop.Util"%>
<%@ page import="com.common.Utils"%>
<%@ page import="com.common.Global"%>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ include file="/include/includeCommon.jsp"%>
<%
	Logger.debug.println(this, "start login check");

    if (session == null) {
		Logger.debug.println(this, "session is null");

		String msg = g.getMessage("MSG.COMMON.0063"); // session 이 끊어졌습니다. 다시 로그인 해주세요.
        String url = "parent.location.href= '" + WebUtil.JspPath + "logout.jsp';";
         // request.setAttribute("msg", msg);
        request.setAttribute("url", url);
%>
		<jsp:forward page = "/web/common/msg.jsp" />
<%
		return;
	} // end if

    WebUserData commonProcessWebUserData  = (WebUserData)session.getValue("user");

	if (  commonProcessWebUserData == null
      ||  commonProcessWebUserData.login_stat == null
      || !commonProcessWebUserData.login_stat.equals("Y") ) {

		// 로그인이 안된 상태
		Logger.debug.println(this, "not Login");

		String msg = g.getMessage("MSG.COMMON.0064"); // 로그인 상태가 아닙니다. 다시 로그인 해주세요.
        String url = "parent.location.href= '" + WebUtil.JspPath + "logout.jsp';";
        // request.setAttribute("msg", msg);
        request.setAttribute("url", url);
%>
		<jsp:forward page = "/web/common/msg.jsp" />
<%
        Logger.debug.println(this, "end login check");

        return;
    } // end if
%>