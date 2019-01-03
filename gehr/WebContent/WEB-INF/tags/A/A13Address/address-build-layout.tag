<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%@ attribute name="help" type="java.lang.String"  %>
<%@ attribute name="buttonBody" type="com.common.vo.BodyContainer"  %>
<c:set var="help" value="${(empty help) ? 'A13Address.html' : help}" />
<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout title="MSG.A.A13.003" help="A13Address.html">
    <tags:script>
        <script>

            $(function() {
                try {
                    js_change();
                } catch(e) {}
            });

            function doSubmit() {
                document.form1.jobid.value = "first";
                document.form1.action = '${g.servlet}hris.A.A13Address.A13AddressListSV';
                document.form1.submit();
            }

            // 입력 버튼을 클릭하면 data null check을 한후 주소 유형을 check한 후 맞으면 입력 servlet(jobid="create")으로 이동한다.
            function doSubmit_Build() {
                if(!isValid("form1")) return;

                if (doMethod(validate, true)) { /*valuedate메소드 실행*/

                    // 기존에 주소유형이 같은 것이 있으면 error 메시지를 띄운다.
                    var subty = document.form1.SUBTY.value;
                    var _process = true;
                    $(".subtype").each(function() {
                        if(_.isEqual(subty, $(this).val())) _process = false;
                    })

                    if(!_process) {
                        alert("<spring:message code="MSG.A.A13.038"/>"); /*주소유형이 존재합니다. 수정을 통해 변경하세요.*/
                        document.form1.SUBTY.focus();
                        return;
                    }

                    if(!confirm("<spring:message code="MSG.COMMON.SAVE.CONFIRM" />")) {
                        return;
                    } // end if

                    doMethod(beforeSubmit); /*beforeSubmit메소드 실행*/

                    document.form1.jobid.value = "create";
                    document.form1.action = '${g.servlet}hris.A.A13Address.A13AddressBuildSV';
                    document.form1.submit();
                }
            }

        </script>
    </tags:script>
    <div class="tableArea">
        <form id="form1" name="form1" method="post">
            <input type="hidden" name="subView" value="${param.subView}" />
            <input type="hidden" name="jobid" value="">

            <%-- 내용부 --%>
            <jsp:doBody />

            <%-- button --%>
            <div class="buttonArea">
                <ul class="btn_crud">
                    <li><a href="javascript:;" onclick="doSubmit_Build();"><span><spring:message code="BUTTON.COMMON.SAVE" /><%--저장--%></span></a></li>
                    <li><a href="javascript:;" onclick="doSubmit();"><span><spring:message code="BUTTON.COMMON.LIST" /><%--목록--%></span></a></li>
                </ul>
            </div>

        <c:forEach var="addressType" items="${a13AddressListData_vt}">
            <input type="hidden" class="subtype" name="subtype" value='${addressType.SUBTY }'>
        </c:forEach>
        </form>
    </div>
</tags:layout>
