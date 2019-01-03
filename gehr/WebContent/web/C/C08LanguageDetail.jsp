<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.C.C07Language.*" %>
<%@ page import="hris.C.C07Language.rfc.*" %>

<%
    WebUserData     user = (WebUserData)session.getAttribute("user");
    Box             box  = WebUtil.getBox(request);
    C07LanguageData data = new C07LanguageData();
    box.copyToEntity(data);

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
function f_print()
{
     self.print();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<div class="subWrapper">

    <div class="title"><h1>어학지원비 상세조회</h1></div>

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

    <form name="form1" method="post" action="">
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
    <!-- 상단 입력 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back();"><span>목록</span></a></li>
        </ul>
    </div>

  </form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>
