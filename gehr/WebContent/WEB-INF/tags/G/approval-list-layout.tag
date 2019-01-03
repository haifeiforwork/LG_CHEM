<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/G" %>

<tags:layout title="COMMON.MENU.ESS_APP_TO_DO_DOC">
    <%--@elvariable id="g" type="com.common.Global"--%>
    <%--@elvariable id="pu" type="com.sns.jdf.util.PageUtil"--%>
    <tags:script>
        <script language="JavaScript" type="text/JavaScript">
            <!--
            function checkAll() {
                $(".approvalSeq:enabled").prop("checked", $("#allCheck").is(":checked"));
            }

            function approval() {

                if( $(".approvalSeq:checked") == 0) {
                    alert("<spring:message code='LABEL.APPROVAL.0011' />"); //일괄 결재할 목록을 선택하세요
                    return;
                } // end if

                if(!doMethod("beforeApproval")) return;

                if(confirm("<spring:message code='MSG.APPROVAL.APPROVAL.CONFIRM' />")) { //결재하시겠습니까?
                    document.form1.jobid.value = "save";
                    document.form1.action = '${g.servlet}hris.G.G001ApprovalDocListSV';
                    blockFrame();
                    document.form1.submit();
                }
            }

            function viewDetail(idx) {
                var $row = $("#row_" + idx);

                $("#AINF_SEQN").val($row.data("seq"));
                $("#UPMU_TYPE").val($row.data("type"));
                $("#PERNR").val($row.data("pernr"));

                document.detailForm.submit();
            }


            //-->
        </script>
    </tags:script>
    <!--  검색테이블 시작 -->
    <div class="tableInquiry">
        <form id="detailForm" name="detailForm" action="${g.servlet}hris.G.G000ApprovalDetailSV">
            <input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
            <input type="hidden" id="UPMU_TYPE" name="UPMU_TYPE" />
            <input type="hidden" id="PERNR" name="PERNR" />
            <input type="hidden" id="RequestPageName" name="RequestPageName" value="${currentURL}"/>
        </form>
        <form id="searchForm" name="searchForm" action="${g.servlet}hris.G.G001ApprovalDocListSV">
                <%-- 검색 공통 --%>
            <tags-approval:approval-search-layout />
        </form>
    </div>
    <!--  검색테이블 끝-->

    <!-- 리스트테이블 시작 -->
    <div class="listArea">
        <form name="form1" method="post" action="">
            <input type="hidden" name="RequestPageName" value="${currentURL}"/>
            <input TYPE="hidden" name="jobid" value="">
        <div class="listTop">
            <span class="listCnt">${pu.pageInfo}</span>
        </div>
        <div class="table">
            <jsp:doBody/>
            <div class="align_center">
                ${pu.pageControl}
            </div>
        </div>
        </form>
    </div>
    <!-- 리스트테이블 끝-->

    <!--결재버튼 들어가는 테이블 시작 -->
    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:;" class="unloading" onclick="approval()"><span><spring:message code='BUTTON.COMMON.APPROVAL' /><%--결재 --%></span></a></li>
        </ul>
    </div>
    <!--결재버튼 들어가는 테이블 끝 -->

    <c:if test="${g.sapType.local}">
    <div class="commentImportant" style="width:640px;">
        <p><spring:message code='LABEL.APPROVAL.0012' /><%-- ※ 본화면에서의 결재버튼은 일괄로 결재가 가능한 항목에 대해서만 사용할 수 있습니다. --%></p>
        <p><spring:message code='LABEL.APPROVAL.0013' /><%-- ※ 식대 결재시 퇴직자 또는 퇴직예정자에 대해서는 퇴직일 전일까지의 근무일수를 계산하여 결재바랍니다. --%></p>
    </div>
    </c:if>

</tags:layout>


