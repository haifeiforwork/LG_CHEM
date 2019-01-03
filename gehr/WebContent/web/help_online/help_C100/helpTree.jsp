<%@ page contentType="text/html; charset=utf-8" %>
<%--@ include file="/web/common/popupPorcess.jsp" --%>

<%
    //WebUserData user = WebUtil.getSessionUser(request);

//  사용방법안내 Open시 해당메뉴를 열어줘야하는경우
    String  mName  = request.getParameter("param");
    String  mKey   = mName.substring(0,3);
    int     index1 = 0;
    int     index2 = 0;
    int     index3 = 0;
    int     index4 = 0;
    int     index5 = 0;

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
}
//-->
</script>

<style type="text/css">
<!--
body {

}
//-->
</style>
</head>

<body bgcolor="#F0F0F0" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:on_Load();">
<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td valign="top">
      <table width="100%" height="25" cellspacing="0" cellpadding="0" border="0"><tr>
        <td width=10>&nbsp;</td>
        <td>
        <!--- 디렉토리 폴더 보기 ------------------------------------------------------------>
        <script language="JavaScript">
          aux0 = gFld("사용방법안내 목차",                                   "", 0)

            <!-- 초기화면 -------------------------------------------------------------------------------------->
            aux1 = insFld(aux0, gFld("초기화면",                             "helpMain.jsp?param=X01InitScreen.html", 1))

            <!-- 개인인사정보 ---------------------------------------------------------------------------------->
            aux1 = insFld(aux0, gFld("개인인사정보",                         "", 0))
              aux2 = insFld(aux1, gFld("인사정보",                           "", 0))
                aux3 = insFld(aux2, gFld("개인사항",                         "", 0))
                  aux4 = insFld(aux3, gFld("주소",                           "helpMain.jsp?param=A13Address.html", 1))
                  aux4 = insFld(aux3, gFld("가족사항",                       "helpMain.jsp?param=A04FamilyList.html", 1))
                  aux4 = insFld(aux3, gFld("나의연봉",                       "helpMain.jsp?param=A10AnnualList.html", 1))
                aux3 = insFld(aux2, gFld("인재개발",                         "", 0))
                  aux4 = insFld(aux3, gFld("인재개발협의결과",               "helpMain.jsp?param=B03DevelopList.html", 1))
                  aux4 = insFld(aux3, gFld("진급자격요건 시뮬레이션",        "helpMain.jsp?param=B04Promotion.html", 1))
                aux3 = insFld(aux2, gFld("복리후생지원현황",                 "", 0))
                  aux4 = insFld(aux3, gFld("의료비",                         "helpMain.jsp?param=E18Hospital.html", 1))
                  aux4 = insFld(aux3, gFld("경조금",                         "helpMain.jsp?param=E20Congra.html", 1))
                  aux4 = insFld(aux3, gFld("장학자금",            "helpMain.jsp?param=E22Expense.html", 1))
              aux2 = insFld(aux1, gFld("신청",                               "", 0))
                aux3 = insFld(aux2, gFld("개인사항",                         "", 0))
                  aux4 = insFld(aux3, gFld("가족사항추가입력",               "helpMain.jsp?param=A12Family.html", 1))
                  aux4 = insFld(aux3, gFld("자격면허등록",                   "helpMain.jsp?param=A17Licence.html", 1))
                aux3 = insFld(aux2, gFld("급여계좌",                         "", 0))
                  aux4 = insFld(aux3, gFld("급여계좌정보",                   "helpMain.jsp?param=A03Account.html", 1))
               <!--  aux3 = insFld(aux2, gFld("교육",                             "", 0))-->
              <!--    aux4 = insFld(aux3, gFld("교육과정안내/신청",              "helpMain.jsp?param=C02Curri.html", 1))-->
                aux3 = insFld(aux2, gFld("근태",                             "", 0))
                  aux4 = insFld(aux3, gFld("초과근무",                       "helpMain.jsp?param=D01OT.html", 1))
                  aux4 = insFld(aux3, gFld("휴가",                           "helpMain.jsp?param=D03Vocation.html", 1))
                aux3 = insFld(aux2, gFld("복리후생",                         "", 0))
                  aux4 = insFld(aux3, gFld("건강보험 피부양자신청",          "helpMain.jsp?param=E01Medicare.html", 1))
                  aux4 = insFld(aux3, gFld("건강보험 재발급",                "helpMain.jsp?param=E02Medicare.html", 1))
                  aux4 = insFld(aux3, gFld("국민연금 자격변경",              "helpMain.jsp?param=E04Pension.html", 1))
                  aux4 = insFld(aux3, gFld("주택자금 신규신청",              "helpMain.jsp?param=E05House.html", 1))
                <!--  aux4 = insFld(aux3, gFld("주택자금 상환신청",              "helpMain.jsp?param=E06Rehouse.html", 1))-->
                <!--  aux4 = insFld(aux3, gFld("개인연금",                       "helpMain.jsp?param=E10Personal.html", 1))-->
                  aux4 = insFld(aux3, gFld("의료비",                         "helpMain.jsp?param=E17Hospital.html", 1))
                  aux4 = insFld(aux3, gFld("경조금",                         "helpMain.jsp?param=E19Congra.html", 1))
                  aux4 = insFld(aux3, gFld("재해신청",                       "helpMain.jsp?param=E19Disaster.html", 1))
                  aux4 = insFld(aux3, gFld("장학자금",                       "helpMain.jsp?param=E21Expense.html", 1))
                <!--   aux4 = insFld(aux3, gFld("입학축하금",                     "helpMain.jsp?param=E21Entrance.html", 1))-->
                  aux4 = insFld(aux3, gFld("종합검진",                       "helpMain.jsp?param=E15General.html", 1))
                  aux4 = insFld(aux3, gFld("동호회 가입",                    "helpMain.jsp?param=E25Infojoin.html", 1))
                aux3 = insFld(aux2, gFld("제증명신청"     ,                  "", 0))
                  aux4 = insFld(aux3, gFld("재직증명서 신청",                "helpMain.jsp?param=A15Certi.html", 1))
                  aux4 = insFld(aux3, gFld("경력증명서 신청",                "helpMain.jsp?param=A19Career.html", 1))
                  aux4 = insFld(aux3, gFld("원천징수영수증 신청",            "helpMain.jsp?param=A18Deduct.html", 1))
              aux2 = insFld(aux1, gFld("Job Description 관리",               "", 0))
                aux3 = insFld(aux2, gFld("Job Description",                  "", 0))
                  aux4 = insFld(aux3, gFld("Job Matrix",                     "helpMain.jsp?param=J01JobMatrix_m.html", 1))
                  aux4 = insFld(aux3, gFld("Job Profile",                    "helpMain.jsp?param=J01JobProfile_m.html", 1))
                  aux4 = insFld(aux3, gFld("Competency Requirements",        "helpMain.jsp?param=J01CompetencyReq_m.html", 1))
                  aux4 = insFld(aux3, gFld("Job Unit별 KSEA",                "helpMain.jsp?param=J01JobUnitKSEA_m.html", 1))
                  aux4 = insFld(aux3, gFld("Job Process",                    "helpMain.jsp?param=J01JobProcess_m.html", 1))
                  aux4 = insFld(aux3, gFld("Job Leveling Sheet",             "helpMain.jsp?param=J01LevelingSheet_m.html", 1))
                aux3 = insFld(aux2, gFld("Competency List",                  "helpMain.jsp?param=J02CompetencyList.html", 1))
                aux3 = insFld(aux2, gFld("팀원 Job Description 조회",        "", 0))
                  aux4 = insFld(aux3, gFld("Job Matrix",                     "helpMain.jsp?param=J01JobMatrix.html", 1))
                  aux4 = insFld(aux3, gFld("Job Profile",                    "helpMain.jsp?param=J01JobProfile.html", 1))
                  aux4 = insFld(aux3, gFld("Competency Requirements",        "helpMain.jsp?param=J01CompetencyReq.html", 1))
                  aux4 = insFld(aux3, gFld("Job Unit별 KSEA",                "helpMain.jsp?param=J01JobUnitKSEA.html", 1))
                  aux4 = insFld(aux3, gFld("Job Process",                    "helpMain.jsp?param=J01JobProcess.html", 1))
                  aux4 = insFld(aux3, gFld("Job Leveling Sheet",             "helpMain.jsp?param=J01LevelingSheet.html", 1))
                aux3 = insFld(aux2, gFld("Job Description 조회ㆍ수정ㆍ생성", "", 0))
                  aux4 = insFld(aux3, gFld("Job 생성",                       "", 0))
                    aux5 = insFld(aux4, gFld("Job Matrix",                   "helpMain.jsp?param=J03JobMatrix_B.html", 1))
                    aux5 = insFld(aux4, gFld("Job Profile 생성",             "helpMain.jsp?param=J03JobProfile_B.html", 1))
                    aux5 = insFld(aux4, gFld("Competency Requirements 생성", "helpMain.jsp?param=J03CompetencyReq_B.html", 1))
                    aux5 = insFld(aux4, gFld("Job Unit별 KSEA 생성",         "helpMain.jsp?param=J03JobUnitKSEA_B.html", 1))
                    aux5 = insFld(aux4, gFld("Job Process 생성",             "helpMain.jsp?param=J03JobProcess_B.html", 1))
                    aux5 = insFld(aux4, gFld("Job Leveling Sheet 조회",      "helpMain.jsp?param=J03LevelingSheet_B.html", 1))
                  aux4 = insFld(aux3, gFld("Job 수정,삭제",                  "", 0))
                    aux5 = insFld(aux4, gFld("Job Matrix",                   "helpMain.jsp?param=J03JobMatrix_C.html", 1))
                    aux5 = insFld(aux4, gFld("Job Profile 조회",             "helpMain.jsp?param=J03JobProfile_R.html", 1))
                    aux5 = insFld(aux4, gFld("Job Profile 수정",             "helpMain.jsp?param=J03JobProfile_C.html", 1))
                    aux5 = insFld(aux4, gFld("Competency Requirements 수정", "helpMain.jsp?param=J03CompetencyReq_C.html", 1))
                    aux5 = insFld(aux4, gFld("Job Unit별 KSEA 수정",         "helpMain.jsp?param=J03JobUnitKSEA_C.html", 1))
                    aux5 = insFld(aux4, gFld("Job Process 수정",             "helpMain.jsp?param=J03JobProcess_C.html", 1))
                    aux5 = insFld(aux4, gFld("Job Leveling Sheet 수정",      "helpMain.jsp?param=J03LevelingSheet_C.html", 1))
                  aux4 = insFld(aux3, gFld("대분류",                         "", 0))
                    aux5 = insFld(aux4, gFld("Job Matrix",                   "helpMain.jsp?param=J04JobMatrix.html", 1))
                    aux5 = insFld(aux4, gFld("대분류 생성",                  "helpMain.jsp?param=J04Dsort_B.html", 1))
                    aux5 = insFld(aux4, gFld("대분류 조회",                  "helpMain.jsp?param=J04Dsort_R.html", 1))
                    aux5 = insFld(aux4, gFld("Objective 수정",               "helpMain.jsp?param=J04Objective_C.html", 1))
                    aux5 = insFld(aux4, gFld("대분류명 수정",                "helpMain.jsp?param=J04DsortName_C.html", 1))
                    aux5 = insFld(aux4, gFld("대분류 삭제",                  "helpMain.jsp?param=J04Dsort_D.html", 1))
                  aux4 = insFld(aux3, gFld("Job 이동",                       "", 0))
                    aux5 = insFld(aux4, gFld("Job Matrix",                   "helpMain.jsp?param=J05JobMatrix.html", 1))
                    aux5 = insFld(aux4, gFld("Job 이동",                     "helpMain.jsp?param=J05JobMove.html", 1))


            <!-- 부서인사정보 ---------------------------------------------------------------------------------->
            aux1 = insFld(aux0, gFld("부서인사정보",                         "", 0))
              aux2 = insFld(aux1, gFld("사원인사정보",                       "helpMain.jsp?param=X03PersonInfo.html", 1))
              aux2 = insFld(aux1, gFld("조직통계",                           "helpMain.jsp?param=X04Statistics.html", 1))
                aux3 = insFld(aux2, gFld("복리후생수혜현황",                 "helpMain.jsp?param=F51DeptWelfare.html", 1))


            <!-- HR결재함 -------------------------------------------------------------------------------------->
            aux1 = insFld(aux0, gFld("HR결재함",                             "helpMain.jsp?param=Approval.html", 1))

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
