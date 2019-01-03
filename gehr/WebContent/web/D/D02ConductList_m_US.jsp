<%/***************************************************************************************/
/*   System Name    : g-HR                                                                                                                          */
/*   1Depth Name    : Personal HR Info                                                                                                              */
/*   2Depth Name    : Time Management                                                                                                           */
/*   Program Name   : Time & Attendance                                                                                                         */
/*   Program ID         : D02ConductListUsa.jsp                                                                                                     */
/*   Description        : 개인 근태 조회하는 화면 (USA - LG CAI(G340))                                                                        */
/*   Note               :                                                                                                                                   */
/*   Creation           : 2010-10-22 jungin @v1.0                                                                                               */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.text.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.Global.*" %>
<%
    WebUserData user = (WebUserData)session.getAttribute("user");
	WebUserData user_m = (WebUserData)session.getAttribute("user_m");

    D02ConductDisplayMonthData monthlyData =(D02ConductDisplayMonthData)request.getAttribute("monthlyData");

    monthlyData =(D02ConductDisplayMonthData)AppUtilEurp.nvlEntity(monthlyData);
    Vector dayDetial_vt = (Vector)request.getAttribute("dayDetial_vt");

    String E_RETURN = (String)request.getAttribute("E_RETURN");
    String E_MESSAGE = (String)request.getAttribute("E_MESSAGE");

    int year = Integer.parseInt((String)request.getAttribute("year"));          // 년
    int month = Integer.parseInt((String)request.getAttribute("month"));    // 월

    int startYear = 2007;
    int endYear = Integer.parseInt(DataUtil.getCurrentYear());

    if ((endYear - startYear ) > 10) {
        startYear = endYear - 10;
    }

    Vector CodeEntity_vt = new Vector();
    for (int i = startYear; i <= endYear; i++) {
        CodeEntity entity = new CodeEntity();
        entity.code = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    String class_code = "td04" ;
    String day = "" ;
%>

<jsp:include page="/include/header.jsp"/>

<script language="JavaScript">

function showList() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.Global.D02ConductListSV_m";
    document.form1.method = "post";
    document.form1.target = "_self";
    document.form1.submit();
}

//상세 팝업 화면으로 이동.
function goDetail(pageCode, gubun, pernr, absty, value) {
    frm = document.form1;

    if (value != "" && value != "0.0") {
	    frm.PERNR.value = pernr;          	// 사번
	    frm.ABSTY.value = absty;  		// 유형 구분

	    window.open('', 'mssDetailWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=660,height=480");
	    frm.target = "mssDetailWindow";
	    frm.action = "<%= WebUtil.ServletURL %>hris.F.Global.F00DeptDetailListUsaSV?pageCode="+pageCode+"&gubun="+gubun;
	    frm.method = "post";
	    frm.submit();
    }
}

function  doSearchDetail() {

	document.form1.action = "<%= WebUtil.ServletURL %>hris.D.Global.D02ConductListSV_m";
    document.form1.method = "post";
    document.form1.target = "_self";
    document.form1.submit();
}

<!-- 시작 시 테이블 width 지정 -->
$(document).ready(function() {
    <!-- 윈도우 리사이즈 시 테이블 width 지정 -->
    $(window).resize(function(){
        var tableWidth = $('.subWrapper').width()-20;
        $('.listTable').css('width', tableWidth);
        $('.tableArea').css('width', tableWidth);
    });

    $(window).trigger("resize");
});


</script>

<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.MSS_PT_STAT_APPL"/>
    <jsp:param name="help" value="D02ConductDe.html'"/>
</jsp:include>
<form name="form1">
<input type="hidden" name="PERNR" value="">
<input type="hidden" name="BEGDA" value="">
<input type="hidden" name="ENDDA" value="">
<input type="hidden" name="ABSTY" value="">
	<!--   사원검색 보여주는 부분 시작   -->
	<%@ include file="../common/SearchDeptPersons_m.jsp" %>
	<!--   사원검색 보여주는 부분  끝    -->
<%if("X".equals(user_m.e_mss)){ %>
	<div class="tableArea" style="margin-top:-20px;">
		<div class="table">
			<table class="tableGeneral">
            	<colgroup>
            		<col width="12.5%" />
            		<col />
            	</colgroup>
                <tr>
                    <th><!-- Display Period --><%=g.getMessage("LABEL.D.D02.0002")%></th>
                    <td>
                        <select name="year">
                         <%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year)) %>
                        </select>
                        <select name="month">
					<%
					    for (int i = 1; i < 13; i++ ) {
					        String temp = Integer.toString(i);
					        int mon = month;
					%>
                            <option value="<%= temp.length() == 1 ? '0' + temp : temp %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
                        <%
                            }
                        %>
                        </select>
                        <div class="tableBtnSearch tableBtnSearch2">
                        	<a class="search" href="javascript:showList();"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
      </div>
</form>

    <div class="listArea" style="margin-bottom:0;margin-top:-20px" >
        <div class="table" style="margin-right:17px;">
            <table id="tab_h" class="listTable noBtMargin" style="margin-right:17px;">
                <colgroup>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                </colgroup>
                <thead>
                <tr>
                    <th rowspan="2"><!-- Section --><%=g.getMessage("LABEL.D.D02.0003")%></th>
                    <th rowspan="2"><!-- Daily --><%=g.getMessage("LABEL.D.D02.0004")%> <br> <!-- Work --><%=g.getMessage("LABEL.D.D02.0005")%> <br> <!-- Schedule --><%=g.getMessage("LABEL.D.D02.0006")%></th>
                    <th rowspan="2"><!-- Overtime(Hours)--><%=g.getMessage("LABEL.D.D02.0007")%></th>
                    <th colspan="5" class="lastCol"><!-- Leave(Days) --><%=g.getMessage("LABEL.D.D02.0011")%></th>
                </tr>
                <tr>
                    <th><!-- Vacation --><%=g.getMessage("LABEL.D.D02.0025")%></th>
                    <th><!-- Personal Time --><%=g.getMessage("LABEL.D.D02.0026")%></th>
                    <th><!-- Sick --><%=g.getMessage("LABEL.D.D02.0017")%></th>
                    <th><!-- Absence --><%=g.getMessage("LABEL.D.D02.0020")%></th>
                    <th class="lastCol"><!-- Others --><%=g.getMessage("LABEL.D.D02.0019")%></</th>
                </tr>
                </thead>
                <tr>
<%
    if (!E_RETURN.trim().equals("S")) {
%>
                    <td class="lastCol" colspan="8"><!--No data --><%=g.getMessage("LABEL.D.D02.0013")%></td>
<%
    } else {
%>
                    <th><!-- Monthly Total --><%=g.getMessage("LABEL.D.D02.0027")%></th>
                    <th class="align_right">&nbsp;</th>
                    <th class="align_right"><a title="<%= user_m.empNo %>" href="javascript:goDetail('TA', 'E', '<%= user_m.empNo %>', 'OT', '<%=WebUtil.printNumFormat(monthlyData.OT_HRS, 1) %>')"><%=WebUtil.printNumFormat(monthlyData.OT_HRS, 1) %></a></th>
                    <th class="align_right"><a title="<%= user_m.empNo %>" href="javascript:goDetail('TA', 'E', '<%= user_m.empNo %>', '10', '<%=WebUtil.printNumFormat(monthlyData.LE_ANN, 1) %>')"><%=WebUtil.printNumFormat(monthlyData.LE_ANN, 1) %></a></th>
                    <th class="align_right"><a title="<%= user_m.empNo %>" href="javascript:goDetail('TA', 'E', '<%= user_m.empNo %>', '15', '<%=WebUtil.printNumFormat(monthlyData.LE_PER, 1) %>')"><%=WebUtil.printNumFormat(monthlyData.LE_PER, 1) %></a></th>
                    <th class="align_right"><a title="<%= user_m.empNo %>" href="javascript:goDetail('TA', 'E', '<%= user_m.empNo %>', '20', '<%=WebUtil.printNumFormat(monthlyData.LE_SIC, 1) %>')"><%=WebUtil.printNumFormat(monthlyData.LE_SIC, 1) %></a></th>
                    <th class="align_right"><a title="<%= user_m.empNo %>" href="javascript:goDetail('TA', 'E', '<%= user_m.empNo %>', '50', '<%=WebUtil.printNumFormat(monthlyData.AB_ABS, 1) %>')"><%=WebUtil.printNumFormat(monthlyData.AB_ABS, 1) %></a></th>
                    <th class="align_right lastCol"><a title="<%= user_m.empNo %>" href="javascript:goDetail('TA', 'E', '<%= user_m.empNo %>', '30', '<%=WebUtil.printNumFormat(monthlyData.LE_OTH, 1) %>')"><%=WebUtil.printNumFormat(monthlyData.LE_OTH, 1) %></a></th>
<%
    }
%>
                </tr>
            </table>
        </div>
    </div>

<%
    if (E_RETURN.trim().equals("S")) {
%>

<div style="height:336px; overflow:auto;" id="div_c">
	<table class="listTable" id="tab_c">
                <colgroup>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                </colgroup>

<%
        if (dayDetial_vt.size() > 0) {
               for (int i=0; i<dayDetial_vt.size(); i++) {

                D02ConductDisplayDayData detailData =(D02ConductDisplayDayData)dayDetial_vt.get(i);

                DataUtil.fixNullAndTrim(detailData);

                detailData =(D02ConductDisplayDayData)AppUtilEurp.nvlEntity(detailData);

                boolean isWeekend = false;

                SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
                Date ndate=formatter.parse(detailData.DATE.trim().replace(".","").replace("-",""));

                Calendar calendar =Calendar.getInstance();
                calendar.setTime(ndate);
                if (calendar.get(Calendar.DAY_OF_WEEK) == 1) {
                      isWeekend = true;
                } else {
                      isWeekend = false;
                }
%>

    <tr class="borderRow">
        <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\"" %> ><%= WebUtil.printDate(detailData.DATE) %></td>
        <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\"" %> style="text-align:left"  >&nbsp;<%=detailData.DWS %></td>
        <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\"" %> style="text-align:right" ><%= detailData.OT_HRS.equals("0") ? "" : WebUtil.printNumFormat(detailData.OT_HRS, 1) %></td>
        <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\"" %> style="text-align:right" ><%= detailData.LE_ANN.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_ANN, 1) %></td>
        <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\"" %> style="text-align:right" ><%= detailData.LE_PER.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_PER, 1) %></td>
        <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\"" %> style="text-align:right" ><%= detailData.LE_SIC.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_SIC, 1) %></td>
        <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\"" %> style="text-align:right" ><%= detailData.AB_ABS.equals("0") ? "" : WebUtil.printNumFormat(detailData.AB_ABS, 1) %></td>
        <td <%= isWeekend ? "class=\"sunday lastCol\"" : "class=\"lastCol\"" %> style="text-align:right" ><%= detailData.LE_OTH.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_OTH, 1) %></td>
    </tr>
<%
            }

        } else {
%>
           <tr>
               <td class="lastCol" colspan="8"><!--No data --><%=g.getMessage("LABEL.D.D02.0013")%></td>
           </tr>
<%
        }
%>
            </table>
        </div>
<%
    }
%>
<%} %>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

