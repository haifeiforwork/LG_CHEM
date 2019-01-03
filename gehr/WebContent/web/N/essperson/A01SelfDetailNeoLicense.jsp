<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%--update [CSR ID:3440690] 베트남법인 GEHR 적용 요청 2017/07/21 eunha
      update [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 2017/11/06 eunha--%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />

<tags:layout>
	<self:self-license licenseList="${resultList}" isLiceseLink="false"  />
<%--[CSR ID:3440690] 베트남법인 GEHR 적용 요청 2017/07/21 eunha
[CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 2017/11/06 eunha

--%>
  <c:if test="${user.area != 'OT' and user.area != 'TH' }">
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a href="javascript:;" class="unloading" onclick="document.form1.submit();"><span><spring:message code="BUTTON.COMMON.INSERT"/><%--입력--%> </span></a>
		</ul>
	</div>
  </c:if>

	<form name="form1" id="form1" action="${g.servlet}hris.A.A17Licence.A17LicenceBuildSV" method="post">
		<input type="hidden" name="RequestPageName" value="${currentURL}"/>
	</form>


</tags:layout>
