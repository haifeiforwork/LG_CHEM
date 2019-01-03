<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 우리사주보유현황                                            */
/*   Program Name : 우리사주보유현황                                            */
/*   Program ID   : E14StockListSV_m                                            */
/*   Description  : 우리사주현황, 증권계좌, 인출내역을 jsp로 넘겨주는 class     */
/*   Note         :                                                             */
/*   Creation     : 2002-12-23  이형석                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.E.E14Stock.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    String       paging_m = (String)request.getAttribute("page_m");
    E14StockData data     = (E14StockData)request.getAttribute("E14StockData");
    Vector E14Stock_vt             = (Vector)request.getAttribute("E14Stock_vt");
    Vector a03AccountDetailData_vt = (Vector)request.getAttribute("a03AccountDetailData_vt");

    A03AccountDetail2Data accountdata = new A03AccountDetail2Data();

    if( a03AccountDetailData_vt.size() > 0 ) {
        accountdata = (A03AccountDetail2Data)a03AccountDetailData_vt.get(0);
    }

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu_m = null;
    try {
        pu_m = new PageUtil(E14Stock_vt.size(), paging_m , 10, 10);
        Logger.debug.println(this, "page_m : "+paging_m);
    } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
    }
%>

<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E14Stock.E14StockListSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function doSubmit() {
    var command = "";
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
        size = 1;
    } else {
        size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = document.form1.radiobutton[i].value;
        }
    }

    eval("document.form1.INCS_NUMB.value = document.form1.INCS_NUMB"+command+".value");
    eval("document.form1.DEPS_QNTY.value = document.form1.DEPS_QNTY"+command+".value");
    eval("document.form1.SHAR_TEXT.value = document.form1.SHAR_TEXT"+command+".value");
    eval("document.form1.SHAR_TYPE.value = document.form1.SHAR_TYPE"+command+".value");
    eval("document.form1.BEGDA.value = document.form1.BEGDA"+command+".value");

    window.open('', 'essdetail', 'toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=417,height=235,left=160,top=280,scrollbars=yes');
    document.form1.jobid.value = "detail";
    document.form1.target = "essdetail";
    document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E14Stock.E14StockListSV_m';
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</script>
</head>

<!--[CSR ID:2389767] [정보보안] e-HR MSS시스템 수정-->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"> 
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">우리사주 보유현황</td>
                  <td class="titleRight"><a href="javascript:open_help('X03PersonInfo.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a></td>
                </tr>
              </table></td>
          </tr>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
        </table>
        <table width="100%" height="20" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td>
              <table width="780" border="0" cellspacing="1" cellpadding="4" class="table02">
                <tr>
                  <td class="td03" width="100">&nbsp;</td>
                  <td class="td03" width="220">보통주</td>
                  <td class="td03" width="220">우선주</td>
                  <td class="td03" width="240">계</td>
                </tr>
<%
    if( E14Stock_vt.size() == 0 ) {
%>
                <tr align="center">
                  <td class="td04" colspan="4">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
              </table>
            </td>
          </tr>
<%
    } else {
%>
          <tr>
            <td class="td03">잔여량합</td>
            <td class="td04"><%= WebUtil.printNum(data.BOTONG) %></td>
            <td class="td04"><%= WebUtil.printNum(data.USUN) %></td>
            <td class="td04"><%=WebUtil.printNum(data.SUM) %></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="560" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td background="<%= WebUtil.ImageURL %>bg_pixel02.gif"><img src="<%= WebUtil.ImageURL %>bg_pixel02.gif" width="4" height="13"></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="560" border="0" cellspacing="0" cellpadding="0" height="30">
          <tr>
            <td width="52"><a href="javascript:doSubmit();"><img src="<%= WebUtil.ImageURL %>btn_serch02.gif" width="52" height="20" border="0" align="absmiddle"></a></td>
            <td class="td02">
              <table width="320" border="0" cellspacing="1" cellpadding="2" align="right">
                <tr>
                  <td width="80" class="td01">증권번호</td>
<%
        if( a03AccountDetailData_vt.size() > 0 ) {
%>
                  <td class="td02">
                    <input type="text" name="SECU_NAME" size="10" class="input04" value="&nbsp;<%= accountdata.SECU_NAME %>"readonly >
                    <input type="text" name="GAPP_CONT" size="20" class="input04" value="&nbsp;<%= accountdata.GAPP_CONT %>"readonly >
                  </td>
<%
        } else {
%>
                  <td class="td02">&nbsp;증권계좌 정보가 없습니다.</td>
<%
        }
%>
                </tr>
              </table>
            </td>
            <td class="td02" width="125" align="right" valign="bottom"><%= pu_m.pageInfo() %></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!-- 조회 리스트 테이블 시작-->
        <table width="560" border="0" cellspacing="1" cellpadding="3" class="table02">
          <tr>
            <td class="td03" width="40">선택</td>
            <td class="td03" width="60">증자회차</td>
            <td class="td03" width="80">주식구분</td>
            <td class="td03" width="80">예탁주수</td>
            <td class="td03" width="80">예탁일자</td>
            <td class="td03" width="90">인출주식량</td>
            <td class="td03" width="80">잔여량</td>
          </tr>
<%
        for( int i = pu_m.formRow() ; i < pu_m.toRow(); i++ ) {
            E14StockData stockdata = (E14StockData)E14Stock_vt.get(i);
%>
            <input type="hidden" name="INCS_NUMB<%= i %>" value="<%= stockdata.INCS_NUMB %>">
            <input type="hidden" name="SHAR_TEXT<%= i %>" value="<%= stockdata.SHAR_TEXT %>">
            <input type="hidden" name="DEPS_QNTY<%= i %>" value="<%= stockdata.DEPS_QNTY %>">
            <input type="hidden" name="BEGDA<%= i %>" value="<%= stockdata.BEGDA %>">
            <input type="hidden" name="SHAR_TYPE<%= i %>" value="<%= stockdata.SHAR_TYPE %>">

          <tr>
            <td class="td04">
              <input type="radio" name="radiobutton" value="<%= i %>" <%=(i==0) ? "checked" : ""%>  >
            </td>
            <td class="td04"><%= WebUtil.printNum(stockdata.INCS_NUMB) %></td>
            <td class="td04"><%= stockdata.SHAR_TEXT %></td>
            <td class="td04"><%= WebUtil.printNum(stockdata.DEPS_QNTY) %></td>
            <td class="td04"><%= WebUtil.printDate(stockdata.BEGDA) %></td>
            <td class="td04"><%= WebUtil.printNum(stockdata.OUTS_QNTY) %></td>
            <td class="td04"><%= WebUtil.printNum(stockdata.AFTR_QNTY) %></td>
          </tr>
<%
        }
%>
        </table>
        <!-- 조회 리스트 테이블 끝-->
      </td>
    </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
    <tr>
      <td align="center" height="25" valign="bottom" class="td02">
        <input type="hidden" name="page_m" value="">
        </td>
    </tr>
<%= pu_m.pageControl() %>
<!-- PageUtil 관련 - 반드시 써준다. -->
<%
    }
%>
<%
}
%>
  </table>
<input type="hidden" name="jobid_m"  value="">
<input type="hidden" name="INCS_NUMB" value="">
<input type="hidden" name="SHAR_TEXT" value="">
<input type="hidden" name="DEPS_QNTY" value="">
<input type="hidden" name="BEGDA" value="">
<input type="hidden" name="SHAR_TYPE" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
