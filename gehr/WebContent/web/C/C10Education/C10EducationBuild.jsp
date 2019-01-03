<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>

<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>
<%@ page import="hris.C.C10Education.*" %>
<%@ page import="hris.C.C10Education.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector      c10EventListData_vt = (Vector)request.getAttribute("c10EventListData_vt");
    Vector      c10Inform01_vt      = (Vector)request.getAttribute("c10Inform01_vt");
    C10EducationInformData dataInfo = (C10EducationInformData)c10Inform01_vt.get(0);

    String i_objid_L = (String)request.getAttribute("i_objid_L");
    String i_objid_D = (String)request.getAttribute("i_objid_D");
    String idx_Radio = (String)request.getAttribute("idx_Radio");         // 과정 목록에서 선택된 래디오 버튼
    String paging    = (String)request.getAttribute("page");              // 과정 목록에서 선택된 page
    String CNT_REM   = (String)request.getAttribute("CNT_REM");           // 잔여강좌 count

//  결제정보를 vector로 받는다
    Vector      AppLineData_vt      = (Vector)request.getAttribute("AppLineData_vt");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess4.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function doSubmit() {
//접수중 상태이면 [document.form1.CHECK.value == "Y"]임.
  if( document.form1.CHECK.value == "Y" ) {
//  신청하려는 교육과 기간이 중복되는 교육이 있는지를 체크한다.
    if( document.form3.checkFlag.value == 'N' ) {
      if( confirm("다른 비즈니스이벤트에 대해 이미 예약이 되었습니다. 계속 신청하시겠습니까?") ) {
        buttonDisabled();
            document.form1.jobid.value = "create";
            document.form1.action      = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationBuildSV";
            document.form1.method      = "post";
            document.form1.submit();
      }
    } else {
      buttonDisabled();
        document.form1.jobid.value = "create";
        document.form1.action      = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationBuildSV";
        document.form1.method      = "post";
        document.form1.submit();
    }
  } else {
//  신청기간이 없는 차수의 상태는 [접수전, 실시중, 종료]임. - 에러 메시지를 다르게 보여주도록 한다.
    if( document.form1.SDATE.value == "0000-00-00" ) {
      alert("신청이 불가능합니다. 교육담당자에게 문의 바랍니다.");
    } else {
      alert("접수중 상태에서만 신청 가능합니다.");
    }
  }
}

// 앞화면
function do_preview(){
    document.form1.action        = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationCourseListSV";
    document.form1.target        = "menuContentIframe";
    document.form1.submit();
}

// 신청하려는 교육과 기간이 중복되는 교육이 있는지를 체크한다.
function checkFlag() {
  setEventInfo();

  if( document.form1.CHECK.value == "Y" ) {
    document.form3.i_empNo.value = "<%= user.empNo %>";
    document.form3.i_begda.value = document.form1.BEGDA.value;
    document.form3.i_endda.value = document.form1.ENDDA.value;
    document.form3.i_chaid.value = document.form1.CHAID.value;
    document.form3.action        = "<%= WebUtil.JspPath %>C/C10Education/C10EducationHidden.jsp";
    document.form3.target        = "hidden";
    document.form3.submit();
    }
}

// 현재 선택된 차수의 정보를 setting한다.
function setEventInfo() {
  var command = "";
  var size = "";

  if( isNaN( document.form1.radiobutton.length ) ){
    size = 1;
  } else {
    size = document.form1.radiobutton.length;
  }
  for (var i = 0; i < size ; i++) {
      if ( size == 1 ){
          command = 0;
      } else if ( document.form1.radiobutton[i].checked == true ) {
          command = document.form1.radiobutton[i].value;
      }
  }

  eval("document.form1.CHASU.value  = document.form1.CHASU"+command+".value");
  eval("document.form1.CHAID.value  = document.form1.CHAID"+command+".value");
  eval("document.form1.BEGDA.value  = document.form1.BEGDA"+command+".value");
  eval("document.form1.ENDDA.value  = document.form1.ENDDA"+command+".value");
  eval("document.form1.SDATE.value  = document.form1.SDATE"+command+".value");
  eval("document.form1.EDATE.value  = document.form1.EDATE"+command+".value");
  eval("document.form1.LOCATE.value = document.form1.LOCATE"+command+".value");
  eval("document.form1.IKOST.value  = document.form1.IKOST"+command+".value");
  eval("document.form1.DELET.value  = document.form1.DELET"+command+".value");
  eval("document.form1.CHECK.value  = document.form1.CHECK"+command+".value");
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:checkFlag();MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">

<div class="subWrapper">

    <div class="title"><h1>교육과정 신청</h1></div>

    <h2 class="subtitle">교육과정 상세 정보</h2>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>교육분야</th>
                    <td><%= dataInfo.ZGROUP %></td>
                    <th class="th02">과정명</th>
                    <td><%= dataInfo.GWAJUNG %></td>
                </tr>
                <tr>
                    <th>주관팀</th>
                    <td><%= dataInfo.BUSEO %></td>
                    <th class="th02">담당자</th>
                    <td><%= dataInfo.ENAME %></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle"> 교육과정 List</h2>

    <!-- 상단 입력 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>선택</th>
                    <th>교육기간</th>
                    <th>신청기간</th>
                    <th>교육장소</th>
                    <th>교육비용</th>
                    <th class="lastCol">상태</th>
                </tr>
<%
    String chk_Build = "", chk_Build_button = "";
    for( int i = 0 ; i < c10EventListData_vt.size() ; i++ ) {
        C10EducationEventListData data = (C10EducationEventListData)c10EventListData_vt.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }

        chk_Build = (data.DELET.equals("X") ? "N" : (data.STATE.equals("접수중") ? "Y" : "N"));
        if( chk_Build.equals("Y") ) {
            chk_Build_button = "Y";
        }
%>
                <tr class="<%=tr_class%>">
                    <td>
                        <input type="radio" name="radiobutton" value="<%= i %>" onClick="javascript:checkFlag();" <%= (i==0) ? "checked" : "" %>>
                    </td>
                    <td><%= WebUtil.printDate(data.BEGDA, ".").equals("0000.00.00") && WebUtil.printDate(data.ENDDA, ".").equals("0000.00.00") ? "" : WebUtil.printDate(data.BEGDA, ".") + "~" + WebUtil.printDate(data.ENDDA, ".") %></td>
                    <td><%= WebUtil.printDate(data.SDATE, ".").equals("0000.00.00") && WebUtil.printDate(data.EDATE, ".").equals("0000.00.00") ? "" : WebUtil.printDate(data.SDATE, ".") + "~" + WebUtil.printDate(data.EDATE, ".") %></td>
                    <td><%= data.LOCATE %></td>
                    <td class="align_right"><%= WebUtil.printNumFormat(data.IKOST) %></td>
                    <td class="lastCol"><%= data.DELET.equals("X") ? "취소" : (data.STATE.equals("접수중") ? "<font color=blue>-</font>" : data.STATE) %></td>
                </tr>
                    <input type="hidden" name="CHASU<%= i %>"   value="<%= data.STEXT %>">
                    <input type="hidden" name="CHAID<%= i %>"   value="<%= data.OBJID %>">
                    <input type="hidden" name="BEGDA<%= i %>"   value="<%= data.BEGDA %>">
                    <input type="hidden" name="ENDDA<%= i %>"   value="<%= data.ENDDA %>">
                    <input type="hidden" name="SDATE<%= i %>"   value="<%= data.SDATE %>">
                    <input type="hidden" name="EDATE<%= i %>"   value="<%= data.EDATE %>">
                    <input type="hidden" name="LOCATE<%= i %>"  value="<%= data.LOCATE %>">
                    <input type="hidden" name="IKOST<%= i %>"   value="<%= data.IKOST %>">
                    <input type="hidden" name="DELET<%= i %>"   value="<%= data.DELET %>">
                    <input type="hidden" name="CHECK<%= i %>"   value="<%= chk_Build %>">
<%
    }
%>
            </table>
            <span class="commentOne"><span class="textPink">*</span> 는 필수 입력사항입니다.</span>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,user.empNo) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
<%
    if( chk_Build_button.equals("Y") ) {
%>
            <li id="sc_button"><a href="javascript:doSubmit();"><span>신청</span></a></li>
<%
    }
%>
            <li><a href="javascript:do_preview();"><span>목록</span></a></li>
        </ul>
    </div>

    <!--------hidden Field ----------------->
    <input type="hidden" name="jobid"     value="">
    <input type="hidden" name="OBJID_L"   value="<%= i_objid_L %>">
    <input type="hidden" name="OBJID_D"   value="<%= i_objid_D %>">
    <input type="hidden" name="page"      value="<%= paging %>">
    <input type="hidden" name="idx_Radio" value="<%= idx_Radio %>">
    <!--교육과정정보 --->
    <input type="hidden" name="GWAJUNG"   value="<%= dataInfo.GWAJUNG %>">
    <input type="hidden" name="GWAID"     value="<%= dataInfo.GWAID   %>">
    <input type="hidden" name="BUSEO"     value="<%= dataInfo.BUSEO %>"  >
    <!--교육차수정보 --->
    <input type="hidden" name="CHASU"     value="">
    <input type="hidden" name="CHAID"     value="">
    <input type="hidden" name="BEGDA"     value="">
    <input type="hidden" name="ENDDA"     value="">
    <input type="hidden" name="SDATE"     value="">
    <input type="hidden" name="EDATE"     value="">
    <input type="hidden" name="LOCATE"    value="">
    <input type="hidden" name="IKOST"     value="">
    <input type="hidden" name="DELET"     value="">
    <input type="hidden" name="CHECK"     value="">
  </form>
<!-- hidden 호출 -->
  <form name="form3" method="post" action="">
    <input type="hidden" name="i_empNo"   value="">
    <input type="hidden" name="i_begda"   value="">
    <input type="hidden" name="i_endda"   value="">
    <input type="hidden" name="i_chaid"   value="">
    <input type="hidden" name="checkFlag" value="">
  </form>
</div>

<%@ include file="/web/common/commonEnd.jsp" %>


