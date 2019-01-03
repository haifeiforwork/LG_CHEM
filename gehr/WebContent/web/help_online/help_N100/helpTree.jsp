<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

//  사용방법안내 Open시 해당메뉴를 열어줘야하는경우
    String      mName  = request.getParameter("param");
    String      mKey   = mName.substring(0,3);
    int         index1 = 0;
    int         index2 = 0;
    
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
}
//-->
</script>

<style type="text/css">
<!--
body {
    scrollbar-face-color: #FAF9F3; 
    scrollbar-shadow-color: #C7CFFF; 
    scrollbar-highlight-color: #C7CFFF; 
    scrollbar-3dlight-color: #ffffff; 
    scrollbar-darkshadow-color: #ffffff;
    scrollbar-track-color: #ffffff; 
    scrollbar-arrow-color: #C7CFFF
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


