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
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    String E_BEGDA      = WebUtil.nvl((String)request.getAttribute("E_BEGDA"));     //대상년월
    String E_ENDDA      = WebUtil.nvl((String)request.getAttribute("E_ENDDA"));     //대상년월
    Vector F44DeptScheduleTitle_vt = (Vector)request.getAttribute("F44DeptScheduleTitle_vt");   //제목
    Vector F44DeptScheduleData_vt  = (Vector)request.getAttribute("F44DeptScheduleData_vt");    //내용
    Vector T_TPROG  = (Vector)request.getAttribute("T_TPROG");    //일일근무일정 설명 추가 2018-02-09

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptWorkSchedule.xls");
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
	    if( !E_BEGDA.equals("") && !E_ENDDA.equals("") ){
	        E_BEGDA = E_BEGDA.substring(0, 4)+"."+E_BEGDA.substring(4, 6);
	        E_ENDDA = E_ENDDA.substring(0, 4)+"."+E_ENDDA.substring(4, 6);
	    }
%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td colspan="15" class="title02">* <!-- 근무 계획표 --><%=g.getMessage("LABEL.F.F44.0001")%></td>
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
          <td colspan="15" class="td09">
            &nbsp;( <%=E_BEGDA%>~<%=E_ENDDA%> )<!-- 월 --><%=g.getMessage("LABEL.F.F42.0053")%> <!-- 근무 계획표 --><%=g.getMessage("LABEL.F.F44.0001")%>
          </td>
          <td colspan="15"></td>
        </tr>
      </table>
    </td>
    <td  width="16">&nbsp;</td>
  </tr>

<%
        String tempDept = "";
	    for( int j = 0; j < F44DeptScheduleData_vt.size(); j++ ){
	        F44DeptWorkScheduleNoteData deptData = (F44DeptWorkScheduleNoteData)F44DeptScheduleData_vt.get(j);

	        //하위부서를 선택했을 경우 부서 비교.
	        if( !deptData.ORGEH.equals(tempDept) ){
%>
  <tr><td height="10"></td></tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td class="td09">&nbsp;<!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=deptData.STEXT%></td>
    <td class="td08">&nbsp;</td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
          <td width="40" rowspan="2" class="td03" nowrap><!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%></td>
          <td width="60" rowspan="2" class="td03" nowrap><!-- 성명--><%=g.getMessage("LABEL.F.F42.0003")%></td>
          <td width="60" rowspan="2" class="td03" nowrap><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></td>
<%
                //타이틀(일자).
                for( int h = 0; h < titlSize; h++ ){
                    F44DeptWorkScheduleTitleData titleData = (F44DeptWorkScheduleTitleData)F44DeptScheduleTitle_vt.get(h);
                    String tdColor = "class=td03";
                    if (titleData.HOLIDAY.equals("Y")) {
                        tdColor = "class=td11";
                    }
%>
          <td width="40" <%=tdColor%> nowrap><%=titleData.DD%></td>
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
                    if (titleData.HOLIDAY.equals("Y")) {
                        tdColor = "class=td11";
                    }
%>
          <td width="40" <%=tdColor%> nowrap><%=titleData.KURZT%></td>
<%
                }//end if

                int inx = 0;
                for( int i = j; i < F44DeptScheduleData_vt.size(); i++ ){
                    F44DeptWorkScheduleNoteData data = (F44DeptWorkScheduleNoteData)F44DeptScheduleData_vt.get(i);
                    if( data.ORGEH.equals(deptData.ORGEH) ){
                    inx++;
%>
        <tr>
          <td class="td05"><%=inx%>&nbsp;&nbsp;</td>
          <td class="td04"><%=data.ENAME%></td>
          <td class="td04"><%=data.PERNR%></td>
          <td class="td04"><%=data.T1 %></td>
          <td class="td04"><%=data.T2 %></td>
          <td class="td04"><%=data.T3 %></td>
          <td class="td04"><%=data.T4 %></td>
          <td class="td04"><%=data.T5 %></td>
          <td class="td04"><%=data.T6 %></td>
          <td class="td04"><%=data.T7 %></td>
          <td class="td04"><%=data.T8 %></td>
          <td class="td04"><%=data.T9 %></td>
          <td class="td04"><%=data.T10%></td>
          <td class="td04"><%=data.T11%></td>
          <td class="td04"><%=data.T12%></td>
          <td class="td04"><%=data.T13%></td>
          <td class="td04"><%=data.T14%></td>
          <td class="td04"><%=data.T15%></td>
          <td class="td04"><%=data.T16%></td>
          <td class="td04"><%=data.T17%></td>
          <td class="td04"><%=data.T18%></td>
          <td class="td04"><%=data.T19%></td>
          <td class="td04"><%=data.T20%></td>
          <td class="td04"><%=data.T21%></td>
          <td class="td04"><%=data.T22%></td>
          <td class="td04"><%=data.T23%></td>
          <td class="td04"><%=data.T24%></td>
          <td class="td04"><%=data.T25%></td>
          <td class="td04"><%=data.T26%></td>
          <td class="td04"><%=data.T27%></td>
          <td class="td04"><%=data.T28%></td>
          <% if( titlSize >= 29 )  out.println("<td class=td04>"+data.T29+"</td>"); %>
          <% if( titlSize >= 30 )  out.println("<td class=td04>"+data.T30+"</td>"); %>
          <% if( titlSize >= 31 )  out.println("<td class=td04>"+data.T31+"</td>"); %>
        </tr>
<%
                    }//end if
                } //end for...
%>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
<%
                //부서코드 비교를 위한 값.
	            tempDept = deptData.ORGEH;
	        }//end if
        }//end for
%>
  <tr><td height="16"></td></tr>

<tr>
	    <td width="16">&nbsp;</td>
	    <td class="td09">&nbsp;<!-- 일일근무일정 설명--><spring:message code='LABEL.D.D40.0026'/></td>
	    <td class="td08">&nbsp;</td>
	    <td width="16">&nbsp;</td>
	  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
        	<th><!-- 코드--><spring:message code='LABEL.D.D13.0004'/></th>
			<th colspan="2"><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
			<th colspan="3"><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
			<th><!-- 코드--><spring:message code='LABEL.D.D13.0004'/></th>
			<th colspan="2"><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
			<th colspan="3"><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
        </tr>
<%
		if(T_TPROG.size()%2 != 0){
			D40TmSchkzPlanningChartCodeData addDt = new D40TmSchkzPlanningChartCodeData();
			addDt.CODE = "";
			addDt.TEXT = "";
			addDt.DESC = "";
			T_TPROG.addElement(addDt);
		}
		for( int i = 0; i < T_TPROG.size(); i++ ){
			D40TmSchkzPlanningChartCodeData data = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(i);
			String tr_class = "";
                  if(i%4 == 0){
                      tr_class="oddRow";
                  }else{
                      tr_class="";
                  }
%>
		<%if(i%2 == 0){ %>
		<tr class="<%=tr_class%>">
			<td><%=data.CODE %></td>
			<td colspan="2"><%=data.TEXT %></td>
			<td colspan="3"><%=data.DESC %></td>
		<%}else{ %>
			<td><%=data.CODE %></td>
			<td colspan="2"><%=data.TEXT %></td>
			<td colspan="3"><%=data.DESC %></td>
		</tr>
		<%} %>

<%
		}
%>
	</table>

<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.COMMON.0004")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>