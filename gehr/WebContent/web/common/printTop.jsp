<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="commonProcess.jsp" %>

<jsp:include page="/include/header.jsp" />
<script language="javascript">
    function f_print(){
              parent.beprintedpage.focus();
              parent.beprintedpage.print();
    }              
</script>
<body bgcolor="#FFFFFF" text="#000000">
<div style="width: 650px;">

<div class="buttonArea">
  <ul class="btn_crud">
    <li><a href="javascript:;" onclick="f_print();"><span><spring:message code="BUTTON.COMMON.PRINT" /><%--인쇄--%></span></a></li>
  </ul>
</div>
</div>

</body>
<%--<table width="624" border="0" cellspacing="0" cellpadding="0" height="30">
  <tr>
    <td align="right" valign="bottom">
      <a href="javascript:f_print();">
      <img src="<%= WebUtil.ImageURL %>btn_print.gif" border="0"></a> 
      </td>
  </tr>
</table>--%>
<jsp:include page="/include/footer.jsp" />
