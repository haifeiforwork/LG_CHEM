<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page contentType="text/html; charset=utf-8" %>


<body style="margin-bottom:0;padding-bottom:0;"
      <c:if test="${param.subView eq 'Y' || param.click eq 'Y'}" >oncontextmenu="return false" ondragstart="return false" onselectstart="return false"</c:if>>
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780">
              <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                    <c:if test="${!empty param.title}">
                   <td class="subhead"><h2><spring:message code="${param.title}"/></h2></td>
                    </c:if>
                  <td align="right"></td>
                </tr>
                <tr>
          <td height="10" colspan="2"></td>
        </tr>
              </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table>
            </td>
          </tr>
