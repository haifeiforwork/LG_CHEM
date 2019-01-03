<%/******************************************************************************/
/*   Update      :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건  */
/********************************************************************************/%>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:set var="isDev" value="<%=WebUtil.isDev(request) %>"/>

<tags:layout title="MENU.COMMON.0067">

    <tags:script>
        <script>
            $(function() {
                $(".-request-button").click(function() {
                    if(trimSearchVal()) {
                        blockFrame();
                        $("#jobid").val("save");
                        document.form1.submit();
                    }
                });

                $(".-search-button").click(function() {
                    if(trimSearchVal()) {
                        blockFrame();
                        $("#jobid").val("search");
                        document.form1.submit();
                    }
                });

                $(".-delete-button").click(function() {
                    if(confirm("삭제하시겠습니까?")) {
                        if (trimSearchVal()) {
                            blockFrame();
                            $("#jobid").val("delete");
                            document.form1.submit();
                        }
                    }
                });
            });

            function trimSearchVal() {
                var _seqn = $.trim($("#AINF_SEQN").val());

                if(_.isEmpty(_seqn)) {
                    alert("결재번호를 입력하세요");
                    return false;
                }

                $("#AINF_SEQN").val(_seqn);

                return true;
            }
        </script>
    </tags:script>

    <form id="form1" name="form1" method="post" action="" >
    <div class="tableArea">
        <div class="table">
            <table border="0" cellspacing="0" cellpadding="0" class="tableGeneral">
                <colgroup>
                    <col width="15%" />
                    <col width="85%" />
                </colgroup>
                <tr>
                    <th>결재번호</th>
                    <td>
                        <input type="text" id="AINF_SEQN" name="AINF_SEQN" value="${param.AINF_SEQN}" />
                        <input type="hidden" id="jobid" name="jobid" />


                        <input type="checkbox" id="noSend" name="noSend" value="Y"/> 시뮬레이션(eloffice로 실제전송 안함)
                    </td>
                </tr>
            </table>
        </div>
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a class="-search-button " href="javascript:;"><span>조회</span></a></li>
                <li><a class="-delete-button darken" href="javascript:;"><span>삭제</span></a></li>
                <li><a class="-request-button darken" href="javascript:;"><span>실행</span></a></li>
            </ul>
        </div>
    </div>
    </form>

    <c:if test="${jobid == 'save'}">
    <h2 class="subtitle">처리결과</h2>
    <div class="tableArea">
        <!-- 개인 인적사항 조회 -->
        <div class="table">
            <table border="0" cellspacing="0" cellpadding="0" class="tableGeneral">
                <colgroup>
                    <col width="15%" />
                    <col width="85%" />
                </colgroup>
                <tr>
                    <th>결과메세지</th>
                    <td>${isSuccess ? "성공" : message}</td>
                </tr>
            </table>
        </div>
    </div>
    </c:if>

    <c:if test="${not empty approvalHeader}">
    <%-- 헤더 정보 --%>
    <tags-approval:header-layout />
    <%-- 결재라인 HR --%>
    </c:if>

    <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>

    <c:if test="${not empty approvalLine}">
    <!-- 결재자 입력 테이블 시작-->
    <h2 class="subtitle">[${approvalHeader.UPMU_NAME}] HR <spring:message code="MSG.APPROVAL.0011" /><!-- 승인자정보 --></h2>

    <!-- 결재자 입력 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <colgroup>
                    <col width="10%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="" />
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="MSG.APPROVAL.0012" /><%--구분--%></th>
                    <th><spring:message code="MSG.APPROVAL.0013" /><%--성명--%></th>
                	<%-- //[CSR ID:3456352]<th><spring:message code='MSG.APPROVAL.0014' />직위</th> --%>
                	<th><spring:message code='MSG.APPROVAL.0024' /><%--직책/직급호칭--%></th>
                    <th><spring:message code="MSG.APPROVAL.0015" /><%--부서--%></th>
                    <th><spring:message code="MSG.APPROVAL.0016" /><%--결재시간--%></th>
                    <th><spring:message code="MSG.APPROVAL.0017" /><%--상태--%></th>
                    <th class="lastCol"><spring:message code="MSG.APPROVAL.0018" /><%--결재의견--%></th>
                </tr>
                </thead>
                    <%--@elvariable id="approvalLine" type="java.util.Vector<hris.common.approval.ApprovalLineData>"--%>
                <c:forEach var="row" items="${approvalLine}" varStatus="status">
                    <tr class="${f:printOddRow(status.index)}" >
                        <td>${row.APPU_NAME}</td>
                        <td>[${row.APPU_NUMB}] ${row.ENAME} </td>
                    <td id="-APPLINE-JIKWT-${status.index}" >
                    <%--//[CSR ID:3456352] ${row.JIKWT}--%>
                    <c:choose>
		                <c:when test="${row.BUKRS=='C100' && row.JIKWE=='EBA' && row.JIKKT!=''}">
			                ${row.JIKKT}
		                </c:when>
		                <c:otherwise>
		               		${row.JIKWT}
		                </c:otherwise>
	                </c:choose>
	                <%--//[CSR ID:3456352]--%>
                    </td>
                        <td id="-APPLINE-ORGTX-${status.index}" class="align_left">${row.ORGTX}</td>
                        <td>
                            <c:if test="${not empty f:printDate(row.APPR_DATE)}">
                                ${f:printDate(row.APPR_DATE)} ${row.APPR_TIME}
                            </c:if>
                        </td>
                        <td>${row.APPR_STATX}</td>
                        <td class="lastCol align_left">${f:replaceLiteral(row.BIGO_TEXT)}</td>
                    </tr>
                </c:forEach>
                <tags:table-row-nodata list="${approvalLine}" col="7" />
            </table>
        </div>
    </div>
    <!-- 결재자 입력 테이블 End-->
    </c:if>

    <%-- 전송결과 --%>
    <c:if test="${not empty interfaceDataList}">
        <h2 class="subtitle">전송 데이타</h2>

        <!-- 결재자 입력 테이블 시작-->
        <div class="listArea">
            <div class="table">
                <table class="listTable">
                    <%--<colgroup>
                        <col width="15%" />
                        <col width="10%" />
                        <col width="10%" />
                        <col width="15%" />
                        <col width="20%" />
                        <col width="15%" />
                        <col width="15%" />
                    </colgroup>--%>
                    <thead>
                    <tr>
                        <th>업무명 [UPMU_NAME]</th>
                        <th>MAIN_STATUS</th>
                        <th>P_MAIN_STATUS</th>
                        <th>SUB_STATUS</th>
                        <th>REQ_DATE</th>
                        <th>요청자[R_EMP_NO]</th>
                        <th class="lastCol">대상자[A_EMP_NO]</th>
                    </tr>
                    </thead>

                    <%--@elvariable id="interfaceDataList" type="java.util.Vector<hris.common.ElofficInterfaceData>"--%>
                    <c:forEach var="row" items="${interfaceDataList}" varStatus="status">
                        <tr class="${f:printOddRow(status.index)}" >
                            <td>${row.CATEGORY}</td>
                            <td>${row.MAIN_STATUS}</td>
                            <td>${row.p_MAIN_STATUS}</td>
                            <td>${row.SUB_STATUS}</td>
                            <td>${row.REQ_DATE}</td>
                            <td>${row.r_EMP_NO}</td>
                            <td class="lastCol">${row.a_EMP_NO}</td>
                        </tr>
                    </c:forEach>
                    <tags:table-row-nodata list="${interfaceDataList}" col="7" />
                </table>
            </div>
        </div>
        <!-- 결재자 입력 테이블 End-->
    </c:if>

    <c:set var="elofficeURL" value="${isDev ? 'http://uapprovaldev.lgchem.com:9021' : 'http://uapproval.lgchem.com:7010'}/lgchem/front.appint.cmd.RetrieveSappiTraceListCmd.lgc?s_appId=${param.AINF_SEQN}&s_legacy=EHR"/>

    <c:if test="${not empty param.AINF_SEQN}">
        <h2 class="subtitle">Eloffice 상태 - ${elofficeURL}</h2>
        <%--
        #전자결재 연동이 필요시 host 파일에 추가
        165.244.243.134   uapprovaldev.lgchem.com
        165.244.243.134 dev.lgchem.com
        --%>
        <script>
            function autoResize(target) {
                try {
                    var iframeHeight = target.contentWindow.document.body.scrollHeight;
                    target.height = iframeHeight + 100;
                } catch(e) {}
            }
        </script>

        <iframe src="${elofficeURL}" width="100%" height="400" onload="autoResize(this);">
        </iframe>
    </c:if>

</tags:layout>