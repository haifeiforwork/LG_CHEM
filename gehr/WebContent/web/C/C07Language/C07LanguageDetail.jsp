<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ page import="hris.C.C07Language.*" %>
<%@ page import="hris.C.C07Language.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
//  신청한 어학지원 정보를 받는다.
    Vector          c07LanguageData_vt = (Vector)request.getAttribute("c07LanguageData_vt");
    C07LanguageData data               =  (C07LanguageData)c07LanguageData_vt.get(0);

    /* 입력된 결제정보를 vector로 받는다 */
    Vector          AppLineData_vt     = (Vector)request.getAttribute("AppLineData_vt");

//  학습형태 TEXT를 읽어온다.
    C07StudTypeRFC func      = new C07StudTypeRFC();
    Vector         type_vt   = func.getDetail();
    String         STUD_TEXT = "";
    for( int i = 0; i < type_vt.size(); i++ ){
        CodeEntity entity = (CodeEntity)type_vt.get(i);

        if( ( data.STUD_TYPE ).equals( entity.code ) ){
            STUD_TEXT = entity.value;
            break;
        }
    }
//  학습형태 TEXT를 읽어온다.
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess4.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function do_list(){
  document.form1.jobid.value = "first";

  document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A16Appl.A16ApplListSV";
  document.form1.method = "post";
  document.form1.submit();
}

function go_change() {
  if( chk_APPR_STAT(0) ){
      document.form1.jobid.value = "";
      document.form1.action      = "<%= WebUtil.ServletURL %>hris.C.C07Language.C07LanguageChangeSV";
      document.form1.submit();
  }
}

function go_delete() {
    if( chk_APPR_STAT(1) && confirm("정말 삭제하시겠습니까?") ) {
        document.form1.jobid.value = "delete";
        document.form1.action      = "<%= WebUtil.ServletURL %>hris.C.C07Language.C07LanguageDetailSV";
        document.form1.submit();
    }
}
function f_print()
{
     self.print();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<form name="form1" method="post" action="">

<div class="subWrapper">

    <div class="title"><h1>어학지원 신청 조회</h1></div>

    <!-- 상단 검색테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>부서명</th>
                    <td><%= user.e_orgtx %></td>
                    <th class="th02">사 번</th>
                    <td><%= user.empNo %></td>
                    <th class="th02">성 명</th>
                    <td><%= user.ename %></td>
                    <td><a class="inlineBtn" href="javascript:f_print()"><span>인쇄하기</span></a></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 검색테이블 끝-->

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일자</th>
                    <td colspan="3">
                        <input type="text" name="BEGDA" value="<%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA,".") %>" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th>학습시작일</th>
                    <td>
                        <input type="text" name="SBEG_DATE" value="<%= WebUtil.printDate(data.SBEG_DATE,".") %>" size="20" readonly>
                    </td>
                    <th class="th02">학습종료일</th>
                    <td>
                        <input type="text" name="SEND_DATE" value="<%= WebUtil.printDate(data.SEND_DATE,".") %>" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th>학습형태</th>
                    <td>
                        <input type="text" name="STUD_TEXT" value="<%= STUD_TEXT %>" size="20" readonly>
                    </td>
                    <th class="th02">수강시간</th>
                    <td>
                        <input type="text" name="LECT_TIME" value="<%= WebUtil.printNumFormat(data.LECT_TIME).equals("0") ? "" : WebUtil.printNumFormat(data.LECT_TIME) + " " %>" size="20" style="text-align:right" readonly>
                    </td>
                </tr>
                <tr>
                    <th>학습기관</th>
                    <td colspan="3">
                        <input type="text" name="STUD_INST" value="<%= data.STUD_INST %>" size="50" readonly>
                    </td>
                </tr>
                <tr>
                    <th>수강과목</th>
                    <td colspan="3">
                        <input type="text" name="LECT_SBJT" value="<%= data.LECT_SBJT %>" size="50" readonly>
                    </td>
                </tr>
                <tr>
                    <th>결제금액</th>
                    <td>
                        <input type="text" name="SETL_WONX" value="<%= WebUtil.printNumFormat(data.SETL_WONX) + " " %>" size="20" style="text-align:right" readonly>
                    </td>
                    <th class="th02">결제일</th>
                    <td>
                        <input type="text" name="SELT_DATE" value="<%= WebUtil.printDate(data.SELT_DATE,".") %>" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th>카드번호</th>
                    <td colspan="3">
                        <input type="text" name="CARD_NUMB" value="<%= data.CARD_NUMB %>" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th>카드회사</th>
                    <td colspan="3">
                        <input type="text" name="CARD_CMPY" value="<%= data.CARD_CMPY %>" size="50" readonly>
                    </td>
                </tr>
                <tr>
                    <th>회사지원금액</th>
                    <td colspan="3">
                        <input type="text" name="CMPY_WONX" value="<%= WebUtil.printNumFormat(data.CMPY_WONX) + " " %>" style="text-align:right" readonly>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <!--상단 입력 테이블 끝-->

    <h2 class="subtitle"> 결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppDetail(data.AINF_SEQN) %>
    <!-- 결재자 입력 테이블 End-->

    <div class="buttonArea">
        <ul class="btn_crud">
<%
    String ThisJspName = (String)request.getAttribute("ThisJspName");
    Logger.debug.println(this, "ThisJspName : "+ ThisJspName);
    if ( ThisJspName.equals("A16ApplList.jsp")  ) {
%>
            <li><a href="javascript:do_list();"><span>목록</span></a></li>
<%
    }
%>
            <li><a href="javascript:go_change();"><span>수정</span></a></li>
            <li><a href="javascript:go_delete();"><span>삭제</span></a></li>
        </ul>
    </div>

<!--  HIDDEN  처리해야할 부분 시작-->
  <input type="hidden" name="jobid"       value="">
  <input type="hidden" name="AINF_SEQN"   value="<%= data.AINF_SEQN %>">
  <input type="hidden" name="ThisJspName" value="<%= ThisJspName %>">
<!--  HIDDEN  처리해야할 부분 끝-->
  </form>
</div>

<%@ include file="/web/common/commonEnd.jsp" %>
