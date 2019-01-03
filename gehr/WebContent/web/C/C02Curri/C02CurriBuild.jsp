<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 신청                                               */
/*   Program ID   : C02CurriBuild.jsp                                           */
/*   Description  : 교육 신청을 할수 있도록 하는 화면                           */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  박영락                                          */
/*   Update       : 2005-02-22  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    String UPMU_TYPE = "08";
    WebUserData user = WebUtil.getSessionUser(request);

    C02CurriInfoData infoData     = (C02CurriInfoData)request.getAttribute("C02CurriInfoData");
    Vector C02CurriPersonData_vt  = (Vector)request.getAttribute( "C02CurriPersonData_vt" );
    C02CurriPersonData personData = (C02CurriPersonData)C02CurriPersonData_vt.get(0);

//  신청하려는 교육과 기간이 중복되는 교육이 있는지를 체크한다.
    String             checkFlag  = (String)request.getAttribute( "checkFlag" );
//  신청하려는 교육과 기간이 중복되는 교육이 있는지를 체크한다.

    //////////////////////////////////////////
    C02CurriInfoData key            = (C02CurriInfoData)request.getAttribute("C02CurriInfoKey");
    //////////////////////////////////////////
    String PERNR         =  (String)request.getAttribute("PERNR");
    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function doSubmit() {
//신청하려는 교육과 기간이 중복되는 교육이 있는지를 체크한다.
  if( '<%= checkFlag %>' == 'N' ) {
    if( confirm("다른 비즈니스이벤트에 대해 이미 예약이 되었습니다. 계속 신청하시겠습니까?") ) {
        if( check_data() ) {
            document.form1.jobid.value = "create";
            document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriBuildSV";
            document.form1.method = "post";
            document.form1.submit();
      <% if("EPortlet".equals(user.loginPlace)) { %>
        alert("신청되었습니다!");
        self.close();
      <% } %>
      }//TEXT길이제한로직필요
    }
  } else {
    if( check_data() ) {
        document.form1.jobid.value = "create";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriBuildSV";
        document.form1.method = "post";
        document.form1.submit();
    <% if("EPortlet".equals(user.loginPlace)) { %>
      alert("신청되었습니다!");
      self.close();
    <% } %>
    }//TEXT길이제한로직필요
  }
}

function check_data(){
  if ( check_empNo() ){
    return false;
  }
  str = document.form1.TEXT.value;
  if( str.length > 100 ){
    str = str.substring(0,100);
    document.form1.TEXT.value = str;
  }

  return true;
}

function goBack(){
    document.form1.jobid.value = "goBack";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriInfoListSV";
    document.form1.method = "post";
    document.form1.submit();
}

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>교육과정 신청</h1></div>

<%
    // EP portlet으로부터 신청시 제외. 2005.9.27 mkbae.
    if ("Y".equals(user.e_representative) && !"EPortlet".equals(user.loginPlace)) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->

<%
    }
%>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>과정명</th>
                    <td><%= infoData.GWAJUNG %></td>
                    <th class="th02">교육기간</th>
                    <td><%= WebUtil.printDate(infoData.BEGDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(infoData.BEGDA,".") + "~" %><%= WebUtil.printDate(infoData.ENDDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(infoData.ENDDA,".") %></td>
                </tr>
                <tr>
                    <th>신청차수</th>
                    <td><%= infoData.CHASU %></td>
                    <th class="th02">차수ID</th>
                    <td><%= infoData.CHAID %></td>
                </tr>
                <tr>
                    <th>사번</th>
                    <td><%= personData.PERNR %></td>
                    <th class="th02">성명</td>
                    <td><%= personData.ENAME %></td>
                </tr>
                <tr>
                    <th>소속</th>
                    <td><%= personData.ORGTX %></td>
                    <th class="th02">직위</th>
                    <td><%= personData.TITEL %></td>
                </tr>
                <tr>
                    <th>급호/년차</th>
                    <td colspan="3"><%= personData.TRFGR %><%= (personData.TRFST).equals("") ? "" : "-"+personData.TRFST %><%= (personData.VGLST).equals("") ? "" : "/"+personData.VGLST %>년차</td>
                </tr>
                <tr>
                    <th>신청사유</th>
                    <td colspan="3"> <textarea name="TEXT" cols="60" wrap="VIRTUAL" rows="5"></textarea></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppBuild( PERNR, UPMU_TYPE ) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:doSubmit();" ><span>저장</span></a></li>
            <li><a href="javascript:history.back()"><span>과정내용</span></a></li>
<%  if( user.e_learning.equals("") ){ %>
            <li><a href="javascript:goBack()"><span>목록</span></a></li>
<%  } else { %>
            <li><a href="<%=RequestPageName%>"><span>목록</span></a></li>
<%  } %>
        </ul>
    </div>

          <!--------hidden Field ----------------->
          <input type="hidden" name="jobid"   value="">
          <!--교육정보 --->
          <input type="hidden" name="GWAJUNG" value="<%= infoData.GWAJUNG %>">
          <input type="hidden" name="GWAID"   value="<%= infoData.GWAID %>"  >
          <input type="hidden" name="CHASU"   value="<%= infoData.CHASU %>"  >
          <input type="hidden" name="CHAID"   value="<%= infoData.CHAID %>"  >
          <input type="hidden" name="SHORT"   value="<%= infoData.SHORT %>"  >
          <input type="hidden" name="BEGDA"   value="<%= DataUtil.removeStructur(infoData.BEGDA, "-") %>"  >
          <input type="hidden" name="ENDDA"   value="<%= DataUtil.removeStructur(infoData.ENDDA, "-") %>"  >
          <input type="hidden" name="EXTRN"   value="<%= infoData.EXTRN %>"  >
          <input type="hidden" name="KAPZ2"   value="<%= infoData.KAPZ2 %>"  >
          <input type="hidden" name="RESRV"   value="<%= infoData.RESRV %>"  >
          <input type="hidden" name="LOCATE"  value="<%= infoData.LOCATE %>" >
          <input type="hidden" name="BUSEO"   value="<%= infoData.BUSEO %>"  >
          <input type="hidden" name="SDATE"   value="<%= DataUtil.removeStructur(infoData.SDATE, "-") %>"  >
          <input type="hidden" name="EDATE"   value="<%= DataUtil.removeStructur(infoData.EDATE, "-") %>"  >
          <input type="hidden" name="DELET"   value="<%= infoData.DELET %>"  >
          <input type="hidden" name="PELSU"   value="<%= infoData.PELSU %>"  >
          <input type="hidden" name="GIGWAN"  value="<%= infoData.GIGWAN %>" >
          <input type="hidden" name="IKOST"   value="<%= infoData.IKOST %>"  >
          <!--개인정보-->
          <input type="hidden" name="PERNR"   value="<%= personData.PERNR %>"  >
          <input type="hidden" name="ENAME"   value="<%= personData.ENAME %>"  >
          <input type="hidden" name="ORGTX"   value="<%= personData.ORGTX %>"  >
          <input type="hidden" name="TITEL"   value="<%= personData.TITEL %>"  >
          <input type="hidden" name="TRFGR"   value="<%= personData.TRFGR %>" >
          <input type="hidden" name="TRFST"   value="<%= personData.TRFST %>"  >
          <input type="hidden" name="VGLST"   value="<%= personData.VGLST %>"  >
          <input type="hidden" name="page"          value="">
          <input type="hidden" name="I_FDATE"       value="<%= key.I_FDATE %>">
          <input type="hidden" name="I_TDATE"       value="<%= key.I_TDATE %>">
          <input type="hidden" name="I_BUSEO"       value="<%= key.I_BUSEO %>">
          <input type="hidden" name="I_GROUP"       value="<%= key.I_GROUP %>">
          <input type="hidden" name="I_LOCATE"      value="<%= key.I_LOCATE %>">
          <input type="hidden" name="I_DESCRIPTION" value="<%= key.I_DESCRIPTION %>">

</div>
<input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">

</form>

<%@ include file="/web/common/commonEnd.jsp" %>


