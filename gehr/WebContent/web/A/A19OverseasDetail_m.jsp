<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 해외경험                                                    */
/*   Program Name : 해외경험 조회                                               */
/*   Program ID   : A19OverseasDetail_m.jsp                                     */
/*   Description  : 해외경험 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-10  윤정현                                          */
/*                  013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    String E_RETURN  = (String)request.getAttribute("E_RETURN" ) ;
    String E_MESSAGE = (String)request.getAttribute("E_MESSAGE") ;
    Vector a19OverseasData_vt = (Vector)request.getAttribute("a19OverseasData_vt");
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A19OverseasCareerSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
//-->
</SCRIPT>


<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

<!-- 2013-08-21 [CSR ID:2389767] [정보보안] 화면캡쳐방지  -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>해외경험</h1></div>

    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->

<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

    <!--해외경험 리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>기간</th>
                    <th>활동분야</th>
                    <th>지역</th>
                    <th>단체</th>
                    <th>경유지1</th>
                    <th>경유지2</th>
                    <th>소요비용</th>
                    <th class="lastCol">특기사항</th>
                </tr>
                <%
    if( !E_RETURN.equals("E") ) {
        for ( int i = 0 ; i < a19OverseasData_vt.size() ; i++ ) {
            A19OverseasCareerData data = (A19OverseasCareerData)a19OverseasData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td> <%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>~<%= data.ENDDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.ENDDA) %> </td>
                    <td><%= data.RESN_TEXT %></td>
                    <td><%= data.DEST_ZONE %></td>
                    <td><%= data.CRCL_UNIT %></td>
                    <td><%= data.WAY1_ZONE %></td>
                    <td><%= data.WAY2_ZONE %></td>
                    <td><%= WebUtil.printNumFormat(data.EDUC_WONX).equals("0") ? "" : WebUtil.printNumFormat(Double.parseDouble(data.EDUC_WONX) * 100) %></td>
                    <td class="lastCol"><%= data.RESN_DESC1 %><br> <%= data.RESN_DESC2 %></td>
                </tr>
<%
        }
    } else {
%>
                <tr class="oddRow">
                    <td class="lastCol" colspan="8"><%= E_MESSAGE == null ? "" : E_MESSAGE %></td>
                </tr>
<%
    }
%>
            </table>
        </div>
    </div>
    <!--해외경험 리스트 테이블 끝-->

  </div>
<%
}
%>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
</body>
</html>
