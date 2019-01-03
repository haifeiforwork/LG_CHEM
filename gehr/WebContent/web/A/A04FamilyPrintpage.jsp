<%--@elvariable id="personInfo" type="hris.common.PersonData"--%>
<%--@elvariable id="detailData" type="hris.A.A12Family.A12FamilyListData"--%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 부양가족사항                                                */
/*   Program Name : 부양가족사항 Print                                          */
/*   Program ID   : A04FamilyPrintpage.jsp                                      */
/*   Description  : 부양가족신청 Print할 수 있도록 하는 창                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김성일                                          */
/*   Update       : 2005-02-24  윤정현                                          */
/*   Update       : 2007-11-26  김정인                                          */
/*                  2008-04-21  lsa @v1.0 [CSR ID:1254077]대리신청시 정보조회안되게수정*/
/*                  2014-12-02 [CSR ID:2654794] 부양가족 신청화면 변경요청                                                             */
/*                  2015-12-23 [CSR ID:2945607] 부양가족 신청서 양식 수정   */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<jsp:useBean id="resultData" class="hris.A.A12Family.A12FamilyBuyangData" scope="request" />

<%
    WebUserData user = WebUtil.getSessionUser(request);
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function f_print(){
    self.print();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <table width="649" border="0" cellspacing="1" cellpadding="2" align="center">
    <tr>
      <td>
        <table width="645" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top" align="center"><font face="굴림, 굴림체" size="5"><b><u>부양가족 신청서</u></b></font></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="td02">1. 신청자</td>
    </tr>
    <tr>
      <td>
        <table width="645" border="1" cellspacing="0" cellpadding="3" bordercolor="#000000">
          <tr>
            <td class="td04">소속</td>
            <td class="td04" colspan="2" >${personInfo.e_ORGTX}&nbsp;</td>
            <%-- //[CSR ID:3456352]<td class="td04" >직위</td>
            <td class="td04">${personInfo.e_JIKWT}&nbsp;</td> --%>
            <td class="td04" >직책/직급호칭</td>
            <td class="td04">
            <c:choose>
            	<c:when test="${personInfo.e_BUKRS=='C100' && personInfo.e_JIKWE=='EBA' && personInfo.e_JIKKT!=''}">
	            	${personInfo.e_JIKKT}
                </c:when>
                <c:otherwise>
                	${personInfo.e_JIKWT}
                </c:otherwise>
            </c:choose>
            <%-- //[CSR ID:3456352] --%>
            &nbsp;</td>
            <td class="td04">사번</td>
            <td class="td04" >${personInfo.e_PERNR}&nbsp;</td>
          </tr>
          <tr>
            <td class="td04">사내전화</td>
            <td class="td04" colspan="2">${personInfo.e_PHONE_NUM  }&nbsp;</td>
            <td class="td04">신청자</td>
            <td colspan="3" class="td04">${personInfo.e_ENAME }&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
   <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="td02">2. 대상자</td>
    </tr>
    <tr>
      <td>
        <table width="645" border="1" cellspacing="0" cellpadding="3" bordercolor="#000000">


          <tr>
            <td class="td04">성명(한글)</td>
            <td class="td04">${detailData.LNMHG} ${detailData.FNMHG }&nbsp;</td>
            <td class="td04">가족유형</td>
            <td class="td04">${detailData.STEXT }&nbsp;</td>
          </tr>
          <tr>
            <td class="td04">주민등록번호</td>
            <td class="td04">${f:printRegNo(detailData.REGNO, user.empNo != resultData.PERNR ? "FULL" : "")}&nbsp;</td>
            <td class="td04">관계</td>
            <td class="td04">${detailData.ATEXT }&nbsp;</td>
          </tr>
<% //@v1.0
  if( user.empNo.equals(resultData.PERNR) ) {
%>

          <tr>
            <td class="td04">생년월일</td>
            <td class="td04">${fn:substring(detailData.FGBDT, 0, 4)}년&nbsp;${fn:substring(detailData.FGBDT, 5, 7)}월&nbsp;${fn:substring(detailData.FGBDT, 8, 10)}일&nbsp;</td>
            <td class="td04">성별</td>
            <td class="td04">${detailData.FASEX == "1" ? "남" :"여"}&nbsp;</td>
          </tr>
           <tr>
            <td class="td04">출생지</td>
            <td class="td04">${detailData.FGBOT }&nbsp;</td>
            <td class="td04">학력</td>
            <td class="td04">${detailData.STEXT1 }&nbsp;</td>
          </tr>
          <tr>
            <td class="td04">출생국</td>
            <td class="td04">${detailData.LANDX }&nbsp;</td>
            <td class="td04">교육기관</td>
            <td class="td04">${detailData.FASIN }&nbsp;</td>
          </tr>
           <tr>
            <td class="td04">국적</td>
            <td class="td04">${detailData.NATIO }&nbsp;</td>
            <td class="td04">직업</td>
            <td class="td04"><%= resultData.FAJOB %>&nbsp;</td>
          </tr>
<% } %>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="td02"><b>※ 다음과 같은 사항을 필수로 체크해주세요!!</b></td>
    </tr>
    <tr>
      <td>
        <table width="630" border="0" cellspacing="0" cellpadding="3" align="right">
          <tr>
            <td class="td02">1. 신청하려는 부양가족이 다른 가족의 부양가족으로 등재되어 있나요?</td>
            <td class="td02">□ 예</td>
            <td class="td02">□ 아니오</td>
          </tr>
          <tr>
            <td class="td02">2. 신청하려는 부양가족의 소득금액이 100만원 이하인가요?</td>
            <td class="td02">□ 예</td>
            <td class="td02">□ 아니오</td>
          </tr>
          <tr>
            <td class="td02" colspan=3>&nbsp;&nbsp;▷ 소득금액 100만원 이하가 되려면?</td>
          </tr>
          <tr>
            <!-- [CSR ID:2654794] 부양가족 신청화면 변경요청  <td class="td02" colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;1) 근로소득자 : 총급여액이 500만원 이하</td> -->
            <!-- [CSR ID:2945607] 부양가족 신청서 양식 수정 <td class="td02" colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;1) 근로소득자 : 총급여액이 3,333,333원 이하</td>-->
            <td class="td02" colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;1) 근로소득자 : 총급여액이 500만원 이하(단, 근로소득만 있는 경우에 한함)</td><!-- //@2015 연말정산 -->
          </tr>
          <tr>
            <td class="td02" colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;2) 사업소득자 : 사업소득 - 필요경비를 공제한 금액이 100만원 이하</td>
          </tr>
          <tr>
            <td class="td02" colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;3) 기타 : 소득금액증명원 확인 바람 (세무서발행)</td>
          </tr>

        </table>
      </td>
    </tr>
    <tr>
      <td class="td02"><b>※ 부양가족 신청서 제출시 이 서류도 같이 주세요!!</b></td>
    </tr>
    <tr>
      <td align=center>
        <!--table width="600" border="1" cellspacing="0" cellpadding="0" align="right" bordercolor="#000000"-->
        <table width="580" border="0" cellspacing="1"  bgcolor=#666666>
          <tr>
            <td class="td02">관계</td>
            <td class="td02">제출서류</td>
          </tr>
          <tr>
            <td class="td02">장애자</td>
            <td class="td02">국가보훈처 발행증명서 or 장애인수첩사본 or 의료기관에서 발행한 장애인 증명서</td>
          </tr>
          <tr>
            <td class="td02">배우자/자녀</td>
            <td class="td02">주민등록등본 또는 가족관계증명서</td>
          </tr>
          <tr>
            <td class="td02">직계존속<br>(배우자 직계존속 포함)</td>
            <td class="td02">1. 동거시&nbsp;&nbsp;&nbsp;&nbsp;: 주민등록등본<br>2. 비동거시 : 가족관계증명서</td>
          </tr>
          <tr>
            <td class="td02">형제자매<br>(배우자 형제자매 포함)</td>
            <td class="td02">1. 동거시&nbsp;&nbsp;&nbsp;&nbsp;: 주민등록등본
                         <br>2. 비동거시 : 일시퇴거가족상황표, 일시퇴거증빙서류
                         <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(재학, 요양, 재직증명서, 사업자등록등사본 중 관련서류 택일)
                         <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;원주소지 및 퇴거지의 주민등록등본 각1통</td>
          </tr>
          <tr>
            <td class="td02">위탁아동</td>
            <td class="td02">가정위탁보호확인서(종결일 명시)</td>
          </tr>

        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="td02"><b>◎ 신청하려는 부양가족이 다른 가족의 부양가족으로 기 등재 되어있거나 소득금액이 100만원이 초과 되는
      <br>&nbsp;&nbsp;&nbsp;&nbsp;경우에도 불구하고 신청한 경우에는 추후에 부당공제로 인해 가산세 추징이 있음.</b></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>
        <table width="250" border="0" cellspacing="0" cellpadding="3" align="right">
          <tr>
            <td class="font01" width="86" align="right">신청일&nbsp;:</td>
            <td class="font01">${fn:substring(resultData.BEGDA, 0, 4)}&nbsp;년&nbsp;&nbsp;${fn:substring(resultData.BEGDA, 5, 7)}&nbsp;월&nbsp;&nbsp;${fn:substring(resultData.BEGDA, 8, 10)}&nbsp;일</td>
          </tr>
          <tr>
            <td class="font01" width="86" align="right">신청자&nbsp;:</td>
            <td class="font01">${personInfo.e_ENAME }&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>