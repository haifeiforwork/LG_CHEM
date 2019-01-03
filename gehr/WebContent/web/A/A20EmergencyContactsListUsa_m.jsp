<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Employee Data                                                  																*/
/*   2Depth Name  	: Personal Data    																											*/
/*   Program Name 	: Emergency Contacts                                               														*/
/*   Program ID   		: A20EmergencyContactsListUsa.jsp                                             										*/
/*   Description  		: 비상연락망 정보를 조회 하는 화면 [USA]                          														*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-09-30 jungin @v1.0                                          														*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="emergency" tagdir="/WEB-INF/tags/A/A20EmergencyContract" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    WebUserData user = (WebUserData)session.getAttribute("user");
	WebUserData user_m = (WebUserData)session.getAttribute("user_m");

    Vector a20EmergencyContactsData_vt = (Vector)request.getAttribute("a20EmergencyContactsData_vt");
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A20EmergencyContactsListSV_m";
    document.form1.method = "post";
    document.form1.target = "main_ess";
    document.form1.submit();
}
//-->
</SCRIPT>

<html>
<head>
<title>MSS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<link href="../images/css/ehr.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif"><spring:message code='MSG.A.A20.0009' /><!-- Emergency Contacts --></td>
                  <td align="right"><a href="javascript:open_help('X03PersonInfoUsa.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"><img name="Image6" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="Guide"></a></td>
                </tr>
                <tr>
                  <td height="3" align="left" valign="top" background="/web/images/maintitle_line.gif"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                  <td height="3" align="left" valign="top" background="/web/images/maintitle_line.gif"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
                <tr>
                  <td height="10">&nbsp;&nbsp;</td>
                  <td height="10">&nbsp;&nbsp;</td>
                </tr>
              </table></td>
          </tr>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="../common/SearchDeptPersons_m.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <%
				// 사원 검색한 사람이 없을때
				if (user_m != null) {
		  %>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
        </table>
        <table width="100%" height="20" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td>
              <!--경력사항 리스트 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="4" class="table02">
                <tr>
                  <td class="td03" width="30"><spring:message code='MSG.A.A20.0003' /><!-- Relationship --></td>
                  <td class="td03" width="250"><spring:message code='MSG.A.A20.0008' /><!-- Rel. Name --></td>
                  <td class="td03" width="250"><spring:message code='MSG.A.A20.0006' /><!-- Emerg. Ph#1 --></td>
                  <td class="td03" width="250"><spring:message code='MSG.A.A20.0007' /><!-- Emerg. Ph#2 --></td>
                </tr>
                <%
					if (a20EmergencyContactsData_vt.size() > 0) {
				    	for (int i = 0 ; i < a20EmergencyContactsData_vt.size() ; i++) {
				    		A20EmergencyContactsData data = (A20EmergencyContactsData)a20EmergencyContactsData_vt.get(i);
				%>
                <tr>
                  <td class="td04"><%= data.RLSHPTX == null ? "" : data.RLSHPTX %></td>
                  <td class="td04"><%= data.RLNAME == null ? "" : data.RLNAME %></td>
                  <td class="td04"><%= data.EMGPH1 == null ? "" : WebUtil.insertStr(data.EMGPH1, "-", "3-3-4") %></td>
                  <td class="td04"><%= data.EMGPH2 == null ? "" : WebUtil.insertStr(data.EMGPH2, "-", "3-3-4") %></td>
                 </tr>
				<%
				    	}
					} else {
				%>
				<tr><td colspan="5" class="td04"><spring:message code='MSG.A.A20.0011' /><!-- No Data --></td></tr>
				<%
					}
				%>
              </table>
              <!--경력사항 리스트 테이블 끝-->
            </td>
          </tr>
          <tr>
            <td height="30">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
  </table>
	<%
		}
	%>
</form>
<%@ include file="../common/commonEnd.jsp" %>
</body>
</html>
