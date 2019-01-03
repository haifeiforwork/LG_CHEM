<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%@ attribute name="data" type="hris.A.A13Address.A13AddressListData" required="true" %>
<%@ attribute name="help" type="java.lang.String"  %>
<%@ attribute name="buttonBody" type="com.common.vo.BodyContainer"  %>
<c:set var="help" value="${(empty help) ? 'A13Address.html' : help}" />

<tags:layout title="MSG.A.A13.002" help="A13Address.html">
    <tags:script>
        <script>
            function doSubmit() {
                document.form1.jobid.value = "first";
                document.form1.action = "${g.servlet}hris.A.A13Address.A13AddressListSV";
                document.form1.method = "post";
                document.form1.submit();
            }
        </script>
    </tags:script>
    <form id="form1" name="form1">
    <div class="tableArea">
        <input type="hidden" name="jobid"/>
        <jsp:doBody />
        <div class="buttonArea">
            <ul class="btn_crud">
                    ${buttonBody}
                <li><a href="javascript:;" onclick="doSubmit();"><span><spring:message code="BUTTON.COMMON.LIST"/><%--목록--%></span></a></li>
            </ul>
        </div>
    </div>
    </form>
</tags:layout>
