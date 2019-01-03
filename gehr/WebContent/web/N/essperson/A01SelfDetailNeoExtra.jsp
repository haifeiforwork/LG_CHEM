<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<tags:layout always="false"><%--@elvariable id="extraData" type="hris.A.A01SelfDetailExtraData"--%>

	<%--<self:self-extra-data extraData="${extraData}" />--%>
<c:if test="${user.area == 'KR'}">
	<self:self-personal-address personalData="${personalData}" />

	<self:self-army extraData="${armyData}" />
</c:if>

	<self:self-school schoolList="${schoolList}" />

</tags:layout>
