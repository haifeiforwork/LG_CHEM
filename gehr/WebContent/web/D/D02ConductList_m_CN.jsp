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
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.Global.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.sns.jdf.util.*" %>


<%
    WebUserData user = (WebUserData)session.getAttribute("user");
    WebUserData user_m = (WebUserData)session.getAttribute("user_m");

    D02ConductDisplayMonthData monthlyData =(D02ConductDisplayMonthData) request.getAttribute( "monthlyData" ) ;
    monthlyData =(D02ConductDisplayMonthData)AppUtil.nvlEntity(monthlyData);
    Vector dayDetial_vt = (Vector) request.getAttribute( "dayDetial_vt" );

    String E_RETURN = ( String ) request.getAttribute( "E_RETURN"  );
    String E_MESSAGE = ( String ) request.getAttribute( "E_MESSAGE"  );

    int year  = Integer.parseInt( ( String ) request.getAttribute( "year"  ) ) ;  // 년
    int month = Integer.parseInt( ( String ) request.getAttribute( "month" ) ) ;  // 월

    int startYear = 2002;
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
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.Global.D02ConductListSV_m";
    document.form1.method = "post" ;
    document.form1.submit() ;
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
        <jsp:param name="help" value="X03PersonInfo.html'"/>
    </jsp:include>

<form name="form1">
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="../common/SearchDeptPersons_m.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%if("X".equals(user_m.e_mss)){ %>
	<div class="tableArea" style="margin-top:-20px;">
		<div class="table">
			<table class="tableGeneral">
			 <colgroup>
				<col width="16%" />
				<col />
			</colgroup>
                <tr>
                    <th><!-- Display Period --><%=g.getMessage("LABEL.D.D02.0002")%></th>
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
                          	<a class="search" href="javascript:showList();"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a>
                          </div>
                    </td>
                </tr>
            </table>
        </div>
       </div>

    <!--조회년월 검색 테이블 끝-->

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

      	<thead  >
              <tr >
                <th  class="divide" rowspan="2"><!-- Section --><%=g.getMessage("LABEL.D.D02.0003")%></th>
                <th rowspan="2"><!-- Daily --><%=g.getMessage("LABEL.D.D02.0004")%> <br> <!-- Work --><%=g.getMessage("LABEL.D.D02.0005")%> <br> <!-- Schedule --><%=g.getMessage("LABEL.D.D02.0006")%></th>
                <th colspan="3" ><!-- Overtime(Hours)--><%=g.getMessage("LABEL.D.D02.0007")%></th>
                <th rowspan="2" ><!-- Duty --><%=g.getMessage("LABEL.D.D02.0008")%> <br> <!--(Days) --><%=g.getMessage("LABEL.D.D02.0009")%></th>
                <th colspan="3" ><!-- Duty(Hours) --><%=g.getMessage("LABEL.D.D02.0010")%></th>
                <th colspan="4"><!-- Leave(Days) --><%=g.getMessage("LABEL.D.D02.0011")%></th>
                <th colspan="3" class="lastCol"><!-- Absence(Account)--><%=g.getMessage("LABEL.D.D02.0012")%></th>
                <% if(E_RETURN.trim().equals("S")) { %>
<!--                    <th rowspan="3">&nbsp;</th>  -->
                <%} %>
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
                <th class="lastCol" ><!-- Early <br> Dismissa --><%=g.getMessage("LABEL.D.D02.0022")%></th>
              </tr>
            </thead>
              <tr>



   <% if(!E_RETURN.trim().equals("S")) { %>

            <td class="lastCol" colspan="16">No data</td>

    <%}else{ %>

            <th  class="divide"><!-- Monthly Total --><%=g.getMessage("LABEL.D.D15.0139")%></th>

            <th class="align_right" >&nbsp;</th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.OT_WOR,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.OT_OFF,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.OT_HOL,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.DU_FIX,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.DU_WOR,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.DU_OFF,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.DU_HOL,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.LE_ANN,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.LE_SIC,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.LE_PER,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.LE_OTH,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.AB_ABS,1) %> </th>
            <th class="align_right" ><%=WebUtil.printNumFormat(monthlyData.AB_TAR,1) %> </th>
            <th class="align_right lastCol" ><%=WebUtil.printNumFormat(monthlyData.AB_EAR,1) %> </th>
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

          D02ConductDisplayDayData detailData =(D02ConductDisplayDayData) dayDetial_vt.get(i);

          DataUtil.fixNullAndTrim( detailData );

          detailData =(D02ConductDisplayDayData)AppUtil.nvlEntity(detailData);

%>
          <tr class="borderRow">
<%

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

            <td class="divide" <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> ><%=WebUtil.printDate(detailData.DATE) %></td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:left"  > &nbsp; <%=detailData.DWS %> </td>
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

           <tr align="center">
               <td colspan="7"><!--No data --><%=g.getMessage("LABEL.D.D04.0039")%></td>
           </tr>
<%
  }
%>
            </table>
        </div>
    </div>
</div>

<%
 }
%>
<%} %>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

