<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 자격면허                                                    */
/*   Program Name : 자격면허                                                    */
/*   Program ID   : A18LicenseDetail.jsp                                        */
/*   Description  : 자격면허 조회                                               */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-28  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    // 첫 화면에 리스트되는 데이터들..
    Vector  A08LicenseDetailData_vt = (Vector)request.getAttribute("A08LicenseDetail_vt");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}

MM_reloadPage(true);

function view_detail(idx) {
    var licn_code = eval("document.form1.LICN_CODE" + idx + ".value");
    flag      = eval("document.form1.FLAG"      + idx + ".value");

    if( flag == "X" ) {    // 자격수당이 있는 경우..
        window.open('', 'essPopup', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=532,height=330");

        document.form1.jobid.value     = "pop";
        document.form1.licn_code.value = licn_code;

        document.form1.target = "essPopup";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A08LicenseDetailSV';
        document.form1.method = "post";
        document.form1.submit();
    }
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
<form name="form1" method="post">
<div class="subwrapper">
  <div class="title"><h1>자격면허 조회</h1></div>

  <h2 class="subtitle">자격면허</h2>

  <!--자격면허 테이블 시작-->
  <div class="listArea">
    <div class="table">
      <table class="listTable">
        <tr>
          <th>자격면허</th>
          <th>취득일</th>
          <th>등급</th>
          <th>발행기관</th>
          <th class="lastCol">법정선임사유</th>
        </tr>
<%
    if( A08LicenseDetailData_vt.size() > 0 ) {
          for ( int i = 0 ; i < A08LicenseDetailData_vt.size() ; i++ ) {
            A08LicenseDetailData data = (A08LicenseDetailData)A08LicenseDetailData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
        <tr class="<%=tr_class%>">
<%
            if( data.FLAG.equals("X") ) {
%>

          <td><a href="javascript:view_detail(<%=i%>)"><font color="#006699"><%= data.LICN_NAME %></font></a></td>
<%
            } else {
%>
          <td><%= data.LICN_NAME %></td>
<%
            }
%>
          <td><%= data.OBN_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.OBN_DATE) %></td>
          <td><%= data.GRAD_NAME %></td>
          <td><%= data.PUBL_ORGH %></td>
          <td class="lastCol"><%= data.ESTA_AREA %></td>
          <input type="hidden" name="LICN_CODE<%= i %>" value="<%= data.LICN_CODE %>">
          <input type="hidden" name="FLAG<%= i %>"      value="<%= data.FLAG %>">
        </tr>
<%
        }
    } else {
%>
        <tr align="center">
          <td class="lastCol" colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
        </tr>
<%
    }
%>
      </table>
    </div>
  </div>
  <!--자격면허 테이블 끝-->
</div>
  <input type="hidden" name="jobid"     value="">
  <input type="hidden" name="licn_code" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
