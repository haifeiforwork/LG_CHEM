<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>

<tags:script>
    <script>
        function doSubmit() {
            $("#I_BEGDA").val($("#I_BEGDA").stripVal());
            $("#I_ENDDA").val($("#I_ENDDA").stripVal());

            if(isValid("searchForm")) {
                document.searchForm.submit();
            }
        }

        // PageUtil 관련 script - page처리시 반드시 써준다...
        function pageChange(page){
            $("#page").val(page);
            doSubmit();
        }
        // PageUtil 관련 script - page처리시 반드시 써준다...

        // PageUtil 관련 script - selectBox 사용시 - Option
        function selectPage(obj){
            pageChange(obj[obj.selectedIndex].value);
        }
        // PageUtil 관련 script - selectBox 사용시 - Option
    </script>
</tags:script>
<table>
    <tr>
        <th><spring:message code="LABEL.G.G02.0004" /><!-- 업무항목 --></th>
        <td>
            <select name="I_UPMU_TYPE">
                ${f:printOption(upmuList, "UPMU_TYPE", "UPMU_NAME", inputData.i_UPMU_TYPE)}
            </select>
            <input type="hidden" name="jobid" value="search" />
            <input type="hidden" id="page" name="page" value=""/>
        </td>
        <th><spring:message code="LABEL.G.G02.0005" /><!-- 신청자 사번 --></td>
        <td>
            <input type="text" name="I_ITPNR" value="${inputData.i_ITPNR}" size="10" maxlength = "8">
        </td>
    </tr>
    <tr>
        <th><spring:message code="LABEL.G.G02.0006" /><!-- 신청일자 --></th>
        <td colspan="3">
            <input id="I_BEGDA" name="I_BEGDA" class="date" type="text" size="11" maxlenth="10" value="${f:printDate(inputData.i_BEGDA) }" placeholder="<spring:message code="LABEL.G.G02.0006" />">
            ~
            <input id="I_ENDDA" name="I_ENDDA" class="date" type="text"  size="11" maxlenth="10" value="${f:printDate(inputData.i_ENDDA) }" placeholder="<spring:message code="LABEL.G.G02.0006" />">
            <span><spring:message code="LABEL.G.G02.0007" /><!-- (예 : 2005.01.28) --></span>
        </td>
        <td>
            <div class="tableBtnSearch">
                <a href="javascript:;" onclick="doSubmit()" class="search"><span><spring:message code="BUTTON.COMMON.SEARCH" /><!-- 조회 --></span></a>
            </div>
        </td>
    </tr>
</table>