<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<tags:layout title="COMMON.MENU.ESS_HRA_REME_INFO" unblock="false" >
    <script>
        blockFrame();
    </script>
    <tags:script>
        <script type="text/javascript">

            $(function() {
                $(".-tab-link").click(function() {
                    $(".tab").find(".selected").removeClass("selected");
                    $(this).addClass("selected");

                    document.all.urlForm.action = $(this).data("url");
                    document.all.urlForm.submit();

                    document.all.listFrame.height = "0";
                });

                $(".tab").find("a:first").trigger("click").addClass("selected");
            });

            function resizeIframe(height) {
                document.all.listFrame.height = height + 20;
            }

        </script>
    </tags:script>

    <%-- 탭 영역 --%>
    <div class="contentBody">
        <!-- 탭 시작 -->
        <div class="tabArea">
            <ul class="tab">
                <li><a href="javascript:;" class="-tab-link" data-url="${g.servlet}hris.D.D15EmpPayInfo.D15EmpPayBuildSV" ><spring:message code="TAB.COMMON.0049" /><%--지급/공제--%></a></li>
                <c:if test="${enableMemberFee == 'X'}">
                <li><a href="javascript:;" class="-tab-link" data-url="${g.servlet}hris.D.D30MembershipFee.D30MembershipFeeBuildSV"><spring:message code="TAB.COMMON.0050" /><%--회비--%></a></li>
                </c:if>
            </ul>
        </div>
    </div>

    <div class="frameWrapper">
        <!-- TAB 프레임  -->
        <script>
            function autoResize(target) {
                var iframeHeight =  target.contentWindow.document.body.scrollHeight;
                target.height = iframeHeight + 100;
            }
        </script>
        <iframe id="listFrame" onload="autoResize(this);"  name="listFrame" width="100%" height="" marginwidth="0" marginheight="0" scrolling="no" frameborder=0></iframe>
    </div>
    <form id="urlForm" name="urlForm" target="listFrame" method="post">
        <input type="hidden" name="subView" value="Y">
        <input type="hidden" name="pageType" value="${pageType}">
    </form>
</tags:layout>
