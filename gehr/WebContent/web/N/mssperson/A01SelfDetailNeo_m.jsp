<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>


<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--@elvariable id="resultData" type="hris.A.A01SelfDetailData"--%>

<c:set var="loginUser" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="user_m" value="<%=WebUtil.getSessionMSSUser(request)%>" />
<c:set var="isPop" value="${param.ViewOrg == 'Y'}" />

<%-- popup 일 경우 style 틀림? --%>
<tags:layout title="COMMON.MENU.ESS_PA_PERS_FILES" help="${empty param.ViewOrg ? 'X03PersonInfo.html' : ''}" pop="${isPop}">
    <form id="form1" name="form1" method="post">
    <%-- 사원 검색  --%>
    <c:if test="${empty param.ViewOrg}" >

        <tags:script>
            <script>
                function doSearchDetail() {
                    var frm = document.form1;
                    frm.action = "${g.servlet}hris.N.mssperson.A01SelfDetailNeoSV_m";
                    frm.target = "";
                    frm.submit();
                }
            </script>
        </tags:script>
        <jsp:include page="/web/common/includeSearchDeptPersons_m.jsp" >
            <jsp:param name="hideHeader" value="${param.first == 'true' and loginUser.empNo == user.empNo}"/>
        </jsp:include>
    </c:if>
        <input type="hidden" name="ViewOrg" id="ViewOrg" value="${param.ViewOrg}"/>
    </form>

    <c:choose>
        <c:when test="${O_CHECK_FLAG == 'N'}">
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="td09" align="center">
                        <font color="red"><spring:message code="MSG.A.A01.0075" /><%-- ※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.--%><br><br></font><!--@v1.1-->
                    </td>
                </tr>
            </table>
        </c:when>
        <c:when test="${user_m.e_mss == 'X'}">
            <%-- 인사담당만 인사기록부 조회할 수 있도 --%>
            <c:if test="${fn:indexOf(loginUser.e_authorization, 'H') >= 0}">
                <tags:script>
                    <script>
                        function go_Insaprint(){
                            window.open('${g.jsp}common/printFrame_insa.jsp', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=yes,menubar=yes,resizable=yes,width=1010,height=662,left=0,top=2");
                        }
                    </script>
                </tags:script>
                <div class="buttonArea ">
                    <ul class="btn_crud">
                        <li><a style="cursor:pointer;" class="unloading" onclick="go_Insaprint();"><span><spring:message code="MSG.A.MSS.CARD.VIEW"/></span></a></li>
                    </ul>
                </div>

            </c:if>


            <div class="clear"></div>

            <%-- 인사 기록부 헤더부분 --%>
            <self:self-header personData="${resultData}" pageType="M" />

            <%-- 탭 영역 --%>
            <self:self-tab tabType="M"/>

        </c:when>
    </c:choose>

    <c:if test="${isPop}" >
    <div class="buttonArea underList">
        <ul class="btn_crud">
            <li><a href="javascript:window.close();"><span><spring:message code="BUTTON.COMMON.CLOSE"/></span></a></li>
        </ul>
    </div>
    </c:if>


</tags:layout>


