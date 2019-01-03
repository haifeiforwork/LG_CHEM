<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Personal HR Info                                                  															*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Time Sheet                                               																	*/
/*   Program ID   		: D07TimeSheetDetailUsa.jsp                                             													*/
/*   Description  		: Time Sheet 상세 보기 화면 (USA - LG CPI(G400))                          											*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-10-11 jungin @v1.0 LGCPI 법인 Time Sheet 신규 개발														*/
/*   Update				: 2011-02-11 jungin @v1.1 [C20110124_13389] 결재요청 취소(Cancle Application) 추가.					*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D07TimeSheet.*" %>
<%@ page import="hris.D.D07TimeSheet.rfc.*" %>
<%
    WebUserData user = (WebUserData)session.getAttribute("user");

    String jobid = (String)request.getAttribute("jobid");
    //String message = (String)request.getAttribute("message");


	String E_PAYDRX = (String)request.getAttribute("E_PAYDRX");

    Vector D07TimeSheetDeatilDataUsa_vt = null;
    Vector D07TimeSheetSummaryDataUsa_vt = null;

    D07TimeSheetDeatilDataUsa_vt = (Vector)request.getAttribute("D07TimeSheetDeatilDataUsa_vt");
    D07TimeSheetSummaryDataUsa_vt = (Vector)request.getAttribute("D07TimeSheetSummaryDataUsa_vt");

    //D07TimeSheetApproverDataUsa approverData = (D07TimeSheetApproverDataUsa)request.getAttribute("E_APPROVER");

    String message = (String)request.getAttribute("E_MESSAGE");
    String E_BEGDA = (String)request.getAttribute("E_BEGDA");
    String E_ENDDA = (String)request.getAttribute("E_ENDDA");
    String PERNR = (String)request.getAttribute("PERNR");

 /*   Vector AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");


   String btnSubmit = "btn_build.gif";
   String btnSubmitCancel = "btn_cancelApplication.gif";
   if (user.e_area.equals("10")){
   	btnSubmit = "btn_Summit.gif";
   	btnSubmitCancel = "btn_cancelSummit.gif";

   }
   */
%>
<c:set var="E_ENDDA" value="<%=E_ENDDA %>" />
<c:set var="E_BEGDA" value="<%=E_BEGDA %>" />
<c:set var="E_PAYDRX" value="<%=E_PAYDRX %>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="D07TimeSheetSummaryDataUsa_vt" value="<%=D07TimeSheetSummaryDataUsa_vt %>" />
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PT_TIME_SHEET" updateUrl="${g.servlet}hris.D.D07TimeSheet.D07TimeSheetChangeUsaSV" hideHeader="${iframeYn}" hideApprovalLine="${iframeYn}" >
        <%-- 결재 승인 및 반려시 의견 입력시 화면에 정보성으로 보여줄 내용
        <tags:script>
            <script>
                $(function() {
                    /* 승인 부 */
                    $("#-accept-dialog").dialog({
                        open : function() {
                            $("#-accept-info").text("결재 승인 창 상단에 보여줄 텍스트 입력하세요.");
                        }
                    });
                    /* 반려 부 */
                    $("#-reject-dialog").dialog({
                        open : function() {
                            $("#-reject-info").text("결재 승인 창 상단에 보여줄 텍스트 입력하세요.");
                        }
                    });
                });
            </script>
        </tags:script>
        --%>
        <div class="tableArea">
            <div class="table">
                <tags:script>
                    <script>

$(document).ready(function(){
	msg();
	init();
	if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
 });
// msg 를 보여준다.
function msg() {

}

function init() {
	var frm = document.form1;
	$("#cancelPage").val("javascript:history.back();");

	<c:if  test="${ iframeYn=='true'}">
	$(".-update-button").hide();
	$(".-delete-button").hide();
	</c:if>

   <c:if  test="${approverData.APPR_STAT  eq 'A' and  iframeYn!='true' and I_APGUB !='2' and I_APGUB !='1'  }">
	frm.TBEGDA.disabled = true;
	frm.TENDDA.disabled = true;
  	$("#btn_pre").hide();
  	$("#btn_next").hide();
   </c:if>
}

// 날짜 변경해서 보낸다.
// 달력사용
function doPayDateSearch (i_paydr, i_lcldt) {
	var frm = document.form1;

	// 필수 필드의 형식 체크
    /*if (frm.PAYDR.options[frm.PAYDR.selectedIndex].value == "") {
    	alert("Please select Pay Date Range.");
    	frm.PAYDR.focus();
        return;
    }*/

	frm.I_PAYDR.value = i_paydr;		// Week 유형 (Previous Week - PW / Next Week - NW)
	frm.I_LCLDT.value = i_lcldt;		// 현재 화면 Week의 시작일
	if(parent.resizeIframe) parent.setVal(i_paydr, i_lcldt);
	frm.action = "${g.servlet}hris.D.D07TimeSheet.D07TimeSheetDetailUsaSV";
	frm.target = "_self";
	frm.method = "post";
	frm.submit();
}

// Print
function f_print (i_paydr, i_lcldt) {
	var frm = document.form1;

	// 필수 필드의 형식 체크
    /*if (frm.PAYDR.options[frm.PAYDR.selectedIndex].value == "") {
    	alert("Please select Pay Date Range.");
    	frm.PAYDR.focus();
        return;
    }*/

	var ainf_seqn = frm.AINF_SEQN.value;
	var appr_stat = "X";

	window.open('', 'timeCardWindow', "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,width=780,height=650,left=0,top=2");
	frm.target = "timeCardWindow";
	frm.action = "${g.jsp}common/printFrame_TimeSheetUsa.jsp?I_PAYDR="+i_paydr+"&I_LCLDT="+i_lcldt+"&AINF_SEQN="+ainf_seqn+"&APPR_STAT="+appr_stat;
	frm.method = "post";
	frm.submit();
}

function go_change (i_paydr, i_lcldt) {
	var frm = document.form1;

    // 필수 필드의 형식 체크
    /*if (frm.PAYDR.options[frm.PAYDR.selectedIndex].value == "") {
    	alert("Please select Pay Date Range.");
    	frm.PAYDR.focus();
        return;
    }*/

	var ainf_seqn = frm.AINF_SEQN.value;

    frm.jobid.value = "first";
	frm.action = "${g.servlet}hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV?I_PAYDR="+i_paydr+"&I_LCLDT="+i_lcldt+"&AINF_SEQN="+ainf_seqn;
	frm.target = "_self";
	frm.method = "post";
    frm.submit();
}

function go_cancle () {
	var frm = document.form1;

    frm.TBEGDA.value = removePoint(frm.TBEGDA.value);
	frm.TENDDA.value = removePoint(frm.TENDDA.value);

	var ainf_seqn = frm.AINF_SEQN.value;

	if (confirm("Are you sure to cancel?")) {
	    frm.jobid.value = "cancle";
		frm.action = "${g.servlet}hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV?SUM_AINF_SEQN="+ainf_seqn;
		frm.target = "_self";
		frm.method = "post";
	    frm.submit();
    }
}

</script>
</tags:script>





    <div class="tableInquiry">
      <table>
      	<colgroup>
      		<col width="15%" />
      		<col />
      	</colgroup>
        <tr style="line-height:0px ">
          <th><!--Pay Date Range --><spring:message code="LABEL.D.D07.0002"/></th>
          <td>
            <a class="inlineBtn" href="javascript:doPayDateSearch('PW', '${f:deleteStr(E_BEGDA,'-')}')"><span id= "btn_pre"><!-- Previous --><spring:message code="BUTTON.COMMON.PREVIOUS"/></span></a>
            <input type="text" name="TBEGDA" size="10" value="${f:printDate(E_BEGDA)}" readonly>
            ~
            <input type="text" name="TENDDA" size="10"value="${f:printDate(E_ENDDA)}" readonly>
            <a class="inlineBtn" href="javascript:doPayDateSearch('NW', '${f:deleteStr(E_BEGDA, '.')}' )"><span id= "btn_next"><!-- Next --><spring:message code="BUTTON.COMMON.NEXT"/></span></a>
          </td>
        </tr>
      </table>
    </div>



  <!-- 리스트테이블 시작 -->
  <div class="listArea">
	<!-- Hours Summary 테이블 시작 -->
  	<div class="listTop">
  		<h2 class="subtitle withButtons"><!--Hours Summary --><spring:message code="LABEL.D.D07.0003"/></h2>

    <div class="buttonArea">
    <c:if test="${PERNR eq user.empNo}">
		<ul class="btn_mdl">
 				<a href="javascript:f_print('CW', '${f:deleteStr(E_BEGDA, '-')}');"><span><spring:message code="BUTTON.COMMON.PRINTVIEW"/></span></a>
		</ul>
	</c:if>
	</div>
  	</div>
    <div class="table">
      <table class="listTable">
      	<colgroup>
      		<col width="50%" />
      		<col />
      	</colgroup>
      	<thead>
        <tr>
          <th class="align_center"><!--Time Type --><spring:message code="LABEL.D.D07.0010"/></th>
          <th class="lastCol align_center"><!--Hours --><spring:message code="LABEL.D.D07.0005"/></th>
        </tr>
        </thead>
       <c:if test="${f:getSize(D07TimeSheetSummaryDataUsa_vt)>0}">
		 <c:forEach var="row" items="${D07TimeSheetSummaryDataUsa_vt}" varStatus="status" >
        	<tr class= "${f:printOddRow(status.index)}">
          		<td class="${row.LGTXT eq 'Total' ? 'td11' : '' }" style="text-align:left;padding-left:5"> ${row.LGTXT }</td>
          		<td class="${row.LGTXT eq 'Total' ? 'td11' : '' } lastCol"  style="text-align:right;padding-left:5" > ${row.WKHRS }</td>
        	</tr>

   		 </c:forEach>
      </c:if>
       <c:if test="${f:getSize(D07TimeSheetSummaryDataUsa_vt) <1}">
                <tags:table-row-nodata list="${D07TimeSheetSummaryDataUsa_vt}" col="2" />
        </c:if>
      </table>
    </div>
  </div>
  <!-- 리스트테이블 끝-->


	<!-- Timecard Details 테이블 시작 -->
	<h2 class="subtitle"><!--Timecard Details--><spring:message code="LABEL.D.D07.0011"/></h2>

	<!-- 리스트테이블 시작 -->
	<div class="listArea">
		<div class="table">
			<table class="listTable">
			   <thead>
				<tr>
					<th><!--Date In --><spring:message code="LABEL.D.D07.0004"/></th>
					<th><!--Hours --><spring:message code="LABEL.D.D07.0005"/></th>
					<th><!--Daily Totals --><spring:message code="LABEL.D.D07.0006"/></th>
					<th><!--A/A Type --><spring:message code="LABEL.D.D07.0007"/></th>
					<th><!--Cost Center--><spring:message code="LABEL.D.D07.0008"/></th>
					<th class="lastCol"><!--WBS --><spring:message code="LABEL.D.D07.0009"/>
					<input type="hidden" name="BEGDA" value="${approvalHeader.RQDAT}" >
					</th>
				</tr>
				</thead>

				<c:forEach var="row" items="${D07TimeSheetDeatilDataUsa_vt}" varStatus="status" >
				<c:if test="${row.WKDAT !='0000-00-00' and row.WKDAT !='0000.00.00'}">
					<c:choose>
					       <c:when  test="${row.WEEKDAY_L eq day}">
								   <c:choose>
								    <c:when  test="${f:printOddRow(status.index) eq 'oddRow'}">
								            <c:set var="dateStyle" value= "style=\"ime-mode:active;text-align:center;color:#F5F5F5;\"" />
                					        <c:set var="atextStyle" value= "style=\"ime-mode:active;text-align:left;padding-left:5;color:#F5F5F5;\"" />
								    </c:when>
								    <c:otherwise>
								          <c:set var="dateStyle" value= "style=\"ime-mode:active;text-align:center;color:#FFFFFF;\"" />
                					      <c:set var="atextStyle" value= "style=\"ime-mode:active;text-align:left;padding-left:5;color:#FFFFFF;\"" />
     							    </c:otherwise>
     							    </c:choose>
     					    </c:when>
    					    <c:otherwise>
                					<c:set var="dateStyle" value= "style=\"ime-mode:active;text-align:center;\""/>
                					<c:set var="atextStyle" value="style=\"ime-mode:active;text-align:left;padding-left:5;\""/>
                			</c:otherwise>
                	</c:choose>
                <tr class="${f:printOddRow(status.index)}">
				  <td ${dateStyle}>${f:printDate(row.WKDAT)}</td>
				  <td class="align_right">${f:printNumFormat(row.WKHRS,2)}</td>
				  <td class="align_right">${f:printNumFormat(row.DYTOT,2)}</td>
				  <td ${atextStyle}>${row.ATEXT}</td>
				  <td class="align_left">${row.KOSTL}</td>
				  <td class="align_left lastCol">${row.POSID}</td>
                </tr>
              </c:if>
      			<c:set var="day" value="${row.WEEKDAY_L}"/>
    			<c:set var="date" value="${row.WKDAT}"/>

               </c:forEach>
               <c:if test="${f:getSize(D07TimeSheetDeatilDataUsa_vt) <1}">

                        <tags:table-row-nodata list="${D07TimeSheetDeatilDataUsa_vt}" col="6" />
                    </c:if>
                <input type="hidden" name="rowCount" value = "${f:getSize(D07TimeSheetDeatilDataUsa_vt)}">

              </table>
		</div>
	</div>
	<!-- 리스트테이블 끝-->
<c:if  test="${ iframeYn=='true'}">
    <div class="buttonArea">
        <ul class="btn_crud">
            	<c:if test="${ approverData.APPR_STAT  ne 'A' }">
            		<li><a class="darken" href="javascript:go_change('CW', '${f:deleteStr(E_BEGDA, '-')}')" ><span><!-- 수정 --><spring:message code="BUTTON.COMMON.UPDATE"/></span></a></li>
            	</c:if>
                 <c:if  test="${not empty approverData.AINF_SEQN  and  approverData.APPR_STAT  ne 'A'}">
            		<li><a class="darken" href="javascript:go_cancle('CW', '${f:deleteStr(E_BEGDA, '-')}')" ><span><!-- 삭제 --><spring:message code="BUTTON.COMMON.DELETE"/></span></a></li>
            	  </c:if>
        </ul>
    </div>
 </c:if>

</div>
<input type="hidden" name="I_PAYDR" value="">
<input type="hidden" name="PERNR" value="${PERNR}">
<input type="hidden" name="I_LCLDT" value="">
<input type="hidden" name="iframeYn" value="${iframeYn}">
<input type="hidden" name="jobid2" value="printFirst">
    </tags-approval:detail-layout>
</tags:layout>
