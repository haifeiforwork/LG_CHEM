<%--
	결재/반려 버튼(공통)
	결재/반려 클릭 시 ApplConfirmPop.jsp popup 호출 
    update 2018-02-12 rdcamel [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청 
	--%>
<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ attribute name="titlePrefix" type="java.lang.String" %>
<%@ attribute name="button" type="com.common.vo.BodyContainer"  %>
<%@ attribute name="bottomBody" type="com.common.vo.BodyContainer" %>
<%@ attribute name="updateUrl" type="java.lang.String" required="true" %>
<%@ attribute name="hideHeader" type="java.lang.Boolean" %>
<%@ attribute name="hideApprovalLine" type="java.lang.Boolean" %>
<%@ attribute name="disable" type="java.lang.Boolean"  %>
<%@ attribute name="disableUpdate" type="java.lang.Boolean"  %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="disable" value="${disable == true ? disable : false}" />

<spring:message code="${titlePrefix}" var="titlePrefixText" />

<%-- 상태 값에 따라 타이틀 변경 --%>
<%--@elvariable id="g" type="com.common.Global"--%>
<%--req.setAttribute("I_APGUB", "1");   //'1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서--%>
<div class="title"><h1>${titlePrefixText}
    <%--<c:choose>--%>
        <%--<c:when test="${I_APGUB == '1'}">--%>
             <%--<spring:message code="LABEL.COMMON.APPROVAL.TITLE.TODO" arguments="${titlePrefixText}" />--%>
         <%--</c:when>--%>
        <%--<c:when test="${I_APGUB == '2'}">--%>
            <%--<spring:message code="LABEL.COMMON.APPROVAL.TITLE.ING" arguments="${titlePrefixText}" />--%>
        <%--</c:when>--%>
        <%--<c:when test="${I_APGUB == '3'}">--%>
            <%--<spring:message code="LABEL.COMMON.APPROVAL.TITLE.FINISH" arguments="${titlePrefixText}" />--%>
        <%--</c:when>--%>
        <%--<c:otherwise>--%>
            <%--<spring:message code="LABEL.COMMON.APPROVAL.TITLE.DETAIL" arguments="${titlePrefixText}" />--%>
        <%--</c:otherwise>--%>
    <%--</c:choose>--%>
</h1></div>

<tags:script>
    <script>

        $(function() {
        <%-- 수정 삭제 --%>
        <c:if test="${approvalHeader.MODFL == 'X'}">
            $(".-update-button").click(function() {
                //document.form1.
                document.form1.action = "${updateUrl}";
                document.form1.target = "";
                document.form1.jobid.value = "";
                blockFrame();
                document.form1.submit();
            });

            $(".-delete-button").click(function() {
                if(confirm("<spring:message code='MSG.COMMON.DELETE.CONFIRM' />")) {
                    var frm = document.form1;
                    frm.jobid.value = "delete";
                    frm.target = "";
                    frm.action = "${detailPage}";
                    blockFrame();
                    frm.submit();
                }
            });
        </c:if>
        <%-- 승인 취소 --%>
        <c:if test="${approvalHeader.CANCFL == 'X'}">
            $(".-approval-cancel-button").click(function() {
                if(confirm("<spring:message code='MSG.APPROVAL.CANCEL.CONFIRM' />")) {
                    var frm = document.form1;
                    frm.APPR_STAT.value = " ";
                    frm.jobid.value = "C";

                    frm.action = "${approvalPage}";
                    frm.target = "";
                    blockFrame();
                    frm.submit();
                }
            });
        </c:if>
        <%-- 승인, 반려 --%>
        <%-- 하단으로 이동 --%>
        });

    </script>
</tags:script>

<%--  신청 button --%>
<tags-approval:button-layout buttonType="D" button="${button}" disable="${disable}" disableUpdate="${disableUpdate}"/>

<form id="form1" name="form1" method="post">
    <input type="hidden" id="jobid" name="jobid" value=""/>
    <input type="hidden" id="AINF_SEQN" name="AINF_SEQN" value="${approvalHeader.AINF_SEQN}" />
    <input type="hidden" id="I_APGUB" name="I_APGUB" value="${I_APGUB}" />
    <input type="hidden" id="RequestPageName" name="RequestPageName" value="${RequestPageName}" />
    <input type="hidden" id="cancelPage" name="cancelPage" value="${currentURL}" />
    <script>
        try {
            $("#cancelPage").val(location.href);
        } catch(e) {}
    </script>
<c:if test="${approvalHeader.ACCPFL == 'X' or approvalHeader.CANCFL == 'X'}">
    <input type="hidden" id="APPR_STAT" name="APPR_STAT"  />
    <input type="hidden" id="BIGO_TEXT" name="BIGO_TEXT"  />
</c:if>


<%-- 결재함이 아니고 신청자 == 로그인 사번 일 경우는 헤더 안보여줌 ?? --%>
    <c:if test="${hideHeader != true}">
    <!-- 헤더 -->
    <tags-approval:header-layout />
    </c:if>
    <!-- 상단 입력 테이블 시작-->
    <%-- 개발 부분 --%>
    <jsp:doBody />
    <!-- 상단 입력 테이블 끝-->

    <c:if test="${hideApprovalLine != true}">
    <!-- 결재자 입력 테이블 시작-->
    <h2 class="subtitle"><spring:message code="MSG.APPROVAL.0011" /><!-- 승인자정보 --></h2>


    <!-- 결재자 입력 테이블 시작-->
    <div class="listArea" style="${not empty bodyWidth ? bodyWidth : ''}">
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
                    <%-- //[CSR ID:3456352] <th><spring:message code="MSG.APPROVAL.0014" />직위</th> --%>
                    <th><spring:message code="MSG.APPROVAL.0024" /><!-- 직책/직급호칭 --></th>
                    <th><spring:message code="MSG.APPROVAL.0015" /><%--부서--%></th>
                    <th><spring:message code="MSG.APPROVAL.0016" /><%--결재시간--%></th>
                    <th><spring:message code="MSG.APPROVAL.0017" /><%--상태--%></th>
                    <th class="lastCol"><spring:message code="MSG.APPROVAL.0018" /><%--결재의견--%></th>
                </tr>
                </thead>
                    <%--@elvariable id="approvalLine" type="java.util.Vector<hris.common.approval.ApprovalLineData>"--%>
                <c:forEach var="row" items="${approvalLine}" varStatus="status">
                    <tr class="${f:printOddRow(status.index)}" title="${row.ENAME } ☎ ${row.PHONE_NUM }">
                        <td><spring:message code="COMMON.APPROVAL.${row.APPU_TYPE}.STAT"/><%--${row.APPU_NAME}--%></td>
                        <td>${row.ENAME} <span  class="textPink">${row.PHONE_NUM gt '' ?'☎':'' }</span></td>
                        <td id="-APPLINE-JIKWT-${status.index}">
                        <%-- //[CSR ID:3456352] ${row.JIKWT} --%>
                        <c:choose>
			                <c:when test="${row.BUKRS=='C100'&& row.JIKWE=='EBA' && row.JIKKT!=''}">
				                ${row.JIKKT}
			                </c:when>
			                <%-- [CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 start --%>
	                		<c:when test="${f:isChangeGlobalJIKKT(row.BUKRS,row.PERSG,row.PERSK,row.JIKWE,row.JIKKT, row.JIKCH)}">
			               		${row.JIKKT}
		                	</c:when>
		                	<%-- [CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 end --%>
			                <c:otherwise>
			               		${row.JIKWT}
			                </c:otherwise>
		                </c:choose>
		                <!-- //[CSR ID:3456352] -->
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
                <tags:table-row-nodata list="${approvalLine}" col="5" />
            </table>
        </div>
    </div>
    <!-- 결재자 입력 테이블 End-->
    </c:if>
</form>

<%--  신청 button --%>
<tags-approval:button-layout buttonType="D" button="${button}" disable="${disable}" disableUpdate="${disableUpdate}"/>

<%-- 승인, 반려 처리부  --%>
<c:if test="${approvalHeader.ACCPFL == 'X'}">
    <tags:script>
        <script>
            $(function() {

                $(".-accept-dialog-button").click(function() {
                    if(doMethod('beforeAccept') != true) return;

                    if(!isValid("form1")) return;

                    //$("#-accept-dialog").openDialog();  /* 결재의견 dialog */
                    openApprovalPop("A");  /* 결재의견 dialog*/

                });

                $(".-reject-dialog-button").click(function() {
                    if(doMethod('beforeReject') != true) return;

                    //$("#-reject-dialog").openDialog();
                    openApprovalPop("R");  /* 결재의견 dialog*/
                });

                $("#-accept-button").click(function() {
                    accept();
                });

                $("#-reject-button").click(function() {
                    reject();
                });
            });

            function accept() {
                if(doMethod('beforeAccept') != true) return;

                if(!isValid("form1")) return;

                var frm =  document.form1;
                frm.APPR_STAT.value = "A";
                frm.jobid.value = "A";
                frm.BIGO_TEXT.value = $("#acceptCommentText").val();

                doMethod('afterAccept');
                frm.action = "${approvalPage}";
                frm.target = "";
                blockFrame();
                frm.submit();
            }

            function reject() {
                if(doMethod('beforeReject') != true) return;

                var frm = document.form1;
                frm.APPR_STAT.value = "R";
                frm.jobid.value = "R";
                frm.BIGO_TEXT.value = $("#rejectCommentText").val();

                frm.action = "${approvalPage}";
                frm.target = "";
                blockFrame();
                frm.submit();
            }

            /**
             * 결재의견 window pop
             * gubun : A 승인, R 반려
             * @param gubun
             */
            function openApprovalPop(gubun, msg) {

                var strURL = "${g.jsp}common/ApplConfirmPop.jsp";
                //<!-- 결재양식 수정 -->    
                //var strPos = "dialogWidth:380px;dialogHeight:330px;status:no;scroll:yes;resizable:no";
                var strPos = "dialogWidth:380px;dialogHeight:380px;status:no;scroll:yes;resizable:no";

                if(_.isEmpty(msg)) {
                	
                    if (gubun == "A") msg = "<spring:message code="MSG.APPROVAL.APPROVAL.CONFIRM"/>";
                    else if (gubun == "R") msg = "<spring:message code="MSG.APPROVAL.REJECT.CONFIRM"/>";
                }

                // 팝업 뛰우기(데이터전송)
                var resultObj = window.showModalDialog(strURL, {confMsg : $("#-accept-info").text(), confMsgCenter : msg}, strPos);

                if(resultObj && resultObj.confirm == "Y") {
                    if(gubun == "A") {
                        $("#acceptCommentText").val(resultObj.acceptCommentText);
                        accept();
                    } else if(gubun == "R") {
                        $("#rejectCommentText").val(resultObj.acceptCommentText);
                        reject();
                    }
                }

            }


        </script>
    </tags:script>
    <%-- 승인 dialog --%>
    <div id="-accept-dialog" class="-ui-dialog" data-width="600" data-height="400" style="display: none;">
        <div class="popWindow">
            <div class="popTop">
                <div class="popHeader">
                    <p><spring:message code="MSG.APPROVAL.0018" /><%--승인의견->결재의견 --%></p>
                    <a href="javascript:;" class="-close-dialog unloading"><img src="${g.image}sshr/btn_popup_close.png" /></a>
                </div>
            </div>
            <div class="popCenter">
                <div id="-accept-info" style="text-align: center;font-weight: bold;"></div>
                <div style="text-align: center;font-weight: bold;"><spring:message code="MSG.APPROVAL.APPROVAL.CONFIRM"/></div>
                <textarea name="acceptCommentText" id="acceptCommentText" style="width: 500px; height: 150px; "  ></textarea>
                <div class="buttonArea">
                    <ul class="btn_crud">
                        <li><a id="-accept-button" class="darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.CONFIRM" /><%--확인--%></span></a></li>
                        <li><a href="javascript:;" class="-close-dialog unloading"><span><spring:message code="BUTTON.COMMON.CANCEL" /><%--취소--%></span></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <%-- 반려 dialog --%>
    <div id="-reject-dialog" class="-ui-dialog" data-width="600" data-height="400" style="display: none;">
        <div class="popWindow">
            <div class="popTop">
                <div class="popHeader">
                    <p><spring:message code="MSG.APPROVAL.0018" /><%--반려의견->결재의견--%></p>
                    <a href="javascript:;" class="-close-dialog unloading"><img src="${g.image}sshr/btn_popup_close.png" /></a>
                </div>
            </div>
            <div class="popCenter">
                <div id="-reject-info">
                </div>
                <div style="text-align: center;font-weight: bold;"><spring:message code="MSG.APPROVAL.REJECT.CONFIRM"/></div>
                <textarea name="rejectCommentText" id="rejectCommentText" style="width: 500px; height: 150px; " ></textarea>
                <div class="buttonArea">
                    <ul class="btn_crud">
                        <li><a id="-reject-button" class="darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.CONFIRM" /><%--확인--%></span></a></li>
                        <li><a href="javascript:;" class="-close-dialog unloading" ><span><spring:message code="BUTTON.COMMON.CANCEL" /><%--취소--%></span></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

</c:if>