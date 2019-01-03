<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근무 계획표                                                 */
/*   Program ID   : F44DeptWorkScheduleExcel.jsp                                */
/*   Description  : 부서별 근무 계획표 Excel 저장을 위한 jsp 파일               */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-18 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>

<%@ page import="hris.common.util.*" %>

<%@ page import="hris.F.Global.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.GregorianCalendar" %>
 <%@ page import="java.text.SimpleDateFormat" %>
<%
	request.setCharacterEncoding("utf-8");
	WebUserData user = (WebUserData)session.getAttribute("user");
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));          //부서명
   	String searchDay    = WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));   //대상년월
    String year      = "";
    String month     = "";
    Vector F44DeptScheduleTitle_vt = (Vector)request.getAttribute("F44DeptScheduleTitle_vt");   //제목
    Vector F44DeptScheduleData_vt  = (Vector)request.getAttribute("F44DeptScheduleData_vt");    //내용

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Mothly_Work_Schedule.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">


</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<%
    if ( F44DeptScheduleTitle_vt != null && F44DeptScheduleTitle_vt.size() > 0 ) {
        //타이틀 사이즈.
        int titlSize = F44DeptScheduleTitle_vt.size();
        int tableSize = titlSize*60 + 160;

	    //대상년월 폼 변경.
%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td colspan="15" class="title02">*<%=g.getMessage("LABEL.F.F44.0002")%></td>
        </tr>
	    <tr><td colspan="15" height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="15" class="td09_1">
            &nbsp;<%--Period --%><%=g.getMessage("LABEL.F.F22.0001")%>:  <%=searchDay%>
          </td>
          <td colspan="15"></td>
        </tr>
      </table>
    </td>
    <td  width="16">&nbsp;</td>
  </tr>

  <tr><td height="10"></td></tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td class="td09_1" colspan="2">&nbsp;<!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
  	<td width="16">&nbsp;</td>
    <td class="td09_1">&nbsp;</td>
    <td class="td08">&nbsp;</td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
          <td rowspan="2" class="td03" style="text-align:center"><!--Pers.No--><%=g.getMessage("LABEL.F.F41.0020")%></td>
          <td  rowspan="2" class="td03" nowrap><!--Name--><%=g.getMessage("LABEL.F.F42.0003")%></td>
<%
                //타이틀(일자).
                for( int h = 0; h < titlSize; h++ ){
                    F44DeptWorkScheduleTitleData titleData = (F44DeptWorkScheduleTitleData)F44DeptScheduleTitle_vt.get(h);
                    String tdColor = "class=td03";
                    if (titleData.DAYTXT.equals("Sunday")) {
                        tdColor = "class=td11";
                    }
%>
          <td  <%=tdColor%> style='text-align:center' nowrap><%=titleData.DAY.substring(8,10) %></td>
<%
                }
%>
        </tr>
        <tr>
<%
                //타이틀(요일).
                for( int k = 0; k < titlSize; k++ ){
                    F44DeptWorkScheduleTitleData titleData = (F44DeptWorkScheduleTitleData)F44DeptScheduleTitle_vt.get(k);
                    String tdColor = "class=td03";
                    if (titleData.DAYTXT.equals("Sunday")) {
                        tdColor = "class=td11 ";
                    }
%>
          <td <%=tdColor%> style='text-align:center' nowrap><%= titleData.DAYTXT.substring(0,3) %></td>
<%
                }//end if
                int inx = 0;
                for( int i = 0; i < F44DeptScheduleData_vt.size(); i++ ){
                    F44DeptWorkScheduleNoteData data = (F44DeptWorkScheduleNoteData)F44DeptScheduleData_vt.get(i);
                    inx++;
%>
        <tr>
          <td class="td04" style="text-align:center">&nbsp;&nbsp;<%=data.PERNR%>&nbsp;&nbsp;</td>
          <td class="td04" style="text-align:left">&nbsp;&nbsp;<%=data.ENAME%></td>
          <td class="td04"><%=data.TPROG01 %></td>
          <td class="td04"><%=data.TPROG02 %></td>
          <td class="td04"><%=data.TPROG03 %></td>
          <td class="td04"><%=data.TPROG04 %></td>
          <td class="td04"><%=data.TPROG05 %></td>
          <td class="td04"><%=data.TPROG06 %></td>
          <td class="td04"><%=data.TPROG07 %></td>
          <td class="td04"><%=data.TPROG08 %></td>
          <td class="td04"><%=data.TPROG09 %></td>
          <td class="td04"><%=data.TPROG10 %></td>
          <td class="td04"><%=data.TPROG11 %></td>
          <td class="td04"><%=data.TPROG12 %></td>
          <td class="td04"><%=data.TPROG13 %></td>
          <td class="td04"><%=data.TPROG14 %></td>
          <td class="td04"><%=data.TPROG15 %></td>
          <td class="td04"><%=data.TPROG16 %></td>
          <td class="td04"><%=data.TPROG17 %></td>
          <td class="td04"><%=data.TPROG18 %></td>
          <td class="td04"><%=data.TPROG19 %></td>
          <td class="td04"><%=data.TPROG20 %></td>
          <td class="td04"><%=data.TPROG21 %></td>
          <td class="td04"><%=data.TPROG22 %></td>
          <td class="td04"><%=data.TPROG23 %></td>
          <td class="td04"><%=data.TPROG24 %></td>
          <td class="td04"><%=data.TPROG25 %></td>
          <td class="td04"><%=data.TPROG26 %></td>
          <td class="td04"><%=data.TPROG27 %></td>
          <td class="td04"><%=data.TPROG28 %></td>
          <% if( titlSize >= 29 )  out.println("<td class=td04>"+data.TPROG29+"</td>"); %>
          <% if( titlSize >= 30 )  out.println("<td class=td04>"+data.TPROG30+"</td>"); %>
          <% if( titlSize >= 31 )  out.println("<td class=td04>"+data.TPROG31+"</td>"); %>
        </tr>
<%
                } //end for...
%>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>
<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><!-- No data --><%=g.getMessage("LABEL.F.F51.0029")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>