<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육이력                                                    */
/*   Program Name : 교육이력                                                    */
/*   Program ID   : C03LearnDetail.jsp                                          */
/*   Description  : 교육 이력 조회                                              */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-21  윤정현                                          */
/*                  2008-09-19  lsa [CSR ID:1331138]                            */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-trainig" tagdir="/WEB-INF/tags/C/C03" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<tags:layout title="COMMON.MENU.ESS_PA_TRAI_HIST" script="jquery.tablesorter.min.js" css="/blue/style.css">
    <tags:script>
        <script>

            function doSearch() {
                if(isValid("form1")) {
                    $("#form1").attr("target", "").attr("action", "").submit();
                }
            }
        </script>
    </tags:script>

    <div class="tableInquiry" >
        <div  class="inner">
            <form id="form1" name="form1" method="post" >
            <span class="textPink">*</span><spring:message code="LABEL.E.E21.0008"/><%--조회기간--%>
                <input type="text" id="I_BEGDA" name="I_BEGDA" class="date required" value="${f:printDate(I_BEGDA)}" size="10" placeholder="<spring:message code="LABEL.C.C03.0011" /><!-- 조회기간 시작일 -->">
                &nbsp; ~
                <input type="text" id="I_ENDDA" name="I_ENDDA" class="date required" value="${f:printDate(I_ENDDA)}" size="10" placeholder="<spring:message code="LABEL.C.C03.0012" /><!-- 조회기간 종료일 -->" >
            &nbsp;&nbsp;<spring:message code="LABEL.C.C03.0013" /><!-- (예 : 2005.01.28) -->
            &nbsp;&nbsp;
            <div class="tableBtnSearch tableBtnSearch2">
                <a class="search" href="javascript:;" onclick="doSearch();"><span><spring:message code="BUTTON.COMMON.SEARCH" /><!-- 조회 --></span></a>
            </div>
            <c:if test="${user.area == 'PL'}" >
            <tags:script>
                <script>
                    function openPopHistory() {
                        window.open('${g.servlet}hris.C.C03LearnDetailHistoryPopSV', 'tariningHistoryPop', "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,width=900,height=662,left=0,top=2");
                    }
                </script>
            </tags:script>
            <ul class="btn_mdl" style="display: inline;padding-left: 50px;" >
                <li><a href="javascript:;" onclick="openPopHistory();"><span><spring:message code="TITLE.POP.C.C03"/><%--입사전 교육이력--%></span></a></li>
            </ul>
            </c:if>
            </form>
        </div>
    </div>

    <%-- 결과 리스트  --%>
    <tags-trainig:training-list />

</tags:layout>

