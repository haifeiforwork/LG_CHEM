<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  		*/
/*   2Depth Name  : 휴가실적정보                                                		*/
/*   Program Name : 휴가실적정보                                                		*/
/*   Program ID   : D04VocationDetail.jsp                                       */
/*   Description  : 개인의 휴가현황 정보 조회                                   		*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-21  chldudgh                                        */
/*   Update       : 2005-01-24  윤정현                                          		*/
/*   Update       : [CSR ID:2797167] 휴가실적 출력 용 화면 추가요청 				*/
/*                : [CSR ID:3449160] 근태실적정보 화면 수정요청의 건 eunha 20170804 */
/*                : 2018-05-18 성환희 [WorkTime52] 보상휴가 추가 건 				*/
/* 				  2018-06-21 cykim  [CSR ID:3702001] HR제도 및 웹화면 문구 수정 요청  */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D03Vocation.*" %>

<%
  WebUserData  user = (WebUserData)session.getAttribute("user");

	String EMPGUB = (String) request.getAttribute("EMPGUB");

    Vector                 d04VocationDetail1Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail1Data_vt" ) ;
    D04VocationDetail3Data data1                     = new D04VocationDetail3Data();
    if( d04VocationDetail1Data_vt != null && d04VocationDetail1Data_vt.size() > 0 ) {
        data1 = (D04VocationDetail3Data)d04VocationDetail1Data_vt.get(0);
    } else {
        DataUtil.fixNull(data1);
    }

    Vector                 d04VocationDetail2Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail2Data_vt" ) ;
    D04VocationDetail2Data data2                     = new D04VocationDetail2Data();
    if( d04VocationDetail2Data_vt != null && d04VocationDetail2Data_vt.size() > 0 ) {
        data2 = (D04VocationDetail2Data)d04VocationDetail2Data_vt.get(0);
    } else {
        DataUtil.fixNull(data2);
    }

    Vector                 d04VocationDetail3Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail3Data_vt" ) ;
    D04VocationDetail3Data data3                     = new D04VocationDetail3Data();
    if( d04VocationDetail3Data_vt != null && d04VocationDetail3Data_vt.size() > 0 ) {
        data3 = (D04VocationDetail3Data)d04VocationDetail3Data_vt.get(0);
    } else {
        DataUtil.fixNull(data3);
    }

    Vector                 d04VocationDetail4Data_vt = ( Vector ) request.getAttribute( "d04VocationDetail4Data_vt" ) ;
    D04VocationDetail4Data data4                     = new D04VocationDetail4Data();
    if( d04VocationDetail4Data_vt != null && d04VocationDetail4Data_vt.size() > 0 ) {
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

    String jobid = request.getParameter("jobid");

    String NON_ABSENCE  = ( String ) request.getAttribute( "NON_ABSENCE"  ) ;
    String LONG_SERVICE = ( String ) request.getAttribute( "LONG_SERVICE"  ) ;
    String FLEXIBLE = ( String ) request.getAttribute( "FLEXIBLE"  ) ;//@rdcamel 2016.12.15 유연휴가제
    String E_COMPTIME = ( String ) request.getAttribute( "E_COMPTIME"  ) ;
    String year         = ( String ) request.getAttribute( "year"  ) ;
    int startYear       = Integer.parseInt( (user.e_dat03).substring(0,4) );
    int endYear         = Integer.parseInt( DataUtil.getCurrentYear() );
    int current_time_year =  Integer.parseInt( DataUtil.getCurrentYear());
    if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220){
    	current_time_year =  Integer.parseInt( DataUtil.getCurrentYear())+1;
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

	// 짝수 Row 클래스 추가(oddRow)
	$('.listTable').each(function() {
		$(this).find('tbody').find('tr').each(function(index) {
			if((index % 2) == 0) $(this).addClass('oddRow');
		});
	});

});

<!--
function doSubmit(obj) {
    if ( obj.value =="") {
       //alert("년도를 선택하세요!");
       alert("<%=g.getMessage("MSG.D.D15.0014")%>");
       return;
    }
    document.form1.jobid.value = "search";
    document.form1.target = "_self";
    document.form1.year.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D04Vocation.D04VocationDetailSV";
    document.form1.method = "post";
    document.form1.submit();

}

function kubya() {
    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=650,height=400");
    document.form1.jobid.value  = "kubya_1";
    document.form1.target = "essPrintWindow";
    document.form1.year.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D04Vocation.D04VocationDetailSV";
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</script>
<%-- html body 안 헤더부분 - 타이틀 등 --%>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.ESS_PT_LEAV_INFO"/>
    </jsp:include>
    
    <style>
    	td.sum_column {background-color:#F6EDB8;}
    </style>

<form name="form1" method="post">

  <!--조회년월 검색 테이블 시작-->
  <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">
        <tr>
          <th><!--  조회년도--><%=g.getMessage("LABEL.D.D15.0046")%></th>
          <td>
            <select name="year" onChange="javascript:doSubmit(this);">
             <%= WebUtil.printOption(CodeEntity_vt, year )%>
            </select>
          </td>
          <th class="th02"><!--  발생일수--><%=g.getMessage("LABEL.D.D15.0047")%></th>
          <td>
            <input type="text" name="BALSENG_ILSU" value= "<%= WebUtil.printNumFormat(Double.parseDouble(OCCUR.equals("") ? "0.0" : OCCUR),1)%>" size="10" style="text-align:right" readonly>
          </td>
          <th class="th02">
          <% if("S".equals(EMPGUB)) { %>
          	<!-- 사용/보상일수 --><%=g.getMessage("LABEL.D.D15.0208")%>
          <% } else { %>
          	<!-- 사용일수 --><%=g.getMessage("LABEL.D.D15.0048")%>
          <% } %>
          </th>
          <td>
            <input type="text" name="ABRTG_SUM" value= "<%= ABWTG.equals("0") ? "0.0" : WebUtil.printNumFormat(Double.parseDouble(ABWTG),1) %>" size="10" style="text-align:right" readonly>
          </td>
<%  if( user.companyCode.equals("C100") && !OCCUR1.equals("0") ) { %>

          <th class="th02" title="<%=g.getMessage("LABEL.D.D15.0052")%>" onMouseOver="this.style.cursor='help'"><!-- 잔여일수 --><%=g.getMessage("LABEL.D.D15.0049")%></th>

<%  }else { %>

          <th class="th02"><!-- 잔여일수 --><%=g.getMessage("LABEL.D.D15.0049")%></th>

<%  } %>
          <td>
<%  if( user.companyCode.equals("C100") && (Double.parseDouble(ZKVRB.equals("0") ? "0.0" : ZKVRB ) < 0.0) ) { %>
            <input type="text" name="JAN_ILSU" value= "0.0" size="10" style="text-align:right" readonly>
<%  }else { %>
            <input type="text" name="JAN_ILSU" value= "<%= WebUtil.printNumFormat(Double.parseDouble(ZKVRB.equals("0") ? "0.0" : ZKVRB) ,1) %>" size="10" style="text-align:right" readonly>
<%  } %>
          </td>
        </tr>
      </table>
    </div>
  </div>
  <!--조회년월 검색 테이블 끝-->

<%
    if( user.companyCode.equals("C100") && !OCCUR1.equals("0") ) {
%>

  <!--조회년월 검색 테이블 시작-->
  <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">
        <tr>
          <!-- 사전부여휴가일수 = ANZHL_SUM(ZHRW_RFC_HOLIDAY_DISPLAY) -->
          <th  title="<%=g.getMessage("LABEL.D.D15.0051")%>" onMouseOver="this.style.cursor='help'"><!-- 사전부여휴가 --> <%=g.getMessage("LABEL.D.D15.0050")%></th>
          <td >
            <input type="text" name="SAJ_SUM" value= "<%= WebUtil.printNumFormat(Double.parseDouble(OCCUR1.equals("0") ? "0.0" : OCCUR1),1) %>" size="10" style="text-align:right" readonly>
          </td>
          <th class="th02"  title="<%=g.getMessage("LABEL.D.D15.0053")%>" onMouseOver="this.style.cursor='help'"><!-- 사전부여휴가 --> <%=g.getMessage("LABEL.D.D15.0050")%><!-- 잔여일수 --><%=g.getMessage("LABEL.D.D15.0049")%></th>
          <td >
            <input type="text" name="SAJ_JAN" value= "<%= WebUtil.printNumFormat(Double.parseDouble(ZKVRB1.equals("0") ? "0.0" : ZKVRB1),1) %>" size="10" style="text-align:right" readonly>
          </td>
        </tr>
      </table>
    </div>
  </div>


<%
    }
%>
<%
    if( user.companyCode.equals("C100") && !OCCUR2.equals("0") ) {
%>

  <!--조회년월 검색 테이블 시작-->
  <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">
        <tr>
          <!-- 선택적보상휴가일수 -->
          <th title="<%=g.getMessage("LABEL.D.D15.0054")%>" onMouseOver="this.style.cursor='help'"><!-- 선택적 보상휴가 --><%=g.getMessage("LABEL.D.D15.0056")%></th>
          <td>
            <input type="text" name="SUN_SUM" value= "<%= WebUtil.printNumFormat(Double.parseDouble(OCCUR2.equals("0") ? "0.0" : OCCUR2),1) %>" size="10" style="text-align:right" readonly>
          </td>
          <th class="th02" title="<%=g.getMessage("LABEL.D.D15.0055")%>" onMouseOver="this.style.cursor='help'"><!-- 선택적 보상휴가 --><%=g.getMessage("LABEL.D.D15.0056")%><!--잔여일수  --><%=g.getMessage("LABEL.D.D15.0049")%></th>
          <td>
            <input type="text" name="SUN_JAN" value= "<%= WebUtil.printNumFormat(Double.parseDouble(ZKVRB2.equals("0") ? "0.0" : ZKVRB2),1) %>" size="10" style="text-align:right" readonly>
          </td>
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
          <th class="divide" valign="bottom"><!-- 구분 --><%=g.getMessage("LABEL.D.D15.0076")%></th>
          <th><!--1월  --><%=g.getMessage("LABEL.D.D15.0058")%></th>
          <th><!--2월  --><%=g.getMessage("LABEL.D.D15.0059")%></th>
          <th><!--3월  --><%=g.getMessage("LABEL.D.D15.0060")%></th>
          <th><!--4월  --><%=g.getMessage("LABEL.D.D15.0061")%></th>
          <th><!--5월  --><%=g.getMessage("LABEL.D.D15.0062")%></th>
          <th><!--6월  --><%=g.getMessage("LABEL.D.D15.0063")%></th>
          <th><!--7월  --><%=g.getMessage("LABEL.D.D15.0064")%></th>
          <th><!--8월  --><%=g.getMessage("LABEL.D.D15.0065")%></th>
          <th><!--9월  --><%=g.getMessage("LABEL.D.D15.0066")%></th>
          <th><!--10월  --><%=g.getMessage("LABEL.D.D15.0067")%></th>
          <th><!--11월  --><%=g.getMessage("LABEL.D.D15.0068")%></th>
          <th><!--12월  --><%=g.getMessage("LABEL.D.D15.0069")%></th>
          <th class="lastCol sum_column"><!-- 계 --><%=g.getMessage("LABEL.D.D15.0070")%></th>
        </tr>
        </thead>
        <tr>
          <td class="divide"><!-- 개근연차 --><%=g.getMessage("LABEL.D.D15.0071")%></td>
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
          <td class="lastCol sum_column" name="NON_ABSENCE"><%= NON_ABSENCE.equals("") ? "0.0" : WebUtil.printNumFormat(NON_ABSENCE,1) %></td>
        </tr>
        <tr>
          <td class="divide"><!-- 근속연차--><%=g.getMessage("LABEL.D.D15.0072")%></td>
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
          <td class="lastCol sum_column" name="LONG_SERVICE"><%= LONG_SERVICE.equals("") ? "0.0" : WebUtil.printNumFormat(LONG_SERVICE,1) %></td>
        </tr>
        <%--[CSR ID:3449160] 근태실적정보 화면 수정요청의 건 eunha 20170804
        <tr class="oddRow">
          <td class="divide"><!-- 월차 --><%=g.getMessage("LABEL.D.D15.0073")%></td>
          <td name="ANZHL01"><%= data1.ANZHL01.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL01,1) %></td>
          <td name="ANZHL02"><%= data1.ANZHL02.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL02,1) %></td>
          <td name="ANZHL03"><%= data1.ANZHL03.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL03,1) %></td>
          <td name="ANZHL04"><%= data1.ANZHL04.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL04,1) %></td>
          <td name="ANZHL05"><%= data1.ANZHL05.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL05,1) %></td>
          <td name="ANZHL06"><%= data1.ANZHL06.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL06,1) %></td>
          <td name="ANZHL07"><%= data1.ANZHL07.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL07,1) %></td>
          <td name="ANZHL08"><%= data1.ANZHL08.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL08,1) %></td>
          <td name="ANZHL09"><%= data1.ANZHL09.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL09,1) %></td>
          <td name="ANZHL10"><%= data1.ANZHL10.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL10,1) %></td>
          <td name="ANZHL11"><%= data1.ANZHL11.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL11,1) %></td>
          <td name="ANZHL12"><%= data1.ANZHL12.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL12,1) %></td>
          <td class="lastCol" name="ANZHL_SUM"><%= data1.ANZHL_SUM.equals("") ? "0.0" : WebUtil.printNumFormat(data1.ANZHL_SUM,1) %></td>
        </tr>
         --%>


		<!-- @rdcamel 2016.12.15 유연휴가 -->
		<tr>
          <td class="divide"><!-- 개근연차 -->유연휴가</td>
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
    if( user.companyCode.equals("C100") && !data3.ANZHL_SUM.equals("") ) {
%>
        <tr><!-- @rdcamel -->
          <td class="divide"><!-- 사전부여휴가 --><%=g.getMessage("LABEL.D.D15.0050")%></td>
          <td name="ABRTG01"><%= data3.ANZHL01.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL01,1) %></td>
          <td name="ABRTG02"><%= data3.ANZHL02.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL02,1) %></td>
          <td name="ABRTG03"><%= data3.ANZHL03.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL03,1) %></td>
          <td name="ABRTG04"><%= data3.ANZHL04.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL04,1) %></td>
          <td name="ABRTG05"><%= data3.ANZHL05.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL05,1) %></td>
          <td name="ABRTG06"><%= data3.ANZHL06.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL06,1) %></td>
          <td name="ABRTG07"><%= data3.ANZHL07.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL07,1) %></td>
          <td name="ABRTG08"><%= data3.ANZHL08.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL08,1) %></td>
          <td name="ABRTG09"><%= data3.ANZHL09.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL09,1) %></td>
          <td name="ABRTG10"><%= data3.ANZHL10.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL10,1) %></td>
          <td name="ABRTG11"><%= data3.ANZHL11.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL11,1) %></td>
          <td name="ABRTG12"><%= data3.ANZHL12.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL12,1) %></td>
          <td class="lastCol sum_column" name="ABRTG_SUM"><%= data3.ANZHL_SUM.equals("") ? "0.0" : WebUtil.printNumFormat(data3.ANZHL_SUM,1) %></td>
        </tr>
<%
    }
%>
<%
    if( user.companyCode.equals("C100") && !data4.ANZHL_SUM.equals("") ) {
%>
        <tr><!-- @rdcamel -->
          <td class="divide"><!-- 선택적보상휴가 --><%=g.getMessage("LABEL.D.D15.0074")%></td>
          <td name="ANZHL01"><%= data4.ANZHL01.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL01,1) %></td>
          <td name="ANZHL02"><%= data4.ANZHL02.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL02,1) %></td>
          <td name="ANZHL03"><%= data4.ANZHL03.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL03,1) %></td>
          <td name="ANZHL04"><%= data4.ANZHL04.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL04,1) %></td>
          <td name="ANZHL05"><%= data4.ANZHL05.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL05,1) %></td>
          <td name="ANZHL06"><%= data4.ANZHL06.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL06,1) %></td>
          <td name="ANZHL07"><%= data4.ANZHL07.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL07,1) %></td>
          <td name="ANZHL08"><%= data4.ANZHL08.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL08,1) %></td>
          <td name="ANZHL09"><%= data4.ANZHL09.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL09,1) %></td>
          <td name="ANZHL10"><%= data4.ANZHL10.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL10,1) %></td>
          <td name="ANZHL11"><%= data4.ANZHL11.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL11,1) %></td>
          <td name="ANZHL12"><%= data4.ANZHL12.equals("") ? "0.0" : WebUtil.printNumFormat(data4.ANZHL12,1) %></td>
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

  <div class="tableArea">
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
          <th class="divide" valign="bottom"><!-- 구분 --><%=g.getMessage("LABEL.D.D15.0076")%></th>
          <th><!--1월  --><%=g.getMessage("LABEL.D.D15.0058")%></th>
          <th><!--2월  --><%=g.getMessage("LABEL.D.D15.0059")%></th>
          <th><!--3월  --><%=g.getMessage("LABEL.D.D15.0060")%></th>
          <th><!--4월  --><%=g.getMessage("LABEL.D.D15.0061")%></th>
          <th><!--5월  --><%=g.getMessage("LABEL.D.D15.0062")%></th>
          <th><!--6월  --><%=g.getMessage("LABEL.D.D15.0063")%></th>
          <th><!--7월  --><%=g.getMessage("LABEL.D.D15.0064")%></th>
          <th><!--8월  --><%=g.getMessage("LABEL.D.D15.0065")%></th>
          <th><!--9월  --><%=g.getMessage("LABEL.D.D15.0066")%></th>
          <th><!--10월 --><%=g.getMessage("LABEL.D.D15.0067")%></th>
          <th><!--11월 --><%=g.getMessage("LABEL.D.D15.0068")%></th>
          <th><!--12월 --><%=g.getMessage("LABEL.D.D15.0069")%></th>
          <th class="lastCol sum_column"><!-- 계 --><%=g.getMessage("LABEL.D.D15.0070")%></th>
        </tr>
       </thead>
        <tr>
          <td class="divide"><!-- 사용일수 --><%=g.getMessage("LABEL.D.D15.0048")%></td>
          <td name="ABRTG01"><%= data2.ABRTG01.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG01,1) %></td>
          <td name="ABRTG02"><%= data2.ABRTG02.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG02,1) %></td>
          <td name="ABRTG03"><%= data2.ABRTG03.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG03,1) %></td>
          <td name="ABRTG04"><%= data2.ABRTG04.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG04,1) %></td>
          <td name="ABRTG05"><%= data2.ABRTG05.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG05,1) %></td>
          <td name="ABRTG06"><%= data2.ABRTG06.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG06,1) %></td>
          <td name="ABRTG07"><%= data2.ABRTG07.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG07,1) %></td>
          <td name="ABRTG08"><%= data2.ABRTG08.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG08,1) %></td>
          <td name="ABRTG09"><%= data2.ABRTG09.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG09,1) %></td>
          <td name="ABRTG10"><%= data2.ABRTG10.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG10,1) %></td>
          <td name="ABRTG11"><%= data2.ABRTG11.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG11,1) %></td>
          <td name="ABRTG12"><%= data2.ABRTG12.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG12,1) %></td>
          <td class="lastCol sum_column" name="ABRTG_SUM"><%= data2.ABRTG_SUM.equals("") ? "0.0" : WebUtil.printNumFormat(data2.ABRTG_SUM,1) %></td>
        </tr>
<%
    // 조회년도가 올해이며 LG화학일 경우, 하계휴가 표시. 2003.09.09 mkbae.
    if ( (jobid == null || current_time_year == Integer.parseInt(year)) && user.companyCode.equals("C100") ) {
        Vector d03VacationUsedData_vt = ( Vector ) request.getAttribute( "d03VacationUsedData_vt") ;
        D03VacationUsedData data9     = new D03VacationUsedData();
        String E_ABRTG                = ( String ) request.getAttribute( "E_ABRTG" ) ;
%>
        <tr>
          <td class="divide"><!-- 하계휴가 --><%=g.getMessage("LABEL.D.D15.0077")%></td>
<%      //20071221 ~ 20081220
        if( d03VacationUsedData_vt.size() > 0 ) {
            int i = 1;
            int k = 0;
            String sumDATUM = "";
            for(int j=0; j<d03VacationUsedData_vt.size(); j++) {
                data9 = null;
                data9 = (D03VacationUsedData)d03VacationUsedData_vt.get(j);
                //if(Integer.parseInt(data9.DATUM.substring(0,4))<Integer.parseInt(year) || Integer.parseInt(data9.DATUM.substring(5,7))==i && Integer.parseInt(data9.DATUM.substring(7,9))<20) {
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
                    //if(Integer.parseInt(data9.DATUM.substring(5,7))==i) {
//                    out.println("i-1:["+(Integer.parseInt(data9.DATUM.substring(5,7))-1)+"dd:"+Integer.parseInt(data9.DATUM.substring(8,10))+"<br>");

                    if((  Integer.parseInt(data9.DATUM.substring(5,7))== (i-1)  && Integer.parseInt(data9.DATUM.substring(8,10))>=21 ) ||(Integer.parseInt(data9.DATUM.substring(5,7))==i && Integer.parseInt(data9.DATUM.substring(8,10))<=20 )) { //2008.12.09 12월20일이전 data 11월에 표시되지 않는 오류로 인해수정
//                    out.println("loop 내부i-1:["+(Integer.parseInt(data9.DATUM.substring(5,7))-1)+"dd:"+Integer.parseInt(data9.DATUM.substring(8,10))+"<br>");
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
                //if(Integer.parseInt(data9.DATUM.substring(0,4))>Integer.parseInt(year) || Integer.parseInt(data9.DATUM.substring(5,7))==i && Integer.parseInt(data9.DATUM.substring(7,9))>=21) {
                    if(( Integer.parseInt(data9.DATUM.substring(0,4))==Integer.parseInt(year) &&  Integer.parseInt(data9.DATUM.substring(5,7))== (i -1) && Integer.parseInt(data9.DATUM.substring(8,10))>=21 ) ||(Integer.parseInt(data9.DATUM.substring(0,4))==Integer.parseInt(year) && Integer.parseInt(data9.DATUM.substring(5,7))==i && Integer.parseInt(data9.DATUM.substring(8,10))<=20 )) { //2008.12.09 12월20일이전 data 11월에 표시되지 않는 오류로 인해수정

                    k++;
                    if(k==1) sumDATUM = data9.DATUM;
                    else sumDATUM = sumDATUM+"\n"+data9.DATUM;
                }
            }
%>
          <td name="DATUM1" title="<%=sumDATUM%>"><%=WebUtil.printNumFormat(k,1)%></td>
          <td class="lastCol sum_column" name="E_ABRTG"><%=WebUtil.printNumFormat( E_ABRTG ,1)%></td>
<%
        } else {
%>
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

  <div class="buttonArea underList">
      <ul class="btn_crud">
          <li><a href="javascript:kubya();"><span><!-- 휴가명세표 --><%=g.getMessage("LABEL.D.D15.0078")%></span></a></li>
      </ul>
  </div>

  <!-- [CSR ID:2797167] 휴가명세표 출력팝업 추가 end -->


<%
    if( user.companyCode.equals("C100") && (!data3.ANZHL_SUM.equals("") || !data4.ANZHL_SUM.equals("")) ) {
%>

  <table class="tableGeneral">
          <tr>
            <td><b><!--  용어설명--><%=g.getMessage("LABEL.D.D15.0079")%></b><br>
<%      if( !data3.ANZHL_SUM.equals("") ) { %>
              <!-- ◆ 잔여일수 : 발생한 휴가중 미사용 휴가일수로서 당해년도 말에 보상 가능한 휴가 일수<br>
              ◆ 사전부여휴가 : 근속1년 미만자에게 부여되는 휴가로서 매월 만근한 자에 한하여 발생하며, 당해년도 12월21일에 발생할 년차휴가의 일부를 미리 발생시킨 휴가<br>
              ◆ 사전부여 휴가 잔여일수 : 발생한 사전부여휴가중 미사용한 휴가일수로서 당해년도에는 보상하지 않음 -->
         <!-- [CSR ID:3702001] HR제도 및 웹화면 문구 수정 요청 start:: 문구삭제요청 ◆ 사전부여 휴가 잔여일수 : 발생한 사전부여휴가중 미사용한 휴가일수로서 당해년도에는 보상하지 않음 -->
         <%-- <%=g.getMessage("LABEL.D.D15.0080")%> --%>
         <%=g.getMessage("LABEL.D.D15.0211")%>
         <!-- [CSR ID:3702001] HR제도 및 웹화면 문구 수정 요청 end -->
<%      }else if( !data4.ANZHL_SUM.equals("") ){ %>
              <!-- ◆ 선택적 보상휴가 : 4조3교대 근무자의 주단위 40시간을 초과하는 2시간 근무에 대해서 월 단위로 부여하는 휴가<br>
              ◆ 선택적 보상휴가 잔여일수 : 매월 근태마감시 사용하지 않은 잔여휴가에 대해 고정O/T로 보상 -->
          <%=g.getMessage("LABEL.D.D15.0081")%>
<%      }else if( !data3.ANZHL_SUM.equals("") && !data4.ANZHL_SUM.equals("") ) { %>
              <!-- ◆ 잔여일수 : 발생한 휴가중 미사용 휴가일수로서 당해년도 말에 보상 가능한 휴가 일수<br>
              ◆ 사전부여휴가 : 근속1년 미만자에게 부여되는 휴가로서 매월 만근한 자에 한하여 발생하며, 당해년도 12월21일에 발생할 년차휴가의 일부를 미리 발생시킨 휴가<br>
              ◆ 사전부여 휴가 잔여일수 : 발생한 사전부여휴가중 미사용한 휴가일수로서 당해년도에는 보상하지 않음<br>
              ◆ 선택적 보상휴가 : 4조3교대 근무자의 주단위 40시간을 초과하는 2시간 근무에 대해서 월 단위로 부여하는 휴가<br>
              ◆ 선택적 보상휴가 잔여일수 : 매월 근태마감시 사용하지 않은 잔여휴가에 대해 고정O/T로 보상
               -->
          <%=g.getMessage("LABEL.D.D15.0082")%>
<%      } %>
            </td>
          </tr>
  </table>

<%  } %>

<%
    if( year.equals("2002") ) {
        if( user.companyCode.equals("C100") ) {    // LG화학
%>
  <span class="commentOne"><!-- ※ 2002년 휴가발생 내역은 2002년 6월 20일까지 사용한 사용일수를 차감한 잔여휴가일수 --><%=g.getMessage("LABEL.D.D15.0168")%></span>
<%
        }
    }
%>


  <!-- hidden 처리부분 -->
  <input type="hidden" name="jobid"     value="">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
