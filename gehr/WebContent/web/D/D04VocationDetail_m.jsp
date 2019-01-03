<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 휴가실적정보                                                		*/
/*   Program Name : 휴가실적정보                                                		*/
/*   Program ID   : D04VocationDetail_m.jsp                                     */
/*   Description  : 개인의 휴가현황 정보 조회                                   		*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-21  chldudgh                                        */
/*   Update       : 2005-01-24  윤정현                                          		*/
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    	*/
/*                  [CSR ID:2797167] 휴가실적 출력 용 화면 추가요청          		*/
/*					[CSR ID:3449160] 근태실적정보 화면 수정요청의 건 eunha 20170804	*/
/* 				 	2018-06-21 cykim  [CSR ID:3702001] HR제도 및 웹화면 문구 수정 요청 */
/* 				 	2018-07-24 성환희 [Worktime52] 보상휴가 추가의 건 				*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D03Vocation.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);
    
    String EMPGUB = (String) request.getAttribute("EMPGUB");

    String jobid_m = request.getParameter("jobid_m");

    Vector                 d04VocationDetail1Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail1Data_vt" ) ;
    D04VocationDetail3Data data1                     = new D04VocationDetail3Data();
    if( d04VocationDetail1Data_vt != null && d04VocationDetail1Data_vt.size() > 0 ) {
        data1 = (D04VocationDetail3Data)d04VocationDetail1Data_vt.get(0);
    } else {
        DataUtil.fixNull(data1);
    }

    Vector                 d04VocationDetail2Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail2Data_vt" ) ;
    D04VocationDetail2Data data2                     = new D04VocationDetail2Data();
    if( d04VocationDetail2Data_vt.size() > 0 ) {
        data2 = (D04VocationDetail2Data)d04VocationDetail2Data_vt.get(0);
    } else {
        DataUtil.fixNull(data2);
    }

    Vector                 d04VocationDetail3Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail3Data_vt" ) ;
    D04VocationDetail3Data data3                     = new D04VocationDetail3Data();
    if( d04VocationDetail3Data_vt.size() > 0 ) {
        data3 = (D04VocationDetail3Data)d04VocationDetail3Data_vt.get(0);
    } else {
        DataUtil.fixNull(data3);
    }

    Vector                 d04VocationDetail4Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail4Data_vt" ) ;
    D04VocationDetail4Data data4                     = new D04VocationDetail4Data();
    if( d04VocationDetail4Data_vt.size() > 0 ) {
        data4 = (D04VocationDetail4Data)d04VocationDetail4Data_vt.get(0);
    } else {
        DataUtil.fixNull(data4);
    }
    
    Vector                 d04VocationDetail5Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail5Data_vt" ) ;
    D04VocationDetail4Data data5                     = new D04VocationDetail4Data();
    if( d04VocationDetail5Data_vt != null && d04VocationDetail5Data_vt.size() > 0 ) {
        data5 = (D04VocationDetail4Data)d04VocationDetail5Data_vt.get(0);
    } else {
        DataUtil.fixNull(data5);
    }

    Vector                 d04VocationDetail6Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail6Data_vt" ) ;
    D04VocationDetail2Data data6                     = new D04VocationDetail2Data();
    if( d04VocationDetail6Data_vt != null && d04VocationDetail6Data_vt.size() > 0 ) {
        data6 = (D04VocationDetail2Data)d04VocationDetail6Data_vt.get(0);
    } else {
        DataUtil.fixNull(data6);
    }

    String NON_ABSENCE  = ( String ) request.getAttribute( "NON_ABSENCE"  ) ;
    String LONG_SERVICE = ( String ) request.getAttribute( "LONG_SERVICE"  ) ;
    String FLEXIBLE = ( String ) request.getAttribute( "FLEXIBLE"  ) ;//@rdcamel 2016.12.15 유연휴가제
    String E_COMPTIME = ( String ) request.getAttribute( "E_COMPTIME"  ) ;
    String year         = ( String ) request.getAttribute( "year"  ) ;

    int startYear = Integer.parseInt( DataUtil.getCurrentYear() );
    int endYear   = Integer.parseInt( DataUtil.getCurrentYear() );

    if ( user_m != null ) {
        startYear = Integer.parseInt( (user_m.e_dat03).substring(0,4) );
    }

//    2003.01.02. - 12월일때만 endYear에 + 1년을 해준다.
    if( (DataUtil.getCurrentMonth()).equals("12") ) {
        endYear = Integer.parseInt( DataUtil.getCurrentYear() ) + 1;
    }

    if( startYear < 2002 ){
        startYear = 2002;
    }
    if( ( endYear - startYear ) > 10 ){
        startYear = endYear - 10;
    }
    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    int current_time_year =  Integer.parseInt( DataUtil.getCurrentYear());
    if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220){
    	current_time_year =  Integer.parseInt( DataUtil.getCurrentYear())+1;
    }
    // 휴가신청정보 가져오는 부분 수정 - 2004.09.09
    Object d03Data_oj = request.getAttribute( "D03GetWorkdayData_vt" ) ;

    String ABWTG  = DataUtil.getValue(d03Data_oj, "ABWTG");   // 사용휴가
    String ZKVRB  = DataUtil.getValue(d03Data_oj, "ZKVRB");   // 잔여휴가
    String OCCUR  = DataUtil.getValue(d03Data_oj, "OCCUR");   // 발생일수
    String OCCUR1 = DataUtil.getValue(d03Data_oj, "OCCUR1");  // 사전부여휴가 발생일수
    String ABWTG1 = DataUtil.getValue(d03Data_oj, "ABWTG1");  // 사전부여휴가 사용일수
    String ZKVRB1 = DataUtil.getValue(d03Data_oj, "ZKVRB1");  // 사전부여휴가 잔여일수
    String OCCUR2 = DataUtil.getValue(d03Data_oj, "OCCUR2");  // 선택적보상휴가 발생일수
    String ABWTG2 = DataUtil.getValue(d03Data_oj, "ABWTG2");  // 선택적보상휴가 사용일수
    String ZKVRB2 = DataUtil.getValue(d03Data_oj, "ZKVRB2");  // 선택적보상휴가 잔여일수

%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">

$(function() {

	$('.listTable').each(function() {
		$(this).find('tbody').find('tr').each(function(index) {
			if((index % 2) == 0) $(this).addClass('oddRow');
		});
	});

});

<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D04Vocation.D04VocationDetailSV_m";
    document.form1.target = "_self";
    document.form1.method = "post";
    document.form1.jobid_m.value = "";
    document.form1.submit();
}

function doSubmit() {
    document.form1.jobid_m.value = "search";
    document.form1.target = "_self";
    document.form1.year.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D04Vocation.D04VocationDetailSV_m";
    document.form1.method = "post";
    document.form1.submit();
}

//[CSR ID:2797167] 휴가명세표 출력팝업 추가 start
function kubya() {
    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=650,height=400");
    document.form1.jobid_m.value  = "kubya_1";
    document.form1.target = "essPrintWindow";
    document.form1.year.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D04Vocation.D04VocationDetailSV_m";
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</script>
<!--[CSR ID:2389767] [정보보안] e-HR MSS시스템 수정-->
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.MSS_PT_LEAV_INFO"/>
        <jsp:param name="click" value="Y"/>
    </jsp:include>
    
    <style>
    	td.sum_column {background-color:#F6EDB8;}
    </style>
    
<form name="form1" method="post" action="">
	<!--   사원검색 보여주는 부분 시작   -->
	<%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
	<!--   사원검색 보여주는 부분  끝    -->
<%if("X".equals(user_m.e_mss)){ %>
<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

	<!--조회년월 검색 테이블 시작-->
	<div class="tableArea">
		<div class="table">
	        <table class="tableGeneral">
	        	<colgroup>
	        		<col width="10%" />
	        		<col width="15%" />
	        		<col width="10%" />
	        		<col width="15%" />
	        		<col width="10%" />
	        		<col width="15%" />
	        		<col width="10%" />
	        		<col width="15%" />
	        	</colgroup>
	            <tr>
	              <th><!--  조회년도--><%=g.getMessage("LABEL.D.D15.0046")%></th>
	              <td> <select name="year" onChange="javascript:doSubmit();">
	                  <%= WebUtil.printOption(CodeEntity_vt, year )%> </select> </td>
	              <th class="th02"><!--  발생일수--><%=g.getMessage("LABEL.D.D15.0047")%></th>
	              <td> <input type="text" name="BALSENG_ILSU" value= "<%= WebUtil.printNumFormat(Double.parseDouble(OCCUR.equals("0") ? "0.0" : OCCUR),1) %>&nbsp;" size="10" class="input05" style="text-align:right" readonly></td>
	              <th class="th02">
	              <% if("S".equals(EMPGUB)) { %>
		          	<!-- 사용/보상일수 --><%=g.getMessage("LABEL.D.D15.0208")%>
		          <% } else { %>
		          	<!-- 사용일수 --><%=g.getMessage("LABEL.D.D15.0048")%>
		          <% } %>
	              </th>
	              <td> <input type="text" name="ABRTG_SUM" value= "<%= ABWTG.equals("0") ? "0.0" : WebUtil.printNumFormat(Double.parseDouble(ABWTG),1) %>&nbsp;" size="10" class="input05" style="text-align:right" readonly></td>
                        <%
    if( user_m.companyCode.equals("C100") && !OCCUR1.equals("0") ) {
%>
					<th class="th02" title="<%=g.getMessage("LABEL.D.D15.0052")%>" onMouseOver="this.style.cursor='help'"><%=g.getMessage("LABEL.D.D15.0049")%></th>
                        <%
    }else {
%>
					<th class="th02"><%=g.getMessage("LABEL.D.D15.0049")%></th>
                        <%
    }
%>
					<td width="100"> <%
    if( user_m.companyCode.equals("C100") && (Double.parseDouble(ZKVRB.equals("0") ? "0.0" : ZKVRB ) < 0.0) ) {
%> <input type="text" name="JAN_ILSU" value= "0.0" size="10" class="input05" style="text-align:right" readonly>
                          <%
    }else {
%> <input type="text" name="JAN_ILSU" value= "<%= WebUtil.printNumFormat(Double.parseDouble(ZKVRB.equals("0") ? "0.0" : ZKVRB) ,1) %>&nbsp;" size="10" class="input05" style="text-align:right" readonly>
                          <%
    }
%> </td>
				</tr>
			</table>
		</div>
	</div>
	<!--조회년월 검색 테이블 끝-->

<%
    if( user_m.companyCode.equals("C100") && !OCCUR1.equals("0") ) {
%>

	<!--조회년월 검색 테이블 시작-->
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
	        	<colgroup>
	        		<col width="15%" />
	        		<col width="35%" />
	        		<col width="15%" />
	        		<col width="35%" />
	        	</colgroup>
				<tr>
                        <!-- 사전부여휴가일수 = ANZHL_SUM(ZHRW_RFC_HOLIDAY_DISPLAY) -->
                        <th title="<%=g.getMessage("LABEL.D.D15.0051")%>" onMouseOver="this.style.cursor='help'"><!-- 사전부여휴가 --> <%=g.getMessage("LABEL.D.D15.0050")%></th>
                        <td> <input type="text" name="SAJ_SUM" value= "<%= WebUtil.printNumFormat(Double.parseDouble(OCCUR1.equals("0") ? "0.0" : OCCUR1),1) %>&nbsp;" size="10" class="input05" style="text-align:right" readonly></td>
                        <th class="th02" title="<%=g.getMessage("LABEL.D.D15.0053")%>" onMouseOver="this.style.cursor='help'"><!-- 사전부여휴가 --> <%=g.getMessage("LABEL.D.D15.0050")%>
                         <!-- 잔여일수 --><%=g.getMessage("LABEL.D.D15.0049")%></th>
                        <td> <input type="text" name="SAJ_JAN" value= "<%= WebUtil.printNumFormat(Double.parseDouble(ZKVRB1.equals("0") ? "0.0" : ZKVRB1),1) %>&nbsp;" size="10" class="input05" style="text-align:right" readonly></td>
				</tr>
			</table>
		</div>
	</div>
<%
    }
%>
<%
    if( user_m.companyCode.equals("C100") && !OCCUR2.equals("0") ) {
%>

	<!--조회년월 검색 테이블 시작-->
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
	        	<colgroup>
	        		<col width="15%" />
	        		<col width="35%" />
	        		<col width="15%" />
	        		<col width="35%" />
	        	</colgroup>
				<tr>
                        <!-- 선택적보상휴가일수 -->
                        <th title="<%=g.getMessage("LABEL.D.D15.0054")%>" onMouseOver="this.style.cursor='help'"><!-- 선택적 보상휴가 --><%=g.getMessage("LABEL.D.D15.0056")%></td>
                        <td> <input type="text" name="SUN_SUM" value= "<%= WebUtil.printNumFormat(Double.parseDouble(OCCUR2.equals("0") ? "0.0" : OCCUR2),1) %>" size="10" style="text-align:right" readonly></td>
                        <th class="th02" title="<%=g.getMessage("LABEL.D.D15.0055")%>" onMouseOver="this.style.cursor='help'"><!-- 선택적 보상휴가 --><%=g.getMessage("LABEL.D.D15.0056")%><!--잔여일수  --><%=g.getMessage("LABEL.D.D15.0049")%></th>
                        <td> <input type="text" name="SUN_JAN" value= "<%= WebUtil.printNumFormat(Double.parseDouble(ZKVRB2.equals("0") ? "0.0" : ZKVRB2),1) %>&nbsp;" size="10" style="text-align:right" readonly></td>
				</tr>
			</table>
		</div>
	</div>

          <%
    }
%>

	<h2 class="subtitle"><!-- 휴가발생내역 --><%=g.getMessage("LABEL.D.D15.0057")%></h2>

	<div class="listArea">
		<div class="table">
			<table class="listTable">
			  <colgroup>
	      		<col width="9%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      		<col width="7%" />
	      	  </colgroup>
			  <thead>
                <tr>
                  <th class="divide" valign="bottom" width="100"><!-- 구분 --><%=g.getMessage("LABEL.D.D15.0076")%></th>
                  <th width="50"><!--1월  --><%=g.getMessage("LABEL.D.D15.0058")%></th>
                  <th width="50"><!--2월  --><%=g.getMessage("LABEL.D.D15.0059")%></th>
                  <th width="50"><!--3월  --><%=g.getMessage("LABEL.D.D15.0060")%></th>
                  <th width="50"><!--4월  --><%=g.getMessage("LABEL.D.D15.0061")%></th>
                  <th width="50"><!--5월  --><%=g.getMessage("LABEL.D.D15.0062")%></th>
                  <th width="50"><!--6월  --><%=g.getMessage("LABEL.D.D15.0063")%></th>
                  <th width="50"><!--7월  --><%=g.getMessage("LABEL.D.D15.0064")%></th>
                  <th width="50"><!--8월  --><%=g.getMessage("LABEL.D.D15.0065")%></th>
                  <th width="50"><!--9월  --><%=g.getMessage("LABEL.D.D15.0066")%></th>
                  <th width="50"><!--10월  --><%=g.getMessage("LABEL.D.D15.0067")%></th>
                  <th width="50"><!--11월  --><%=g.getMessage("LABEL.D.D15.0068")%></th>
                  <th width="50"><!--12월  --><%=g.getMessage("LABEL.D.D15.0069")%></th>
                  <th class="lastCol" width="80"><!-- 계 --><%=g.getMessage("LABEL.D.D15.0070")%></th>
                </tr>
               </thead>
                <tr>
                  <td class="divide"><!-- 개근연차 --><%=g.getMessage("LABEL.D.D15.0071")%></td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td class="lastCol sum_column"  name="NON_ABSENCE"><%= NON_ABSENCE.equals("") ? "0.0" : WebUtil.printNumFormat(NON_ABSENCE,1) %></td>
                </tr>
                <tr>
                  <td class="divide"><!-- 근속연차--><%=g.getMessage("LABEL.D.D15.0072")%></td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td class="lastCol sum_column"  name="LONG_SERVICE"><%= LONG_SERVICE.equals("") ? "0.0" : WebUtil.printNumFormat(LONG_SERVICE,1) %></td>
                </tr>
                <%-- [CSR ID:3449160] 근태실적정보 화면 수정요청의 건 eunha 20170804
                <tr>
                  <td class="divide"><!-- 월&nbsp;&nbsp;&nbsp;&nbsp;차 --><%=g.getMessage("LABEL.D.D15.0073")%></td>
                  <td  name="ANZHL01"><%= data1.ANZHL01.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL01,1) %></td>
                  <td  name="ANZHL02"><%= data1.ANZHL02.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL02,1) %></td>
                  <td  name="ANZHL03"><%= data1.ANZHL03.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL03,1) %></td>
                  <td  name="ANZHL04"><%= data1.ANZHL04.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL04,1) %></td>
                  <td  name="ANZHL05"><%= data1.ANZHL05.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL05,1) %></td>
                  <td  name="ANZHL06"><%= data1.ANZHL06.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL06,1) %></td>
                  <td  name="ANZHL07"><%= data1.ANZHL07.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL07,1) %></td>
                  <td  name="ANZHL08"><%= data1.ANZHL08.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL08,1) %></td>
                  <td  name="ANZHL09"><%= data1.ANZHL09.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL09,1) %></td>
                  <td  name="ANZHL10"><%= data1.ANZHL10.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL10,1) %></td>
                  <td  name="ANZHL11"><%= data1.ANZHL11.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL11,1) %></td>
                  <td  name="ANZHL12"><%= data1.ANZHL12.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL12,1) %></td>
                  <td class="lastCol sum_column" name="ANZHL_SUM"><%= data1.ANZHL_SUM.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL_SUM,1) %></td>
                </tr>
                 --%>

                <!-- @rdcamel 2016.12.15 유연휴가 -->
				<tr>
		          <td class="divide"><!-- 개근연차 -->유연 휴가</td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td class="lastCol sum_column" name="FLEXIBLE"><%= FLEXIBLE.equals("") ? "0.0" : WebUtil.printNumFormat(FLEXIBLE,1) %></td>
		        </tr>
		        <!-- @rdcamel 2016.12.15 유연휴가  end -->
                <%
    if( user_m.companyCode.equals("C100") && !data3.ANZHL_SUM.equals("") ) {
%>
                <tr><!-- @rdcamel -->
                  <td class="divide"><!-- 사전부여휴가 --><%=g.getMessage("LABEL.D.D15.0050")%></td>
                  <td  name="ANZHL01"><%= data3.ANZHL01.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL01,1) %></td>
                  <td  name="ANZHL02"><%= data3.ANZHL02.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL02,1) %></td>
                  <td  name="ANZHL03"><%= data3.ANZHL03.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL03,1) %></td>
                  <td  name="ANZHL04"><%= data3.ANZHL04.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL04,1) %></td>
                  <td  name="ANZHL05"><%= data3.ANZHL05.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL05,1) %></td>
                  <td  name="ANZHL06"><%= data3.ANZHL06.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL06,1) %></td>
                  <td  name="ANZHL07"><%= data3.ANZHL07.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL07,1) %></td>
                  <td  name="ANZHL08"><%= data3.ANZHL08.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL08,1) %></td>
                  <td  name="ANZHL09"><%= data3.ANZHL09.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL09,1) %></td>
                  <td  name="ANZHL10"><%= data3.ANZHL10.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL10,1) %></td>
                  <td  name="ANZHL11"><%= data3.ANZHL11.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL11,1) %></td>
                  <td  name="ANZHL12"><%= data3.ANZHL12.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL12,1) %></td>
                  <td class="lastCol sum_column" name="ANZHL_SUM"><%= data3.ANZHL_SUM.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL_SUM,1) %></td>
                </tr>
                <%
    }
%>
                <%
    if( user_m.companyCode.equals("C100") && !data4.ANZHL_SUM.equals("") ) {
%>
                <tr><!-- @rdcamel -->
                  <td class="divide"><!-- 선택적보상휴가 --><%=g.getMessage("LABEL.D.D15.0074")%></td>
                  <td  name="ANZHL01"><%= data4.ANZHL01.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL01,1) %></td>
                  <td  name="ANZHL02"><%= data4.ANZHL02.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL02,1) %></td>
                  <td  name="ANZHL03"><%= data4.ANZHL03.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL03,1) %></td>
                  <td  name="ANZHL04"><%= data4.ANZHL04.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL04,1) %></td>
                  <td  name="ANZHL05"><%= data4.ANZHL05.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL05,1) %></td>
                  <td  name="ANZHL06"><%= data4.ANZHL06.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL06,1) %></td>
                  <td  name="ANZHL07"><%= data4.ANZHL07.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL07,1) %></td>
                  <td  name="ANZHL08"><%= data4.ANZHL08.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL08,1) %></td>
                  <td  name="ANZHL09"><%= data4.ANZHL09.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL09,1) %></td>
                  <td  name="ANZHL10"><%= data4.ANZHL10.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL10,1) %></td>
                  <td  name="ANZHL11"><%= data4.ANZHL11.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL11,1) %></td>
                  <td  name="ANZHL12"><%= data4.ANZHL12.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL12,1) %></td>
                  <td class="lastCol sum_column" name="ANZHL_SUM"><%= data4.ANZHL_SUM.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL_SUM,1) %></td>
                </tr>
                <%
    }
%>
			<% if("S".equals(EMPGUB)) { %>
	        <tr>
	          <td class="divide"><!-- 보상휴가 --><%=g.getMessage("LABEL.D.D15.0209")%></td>
	          <td><%= data5.ANZHL01.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL01,1) %></td>
	          <td><%= data5.ANZHL02.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL02,1) %></td>
	          <td><%= data5.ANZHL03.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL03,1) %></td>
	          <td><%= data5.ANZHL04.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL04,1) %></td>
	          <td><%= data5.ANZHL05.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL05,1) %></td>
	          <td><%= data5.ANZHL06.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL06,1) %></td>
	          <td><%= data5.ANZHL07.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL07,1) %></td>
	          <td><%= data5.ANZHL08.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL08,1) %></td>
	          <td><%= data5.ANZHL09.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL09,1) %></td>
	          <td><%= data5.ANZHL10.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL10,1) %></td>
	          <td><%= data5.ANZHL11.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL11,1) %></td>
	          <td><%= data5.ANZHL12.equals("") ? "0.0" : WebUtil.printNumFormat(data5.ANZHL12,1) %></td>
	          <td class="lastCol sum_column" name="E_COMPTIME"><%= E_COMPTIME.equals("") ? "0.0" : WebUtil.printNumFormat(E_COMPTIME,1) %></td>
	        </tr>
	        <% } %>
			</table>
		</div>
	</div>

	<% if("S".equals(EMPGUB)) { %>
    <h2 class="subtitle"><!-- 휴가 사용/보상 내역 --><%=g.getMessage("LABEL.D.D15.0210")%></h2>
    <% } else { %>
    <h2 class="subtitle"><!-- 휴가사용내역 --><%=g.getMessage("LABEL.D.D15.0075")%></h2>
    <% } %>

	<div class="listArea">
		<div class="table">
			<table class="listTable">
			<colgroup>
	   		 <col width="9%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   		 <col width="7%" />
	   	  </colgroup>
			  <thead>
                <tr>
                  <th class="divide" valign="bottom" width="100"><!-- 구분 --><%=g.getMessage("LABEL.D.D15.0076")%></th>
                  <th width="50"><!--1월  --><%=g.getMessage("LABEL.D.D15.0058")%></th>
                  <th width="50"><!--2월  --><%=g.getMessage("LABEL.D.D15.0059")%></th>
                  <th width="50"><!--3월  --><%=g.getMessage("LABEL.D.D15.0060")%></th>
                  <th width="50"><!--4월  --><%=g.getMessage("LABEL.D.D15.0061")%></th>
                  <th width="50"><!--5월  --><%=g.getMessage("LABEL.D.D15.0062")%></th>
                  <th width="50"><!--6월  --><%=g.getMessage("LABEL.D.D15.0063")%></th>
                  <th width="50"><!--7월  --><%=g.getMessage("LABEL.D.D15.0064")%></th>
                  <th width="50"><!--8월  --><%=g.getMessage("LABEL.D.D15.0065")%></th>
                  <th width="50"><!--9월  --><%=g.getMessage("LABEL.D.D15.0066")%></th>
                  <th width="50"><!--10월 --><%=g.getMessage("LABEL.D.D15.0067")%></th>
                  <th width="50"><!--11월 --><%=g.getMessage("LABEL.D.D15.0068")%></th>
                  <th width="50"><!--12월 --><%=g.getMessage("LABEL.D.D15.0069")%></th>
                  <th class="lastCol" width="80"><!-- 계 --><%=g.getMessage("LABEL.D.D15.0070")%></th>
                </tr>
                </thead>
                <tr>
                  <td class="divide"><!-- 사용일수 --><%=g.getMessage("LABEL.D.D15.0048")%></td>
                  <td  name="ABRTG01"><%= data2.ABRTG01.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG01,1) %></td>
                  <td  name="ABRTG02"><%= data2.ABRTG02.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG02,1) %></td>
                  <td  name="ABRTG03"><%= data2.ABRTG03.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG03,1) %></td>
                  <td  name="ABRTG04"><%= data2.ABRTG04.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG04,1) %></td>
                  <td  name="ABRTG05"><%= data2.ABRTG05.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG05,1) %></td>
                  <td  name="ABRTG06"><%= data2.ABRTG06.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG06,1) %></td>
                  <td  name="ABRTG07"><%= data2.ABRTG07.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG07,1) %></td>
                  <td  name="ABRTG08"><%= data2.ABRTG08.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG08,1) %></td>
                  <td  name="ABRTG09"><%= data2.ABRTG09.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG09,1) %></td>
                  <td  name="ABRTG10"><%= data2.ABRTG10.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG10,1) %></td>
                  <td  name="ABRTG11"><%= data2.ABRTG11.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG11,1) %></td>
                  <td  name="ABRTG12"><%= data2.ABRTG12.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG12,1) %></td>
                  <td class="lastCol sum_column" name="ABRTG_SUM"><%= data2.ABRTG_SUM.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG_SUM,1) %></td>
                </tr>
                <%
    // 조회년도가 올해이며 LG화학일 경우, 하계휴가 표시. 2003.09.09 mkbae.
    if ( (jobid_m == null || current_time_year == Integer.parseInt(year)) && user_m.companyCode.equals("C100") ) {
        Vector d03VacationUsedData_vt = ( Vector ) request.getAttribute( "d03VacationUsedData_vt") ;
        D03VacationUsedData data9     = new D03VacationUsedData();
        String E_ABRTG                = ( String ) request.getAttribute( "E_ABRTG" ) ;
%>
<input type=hidden name="test98" value="<%=d03VacationUsedData_vt.toString()%>">

                <tr>
                  <td class="divide"><!-- 하계휴가 --><%=g.getMessage("LABEL.D.D15.0077")%></td>
                  <%
        if( d03VacationUsedData_vt.size() > 0 ) {
            int i = 1;
            int k = 0;
            String sumDATUM = "";
            for(int j=0; j<d03VacationUsedData_vt.size(); j++) {
                data9 = null;
                data9 = (D03VacationUsedData)d03VacationUsedData_vt.get(j);
                if(Integer.parseInt(data9.DATUM.substring(0,4))<Integer.parseInt(year) || Integer.parseInt(data9.DATUM.substring(5,7))==i && Integer.parseInt(data9.DATUM.substring(8,10))<=20) {
                    k++;
                    if(k==1) sumDATUM = data9.DATUM;
                    else sumDATUM = sumDATUM+"\n"+data9.DATUM;
                }
            }
%>
                  <td name="DATUM1" title="<%=sumDATUM%>"><%=WebUtil.printNumFormat(k,1)%></td>
                  <%
            for( i=2; i<=11; i++) {
                k = 0;
                sumDATUM = "";
                for(int j=0; j<d03VacationUsedData_vt.size(); j++) {
                    data9 = null;
                    data9 = (D03VacationUsedData)d03VacationUsedData_vt.get(j);
                  //  if(Integer.parseInt(data9.DATUM.substring(5,7))==i) {
                    if((  Integer.parseInt(data9.DATUM.substring(5,7))== (i -1) && Integer.parseInt(data9.DATUM.substring(8,10))>=21 ) ||(Integer.parseInt(data9.DATUM.substring(5,7))==i && Integer.parseInt(data9.DATUM.substring(8,10))<=20 )) { //2008.12.09 12월20일이전 data 11월에 표시되지 않는 오류로 인해수정
                        k++;
                        if(k==1) sumDATUM = data9.DATUM;
                        else sumDATUM = sumDATUM+"\n"+data9.DATUM;
                    }
                }
%>

                  <td name="DATUM<%=i%>" title="<%=sumDATUM%>"><%=WebUtil.printNumFormat(k,1)%></td>
                  <%
            }
            i = 12;
            k = 0;
            sumDATUM = "";
            for(int j=0; j<d03VacationUsedData_vt.size(); j++) {
                data9 = null;
                data9 = (D03VacationUsedData)d03VacationUsedData_vt.get(j);
            //    if(Integer.parseInt(data9.DATUM.substring(0,4))>Integer.parseInt(year) || Integer.parseInt(data9.DATUM.substring(5,7))==i && Integer.parseInt(data9.DATUM.substring(7,9))>=21) {
                    if(( Integer.parseInt(data9.DATUM.substring(0,4))==Integer.parseInt(year) && Integer.parseInt(data9.DATUM.substring(5,7))==( i-1)  && Integer.parseInt(data9.DATUM.substring(8,10))>=21 ) ||(  Integer.parseInt(data9.DATUM.substring(0,4))==Integer.parseInt(year) &&Integer.parseInt(data9.DATUM.substring(5,7))==i && Integer.parseInt(data9.DATUM.substring(8,10))<=20 )) { //2008.12.09 12월20일이전 data 11월에 표시되지 않는 오류로 인해수정
                    k++;
                    if(k==1) sumDATUM = data9.DATUM;
                    else sumDATUM = sumDATUM+"\n"+data9.DATUM;
                }
            }
%>
                  <td name="DATUM1" title="<%=sumDATUM%>"><%=WebUtil.printNumFormat(k,1)%></td>
                  <td class="lastCol" name="E_ABRTG"><%= WebUtil.printNumFormat(E_ABRTG,1) %></td>
                  <%
        } else {
%>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td class="lastCol sum_column" name="E_ABRTG">0.0</td>
                  <%
        }
%>
                </tr>
                <%
    }
%>
			<% if("S".equals(EMPGUB)) { %>
			<tr>
	          <td class="divide"><!-- 보상휴가 --><%=g.getMessage("LABEL.D.D15.0209")%></td>
	          <td><%= data6.ABRTG01.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG01,1) %></td>
	          <td><%= data6.ABRTG02.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG02,1) %></td>
	          <td><%= data6.ABRTG03.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG03,1) %></td>
	          <td><%= data6.ABRTG04.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG04,1) %></td>
	          <td><%= data6.ABRTG05.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG05,1) %></td>
	          <td><%= data6.ABRTG06.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG06,1) %></td>
	          <td><%= data6.ABRTG07.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG07,1) %></td>
	          <td><%= data6.ABRTG08.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG08,1) %></td>
	          <td><%= data6.ABRTG09.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG09,1) %></td>
	          <td><%= data6.ABRTG10.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG10,1) %></td>
	          <td><%= data6.ABRTG11.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG11,1) %></td>
	          <td><%= data6.ABRTG12.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG12,1) %></td>
	          <td class="lastCol sum_column"><%= data6.ABRTG_SUM.equals("") ? "0.0" : WebUtil.printNumFormat(data6.ABRTG_SUM,1) %></td>
	        </tr>
	        <% } %>
			</table>
		</div>
	</div>


    <!-- [CSR ID:2797167] 휴가명세표 출력팝업 추가 start -->


	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a href="javascript:kubya();"><span><!-- 휴가명세표 --><%=g.getMessage("LABEL.D.D15.0078")%></span></a></li>
		</ul>
	</div>


	<!--[CSR ID:2797167] 휴가명세표 출력팝업 추가 end -->

          <%
    if( user_m.companyCode.equals("C100") && (!data3.ANZHL_SUM.equals("") || !data4.ANZHL_SUM.equals("")) ) {
%>
	<table class="tableGeneral">
                <tr>
                  <td><b><!--  용어설명--><%=g.getMessage("LABEL.D.D15.0079")%></b><br> <%
        if( !data3.ANZHL_SUM.equals("") ) {
%>
              <!-- ◆ 잔여일수 : 발생한 휴가중 미사용 휴가일수로서 당해년도 말에 보상 가능한 휴가 일수<br>
              ◆ 사전부여휴가 : 근속1년 미만자에게 부여되는 휴가로서 매월 만근한 자에 한하여 발생하며, 당해년도 12월21일에 발생할 년차휴가의 일부를 미리 발생시킨 휴가<br>
              ◆ 사전부여 휴가 잔여일수 : 발생한 사전부여휴가중 미사용한 휴가일수로서 당해년도에는 보상하지 않음 -->
         <!-- [CSR ID:3702001] HR제도 및 웹화면 문구 수정 요청 start:: 문구삭제요청 ◆ 사전부여 휴가 잔여일수 : 발생한 사전부여휴가중 미사용한 휴가일수로서 당해년도에는 보상하지 않음 -->
         <%-- <%=g.getMessage("LABEL.D.D15.0080")%> --%>
         <%=g.getMessage("LABEL.D.D15.0211")%>
         <!-- [CSR ID:3702001] HR제도 및 웹화면 문구 수정 요청 end -->
                    <%
        }else if( !data4.ANZHL_SUM.equals("") ){
%>
                  <!-- ◆ 선택적 보상휴가 : 4조3교대 근무자의 주단위 40시간을 초과하는 2시간 근무에 대해서 월 단위로 부여하는 휴가<br>
              ◆ 선택적 보상휴가 잔여일수 : 매월 근태마감시 사용하지 않은 잔여휴가에 대해 고정O/T로 보상 -->
              <%=g.getMessage("LABEL.D.D15.0081")%>
                    <%
        }else if( !data3.ANZHL_SUM.equals("") && !data4.ANZHL_SUM.equals("") ) {
%>
 <!-- ◆ 잔여일수 : 발생한 휴가중 미사용 휴가일수로서 당해년도 말에 보상 가능한 휴가 일수<br>
              ◆ 사전부여휴가 : 근속1년 미만자에게 부여되는 휴가로서 매월 만근한 자에 한하여 발생하며, 당해년도 12월21일에 발생할 년차휴가의 일부를 미리 발생시킨 휴가<br>
              ◆ 사전부여 휴가 잔여일수 : 발생한 사전부여휴가중 미사용한 휴가일수로서 당해년도에는 보상하지 않음<br>
              ◆ 선택적 보상휴가 : 4조3교대 근무자의 주단위 40시간을 초과하는 2시간 근무에 대해서 월 단위로 부여하는 휴가<br>
              ◆ 선택적 보상휴가 잔여일수 : 매월 근태마감시 사용하지 않은 잔여휴가에 대해 고정O/T로 보상
               -->
          <%=g.getMessage("LABEL.D.D15.0082")%>
                    <%
        }
%> </td>
                </tr>
	</table>
<%
    }
%>

<%
    if( year.equals("2002") ) {
        if( user_m.companyCode.equals("C100") ) {         // LG화학
%>
	<span class="commentOne"><!-- ※ 2002년 휴가발생 내역은 2002년 6월 20일까지 사용한 사용일수를 차감한 잔여휴가일수 --><%=g.getMessage("LABEL.D.D15.0168")%>
              입니다.</span>
            <%
        }
    }
%>

       <!-- hidden 처리부분 -->


<%
        }
%>
<%} %>
   <input type="hidden" name="jobid_m"   value="">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

