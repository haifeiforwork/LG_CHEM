<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
//  도움말 Open시 해당메뉴를 열어줘야하는경우
    String      mName  = request.getParameter("param");
    String      mKey   = mName.substring(0,3);
    String      mTitle = "";
//  5가지 Type로 나뉜다.
//  Type① : Ⅰ. 개요 및 신청절차
//           Ⅱ. 화면사용법 및 유의사항
//           Ⅲ. 제도소개
//           Ⅵ. 제출서류
//  Type② : Type①의 1, 2, 3
//  Type③ : Type①의 1, 2
//  Type④ : Ⅰ. 개요
//           Ⅱ. 화면사용법 및 유의사항
//  Type⑤ : Ⅰ. 개요 및 신청절차
//           Ⅱ. 화면사용법 및 유의사항
//           Ⅲ. 제출서류
    int         mType  = 0;

    if( mKey.equals("A03") ) {          //Type①
        mTitle = "계좌정보";
        mType  = 1;
    } else if( mKey.equals("A04") ) {   //Type①
        mTitle = "가족사항";
        mType  = 1;
    } else if( mKey.equals("A10") ) {   //Type④
        mTitle = "나의연봉";
        mType  = 4;
    } else if( mKey.equals("A12") ) {   //Type①
        mTitle = "가족사항추가입력";
        mType  = 1;
    } else if( mKey.equals("A13") ) {   //Type④
        mTitle = "주소";
        mType  = 4;
    } else if( mKey.equals("A15") ) {   //Type③
        mTitle = "재직증명서 신청";
        mType  = 3;
    } else if( mKey.equals("A16") ) {   //Type④
        mTitle = "결재진행현황";
        mType  = 4;
    } else if( mKey.equals("A17") ) {   //Type②
        mTitle = "자격면허등록";
        mType  = 2;
    } else if( mKey.equals("A18") ) {   //Type③
        mTitle = "근로소득·갑근세 원천징수 영수증 신청";
        mType  = 3;
    } else if( mKey.equals("B03") ) {   //Type②
        mTitle = "인재개발협의결과";
        mType  = 2;
    } else if( mKey.equals("B04") ) {   //Type④
        mTitle = "진급자격요건 시뮬레이션";
        mType  = 4;
    } else if( mKey.equals("C02") ) {   //Type②
        mTitle = "교육과정 안내ㆍ신청";
        mType  = 2;
    } else if( mKey.equals("D01") ) {   //Type③
        mTitle = "초과근무(OTㆍ특근)";
        mType  = 3;
    } else if( mKey.equals("D03") ) {   //Type③
        mTitle = "휴가";
        mType  = 3;
    } else if( mKey.equals("E01") ) {   //Type⑤
        mTitle = "건강보험 자격변경";
        mType  = 5;
    } else if( mKey.equals("E02") ) {   //Type③
        mTitle = "건강보험 정보변경";
        mType  = 3;
    } else if( mKey.equals("E04") ) {   //Type①
        mTitle = "국민연금 자격변경";
        mType  = 1;
    } else if( mKey.equals("E05") ) {   //Type①
        mTitle = "주택자금 신규신청";
        mType  = 1;
    } else if( mKey.equals("E06") ) {   //Type①
        mTitle = "주택자금 상환신청";
        mType  = 1;
    } else if( mKey.equals("E10") ) {   //Type②
        mTitle = "개인연금";
        mType  = 2;
    } else if( mKey.equals("E14") ) {   //Type④
        mTitle = "우리사주 보유현황";
        mType  = 4;
    } else if( mKey.equals("E15") ) {   //Type③
        mTitle = "종합검진";
        mType  = 3;
    } else if( mKey.equals("E17") ) {   //Type①
        mTitle = "의료비";
        mType  = 1;
    } else if( mKey.equals("E18") ) {   //Type④
        mTitle = "의료비 지원내역";
        mType  = 4;
    } else if( mKey.equals("E19") ) {   //Type①
        if( mName.equals("E19Congra.html") ) {              //경조금     - Type①
            mTitle = "경조금";
        } else if( mName.equals("E19Disaster.html") ) {     //재해신청   - Type①
            mTitle = "재해신청";
        }
        mType  = 1;
    } else if( mKey.equals("E20") ) {   //Type④
        mTitle = "경조금 지원내역";
        mType  = 4;
    } else if( mKey.equals("E21") ) {
        if( mName.equals("E21Expense.html") ) {             //장학자금   - Type①
            mTitle = "장학자금";
            mType  = 1;
        } else if( mName.equals("E21Entrance.html") ) {     //입학축하금 - Type②
            mTitle = "입학축하금";
            mType  = 2;
        }
    } else if( mKey.equals("E22") ) {   //Type④
        mTitle = "장학자금·입학축하금 지원내역";
        mType  = 4;
    } else if( mKey.equals("E25") ) {   //Type③
        mTitle = "동호회 가입";
        mType  = 3;
    } else if( mKey.equals("J01") ) {   //Type④
//      Job Description 조회(개인,팀장)
        if( mName.equals("J01CompetencyReq.html") || mName.equals("J01CompetencyReq_m.html") ) {
            mTitle = "Competency Requirements 화면 조회";
        } else if( mName.equals("J01JobMatrix.html") || mName.equals("J01JobMatrix_m.html") ) {
            mTitle = "Job Matrix 화면 조회";
        } else if( mName.equals("J01JobProcess.html") || mName.equals("J01JobProcess_m.html") ) {
            mTitle = "Job Process 화면 조회";
        } else if( mName.equals("J01JobProfile.html") || mName.equals("J01JobProfile_m.html") ) {
            mTitle = "Job Profile 화면 조회";
        } else if( mName.equals("J01JobUnitKSEA.html") || mName.equals("J01JobUnitKSEA_m.html") ) {
            mTitle = "Job Unit별 KSEA 화면 조회";
        } else if( mName.equals("J01LevelingSheet.html") || mName.equals("J01LevelingSheet_m.html") ) {
            mTitle = "Job Leveling Sheet 화면 조회";
        }
        mType  = 4;
    } else if( mKey.equals("J02") ) {   //Type④
//      Competency List
        mTitle = "Competency List 화면 조회";
        mType  = 4;
    }
%>

<html>
<head>
<link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>css/help_style.css">
<script language="JavaScript">
<!--
function view_menu(){
  if( document.form1.menu.selectedIndex > 0 ) {
    menu_s = document.form1.menu[document.form1.menu.selectedIndex].value;
    parent.endPage.location.href = "<%= mName %>#" + menu_s;
  }
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" leftmargin="8" topmargin="8" marginwidth="0" marginheight="0" scroll="no">
<form name="form1" method="post" action="">
<table width="608" border="0" cellspacing="0" cellpadding="0">
  <tr height=29>
    <td class="title00" width="420"><%= mTitle %></td>
    <td width=185 align=right>
<%
    if( mType > 0 ) {
%>
      <select name="menu" onChange="javascript:view_menu();">
        <option value="menu0">----------------- 이동 -----------------</option>
<%
//      Type① : Ⅰ. 개요 및 신청절차
//               Ⅱ. 화면사용법 및 유의사항
//               Ⅲ. 제도소개
//               Ⅵ. 제출서류
//      Type② : Type①의 1, 2, 3
//      Type③ : Type①의 1, 2
//      Type④ : Ⅰ. 개요
//               Ⅱ. 화면사용법 및 유의사항
//      Type⑤ : Ⅰ. 개요 및 신청절차
//               Ⅱ. 화면사용법 및 유의사항
//               Ⅲ. 제출서류
        if( mType == 1 ) {
%>
        <option value="menu1">Ⅰ. 개요 및 신청절차</option>
        <option value="menu2">Ⅱ. 화면사용법 및 유의사항</option>
        <option value="menu3">Ⅲ. 제도소개</option>
        <option value="menu4">Ⅵ. 제출서류</option>
<%
        } else if( mType == 2 ) {
%>
        <option value="menu1">Ⅰ. 개요 및 신청절차</option>
        <option value="menu2">Ⅱ. 화면사용법 및 유의사항</option>
        <option value="menu3">Ⅲ. 제도소개</option>
<%
        } else if( mType == 3 ) {
%>
        <option value="menu1">Ⅰ. 개요 및 신청절차</option>
        <option value="menu2">Ⅱ. 화면사용법 및 유의사항</option>
<%
        } else if( mType == 4 ) {
%>
        <option value="menu1">Ⅰ. 개요</option>
        <option value="menu2">Ⅱ. 화면사용법 및 유의사항</option>
<%
        } else if( mType == 5 ) {
%>
        <option value="menu1">Ⅰ. 개요 및 신청절차</option>
        <option value="menu2">Ⅱ. 화면사용법 및 유의사항</option>
        <option value="menu3">Ⅲ. 제출서류</option>
<%
       } 
%>
      </select>
    </td>
    <td width=3><img src="<%= WebUtil.ImageURL %>help/spacer.gif" width=3 height=3></td>
<%
    }
%>
  </tr>
  <tr height=9>
    <td colspan=3 background="<%= WebUtil.ImageURL %>help/mainTopBg.gif"></td>
  </tr>
</table>
</form>
</body>
</html>
