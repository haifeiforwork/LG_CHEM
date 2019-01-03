<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금                                                    */
/*   Program Name : 학자금·장학금 신청서 Print                                 */
/*   Program ID   : E21ExpensePrint.jsp                                         */
/*   Description  : 학자금·장학금 신청서 Prin할 수 있도록 하는 화면            */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김성일                                          */
/*   Update       : 2005-03-01  윤정현                                          */
/*   Update       : 2013-03-13  lsa C20130313_90993  문구변경                   */
/*						2014-10-24  @v.1.5 SJY 신청유형:장학금인 경우에만 시스템 수정 	[CSR ID:2634836] 학자금 신청 시스템 개발 요청	*/
/*  					2018-01-11  cykim  [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E21Expense.*" %>
<%@ page import="hris.common.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
    E21ExpenseData e21ExpenseData = (E21ExpenseData)request.getAttribute("e21ExpenseData");
    // E21ExpenseChkData e21ExpenseChkData = (E21ExpenseChkData)request.getAttribute("e21ExpenseChkData");
    String msgFLAG = (String)request.getAttribute("msgFLAG");
    String msgTEXT = (String)request.getAttribute("msgTEXT");

    //  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize  = 2;
    double currencyDecimalSize1 = 2;
    int    currencyValue  = 0;
    int    currencyValue1 = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e21ExpenseData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }

        if( e21ExpenseData.WAERS1.equals(codeEnt.code) ){
            currencyDecimalSize1 = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue  = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
    currencyValue1 = (int)currencyDecimalSize1; //???  KRW -> 0, USDN -> 5
    //  통화키에 따른 소수자리수를 가져온다

    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
//신청유형:장학금인 경우에만 시스템 수정 START

function init(){
<%
    if(WebUtil.nvl(e21ExpenseData.SUBF_TYPE).equals("3")){
%>
			document.getElementById("TYPE_3").style.display="block";
	        document.getElementById("TYPE_3_1").style.display="block";
	        /* [CSR ID:3569058] 신청유형이 장학금인 경우 학과필드 display  start*/
	        document.getElementById("FRTXT").style.display="block";
	        /* [CSR ID:3569058] 신청유형이 장학금인 경우 학과필드 display end*/
<%
    }
%>
}

//신청유형:장학금인 경우에만 시스템 수정 END
</script>

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="javascript:init();">
<form name="form1" method="post" action="">

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<%
    if ( !msgFLAG.equals("") ) { // 에러메시지 보여줌
%>
    <tr>
      <td width="10">&nbsp;</td>
      <td><%= msgTEXT %></td>
    </tr>
<%
    } else {
%>

    <tr>
      <td width="10">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center"><h2>학자금·장학금 신청서</h2></td>
    </tr>
    <tr>
    <td width="10">&nbsp;</td>
    <td>
      <!--타이틀 테이블 시작-->
        <table width="700" border="0" cellspacing="1" cellpadding="0">
          <tr>
              <td class="tr01">
                <table width="690" border="0" cellspacing="1" cellpadding="2">
                  <tr>
                    <td class="td09" colspan="2"><b>1. 신청자</b></td>
                  </tr>
                </table>
              </td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="10">&nbsp;</td>
      <td>
        <!--타이틀 테이블 시작-->
        <table width="700" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="tr01">
              <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table01">
                <tr>
                  <td class="td03" align="center">사&nbsp;&nbsp;번</td>
                  <td class="td03" align="center">성&nbsp;&nbsp;명</td>
                  <td class="td03" align="center">소&nbsp;&nbsp;속</td>
                  <td class="td03" align="center">전화번호</td>
                </tr>
                <tr>
                  <td class="td04" align="center"><%= PERNR_Data.E_PERNR %>&nbsp;</td>
                  <td class="td04" align="center"><%= PERNR_Data.E_ENAME %>&nbsp;</td>
                  <td class="td04" align="center"><%= PERNR_Data.E_ORGTX %>&nbsp;</td>
                  <td class="td04" align="center"><%= PERNR_Data.E_PHONE_NUM %>&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="10">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="10">&nbsp;</td>
      <td>
        <!--타이틀 테이블 시작-->
          <table width="700" border="0" cellspacing="1" cellpadding="0">
            <tr>
                <td class="tr01">
                  <table width="690" border="0" cellspacing="1" cellpadding="2">
                    <tr>
                      <td class="td09" colspan="2"><b>2. 지급대상자</b></td>
                    </tr>
                  </table>
                </td>
            </tr>
          </table>
        <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="10">&nbsp; </td>
      <td>
        <!-- 상단 입력 테이블 시작-->
        <table width="700" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="tr01">
              <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table01">
                <tr>
                  <td class="td01">신청일자</td>
                  <td class="td09" colspan="3">
                    &nbsp;&nbsp;<%= e21ExpenseData.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(e21ExpenseData.BEGDA) %>
                  </td>
                </tr>
                <tr>
                  <td class="td01">가족선택</td>
                  <td class="td09" colspan="3">
                      &nbsp;&nbsp;<%= e21ExpenseData.ATEXT %>
                  </td>
                </tr>
                <tr>
                  <td class="td01" width="110">신청유형</td>
                  <td class="td09" width="240">&nbsp;&nbsp;<%= e21ExpenseData.SUBF_TYPE.equals("2")? "학자금" : "장학금" %></td>
                  <td class="td01" width="110">신청년도</td>
                  <td class="td09">&nbsp;&nbsp;<%= e21ExpenseData.PROP_YEAR %></td>
                </tr>
                <tr>
                  <td class="td01">신청구분</td>
                  <td class="td09">
                    <input type="radio" name="radiobutton" value="신규분" <%= e21ExpenseData.PAY1_TYPE.equals("X") ? "checked" : "" %> disabled>
                    신규분
                    <input type="radio" name="radiobutton" value="추가분" <%= e21ExpenseData.PAY2_TYPE.equals("X") ? "checked" : "" %> disabled>
                    추가분
                  </td>
                  <td class="td01">신청분기ㆍ학기</td>
                  <td class="td09">&nbsp;&nbsp;<%= e21ExpenseData.SUBF_TYPE.equals("2") ? (e21ExpenseData.PERD_TYPE.equals("0") ? "" : e21ExpenseData.PERD_TYPE + "분기") : (e21ExpenseData.HALF_TYPE.equals("0") ? "" : e21ExpenseData.HALF_TYPE + "학기") %></td>
                </tr>
                <tr>
                  <td class="td01">이름</td>
                  <td class="td09" colspan="3"> &nbsp;&nbsp;<%=e21ExpenseData.LNMHG.trim()%><%=e21ExpenseData.FNMHG.trim()%></td>
                </tr>
                <tr>
                  <td class="td01">학력</td>
                  <td class="td09" colspan="3">
                    &nbsp;&nbsp;<%= e21ExpenseData.STEXT %>
                  </td>
                </tr>
                <tr>
                  <td class="td01">교육기관</td>
                  <td class="td09">
                    &nbsp;&nbsp;<%= e21ExpenseData.FASIN %>
                  </td>
                  <td class="td01">학년</td>
                  <td class="td09">&nbsp;&nbsp;<%= e21ExpenseData.ACAD_YEAR.equals("0") ? "" : e21ExpenseData.ACAD_YEAR + "&nbsp;&nbsp;학년" %></td>
                </tr>
                <!--  [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 start -->
				<tr id="FRTXT" style="display:none;">
                  <td class="td01">학과</td>
                  <td class="td09" colspan="3">
                    &nbsp;&nbsp;<%= e21ExpenseData.FRTXT %>
                  </td>
                </tr>
                <!--  [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 end -->
                <tr>
                  <td class="td01">신청액</td>
                  <td class="td09">
                    &nbsp;&nbsp;<%= WebUtil.printNumFormat(e21ExpenseData.PROP_AMNT,currencyValue) %> &nbsp;&nbsp;
                    <%= e21ExpenseData.WAERS %>
                  </td>
                  <td class="td01">수혜횟수</td>
                  <td class="td09">&nbsp;&nbsp;<%= WebUtil.printNumFormat(e21ExpenseData.P_COUNT).equals("0") ? "" : WebUtil.printNumFormat(e21ExpenseData.P_COUNT) + "&nbsp;&nbsp;회" %></td>
                </tr>
                <tr>
                  <td class="td01">입학금</td>
                  <td class="td09" colspan="<%=WebUtil.nvl(e21ExpenseData.SUBF_TYPE).equals("3") ? "":"3"%>">
                    <input type="checkbox" name="ENTR_FIAG" value="X" size="20" class="input04" <%= e21ExpenseData.ENTR_FIAG.equals("X") ? "checked" : "" %> disabled>
                  </td>

                  <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
				   <td class="td01" id="TYPE_3" style="display:none;">유학 학자금</td>
	               <td class="td09" id="TYPE_3_1" style="display:none;">
						<input type="checkbox" name="ABRSCHOOL" value="X" size="20" class="input04" <%= WebUtil.nvl(e21ExpenseData.ABRSCHOOL).equals("X") ? "checked" : "" %> disabled>
					</td>

                </tr>
              </table>
              <!-- 상단 입력 테이블 끝-->
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
    <td width="10">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="10">&nbsp;</td>
    <td>
      <!--타이틀 테이블 시작-->
        <table width="700" border="0" cellspacing="1" cellpadding="0">
          <tr>
              <td class="tr01">
                <table width="690" border="0" cellspacing="1" cellpadding="2">
                  <tr>
                    <td class="td09" colspan="2"><b>3. 지급기준 및 범위</b></td>
                  </tr>
                </table>
              </td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
    </td>
  </tr>
  <tr>
    <td width="10">&nbsp;</td>
    <td>
      <!--타이틀 테이블 시작-->
        <table width="700" border="0" cellspacing="1" cellpadding="0">
          <tr>
              <td class="tr01">
                <table width="690" border="0" cellspacing="1" cellpadding="2">
                  <tr>
                    <td class="td09" align="center">&nbsp;</td>
                    <td class="td09">
                    <p>1) 학자금(중, 고)<br> <!--C20130313_90993-->
                    &nbsp;① 지급내역 : 입학금, 수업료, 학교운영지원비, 학생회비<br>
                    &nbsp;② 증빙서류 : (장학금,학자금) 신청서, 등록금 납입영수증 원본</br>
                    &nbsp;③ 수혜회수 : 자녀 1인당 잔여학기 범위내 중,고 포함해서 총 24회로 함<br>
                    </P>
                    <p>2) 장학금(대학교)<br>
                    &nbsp;① 지급내역 : 입학금(1회만 지급), 수업료, 기성회비, 실습비, 학생회비<br>
                    <!-- [CSR ID:2633966] 학자금 및 의료비 문구 수정
                    &nbsp;② 대상자녀 : 자녀가 전문대 이상(각종학교제외, 단, 전국정규 4년제 대학의 야간 및 분교포함)의 재학생으로<br> -->
                    &nbsp;② 대상자녀 : 자녀가 전문대 이상(각종학교제외, 단, 전국정규 4년제 대학의 야간 및 분교, 전문대 야간 포함)의 재학생으로<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당학기 평균성적이 D0(당사 평균점수 환산 기준) 이상인 자,<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☞ 원격대학(방송통신대, 사이버 대학교)는 교육과학기술부의 인가를 받은 학교에 한하여 지원함.<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☞ 평균점수 환산법은 담당부서로 문의<br>
                    &nbsp;③ 수혜회수 : 자녀 1인당 잔여학기 범위내 최대 8회로 함<br>
                    &nbsp;④ 장학금을 수령한 후 학기중 해당학기 이수가 인정되지 않는 휴학, 퇴학, 정학, 성적미달(D0이하)인 경우 <br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사유발생일 30일 이내에 회사에 해당사실 통보 및 장학금 전액을 반납하여야 하며 이를 위반할 시 징계위원회 회부 <br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;및 장학금 지급을 중지함<br>
                    &nbsp;⑤ 증빙서류 : (장학금,학자금) 신청서, 등록금(입학금) 납입영수증 원본, 성적증명서<br>
                    </p>
                   </td>
                </table>
              </td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
    </td>
    </tr>
    <tr>
      <td width="10">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
    <td width="10">&nbsp;</td>
    <td>
      <!--타이틀 테이블 시작-->
        <table width="700" border="0" cellspacing="1" cellpadding="0">
          <tr>
              <td class="tr01">
                <table width="650" border="0" cellspacing="1" cellpadding="2">
                  <tr>
                    <td class="font01" width="500" align="right">신청일&nbsp;:</td>
                    <td class="font01"><%= e21ExpenseData.BEGDA.equals("0000-00-00") ? "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" : WebUtil.printDate((e21ExpenseData.BEGDA)).substring(0,4) %>&nbsp;년&nbsp;&nbsp;<%= e21ExpenseData.BEGDA.equals("0000-00-00") ? "&nbsp;&nbsp;&nbsp;&nbsp;" : WebUtil.printDate((e21ExpenseData.BEGDA)).substring(5,7) %>&nbsp;월&nbsp;&nbsp;<%= e21ExpenseData.BEGDA.equals("0000-00-00") ? "&nbsp;&nbsp;&nbsp;&nbsp;" : WebUtil.printDate((e21ExpenseData.BEGDA)).substring(8,10) %>&nbsp;일</td>
                  </tr>
                  <tr>
                    <td class="font01" width="500" align="right">신청자&nbsp;:</td>
                    <td class="font01"><%= PERNR_Data.E_ENAME %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</td>
                  </tr>
                </table>
              </td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
    </td>
  </tr>
<%
    } // end if  // 에러메시지 보여줌
%>
</table>
학자금·장학금 신청서
<%@ include file="/web/common/commonEnd.jsp" %>


