<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 피부양자 신청                                      */
/*   Program Name : 건강보험 피부양자 취득/상실 조회                            */
/*   Program ID   : E01MedicareDetail.jsp                                       */
/*   Description  : 건강보험 피부양자 자격(취득/상실) 조회 하는 화면            */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-02-28  윤정현                                          */
/*                  2006-11-13  @v1.0 lsa 관계추가                              */
/*                                                                              */
/*                   2016.10.18 [CSR ID:3194400] HR제도안내 및 신청화면 수정 건 김불휘S                                                           */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E01Medicare.*" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="hris.A.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />



<%
    WebUserData user = WebUtil.getSessionUser(request);

    /* 현재 레코드를 vector로 받는다*/
    Vector                 e01HealthGuaranteeData_vt = (Vector)request.getAttribute("e01HealthGuaranteeData_vt");
    E01HealthGuaranteeData data                      = (E01HealthGuaranteeData)e01HealthGuaranteeData_vt.get(0);
    String ThisJspName = (String)request.getAttribute("ThisJspName");


    //@v1.0 가족사항detail data get
    A04FamilyDetailRFC   rfcF   = new A04FamilyDetailRFC();
    Vector family_vt = new Vector();
    Box box = WebUtil.getBox(request);
    box.put("I_PERNR", data.PERNR);
    family_vt = rfcF.getFamilyDetail(box );

%>
<c:set var="e01HealthGuaranteeData_vt_size" value="<%=e01HealthGuaranteeData_vt.size() %>"/>
<c:set var="family_vt_size" value="<%=family_vt.size() %>"/>
<c:set var="family_vt" value="<%=family_vt %>"/>

    <tags:layout css="ui_library_approval.css" script="dialog.js" >
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_HEAL_INSUR"  updateUrl="${g.servlet}hris.E.E01Medicare.E01MedicareChangeSV">
                <tags:script>
                    <script>
-


function do_delete(){
    if( chk_APPR_STAT(1) && confirm("<spring:message code='MSG.E.E01.0014' />") ) { //정말 삭제하시겠습니까?
        document.form1.jobid.value = "delete";
        document.form1.AINF_SEQN.value = "${firstData.AINF_SEQN}";
        document.form1.SUBTY.value     = "${firstData.SUBTY}";
        document.form1.OBJPS.value     = "${firstData.OBJPS}";

        document.form1.action = "${g.servlet}hris.E.E01Medicare.E01MedicareDetailSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function do_preview(){
    document.form1.jobid.value = "first";
    document.form1.SUBTY.value = "${firstData.SUBTY}";
    document.form1.OBJPS.value = "${firstData.OBJPS}";

    document.form1.action = "${g.servlet}hris.A.A12Family.A12FamilyBuild01SV";
    document.form1.method = "post";
    document.form1.submit();
}

// 조회될 항목들 화면에 뿌리기
function show_detail() {
    var command = "";
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
        size = 1;
    } else {
        size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = i+"";
        }
    }

    eval("document.form1.APPL_TYPE.value = document.form1.APPL_TYPE"+command+".value");
    eval("document.form1.APPL_TEXT.value = document.form1.APPL_TEXT"+command+".value");

    if( document.form1.APPL_TYPE.value == "0001" ) {          // 자격취득
        eval("document.form1.ACCQ_DATE.value = addPointAtDate(document.form1.ACCQ_LOSS_DATE" +command+".value)");
        eval("document.form1.ACCQ_TEXT.value =                document.form1.ACCQ_LOSS_TEXT" +command+".value");

        document.form1.LOSS_DATE.value = "";
        document.form1.LOSS_TEXT.value = "";
    } else if( document.form1.APPL_TYPE.value == "0002" ) {   // 자격상실
        document.form1.ACCQ_DATE.value = "";
        document.form1.ACCQ_TEXT.value = "";

        eval("document.form1.LOSS_DATE.value = addPointAtDate(document.form1.ACCQ_LOSS_DATE" +command+".value)");
        eval("document.form1.LOSS_TEXT.value =                document.form1.ACCQ_LOSS_TEXT" +command+".value");
    }

    eval("document.form1.HITCH_TEXT.value  = document.form1.HITCH_TEXT"     +command+".value");
    eval("document.form1.HITCH_GRADE.value = document.form1.HITCH_GRADE"    +command+".value");
    eval("document.form1.HITCH_DATE.value  = addPointAtDate(document.form1.HITCH_DATE"     +command+".value)");
    eval("document.form1.APPL_TEXT.value   = document.form1.APPL_TEXT"      +command+".value");
    eval("document.form1.ENAME.value       = document.form1.ENAME"          +command+".value");
    eval("document.form1.SUBTY_INAME.value       = document.form1.SUBTY_INDEX"          +command+".value");

    if( eval("document.form1.APRT_CODE"+command+".value") == "X" ) {
      document.form1.APRT_CODE.checked = true;
    } else {
      document.form1.APRT_CODE.checked = false;
    }
}
</script>
</tags:script>

    <c:if test="${!approvalHeader.chargeArea and ! approvalHeader.showManagerArea }">
              <!-- 상단 입력 테이블 시작-->
				<div class="tableArea">
                  <div class="table">
	                  <table class="tableGeneral tableApproval">
            		<colgroup>
            			<col width="15%" />
            			<col width="35%" />
            			<col width="15%" />
            			<col width="35%" />
            		</colgroup>
	                <tr>
	                  <th><spring:message code='LABEL.E.E22.0042' /><!-- 신청구분 --></th>
	                  <td >
	                    <input type="text"   name="APPL_TEXT" value="${firstData.APPL_TEXT}" readonly size="14">
	                    <input type="hidden" name="APPL_TYPE" value="${firstData.APPL_TYPE}" readonly size="14">
	                    <input type="hidden" name="BEGDA" value="${firstData.BEGDA}" readonly size="14">
                   </td>
	                  <th  class="th02"><spring:message code='LABEL.E.E01.0002' /><!-- 대상자 성명 --></th>
	                  <td >
	                    <input type="text" name="ENAME" value="${firstData.ENAME}" readonly size="8">
	                    <a href="javascript:open_rule('Rule02Benefits01.html');" class="inlineBtn unloading" style="float:right"><span><spring:message code='LABEL.E.E01.0001' /><!-- 피부양자 자격요건 --></span></a>
	                    <c:forEach var="row" items="${family_vt}" varStatus="status">
	                    <c:set var="fname" value="${row.LNMHG} ${row.FNMHG}"/>
	                           <c:if test ="${firstData.SUBTY eq row.SUBTY and firstData.ENAME eq fname }" >
	                                 <input type="text" name="SUBTY_INAME" value=" ${row.ATEXT}" class="input04" size="23" readonly>
                     			</c:if>
                        </c:forEach>
                        <input type="hidden" name="APRT_CODE" value="${firstData.APRT_CODE}" size="20">
				      </td>
	                </tr>
	                <tr>
	                  <th><spring:message code='LABEL.E.E01.0003' /><!-- 취득일자 --></th>
	                  <td><input type="text" name="ACCQ_DATE" value="${firstData.APPL_TYPE eq '0001' ? f:printDate( firstData.ACCQ_LOSS_DATE) : '' }"  readonly size="14"></td>
	                  <th class="th02"><spring:message code='LABEL.E.E01.0004' /><!-- 취득사유 --></th>
	                  <td><input type="text" name="ACCQ_TEXT" value="${firstData.APPL_TYPE eq '0001' ?  firstData.ACCQ_LOSS_TEXT : '' }" readonly size="35"></td>
	                </tr>
	                <tr>
	                  <th><spring:message code='LABEL.E.E01.0005' /><!-- 상실일자 --></th>
	                  <td><input type="text" name="LOSS_DATE" value="${firstData.APPL_TYPE eq '0002' ? f:printDate( firstData.ACCQ_LOSS_DATE) : '' }"  readonly size="14"></td>
	                  <th class="th02"><spring:message code='LABEL.E.E01.0006' /><!-- 상실사유 --></th>
	                  <td><input type="text" name="LOSS_TEXT" value="${firstData.APPL_TYPE eq '0002' ?  firstData.ACCQ_LOSS_TEXT : '' }"   readonly size="35"></td>
	                </tr>
	                <tr>
	                  <th><spring:message code='LABEL.E.E01.0007' /><!-- 장애인 --></th>
	                  <td colspan="3">
	                  	<table class="innerTable" width="700" border="0" cellspacing="0" cellpadding="0">
		                      <tr>
		                        <th class="noBtBorder" width="60"><spring:message code='LABEL.E.E01.0008' /><!-- 종별부호 --></th>
		                        <td class="noBtBorder" width="100"><input type="text" name="HITCH_TEXT" value="${firstData.HITCH_TEXT}" readonly size="12"></td>
		                        <th class="noBtBorder" width="40"><spring:message code='LABEL.E.E01.0014' /><!-- 등 급 --> </th>
		                        <td class="noBtBorder" width="60"><input type="text" name="HITCH_GRADE" value="${firstData.HITCH_GRADE eq '00' ? '' : firstData.HITCH_GRADE}" readonly size="5"></td>
		                        <th class="noBtBorder" width="50"><spring:message code='LABEL.E.E01.0009' /><!-- 등록일 --></th>
		                        <td class="noBtBorder noRtBorder"><input type="text" name="HITCH_DATE" value="${firstData.HITCH_DATE eq '0000-00-00' ? '' : f:printDate(firstData.HITCH_DATE)}" readonly size="20"></td>
                            </tr>
                          </table>

                        </td>
                    </tr>
                  </table>
	 		<%-- [CSR ID:3430058] HR제도안내 수정 건 start--%>
            <%-- <span class="commentOne"><spring:message code='LABEL.E.E01.0013' /><!-- ※ 제출서류 : 가족관계증명서 또는 주민등록등본(단,사망의 경우 건강보험증, 사망진단서 또는 가족관계증명서 1부) --></span>  --%>
	        <div class="commentImportant" style="width:640px;">
            <p><strong><spring:message code='LABEL.E.E01.0015' /><!-- ※ 제출서류 --></strong></p>
            <p><spring:message code='LABEL.E.E01.0016' /><!-- . 동거시 : 구비서류 생략 가능 --></p>
            <p><spring:message code='LABEL.E.E01.0017' /><!-- . 비동거시 : <u>신청대상 가족 명의</u> 가족관계증명서 1부--></p>
            <p><spring:message code='LABEL.E.E01.0018' /><!-- ※ 배우자 최초 등재시 : 혼인관계증명서'(상세)'본 제출必 --></p>
            <p><spring:message code='LABEL.E.E01.0019' /><!-- ※ 상세사항은 화면 우측상단의 피부양자 자격요건 메뉴 참고 --></p>
            <%-- [CSR ID:3430058] HR제도안내 수정 건 end --%>
        </div>
         </div>
		</div>
</c:if>

<c:if test ="${e01HealthGuaranteeData_vt_size>0}">

            <div class="listArea">
            	<div class="table">
            	<table class="listTable">
	                <thead>
	                <tr>
	                <c:if test="${!approvalHeader.chargeArea and ! approvalHeader.showManagerArea }">
			            <th ><spring:message code='LABEL.COMMON.0014' /><!-- 선택 --></th>
			         </c:if>
			            <th><spring:message code='LABEL.E.E18.0034' /><!-- No. --></th>
			            <th><spring:message code='LABEL.E.E22.0042' /><!-- 신청구분 --></th>
			            <th><spring:message code='LABEL.E.E20.0004' /><!-- 대상자 --><br><spring:message code='MSG.APPROVAL.0013' /><!-- 성명 --></th>
			            <th ><spring:message code='LABEL.E.E19.0053' /><!-- 관계 --></th>
			            <th><spring:message code='LABEL.E.E01.0003' /><!-- 취득일자 -->/<br><spring:message code='LABEL.E.E01.0005' /><!-- 상실일자 --></th>
			            <th ><spring:message code='LABEL.E.E01.0004' /><!-- 취득사유 -->/<spring:message code='LABEL.E.E01.0006' /><!-- 상실사유 --></th>
			            <!-- [CSR ID:3194400] HR제도안내 및 신청화면 수정 건
			            <th width="60">원격지<br>발급여부</th>-->
			            <th ><spring:message code='LABEL.E.E01.0007' /><!-- 장애인 --><br><spring:message code='LABEL.E.E01.0008' /><!-- 종별부호 --></th>
			            <th><spring:message code='LABEL.E.E01.0007' /><!-- 장애인 --><br><spring:message code='LABEL.E.E21.0007' /><!-- 등급 --></th>
			            <th class="lastCol" width="60"><spring:message code='LABEL.E.E01.0007' /><!-- 장애인 --><br><spring:message code='LABEL.E.E01.0009' /><!-- 등록일 --></th>
			          </tr>
			          </thead>
		<c:forEach var="row1" items="${e01HealthGuaranteeData_vt}" varStatus="status1">
                <tr class="${f:printOddRow(status1.index)}">
                <c:if test="${!approvalHeader.chargeArea and ! approvalHeader.showManagerArea }">
                  <td>
                  <input type="radio" name="radiobutton" value="" ${status1.index eq  '0' ? 'checked' : ''}></td>
                  </c:if>
                  <td>${status1.count}</td>
                  <td>${row1.APPL_TEXT }</td>
                  <td>${row1.ENAME }</td>
			      <td>
             <c:forEach var="row" items="${family_vt}" varStatus="status">

             	<c:set var="fname" value="${row.LNMHG} ${row.FNMHG}"/>
             <c:if test ="${row.SUBTY eq row1.SUBTY and row1.ENAME eq fname }" >
             ${row.ATEXT}
             <input type="hidden" name="SUBTY_INDEX${status1.index}" value=" ${row.ATEXT}" class="input04" size="14" readonly>
			 </c:if>
			 </c:forEach>
            </td>
                  		<td>${f:printDate(row1.ACCQ_LOSS_DATE)}</td>
                  		<td>${row1.ACCQ_LOSS_TEXT}</td>
                  		<!-- [CSR ID:3194400] HR제도안내 및 신청화면 수정 건
                  		<td>${row1.APRT_CODE eq 'X' ? 'Y' : ''}</td>-->
                  		<td>${row1.HITCH_TEXT}</td>
                  		<td>${row1.HITCH_GRADE eq '00' ? '' : row1.HITCH_GRADE}</td>
                  		<td class="lastCol">${row1.HITCH_DATE eq '0000-00-00' ? '' : f:printDate(row1.HITCH_DATE)}
                  		<input type="hidden" name="use_flag${status1.index}"      value="Y">
                  		<input type="hidden" name="APPL_TYPE${status1.index}"     value="${row1.APPL_TYPE}">
                  		<input type="hidden" name="SUBTY${status1.index}"          value="${row1.SUBTY}">
                  		<input type="hidden" name="OBJPS${status1.index}"       value="${row1.OBJPS}">
                  		<input type="hidden" name="ACCQ_LOSS_DATE${status1.index}" value="${f:printDate(row1.ACCQ_LOSS_DATE)}">
                  		<input type="hidden" name="ACCQ_LOSS_TYPE${status1.index}" value="${row1.ACCQ_LOSS_TYPE}">
                  		<input type="hidden" name="HITCH_TYPE${status1.index}"     value="${row1.HITCH_TYPE}">
                  		<input type="hidden" name="HITCH_GRADE${status1.index}"    value="${row1.HITCH_GRADE eq '00' ? '' : row1.HITCH_GRADE}">
                  		<input type="hidden" name="HITCH_DATE${status1.index}"     value="${row1.HITCH_DATE eq '0000-00-00' ? '' : f:printDate(row1.HITCH_DATE)}">
                  		<input type="hidden" name="APPL_TEXT${status1.index}"      value="${row1.APPL_TEXT}">
                  		<input type="hidden" name="ACCQ_LOSS_TEXT${status1.index}" value="${row1.ACCQ_LOSS_TEXT}">
                  		<input type="hidden" name="HITCH_TEXT${status1.index}"     value="${row1.HITCH_TEXT}">
                  		<input type="hidden" name="ENAME${status1.index}"          value="${row1.ENAME}">
                  		<input type="hidden" name="APRT_CODE${status1.index}"      value="${row1.APRT_CODE}">
			            </td>
			          </tr>
				</c:forEach>
              </table>
              </div>
              <c:if test="${!approvalHeader.chargeArea and ! approvalHeader.showManagerArea }">
		       	<div class="buttonArea">
		       		<ul class="btn_mdl">
		       			<li><a href="javascript:show_detail();"><span><spring:message code='BUTTON.COMMON.SEARCH' /><!-- 조회 --></span></a></li>
		       		</ul>
		       	</div>
		       </c:if>
              </div>
		</c:if>
<!--  HIDDEN  처리해야할 부분 시작-->

      <input type="hidden" name="PERNR"       value="${firstData.PERNR}">
      <input type="hidden" name="SUBTY"       value="">
      <input type="hidden" name="OBJPS"       value="">

<!--  HIDDEN  처리해야할 부분 끝-->
    </tags-approval:detail-layout>
</tags:layout>