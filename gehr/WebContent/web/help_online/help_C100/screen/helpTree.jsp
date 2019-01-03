<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

//  사용방법안내 Open시 해당메뉴를 열어줘야하는경우
    String      mName  = request.getParameter("param");
    String      mKey   = mName.substring(0,3);
    int         index1 = 0;
    int         index2 = 0;
    int         index3 = 0;
    
    if( mKey.equals("A16") ) {
        index1 = 0;
        index2 = 0;
    } else if( mKey.equals("A04") || mKey.equals("A10") || mKey.equals("A13") ) {
        index1 = 1;
        index2 = 2;
    } else if( mKey.equals("B03") || mKey.equals("B04") ) {
        index1 = 1;
        index2 = 27;
    } else if( mKey.equals("E14") || mKey.equals("E18") || mKey.equals("E20") || mKey.equals("E22") ) {
        index1 = 1;
        index2 = 31;
    } else if( mKey.equals("con") ) {          //tmenu.jsp
        index1 = 1;
        index2 = 41;
        index3 = 70;
    } else if( mKey.equals("A12") || mKey.equals("A17") ) {
        index1 = 41;
        index2 = 42;
    } else if( mKey.equals("A03") || mKey.equals("A14") || mKey.equals("E12") ) {
        index1 = 41;
        index2 = 45;
    } else if( mKey.equals("D01") || mKey.equals("D03") ) {
        index1 = 41;
        index2 = 47;
    } else if( mKey.equals("C02") ) {
        index1 = 41;
        index2 = 50;
    } else if( mKey.equals("E01") || mKey.equals("E02") || mKey.equals("E04") || mKey.equals("E05") || 
               mKey.equals("E06") || mKey.equals("E10") || mKey.equals("E15") || mKey.equals("E17") || 
               mKey.equals("E19") || mKey.equals("E21") || mKey.equals("E25") ) {
        index1 = 41;
        index2 = 53;
    } else if( mKey.equals("A15") || mKey.equals("A18") ) {
        index1 = 41;
        index2 = 67;
    } else if( mKey.equals("J01") ) {
//      Job Description 조회(팀장)
        if( mName.equals("J01JobMatrix.html")     || mName.equals("J01JobProfile.html")      || 
            mName.equals("J01CompetencyReq.html") || mName.equals("J01CompetencyReq_d.html") ||
            mName.equals("J01JobProcess.html")    || mName.equals("J01JobUnitKSEA.html")     || 
            mName.equals("J01LevelingSheet.html") ) {
            index1 = 70;
            index2 = 79;
//      Job Description 조회(개인)
        } else if( mName.equals("J01JobMatrix_m.html") || mName.equals("J01JobProfile_m.html")      || 
            mName.equals("J01CompetencyReq_m.html")    || mName.equals("J01CompetencyReq_d_m.html") ||
            mName.equals("J01JobProcess_m.html")       || mName.equals("J01JobUnitKSEA_m.html")     || 
            mName.equals("J01LevelingSheet_m.html") ) {
            index1 = 70;
            index2 = 71;
        }
//  Competency List
    } else if( mKey.equals("J02") ) {  
        index1 = 70;
        index2 = 0;
    } else if( mKey.equals("J03") ) {
//      Job Description 생성
        if( mName.equals("J03JobMatrix_B.html")     || mName.equals("J03JobProfile_B.html")   || 
            mName.equals("J03CompetencyReq_B.html") || mName.equals("J03JobUnitKSEA_B.html")  ||
            mName.equals("J03JobProcess_B.html")    || mName.equals("J03LevelingSheet_B.html") ) {
            index1 = 70;
            index2 = 86;
            index3 = 87;
//      Job Description 조회, 수정
        } else if( mName.equals("J03JobMatrix_C.html") || mName.equals("J03JobProfile_R.html")    || 
            mName.equals("J03JobProfile_C.html")       || mName.equals("J03CompetencyReq_C.html") ||
            mName.equals("J03JobUnitKSEA_C.html")      || mName.equals("J03JobProcess_C.html")    || 
            mName.equals("J03LevelingSheet_C.html") ) {
            index1 = 70;
            index2 = 86;
            index3 = 94;
        }
//  대분류 생성
    } else if( mKey.equals("J04") ) {
        index1 = 70;
        index2 = 86;
        index3 = 102;
//  Job 이동
    } else if( mKey.equals("J05") ) {
        index1 = 70;
        index2 = 86;
        index3 = 109;
    }
%>

<html>
<head>
<title>ESS 사용방법안내</title>
<link rel="stylesheet" type="text/css" href="/help_online/images/skin/style.css">
<script src="/help_online/images/tree/MakeTree_help.js"></script>
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
<tr><td valign="top">
	<table width="100%" height="25" cellspacing="0" cellpadding="0" border="0"><tr>
	<td width=10>&nbsp;</td>
	<td>
	
	<!--- 디렉토리 폴더 보기 -------------------------------------->
	<script language="JavaScript">
		aux0 = gFld("사용방법안내 목차", "", 0)
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////
		aux1 = insFld(aux0, gFld("MY HR 정보",              "", 0))
		
		aux2 = insFld(aux1, gFld("개인사항",                 "", 0))
		aux3 = insFld(aux2, gFld("개인인적사항",             "", 0))
		aux3 = insFld(aux2, gFld("학력사항",                 "", 0))
		aux3 = insFld(aux2, gFld("주소",                     "helpMain.jsp?param=A13Address.html", 1))
		aux3 = insFld(aux2, gFld("가족사항",                 "helpMain.jsp?param=A04FamilyList.html", 1))
		aux3 = insFld(aux2, gFld("발령사항",                 "", 0))
		aux3 = insFld(aux2, gFld("포상",                     "", 0))
		aux3 = insFld(aux2, gFld("징계",                     "", 0))
		aux3 = insFld(aux2, gFld("자격면허",                 "", 0))
		aux3 = insFld(aux2, gFld("근무경력",                 "", 0))
		aux3 = insFld(aux2, gFld("나의연봉",                 "helpMain.jsp?param=A10AnnualList.html", 1))
		aux3 = insFld(aux2, gFld("연봉계약서",               "", 0))
		
		aux2 = insFld(aux1, gFld("급여",                     "", 0))
		aux3 = insFld(aux2, gFld("월급여",                   "", 0))
		aux3 = insFld(aux2, gFld("연급여",                   "", 0))
		aux3 = insFld(aux2, gFld("채권가압류",               "", 0))
		aux3 = insFld(aux2, gFld("연말정산",                 "", 0))
		aux3 = insFld(aux2, gFld("퇴직금 시뮬레이션",         "", 0))

		aux2 = insFld(aux1, gFld("근태",                      "", 0))
		aux3 = insFld(aux2, gFld("근태 실적정보",             "", 0))
		aux3 = insFld(aux2, gFld("휴가 실적정보",             "", 0))

		aux2 = insFld(aux1, gFld("교육",                     "", 0))
		aux3 = insFld(aux2, gFld("교육이수정보",              "", 0))
		aux3 = insFld(aux2, gFld("어학능력",                  "", 0))
		aux3 = insFld(aux2, gFld("수강신청현황",              "", 0))
		
		aux2 = insFld(aux1, gFld("인재개발",                  "", 0))
		aux3 = insFld(aux2, gFld("평가결과",                  "", 0))
		aux3 = insFld(aux2, gFld("인재개발협의결과",           "helpMain.jsp?param=B03DevelopList.html", 1))
		aux3 = insFld(aux2, gFld("진급자격요건 시뮬레이션",    "helpMain.jsp?param=B04Promotion.html", 1))
		
		aux2 = insFld(aux1, gFld("복리후생",                  "", 0))
		aux3 = insFld(aux2, gFld("주택지원",                  "", 0))
		aux3 = insFld(aux2, gFld("국민연금",                  "", 0))
		aux3 = insFld(aux2, gFld("개인연금",                  "", 0))
		aux3 = insFld(aux2, gFld("우리사주 보유현황",         "helpMain.jsp?param=E14Stock.html", 1))
		aux3 = insFld(aux2, gFld("의료비 지원내역",           "helpMain.jsp?param=E18Hospital.html", 1))
		aux3 = insFld(aux2, gFld("경조금 지원내역",           "helpMain.jsp?param=E20Congra.html", 1))
		aux3 = insFld(aux2, gFld("종합검진 실시내역",         "", 0))
		aux3 = insFld(aux2, gFld("장학자금ㆍ입학축하금 지원내역", "helpMain.jsp?param=E22Expense.html", 1))
		aux3 = insFld(aux2, gFld("동호회 가입현황",           "", 0))
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////
		aux1 = insFld(aux0, gFld("신청",                     "", 0))
		
		aux2 = insFld(aux1, gFld("개인사항",                  "", 0))
		aux3 = insFld(aux2, gFld("가족사항추가입력",          "helpMain.jsp?param=A12Family.html", 1))
		aux3 = insFld(aux2, gFld("자격면허등록",              "helpMain.jsp?param=A17Licence.html", 1))
		
		aux2 = insFld(aux1, gFld("급여",                      "", 0))
		aux3 = insFld(aux2, gFld("계좌정보",                  "helpMain.jsp?param=A03Account.html", 1))
<%
//  근태 메뉴를 임원일경우 보이지 않는다. 2002.06.30. 요청자 : 김도현차장님
    if( (user.e_persk).equals("11") || (user.e_persk).equals("12") 
                                    || (user.e_persk).equals("13") || (user.e_persk).equals("14") ){
%>
		aux2 = insFld(aux1, gFld("근태",                      "", 0))
		aux3 = insFld(aux2, gFld("초과근무(OTㆍ특근)",         "", 0))
		aux3 = insFld(aux2, gFld("휴가",                      "", 0))
<%
    } else {
%>
		aux2 = insFld(aux1, gFld("근태",                      "", 0))
		aux3 = insFld(aux2, gFld("초과근무(OTㆍ특근)",         "helpMain.jsp?param=D01OT.html", 1))
		aux3 = insFld(aux2, gFld("휴가",                      "helpMain.jsp?param=D03Vocation.html", 1))
<%
    }
//  근태 메뉴를 임원일경우 보이지 않는다. 2002.06.30. 요청자 : 김도현차장님
%>
		aux2 = insFld(aux1, gFld("교육",                      "", 0))
		aux3 = insFld(aux2, gFld("교육과정 안내ㆍ신청",        "helpMain.jsp?param=C02Curri.html", 1))
		aux3 = insFld(aux2, gFld("사내어학검정",               "", 0))
		
		aux2 = insFld(aux1, gFld("복리후생",                   "", 0))
		aux3 = insFld(aux2, gFld("건강보험 자격변경",          "helpMain.jsp?param=E01Medicare.html", 1))
		aux3 = insFld(aux2, gFld("건강보험 정보변경",          "helpMain.jsp?param=E02Medicare.html", 1))
		aux3 = insFld(aux2, gFld("국민연금 자격변경",          "helpMain.jsp?param=E04Pension.html", 1))
		aux3 = insFld(aux2, gFld("주택자금 신규신청",          "helpMain.jsp?param=E05House.html", 1))
		aux3 = insFld(aux2, gFld("주택자금 상환신청",          "helpMain.jsp?param=E06Rehouse.html", 1))
		aux3 = insFld(aux2, gFld("개인연금",                   "helpMain.jsp?param=E10Personal.html", 1))
		aux3 = insFld(aux2, gFld("의료비",                     "helpMain.jsp?param=E17Hospital.html", 1))
		aux3 = insFld(aux2, gFld("경조금",                     "helpMain.jsp?param=E19Congra.html", 1))
		aux3 = insFld(aux2, gFld("재해신청",                   "helpMain.jsp?param=E19Disaster.html", 1))
		aux3 = insFld(aux2, gFld("장학자금",                   "helpMain.jsp?param=E21Expense.html", 1))
		aux3 = insFld(aux2, gFld("입학축하금",                 "helpMain.jsp?param=E21Entrance.html", 1))
		aux3 = insFld(aux2, gFld("종합검진",                   "helpMain.jsp?param=E15General.html", 1))
		aux3 = insFld(aux2, gFld("동호회 가입",                "helpMain.jsp?param=E25Infojoin.html", 1))
		
		aux2 = insFld(aux1, gFld("제 증명신청",                "", 0))
		aux3 = insFld(aux2, gFld("재직증명서 신청",            "helpMain.jsp?param=A15Certi.html", 1))
		aux3 = insFld(aux2, gFld("근로소득·갑근세 원천징수 영수증 신청", "helpMain.jsp?param=A18Deduct.html", 1))
		
<!-- Job Description 관리 추가 2003.05.29 -->
		aux1 = insFld(aux0, gFld("Job Description 관리",      "", 0))
		
		aux2 = insFld(aux1, gFld("Job Description",           "", 0))
		aux3 = insFld(aux2, gFld("Job Matrix",                "helpMain.jsp?param=J01JobMatrix_m.html", 1))
		aux3 = insFld(aux2, gFld("Job Profile",               "helpMain.jsp?param=J01JobProfile_m.html", 1))
		aux3 = insFld(aux2, gFld("Competency Requirements",   "helpMain.jsp?param=J01CompetencyReq_m.html", 1))
		aux3 = insFld(aux2, gFld("Job Unit별 KSEA",           "helpMain.jsp?param=J01JobUnitKSEA_m.html", 1))
		aux3 = insFld(aux2, gFld("Job Process",               "helpMain.jsp?param=J01JobProcess_m.html", 1))
		aux3 = insFld(aux2, gFld("Job Leveling Sheet",        "helpMain.jsp?param=J01LevelingSheet_m.html", 1))

		aux2 = insFld(aux1, gFld("Competency List",           "helpMain.jsp?param=J02CompetencyList.html", 1))

		aux2 = insFld(aux1, gFld("팀원 Job Description 조회",  "", 0))
		aux3 = insFld(aux2, gFld("Job Matrix",                "helpMain.jsp?param=J01JobMatrix.html", 1))
		aux3 = insFld(aux2, gFld("Job Profile",               "helpMain.jsp?param=J01JobProfile.html", 1))
		aux3 = insFld(aux2, gFld("Competency Requirements",   "helpMain.jsp?param=J01CompetencyReq.html", 1))
		aux3 = insFld(aux2, gFld("Job Unit별 KSEA",           "helpMain.jsp?param=J01JobUnitKSEA.html", 1))
		aux3 = insFld(aux2, gFld("Job Process",               "helpMain.jsp?param=J01JobProcess.html", 1))
		aux3 = insFld(aux2, gFld("Job Leveling Sheet",        "helpMain.jsp?param=J01LevelingSheet.html", 1))

    aux2 = insFld(aux1, gFld("Job Description 조회ㆍ수정ㆍ생성",  "", 0))
		aux3 = insFld(aux2, gFld("Job 생성",                  "", 0))
		aux4 = insFld(aux3, gFld("Job Matrix",                "helpMain.jsp?param=J03JobMatrix_B.html", 1))
		aux4 = insFld(aux3, gFld("Job Profile 생성",          "helpMain.jsp?param=J03JobProfile_B.html", 1))
		aux4 = insFld(aux3, gFld("Competency Requirements 생성",   "helpMain.jsp?param=J03CompetencyReq_B.html", 1))
		aux4 = insFld(aux3, gFld("Job Unit별 KSEA 생성",      "helpMain.jsp?param=J03JobUnitKSEA_B.html", 1))
		aux4 = insFld(aux3, gFld("Job Process 생성",          "helpMain.jsp?param=J03JobProcess_B.html", 1))
		aux4 = insFld(aux3, gFld("Job Leveling Sheet 조회",   "helpMain.jsp?param=J03LevelingSheet_B.html", 1))

		aux3 = insFld(aux2, gFld("Job 수정,삭제",             "", 0))
		aux4 = insFld(aux3, gFld("Job Matrix",                "helpMain.jsp?param=J03JobMatrix_C.html", 1))
		aux4 = insFld(aux3, gFld("Job Profile 조회",          "helpMain.jsp?param=J03JobProfile_R.html", 1))
		aux4 = insFld(aux3, gFld("Job Profile 수정",          "helpMain.jsp?param=J03JobProfile_C.html", 1))
		aux4 = insFld(aux3, gFld("Competency Requirements 수정",   "helpMain.jsp?param=J03CompetencyReq_C.html", 1))
		aux4 = insFld(aux3, gFld("Job Unit별 KSEA 수정",      "helpMain.jsp?param=J03JobUnitKSEA_C.html", 1))
		aux4 = insFld(aux3, gFld("Job Process 수정",          "helpMain.jsp?param=J03JobProcess_C.html", 1))
		aux4 = insFld(aux3, gFld("Job Leveling Sheet 수정",   "helpMain.jsp?param=J03LevelingSheet_C.html", 1))

		aux3 = insFld(aux2, gFld("대분류",                    "", 0))
		aux4 = insFld(aux3, gFld("Job Matrix",                "helpMain.jsp?param=J04JobMatrix.html", 1))
		aux4 = insFld(aux3, gFld("대분류 생성",               "helpMain.jsp?param=J04Dsort_B.html", 1))
		aux4 = insFld(aux3, gFld("대분류 조회",               "helpMain.jsp?param=J04Dsort_R.html", 1))
		aux4 = insFld(aux3, gFld("Objective 수정",            "helpMain.jsp?param=J04Objective_C.html", 1))
		aux4 = insFld(aux3, gFld("대분류명 수정",             "helpMain.jsp?param=J04DsortName_C.html", 1))
		aux4 = insFld(aux3, gFld("대분류 삭제",               "helpMain.jsp?param=J04Dsort_D.html", 1))

		aux3 = insFld(aux2, gFld("Job 이동",                  "", 0))
		aux4 = insFld(aux3, gFld("Job Matrix",                "helpMain.jsp?param=J05JobMatrix.html", 1))
		aux4 = insFld(aux3, gFld("Job 이동",                  "helpMain.jsp?param=J05JobMove.html", 1))

		//////////////////////////////////////////////////////////////////////////////////////////////////////////
		aux1 = insFld(aux0, gFld("결재진행현황",              "helpMain.jsp?param=A16Appl.html", 1))
		
<% 
    if(user.e_is_chief.equals("Y")) {             // 간사인 경우만 보여준다.
%>
		//////////////////////////////////////////////////////////////////////////////////////////////////////////
		aux1 = insFld(aux0, gFld("동호회 간사 결재",           "", 0))
<% 
    }
%>
		initializeDocument();
	</script>
	<!--- 디렉토리 폴더 보기 -------------------------------------->
	</td>
	</tr></table>
</td></td>
</table>
</body>
</html>	


