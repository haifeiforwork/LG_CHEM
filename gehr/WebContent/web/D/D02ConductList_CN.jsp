<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근태실적정보                                                */
/*   Program ID   : D02ConductList.jsp                                          */
/*   Description  : 근태 사항을 조회                                            */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  한성덕                                          */
/*   Update       : 2005-01-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.Global.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData user = (WebUserData)session.getAttribute("user");
//  Vector D02ConductDisplayData_vt = ( Vector ) request.getAttribute( "D02ConductDisplayData_vt" ) ;

//  D02ConductDisplayMonthData monthlyData = (D02ConductDisplayMonthData)D02ConductDisplayData_vt.get(0);
    D02ConductDisplayMonthData monthlyData =(D02ConductDisplayMonthData) request.getAttribute( "monthlyData" ) ;
    monthlyData =(D02ConductDisplayMonthData)AppUtil.nvlEntity(monthlyData);
    Vector dayDetial_vt = (Vector) request.getAttribute( "dayDetial_vt" );

//  Vector reDetailDataAll_vt = (Vector)D02ConductDisplayData_vt.get(1);

    String E_RETURN = ( String ) request.getAttribute( "E_RETURN"  );
    String E_MESSAGE = ( String ) request.getAttribute( "E_MESSAGE"  );

    int year  = Integer.parseInt( ( String ) request.getAttribute( "year"  ) ) ;  // 년
    int month = Integer.parseInt( ( String ) request.getAttribute( "month" ) ) ;  // 월

    int startYear = 2007;
    int endYear   = Integer.parseInt( DataUtil.getCurrentYear() );

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

    String class_code = "td04" ;
    String day        = "" ;
%>

<jsp:include page="/include/header.jsp"/>
<% if(Locale.ENGLISH.equals(user.locale)){
%>

<style>
.listTable th {
	font-size: 11px;
}
</style>
<%} %>
<script language="JavaScript">




function showList() {
    document.searchForm.action = "<%= WebUtil.ServletURL %>hris.D.Global.D02ConductListSV";
    document.searchForm.method = "post" ;
    document.searchForm.submit() ;
}
<!-- 시작 시 테이블 width 지정 -->
$(document).ready(function() {
    parent.resizeIframe(document.body.scrollHeight);

    $(window).resize(function(){
        var tableWidth = $('.subWrapper').width()-20;
        $('.listTable').css('width', tableWidth);
        $('.tableArea').css('width', tableWidth);
    });
    $(window).trigger("resize");

});


</script>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="D02Conduct.html"/>
    </jsp:include>
<form name="searchForm">

  <div class="tableInquiry">
    <table>
		<colgroup>
			<col width="20%" />
			<col />
		</colgroup>
      <tr>
        <th>
        	<img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
        	<!-- Display Period --><%=g.getMessage("LABEL.D.D02.0002")%>
        </th>
        <td>
          <select name="year">
           <%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year) )%>
          </select>
          <select name="month">
<%
    for( int i = 1 ; i < 13 ; i++ ) {
%>
            <option value="<%= i %>" <%= i == month ? "selected" : "" %>><%= i %></option>
<%
    }
%>
          </select>
	         <div class="tableBtnSearch tableBtnSearch2">
	          <a href="javascript:showList();" class="search"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a>
	        </div>
         </td>
      </tr>
    </table>
  </div>

</form>

    <div class="listArea noBtMargin noBtPadding">
        <div class="table" >
            <table id="tab_h" class="listTable noBtMargin" >
      	<colgroup>
      		<col width="10%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      	</colgroup>
      	<thead>
        <tr>
          <th rowspan="2"><!-- Section --><%=g.getMessage("LABEL.D.D02.0003")%></th>
          <th rowspan="2"><!-- Daily --><%=g.getMessage("LABEL.D.D02.0004")%> <br> <!-- Work --><%=g.getMessage("LABEL.D.D02.0005")%> <br> <!-- Schedule --><%=g.getMessage("LABEL.D.D02.0006")%></th>
          <th colspan="3"><!-- Overtime(Hours)--><%=g.getMessage("LABEL.D.D02.0007")%></th>
          <th rowspan="2"><!-- Duty --><%=g.getMessage("LABEL.D.D02.0008")%> <br> <!--(Days) --><%=g.getMessage("LABEL.D.D02.0009")%></th>
          <th colspan="3"><!-- Duty(Hours) --><%=g.getMessage("LABEL.D.D02.0010")%></th>
          <th colspan="4"><!-- Leave(Days) --><%=g.getMessage("LABEL.D.D02.0011")%></th>
          <th colspan="3" class="lastCol"><!-- Absence(Account)--><%=g.getMessage("LABEL.D.D02.0012")%></th>
        </tr>

        <tr>
          <th><!--Workday --><%=g.getMessage("LABEL.D.D02.0013")%></th>
          <th><!-- Offday --><%=g.getMessage("LABEL.D.D02.0014")%></th>
          <th><!-- Holiday --><%=g.getMessage("LABEL.D.D02.0015")%></th>
          <th><!-- Workday --><%=g.getMessage("LABEL.D.D02.0013")%></th>
          <th><!-- Offday --><%=g.getMessage("LABEL.D.D02.0014")%></th>
          <th><!-- Holiday --><%=g.getMessage("LABEL.D.D02.0015")%></th>
          <th><!-- Annual --><%=g.getMessage("LABEL.D.D02.0016")%></th>
          <th><!-- Sick --><%=g.getMessage("LABEL.D.D02.0017")%></th>
          <th><!-- Personal --><%=g.getMessage("LABEL.D.D02.0018")%></th>
          <th><!-- Others --><%=g.getMessage("LABEL.D.D02.0019")%></th>
          <th><!-- Absence --><%=g.getMessage("LABEL.D.D02.0020")%></th>
          <th><!-- Tardiness --><%=g.getMessage("LABEL.D.D02.0021")%></th>
          <th class="lastCol"><!-- Early <br> Dismissa --><%=g.getMessage("LABEL.D.D02.0022")%></th>
        </tr>
      <tr>
      </thead>

    <% if(!E_RETURN.trim().equals("S")) { %>

          <td colspan="16"><!--No data --><%=g.getMessage("LABEL.D.D04.0039")%></td>

    <%}else{ %>

          <td><!-- Monthly Total --><%=g.getMessage("LABEL.D.D15.0139")%></td>
          <td>&nbsp;</td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.OT_WOR,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.OT_OFF,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.OT_HOL,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.DU_FIX,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.DU_WOR,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.DU_OFF,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.DU_HOL,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.LE_ANN,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.LE_SIC,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.LE_PER,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.LE_OTH,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.AB_ABS,1) %> </td>
          <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.AB_TAR,1) %> </td>
          <td class="align_right lastCol"><%=WebUtil.printNumFormat(monthlyData.AB_EAR,1) %> </td>

     <%} %>
        </tr>
      </table>
	</div>
</div>
<% if(E_RETURN.trim().equals("S")) { %>

<div style="height:370px; overflow:auto;" id="div_c">
	<table class="listTable" id="tab_c" style="margin-right:17px;">
      	<colgroup>
      		<col width="10%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      		<col width="6%" />
      	</colgroup>

<%

if(dayDetial_vt.size() > 0 ){
       for(int i=0; i<dayDetial_vt.size(); i++ ){


//      BetweenDateData detailData=(BetweenDateData)reDetailDataAll_vt.get(i);
//      detailData =(BetweenDateData)AppUtil.nvlEntity(detailData);

          D02ConductDisplayDayData detailData =(D02ConductDisplayDayData) dayDetial_vt.get(i);

          DataUtil.fixNullAndTrim( detailData );

          detailData =(D02ConductDisplayDayData)AppUtil.nvlEntity(detailData);

    boolean isWeekend = false;

    SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
    Date ndate=formatter.parse(detailData.DATE.trim().replace(".","").replace("-",""));
    Calendar  calendar =Calendar.getInstance();
    calendar.setTime(ndate);


    if(calendar.get(Calendar.DAY_OF_WEEK)==1)
          isWeekend = true;
    else
          isWeekend = false;


%>

        <tr class="borderRow">
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> ><%=WebUtil.printDate(detailData.DATE) %></td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> > <%=detailData.DWS %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.OT_WOR.equals("0") ? "" : WebUtil.printNumFormat(detailData.OT_WOR,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.OT_OFF.equals("0") ? "" : WebUtil.printNumFormat(detailData.OT_OFF,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.OT_HOL.equals("0") ? "" : WebUtil.printNumFormat(detailData.OT_HOL,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.DU_FIX.equals("0") ? "" : WebUtil.printNumFormat(detailData.DU_FIX,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.DU_WOR.equals("0") ? "" : WebUtil.printNumFormat(detailData.DU_WOR,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.DU_OFF.equals("0") ? "" : WebUtil.printNumFormat(detailData.DU_OFF,1)%> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.DU_HOL.equals("0") ? "" : WebUtil.printNumFormat(detailData.DU_HOL,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.LE_ANN.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_ANN,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"  ><%=detailData.LE_SIC.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_SIC,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.LE_PER.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_PER,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.LE_OTH.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_OTH,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.AB_ABS.equals("0") ? "" : WebUtil.printNumFormat(detailData.AB_ABS,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right" ><%=detailData.AB_TAR.equals("0") ? "" : WebUtil.printNumFormat(detailData.AB_TAR,1) %> </td>
          <td <%= isWeekend ? "class=\"sunday lastCol\"" : "class=\"lastCol\""%> style="text-align:right" ><%=detailData.AB_EAR.equals("0") ? "" : WebUtil.printNumFormat(detailData.AB_EAR,1) %> </td>
        </tr>
<%
  }
}else{ %>

        <tr>
          <td colspan="7"><!--No data --><%=g.getMessage("LABEL.D.D04.0039")%></td>
        </tr>
<%
  }
%>
      </table>
    </div>


</div>
<%
 }
%>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
