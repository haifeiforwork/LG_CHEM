<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조대상자                                                    */
/*   Program Name : 경조지원내역 조회                                               */
/*   Program ID   : G004ApprovalCongra_pop.jsp                                     */
/*   Description  : 경조지원내역 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-06-13 ebksong                                                            */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E20Congra.rfc.*" %>
<%@ page import="hris.E.E20Congra.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    // 경조대상자 조회..
    String PERNR = (String)request.getParameter("PERNR");
    String sortField = (String)request.getParameter("sortField");
    String select = (String)request.getParameter("select");
    E20CongDisplayRFC func1 = new E20CongDisplayRFC();
    Vector             E20CongcondData_dis= func1.getCongDisplay(user.sapType,PERNR) ;
    if ( sortField.equals( select ) ) {
       E20CongcondData_dis = SortUtil.sort( E20CongcondData_dis, sortField, "asc" );
   } else {
       E20CongcondData_dis = SortUtil.sort( E20CongcondData_dis, sortField, "desc" );
   }
    int check_1 = 1;

%>
<jsp:include page="/include/header.jsp" />
<script language="Javascript">
<!--

function sort( field_num ) {
    //E20CongcondData_dis = SortUtil.sort( E20CongcondData_dis, FieldName, "desc" );
    //document.form1.CHECK_1 = "1" ;
   if ( field_num == '1' ) {
    var url="<%=WebUtil.JspURL%>"+"G/G004ApprovalCongra_pop.jsp?PERNR="+"<%=PERNR%>"+"&sortField=BEGDA&select="+"<%=sortField%>";
   } else if ( field_num == '2' ){
     var url="<%=WebUtil.JspURL%>"+"G/G004ApprovalCongra_pop.jsp?PERNR="+"<%=PERNR%>"+"&sortField=CONG_NAME&select="+"<%=sortField%>";
   } else if ( field_num == '3' ){
     var url="<%=WebUtil.JspURL%>"+"G/G004ApprovalCongra_pop.jsp?PERNR="+"<%=PERNR%>"+"&sortField=RELA_NAME&select="+"<%=sortField%>";
   } else if ( field_num == '4' ){
     var url="<%=WebUtil.JspURL%>"+"G/G004ApprovalCongra_pop.jsp?PERNR="+"<%=PERNR%>"+"&sortField=EREL_NAME&select="+"<%=sortField%>";
   } else if ( field_num == '5' ){
     var url="<%=WebUtil.JspURL%>"+"G/G004ApprovalCongra_pop.jsp?PERNR="+"<%=PERNR%>"+"&sortField=CONG_DATE&select="+"<%=sortField%>";
   } else if ( field_num == '6' ){
     var url="<%=WebUtil.JspURL%>"+"G/G004ApprovalCongra_pop.jsp?PERNR="+"<%=PERNR%>"+"&sortField=CONG_WONX&select="+"<%=sortField%>";
   } else if ( field_num == '7' ){
     var url="<%=WebUtil.JspURL%>"+"G/G004ApprovalCongra_pop.jsp?PERNR="+"<%=PERNR%>"+"&sortField=POST_DATE&select="+"<%=sortField%>";
   }   //var url = "/servlet/hris.E.E20Congra.E20CongraListSV_m"
      var win = window.open(url,"_parent","width=810,height=480,left=365,top=70,scrollbars=yes");
      win.focus();

}
-->
</script>
<div class="winPop">
	<div class="header">
		<span><spring:message code="LABEL.G.G04.0001" /><!-- 경조금 조회 --></span>
		<a href="javascript:self.close();"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
	</div>

<div class="body">
<form name="form1" method="post">
  <input type="hidden" name = "CHECK_1" value="">
        <!-- 조회 리스트 테이블 시작-->
	<div class="listArea">
		<div class="table">
			<table class="listTable">
          <tr>
            <th width="90" onClick="javascript:sort('1')" style="cursor:hand"><spring:message code="LABEL.G.G04.0002" /><!-- 신청일 -->
            <%= sortField.equals("BEGDA") ? sortField.equals(select) ?
             "<font color='#FF0000'><b>▼</b></font>"
            : "<font color='#FF0000'><b>▲</b></font>"
            : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
            <th width="80" onClick="javascript:sort('2')" style="cursor:hand"><spring:message code="LABEL.G.G04.0003" /><!-- 경조내역 -->
            <%= sortField.equals("CONG_NAME") ? sortField.equals(select) ?
             "<font color='#FF0000'><b>▼</b></font>"
            : "<font color='#FF0000'><b>▲</b></font>"
            : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
            <th width="130" onClick="javascript:sort('3')" style="cursor:hand"><spring:message code="LABEL.G.G04.0004" /><!-- 경조대상자 관계 -->
            <%= sortField.equals("RELA_NAME") ? sortField.equals(select) ?
             "<font color='#FF0000'><b>▼</b></font>"
            : "<font color='#FF0000'><b>▲</b></font>"
            : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
            <th width="80" onClick="javascript:sort('4')" style="cursor:hand"><spring:message code="LABEL.G.G04.0005" /><!-- 대상자 -->
            <%= sortField.equals("EREL_NAME") ? sortField.equals(select) ?
             "<font color='#FF0000'><b>▼</b></font>"
            : "<font color='#FF0000'><b>▲</b></font>"
            : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
            <th width="100" onClick="javascript:sort('5')" style="cursor:hand"><spring:message code="LABEL.G.G04.0006" /><!-- 경조발생일 -->
            <%= sortField.equals("CONG_DATE") ? sortField.equals(select) ?
             "<font color='#FF0000'><b>▼</b></font>"
            : "<font color='#FF0000'><b>▲</b></font>"
            : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
            <th width="80" onClick="javascript:sort('6')" style="cursor:hand"><spring:message code="LABEL.G.G04.0007" /><!-- 경조금액 -->
            <%= sortField.equals("CONG_WONX") ? sortField.equals(select) ?
             "<font color='#FF0000'><b>▼</b></font>"
            : "<font color='#FF0000'><b>▲</b></font>"
            : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
            <th class="lastCol" width="90" onClick="javascript:sort('7')" style="cursor:hand"><spring:message code="LABEL.G.G04.0008" /><!-- 최종결재일 -->
            <%= sortField.equals("POST_DATE") ? sortField.equals(select) ?
             "<font color='#FF0000'><b>▼</b></font>"
            : "<font color='#FF0000'><b>▲</b></font>"
            : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
          </tr>
<%
        for( int i = 0 ; i < E20CongcondData_dis.size() ; i++ ) {
            E20CongcondData data = (E20CongcondData)E20CongcondData_dis.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
          <tr class="<%=tr_class%>">
            <td><%=data.BEGDA.equals("0000-00-00")||data.BEGDA.equals("") ? "" : WebUtil.printDate(data.BEGDA)%></td>
            <td><%=data.CONG_NAME%></td>
            <td><%=data.RELA_NAME%></td>
            <td><%=data.EREL_NAME%></td>
            <td><%=data.CONG_DATE.equals("0000-00-00")||data.CONG_DATE.equals("") ? "" : WebUtil.printDate(data.CONG_DATE)%></td>
<%
//  2002.07.09. 경조발생일자가 2002.01.01. 이전이면 통상임금, 경조금액을 보여주지 않는다.
    String dateCheck = "Y";
        long dateLong = Long.parseLong(DataUtil.removeStructur(data.CONG_DATE, "-"));

        if( dateLong < 20020101 ) {
            dateCheck = "N";
        }
        if( dateCheck.equals("Y") ) {
%>
            <td align="right"><%= WebUtil.printNumFormat(data.CONG_WONX) %>&nbsp;&nbsp;</td>
<%
        } else {
%>
            <td align="right">&nbsp;</td>
<%
        }  // end of if( dateLong < 20020101 )
//  2002.07.09. 0보다 큰 경우에만 값을 보여준다.
%>
            <td class="lastCol"><%=data.POST_DATE.equals("0000-00-00")||data.POST_DATE.equals("") ? "" : WebUtil.printDate(data.POST_DATE)%></td>
          </tr>
<%
  } // end of for( int i = 0 ; i < E20CongcondData_dis.size() ; i++ )
%>
              </table>
		</div>
	</div>
</form>
</div>
<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="PERNR"    value="<%= PERNR %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="select" value="<%= select %>">
</form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>
