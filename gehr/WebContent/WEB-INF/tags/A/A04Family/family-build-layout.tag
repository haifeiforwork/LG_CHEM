<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%@ attribute name="help" type="java.lang.String"  %>
<%@ attribute name="buttonBody" type="com.common.vo.BodyContainer"  %>
<c:set var="help" value="${(empty help) ? 'A13Address.html' : help}" />
<%--@elvariable id="g" type="com.common.Global"--%>

<tags:layout title="${isUpdate ? 'LABEL.A.A12.0021' : 'LABEL.A.A12.0011'}" help="A04Family.html">
    <tags:script>
        <script>

            $(function() {
                try {
                    js_change();
                } catch(e) {}
            });

            function doSubmit() {
                document.form1.jobid.value = "first";
                document.form1.action = "${g.servlet}hris.A.A04FamilyDetailSV";
                document.form1.submit();
            }

            // 입력 버튼을 클릭하면 data null check을 한후 주소 유형을 check한 후 맞으면 입력 servlet(jobid="create")으로 이동한다.
            function doSubmit_Build() {

                if(!isValid("form1")) return;

                if(!confirm("<spring:message code='MSG.A.A04.0002' />")) {  //Are you sure to save?
                    return;
                } // end if

                doMethod("beforeSubmit"); /*beforeSubmit메소드 실행*/

                document.form1.jobid.value = "${isUpdate ? 'change' : 'create'}";
                document.form1.action = '${g.servlet}hris.A.A12Family.${isUpdate ? 'A12FamilyChangeSV' : 'A12FamilyBuildSV'}';
                document.form1.submit();
            }

        </script>
    </tags:script>
    <form id="form1"  name="form1" method="post">
        <input type="hidden" name="subView" value="${param.subView}" />
        <input type="hidden" name="jobid" value="">
        <input type="hidden" name = "PERNR" value="${PERNR}">
            <%--2012-08-06 lixinxin@v1.7 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
        <input type="hidden" name = "E_PERSG" value="${PersonData.e_PERSG}">

            <%-- 내용부 --%>
        <jsp:doBody />

        <div class="buttonArea">
            <%-- button --%>
            <ul class="btn_crud">
                <li><a href="javascript:;" onclick="doSubmit_Build();"><span><spring:message code="BUTTON.COMMON.SAVE" /><%--저장--%></span></a></li>
                <li><a href="javascript:;" onclick="doSubmit();"><span><spring:message code="BUTTON.COMMON.LIST" /><%--목록--%></span></a></li>
            </ul>
        </div>
    </form>
</tags:layout>
