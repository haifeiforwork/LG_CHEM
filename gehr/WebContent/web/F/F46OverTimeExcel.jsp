<%/******************************************************************************/
/*                                                                             */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 연장근로실적정보                                            */
/*   Program ID   : F46OverTimeExcel.jsp                               */
/*   Description  : 부서별 연장근로실적정보 Excel 저장을 위한 jsp 파일                */
/*   Note         : 없음                                                        */
/*   Creation     : 2013-09-30 손혜영                                           */
/*   Update       :   2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>

<%
	String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
	String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
	F46OverTimeData searchData = (F46OverTimeData)request.getAttribute("searchData");   //대상년월
	Vector overTimeVt = (Vector)request.getAttribute("overTimeVt");
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=OverTime.xls");
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
<table width="1380" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td class="title02" colspan="11">* <!-- 연장근로실적정보 --><%=g.getMessage("LABEL.F.F46.0001")%></td>
        </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="td09" colspan="11">
            &nbsp;<%if(searchData.I_GUBUN.equals("1")){ %><!-- 월별 --><%=g.getMessage("LABEL.F.F46.0003")%><%} else{ %><!-- 주간 --><%=g.getMessage("LABEL.F.F46.0004")%><%} %>
            &nbsp; : <%if(searchData.I_GUBUN.equals("1")){ %><%=searchData.year%>.<%=searchData.month%><%} else{ %><%=WebUtil.printDate(searchData.yymmdd)%> - <%=WebUtil.printDate(DataUtil.addDays(DataUtil.delDateGubn(searchData.yymmdd),6))%><%} %>
          	&nbsp;&nbsp;&nbsp;&nbsp;
          	<%= searchData.I_OVERYN.equals("Y")  ?g.getMessage("LABEL.F.F46.0016") : "" %>
          </td>
          <td></td>
        </tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <%
 		String tempDept = "";
 		for( int i = 0; i < overTimeVt.size(); i++ ){
 			F46OverTimeData tdata = (F46OverTimeData)overTimeVt.get(i);
			//하위부서를 선택했을 경우 부서 비교.
            if( !tdata.ORGEH.equals(tempDept) ){
%>
  <tr><td height="10"></td></tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td class="td09" colspan="11">&nbsp;<!--부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=tdata.STEXT%></td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr class="td03">
          <td rowspan="2" id="td1"><!--신분--><%=g.getMessage("LABEL.F.F46.0007")%></td>
          <td width="70" rowspan="2" id="td2"><!-사번--><%=g.getMessage("LABEL.F.F41.0004")%></td>
          <td width="60" rowspan="2" id="td3"><!--성명--><%=g.getMessage("LABEL.F.F42.0003")%></td>
 	      <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    	  <%--<td width="60" rowspan="2" id="td4"><!--직위--><%=g.getMessage("LABEL.F.F41.0008")%></td> --%>
    	  <td width="60" rowspan="2" id="td4"><!-- 직위/직급호칭 --><%=g.getMessage("MSG.A.A01.0083")%></td>
           <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
          <td width="60" rowspan="2" id="td5"><!--직책--><%=g.getMessage("LABEL.F.F41.0007")%></td>
          <td width="320" colspan="4"><!--연장근로--><%=g.getMessage("LABEL.F.F46.0017")%></td>
          <td width="80" rowspan="2" id="td10"><!--휴일근로--><%=g.getMessage("LABEL.F.F46.0008")%></td>
        </tr>
        <tr  class="td03">
          <td width="80" id="td6"><!--평일연장--><%=g.getMessage("LABEL.F.F46.0010")%></td>
          <td width="80" id="td7"><!--휴일연장--><%=g.getMessage("LABEL.F.F46.0011")%></td>
          <td width="80" id="td8"><!--소계--><%=g.getMessage("LABEL.F.F46.0012")%></td>
          <td width="80" id="td9"><!--주당평균<br/>연장근로--><%=g.getMessage("LABEL.F.F46.0013")%></td>
        </tr>
<%
		for(int j=i;j<overTimeVt.size();j++){
			F46OverTimeData data = (F46OverTimeData)overTimeVt.get(j);
        	if(!data.ENAME.equals("TOTAL")){
%>
        <tr>
          <td class="td04"><%=data.PTEXT    %></td>
          <td class="td04">'<%=data.PERNR    %></td>
          <td class="td04"><%=data.ENAME    %></td>
          <td class="td04"><%=data.TITEL    %></td>
          <td class="td04"><%=data.TITL2    %></td>
          <td class="td05"><%=data.YUNJANG%></td>
          <td class="td05"><%=data.HYUNJANG     %></td>
          <td class="td05"><%=data.SUB_TOTAL    %></td>
          <td class="td05"><%=data.WEEK_AVG    %></td>
          <td class="td05"><%=data.HTKGUN     %></td>
        </tr>
<%
        	} else {
%>
		<tr>
          <td class="td04" colspan="5"><%=tdata.STEXT%><!--평균--><%=g.getMessage("LABEL.F.F46.0014")%></td>
          <td class="td05"><%=data.YUNJANG%></td>
          <td class="td05"><%=data.HYUNJANG     %></td>
          <td class="td05"><%=data.SUB_TOTAL    %></td>
          <td class="td05"><%=data.WEEK_AVG    %></td>
          <td class="td05"><%=data.HTKGUN     %></td>
        </tr>
<%
				break;
        	}

		}
%>
      </table>
    </td>
  </tr>
<%

            }//end if
			//부서코드 비교를 위한 값.
            tempDept = tdata.ORGEH;
        }//end for
%>
  <tr><td height="15"></td></tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="755" border="0" cellpadding="0" cellspacing="0" align="left">
        <tr>
          <td colspan="11" ></p><!--<p>＊주당평균 연장근로시간 = (평일연장+휴일연장시간)  / 근태일수 * 7일</p>
          		<p>＊휴일근로포함 주당평균 연장근로시간 = (평일연장+휴일연장시간 +휴일근로)  / 근태일수 * 7일</p>
          		<p>＊법정근로시간(주) : 기본근무(40hr)+연장근무(12hr)=52hr한도--><%=g.getMessage("LABEL.F.F46.0015")%>
           </td>
        </tr>
      </table>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>
</form>
</body>
</html>