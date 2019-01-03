<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%--@elvariable id="resultData" type="hris.A.A01SelfDetailData"--%>
<tags:layout title="COMMON.MENU.ESS_PA_PERS_FILES">
    <%--
    B01ValuateDetailDB valuateDetailDB = new B01ValuateDetailDB();
    String StartDate = valuateDetailDB.getStartDate();
    <div class="buttonArea">
    <%  if (Long.parseLong(StartDate) <= Long.parseLong(resultData.til.getCurrentDate())) { %>
        <form id="insaForm" name="insaForm" method="post" action="<%= WebUtil.JspURL %>common/printFrame_insa.jsp" target="essPrintWindow">
            <input type="hidden" name="jobid2" value="">
            <input type="hidden" name="pernr" value="<%=resultData.til.encodeEmpNo(resultData.PERNR) %>">
            <input type="hidden" name="Screen" value="">
        </form>
        <!--[CSR ID:1558477] 인사기록부 개선 요청의 건-->
        <script>
            function go_Insaprint() {
                window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1010,height=662,left=0,top=2");
                document.insaForm.jobid2.value = "printSelf";//C20140210_84209
                document.insaForm.submit();
            }
        </script>
        <ul class="btn_crud">
            <li><a href="javascript:go_Insaprint();"><span>인사기록부 조회</span></a></li>
        </ul>
    <%  } %>
    </div>--%>
    <div class="clear"></div>

    <%-- 인사 기록부 헤더부분 --%>
    <self:self-header personData="${resultData}" />

    <%-- 탭 영역 --%>
    <self:self-tab tabType="E"/>

    <c:if test="${not empty param.RequestPageName}">
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:history.back()"><span><!--뒤로가기--><spring:message code="BUTTON.COMMON.BACK"/></span></a></li>
            </ul>
        </div>
    </c:if>

</tags:layout>
