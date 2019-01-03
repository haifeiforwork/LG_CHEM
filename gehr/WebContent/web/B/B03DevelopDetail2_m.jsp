<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인재개발 협의결과 조회                                      */
/*   Program Name : 인재개발 협의결과 조회                                      */
/*   Program ID   : B01ValuateDetail2_m.jsp                                     */
/*   Description  : 인재개발 협의결과 - 경력/교육개발                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2002-01-29  이형석                                          */
/*   Update       : 2003-06-23  최영호                                          */
/*                  2005-01-11  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector B03DevelopDetail2_vt = (Vector)request.getAttribute("B03DevelopDetail2_vt");
    String begDa                = (String)request.getAttribute("begDa");
%>


<SCRIPT LANGUAGE="JavaScript">
<!--
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.B.B03DevelopListSV_m";
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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>icon_Darrow_next_o.gif','<%= WebUtil.ImageURL %>icon_arrow_next_o.gif','<%= WebUtil.ImageURL %>icon_Darrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_prev_o.gif')">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>인재개발 협의결과 - 경력/교육개발</h1></div>

    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->

<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

    <!--리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>구분</th>
                    <th>년도</th>
                    <th>시기</th>
                    <th>직무/교육명</th>
                    <th>상태</th>
                    <th class="lastCol">비고</th>
                </tr>
                <%
    if( B03DevelopDetail2_vt.size() > 0 ) {
        for ( int i = 0 ; i < B03DevelopDetail2_vt.size() ; i++ ) {
            B03DevelopData2 developDetailData = (B03DevelopData2)B03DevelopDetail2_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td> <% if(developDetailData.DEVP_TYPE.equals("01")){ %>
                    경력
                    <% } %> <% if(developDetailData.DEVP_TYPE.equals("02")){ %>
                    교육
                    <% } %> </td>
                  <td><%= developDetailData.DEVP_YEAR %></td>
                  <td> <% if(developDetailData.DEVP_MNTH.equals("01")){ %>
                    상반기
                    <% } %> <% if(developDetailData.DEVP_MNTH.equals("02")){ %>
                    하반기
                    <% } %> <% if(developDetailData.DEVP_MNTH.equals("03")){ %>
                    1/4분기
                    <% } %> <% if(developDetailData.DEVP_MNTH.equals("04")){ %>
                    2/4분기
                    <% } %> <% if(developDetailData.DEVP_MNTH.equals("05")){ %>
                    3/4분기
                    <% } %> <% if(developDetailData.DEVP_MNTH.equals("06")){ %>
                    4/4분기
                    <% } %> </td>
                  <td><%= developDetailData.DEVP_TEXT %></td>
                  <td > <% if(developDetailData.DEVP_STAT.equals("01")){ %>
                    계획
                    <% } %> <% if(developDetailData.DEVP_STAT.equals("02")){ %>
                    현재
                    <% } %> <% if(developDetailData.DEVP_STAT.equals("03")){ %>
                    완료
                    <% } %> </td>
                  <td class="lastCol"><%= developDetailData.RMRK_TEXT %></td>
                </tr>
                <%
        }
    } else {
%>
                <tr class="oddRow">
                    <td class="lastCol" colspan="6">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
                <%
    }
%>
            </table>
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back();"><span>이전화면</span></a></li>
        </ul>
    </div>

  </div>
<%
}
%>
  <input type="hidden" name="jobid2" value="">
</form>
<form name="form2">
    <input type="hidden" name="jobid2" value="">
    <input type="hidden" name="begDa" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
</body>
</html>
