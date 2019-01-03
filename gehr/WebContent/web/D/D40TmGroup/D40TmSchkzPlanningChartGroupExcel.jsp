<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정	-근무계획표 조회						*/
/*   Program Name	:   계획근무일정	-근무계획표 조회(엑셀다운로드)		*/
/*   Program ID		: D40TmSchkzPlanningChartExcel.jsp				*/
/*   Description		: 계획근무일정-근무계획표 조회(엑셀다운로드)		*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%

	WebUserData user = (WebUserData)session.getAttribute("user");

	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자

	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));
	String sMenuCode =  (String)request.getAttribute("sMenuCode");

	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_TPROG    = (Vector)request.getAttribute("T_TPROG");	//일일근무상세설명
	Vector T_EXPORTA    = (Vector)request.getAttribute("T_EXPORTA");	//근무계획표-TITLE
	Vector T_EXPORTB    = (Vector)request.getAttribute("T_EXPORTB");	//근무계획표-DATA

	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜
	String gubun    = (String)request.getAttribute("gubun");	//선택날짜

	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

// 	String fileName = java.net.URLEncoder.encode("근무계획표","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0029"),"UTF-8");

	fileName = fileName+time;
	fileName = fileName.replace("\r","").replace("\n","");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename="+fileName+".xls");
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
	if ( T_EXPORTA != null && T_EXPORTA.size() > 0 ) {
        //타이틀 사이즈.
        int titlSize = T_EXPORTA.size();
        int tableSize = titlSize*60 + 160;

%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td colspan="15" class="title02">* <!-- 근무 계획표 --><%=g.getMessage("LABEL.F.F44.0001")%>(<spring:message code='TAB.D.D40.0021'/>)</td>
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
            <%=E_INFO%>
          </td>
          <td colspan="15"></td>
        </tr>
      </table>
    </td>
    <td  width="16">&nbsp;</td>
  </tr>

  <tr><td height="10"></td></tr>
<!--   <tr> -->
<!--     <td width="16">&nbsp;</td> -->
<%--     <td class="td09">&nbsp;<!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=deptData.STEXT%> [<%=deptData.ORGEH%>]</td> --%>
<%--     <td class="td08"><!-- 발행일자 --><%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %></td> --%>
<!--     <td width="16">&nbsp;</td> -->
<!--   </tr> -->
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
<%--           <td width="40" rowspan="2" class="td03" nowrap><!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%></td> --%>
          <td width="60" rowspan="2" colspan="2" class="td03" nowrap><!-- 계획근무--><%=g.getMessage("LABEL.D.D40.0025")%></td>
<%--           <td width="60" rowspan="2" class="td03" nowrap><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></td> --%>
<%
                //타이틀(일자).
                for( int h = 0; h < titlSize; h++ ){
                	D40TmSchkzPlanningChartData titleData = (D40TmSchkzPlanningChartData)T_EXPORTA.get(h);
                    String tdColor = "";
                    if (titleData.HOLIDAY.equals("Y")) {
                        tdColor = "td11";
                    }
                    if (titleData.HOLIDAY.equals("X")) {
                        tdColor = "td11 T"+(h+1);
                    }
%>
          <td width="40" class='<%=tdColor%>' nowrap><%=titleData.DD%></td>
<%
                }
%>
        </tr>
        <tr>
<%
                //타이틀(요일).
                for( int k = 0; k < titlSize; k++ ){
                	D40TmSchkzPlanningChartData titleData = (D40TmSchkzPlanningChartData)T_EXPORTA.get(k);
                    String tdColor = "";
                    if (titleData.HOLIDAY.equals("Y")) {
                        tdColor = "td11";
                    }
                    if (titleData.HOLIDAY.equals("X")) {
                        tdColor = "td11 T"+(k+1);
                    }
%>
          <td width="40" class='<%=tdColor%>' nowrap><%=titleData.KURZT%></td>
<%
                }//end for
%>
                </tr>
<%

//                 int inx = 0;
                for( int i = 0; i < T_EXPORTB.size(); i++ ){
                	D40TmSchkzPlanningChartNoteData data = (D40TmSchkzPlanningChartNoteData)T_EXPORTB.get(i);
//                     if( data.ORGEH.equals(deptData.ORGEH) ){
//                     inx++;
%>
        <tr>
<%--           <td class="td05"><%=inx%>&nbsp;&nbsp;</td> --%>
          <td class=""><%=data.SCHKZ%></td>
          <td class=""><%=data.SCHKZ_TX%></td>
          <td class="T1"><%=data.T1 %></td>
          <td class="T2"><%=data.T2 %></td>
          <td class="T3"><%=data.T3 %></td>
          <td class="T4"><%=data.T4 %></td>
          <td class="T5"><%=data.T5 %></td>
          <td class="T6"><%=data.T6 %></td>
          <td class="T7"><%=data.T7 %></td>
          <td class="T8"><%=data.T8 %></td>
          <td class="T9"><%=data.T9 %></td>
          <td class="T10"><%=data.T10%></td>
          <td class="T11"><%=data.T11%></td>
          <td class="T12"><%=data.T12%></td>
          <td class="T13"><%=data.T13%></td>
          <td class="T14"><%=data.T14%></td>
          <td class="T15"><%=data.T15%></td>
          <td class="T16"><%=data.T16%></td>
          <td class="T17"><%=data.T17%></td>
          <td class="T18"><%=data.T18%></td>
          <td class="T19"><%=data.T19%></td>
          <td class="T20"><%=data.T20%></td>
          <td class="T21"><%=data.T21%></td>
          <td class="T22"><%=data.T22%></td>
          <td class="T23"><%=data.T23%></td>
          <td class="T24"><%=data.T24%></td>
          <td class="T25"><%=data.T25%></td>
          <td class="T26"><%=data.T26%></td>
          <td class="T27"><%=data.T27%></td>
          <td class="T28"><%=data.T28%></td>
          <% if( titlSize >= 29 ){%><td class='T29'><%=data.T29%></td><% } %>
          <% if( titlSize >= 30 ){%><td class='T30'><%=data.T30%></td><% } %>
          <% if( titlSize >= 31 ){%><td class='T31'><%=data.T31%></td><% } %>
        </tr>
<%
//                     }//end if
                } //end for...
%>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>

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
			<th><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
			<th><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
			<th><!-- 코드--><spring:message code='LABEL.D.D13.0004'/></th>
			<th><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
			<th><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
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
			<td><%=data.TEXT %></td>
			<td><%=data.DESC %></td>
		<%}else{ %>
			<td><%=data.CODE %></td>
			<td><%=data.TEXT %></td>
			<td><%=data.DESC %></td>
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
</td>
</tr>
</table>
</form>
</body>
</html>

