<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 교육이력                                                    */
/*   Program Name : 교육이력                                                    */
/*   Program ID   : C03LearnDetail_m.jsp                                        */
/*   Description  : 교육 이력 조회                                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :                                                             */
/*                  2008-09-19  lsa [CSR ID:1331138]                            */
/*                                                                              */
/*                  013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags-trainig" tagdir="/WEB-INF/tags/C/C03" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="user_m" value="<%=WebUtil.getSessionMSSUser(request) %>" />

<tags:layout script="jquery.tablesorter.min.js" css="blue/style.css">
    <tags:script>
        <script>

            function doSearch() {
                if(isValid("form1")) {
                    $("#form1").attr("target", "").attr("action", "").submit();
                }
            }

            $(function() {
//                $("#I_BEGDA").datepicker("option", "maxDate", "+1w");

               /* $("#I_BEGDA").on("change", function() {
                    alert($.datepicker.parseDate("yy.mm.dd", $("#I_BEGDA").val()));
                    $("#I_ENDDA").datepicker({minDate : new Date()});
                });

                $("#I_ENDDA").on("change", function() {
                    alert($.datepicker.parseDate("yy.mm.dd", $("#I_ENDDA").val()));
                    $("#I_BEGDA").datepicker({maxDate : $.datepicker.parseDate("yy.mm.dd", $("#I_ENDDA").val())});
                });*/
            });

            function getDate( element ) {
                var date;
                try {
                    date = $.datepicker.parseDate( dateFormat, element.value );
                } catch( error ) {
                    date = null;
                }

                return date;
            }

        </script>
    </tags:script>
    <form id="form1" name="form1" method="post" >
        <c:choose>
            <c:when test="${empty user_m}">
                <div class="listArea">
                    <div class="table">
                        <table class="listTable" >
                            <tags:table-row-nodata list="${emptyList}" col="1" />
                        </table>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="tableInquiry" >
                    <div  class="inner">
                        <span class="textPink">*</span><spring:message code="BUTTON.COMMON.SEARCH" /><!-- 조회기간 -->
                        <input type="text" id="I_BEGDA" name="I_BEGDA" class="required date fromDate" data-to-date="I_ENDDA" value="${f:printDate(I_BEGDA)}" size="10" placeholder="<spring:message code="LABEL.C.C03.0011" /><!-- 조회기간 시작일 -->">
                        &nbsp; ~
                        <input type="text" id="I_ENDDA" name="I_ENDDA" class="required date toDate" data-from-date="I_BEGDA" value="${f:printDate(I_ENDDA)}" size="10" placeholder="<spring:message code="LABEL.C.C03.0012" /><!-- 조회기간 종료일 -->" >
                        &nbsp;&nbsp;<spring:message code="LABEL.C.C03.0013" /><!-- (예 : 2005.01.28) -->
                        &nbsp;&nbsp;
                        <div class="tableBtnSearch tableBtnSearch2">
                            <a class="search" href="javascript:;" onclick="doSearch();"><span><spring:message code="BUTTON.COMMON.SEARCH" /><!-- 조회 --></span></a>
                        </div>
                        <c:if test="${user.area == 'PL'}" >
                            <tags:script>
                                <script>
                                    function openPopHistory() {
                                        window.open('${g.servlet}hris.C.C03LearnDetailHistoryPopSV_m', 'tariningHistoryPop', "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,width=900,height=662,left=0,top=2");
                                    }
                                </script>
                            </tags:script>
                            <ul class="btn_mdl" style="display: inline;padding-left: 50px;" >
                                <li><a href="javascript:;" onclick="openPopHistory();"><span><spring:message code="TITLE.POP.C.C03" /><!-- 입사전 교육이력 --></span></a></li>
                            </ul>
                        </c:if>

                    </div>
                </div>
                <%-- 결과 리스트  --%>
                <tags-trainig:training-list />
            </c:otherwise>
        </c:choose>
    </form>
</tags:layout>


