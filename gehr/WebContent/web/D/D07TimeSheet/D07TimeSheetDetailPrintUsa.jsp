<%/***************************************************************************************/
/*   System Name    : g-HR                                                                                                                              */
/*   1Depth Name    : Personal HR Info                                                                                                              */
/*   2Depth Name    : Time Management                                                                                                           */
/*   Program Name   : Time Sheet                                                                                                                */
/*   Program ID         : D07TimeSheetDetailPrintUsa.jsp                                                                                        */
/*   Description        : Time Sheet 상세조회 출력 화면 (USA - LGCPI(G400))                                                             */
/*   Note               :                                                                                                                                   */
/*   Creation           : 2010-10-11 jungin @v1.0 LGCPI 법인 Time Sheet 신규 개발                                                     */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D07TimeSheet.*" %>
<%@ page import="hris.D.D07TimeSheet.rfc.*" %>
<%
    WebUserData user = (WebUserData)session.getAttribute("user");
    WebUserData user_m = (WebUserData)session.getAttribute("user_m");

    String jobid = (String)request.getAttribute("jobid");
    String empName = (String)request.getAttribute("empName");

    String PERNR = (String)request.getAttribute("PERNR");
    String E_BUKRS = (String)request.getAttribute("E_BUKRS");

    String PAYDR = (String)request.getAttribute("PAYDR");

    Vector D07TimeSheetDeatilDataUsa_vt = null;
    Vector D07TimeSheetSummaryDataUsa_vt = null;

    D07TimeSheetDeatilDataUsa_vt = (Vector)request.getAttribute("D07TimeSheetDeatilDataUsa_vt");
    D07TimeSheetSummaryDataUsa_vt = (Vector)request.getAttribute("D07TimeSheetSummaryDataUsa_vt");

    D07TimeSheetApproverDataUsa approverData = (D07TimeSheetApproverDataUsa)request.getAttribute("E_APPROVER");

    //String message = (String)request.getAttribute("E_MESSAGE");
    String E_BEGDA = (String)request.getAttribute("E_BEGDA");
    String E_ENDDA = (String)request.getAttribute("E_ENDDA");
    Date currentDate = DataUtil.getDate(request);
	String sDate	=currentDate.toString();
	String sTime		=sDate.substring(11,13)+sDate.substring(14,16)+sDate.substring(17,19);

    /*
    if (message == null) {
        message = "";
    }
    */
%>
<jsp:include page="/include/header.jsp"/>
<!-- Page Skip 해서 프린트 하기 -->
<style type = "text/css">
P.breakhere {page-break-before: always}
</style>

<SCRIPT LANGUAGE="JavaScript">
<!--


function prevDetail() {
    switch (location.hash)  {
        case "#page2":
            location.hash="#page1";
        break;
    } // end switch
}

function nextDetail() {
    switch (location.hash)  {
        case "":
        case "#page1":
            location.hash ="#page2";
        break;
    } // end switch
}

function keypressed() {
    return false;
}

//document.onmousedown=click;
//document.onkeydown=keypressed;

//-->
</SCRIPT>


<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post" action="">
<input type="hidden" name="jobid2" value="">

<div class="winPop">
<div class="header">
		<span><!--Timecard View for --><%=g.getMessage("LABEL.D.D07.0015")%> <%= empName %></span>
		<a href="" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
</div>
<div class="clear"></div>
<div style="text-align:right">
  		<b><h2   class="subtitle"><%= WebUtil.printDate(DataUtil.getCurrentDate(request)) %>&nbsp;&nbsp;<%= WebUtil.printTime(sTime) %></h2></b>
</div>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                  <th width="140"><!--Timecard Date Range --><%=g.getMessage("LABEL.D.D07.0014")%></th>
                  <td style="align:left"><%= approverData.TEXT %>&nbsp;(<%= WebUtil.printDate(E_BEGDA) %>&nbsp;~&nbsp;<%= WebUtil.printDate(E_ENDDA) %>)</td>
                </tr>
                <tr>
                  <th width="140"><!--Supervisor --><%=g.getMessage("LABEL.D.D07.0013")%></th>
                  <td><%=approverData.ENAME%></td>
                </tr>
            </table>
        </div>
    </div>

    <!-- Hours Summary 테이블 시작 -->

    <h2 class="subtitle"><!--Hours Summary --><%=g.getMessage("LABEL.D.D07.0003")%></h2>

    <!-- 리스트테이블 시작 -->
     <div class="tableArea">
        <div class="table">
            <table class="listTable">
              <thead>
                <tr >
                  <th><!--Time Type --><%=g.getMessage("LABEL.D.D07.0010")%></th>
                  <th class="lastCol"><!--Hours --><%=g.getMessage("LABEL.D.D07.0005")%></th>
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
                <tr class="<%=WebUtil.printOddRow(i) %>">
                    <td class="<%= ts_summa.LGTXT.equals("Total") ? "td11" : "" %>" style="text-align:left;padding-left:5"><%= ts_summa.LGTXT %></td>
                    <td class="<%= ts_summa.LGTXT.equals("Total") ? "td11" : "" %> lastCol" style="text-align:right;padding-right:5"><%= ts_summa.WKHRS %></td>
                </tr>
<%
        }
    } else {
%>
                <tr class="oddRow">
                   <td class="lastCol" colspan="2"><!--No data --><%=g.getMessage("MSG.COMMON.0004")%></td>
                </tr>
<%
    }
%>
            </table>
        </div>
    </div>
    <!-- 리스트테이블 끝-->

    <!-- Timecard Details 테이블 시작 -->

    <h2 class="subtitle"><!--Timecard Details--><%=g.getMessage("LABEL.D.D07.0011")%></h2>

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

            if (!WebUtil.printDate(ts_data.WKDAT, ".").equals("0000.00.00")) {  // TOTAL

                // 같은 요일일경우, style 처리
                if (ts_data.WEEKDAY_L.equals(day)){
                	if (tr_class.equals("oddRow")) {
                        dateStyle = "style=\"ime-mode:active;text-align:center;color:#F5F5F5;\"";
                        atextStyle = "style=\"ime-mode:active;text-align:left;padding-left:5;color:#F5F5F5;\"";

                	}else {
                        dateStyle = "style=\"ime-mode:active;text-align:center;color:#F5F5F5;\"";
                        atextStyle = "style=\"ime-mode:active;text-align:left;padding-left:5;color:#F5F5F5;\"";

                	}

                }else {
                    dateStyle = "style=\"ime-mode:active;text-align:center;\"";
                    atextStyle = "style=\"ime-mode:active;text-align:left;padding-left:5;\"";
                }
%>
                <tr class="<%=tr_class%>">
                    <td <%= dateStyle %>><%= WebUtil.printDate(ts_data.WKDAT, ".") %></td>
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
                <tr class="oddRow">
                   <td class="lastCol" colspan="6"><!--No data --><%=g.getMessage("MSG.COMMON.0004")%></td>
                </tr>
<%
    }
%>

            </table>
        </div>
    </div>
    <!-- 리스트테이블 끝-->
                             <table width="700" border="0" cellspacing="0" cellpadding="0">
				                <tr>
				                  	<td colspan="5" align="left" class="font01" style="padding-bottom:5px">&nbsp;<!--Signatures --><%=g.getMessage("LABEL.D.D07.0012")%></td>
				                </tr>
				                <tr>
				                	<td colspan="5" align="left" valign="top" style="border-bottom:2px solid #c8294b"></td>
				                </tr>
				                <tr>
				                	<td colspan="5" height="50">&nbsp;</td>
				                </tr>
				                <tr>
				                	<td colspan="2" align="left" valign="top" style="border-bottom:2px solid #c8294b"></td>
				                	<td></td>
				                	<td colspan="2" align="left" valign="top" style="border-bottom:2px solid #c8294b"></td>
				                <tr>
				                <tr>
				                	<td align="left" class="font01" style="padding-top:3px">&nbsp;<!--Signatures --><%=g.getMessage("LABEL.D.D07.0012")%></td>
				                	<td align="right" class="font01" style="padding-top:3px"><!-- Date --><%=g.getMessage("LABEL.D.D07.0016")%>&nbsp;</td>
				                	<td>&nbsp;&nbsp;&nbsp;</td>
				                	<td align="left" class="font01" style="padding-top:3px">&nbsp;<!--Signatures --><%=g.getMessage("LABEL.D.D07.0012")%></td>
				                	<td align="right" class="font01" style="padding-top:3px"><!-- Date --><%=g.getMessage("LABEL.D.D07.0016")%>&nbsp;</td>
				                </tr>
				              </table>


<input type="hidden" name="rowCount" value = "<%= D07TimeSheetDeatilDataUsa_vt.size() %>">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
