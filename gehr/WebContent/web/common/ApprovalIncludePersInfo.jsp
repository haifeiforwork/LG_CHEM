<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="hris.common.*" %>
<% PersInfoData    persInfo            = (PersInfoData) request.getAttribute("PersInfoData"); %>

<div class="tableArea">
	<div class="table">
	  <table width="780" class="tableGeneral">
	    <tr>
	      <th width="40"><spring:message code="MSG.A.A01.0005" /><!-- 사번 --></td>
	      <td width="80"><%=persInfo.PERNR%><input type="hidden" name="persInfo_PERNR" value="<%=persInfo.PERNR%>"></td>
		  <th class="th02" width="40"><spring:message code="MSG.APPROVAL.0013" /><!-- 성명 --></th>
		  <td><%=persInfo.ENAME%></td>
		  <th width="40" class="th02"><spring:message code="LABEL.COMMON.0008" /><!-- 직위 --></th>
		  <td width="70"><%=persInfo.TITEL%></td>
		  <th width="40" class="th02"><spring:message code="LABEL.COMMON.0009" /><!-- 직책 --></th>
		  <td width="70"><%=persInfo.TITL2%></td>
		  <th width="40" class="th02"><spring:message code="LABEL.COMMON.0007" /><!-- 부서 --></th>
		  <td><%=persInfo.ORGTX%></td>
	    </tr>
	  </table>
	</div>
</div>