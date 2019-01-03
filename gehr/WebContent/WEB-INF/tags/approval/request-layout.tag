<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ attribute name="titlePrefix" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="script" type="java.lang.String" %>
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

<%@ attribute name="disableApprovalLine" type="java.lang.Boolean"  %>
<%@ attribute name="subtitleCode" type="java.lang.String"  %>
<%@ attribute name="upload" type="java.lang.Boolean"  %>

<c:set var="disable" value="${disable == true ? disable : false}" />
<c:set var="upload" value="${upload == true ? upload : false}" />

<%-- 대리신청 불가화면 시 representative="false" --%>
<c:set var="representative" value="${representative == null ? true : representative}" />
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />

<spring:message code="${titlePrefix}" var="titlePrefixText" />

<c:if test="${not empty subtitleCode and !isUpdate}">
    <h2 class="subtitle"><spring:message code="${subtitleCode}" /></h2>
</c:if>

<div class="title"><h1>
    <%-- titlePrefix 입력하면 titlePrefix 신청, titlePrefix 수정 자동으로 표시됨 --%>
    <%-- 만약 title 이 존재하면 신청일 경우만 title이 표시됨--%>

                    ${titlePrefixText}

</h1></div>

<tags:script>
<script>
$(function() {
    /* 신청 */
    $(".-request-button").click(function() {
        if (typeof console !== 'undefined' && typeof console.log === 'function') console.log("------- request");

        if (!checkApprovalLine()) return;

        if (doMethod('beforeSubmit') != true) return;

        if (!isValid("form1")) return;

        var $firstRow = $("#-approvalLine-table tbody tr:first");

        <%-- 아래 스크립트 변수명 변경시 메세지 파일(COMMON.APPROVAL.REQUEST.CONFIRM) 확인 후 변경 할것  --%>
        var apprName = $firstRow.find("input[name=APPLINE_ENAME]").val();
        var apprJikwt = $firstRow.find("input[name=APPLINE_JIKWT]").val();
        var apprOrgtx =  $firstRow.find("input[name=APPLINE_ORGTX]").val();

        <%-- if(confirm(<spring:message code="COMMON.APPROVAL.REQUEST.CONFIRM"/>)) { --%>
        if (confirm("<spring:message code='MSG.APPROVAL.REQUEST.CONFIRM' />")) {
            var frm = document.form1;
            frm.jobid.value = "${isUpdate ? "change" : "create"}";
            frm.action = "${requestURL}";
            frm.target = "";
            frm.submit();
        }
    });
});

<c:if test="${enableChangeApprovalLine == true}">
/* 결재자 변경 : 필요한 param은 json 형태로 */
function changeApprovalLine(params) {

    if(params) _.extend(params, {PERNR : $("#PERNR").val(), UPMU_TYPE : $("#UPMU_TYPE").val()});
    else params = "form1";

    ajaxPost("${g.servlet}hris.common.ApprovalLineSV", params, function(data) {
        $("#-approvalLine-layout .table").empty().html($(data).find("div:first").html());
    });
}
</c:if>
</script>
</tags:script>

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

    if ( _.isEmpty(_value)) {
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

    var searchApprovalHeaderPop = window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=450,top=00");

    searchApprovalHeaderPop.focus();

    searchFrom.target = "DeptPers";
    searchFrom.action = "${g.jsp}common/SearchDeptPersonsWait_R.jsp";
    searchFrom.submit();
    //$(searchFrom).unloadingSubmit();
}

//조직도 검사Popup.
function organ_search() {
    var searchFrom = document.approvalHeaderSearchForm;
    var searchApprovalHeaderPop = window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=520,left=450,top=0");
    searchFrom.target = "Organ";
    searchFrom.action = "${g.jsp}common/ApprovalOrganListFramePop.jsp";
    searchFrom.submit();

    searchApprovalHeaderPop.focus();

}
/*  공통 대리신청시 대상자 검색 끝*/
</script>
</tags:script>
    <%--<div class="tableInquiry">
        <table>
            <tr>
            	<th width="20%">
            		<img class="searchTitle" src="${g.image}sshr/top_box_search.gif" />
               		<!--선택구분--><spring:message code="LABEL.COMMON.0003" />
               	</th>
                <td width="40px;">
                    <select name="I_GUBUN" onChange="$('#I_VALUE1').val('');">
                        <option value="2" ><!--성명별--><spring:message code="LABEL.COMMON.0004" /></option>
                        <option value="1" ><!--사번별--><spring:message code="LABEL.COMMON.0005" /></option>
                    </select>
                </td>
                <td>
                    <form id="approvalHeaderSearchForm" name="approvalHeaderSearchForm" method="post" target="DeptPers" action="${g.jsp}common/SearchDeptPersonsWait.jsp">
                        <input type="text"  id="I_VALUE1" name="I_VALUE1" size="16"  maxlength="10"  value=""  onKeyDown = "if(event.keyCode == 13) pers_search();"
                               onFocus="this.select();" style="ime-mode:active" >
                        <div class="tableBtnSearch tableBtnSearch2" >
                            <a class="search" href="javascript:;" onclick="pers_search();"><span><!--사원찾기--><spring:message code="LABEL.COMMON.0006" /></span></a>
                        </div>
                    </form>
                </td>
            </tr>
        </table>
    </div>--%>



    <div class="tableInquiry">
        <form id="approvalHeaderSearchForm" name="approvalHeaderSearchForm" method="post" onsubmit="return false;">
        <table>
            <tr>
                <th><img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" /></th>
                <th><!--선택구분--><spring:message code="LABEL.COMMON.0003" /></th>
                <td>
                    <select id="APPR_SEARCH_GUBUN" name="I_GUBUN" onChange="$('#APPR_SEARCH_VALUE').val('').focus();">
                        <option value="2"><!--성명별--><spring:message code="LABEL.COMMON.0004" /></option>
                        <option value="1"><!--사번별--><spring:message code="LABEL.COMMON.0005" /></option>
                    </select>
                    <input type="text"  id="APPR_SEARCH_VALUE" name="I_VALUE1" size="17"  maxlength="10"  onkeydown="pers_search();" style="ime-mode:active" >
                    <input type="hidden" name="jobid" />
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search"  onclick="pers_search();"><span><!--사원찾기--><spring:message code="LABEL.COMMON.0006" /></span></a>
                    </div>
                </td>
                <td>
                    <img class="searchIcon" src="<%= WebUtil.ImageURL %>sshr/icon_map_g.gif" />
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search"  onclick="organ_search()"><span><!--조직도로 찾기--><spring:message code="LABEL.COMMON.0011" /></span></a>
                    </div>
                </td>
            </tr>
<%--            <input type="hidden" name="I_DEPT"   value="<%= user.empNo  %>">
            <input type="hidden" name="E_RETIR"  value="<%= user.e_retir %>">
            <input type="hidden" name="count"    value="<%= l_count %>">--%>

        </table>
        </form>

    </div>
</c:if>
<%-- 대리신청 끝 --%>

<!-- button 시작 -->
<tags-approval:button-layout buttonType="R" button="${button}" disable="${disable}"/>
<!-- button 끝 -->

<form id="form1" name="form1" method="post" <c:if test="${upload}">enctype="multipart/form-data"</c:if>>
    <input type="hidden" id="jobid" name="jobid" />
    <input type="hidden" id="I_APGUB" name="I_APGUB" value="${param.I_APGUB}" />
    <input type="hidden" id="RequestPageName" name="RequestPageName" value="${RequestPageName}" />
    <input type="hidden" id="cancelPage" name="cancelPage" value="${param.cancelPage}" />
    <input type="hidden" id="PERNR" name="PERNR" value="${approvalHeader.PERNR}"/>
    <input type="hidden" id="AINF_SEQN" name="AINF_SEQN" value="${approvalHeader.AINF_SEQN}"/><c:if test="${!empty param.FROM_ESS_OFW_WORK_TIME}"><%-- [WorkTime52] 근무 시간 입력 화면에서 popup으로 들어온 경우 결재신청 후 popup을 닫기 위한 flag --%>
    <input type="hidden" name="FROM_ESS_OFW_WORK_TIME" value="${param.FROM_ESS_OFW_WORK_TIME}"/></c:if>

    <tags-approval:header-layout />

    <%-- 개발 부분 --%>
    <!-- 상단 입력 테이블 시작 -->
    <jsp:doBody />
    <!-- 상단 입력 테이블 끝 -->

<tags:script>
<script>
/*결재자 검색*/
    //[CSR ID:3438118] flexible time 시스템 요청  eunha 20170905 Flextime에서 담당결재가 2차까지 있어 로직이 제대로 수행되지 않아 수정 start
function changePop(idx) {
	var $row = $("#-search-decision_" + idx);
	var theURL = "${g.jsp}common/AppLinePop.jsp?index=" + $row.data("idx") + "&objid=" + $row.data("objid") + "&pernr=${f:encrypt(approvalHeader.PERNR)}"
	window.open(theURL, "essSearch", "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=750,height=400,left=100,top=100");
}
//[CSR ID:3438118] flexible time 시스템 요청  eunha 20170905 Flextime에서 담당결재가 2차까지 있어 로직이 제대로 수행되지 않아 수정 end

/*$(document).on('click',"a.-search-decision",function () {
    var $this = $(this);

    var theURL = "${g.jsp}common/AppLinePop.jsp?index=" + $this.data("idx") + "&objid=" + $this.siblings("input[name=APPLINE_OBJID]").val() + "&pernr=${f:encrypt(approvalHeader.PERNR)}"
    window.open(theURL, "essSearch", "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=750,height=400,left=100,top=100");
});*/

//[CSR ID:3438118] flexible time 시스템 요청  eunha 20170905 Flextime에서 담당결재가 2차까지 있어 로직이 제대로 수행되지 않아 수정 end
/*결재자 검색*/
/*$(".-search-decision").on("click", function () {

    var theURL = "${g.jsp}common/AppLinePop.jsp?index=" + $(this).data("idx") + "&objid=" + $(this).siblings("input[name=OBJID]").val() + "&pernr=${approvalHeader.PERNR}"
    window.open(theURL, "essSearch", "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=650,height=400,left=100,top=100");
});*/

/*
 결재자 체크
 1. 결재라인 == 0 체크
 2. 결재자 미입력 체크
 3. 결재자 중복 체크
 */
function checkApprovalLine() {

    if($("input[name=APPLINE_APPU_ENC_NUMB]").length == 0) {
        alert("<spring:message code='MSG.APPROVAL.0001' />");   //승인자 정보가 없습니다.
        return false;
    }

    var isEmpty = false;
    var isDuplicate = false;
    $("input[name=APPLINE_APPU_ENC_NUMB]").each(function() {
        var $this = $(this);
        var _value =  $this.val();
        if(_.isEmpty(_value) || "00000000" == _value) isEmpty = true;
        <%-- 결재라인 중복 체크 APPU_TYPE == 02 일 경우 중복 체크 제외  --%>
        //[CSR ID:3438118] flexible time 시스템 요청  eunha 20170905 Flextime에서 담당결재가 2차까지 있어 로직이 제대로 수행되지 않아 수정 start
       /*else {

            if($this.parents("tr").find("input[name=APPLINE_APPU_TYPE]").val() !='02') {
                if($("input[name=APPLINE_APPU_TYPE][value!='02']").parents("tr").find("input[name=APPLINE_APPU_ENC_NUMB][value=" + _value + "]").length > 1)
                    isDuplicate = true;
            }
        }*/
    });

	var size = $("input[name=APPLINE_APPU_ENC_NUMB]").length;
    for( i = 0; i < size; i++ ){
        for( j = 0; j < size; j++){
            if( i != j ){
                if(  $("#APPLINE_APPU_TYPE_" + i).val() != "02"  && $("#APPLINE_APPU_TYPE_" + j).val() != "02"  ){
                    if( $("#APPLINE_APPU_ENC_NUMB_" + i).val() == $("#APPLINE_APPU_ENC_NUMB_" + j).val()  ){
                   	 isDuplicate = true;
                    }
                }
            }
        }
    }
    //[CSR ID:3438118] flexible time 시스템 요청  eunha 20170905 Flextime에서 담당결재가 2차까지 있어 로직이 제대로 수행되지 않아 수정 end

    if(isEmpty) {
        alert("<spring:message code='MSG.COMMON.0024' />");// 결재자 이름을 입력하세요.
        return false;
    }

    if(isDuplicate) {
        alert("<spring:message code="MSG.COMMON.0025"/>");    //결재자가 중복 입력되었습니다.
        return false;
    }

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
    <c:if test="${!disable and disableApprovalLine != true}" >
    <!-- 결재자 입력 테이블 시작-->
    <h2 class="subtitle"><spring:message code="MSG.APPROVAL.0011" /><%--승인자정보--%></h2>

    <!-- 결재라인 테이블 시작-->
    <tags-approval:approval-line-layout approvalLine="${approvalLine}" />
    <!-- 결재라인 테이블 End-->
    </c:if>

</form>

<%--  신청 button --%>
<tags-approval:button-layout buttonType="R" button="${button}" disable="${disable}"/>
<%-- 하단 추가 부분 --%>