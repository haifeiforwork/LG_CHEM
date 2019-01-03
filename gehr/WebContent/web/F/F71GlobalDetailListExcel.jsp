<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : Global인재Pool                                              */
/*   Program Name : Global인재Pool 각각의 상세화면                              */
/*   Program ID   : F71GlobalDetailListExcel.jsp                                */
/*   Description  : Global인재Pool 각각의 상세화면 Excel 저장을 위한 jsp 파일   */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-03-20 lsa                                               */
/*   Update       :                                                             */
/*                  2014-02-07 C20140204_80557  어학 이라는 표현을  외국어 로 변경*/
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
    Vector F71GlobalDetailListData_vt  = (Vector)request.getAttribute("F71GlobalDetailListData_vt");    //내용
    String gubun        = WebUtil.nvl(request.getParameter("hdn_gubun"));           //구분값.

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
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=GlobalDetailList.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=ks_c_5601-1987">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<%
    if ( F71GlobalDetailListData_vt != null && F71GlobalDetailListData_vt.size() > 0 ) {
%>
<table width="900" border="0" cellspacing="0" cellpadding="0" align="left">

  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02">* <%=Title[Integer.parseInt(gubun)]%> 상세현황</td>
        </tr>
        <tr><td height="10"></td></tr>
<%  //comment
    if ( gubun.equals("17") ) {  //영어&중국어 가능자
%>
        <tr>
          <td colspan="13" >
	              &nbsp;※ 영어:TOEIC 700점 이상 or LGA 3 이상, 중국어: HSK 5등급 이상 or 중국어 전공자&nbsp;
          </td>
        </tr>
<%  }  %>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="13" class="td09">
            &nbsp;부서명 : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
          <td class="td08">(총 <%=F71GlobalDetailListData_vt.size()%> 건)&nbsp;</td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr>
          <td class="td03" rowspan=2 nowrap>사번</td>
          <td class="td03" rowspan=2 nowrap>이름</td>
          <td class="td03" rowspan=2 nowrap>소속명</td>
          <td class="td03" rowspan=2 nowrap>신분</td>
          <td class="td03" rowspan=2 nowrap>직위/직급호칭</td><!--  [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/ -->
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
          <td class="td09" nowrap><%= data.PERNR %></td>
          <td class="td09" nowrap><%= data.ENAME %></td>
          <td class="td09" nowrap><%= data.STEXT %></td>
          <td class="td09" nowrap><%= data.PTEXT %></td>
          <td class="td09" nowrap><%= data.TITEL %></td>
          <td class="td09" nowrap><%= data.TITL2 %></td>
          <td class="td09" nowrap><%= data.TRFGR %></td>
          <td class="td09" nowrap><%= data.TRFST.equals("00") ? "" : data.TRFST %></td>
          <td class="td09" nowrap><%= data.VGLST %></td>
          <td class="td09" nowrap><%= data.STELL_TEXT %></td>
          <td class="td04" nowrap><%= (data.DAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT) %></td>
          <td class="td04" nowrap><%= data.GNSOK %>&nbsp;</td>
          <td class="td09" nowrap><%= data.OLDS %>&nbsp;</td>      <!--연령-->
<%
   if (gubun.equals("02") ||gubun.equals("03") ) { //02:지역전문가 ,03:HPI&지역전문가,06:법인장교육이수자
%>
          <td class="td09" nowrap><%= WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.REGI_SLAND),data.REGI_SLAND) %><%=data.REGI_YEAR.equals("") ? "" : "("+data.REGI_YEAR+")" %></td> <!--연수지역-->
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
          <%= data.DEGR_DETAI3.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0006"),data.DEGR_DETAI3) %></td><!--구분-->
          <td class="td09" nowrap>
          <%= data.DEGR_SLAND1.equals("") ? "" : WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.DEGR_SLAND1),data.DEGR_SLAND1) %>
          <%= data.DEGR_SLAND2.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.DEGR_SLAND2),data.DEGR_SLAND2) %>
          <%= data.DEGR_SLAND3.equals("") ? "" : "<BR>"+WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.DEGR_SLAND3),data.DEGR_SLAND3) %></td><!--국가-->
<%
   } else if (gubun.equals("09")  ) {  //09:R&D박사
%>
          <td class="td09" nowrap><%= data.RND_DETAI.equals("") ? "" : WebUtil.printOptionText((new F73CorePeCodeRFC()).getObject("0005"),data.RND_DETAI) %>&nbsp;</td><!--구분-->
          <td class="td09" nowrap><%= data.RND_SLAND.equals("") ? "" : WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.RND_SLAND),data.RND_SLAND) %></td><!--국가-->
<%
   } else if (gubun.equals("10")  ) {  //10:국내외국인근무자
%>
          <td class="td09" nowrap><%= WebUtil.printOptionText((new A12FamilyNationRFC()).getFamilyNationText(data.FORE_NATIO),data.FORE_NATIO) %></td><!--국적-->
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
          <%= data.CHIN_BTEXT1.equals("") ? "" : data.CHIN_YEAR1 +""%>
          <%= data.CHIN_BTEXT2.equals("") ? "" : "<BR>"+data.CHIN_YEAR2 +"" %>
          <%= data.CHIN_BTEXT3.equals("") ? "" : "<BR>"+data.CHIN_YEAR3 +"" %>
          <%= data.CHIN_BTEXT4.equals("") ? "" : "<BR>"+data.CHIN_YEAR4 +"" %>
          <%= data.CHIN_BTEXT5.equals("") ? "" : "<BR>"+data.CHIN_YEAR5 +"" %></td><!--중국근무년수-->
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
          <%= data.NCHIN_BTEXT1.equals("") ? "" : data.NCHIN_YEAR1 +""  %>
          <%= data.NCHIN_BTEXT2.equals("") ? "" : "<BR>"+data.NCHIN_YEAR2 +"" %>
          <%= data.NCHIN_BTEXT3.equals("") ? "" : "<BR>"+data.NCHIN_YEAR3 +"" %>
          <%= data.NCHIN_BTEXT4.equals("") ? "" : "<BR>"+data.NCHIN_YEAR4 +"" %>
          <%= data.NCHIN_BTEXT5.equals("") ? "" : "<BR>"+data.NCHIN_YEAR5 +"" %>
          </td><!--중국외근무년수-->
<%
   }
%>
          <td class="td09" nowrap><%= data.LART_TEXT1 %><%= data.LART_TEXT2.equals("") ? "" : "<BR>("+data.LART_TEXT2+")" %>&nbsp;</td><!--대학교-->
          <td class="td09" nowrap><%= WebUtil.printOptionText((new F72MajorPeCodeRFC()).getMajorPe(data.FTEXT1),data.FTEXT1) %><%= data.FTEXT2.equals("") ? "" : "<BR>("+WebUtil.printOptionText((new F72MajorPeCodeRFC()).getMajorPe(data.FTEXT2),data.FTEXT2)+")" %></td><!--전공-->
          <td class="td09" nowrap><%= data.TOEI_SCOR.equals("000") ? "" : data.TOEI_SCOR %></td>
          <td class="td09" nowrap><%= data.JPT_SCOR.equals("000") ? "" : data.JPT_SCOR %></td>
          <td class="td09" nowrap><%= data.LANG_LEVL.equals("") ? "" : Integer.toString(Integer.parseInt(data.LANG_LEVL))  %></td>
          <td class="td09" nowrap><%= data.LGAX_SCOR %></td>
          <td class="td09" nowrap><%= data.PERS_APP1 %></td>
          <td class="td09" nowrap><%= data.PERS_APP2 %></td>
          <td class="td09" nowrap><%= data.PERS_APP3 %></td>
        </tr>
<%
                } //end for...
%>
      </table>
    </td>
    <td width="16">&nbsp;</td>
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
</body>
</html>

