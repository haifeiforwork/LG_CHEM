<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Organization & Staffing
*   2Depth Name  : Headcount
*   Program Name : Org.Unit/Distance
*   Program ID   : F73DistanceInKilometersExcelEurp.jsp
*   Description  : 부서별 거주지와 출퇴근정보 Excel 저장을 위한 jsp 파일
*   Note         :
*   Creation     :
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");                            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드


    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                  //부서명
    Vector F73DistanceInKilometersTitle_vt = (Vector)request.getAttribute("F73DistanceInKilometersTitle_vt");   //제목
    HashMap meta = (HashMap)request.getAttribute("meta");
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Distance_InKilometers_Level.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
    F73DistanceInKilometersEurpGlobalData total = new F73DistanceInKilometersEurpGlobalData();
    AppUtil.initEntity(total,"0");
    if(F73DistanceInKilometersTitle_vt.size() > 0)
         total = (F73DistanceInKilometersEurpGlobalData)F73DistanceInKilometersTitle_vt.get(F73DistanceInKilometersTitle_vt.size() - 1 );
    AppUtil.nvlEntity(total);
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
    if ( F73DistanceInKilometersTitle_vt != null && F73DistanceInKilometersTitle_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="2" class="title02">* <spring:message code='LABEL.F.F03.0001'/><!-- Working area -->/<spring:message code='LABEL.F.F04.0005'/><!-- Level --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="2" class="td09">
            &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
          <td ></td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td valign="top" width="">
		<table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
	        <tr>
	          <td width="162" class="td03" rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.&nbsp;Unit --></td>
	          <td width="100" class="td03" rowspan="2"><spring:message code='LABEL.F.F73.0001'/><!-- Active --><br><spring:message code='LABEL.F.F73.0002'/><!-- Employee --></td>
	          <td width="" class="td03" colspan="5" align="center"><spring:message code='LABEL.F.F73.0003'/><!-- 51km&nbsp;↑ --></td>
	         <td  width="" class="td03" colspan="2" align="center"><spring:message code='LABEL.F.F73.0004'/><!-- 50km&nbsp;↓ --></td>
	        </tr>
	        <tr>
	          <td width="70" class="td03"  nowrap><spring:message code='LABEL.F.F73.0005'/><!-- 100Km&nbsp;↑ --></td>
	          <td width="70" class="td03"  nowrap><spring:message code='LABEL.F.F73.0006'/><!-- 71~100Km --></td>
	          <td width="70" class="td03"  nowrap><spring:message code='LABEL.F.F73.0007'/><!-- 51~71Km --></td>
	          <td width="70" class="td03"  nowrap><spring:message code='LABEL.F.F10.0006'/><!-- SUM --></td>
	          <td width="70" class="td03"  nowrap>%</td>
	          <td width="70" class="td03"  nowrap><spring:message code='LABEL.F.F73.0004'/><!-- 50Km&nbsp;↓ --></td>
	          <td width="70" class="td03"  nowrap>%</td>
	        </tr>
	        <%
	        	//String tmp = "";
	        	//for( int i = 0 ; i < F73DistanceInKilometersTitle_vt.size() ; i ++){
	        	//F73DistanceInKilometersDataEurp entity = (F73DistanceInKilometersDataEurp)F73DistanceInKilometersTitle_vt.get(i);
	        %>
			<%
			        //타이틀에 맞추어 내용영역 보여주기위한 개수.
			        int noteSize = F73DistanceInKilometersTitle_vt.size();
			        //내용.
			        for( int i = 0; i < F73DistanceInKilometersTitle_vt.size(); i++ ){
			        	F73DistanceInKilometersEurpGlobalData entity = (F73DistanceInKilometersEurpGlobalData)F73DistanceInKilometersTitle_vt.get(i);

			            String strBlank  = "";
			            String titlClass = "";
			            String noteClass = "";
			            int blankSize = Integer.parseInt(WebUtil.nvl(entity.ZLEVEL, "0")) ;

			            //클래스 설정.
			  			if (!entity.ORGTX.equals("TOTAL")) {
			                titlClass = "class=td09";
			                noteClass = "class=td05";
			            } else {
			                titlClass = "class=td11 style='text-align:center'";
			                noteClass = "class=td12";
			            }

			            //부서명 앞에 공백넣기.
			            for (int h = 0; h < blankSize; h++) {
			                strBlank = strBlank+"&nbsp;&nbsp;";
			            }
			%>
	        <tr>
				<td  <%=titlClass%> ><%=strBlank%><%= entity.ORGTX %></td>
				<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05"%>"><%=entity.EMPNR %></td>
				<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05"%>"><%= WebUtil.printNumFormat(entity.DIS01) %></td>
			    <td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05"%>"><%= WebUtil.printNumFormat(entity.DIS02) %></td>
				<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05"%>"><%= WebUtil.printNumFormat(entity.DIS03) %></td>
				<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05"%>"><%= WebUtil.printNumFormat(entity.TOTAL) %></td>
				<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05"%>"><%= WebUtil.printNumFormat(entity.PCT01) %></td>
				<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05"%>"><%= WebUtil.printNumFormat(entity.DIS04) %></td>
	            <td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05"%>"><%= WebUtil.printNumFormat(entity.PCT02) %></td>
			</tr>
		<%} %>
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
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.F.FCOMMON.0002'/></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>


