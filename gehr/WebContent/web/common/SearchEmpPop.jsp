<%/******************************************************************************/
/*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%
    boolean isFirst = true;
    Vector PersInfoData_vt = null;

    String jobid = request.getParameter("jobid");
    String ename = request.getParameter("I_ENAME");
    String index = request.getParameter("index");
    String objid = request.getParameter("objid");
    if( jobid != null && jobid.equals("search") ) {
        if ( ename == null ) {
            ename = "";
        }
        try{
            PersInfoData_vt = ( new PersInfoWithNameRFC() ).getApproval(ename, objid,"");
        }catch(Exception ex){
            PersInfoData_vt = null;
        }

        isFirst = false;
    }

    String winTitle = g.getMessage("LABEL.COMMON.0040");
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--
function init(){
    document.form1.I_ENAME.focus();
}

function pers_search() {
  val = document.form1.I_ENAME.value;
  val = rtrim(ltrim(val));
  if ( val == "" ) {
	  alert("<spring:message code='MSG.COMMON.0080' />");
    document.form1.I_ENAME.focus();
    return;
  } else {
    document.form1.jobid.value = "search";
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchEmpPop.jsp";
    document.form1.target = "essSearch";
    document.form1.submit();
  }

}

function EnterCheck(){
	if (event.keyCode == 13)  {
		pers_search();
	}
}

function changeAppData(index, PERNR, ENAME, ORGTX, TITEL, TITL2, TELNUMBER){
    opener.get_EmpData(index, PERNR, ENAME, ORGTX, TITEL, TITL2, TELNUMBER);
    self.close();
}

//document.onkeydown = pers_search();
//-->
</SCRIPT>

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init()">
<table width="480" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td> <br>
      <table width="460" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="font01"><img src="<%= WebUtil.ImageURL %>icon_3spot.gif" width="10" height="15" align="absmiddle">
            <%= winTitle %> <spring:message code="LABEL.COMMON.0014"/><!-- 선택 --></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="460" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <form name="form1" method="post" onsubmit="return false">

                  <td width="247">
                    <table width="247" border="0" cellspacing="1" cellpadding="2" class="table01">
                      <tr>
                        <td class="td03" width="139"><%= winTitle %></td>
                        <td class="td03" width="221">
                          <input type="text" name="I_ENAME" size="15" class="input03" value="<%= ( ename == null || ename.equals("") ) ? "" : ename %>"  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" onsubmit="return false" >
                           <input type="hidden" name="jobid"   value="">
                           <input type="hidden" name="index"   value="<%= index %>">
                           <input type="hidden" name="objid"   value="<%= objid %>">
                           <input type="hidden" name="x_title" value="<%= winTitle %>">
                        </td>
                        <td class="td03" width="60">
                          <a href="javascript:pers_search();" ><img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" border="0"></a>
                        </td>
                      </tr>
                    </table>
                  </td>
                </form>
                <td align="right" valign="bottom"><a href="javascript:self.close()">
                <img src="<%= WebUtil.ImageURL %>btn_close.gif" width="49" height="20" border="0"></a></td>
              </tr>
            </table>
          </td>
        </tr>
<%
   if( !isFirst ){
%>
        <tr>
          <td background="<%= WebUtil.ImageURL %>bg_pixel.gif">&nbsp;</td>
        </tr>
<%
      if( PersInfoData_vt != null && PersInfoData_vt.size() > 0 ){
%>

        <tr>
          <td>
            <table width="460" border="0" cellspacing="1" cellpadding="2" class="table01">
              <tr>
                <td class="td03" width="40"><spring:message code="LABEL.APPROVAL.0003"/><!-- 선 택 --></td>
                <td class="td03" width="80"><spring:message code="LABEL.APPROVAL.0004"/><!-- 사 번 --></td>
                <td class="td03" width="80"><spring:message code="LABEL.APPROVAL.0005"/><!-- 성 명 --></td>
                <td class="td03" width="150"><spring:message code="LABEL.SEARCH.ORGEH.NAME"/><!-- 부서명 --></td>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<td class="td03" width="40"><spring:message code="LABEL.APPROVAL.0006"/><!-- 직위명 --></td> --%>
                <td class="td03" width="40"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                <td class="td03" width="40"><spring:message code="LABEL.APPROVAL.0007"/><!-- 직책명 --></td>
              </tr>
              <form name="form2" method="post">

<%
            for( int i = 0 ; i < PersInfoData_vt.size() ; i++ ) {
               PersInfoData persInfoData = (PersInfoData)PersInfoData_vt.get(i);
%>
                <tr align="center">
                  <td class="td02" width="40"><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= index %>', '<%= persInfoData.PERNR %>', '<%= persInfoData.ENAME %>', '<%= persInfoData.ORGTX %>', '<%= persInfoData.TITEL %>', '<%= persInfoData.TITL2 %>', '<%= persInfoData.TELNUMBER %>');"></td>
                  <td class="td02" width="80"><%=WebUtil.printString( persInfoData.PERNR )%></td>
                  <td class="td02" width="80"><%=WebUtil.printString( persInfoData.ENAME )%></td>
                  <td class="td02" width="150"><%=WebUtil.printString( persInfoData.ORGTX )%></td>
                  <td class="td02" width="40"><%=WebUtil.printString( persInfoData.TITEL )%></td>
                  <td class="td02" width="40"><%=WebUtil.printString( persInfoData.TITL2 )%></td>
                </tr>
<%
            }
%>

              </form>
            </table>
<%
        } else {

%>
             <td class="td02" align="center"><spring:message code="LABEL.APPROVAL.0008"/><!-- 해당하는 데이타가 없습니다. --></td>
<%
        }
%>
        </tr>
        <tr>
          <td background="<%= WebUtil.ImageURL %>bg_pixel.gif">&nbsp;</td>
        </tr>
        <tr>
          <td align="right"><a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>btn_close.gif" width="49" height="20" border="0"></a></td>
        </tr>
<%
    }
%>
      </table>
    </td>
  </tr>
</table>
<%@ include file="commonEnd.jsp" %>
