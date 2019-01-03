<%@ page contentType="text/html; charset=utf-8" %>
<%--@ include file="/web/common/popupPorcess.jsp" --%>
<%@ page import="com.sns.jdf.util.*" %>
<%
	//update : 2015-10-26 [CSR ID:2902358] 제도안내 內 모성보호 항목 추가 구성요청
    //update : 2016-02-16 [CSR ID:2985320] G-portal內 HR제도, 교육지원포탈, 사내정보내용 변경요청件
	//WebUserData user = WebUtil.getSessionUser(request);
    //update : 2016-05-16  [CSR ID:3059290] HR제도 팝업 관련 개선 요청의 건
    //update : 2017-07-06  [CSR ID:3475158] Global HR Portal 내 HR제도 관련
    //update : 2017-07-17  [CSR ID:3435049] Global HR Portal상의 HR제도 수정사항 반영 요청의 건

//  사용방법안내 Open시 해당메뉴를 열어줘야하는경우
    String  mName  = request.getParameter("param");
    String  mKey   = mName.substring(0,3);
    int     index1 = 0;
    int     index2 = 0;
    int     index3 = 0;
    int     index4 = 0;
    int     index5 = 0;
    int     index6 = 0;

    if( mKey.equals("A04") || mKey.equals("A10") || mKey.equals("A13") ) {
        index1 = 25;
        index2 = 26;
        index3 = 27;
    } else if( mKey.equals("B03") || mKey.equals("B04") ) {
        index1 = 25;
        index2 = 26;
        index3 = 31;
    } else if( mKey.equals("E14") || mKey.equals("E18") || mKey.equals("E20") || mKey.equals("E22") ) {
        index1 = 25;
        index2 = 26;
        index3 = 34;
    } else if( mKey.equals("con") ) {     // 사이트맵
        index1 = 0;
    } else if( mKey.equals("A12") || mKey.equals("A17") ) {
        index1 = 25;
        index2 = 38;
        index3 = 39;
    } else if( mKey.equals("A03") || mKey.equals("A14") || mKey.equals("E12") ) {
        index1 = 25;
        index2 = 38;
        index3 = 42;
    } else if( mKey.equals("D01") || mKey.equals("D03") ) {
        index1 = 25;
        index2 = 38;
        index3 = 46;
    } else if( mKey.equals("C02") ) {
        index1 = 25;
        index2 = 38;
        index3 = 44;
    } else if( mKey.equals("E01") || mKey.equals("E02") || mKey.equals("E04") || mKey.equals("E05") ||
               mKey.equals("E06") || mKey.equals("E10") || mKey.equals("E15") || mKey.equals("E17") ||
               mKey.equals("E19") || mKey.equals("E21") || mKey.equals("E25") ) {
        index1 = 25;
        index2 = 38;
        index3 = 49;
    } else if( mKey.equals("A15") || mKey.equals("A18") ) {
        index1 = 25;
        index2 = 38;
        index3 = 63;
    } else if( mKey.equals("X03") ) {
        index1 = 108;
    } else if( mKey.equals("X04") ) {
        index1 = 108;
    } else if( mKey.equals("F51") ) {
        index1 = 108;
        index2 = 110;
        index3 = 111;
    } else if( mKey.equals("GAp") ) {
        index1 = 112;
        index2 = 113;
    } else if( mKey.equals("J01") ) {
        // Job Description 조회(팀장)
        if( mName.equals("J01JobMatrix.html")     || mName.equals("J01JobProfile.html")      ||
            mName.equals("J01CompetencyReq.html") || mName.equals("J01CompetencyReq_d.html") ||
            mName.equals("J01JobProcess.html")    || mName.equals("J01JobUnitKSEA.html")     ||
            mName.equals("J01LevelingSheet.html") ) {
            index1 = 25;
            index2 = 66;
            index3 = 75;
            index4 = 76;
        // Job Description 조회(개인)
        } else if( mName.equals("J01JobMatrix_m.html") || mName.equals("J01JobProfile_m.html")      ||
            mName.equals("J01CompetencyReq_m.html")    || mName.equals("J01CompetencyReq_d_m.html") ||
            mName.equals("J01JobProcess_m.html")       || mName.equals("J01JobUnitKSEA_m.html")     ||
            mName.equals("J01LevelingSheet_m.html") ) {
            index1 = 25;
            index2 = 66;
            index3 = 67;
            index4 = 68;
        }
    //  Competency List
    } else if( mKey.equals("J02") ) {
        index1 = 25;
        index2 = 66;
    } else if( mKey.equals("J03") ) {
        // Job Description 생성
        if( mName.equals("J03JobMatrix_B.html")     || mName.equals("J03JobProfile_B.html")   ||
            mName.equals("J03CompetencyReq_B.html") || mName.equals("J03JobUnitKSEA_B.html")  ||
            mName.equals("J03JobProcess_B.html")    || mName.equals("J03LevelingSheet_B.html") ) {
            index1 = 25;
            index2 = 66;
            index3 = 82;
            index4 = 83;
            index5 = 84;
        // Job Description 조회, 수정
        } else if( mName.equals("J03JobMatrix_C.html") || mName.equals("J03JobProfile_R.html")    ||
            mName.equals("J03JobProfile_C.html")       || mName.equals("J03CompetencyReq_C.html") ||
            mName.equals("J03JobUnitKSEA_C.html")      || mName.equals("J03JobProcess_C.html")    ||
            mName.equals("J03LevelingSheet_C.html") ) {
            index1 = 25;
            index2 = 66;
            index3 = 82;
            index4 = 90;
            index5 = 91;
        }
    // 대분류 생성
    } else if( mKey.equals("J04") ) {
        index1 = 25;
        index2 = 66;
        index3 = 82;
        index4 = 98;
    // Job 이동
    } else if( mKey.equals("J05") ) {
        index1 = 25;
        index2 = 66;
        index3 = 82;
        index4 = 105;
    // Job 이동
    }
%>

<html>
<head>

<title>e-HR 사용방법안내</title>
<link rel="stylesheet" type="text/css" href="/web/help_online/images/skin/style.css">
<script src="/web/help_online/images/tree/MakeTree_help.js"></script>
<script language="javascript">
<!--
function on_Load() {
    if( "<%= index1 %>" != "0" ) {
        clickOnNode(<%= index1 %>);
    }

    if( "<%= index2 %>" != "0" ) {
        clickOnNode(<%= index2 %>);
    }

    if( "<%= index3 %>" != "0" ) {
        clickOnNode(<%= index3 %>);
    }

    if( "<%= index4 %>" != "0" ) {
        clickOnNode(<%= index4 %>);
    }

    if( "<%= index5 %>" != "0" ) {
        clickOnNode(<%= index5 %>);
    }
    if( "<%= index6 %>" != "0" ) {
        clickOnNode(<%= index6 %>);
    }
    //clickOnNode(1);//[CSR ID:3059290] 복리후생 메뉴 default open숨김
    //clickOnNode(7);//[CSR ID:3059290] 복리후생 메뉴 default open숨김
    clickOnNode(13);
    clickOnNode(18);//[CSR ID:3059290] 복리후생 메뉴 default open
    //clickOnNode(20);
   // clickOnNode(20);
    //clickOnNode(24);
}
//-->
</script>

<style type="text/css">
<!--
body {

    font-family:malgun gothic;
    font-size:11px;
}
a, td {    font-family:malgun gothic;font-size:12px;letter-spacing:-1px;}
//-->
</style>
</head>

<!--<body bgcolor="#F0F0F0" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:on_Load();">-->

<body style="background:#ffffff url(/web/help_online/help_C100/screen/rule//bg_left.gif) repeat-y top right;" onLoad="javascript:on_Load();">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td valign="top">
      <table width="100%" height="25" cellspacing="0" cellpadding="0" border="0"><tr>
        <td width=10>&nbsp;</td>
        <td>
        <!--- 디렉토리 폴더 보기 ------------------------------------------------------------>
        <script language="JavaScript">
          aux0 = gFld("제도안내 목차",                                   "", 0)
          aux1 = insFld(aux0, gFld("인사제도 ·발령",           "", 0))

			// [CSR ID:3435049] Global HR Portal상의 HR제도 수정사항 반영 요청의 건(빈화면 처리한것 원복)
            aux2 = insFld(aux1, gFld("평가",           "ruleMain.jsp?param=Rule03Valuate01.html", 1))
            aux2 = insFld(aux1, gFld("진급",           "ruleMain.jsp?param=Rule03Valuate02.html", 1))
            aux2 = insFld(aux1, gFld("사업가육성",           "ruleMain.jsp?param=Rule03Valuate03.html", 1))
            //[CSR ID:3475158] 평가/직급/사업가육성 임시로 빈화면 처리함
            //aux2 = insFld(aux1, gFld("평가",           "ruleMain.jsp?param=Rule03Valuate06.html", 1))
            //aux2 = insFld(aux1, gFld("진급",           "ruleMain.jsp?param=Rule03Valuate06.html", 1))
            //aux2 = insFld(aux1, gFld("사업가육성",           "ruleMain.jsp?param=Rule03Valuate06.html", 1))

            aux2 = insFld(aux1, gFld("휴직",           "ruleMain.jsp?param=Rule03Valuate04.html", 1))
            aux2 = insFld(aux1, gFld("퇴직",           "ruleMain.jsp?param=Rule03Valuate05.html", 1))

            //aux1 = insFld(aux0, gFld("교육체계",           "", 0)) //[CSR ID:2985320]
            aux1 = insFld(aux0, gFld("교육제도",           "", 0))
              aux2 = insFld(aux1, gFld("교육 체계도",                         "ruleMain.jsp?param=Rule04Learn01.html", 1))
              aux2 = insFld(aux1, gFld("Mentoring제도",                         "ruleMain.jsp?param=Rule04Learn02.html", 1))
              //aux2 = insFld(aux1, gFld("e-Learning 지원제도",                   "ruleMain.jsp?param=Rule04Learn03.html", 1))
              aux2 = insFld(aux1, gFld("외국어성적 등록방법",                  "ruleMain.jsp?param=Rule04Learn04.html", 1))
              aux2 = insFld(aux1, gFld("LAP Test 등록방법",                    "ruleMain.jsp?param=Rule04Learn05.html", 1))
              aux2 = insFld(aux1, gFld("리더십센터 이용안내",           "ruleMain.jsp?param=Rule04Learn06.html", 1))


            aux1 = insFld(aux0, gFld("급여·상여·제수당·휴가",           "", 0))
              aux2 = insFld(aux1, gFld("급여안내",                         "ruleMain.jsp?param=Rule01Payment01.html", 1))
              aux2 = insFld(aux1, gFld("상여금",                           "ruleMain.jsp?param=Rule01Payment03.html", 1))
              aux2 = insFld(aux1, gFld("퇴직금",                           "ruleMain.jsp?param=Rule01Payment04.html", 1))
              aux2 = insFld(aux1, gFld("휴가",                             "ruleMain.jsp?param=Rule01Payment05.html", 1))
            aux1 = insFld(aux0, gFld("복리후생",                           "", 0))
              //aux2 = insFld(aux1, gFld("법정지원",                         "", 0))
             // C20140106_63914 2레벨삭제
                aux2 = insFld(aux1, gFld("고용보험",                       "ruleMain.jsp?param=Rule02Benefits01.html", 1))
                aux2 = insFld(aux1, gFld("산재보험",                       "ruleMain.jsp?param=Rule02Benefits02.html", 1))
                aux2 = insFld(aux1, gFld("국민연금",                       "ruleMain.jsp?param=Rule02Benefits03.html", 1))
                aux2 = insFld(aux1, gFld("건강보험",                       "ruleMain.jsp?param=Rule02Benefits16.html", 1))
             // C20140106_63914 선택적복리후생추가
                aux2 = insFld(aux1, gFld("선택적복리후생",                 "ruleMain.jsp?param=Rule02Benefits17.html", 1))
             // aux2 = insFld(aux1, gFld("임의적지원",                       "", 0))
             // C20140106_63914 2레벨삭제
                aux2 = insFld(aux1, gFld("주택자금 지원규정",              "ruleMain.jsp?param=Rule02Benefits04.html",1))
                aux2 = insFld(aux1, gFld("학자금·장학금",                  "ruleMain.jsp?param=Rule02Benefits05.html",1))
                aux2 = insFld(aux1, gFld("경조금 지원제도",                "ruleMain.jsp?param=Rule02Benefits06.html",1))
                aux2 = insFld(aux1, gFld("건강검진",                       "ruleMain.jsp?param=Rule02Benefits08.html",1))
                aux2 = insFld(aux1, gFld("의료비지원",                     "ruleMain.jsp?param=Rule02Benefits09.html",1))
                aux2 = insFld(aux1, gFld("단체정기보험",                   "ruleMain.jsp?param=Rule02Benefits10.html",1))
                aux2 = insFld(aux1, gFld("장기근속포상·기념품",            "ruleMain.jsp?param=Rule02Benefits12.html",1))
                aux2 = insFld(aux1, gFld("LG휴양소",                       "ruleMain.jsp?param=Rule02Benefits13.html",1))
                aux2 = insFld(aux1, gFld("장례용품 지급기준",              "ruleMain.jsp?param=Rule02Benefits14.html",1))
                aux2 = insFld(aux1, gFld("작은결혼식",                     "ruleMain.jsp?param=Rule02Benefits15.html",1))
                aux2 = insFld(aux1, gFld("모성보호",                     "ruleMain.jsp?param=Rule02Benefits18.html",1))    //CSR ID:2902358
        initializeDocument();
        </script>
        <!--디렉토리 폴더 보기 ------------------------------------------------------------>
        </td>
      </tr>
    </table>
  </td>
</table>
</body>
</html>
