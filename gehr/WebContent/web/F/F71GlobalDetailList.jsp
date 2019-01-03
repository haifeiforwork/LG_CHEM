<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : Global육성POOL                                              */
/*   Program Name : Global육성POOL 각각의 상세화면                              */
/*   Program ID   : F71GlobalDetailList.jsp                                     */
/*   Description  : Global육성POOL 각각의 상세화면 조회를 위한 jsp 파일         */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-03-16 LSA                                              */
/*                  2008-08-11 @v1.2 교육과정 과정상세정보 링크수정             */
/*   Update       :                                                             */
/*                  2014-02-07 C20140204_80557  어학 이라는 표현을  외국어 로 변경*/
/*                  2014-02-10 C20140210_84209  구분추가*/
/*                 : 2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user    = (WebUserData)session.getAttribute("user");                    //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
    String gubun        = WebUtil.nvl(request.getParameter("hdn_gubun"));           //구분값.
    String checkYN      = WebUtil.nvl(request.getParameter("chck_yeno"));           //하위부서여부.
    String paramA       = WebUtil.nvl(request.getParameter("hdn_paramA"));          //조직ID
    String paramB       = WebUtil.nvl(request.getParameter("hdn_paramB"));          //조직코드명
    String paramC       = WebUtil.nvl(request.getParameter("hdn_paramC"));          //사원서브그룹
    String paramD       = WebUtil.nvl(request.getParameter("hdn_paramD"));          //직위명

    Vector F71GlobalDetailListData_vt  = (Vector)request.getAttribute("F71GlobalDetailListData_vt");    //내용
    String Title [];
    Title = new String [18];
    Title[ 1]="HPI                  ";
    Title[ 2]="지역전문가           ";
    Title[ 3]="HPI&지역전문가       ";
    Title[ 4]="육성MBA              ";
    Title[ 5]="HPI&육성MBA          ";
    Title[ 6]="법인장교육이수자     ";
    Title[ 7]="확보MBA              ";
    Title[ 8]="해외학위자           ";
    Title[ 9]="R&D박사              ";
    Title[10]="국내외국인근무자     ";
    Title[11]="중국지역경험자       ";
    Title[12]="중국外지역경험자     ";
    Title[13]="TOEIC 800점 이상자   ";
    Title[14]="HSK 5등급 이상자     ";
    Title[15]="LGA 3.5점 이상자     ";
    Title[16]="중국어 전공자        ";
    Title[17]="영어&중국어 가능자   ";
%>

<SCRIPT LANGUAGE="JavaScript">
<!--

//목록으로 가기.
function do_list(){
    history.back();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_gubun.value  = "<%= gubun %>";      //구분값
    frm.hdn_deptId.value = "<%= deptId %>";     //부서코드
    frm.chck_yeno.value  = "<%= checkYN %>";    //하위부서여부
    frm.hdn_paramA.value = "<%= paramA %>";     //조직ID
    frm.hdn_paramB.value = "<%= paramB %>";     //조직코드명
    frm.hdn_paramC.value = "<%= paramC %>";     //사원서브그룹
    frm.hdn_paramD.value = "<%= paramD %>";     //직위명
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F71GlobalDetailListSV";
    frm.target = "ifHidden";
    frm.submit();
}
//인사기록부발행
function go_Insaprint(pernr){

    window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=no,resizable=no,width=1010,height=662,left=0,top=2");

    document.form2.pernr.value = pernr;
    document.form2.jobid2.value = "printGlobal";
    document.form2.target = "essPrintWindow";
    document.form2.action = "<%= WebUtil.JspURL %>common/printFrame_insa.jsp";
    document.form2.method = "post";
    document.form2.submit();
}
function f_eduDetail(pernr) {

    var frm = document.form3;
    frm.jobid.value = "detail";
    frm.pernr.value = pernr;

    small_window=window.open("","essEDUWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,scrollbars=yes,width=800,height=600,left=0,top=0");
    small_window.focus();

    frm.action = "<%= WebUtil.ServletURL %>hris.C.C04HrdLearnDetailSV_m";
    frm.target = "essEDUWindow";
    frm.submit();


}
//-->
</SCRIPT>

<html>
<head>
<title>MSS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form3" method="post">
  <input type="hidden" name="jobid"     value="">
  <input type="hidden" name="pernr" value="">
  <input type="hidden" name="IM_SORTKEY" value="BEGDA">
  <input type="hidden" name="IM_SORTDIR" value="DES">
</form>
<form name="form2" method="post">
  <input type="hidden" name="jobid"     value="">
  <input type="hidden" name="jobid2"   value="printGlobal">
  <input type="hidden" name="licn_code" value="">
  <input type="hidden" name="pernr" value="">
  <input type="hidden" name="Screen" value="Y"><!--C20140210_84209  구분추가-->
</form>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">

<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="chck_yeno"   value="">
<input type="hidden" name="hdn_paramA"  value="">
<input type="hidden" name="hdn_paramB"  value="">
<input type="hidden" name="hdn_paramC"  value="">
<input type="hidden" name="hdn_paramD"  value="">

<table width="780" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="764" border="0" cellpadding="0" cellspacing="0" align="left">
        <tr>
          <td height="5" ></td>
        </tr>
        <tr>
          <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif"><%=Title[Integer.parseInt(gubun)]%> 상세현황</td>
        </tr>
      </table>
    </td>
  </tr>

  <tr>
    <td height="10" >&nbsp;</td>
  </tr>
</table>

<%
    if ( F71GlobalDetailListData_vt != null && F71GlobalDetailListData_vt.size() > 0 ) {
%>
<table width="900" border="0" cellspacing="0" cellpadding="0" align="left">
<%  //comment
    if ( gubun.equals("17") ) {  //영어&중국어 가능자
%>
  <tr>
    <td width="16" nowrap>&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
	      <td width="50%" class="td09">
	        &nbsp;※ 영어:TOEIC 700점 이상 or LGA 3 이상, 중국어: HSK 5등급 이상 or 중국어 전공자&nbsp;
          </td>
	      <td ></td>
	    </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
  </tr>
<%  }  %>

  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
	      <td width="50%" class="td09">
	        &nbsp;부서명 : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
            &nbsp;&nbsp;<a href="javascript:excelDown();"><img src="<%= WebUtil.ImageURL %>btn_EXCELdownload.gif" border="0" align="absmiddle"></a>
          </td>
	      <td width="50%" class="td08"><총 <%=F71GlobalDetailListData_vt.size()%> 건>&nbsp;</td>
	    </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="0" cellpadding="0" cellspacing="1" class="table02">
        <tr>
          <td class="td03" rowspan=2 nowrap>사번</td>
          <td class="td03" rowspan=2 nowrap>이름</td>
          <td class="td03" rowspan=2 nowrap>소속명</td>
          <td class="td03" rowspan=2 nowrap>신분</td>
          <td class="td03" rowspan=2 nowrap>직위/직급호칭</td><!-- [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/ -->
          <td class="td03" rowspan=2 nowrap>직책</td>
          <td class="td03" rowspan=2 nowrap>직급</td>
          <td class="td03" rowspan=2 nowrap>호봉</td>
          <td class="td03" rowspan=2 nowrap>년차</td>
          <td class="td03" rowspan=2 nowrap>직무</td>
          <td class="td03" rowspan=2 nowrap>입사일</td>
          <td class="td03" rowspan=2 nowrap>근속</td>
          <td class="td03" rowspan=2 nowrap>연령</td>
<%
    //01:HPI
    //02:지역전문가
    //03:HPI&지역전문가
    //04:육성MBA
    //05:HPI&육성MBA
    //06:법인장교육이수자
    //07:확보MBA
    //08:해외학위자
    //09:R&D박사
    //10:국내외국인근무자
    //11:중국지역경험자
    //12:중국外지역경험자
    //13:TOEIC 800점 이상자
    //14:HSK 5등급 이상자
    //15:LGA 3.5점 이상자
    //16:중국어 전공자
    //17:영어&중국어 가능자

   if (gubun.equals("02") ||gubun.equals("03")||gubun.equals("06") ) {
%>
          <td class="td03" rowspan=2 nowrap>연수지역</td>
<%
   } else if (gubun.equals("04") ||gubun.equals("05") ) {
%>
          <td class="td03" rowspan=2 nowrap>교육내용</td>
<%
   } else if ( gubun.equals("07") || gubun.equals("08") ||gubun.equals("09") ) {
        if (gubun.equals("08") ||gubun.equals("09")  ) {
%>
          <td class="td03" rowspan=2 nowrap>구분</td>
<%
        }
%>
          <td class="td03" rowspan=2 nowrap>국가</td>
<%
   } else if (gubun.equals("10")  ) {
%>
          <td class="td03" rowspan=2 nowrap>국적</td>
          <td class="td03" rowspan=2 nowrap>성별</td>
          <td class="td03" rowspan=2 nowrap>학력</td>
          <td class="td03" rowspan=2 nowrap>비고</td>
<%
   } else if (gubun.equals("11")  ) {
%>
          <td class="td03" rowspan=2 nowrap>중국근무지</td>
          <td class="td03" rowspan=2 nowrap>중국<br>근무년수</td>
<%
   } else if (gubun.equals("12")  ) {
%>
          <td class="td03" rowspan=2 nowrap>근무지</td>
          <td class="td03" rowspan=2 nowrap>근무년수</td>
<%
   }
%>
          <td class="td03" colspan=2 nowrap>학력</td>
          <td class="td03" colspan=4 nowrap>외국어</td><!-- C20140204_80557 어학 을  외국어로 변경-->
          <td class="td03" colspan=3 nowrap>평가</td>
          <td class="td03" colspan=3 rowspan=2 nowrap>교육<br>상세</td>
        </tr>
        <tr>
          <td class="td03" nowrap>대학교<br>(대학원)</td>
          <td class="td03" nowrap>전공<br>(전공)</td>
          <td class="td03" nowrap>TOEIC</td>
          <td class="td03" nowrap>JPT</td>
          <td class="td03" nowrap>HSK</td>
          <td class="td03" nowrap>LGA</td>
          <td class="td03" nowrap>직전<br>1개년</td>
          <td class="td03" nowrap>직전<br>2개년</td>
          <td class="td03" nowrap>직전<br>3개년</td>
        </tr>
<%
        //내용.
        for( int i = 0; i < F71GlobalDetailListData_vt.size(); i++ ){
            F71GlobalDetailListData data = (F71GlobalDetailListData)F71GlobalDetailListData_vt.get(i);
%>
        <tr align="center">
          <td class="td09" nowrap>&nbsp;<a href="javascript:go_Insaprint('<%= DataUtil.encodeEmpNo(data.PERNR) %>');"><font color=blue><%= data.PERNR %></font></a>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.ENAME %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.STEXT %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.PTEXT %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.TITEL %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.TITL2 %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.TRFGR %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.TRFST.equals("00") ? "" : data.TRFST %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.VGLST %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.STELL_TEXT %>&nbsp;</td>
          <td class="td04" nowrap>&nbsp;<%= (data.DAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT) %>&nbsp;</td>
          <td class="td04" nowrap>&nbsp;<%= data.GNSOK %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.OLDS %>&nbsp;</td>      <!--연령-->
<%
   if (gubun.equals("02") ||gubun.equals("03") ) { //02:지역전문가 ,03:HPI&지역전문가,06:법인장교육이수자
%>
          <td class="td09" nowrap><%= WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.REGI_SLAND),data.REGI_SLAND) %><%=data.REGI_YEAR.equals("") ? "" : "("+data.REGI_YEAR+")" %>&nbsp;</td> <!--연수지역-->
<%
   } else if (gubun.equals("04") ||gubun.equals("05") ) { //04:육성MBA,05:HPI&육성MBA
%>
          <td class="td09" nowrap>
          <%= data.MBA_YEAR1 %> <%= WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0003"),data.MBA_DETAI1) %> <%= data.MBA_SCHOO1.equals("") ? "" : "("+data.MBA_SCHOO1+")" %>
          <%= data.MBA_YEAR2.equals("") ? "" : "<br>"+data.MBA_YEAR2 %> <%= WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0003"),data.MBA_DETAI2) %> <%= data.MBA_SCHOO2.equals("") ? "" : "("+data.MBA_SCHOO2+")" %>
          <%= data.MBA_YEAR3.equals("") ? "" : "<br>"+data.MBA_YEAR3 %> <%= WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0003"),data.MBA_DETAI3) %> <%= data.MBA_SCHOO3.equals("") ? "" : "("+data.MBA_SCHOO3+")" %>
          <%= data.MBA_YEAR4.equals("") ? "" : "<br>"+data.MBA_YEAR4 %> <%= WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0003"),data.MBA_DETAI4) %> <%= data.MBA_SCHOO4.equals("") ? "" : "("+data.MBA_SCHOO4+")" %>
          <%= data.MBA_YEAR5.equals("") ? "" : "<br>"+data.MBA_YEAR5 %> <%= WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0003"),data.MBA_DETAI5) %> <%= data.MBA_SCHOO5.equals("") ? "" : "("+data.MBA_SCHOO5+")" %>
          &nbsp;</td><!--교육내용-->
<%
   } else if (gubun.equals("06") ) {  //06:법인장교육이수자
%>
          <td class="td09" nowrap><%= data.CORP_AREA.equals("") ? "" : data.CORP_AREA %>&nbsp;</td> <!--연수지역-->
<%
   } else if ( gubun.equals("07") ) {  //07:확보MBA--------------------
%>
          <td class="td09" nowrap><%= data.MBA_SLAND.equals("") ? "" : WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.MBA_SLAND),data.MBA_SLAND) %>&nbsp;</td><!--확보MBA 국가-->
<%
   } else if ( gubun.equals("08") ) {  //08:해외학위자
%>
          <td class="td09" nowrap>
          <%= data.DEGR_DETAI1.equals("") ? "" : WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0006"),data.DEGR_DETAI1) %>
          <%= data.DEGR_DETAI2.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0006"),data.DEGR_DETAI2) %>
          <%= data.DEGR_DETAI3.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0006"),data.DEGR_DETAI3) %>&nbsp;</td><!--구분-->
          <td class="td09" nowrap>
          <%= data.DEGR_SLAND1.equals("") ? "" : WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.DEGR_SLAND1),data.DEGR_SLAND1) %>
          <%= data.DEGR_SLAND2.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.DEGR_SLAND2),data.DEGR_SLAND2) %>
          <%= data.DEGR_SLAND3.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.DEGR_SLAND3),data.DEGR_SLAND3) %>&nbsp;</td><!--국가-->
<%
   } else if (gubun.equals("09")  ) {  //09:R&D박사
%>
          <td class="td09" nowrap><%= data.RND_DETAI.equals("") ? "" : WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0005"),data.RND_DETAI) %>&nbsp;</td><!--구분-->
          <td class="td09" nowrap><%= data.RND_SLAND.equals("") ? "" : WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.RND_SLAND),data.RND_SLAND) %>&nbsp;</td><!--국가-->
<%
   } else if (gubun.equals("10")  ) {  //10:국내외국인근무자
%>
          <td class="td09" nowrap><%= WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.FORE_NATIO),data.FORE_NATIO) %>&nbsp;</td><!--국적-->
          <td class="td09" nowrap><%= data.FORE_GESCH %>&nbsp;</td><!--성별-->
          <td class="td09" nowrap><%= data.FORE_STEXT %>&nbsp;</td><!--학력-->
          <td class="td09" nowrap><%= data.FORE_INFO %>&nbsp;</td><!--비고-->
<%
   } else if (gubun.equals("11")  ) {  //11:중국지역경험자
%>
          <td class="td09" nowrap>
          <%= WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.CHIN_NAME1),data.CHIN_BTEXT1) %>&nbsp;<%= WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.CHIN_NAME1) %>
          <%= data.CHIN_BTEXT2.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.CHIN_NAME2),data.CHIN_BTEXT2) %><%= data.CHIN_BTEXT2.equals("") ? "" : "&nbsp;"+WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.CHIN_NAME2) %>
          <%= data.CHIN_BTEXT3.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.CHIN_NAME3),data.CHIN_BTEXT3) %><%= data.CHIN_BTEXT3.equals("") ? "" : "&nbsp;"+WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.CHIN_NAME3) %>
          <%= data.CHIN_BTEXT4.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.CHIN_NAME4),data.CHIN_BTEXT4) %><%= data.CHIN_BTEXT4.equals("") ? "" : "&nbsp;"+WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.CHIN_NAME4) %>
          <%= data.CHIN_BTEXT5.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.CHIN_NAME5),data.CHIN_BTEXT5) %><%= data.CHIN_BTEXT5.equals("") ? "" : "&nbsp;"+WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.CHIN_NAME5) %>
          &nbsp;</td><!--중국근무지-->
          <td class="td02" nowrap>
          <%= data.CHIN_BTEXT1.equals("") ? "" : data.CHIN_YEAR1 +"&nbsp;&nbsp;"%>
          <%= data.CHIN_BTEXT2.equals("") ? "" : "<BR>"+data.CHIN_YEAR2 +"&nbsp;&nbsp;" %>
          <%= data.CHIN_BTEXT3.equals("") ? "" : "<BR>"+data.CHIN_YEAR3 +"&nbsp;&nbsp;" %>
          <%= data.CHIN_BTEXT4.equals("") ? "" : "<BR>"+data.CHIN_YEAR4 +"&nbsp;&nbsp;" %>
          <%= data.CHIN_BTEXT5.equals("") ? "" : "<BR>"+data.CHIN_YEAR5 +"&nbsp;&nbsp;" %></td><!--중국근무년수-->
<%
   } else if (gubun.equals("12")  ) {  //12:중국外지역경험자
%>
          <td class="td09" nowrap>
          <%= WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.NCHIN_NAME1),data.NCHIN_BTEXT1) %>&nbsp;<%= WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.NCHIN_NAME1) %>
          <%= data.NCHIN_BTEXT2.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.NCHIN_NAME2),data.NCHIN_BTEXT2) %><%= data.NCHIN_BTEXT2.equals("") ? "" : "&nbsp;"+WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.NCHIN_NAME2) %>
          <%= data.NCHIN_BTEXT3.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.NCHIN_NAME3),data.NCHIN_BTEXT3) %><%= data.NCHIN_BTEXT3.equals("") ? "" : "&nbsp;"+WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.NCHIN_NAME3) %>
          <%= data.NCHIN_BTEXT4.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.NCHIN_NAME4),data.NCHIN_BTEXT4) %><%= data.NCHIN_BTEXT4.equals("") ? "" : "&nbsp;"+WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.NCHIN_NAME4) %>
          <%= data.NCHIN_BTEXT5.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F75PersonnelSubAreaPeCodeRFC()).getObject(data.NCHIN_NAME5),data.NCHIN_BTEXT5) %><%= data.NCHIN_BTEXT5.equals("") ? "" : "&nbsp;"+WebUtil.printOptionText((new F74PersonnelAreaPeCodeRFC()).getObject(),data.NCHIN_NAME5) %>
          &nbsp;</td><!--중국외근무지-->
          <td class="td02" nowrap>
          <%= data.NCHIN_BTEXT1.equals("") ? "" : data.NCHIN_YEAR1 +"&nbsp;&nbsp;"  %>
          <%= data.NCHIN_BTEXT2.equals("") ? "" : "<BR>"+data.NCHIN_YEAR2 +"&nbsp;&nbsp;" %>
          <%= data.NCHIN_BTEXT3.equals("") ? "" : "<BR>"+data.NCHIN_YEAR3 +"&nbsp;&nbsp;" %>
          <%= data.NCHIN_BTEXT4.equals("") ? "" : "<BR>"+data.NCHIN_YEAR4 +"&nbsp;&nbsp;" %>
          <%= data.NCHIN_BTEXT5.equals("") ? "" : "<BR>"+data.NCHIN_YEAR5 +"&nbsp;&nbsp;" %>
          </td><!--중국외근무년수-->
<%
   }
%>
          <td class="td09" nowrap>&nbsp;<%= data.LART_TEXT1 %><%= data.LART_TEXT2.equals("") ? "" : "<BR>("+data.LART_TEXT2+")" %>&nbsp;</td><!--대학교-->
          <td class="td09" nowrap>&nbsp;<%= WebUtil.printOptionText((new F72MajorPeCodeRFC()).getMajorPe(data.FTEXT1),data.FTEXT1) %><%= data.FTEXT2.equals("") ? "" : "<BR>("+WebUtil.printOptionText((new F72MajorPeCodeRFC()).getMajorPe(data.FTEXT2),data.FTEXT2)+")" %>&nbsp;</td><!--전공-->
          <td class="td09" nowrap>&nbsp;<%= data.TOEI_SCOR.equals("000") ? "" : data.TOEI_SCOR %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.JPT_SCOR.equals("000") ? "" : data.JPT_SCOR %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.LANG_LEVL.equals("") ? "" : Integer.toString(Integer.parseInt(data.LANG_LEVL))  %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.LGAX_SCOR %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.PERS_APP1 %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.PERS_APP2 %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.PERS_APP3 %>&nbsp;</td>
          <td class="td09" nowrap><a href="javascript:f_eduDetail('<%= data.PERNR %>')"><img src="<%= WebUtil.ImageURL %>r_ico_search.gif" align="absmiddle" border="0"/></a></td>
        </tr>
<%
        } //end for...
%>

      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
  <tr>
    <td colspan="3" align="center">
      <a href="javascript:do_list();"><img src="<%= WebUtil.ImageURL %>btn_list.gif" name="image3" border="0" align="absmiddle"></a>
    </td>
  </tr>
  <tr><td height="16"></td></tr>
</table>

<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" >해당하는 데이터가 존재하지 않습니다.</td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
<iframe name="ifHidden" width="0" height="0" />
</body>
</html>

