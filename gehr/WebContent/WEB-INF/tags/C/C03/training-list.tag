<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="language" tagdir="/WEB-INF/tags/C/C05" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>

<style>
    .even {
        background-color : #f5f5f5
    }

    .listTable td {
        border-bottom : 1px solid #dddddd;
        background-color : #fff
    }
</style>
<tags:script>
    <style>
        .listTableHover:hover {
            background: #fff;
        }
    </style>
    <script>
        $(function() {
            $("#-training-table").tablesorter();

            $("#-training-table").bind("sortStart",function() {
                var $cols = $('#-training-table-body tr td:nth-child(1)');

                $cols.each(function() {
                    var $this = $(this);

                    $this.attr("rowSpan", 1);
                    $this.show();
                });
            });

            $("#-training-table").bind("sortEnd",function() {

                var $tr = $("#-training-table tbody tr");

                /*$("#-training-table .oddRow").removeClass("oddRow");
                $tr.each(function(idx) {
                    if(idx % 2 == 0) $(this).addClass("oddRow");
                });*/

                rowspan("-training-table-body", 1);
            });

            rowspan("-training-table-body", 1);
        });
    </script>
</tags:script>
<!--교육이수현황 리스트 테이블 시작-->

<div class="align_right"><span class="inlineComment">※ Y : <spring:message code="LABEL.C.C03.0001"/><%--이수--%>, N : <spring:message code="LABEL.C.C03.0002"/><%--미이수--%></span></div>

<!--교육이수현황 리스트 테이블 시작-->
<div class="listArea">
    <div class="table">
        <table id="-training-table" class="listTable tablesorter" >
            <colgroup>
                <col width="10%;"/>
                <col width="20%"/>
                <col width="15%;"/>
                <col />
                <col />
                <col />
                <col width="20%"/>
                <col />
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="LABEL.C.C03.0015"/><%--분류--%></th>
                <th><spring:message code="LABEL.C.C03.0003"/><%--과정명--%></th>
                <th><spring:message code="LABEL.C.C03.0004"/><%--교육기간--%></th>
                <th><spring:message code="LABEL.C.C03.0005"/><%--주관부서--%></th>
                <th><spring:message code="LABEL.C.C03.0006"/><%--이수--%></th>
                <th><spring:message code="LABEL.C.C03.0007"/><%--평가--%></th>
                <th><spring:message code="LABEL.C.C03.0008"/><%--필수과정--%></th>
                <th class="lastCol"><spring:message code="LABEL.C.C03.0009"/><%--교육형태--%></th>
            </tr>
            </thead>
            <tbody id="-training-table-body">
            <%--@elvariable id="resultList" type="java.util.Vector<hris.C.C03LearnDetailData>"--%>

            <c:forEach var="row" items="${resultList}" varStatus="status">
                <tr <%--class="${f:printOddRow(status.index)}"--%> >
                    <td>${row.LVSTX}</td>
                    <td>${row.DVSTX}</td>
                    <td>${row.PERIOD}</td>
                    <td>${row.TESTX}</td>
                    <td>${row.STATE_ID}</td>
                    <td>${f:parseFloat(row.TASTX) == 0 ? "" : row.TASTX}</td>
                    <td>${row.ATTXT}</td>
                    <td class="lastCol">${row.TFORM}</td>
                </tr>
            </c:forEach>
            <%--
            [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청
            <tags:table-row-nodata list="${resultList}" col="7" />
             --%>
             <tags:table-row-nodata list="${resultList}" col="8" />
            </tbody>
        </table>
    </div>
</div>
<!--교육이수현황 리스트 테이블 끝-->