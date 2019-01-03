<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:set var="user_m" value="<%=WebUtil.getSessionMSSUser(request)%>"/>
<tags:layout title="COMMON.MENU.MSS_PD_PERS_INFO">
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

            /*function resizeIframe(height) {
             document.all.listFrame.height = height + 20;
             }*/

            function doSearchDetail() {
                if(window.frames['listFrame']) window.frames['listFrame'].doSearch();
                else {
                    document.form1.action = "";
                    document.form1.target = "";
                    document.form1.submit();
                }
            }
        </script>
    </tags:script>

    <form id="form1" name="form1" method="post" >
    <jsp:include page="/web/common/includeSearchDeptPersons_m.jsp" />
    </form>

    <c:if test="${user_m.e_mss == 'X'}">
    <%-- 탭 영역 --%>
    <div class="contentBody">
        <!-- 탭 시작 -->
        <div class="tabArea">
            <ul class="tab">
                <li><a href="javascript:;" class="-tab-link" data-url="${g.servlet}hris.C.C03LearnDetailSV_m" ><spring:message code="TAB.COMMON.0058" /><%--교육--%></a></li>
                <li><a href="javascript:;" class="-tab-link" data-url="${g.servlet}hris.C.C09GetTripList_m"><spring:message code="TAB.COMMON.0059" /><%--경력증명서--%></a></li>
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
    </c:if>
    <form id="urlForm" name="urlForm" target="listFrame" method="post">
        <input type="hidden" name="subView" value="Y">
        <input type="hidden" name="pageType" value="${pageType}">
    </form>
</tags:layout>
