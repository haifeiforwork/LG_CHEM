<%/***************************************************************************************/
/*   System Name    : g-HR                                                                                                                          */
/*   1Depth Name    : Application                                                                                                                   */
/*   2Depth Name    : Time Management                                                                                                           */
/*   Program Name   : Time Sheet                                                                                                                */
/*   Program ID         : D07TimeSheetWBSPop.jsp                                                                                                */
/*   Description        : Time Sheet 신청시 WBS 팝업 조회 화면 (USA - LG CPI(G400))                                                      */
/*   Note               :                                                                                                                                   */
/*   Creation           : 2010-10-11 jungin @v1.0 LGCPI Time Sheet 신규 개발                                                            */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D07TimeSheet.*" %>
<%@ page import="hris.D.D07TimeSheet.rfc.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    WebUserData user = (WebUserData)session.getAttribute("user");

    String jobid = (String)request.getAttribute("jobid");
    //String message = (String)request.getAttribute("message");

    String PERNR = (String)request.getAttribute("PERNR");
    String E_BUKRS = (String)request.getAttribute("E_BUKRS");
    String E_PAYDRX = (String)request.getAttribute("E_PAYDRX");

    Vector D07TimeSheetSummaryDataUsa_vt = null;

    D07TimeSheetSummaryDataUsa data = null;

    D07TimeSheetSummaryDataUsa_vt = (Vector)request.getAttribute("D07TimeSheetSummaryDataUsa_vt");

    String E_BEGDA = (String)request.getAttribute("E_BEGDA");
    String E_ENDDA = (String)request.getAttribute("E_ENDDA");

    /*
    if (message == null) {
        message = "";
    }
    */

    // page 처리
    String paging = request.getParameter("page");

    // PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    try {
        pu = new PageUtil(D07TimeSheetSummaryDataUsa_vt.size(), paging , 10, 10);
        //
    } catch (Exception ex) {

    }
%>
<html>
<jsp:include page="/include/header.jsp"/>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<div class="winPop">
<form name="form1" method="post">

    <div class="header">
        <span><!-- Payroll Summary --><spring:message code='LABEL.D.D07.0017'/></span>
        <a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" border="0" /></a>
    </div>

    <div class="body">
                <!-- Hours Summary 테이블 시작 -->

        <!-- 리스트테이블 시작 -->
        <div class="listArea">
            <div class="listTop">
                <span class="listCnt"><%= WebUtil.printDate(E_BEGDA) %> - <%= WebUtil.printDate(E_ENDDA) %></span>
            </div>
            <div class="table">
                <table class="listTable">
                        <tr>
                            <th width="400"><!-- Time Type --><spring:message code='LABEL.D.D07.0010'/></th>
                            <th class="lastCol"><!-- Hours --><spring:message code='LABEL.D.D07.0005'/></th>
                        </tr>
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
                        <tr class="<%=tr_class%>">
                            <td class="<%= ts_summa.LGTXT.equals("Total") ? "td11" : "" %>" style="text-align:left;"><%= ts_summa.LGTXT %></td>
                            <td class="lastCol <%= ts_summa.LGTXT.equals("Total") ? "td11" : "" %>" style="text-align:right;"><%= ts_summa.WKHRS %></td>
                        </tr>
<%
        }
    } else {
%>
                        <tr class="oddRow">
                            <td class="lastCol" colspan="2"><!-- No data --><spring:message code='MSG.COMMON.0004'/></td>
                        </tr>
<%
    }
%>
                </table>
            </div>
        </div>
        <!-- 리스트테이블 끝-->

        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:self.close()"><span><!-- 닫기 --><spring:message code='BUTTON.COMMON.CLOSE'/></span></a></li>
            </ul>
        </div>
    </div>

    <input type="hidden" name="PERNR" value="<%= PERNR %>">
</form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>
