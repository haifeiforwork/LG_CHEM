<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ attribute name="list" type="java.util.Vector" required="true" %>
<%@ attribute name="col" type="java.lang.String" required="true" %>
<c:if test="${empty list}">
<tfoot>
<tr>
    <%-- 해당하는 데이타가 존재하지 않습니다. --%>
    <td class="lastCol" colspan="<%=col%>" id="-nodata-body"><spring:message code="MSG.COMMON.0004" /></td>
</tr>
</tfoot>
</c:if>
