<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 경력사항                                                    */
/*   Program Name : 경력사항 조회                                               */
/*   Program ID   : A09CareerDetail_m.jsp                                       */
/*   Description  : 경력사항 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2001-12-19  김도신                                          */
/*   Update       : 2005-01-07  윤정현                                          */
/*                  013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */ 
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
 
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);
    Vector a09CareerDetailData_vt = (Vector)request.getAttribute("a09CareerDetailData_vt");
    
//  2015- 06-08 개인정보 통합시 subView ="Y";
	String subView = WebUtil.nvl(request.getParameter("subView"));
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A09CareerDetailSV_m";
    document.form1.method = "post";
    document.form1.target = "main_ess";
    document.form1.submit();
}
//-->
</SCRIPT>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

<!-- 2013-08-21 [CSR ID:2389767] [정보보안] 화면캡쳐방지  -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="1">&nbsp;</td>
      <td>
      
      <table width="780" border="0" cellspacing="0" cellpadding="0">
      <%
	if(!subView.equals("Y")){
%>  
          <tr> 
            <td>
            <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td height="5" colspan="2"></td>
                </tr>
                <tr> 
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">경력사항</td>
                  <td class="titleRight"><a href="javascript:open_help('X03PersonInfo.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a></td>
                </tr>
              </table></td>
          </tr>
          <!--   사원검색 보여주는 부분 시작   -->
          
          <!--   사원검색 보여주는 부분  끝    -->
          <%}
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
        </table>
        <table width="780" height="20" border="0" cellpadding="0" cellspacing="0">
          <tr> 
            <td> 
              <!--경력사항 리스트 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="4" class="table02">
                <tr> 
                  <td width="150" class="td03">근무기간</td>
                  <td width="200" class="td03">근무처</td>
                  <td width="100" class="td03">직위</td>
                  <td class="td03">직무</td>
                </tr>
                <%
    if( a09CareerDetailData_vt.size() > 0 ) {
        for ( int i = 0 ; i < a09CareerDetailData_vt.size() ; i++ ) {
            A09CareerDetailData data = (A09CareerDetailData)a09CareerDetailData_vt.get(i);
%>
                <tr> 
                  <td class="td04"> <%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>~<%= data.ENDDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.ENDDA) %> </td>
                  <td class="td04"><%= data.ARBGB %> </td>
                  <td class="td04"><%= data.TITL_TEXT %></td>
                  <td class="td04"><%= data.JOBB_TEXT %></td>
                </tr>
                <%
        }
    } else {
%>
                <tr align="center"> 
                  <td class="td04" colspan="4">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
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
<%@ include file="/web/common/commonEnd.jsp" %>
</body>
</html>
