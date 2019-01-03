<%@ page contentType="text/html; charset=utf-8" %>
<%--@ include file="/web/common/popupPorcess.jsp" --%>
<%@ page import="com.sns.jdf.util.*" %>

<%
//update : 2015-10-26 [CSR ID:2902358] 제도안내 內 모성보호 항목 추가 구성요청
//update : 2016-02-16 [CSR ID:2985320] G-portal內 HR제도, 교육지원포탈, 사내정보내용 변경요청件
//  도움말 Open시 해당메뉴를 열어줘야하는경우
    String      mName  = request.getParameter("param");
    String      mKey   = mName.substring(0,3);
    String      mTitle = "";
//  5가지 Type로 나뉜다.
//  Type① : 1. 개요 및 신청절차
//           2. 화면사용법 및 유의사항
//           3. 제도소개
//           4. 제출서류
//  Type② : Type①의 1, 2, 3
//  Type③ : Type①의 1, 2
//  Type④ : 1. 개요
//           2. 화면사용법 및 유의사항
//  Type⑤ : 1. 개요 및 신청절차
//           2. 화면사용법 및 유의사항
//           3. 제출서류

    int         mType    = 0;

    if( mKey.equals("A03") ) {          //Type①
        mTitle = "급여계좌정보";
        mType  = 1;
    } else if( mKey.equals("A04") ) {   //Type①
        mTitle = "가족사항";
        mType  = 3;
    } else if( mKey.equals("A10") ) {   //Type④
        mTitle = "나의연봉";
        mType  = 4;
    } else if( mKey.equals("A12") ) {   //Type①
        mTitle = "가족사항추가입력";
        mType  = 3;
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
        mType  = 3;
    } else if( mKey.equals("A18") ) {   //Type③
        mTitle = "원천징수영수증 신청";
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
        mTitle = "초과근무";
        mType  = 3;
    } else if( mKey.equals("D03") ) {   //Type③
        mTitle = "휴가";
        mType  = 3;
    } else if( mKey.equals("E01") ) {   //Type⑤
        mTitle = "건강보험 피부양자신청";
        mType  = 5;
    } else if( mKey.equals("E02") ) {   //Type③
        mTitle = "건강보험 재발급";
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
        mTitle = "의료비";
        mType  = 4;
    } else if( mKey.equals("E19") ) {   //Type①
        if( mName.equals("E19Congra.html") ) {              //경조금     - Type①
            mTitle = "경조금";
        } else if( mName.equals("E19Disaster.html") ) {     //재해신청   - Type①
            mTitle = "재해신청";
        }
        mType  = 1;
    } else if( mKey.equals("E20") ) {   //Type④
        mTitle = "경조금";
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
        mTitle = "장학자금·입학축하금";
        mType  = 4;
    } else if( mKey.equals("E25") ) {   //Type③
        mTitle = "동호회 가입";
        mType  = 3;
    } else if ( mKey.equals("Rul") ) {   //제도안내 - Typeⓞ
        if ( mName.equals("Rule01Payment01.html") ) {
            mTitle = "급여안내";
        } else if ( mName.equals("Rule01Payment02.html") ) {
            mTitle = "제수당";
        } else if ( mName.equals("Rule01Payment03.html") ) {
            mTitle = "상여금";
        } else if ( mName.equals("Rule01Payment04.html") ) {
            mTitle = "퇴직금";
        } else if ( mName.equals("Rule01Payment05.html") ) {
            mTitle = "휴가";
        } else if ( mName.equals("Rule02Benefits01.html") ) {
            mTitle = "고용보험";
        } else if ( mName.equals("Rule02Benefits02.html") ) {
            mTitle = "산재보험";
        } else if ( mName.equals("Rule02Benefits03.html") ) {
            mTitle = "국민연금";
        } else if ( mName.equals("Rule02Benefits16.html") ) {
            mTitle = "건강보험";
        } else if ( mName.equals("Rule02Benefits04.html") ) {
            mTitle = "주택자금 지원규정";
        } else if ( mName.equals("Rule02Benefits05.html") ) {
            mTitle = "학자금·장학금";
        } else if ( mName.equals("Rule02Benefits06.html") ) {
            mTitle = "경조금 지원제도";
        } else if ( mName.equals("Rule02Benefits07.html") ) {
            mTitle = "그룹사제품구입지원";
        } else if ( mName.equals("Rule02Benefits08.html") ) {
            mTitle = "건강검진";
        } else if ( mName.equals("Rule02Benefits09.html") ) {
            mTitle = "의료비지원";
        } else if ( mName.equals("Rule02Benefits10.html") ) {
            mTitle = "단체정기보험";
        } else if ( mName.equals("Rule02Benefits11.html") ) {
            mTitle = "개인연금·마이라이프보험";
        } else if ( mName.equals("Rule02Benefits12.html") ) {
            mTitle = "장기근속포상·기념품";
        } else if ( mName.equals("Rule02Benefits13.html") ) {
            mTitle = "LG휴양소";
        } else if ( mName.equals("Rule02Benefits14.html") ) {
            mTitle = "장례용품 지급기준";
        } else if ( mName.equals("Rule02Benefits15.html") ) {
            mTitle = "작은결혼식";
        } else if ( mName.equals("Rule02Benefits17.html") ) {  //C20140106_63914 선택적복리후생추가
            mTitle = "선택적복리후생";
        } else if ( mName.equals("Rule02Benefits18.html") ) {  //CSR ID:2902358
            mTitle = "모성보호 ";
        }else if ( mName.equals("Rule03Valuate01.html") ) {
            mTitle = "평가";
        } else if ( mName.equals("Rule03Valuate02.html") ) {
            mTitle = "진급";
        } else if ( mName.equals("Rule03Valuate03.html") ) {
            mTitle = "사업가육성";
        } else if ( mName.equals("Rule03Valuate04.html") ) {
            mTitle = "휴직";
        } else if ( mName.equals("Rule03Valuate05.html") ) {
            mTitle = "퇴직";
        } else if ( mName.equals("Rule04Learn01.html") ) {
            mTitle = "교육 체계도";
        } else if ( mName.equals("Rule04Learn02.html") ) {
            mTitle = "Mentoring제도";
        } else if ( mName.equals("Rule04Learn03.html") ) {
            mTitle = "e-Learning 지원제도";//[CSR ID:2985320]
        } else if ( mName.equals("Rule04Learn04.html") ) {
            mTitle = "외국어성적 등록 방법";
        } else if ( mName.equals("Rule04Learn05.html") ) {
            mTitle = "LAP Test 등록 방법";
        } else if ( mName.equals("Rule04Learn06.html") ) {
            mTitle = "리더십센터 이용안내 ";
        }

        mType  = 0;
    } else if ( mKey.equals("X01") ) {   //Type 초기화면
        if ( mName.equals("X01InitScreen.html") ) {
            mTitle = "초기화면";
        }
        mType  = 10;
    } else if ( mKey.equals("X03") || mKey.equals("X04") || mKey.equals("F51") ) {   //Type③
        if ( mName.equals("X03PersonInfo.html") ) {
            mTitle = "사원인사정보";
        } else if ( mName.equals("X04Statistics.html") ) {
            mTitle = "조직통계";
        } else if ( mName.equals("F51DeptWelfare.html") ) {
            mTitle = "복리후생수혜현황";
        }
        mType  = 3;
    } else if ( mKey.equals("App") ) {   //Type③
        if ( mName.equals("Approval.html") ) {
            mTitle = "HR결재함";
        }
        mType  = 11;
    } else if( mKey.equals("J01") ) {   //Type④
//      Job Description 조회(개인,팀장)
        if ( mName.equals("J01JobMatrix.html") ) {
            mTitle = "팀원 Job Matrix 화면 조회";
        } else if ( mName.equals("J01JobMatrix_m.html") ) {
            mTitle = "Job Matrix 화면 조회";
        } else if ( mName.equals("J01JobProfile.html") ) {
            mTitle = "팀원 Job Profile 화면 조회";
        } else if ( mName.equals("J01JobProfile_m.html") ){
            mTitle = "Job Profile 화면 조회";
        } else if ( mName.equals("J01CompetencyReq.html") ) {
            mTitle = "팀원 Competency Requirements 화면 조회";
        } else if ( mName.equals("J01CompetencyReq_m.html") ) {
            mTitle = "Competency Requirements 화면 조회";
        } else if ( mName.equals("J01JobUnitKSEA.html") ) {
            mTitle = "팀원 Job Unit별 KSEA 화면 조회";
        } else if ( mName.equals("J01JobUnitKSEA_m.html") ) {
            mTitle = "Job Unit별 KSEA 화면 조회";
        } else if ( mName.equals("J01JobProcess.html") ) {
            mTitle = "팀원 Job Process 화면 조회";
        } else if ( mName.equals("J01JobProcess_m.html") ) {
            mTitle = "Job Process 화면 조회";
        } else if ( mName.equals("J01LevelingSheet.html") ) {
            mTitle = "팀원 Job Leveling Sheet 화면 조회";
        } else if ( mName.equals("J01LevelingSheet_m.html") ) {
            mTitle = "Job Leveling Sheet 화면 조회";
        }
        mType  = 4;
    } else if( mKey.equals("J02") ) {   //Type④
//      Competency List
        mTitle = "Competency List 화면 조회";
        mType  = 4;
    } else if( mKey.equals("J03") ) {   //Type④
//      Job Description 조회ㆍ수정ㆍ생성 - Job 생성/수정/삭제
        if ( mName.equals("J03JobMatrix_B.html") || mName.equals("J03JobMatrix_C.html") ) {
            mTitle = "Job Matrix 화면 조회";
        } else if ( mName.equals("J03JobProfile_B.html") ) {
            mTitle = "Job Profile 생성화면";
        } else if ( mName.equals("J03JobProfile_R.html") ) {
            mTitle = "Job Profile 조회화면";
        } else if ( mName.equals("J03JobProfile_C.html") ) {
            mTitle = "Job Profile 수정화면";
        }else if ( mName.equals("J03CompetencyReq_B.html") ) {
            mTitle = "Competency Requirements 생성화면";
        }else if ( mName.equals("J03CompetencyReq_C.html") ) {
            mTitle = "Competency Requirements 수정화면";
        } else if ( mName.equals("J03JobUnitKSEA_B.html") ) {
            mTitle = "Job Unit별 KSEA 생성화면";
        } else if ( mName.equals("J03JobUnitKSEA_C.html") ) {
            mTitle = "Job Unit별 KSEA 수정화면";
        } else if ( mName.equals("J03JobProcess_B.html") ) {
            mTitle = "Job Process 생성화면";
        } else if ( mName.equals("J03JobProcess_C.html") ) {
            mTitle = "Job Process 수정화면";
        } else if ( mName.equals("J03LevelingSheet_B.html") ) {
            mTitle = "Job Leveling Sheet 조회화면";
        } else if ( mName.equals("J03LevelingSheet_C.html") ) {
            mTitle = "Job Leveling Sheet 수정화면";
        }
        mType  = 4;
    } else if( mKey.equals("J04") ) {   //Type④
//      Job Description 조회ㆍ수정ㆍ생성 - 대분류 생성/수정/삭제
        if ( mName.equals("J04JobMatrix.html") ) {
            mTitle = "Job Matrix 화면 조회";
        } else if ( mName.equals("J04Dsort_B.html") ) {
            mTitle = "대분류 생성화면";
        } else if ( mName.equals("J04Dsort_R.html") ) {
            mTitle = "대분류 조회화면";
        } else if ( mName.equals("J04Objective_C.html") ) {
            mTitle = "Objective 수정화면";
        }else if ( mName.equals("J04DsortName_C.html") ) {
            mTitle = "대분류명 수정화면";
        }else if ( mName.equals("J04Dsort_D.html") ) {
            mTitle = "대분류 삭제화면";
        }
        mType  = 4;
    } else if( mKey.equals("J05") ) {   //Type④
//      Job Description 조회ㆍ수정ㆍ생성 - Job 이동
        if ( mName.equals("J05JobMatrix.html") ) {
            mTitle = "Job Matrix 화면 조회";
        } else if ( mName.equals("J05JobMove.html") ) {
            mTitle = "Job 이동화면";
        }
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
<!--<body{background:url(/web/help_online/help_C100/screen/rule//bg_left.gif) repeat-y top right;}>
<style>

.subHead {

	margin-bottom:12px;
}
.subWrapper h2 {
}
.title00  {

	}
</style>
<body style="background:#c8294b url(/web/help_online/help_C100/screen/rule//bg_left.gif) repeat-y top right;">-->
<form name="form1" method="post" action="">
<table width="608" border="0" cellspacing="0" cellpadding="0" <%if(!mTitle.equals("")){ %>style="background:url('/web/images/ehr/title_underbar.gif') repeat-x  left bottom;padding:0 0 7px 0;"<%} %>>
  <tr>
    <td class="title00-" width="420" <%if(!mTitle.equals("")){ %>style="background:url(/web/images/ehr/title01.gif) no-repeat 0px 0px;
    	font-family:malgun gothic;color: #333; font-size:15px;font-weight: bold; word-spacing: -1; padding:2px 0 12px 30px;"<%} %> ><%= mTitle %></td>
    <td width=185 align=right>
<%
    if( mType > 0 ) {
%>
      <select name="menu" onChange="javascript:view_menu();">
        <option value="menu0">----------------- 이동 -----------------</option>
<%
//      Type① : 1. 개요 및 신청절차
//               2. 화면사용법 및 유의사항
//               3. 제도소개
//               4. 제출서류
//      Type② : Type①의 1, 2, 3
//      Type③ : Type①의 1, 2
//      Type④ : 1. 개요
//               2. 화면사용법 및 유의사항
//      Type⑤ : 1. 개요 및 신청절차
//               2. 화면사용법 및 유의사항
//               3. 제출서류
        if( mType == 1 ) {
%>
        <option value="menu1">1. 개요 및 신청절차</option>
        <option value="menu2">2. 화면사용법 및 유의사항</option>
        <option value="menu3">3. 제출서류</option>
<%
        } else if( mType == 2 ) {
%>
        <option value="menu1">1. 개요 및 신청절차</option>
        <option value="menu2">2. 화면사용법 및 유의사항</option>
<%
        } else if( mType == 3 ) {
%>
        <option value="menu1">1. 개요 및 신청절차</option>
        <option value="menu2">2. 화면사용법 및 유의사항</option>
<%
        } else if( mType == 4 ) {
%>
        <option value="menu1">1. 개요</option>
        <option value="menu2">2. 화면사용법 및 유의사항</option>
<%
        } else if( mType == 5 ) {
%>
        <option value="menu1">1. 개요 및 신청절차</option>
        <option value="menu2">2. 화면사용법 및 유의사항</option>
        <option value="menu3">3. 제출서류</option>
<%
        } else if (mType == 10 ) {
%>
        <option value="menu1">1. 사원용 초기화면</option>
        <option value="menu2">2. 팀장용 초기화면</option>
<%
        } else if (mType == 11 ) {
%>
        <option value="menu1">1. HR 결재함 - 개인용</option>
        <option value="menu2">2. HR 결재함 - 팀장용</option>
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

<% if (!mTitle.equals("")){ %>
  <tr height=9 style="display:none;">
    <td colspan=3 background="<%= WebUtil.ImageURL %>help/mainTopBg.gif"></td>
  </tr>
   <%} %>
</table>
</form>
</body>
</html>
