<%/***************************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Unit/Contract Type
*   Program ID   		: F78JobFamilyContractTypeExcel.jsp
*   Description  		: 직군별 계약 유형 정보 Excel 저장을 위한 jsp 파일
*   Note         		: 없음
*   Creation     		:
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%
	request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");            	// 세션

    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"));            	// 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));		// 부서명

    Vector F78JobFamilyContractTypeTitle_vt = (Vector)request.getAttribute("F78JobFamilyContractTypeTitle_vt");   // 제목
    Vector F78JobFamilyContractTypeNote_vt = (Vector)request.getAttribute("F78JobFamilyContractTypeNote_vt");   // 내용

    HashMap metaTitle = (HashMap)request.getAttribute("metaTitle");

    List list = (List)request.getAttribute("metaNote");
    HashMap meta = null;
    HashMap meta1 = null;
    if (list != null) {
	    meta = (HashMap)list.get(0);
	    meta1 = (HashMap)list.get(1);
	}

    F78JobFamilyContractTypeNoteData total = new F78JobFamilyContractTypeNoteData();
    AppUtilEurp.initEntity(total,"0");
    if (F78JobFamilyContractTypeNote_vt != null && F78JobFamilyContractTypeNote_vt.size() > 0)
	    total = (F78JobFamilyContractTypeNoteData)F78JobFamilyContractTypeNote_vt.get(F78JobFamilyContractTypeNote_vt.size() - 1 );
    AppUtilEurp.nvlEntity(total);

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=JobFamily_Contract_Type.xls");
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
    if (F78JobFamilyContractTypeTitle_vt != null && F78JobFamilyContractTypeTitle_vt.size() > 0) {

        // 전체 테이블 크기 조절.
        int tableSize = 0;
%>
<table width="<%= tableSize %>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="2" class="title02">* <spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org. Unit -->/<spring:message code='LABEL.F.F79.0016'/><!-- Contract Type --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="2" class="td09">&nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org. Unit --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %></td>
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
        	<td class="td03"><spring:message code='LABEL.F.F03.0002'/><!-- Pers. Area --></td>
        	<td class="td03" width="90px" nowrap><spring:message code='LABEL.F.F04.0004'/><!-- Job Family --></td>
          	<td class="td03" width="150px" nowrap><spring:message code='LABEL.F.F00.0012'/><!-- Job --></td>
			<%
				String tmp = "";
		        // 타이틀.
		        for (int k = 0; k < F78JobFamilyContractTypeTitle_vt.size(); k++) {
		        	F78JobFamilyContractTypeTitleData titleData = (F78JobFamilyContractTypeTitleData)F78JobFamilyContractTypeTitle_vt.get(k);
		 			int cols = ((Integer)metaTitle.get(titleData.CLSFY)).intValue();
			%>
        	<td width="70" class="td03" nowrap>&nbsp;&nbsp;<%= titleData.CTTXT %>&nbsp;&nbsp;</td>
			<%
				}
			%>
        </tr>
        <%
        	String temp = "";
        	String temp1 = "";
        	for( int i = 0 ; i < F78JobFamilyContractTypeNote_vt.size() ; i ++){
        		F78JobFamilyContractTypeNoteData entity = (F78JobFamilyContractTypeNoteData)F78JobFamilyContractTypeNote_vt.get(i);
        %>
        <tr>
        	<%
        		if(!temp.equals(entity.PBTXT)){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":"td05"%>" rowspan="<%=meta.get(entity.PBTXT)%>" nowrap colspan="<%=entity.PBTXT.equals("TOTAL")?"3":"0"%>" style="text-align:<%=entity.PBTXT.equals("TOTAL")?"center":"left"%>"><%=entity.PBTXT %></td>

        	<%
        		}
        		if(!entity.PBTXT.equals("TOTAL")){
        			if(!temp1.equals(entity.JIKGT)){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" nowrap="nowrap" rowspan="<%=meta1.get(entity.PBTXT + entity.JIKGT)%>"><%=entity.JIKGT %></td>
			<%
					}
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" nowrap="nowrap"><%=entity.STELL_TEXT %></td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT01) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT01) %>
        	</td>
 			<%
 			}
 		 	if(Integer.parseInt(total.CNT02) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT02) %>
        	</td>
 			<%
 			}

          	if(Integer.parseInt(total.CNT03) > 0){
            %>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>">
        	<%=WebUtil.printNumFormat(entity.CNT03) %>
        	</td>
          <%
          	}
          	if(Integer.parseInt(total.CNT04) > 0){
          %>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>">
        	<%=WebUtil.printNumFormat(entity.CNT04) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT05) > 0 ){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>">
        	<%=WebUtil.printNumFormat(entity.CNT05)%>
        	</td>
			<%
			}
			if(Integer.parseInt(total.CNT06) > 0 ){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT06) %>
        	</td>
			<%
			}
			if(Integer.parseInt(total.CNT07) > 0){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT07) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT08) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT08) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT09) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT09) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT10) > 0 ){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT10) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT11) > 0 ){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT11) %>
        	</td>
			<%
			}
		   if(Integer.parseInt(total.CNT14) > 0){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT14) %>
        	</td>
        	<%
        	}
			if(Integer.parseInt(total.CNT12) > 0){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT12) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT13) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT13) %>
        	</td>
			<%
			}

        	if(Integer.parseInt(total.CNT15) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT15) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT16) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT16) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT17) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT17) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT18) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT18) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT19) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT19) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.CNT20) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.STELL.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.CNT20) %>
        	</td>
        	<%
        	}
        	%>
        </tr>
        <%
	      	temp = entity.PBTXT;
        	temp1 = entity.JIKGT;
        	}
        %>
        </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>

<%
    } else {
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.F.FCOMMON.0002'/></td>
  </tr>
</table>
<%
    } //end if.
%>
</form>
</body>
</html>
