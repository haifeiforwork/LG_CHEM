<%/* [CSR ID:2510507] 문구 수정 요청의 건| [요청번호]C20140325_10507 이지은D  2014-03-25 해당 건 받은 뒤 긴급반영(문구 수정) 직책/직무 삭제 (유한범D) */ %>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.A.A10Annual.*" %>
<%@ page import="hris.A.A10Annual.rfc.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
  	Vector      A10AnnualData_vt = (Vector)request.getAttribute("A10AnnualData_vt");
    String      jobid            = (String)request.getAttribute("jobid");
	  String      paging           = (String)request.getAttribute("page");
    PageUtil    pu               = null;
    
	  try {
        if( A10AnnualData_vt.size() != 0 ){
            pu = new PageUtil(A10AnnualData_vt.size(), paging , 10, 10);
            Logger.debug.println(this, "page : "+paging);
        }
	  } catch (Exception ex) {
		    Logger.debug.println(DataUtil.getStackTrace(ex));
	  }
    Logger.debug.println(this, A10AnnualData_vt.toString() );
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit() { //연봉계약서 page로 이동한다.
    document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A10Annual.A10AnnualListSV_m';
    document.form2.method = "post";
    document.form2.target = "listFrame";
    document.form2.submit();
}
                
function trans_form() {
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
          if( i == 0 && document.form1.BETRG0.value==0.0 ){//평가등급에서 연봉으로 변경
            command = 1;//전년도 값
          } else {
            command = document.form1.radiobutton[i].value;
          }
        }
    }
    eval("document.form2.ZYEAR.value = document.form1.ZYEAR"+command+".value");
    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=800,height=650");
    document.form2.jobid.value = "search";
    document.form2.target = "essPrintWindow";
    document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A10Annual.A10AnnualListSV_m';
    document.form2.method = "post";
    document.form2.submit();
    
    //doSubmit();
}       

// PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form2.page.value = page;
  document.form2.jobid.value = "page";
  doSubmit();
}

//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>icon_Darrow_next_o.gif','<%= WebUtil.ImageURL %>icon_arrow_next_o.gif','<%= WebUtil.ImageURL %>icon_Darrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_prev_o.gif')">
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="36">
      <td width="15">&nbsp;</td>
      <td class="td02">
        <font color="#0000FF"><%= "▶ " + user_m.ename + " " + user_m.e_titel + "의 HR정보입니다." + ( user_m.i_stat2.equals("0") ? " (퇴직자)" : "" ) %></font>
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="title01">나의 연봉</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
        <table width="730" border="0" cellspacing="0" cellpadding="0" height="23">
          <tr> 
<%
    if( A10AnnualData_vt.size() > 0 ) {
%>
  <% if (user_m.companyCode.equals("N100")) { %>
            <td valign="top"><a href="javascript:trans_form();" ><img src="<%= WebUtil.ImageURL %>btn_PaySerch.gif" width="113" height="20" border="0" align="absmiddle"></a></td>
  <% }else { %>
            <td valign="top">&nbsp;</td>
  <% } %>
            <td align="right" class="td02"><%= pu == null ?  "" : pu.pageInfo() %></td>
<%
    } else {
%>
            <td valign="top">&nbsp;</td>
            <td align="right" class="td02">&nbsp;</td>
<%
    } 
%>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
        <!-- 조회 리스트 테이블 시작-->
        <table width="730" border="0" cellspacing="1" cellpadding="3" class="table02">
          <tr> 
          <% if (user_m.companyCode.equals("N100")) { %>
            <td class="td03" width="40">선택</td>
          <% } %>
            <td class="td03" width="60" >년도</td>
            <td class="td03" width="116">소속</td>
            <td class="td03" width="80">직급/년차</td>
            <td class="td03" width="80">전년평가등급</td>
            <td class="td03" width="80">기본연봉</td>
            <td class="td03" width="80">수당계(월)</td>
            <td class="td03" width="80">연봉총액</td>
            <td class="td03" width="50">인상율</td>
          </tr>
<%
    if( A10AnnualData_vt.size() > 0 ) {
        int j = 0;// 내부 카운터용
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            A10AnnualData data = (A10AnnualData)A10AnnualData_vt.get(i);
%>
		      <tr> 
<% if (user_m.companyCode.equals("N100")) { %>
            <td class="td04"> 
              <input type="radio" name="radiobutton" value="<%= j %>" <%=(j==0) ? "checked" : ""%> >
            </td>
<% } %>
<% if (user_m.companyCode.equals("C100")&&data.ZYEAR.equals("2004")) { %>
            <td class="td04"><%=  WebUtil.printDate(data.BEGDA) %>&nbsp;</td>
<% }else { %>
            <td class="td04"><%= data.ZYEAR %>&nbsp;</td>
<% } %>
            <td class="td04"><%= (i==pu.formRow()) && (data.ORGTX).equals("") ? user_m.e_orgtx : data.ORGTX %>&nbsp;</td>
            <td class="td04"><%= (i==pu.formRow()) && (data.TRFGR).equals("") ? ( user_m.e_trfgr+"&nbsp;/&nbsp;"+ ((user_m.e_vglst).equals("") ? "-" : user_m.e_vglst )) : ( data.TRFGR+"&nbsp;/&nbsp;"+ ((data.VGLST).equals("") ? "-" : data.VGLST) )%>&nbsp;</td>
            <td class="td04"><%= data.EVLVL %>&nbsp;</td>
            <td class="td04"><%= WebUtil.printNumFormat(data.BETRG).equals("0") ? "" : WebUtil.printNumFormat(data.BETRG) %>&nbsp;</td>
            <td class="td04"><%= WebUtil.printNumFormat(data.BET01).equals("0") ? "" : WebUtil.printNumFormat(data.BET01) %>&nbsp;</td>
            <td class="td04"><%= WebUtil.printNumFormat(data.ANSAL).equals("0") ? "" : WebUtil.printNumFormat(data.ANSAL) %>&nbsp;</td>

            <td class="td04"><%= ( data.ZINCR.equals("0") && i == (pu.toRow()-1) ) ? "" :  WebUtil.printNumFormat(data.ANSAL).equals("0")  ? "" : data.ZINCR+"(%)"%>&nbsp;  <!-- 조건 연봉총액이 0 이거나 현재 값이 0일경우에  표시안함 -->
            </td>
              <input type="hidden" name="BETRG<%= j %>" value="<%= data.BETRG %>">
              <input type="hidden" name="EVLVL<%= j %>" value="<%= data.EVLVL %>">              
              <input type="hidden" name="ZYEAR<%= j %>" value="<%= data.ZYEAR %>">
         </tr>
<%   
            j++;
        }
    } else {
%>
          <tr align="center"> 
            <td class="td04" colspan="9">해당하는 데이터가 존재하지 않습니다.</td>
          </tr>
<%
    }
%>
        </table>
        <!-- 조회 리스트 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td class="td04" height="25" valign="bottom">
<!-- PageUtil 관련 - 반드시 써준다. -->
<%= pu == null ? "" : pu.pageControl() %>
<!-- PageUtil 관련 - 반드시 써준다. -->
	    </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="730" border="0" cellspacing="1" cellpadding="3">
          <tr>
            <td class="td02">○ 기본연봉 : 금년 3월부터 내년 2월까지 실수령하는 금액으로 [(月기본급 + 상여월할분) x 12 + 명절상여 x 2] 한 금액임.</td>
          </tr>
          <tr>
            <td class="td02" style="padding-left: 77px">→ 月기본급  = 명절상여 = 기본연봉의 20분의 1</td>
          </tr>                
          <tr>
            <td class="td02" style="padding-left: 93px">상여월할분 = 月기본급의 2분의 1</td>
          </tr> 
          <tr>
            <td class="td02" style="padding-left: 22px">☞ 중도 입사자 : 입사일로 부터 1년이 되는 날까지의 수령액 기준이며 내년도</td>
          </tr>
          <tr>
            <td class="td02" style="padding-left: 38px">급여조정시 회사가 정하는 바에 따라 연봉조정할 수 있다.</td>
          </tr>
          <tr>
            <!-- 2014/3/25 긴급반영 문구 수정 -->
            <!-- <td class="td02">○ 수당계(월) : 직책/자격/직무/기타수당 등(개인연금지원분 포함)</td>  -->
            <td class="td02">○ 수당계(월) : 자격/기타수당 등(개인연금지원분 포함)</td>            
          </tr>
          <tr>
            <td class="td02">○ 연봉총액 : 기본연봉 + 수당계(월) X 12 (성과급은 제외)</td>
          </tr>
          <tr>
            <td class="td02">○ 지급방법 :</td>
          </tr>
          <tr>
            <td class="td02" style="padding-left: 22px">- 매월 : 月기본급 + 상여월할분 + 수당계(월)</td>
          </tr>
          <tr>
            <td class="td02" style="padding-left: 22px">- 추석.설 : 명절상여</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>

<form name="form2" method="post" action="">
<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="page" value="<%= paging %>">
    <input type="hidden" name="ZYEAR" value="">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
