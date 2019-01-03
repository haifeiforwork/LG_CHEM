<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Employee Data                                                  																*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Time Sheet                                               																	*/
/*   Program ID   		: D07TimeSheetDetailUsa_m.jsp                                             												*/
/*   Description  		: 개인의 Time Sheet 상세 조회 하는 화면 (USA - LG CPI(G400))                          							*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-10-11 jungin @v1.0 LGCPI 법인 Time Sheet 신규 개발														*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D07TimeSheet.*" %>
<%@ page import="hris.D.D07TimeSheet.rfc.*" %>
<%@ page import="hris.common.approval.ApprovalHeader" %>
<%
	WebUserData user = (WebUserData)session.getAttribute("user");
	WebUserData user_m = (WebUserData)session.getAttribute("user_m");

   // String jobid = (String)request.getAttribute("jobid");
    String message = (String)request.getAttribute("message");

    String PERNR = (String)request.getAttribute("PERNR");
	String E_BUKRS = (String)request.getAttribute("E_BUKRS");
	String E_PAYDRX = (String)request.getAttribute("E_PAYDRX");

    Vector D07TimeSheetDeatilDataUsa_vt = null;
    Vector D07TimeSheetSummaryDataUsa_vt = null;

    D07TimeSheetDeatilDataUsa_vt = (Vector)request.getAttribute("D07TimeSheetDeatilDataUsa_vt");
    D07TimeSheetSummaryDataUsa_vt = (Vector)request.getAttribute("D07TimeSheetSummaryDataUsa_vt");

    //D07TimeSheetApproverDataUsa approverData = (D07TimeSheetApproverDataUsa)request.getAttribute("E_APPROVER");
    ApprovalHeader approvalHeader = (ApprovalHeader)request.getAttribute("approvalHeaderStatus");

    String E_BEGDA = (String)request.getAttribute("E_BEGDA");
    String E_ENDDA = (String)request.getAttribute("E_ENDDA");



    /*
    if (message == null) {
        message = "";
    }
    */
%>

<jsp:include page="/include/header.jsp"/>
<script language="JavaScript">
<!--
$(document).ready(function(){
	msg();
	init();
 });
// msg 를 보여준다.
function msg(){

}

function init() {

}

function doSearchDetail() {
    var frm = document.form1;
    frm.action = "<%= WebUtil.ServletURL %>hris.D.D07TimeSheet.D07TimeSheetDetailUsaSV_m";
    frm.target = "";
    frm.submit();
}

// 날짜 변경해서 보낸다.
// 달력사용
function doPayDateSearch(i_paydr, i_lcldt) {
	var frm = document.form1;

	// 필수 필드의 형식 체크
    /*if (frm.PAYDR.options[frm.PAYDR.selectedIndex].value == "") {
    	alert("Please select Pay Date Range.");
    	frm.PAYDR.focus();
        return;
    }*/

	frm.I_PAYDR.value = i_paydr;		// Week 유형 (Previous Week - PW / Next Week - NW)
	frm.I_LCLDT.value = i_lcldt;		// 현재 화면 Week의 시작일

	frm.jobid.value = "first";
	frm.action = "<%= WebUtil.ServletURL %>hris.D.D07TimeSheet.D07TimeSheetDetailUsaSV_m";
	frm.target = "_self";
	frm.method = "post";
	frm.submit();
}

// Print
function f_print(i_paydr, i_lcldt) {
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
	frm.action = "<%= WebUtil.JspURL %>common/printFrame_TimeSheetUsa.jsp?I_PAYDR="+i_paydr+"&I_LCLDT="+i_lcldt+"&AINF_SEQN="+ainf_seqn+"&APPR_STAT="+appr_stat;
	frm.method = "post";
	frm.submit();
}

//-->
</script>

 <jsp:include page="/include/body-header.jsp">
         <jsp:param name="title" value="COMMON.MENU.ESS_PT_TIME_SHEET"/>
        <jsp:param name="help" value="D07TimeSheetUsa.html"/>
    </jsp:include>

<form name="form1" method="post">
<input type="hidden" name="PERNR" value="<%= PERNR %>">
<input type="hidden" name="I_PAYDR" value="">
<input type="hidden" name="I_LCLDT" value="">
<input type="hidden" name="AINF_SEQN" value="<%= approvalHeader.AINF_SEQN %>">
<input type="hidden" name="APPR_STAT" value="">
				<!--   사원검색 보여주는 부분 시작   -->
				<%@ include file="/web/common/SearchDeptPersons_m.jsp"%>

				<!--   사원검색 보여주는 부분  끝    -->
<%if  ("X".equals(user_m.e_mss)){ %>
  <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">
      	<colgroup>
      		<col width="15%" />
      		<col />
      	</colgroup>
        <tr>
          <th><!--Pay Date Range --><%=g.getMessage("LABEL.D.D07.0002")%></th>
          <td>
            <a a class="inlineBtn" href="javascript:doPayDateSearch('PW', '<%= WebUtil.deleteStr(E_BEGDA, "-")  %>')"><span>Previous</span></a>
            <input type="text" name="TBEGDA" size="8" value="<%= WebUtil.printDate(E_BEGDA)  %>" readonly>
            <!-- <img src="<%= WebUtil.ImageURL %>icon_diary.gif" align="absmiddle" border="0">  -->
            ~
            <input type="text" name="TENDDA" size="8" value="<%= WebUtil.printDate(E_ENDDA)  %>" readonly>
            <!-- <img src="<%= WebUtil.ImageURL %>icon_diary.gif" align="absmiddle" border="0">&nbsp;  -->
            <a  class="inlineBtn" href="javascript:doPayDateSearch('NW', '<%= WebUtil.deleteStr(E_BEGDA, "-")  %>')"><span>Next</span></a>
          </td>
        </tr>
      </table>
    </div>
  </div>

	<!-- Hours Summary 테이블 시작 -->
	<div>
	<div style="float:left;">
  		<h2 class="subtitle"><!--Hours Summary --><spring:message code="LABEL.D.D07.0003"/></h2>
	</div>
    <div class="buttonArea">
		<ul class="btn_mdl">
 				<a href="javascript:f_print('CW', '<%= WebUtil.deleteStr(E_BEGDA, "-")  %>');"><span><spring:message code="BUTTON.COMMON.PRINTVIEW"/></span></a>
		</ul>
	</div>
		</div>

	<!-- 리스트테이블 시작 -->
	<div class="listArea">
		<div class="table">
			<table class="listTable">
				<colgroup>
					<col width="50%" />
					<col />
				</colgroup>
				<thead>
		        <tr>
		          <th class="align_center"><!--Time Type --><%=g.getMessage("LABEL.D.D07.0010")%></th>
		          <th class="lastCol align_center"><!--Hours --><%=g.getMessage("LABEL.D.D07.0005")%></th>
		        </tr>
		        </thead>
		        <%
		        	if (D07TimeSheetSummaryDataUsa_vt.size() > 0) {
		        		for (int i=0; i < D07TimeSheetSummaryDataUsa_vt.size(); i++) {
		        			D07TimeSheetSummaryDataUsa ts_summa = (D07TimeSheetSummaryDataUsa)D07TimeSheetSummaryDataUsa_vt.get(i);
		        			String tr_class = "";

                            if(i%2 == 0){
                                tr_class="oddRow";
                            }else{
                                tr_class="";
                            }
		        %>
		        <tr  class= "<%=tr_class %>">
					<td class="<%= ts_summa.LGTXT.equals("Total") ? "td11" : "" %>" style="text-align:left;padding-left:5"><%= ts_summa.LGTXT %></td>
					<td class="<%= ts_summa.LGTXT.equals("Total") ? "td11" : "" %> lastCol"  style="text-align:right;padding-left:5"><%= ts_summa.WKHRS %></td>
		        </tr>
		        <%
		        		}
		        	} else {
		        %>
		        <tr>
		           <td colspan="2"><!--No data --><%=g.getMessage("LABEL.D.D04.0039")%></td>
		        </tr>
		        <%
		        	}
		        %>
			</table>
		</div>
	</div>
	<!-- 리스트테이블 끝-->

	<!-- Timecard Details 테이블 시작 -->
	<h2 class="subtitle"><!--Timecard Details--><%=g.getMessage("LABEL.D.D02.0011")%></h2>

	<!-- 리스트테이블 시작 -->
	<div class="listArea">
		<div class="table">
			<table class="listTable">
			<thead>
				<tr>
                  <th><!--Date In --><%=g.getMessage("LABEL.D.D07.0004")%></th>
                  <th><!--Hours --><%=g.getMessage("LABEL.D.D07.0005")%></th>
                  <th><!--Daily Totals --><%=g.getMessage("LABEL.D.D07.0006")%></th>
                  <th><!--A/A Type --><%=g.getMessage("LABEL.D.D07.0007")%></th>
                  <th><!--Cost Center--><%=g.getMessage("LABEL.D.D07.0008")%></th>
                  <th class="lastCol"><!--WBS --><%=g.getMessage("LABEL.D.D07.0009")%></th>
				</tr>
			</thead>
                <%
	          		String day = "";
	          		String date = "";

	          		String dateStyle = "";
	          		String atextStyle = "";

                	if (D07TimeSheetDeatilDataUsa_vt.size() > 0) {
                		for (int i=0; i < D07TimeSheetDeatilDataUsa_vt.size(); i++) {
                			D07TimeSheetDetailDataUsa ts_data = (D07TimeSheetDetailDataUsa)D07TimeSheetDeatilDataUsa_vt.get(i);

                			String tr_class = "";

                            if(i%2 == 0){
                                tr_class="oddRow";
                            }else{
                                tr_class="";
                            }

                			if (!WebUtil.printDate(ts_data.WKDAT, ".").equals("0000.00.00")) {	// TOTAL 라인 제거

                				// 같은 요일일경우, style 처리
                				if (ts_data.WEEKDAY_L.equals(day)) {
                					dateStyle = "style=\"ime-mode:active;text-align:center;color:#FFFFFF;\"";
                					atextStyle = "style=\"ime-mode:active;text-align:left;padding-left:5;color:#FFFFFF;\"";

                				} else {
                					dateStyle = "style=\"ime-mode:active;text-align:center;\"";
                					atextStyle = "style=\"ime-mode:active;text-align:left;padding-left:5;\"";
                				}
                %>
				<tr class="<%=tr_class%>">
					<td <%= dateStyle %>><%= WebUtil.printDate(ts_data.WKDAT) %></td>
					<td class="align_right"><%= WebUtil.printNumFormat(ts_data.WKHRS, 2) %></td>
	  				<td class="align_right"><%= ts_data.DYTOT.equals("0") ? "0.00" : WebUtil.printNumFormat(ts_data.DYTOT, 2) %></td>
					<td <%= atextStyle %>><%= ts_data.ATEXT %></td>
					<td class="align_left"><%= ts_data.KOSTL %></td>
					<td class="align_left lastCol"><%= ts_data.POSID %></td>
				</tr>
                <%
                			}
                			day = ts_data.WEEKDAY_L;
                			date = ts_data.WKDAT;
                		}
                	} else {
                %>
                <tr>
                   <td colspan="6"><!--No data --><%=g.getMessage("LABEL.D.D04.0039")%></td>
                </tr>
                <%
                	}
                %>
				<input type="hidden" name="rowCount" value = "<%= D07TimeSheetDeatilDataUsa_vt.size() %>">
			</table>
		</div>
	</div>
	<!-- 리스트테이블 끝-->

</div>

<input type="hidden" name="jobid2" value="printGlobal">
<input type="hidden" name="pernr" value="">
<%} %>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
<!-- @v1.1-->
<iframe name="hidden" id="hidden" src="" width="0" height="0"></iframe>

</body>
</html>
