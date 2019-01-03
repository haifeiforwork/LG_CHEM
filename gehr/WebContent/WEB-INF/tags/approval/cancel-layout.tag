<%--
	승인이후 승인취소요청 결재처리를 위해
	detail과 request를 조합한 Layout  = ksc 2016.10.12
    update eunha 2017/08/28 [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
	--%>

<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ attribute name="titlePrefix" type="java.lang.String" %>
<%@ attribute name="bottomBody" type="com.common.vo.BodyContainer" %>
<%@ attribute name="updateUrl" type="java.lang.String" required="true" %>
<%@ attribute name="hideHeader" type="java.lang.Boolean" %>
<%@ attribute name="hideApprovalLine" type="java.lang.Boolean" %>

<%-- 추가버튼 --%>
<%@ attribute name="button" type="com.common.vo.BodyContainer"  %>

<%-- 대리신청 가능 여부 default true --%>
<%@ attribute name="representative" type="java.lang.Boolean"  %>

<%-- 신청 URL이 현재 URL이 아닌 다른 URL 일 경우 --%>
<%@ attribute name="requestURL" type="java.lang.String"  %>

<%-- approval header 및 line 사용 안함--%>
<%@ attribute name="disable" type="java.lang.Boolean"  %>

<%-- changeApprovalLine() /*결재라인 동적 변경 함수 */ 호출 가능 여부 --%>
<%@ attribute name="enableChangeApprovalLine" type="java.lang.Boolean"  %>


<c:set var="disable" value="${disable == true ? disable : false}" />

<%-- 대리신청 불가화면 시 representative="false" --%>
<c:set var="representative" value="${representative == null ? true : representative}" />

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />

<spring:message code="${titlePrefix}" var="titlePrefixText" />

<%-- 상태 값에 따라 타이틀 변경 --%>
<%--@elvariable id="g" type="com.common.Global"--%>
<div class="title"><h1> ${titlePrefixText} </h1></div>
<tags:script>
    <script>

        $(function() {

            /*신청*/
            $(".-request-button").click(function() {
                console.log("------- request");
                if(!checkApprovalLine()) return;

                if(doMethod('beforeSubmit') != true) return;

                if(!isValid("form1")) return;

                var $firstRow = $("#-approvalLine-table tbody tr:first");

                <%-- 아래 스크립트 변수명 변경시 메세지 파일(COMMON.APPROVAL.REQUEST.CONFIRM) 확인 후 변경 할것  --%>
                var apprName = $firstRow.find("input[name=APPLINE_ENAME]").val();
                var apprJikwt = $firstRow.find("input[name=APPLINE_JIKWT]").val();
                var apprOrgtx =  $firstRow.find("input[name=APPLINE_ORGTX]").val();

//                 if(confirm(<spring:message code="COMMON.APPROVAL.REQUEST.CONFIRM"/>)) {
                if(confirm("<spring:message code="MSG.APPROVAL.REQUEST.CONFIRM"/>")) {
                    var frm =  document.form1;
                    frm.jobid.value = "${isUpdate ? "change" : "create"}";
                    frm.action = "${requestURL}";
                    frm.target = "";
                    frm.submit();
                }
            });

            /*결재자 검색*/
            $(".-search-decision").on("click", function () {
                var $this = $(this);

                var theURL = "${g.jsp}common/AppLinePop.jsp?index=" + $this.data("idx") + "&objid=" + $this.siblings("input[name=APPLINE_OBJID]").val() + "&pernr=${f:encrypt(approvalHeader.PERNR)}"
                window.open(theURL, "essSearch", "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=537,height=365,left=100,top=100");
            });

        <%-- 수정 삭제 --%>
        <c:if test="${approvalHeader.MODFL == 'X'}">
            $(".-update-button").click(function() {
                //document.form1.
                document.form1.action = "${updateUrl}";
                document.form1.submit();
            });

            $(".-delete-button").click(function() {
                if(confirm("<spring:message code='MSG.COMMON.DELETE.CONFIRM' />")) {
                    var frm = document.form1;
                    frm.jobid.value = "delete";
                    frm.action = "${detailPage}";
                    frm.submit();
                }
            });
        </c:if>
        <%-- 승인 취소 --%>
        <c:if test="${approvalHeader.CANCFL == 'X'}">
            $(".-approval-cancel-button").click(function() {
                if(confirm("<spring:message code='MSG.COMMON.DELETE.CONFIRM' />")) {
                    var frm = document.form1;
                    frm.APPR_STAT.value = " ";
                    frm.jobid.value = "C";

                    frm.action = "${approvalPage}";
                    frm.target = "";
                    frm.submit();
                }
            });
        </c:if>

        <c:if test="${enableChangeApprovalLine == true}">
        /*결재자 변경 : 필요한 param은 json 형태로*/
        function changeApprovalLine(params) {

            if(params) _.extend(params, {PERNR : $("#PERNR").val(), UPMU_TYPE : $("#UPMU_TYPE").val()});
            else params = "form1";

            ajaxPost("${g.servlet}hris.common.ApprovalLineSV", params, function(data) {
                $("#-approvalLine-layout").html($(data).find("#-approvalLine-layout").html());
            });
        }
        </c:if>

        <%-- 승인, 반려 --%>
        <%-- 하단으로 이동 --%>
        });

    </script>
</tags:script>

<%--  신청 button --%>
<tags-approval:button-layout buttonType='D' button="${button}" disable="${disable}"/>


<form id="form1" name="form1" method="post">
    <input type="hidden" id="jobid" name="jobid" />
    <input type="hidden" id="AINF_SEQN" name="AINF_SEQN" value="${approvalHeader.AINF_SEQN}" />
    <input type="hidden" id="I_APGUB" name="I_APGUB" value="${I_APGUB}" /> <!-- //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서 -->
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
<%--     <input type="hidden" id="PERNR" name="PERNR" value="${approvalHeader.PERNR}"/> --%>
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

<c:choose >
<c:when test="${isUpdate != true}"><!-- 조회/승인/반려모드 -->

    <!-- 결재자 입력 테이블 시작 detail-layout.tag참조-->
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
                    <%--@elvariable id="approvalLine" type="java.util.Vector<hris.common.approval.ApprovalLineData>"--%>
                <c:forEach var="row" items="${approvalLine}" varStatus="status">
                    <tr class="${f:printOddRow(status.index)}" title="${row.ENAME } ☎ ${row.PHONE_NUM }">
                        <td>${row.APPU_NAME}</td>
                        <td>${row.ENAME} <span  class="textPink">${row.PHONE_NUM gt '' ?'☎':'' }</span></td>
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
                <tags:table-row-nodata list="${approvalLine}" col="5" />
            </table>
        </div>
    </div>

    </c:when>

	<c:otherwise ><!-- 요청모드 -->


	    <!-- 결재라인 테이블 시작-->
        	<tags-approval:approval-line-layout approvalLine="${approvalLine}" />
    	<!-- 결재라인 테이블 End-->
    </c:otherwise>
    </c:choose>

    <!-- 결재자 입력 테이블 End-->
    </c:if>



<%--  신청 button --%>
<tags-approval:button-layout buttonType='D' button="${button}" disable="${disable}"/>

<%-- 대리신청 시작 --%>
<c:if test="${user.e_representative == 'Y' and isUpdate != true and representative == true}">
    <tags:script>
        <script>
            /*  공통 대리신청시 대상자 검색 */
            /*function pers_search() {
                //  ------------------------------------------------------------
                var win = window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");
                document.approvalHeaderSearchForm.submit();
                win.focus();
            }*/

            function reload() {
                var frm =  document.form1;
                frm.jobid.value = "first";
                frm.action = "";
                frm.target = "";
                frm.submit();
            }

            function pers_search() {

                if(event.keyCode && event.keyCode != 13) return;

                var searchFrom = document.approvalHeaderSearchForm;

                var _gubun = $("#APPR_SEARCH_GUBUN").val();
                var _value = $("#APPR_SEARCH_VALUE").val();

                if ( _.isEmpty(_value) == "" ) {
                    if(_gubun == "1")
                        alert("<spring:message code='MSG.APPROVAL.SEARCH.PERNR.REQUIRED'/>");//검색할 부서원 사번을 입력하세요
                    if(_gubun == "2")
                        alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.REQUIRED'/>");//검색할 부서원 성명을 입력하세요

                    searchFrom.I_VALUE1.focus();
                    return;
                }

                if( _gubun == "1" ) {                   //사번검색
                    searchFrom.jobid.value = "pernr";
                } else if( _gubun == "2" ) {            //성명검색

                    if(_value.length < 2 ) {
                        alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.MIN'/>")
                        searchFrom.I_VALUE1.focus();
                        return;
                    }

                    searchFrom.jobid.value = "ename";
                }

                var searchApprovalHeaderPop = window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=450,top=00");

                searchApprovalHeaderPop.focus();

                searchFrom.target = "DeptPers";
                searchFrom.action = "${g.jsp}common/SearchDeptPersonsWait_m.jsp";
                searchFrom.submit();
            }

            //조직도 검사Popup.
            function organ_search() {
                var searchFrom = document.approvalHeaderSearchForm;
                var searchApprovalHeaderPop = window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=520,left=450,top=0");
                searchApprovalHeaderPop.focus();
                searchFrom.target = "Organ";
                searchFrom.action = "${g.jsp}common/ApprovalOrganListFramePop.jsp";
                searchFrom.submit();
            }




            /*  공통 대리신청시 대상자 검색 끝*/
        </script>
    </tags:script>


</c:if>

<%-- 대리신청 끝 --%>

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
                $("#-accept-info").text();

                var strURL = "${g.jsp}common/ApplConfirmPop.jsp";
                //<!-- 결재양식 수정 -->
                //var strPos = "dialogWidth:530px;dialogHeight:300px;status:no;scroll:yes;resizable:no";
                var strPos = "dialogWidth:380px;dialogHeight:330px;status:no;scroll:yes;resizable:no";

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
        <div id="-accept-info">
        </div>
        <div class="popWindow">
            <div class="popTop">
                <div class="popHeader">
                    <p><spring:message code="MSG.APPROVAL.0018" /><%--승인의견>결재의견--%></p>
                    <a href="#" class="-close-dialog"><img src="${g.image}sshr/btn_popup_close.png" /></a>
                </div>
            </div>
            <div class="popCenter">
                <textarea name="acceptCommentText" id="acceptCommentText" style="width: 550px; height: 200px; "  ></textarea>
                <div class="buttonArea">
                    <ul class="btn_crud">
                        <li><a id="-accept-button" class="darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.APPROVAL" /><%--승인--%></span></a></li>
                        <li><a href="javascript:;" class="-close-dialog"><span><spring:message code="BUTTON.COMMON.CANCEL" /><%--취소--%></span></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <%-- 반려 dialog --%>
    <div id="-reject-dialog" class="-ui-dialog" data-width="600" data-height="400" style="display: none;">
        <div id="-reject-info">
        </div>
        <div class="popWindow">
            <div class="popTop">
                <div class="popHeader">
                    <p><spring:message code="MSG.APPROVAL.0018" /><%--반려의견->결재의견--%></p>
                    <a href="#" class="-close-dialog"><img src="${g.image}sshr/btn_popup_close.png" /></a>
                </div>
            </div>
            <div class="popCenter">
                <textarea name="rejectCommentText" id="rejectCommentText" style="width: 550px; height: 200px; " ></textarea>
                <div class="buttonArea">
                    <ul class="btn_crud">
                        <li><a id="-reject-button" class="darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.REJECT" /><%--반려--%></span></a></li>
                        <li><a href="javascript:;" class="-close-dialog" ><span><spring:message code="BUTTON.COMMON.CANCEL" /><%--취소--%></span></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

</c:if>


    <c:if test="${!disable}" >

    <tags:script>
        <script>
            /*결재자 검색*/
            $(".-search-decision").on("click", function () {
                var $this = $(this);

                var theURL = "${g.jsp}common/AppLinePop.jsp?index=" + $this.data("idx") + "&objid=" + $this.siblings("input[name=APPLINE_OBJID]").val() + "&pernr=${approvalHeader.PERNR}"
                window.open(theURL, "essSearch", "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=537,height=365,left=100,top=100");
            });

            /*
             결재자 체크
             1. 결재라인 == 0 체크
             2. 결재자 미입력 체크
             3. 결재자 중복 체크
             */
            function checkApprovalLine() {
                if($("input[name=APPLINE_APPU_NUMB]").length == 0) {
                    alert("<spring:message code='MSG.APPROVAL.0001' />");   //승인자 정보가 없습니다.
                    return false;
                }

                var isEmpty = false;
                var isDuplicate = false;
                $("input[name=APPLINE_APPU_NUMB]").each(function() {
                    var _value = $(this).val();
                    if(_.isEmpty(_value) || "00000000" == _value) isEmpty = true;
                    if($("input[name=APPLINE_APPU_NUMB][value=" + _value + "]").length > 1) isDuplicate = true;
                });

                if(isEmpty) {
                    alert("<spring:message code='MSG.COMMON.0024' />");// 결재자 이름을 입력하세요.
                    return false;
                }

                /*if(isDuplicate) {
                    alert("<spring:message code="MSG.COMMON.0025"/>");    //결재자가 중복 입력되었습니다.
                    return false;
                }*/

                return true;
            }

            /**
             * 결재자 변경 - 결재자 팝업에서 호출
             * @param index
             * @param PERNR
             * @param ENAME
             * @param ORGTX
             * @param TITEL
             * @param TITL2
             * @param TELNUMBER
             */
            function change_AppData(index, PERNR, ENAME, ORGTX, TITEL, TITL2, TELNUMBER) {
                $("#APPLINE_ENAME_" + index).val(ENAME);
                $("#APPLINE_APPU_ENC_NUMB_" + index).val(PERNR);

                $("#-APPLINE-ORGTX-" + index).text(ORGTX);
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                if (TITEL== "책임"  &&  TITL2 != ""){
                	$("#-APPLINE-JIKWT-" + index).text(TITL2);
                }else{
                	$("#-APPLINE-JIKWT-" + index).text(TITEL);
                }
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                $("#APPLINE_JIKWT_" + index).val(TITEL);
                $("#APPLINE_ORGTX_" + index).val(ORGTX);
            }
        </script>
    </tags:script>

  </c:if>

  </form>
