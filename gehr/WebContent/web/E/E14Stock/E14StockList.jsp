<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 우리사주 현황조회                                           */
/*   Program Name : 우리사주 현황조회                                           */
/*   Program ID   : E14StockList.jsp                                            */
/*   Description  : 우리사주 현황조회                                           */
/*   Note         :                                                             */
/*   Creation     : 2002-12-23  이형석                                          */
/*   Update       : 2005-01-27  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.E.E14Stock.*" %>

<%
    String paging  = (String)request.getAttribute("page");
    E14StockData data = (E14StockData)request.getAttribute("E14StockData");
    Vector E14Stock_vt             = (Vector)request.getAttribute("E14Stock_vt");
    Vector a03AccountDetailData_vt = (Vector)request.getAttribute("a03AccountDetailData_vt");

    A03AccountDetail2Data accountdata = new A03AccountDetail2Data();

    if( a03AccountDetailData_vt.size() > 0 ) {
        accountdata = (A03AccountDetail2Data)a03AccountDetailData_vt.get(0);
    }

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    try {
        pu = new PageUtil(E14Stock_vt.size(), paging , 10, 10);
        Logger.debug.println(this, "page : "+paging);
    } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
    }
%>

<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
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
    document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E14Stock.E14StockListSV';
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return true" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->
<form name="form1" method="post">

<div class="subWrapper">
  <div class="title"><h1>우리사주 보유현황</h1></div>

  <div class="listArea">
    <div class="table">
      <table class="listTable">
        <tr>
          <th>&nbsp;</th>
          <th>보통주</th>
          <th>우선주</th>
          <th class="lastCol">계</th>
        </tr>
<%
    if( E14Stock_vt.size() == 0 ) {
%>
        <tr class="oddRow">
          <td class="lastCol" colspan="4">해당하는 데이터가 존재하지 않습니다.</td>
        </tr>
      </table>
    </div>
  </div>

<%
    } else {
%>
        <tr class="oddRow">
          <td>잔여량합</td>
          <td><%= WebUtil.printNum(data.BOTONG) %></td>
          <td><%= WebUtil.printNum(data.USUN) %></td>
          <td class="lastCol"><%=WebUtil.printNum(data.SUM) %></td>
        </tr>
      </table>
    </div>
  </div>

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
                  <td class="td02" width="125" align="right" valign="bottom"><%= pu.pageInfo() %></td>
                </tr>
              </table>

  <!-- 조회 리스트 테이블 시작-->
  <div class="listArea">
    <div class="table">
      <table class="listTable">
        <tr>
          <th>선택</th>
          <th>증자회차</th>
          <th>주식구분</th>
          <th>예탁주수</th>
          <th>예탁일자</th>
          <th>인출주식량</th>
          <td class="lastCol">잔여량</th>
        </tr>
<%
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            E14StockData stockdata = (E14StockData)E14Stock_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                  <input type="hidden" name="INCS_NUMB<%= i %>" value="<%= stockdata.INCS_NUMB %>">
                  <input type="hidden" name="SHAR_TEXT<%= i %>" value="<%= stockdata.SHAR_TEXT %>">
                  <input type="hidden" name="DEPS_QNTY<%= i %>" value="<%= stockdata.DEPS_QNTY %>">
                  <input type="hidden" name="BEGDA<%= i %>" value="<%= stockdata.BEGDA %>">
                  <input type="hidden" name="SHAR_TYPE<%= i %>" value="<%= stockdata.SHAR_TYPE %>">

        <tr class="<%=tr_class%>">
          <td><input type="radio" name="radiobutton" value="<%= i %>" <%=(i==0) ? "checked" : ""%>  ></td>
          <td><%= WebUtil.printNum(stockdata.INCS_NUMB) %></td>
          <td><%= stockdata.SHAR_TEXT %></td>
          <td><%= WebUtil.printNum(stockdata.DEPS_QNTY) %></td>
          <td><%= WebUtil.printDate(stockdata.BEGDA) %></td>
          <td><%= WebUtil.printNum(stockdata.OUTS_QNTY) %></td>
          <td class="lastCol"><%= WebUtil.printNum(stockdata.AFTR_QNTY) %></td>
        </tr>
<%
        }
%>
      </table>
    </div>
  </div>
  <!-- 조회 리스트 테이블 끝-->

  <!-- PageUtil 관련 - 반드시 써준다. -->

  <div class="align_center"><%= pu.pageControl() %></div>

  <!-- PageUtil 관련 - 반드시 써준다. -->
<%
    }
%>

</div>

<input type="hidden" name="jobid"  value="">
<input type="hidden" name="INCS_NUMB" value="">
<input type="hidden" name="SHAR_TEXT" value="">
<input type="hidden" name="DEPS_QNTY" value="">
<input type="hidden" name="BEGDA" value="">
<input type="hidden" name="SHAR_TYPE" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
