<%/******************************************************************************/
/*                                                                              */
/*   System Name  : 주택자금                                                    */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금                                                    */
/*   Program Name : 주택자금신청서출력 Print                                    */
/*   Program ID   : E05HousePrintpage.jsp                                       */
/*   Description  : 주택자금신청내역을 Print할 수 있도록 하는 창                */
/*   Note         :                                                             */
/*   Creation     : 2005-11-04  lsa  @v1.2lsa :C2005102701000000578             */
/*   Update       : 2012-04-26  lsa [CSR ID:2097388] 주택자금 신규신청 화면 은행코드 추가 요청 */
/*                   : 2017-11-03  eunha /*   Update       : 2012-04-26  lsa [CSR ID:2097388] 주택자금 신규신청 화면 은행코드 추가 요청 */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>


<!--e05housedetail.jsp랑 소스맞추고 잇음-->
<%
    WebUserData user = WebUtil.getSessionUser(request);
    E05PersInfoData E05PersInfoData = (E05PersInfoData)request.getAttribute("E05PersInfoData");

    Vector e05HouseData_vt  = (Vector)request.getAttribute("e05HouseData_vt");
    E05HouseData E05HouseData = (E05HouseData)e05HouseData_vt.get(0);

    PersonData personData2 = (PersonData)request.getAttribute("PersonData");
//out.println("personData2:"+personData2.toString());

    //String RequestPageName = (String)request.getAttribute("RequestPageName");

    //// 현재 결재자 구분
    //DocumentInfo docinfo = new DocumentInfo(E05HouseData.AINF_SEQN ,user.empNo);
    //int approvalStep = docinfo.getApprovalStep();

    /* [CSR ID:2097388] 급여계좌 리스트를 vector로 받는다*/
    E05HouseBankCodeRFC  rfc_bank    = new E05HouseBankCodeRFC();
    Vector          e05BankCodeData_vt = rfc_bank.getBankCode();

%>

<%
    //WebUserData user               = (WebUserData)session.getAttribute("user");
    //E17SickData e17SickData        = (E17SickData)request.getAttribute("e17SickData");
    //Vector      E05HouseData_vt = (Vector)request.getAttribute("E05HouseData_vt");
      String      BEGDA              = E05HouseData.BEGDA ;
      String      YYYY               = null;
      String      MM                 = null;
      String      DD                 = null;

      if(BEGDA!= null && BEGDA.equals("") && BEGDA.equals("0000-00-00") ){
          YYYY = "";
          MM   = "";
          DD   = "";
      }else{
          YYYY = BEGDA.substring(0,4);
          MM   = BEGDA.substring(5,7);
          DD   = BEGDA.substring(8,10);
      }

%>
<html>
<head>
<title>eHR주택자금신청서</title>
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
  <table width="624" border="0" cellspacing="1" cellpadding="2" align="center">
    <tr>
      <td class="td02" height=20></td>
    </tr>
    <tr>
      <td>
        <table width="620" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top" align="center"><font face="굴림, 굴림체" size="5"><b><u>주택자금 지원 신청서</u></b></font></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="td02" height=20></td>
    </tr>

    <tr>
      <td class="td02">1. 신청자</td>
    </tr>
    <tr>
      <td>
        <table width="620" border="1" cellspacing="0" cellpadding="3" bordercolor="#000000">
          <tr>
            <td class="td04">소속</td>
            <td class="td04" colspan="2" ><%=personData2.E_ORGTX%>&nbsp;</td>
            <%-- //[CSR ID:3456352] <td class="td04" >직위</td>
            <td class="td04"><%=personData2.E_JIKWT%>&nbsp;</td> --%>
            <td class="td04" >직책/직급호칭</td>
            <td class="td04"><%=personData2.E_JIKWT.equals("책임") && !personData2.E_JIKKT.equals("") ? personData2.E_JIKKT : personData2.E_JIKWT %>&nbsp;</td>
            <td class="td04">사번</td>
            <td class="td04" ><%=personData2.E_PERNR%>&nbsp;</td>
          </tr>
          <tr>
            <td class="td04">사내전화</td>
            <td class="td04" colspan="2"><%=personData2.E_PHONE_NUM  %>&nbsp;</td>
            <td class="td04">신청자</td>
            <td colspan="3" class="td04"><%=personData2.E_ENAME %>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
   <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="td02">2. 신청내역</td>
    </tr>
    <tr>
      <td>
        <table width="620" border="1" cellspacing="0" cellpadding="3" bordercolor="#000000">
          <tr>
            <td class="td04">주택자금유형</td>
            <td class="td04"  colspan="3" style="text-align:left">&nbsp;
<%
            E05LoanCodeRFC      rfc       = new E05LoanCodeRFC();
            Vector E05LoanCodeData_vt  = null;
            E05LoanCodeData_vt = rfc.getLoanType();
            for (int i=0; i< E05LoanCodeData_vt.size(); i++) {
                com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)E05LoanCodeData_vt.get(i);
                if (ck.code.equals(E05HouseData.DLART)) {
%>
                   <%= ck.value %>
<%
                }
            }
%>
            &nbsp;</td>

          </tr>
          <tr>
            <td class="td04">현주소</td>
            <td class="td04" colspan="3" style="text-align:left">&nbsp; <%= E05PersInfoData.E_STRAS %>&nbsp;</td>
          </tr>
          <tr>
            <td class="td04" width="100" >근속년수</td>
            <td class="td04" width="210" style="text-align:right"><%= E05PersInfoData.E_YEARS %>년&nbsp;</td>
            <td class="td04" width="100" >신청은행</td>
            <td class="td04" width="210" style="text-align:left">&nbsp;
<%
    for(int i = 0 ; i < e05BankCodeData_vt.size() ; i++){
        E05HouseBankCodeData data_bank = (E05HouseBankCodeData)e05BankCodeData_vt.get(i);
%>
     <%=data_bank.BANK_CODE.equals(E05HouseData.BANK_CODE) ? data_bank.BANK_NAME : "" %>
<%
    }
%>
            </td>
          </tr>
          <tr>

            <td class="td04" width="100">신청금액</td>
            <td class="td04" width="210" style="text-align:right"><%= WebUtil.printNumFormat(Double.parseDouble(E05HouseData.REQU_MONY)*100) %>원&nbsp;</td>
            <td class="td04" colspan=2>&nbsp</td>
          </tr>
          <tr>
            <td class="td04">자금용도</td>
            <td class="td04" style="text-align:left">&nbsp;

<%  //CSR ID:1327268
    Vector E05FundCode_vt  = (new E05FundCodeRFC()).getFundCode();

    for( int i = 0 ; i < E05FundCode_vt.size() ; i++ ) {
        E05FundCodeData dt = (E05FundCodeData)E05FundCode_vt.get(i);
        if ( E05HouseData.DLART.equals(dt.DLART)&& E05HouseData.ZZFUND_CODE.equals(dt.FUND_CODE)) {
%>
           <%=dt.FUND_TEXT%>
<%
        }
    }
%>

            &nbsp;</td>
            <td class="td04">보증여부</td>
            <td class="td04" style="text-align:left">&nbsp;
<%  if( E05HouseData.ZZSECU_FLAG.equals("N") ) {  %>
            보증보험가입희망
<%  } else if( E05HouseData.ZZSECU_FLAG.equals("Y") ) {  %>
            연대보증인 입보
<%  } else if( E05HouseData.ZZSECU_FLAG.equals("C") ) {  %>
            신용보증
<%  } %>
            &nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="td02">
      <%--[CSR ID:3517737] 주택자금 신청화면 및 신청서 문구 수정요청의 건
      &nbsp;&nbsp;&nbsp;&nbsp;본인은 신청일 현재 무주택자 임을 확인합니다.  <br>--%>
      &nbsp;&nbsp;&nbsp;&nbsp;신청일 현재 무주택자 임을 확인합니다.  <br>
      &nbsp;&nbsp;&nbsp;&nbsp;상기 사항이 사실이 아닌 경우 규정에 따른 조치(대출액 환수 등)에 이의가 없음을 확인합니다.<br>
      </td>
    </tr>
    <tr>
      <td class="td02">
        <table width="620" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td  class="td02" valign="top" align="center">본인동의 : <%= E05HouseData.ZCONF.equals("Y") ? "예" : "" %><%= E05HouseData.ZCONF.equals("N") ? "아니오" : "" %></td>
          </tr>
        </table>

      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>

    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>
        <table width="250" border="0" cellspacing="0" cellpadding="3" align="right">
          <tr>
            <td class="font01" width="86" align="right">신청일&nbsp;:</td>
            <td class="font01"><%=YYYY%>&nbsp;년&nbsp;&nbsp;<%=MM%>&nbsp;월&nbsp;&nbsp;<%=DD%>&nbsp;일</td>
          </tr>
          <tr>
            <td class="font01" width="86" align="right">신청자&nbsp;:</td>
            <td class="font01"><%= personData2.E_ENAME %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
