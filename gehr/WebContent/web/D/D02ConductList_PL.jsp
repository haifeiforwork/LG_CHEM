<%/******************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Personal HR Info                                                  */
/*   2Depth Name  : Time Management                                                        */
/*   Program Name : Time & Attendance                                                  */
/*   Program ID   : D02ConductListPl.jsp                                          */
/*   Description  : 근태 사항을 조회[폴란드]                                            */
/*   Note         :                                                             */
/*   Creation     : 2010-07-16  yji                                          */
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
    D02ConductDisplayMonthData monthlyData =(D02ConductDisplayMonthData) request.getAttribute( "monthlyData" ) ;
    monthlyData =(D02ConductDisplayMonthData)AppUtil.nvlEntity(monthlyData);
    Vector dayDetial_vt = (Vector) request.getAttribute( "dayDetial_vt" );

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
<%if(Locale.ENGLISH.equals(user.locale)){
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
        var tableWidth = $('.subWrapper').width()-30;
        $('.listTable').css('width', tableWidth);
        $('.tableArea').css('width', tableWidth);
    });
    $(window).trigger("resize");

});
</script>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="D02ConductPl.html'"/>
    </jsp:include>
<form name="searchForm">

    <div class="tableInquiry">
            <table>
                <colgroup>
                    <col width="15%" />
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

</form>

    <div class="listArea noBtMargin">
        <div class="table" style="margin-right:17px;">
            <table class="listTable noBtMargin" id="tab_h" style="margin-right:17px;">
                <colgroup>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                </colgroup>
                <thead>
                <tr>
                    <th rowspan="2"><!-- Section --><%=g.getMessage("LABEL.D.D02.0003")%></th>
                    <th rowspan="2"><!-- Daily --><%=g.getMessage("LABEL.D.D02.0004")%> <br> <!-- Work --><%=g.getMessage("LABEL.D.D02.0005")%> <br> <!-- Schedule --><%=g.getMessage("LABEL.D.D02.0006")%></th>
                    <th colspan="4"><!-- Overtime(Hours)--><%=g.getMessage("LABEL.D.D02.0007")%></th>
                    <th colspan="4"><!-- Leave(Days) --><%=g.getMessage("LABEL.D.D02.0011")%></th>
                    <th colspan="2" class="lastCol" ><!-- Absence(Account)--><%=g.getMessage("LABEL.D.D02.0012")%></th>

          <% if(E_RETURN.trim().equals("S")) { %>

            <!--<td rowspan=3  class="td04">&nbsp;</td>  -->
          <%} %>

                </tr>

                <tr>
                    <th>50%</th>
                    <th>100%</th>
                    <th><!-- Night --><%=g.getMessage("LABEL.D.D02.0023")%></th>
                    <th><!-- Holiday --><%=g.getMessage("LABEL.D.D02.0015")%></th>
                    <th><!-- Annual --><%=g.getMessage("LABEL.D.D02.0016")%></th>
                    <th><!-- Section --><%=g.getMessage("LABEL.D.D02.0024")%></th>
                    <th><!-- Sick --><%=g.getMessage("LABEL.D.D02.0017")%></th>
                    <th><!-- Others --><%=g.getMessage("LABEL.D.D02.0019")%></th>
                    <th><!-- Section --><%=g.getMessage("LABEL.D.D02.0025")%></th>
                    <th class="lastCol"><!-- Tardiness --><%=g.getMessage("LABEL.D.D02.0021")%></th>
                </tr>
                </thead>
                <tr>
    <% if(!E_RETURN.trim().equals("S")) { %>
                    <td colspan="12"><!--No data --><%=g.getMessage("LABEL.D.D04.0039")%></td>
    <%}else{ %>
                    <td ><!-- Monthly Total --><%=g.getMessage("LABEL.D.D15.0139")%></td>
                    <td class="align_right">&nbsp;</td>
                    <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.OT_ADD,1) %> </td>
                    <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.OT_WOR,1) %> </td>
                    <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.OT_OFF,1) %> </td>
                    <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.OT_HOL,1) %> </td>
                    <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.LE_ANN,1) %> </td>
                    <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.LE_DMD,1) %> </td>
                    <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.LE_SIC,1) %> </td>
                    <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.LE_OTH,1) %> </td>
                    <td class="align_right"><%=WebUtil.printNumFormat(monthlyData.AB_ABS,1) %> </td>
                    <td class="align_right lastCol"><%=WebUtil.printNumFormat(monthlyData.AB_TAR,1) %> </td>
     <%} %>
                </tr>
            </table>
        </div>
    </div>

<% if(E_RETURN.trim().equals("S")) { %>

<div style="height:370px; overflow:auto;" id="div_c">
	<table class="listTable" id="tab_c">
                <colgroup>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                    <col width="8.33%"/>
                </colgroup>

<%

if(dayDetial_vt.size() > 0 ){
       for(int i=0; i<dayDetial_vt.size(); i++ ){

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
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%>><%=WebUtil.printDate(detailData.DATE) %></td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:left" > &nbsp;<%=detailData.DWS %> </td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"><%=detailData.OT_ADD.equals("0") ? "" : WebUtil.printNumFormat(detailData.OT_ADD,1) %> </td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"><%=detailData.OT_WOR.equals("0") ? "" : WebUtil.printNumFormat(detailData.OT_WOR,1) %> </td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"><%=detailData.OT_OFF.equals("0") ? "" : WebUtil.printNumFormat(detailData.OT_OFF,1) %> </td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"><%=detailData.OT_HOL.equals("0") ? "" : WebUtil.printNumFormat(detailData.OT_HOL,1) %> </td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"><%=detailData.LE_ANN.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_ANN,1) %> </td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"><%=detailData.LE_DMD.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_SIC,1) %> </td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"><%=detailData.LE_SIC.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_SIC,1) %> </td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"><%=detailData.LE_OTH.equals("0") ? "" : WebUtil.printNumFormat(detailData.LE_OTH,1) %> </td>
            <td <%= isWeekend ? "class=\"sunday\"" : "class=\"\""%> style="text-align:right"><%=detailData.AB_ABS.equals("0") ? "" : WebUtil.printNumFormat(detailData.AB_ABS,1) %> </td>
            <td <%= isWeekend ? "class=\"sunday lastCol\"" : "class=\"lastCol\""%> style="text-align:right"><%=detailData.AB_TAR.equals("0") ? "" : WebUtil.printNumFormat(detailData.AB_TAR,1) %> </td>
        </tr>

<%
  }
}else{ %>

       <tr>
           <td colspan="12" class="lastCol"><!--No data --><%=g.getMessage("LABEL.D.D04.0039")%></td>
       </tr>
<%
  }
%>
        </table>
</div>

<%
 }
%>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
