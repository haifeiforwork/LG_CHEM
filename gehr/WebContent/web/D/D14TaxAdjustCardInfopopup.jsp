<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : 패스워드 수정                                               */
/*   2Depth Name  : 패스워드 수정                                               */
/*   Program Name : 패스워드 수정                                               */
/*   Program ID   : D14TaxAdjustCardInfopopup.jsp                                                */
/*   Description  : 패스워드 수정                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-28 이승희                                           */
/*   Update       : C20130813_86689  2013-08-12 문자+숫자 조합 시 10자리 이상, 문자+숫자+특수문자 조합 시 8자리 이상으로 설정  */
/*   Update       :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정 (복잡도 부분 수정)                      */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*"%>
<%@ page session="false" %>


<HTML>
<HEAD>
<TITLE> 연말정산 신용카드 공제기준 </TITLE>
<style type=text/css>
/*ixss*/
td { font-size: 13px; font-family: 굴림 ; color:#666666;}
img {border: none;}
a {text-decoration:none}
a:hover {text-decoration: underline}

/*form*/
input {font-size: 12px; font-family: 굴림 ; color:#000000;}
.box03 { font-size:12px; font-family: 굴림 ; border:1px solid #B6AE9B; color:#666666; padding:2 0 0 5px}

/*color*/
.c, a.c:link, a.c:visited, a.c:hover, a.c:active{color:#000000}
</style>
<script>
<!--

-->
</script>
</HEAD>

<BODY onload="document.form1.webUserPwd.focus();init();">
<form method=post name=form1>

 <table width=630 >
 
   <tr><td class="td02" width="100%">
      ※ <b><font color=green>신용카드 공제기준 상세내역</font></b>
      <br>
      <br><b>총 소득의 25%이상 사용해야 함</b>
      <br>
      <br>* 공제금액(ⓐ+ⓑ+ⓒ+ⓓ-ⓔ+ⓕ)
      <br>ⓐ 전통시장사용분×30%
      <br>ⓑ 대중교통이용분×30%
      <br>ⓒ 현금영수증,직불카드사용분(전통시장&대중교통제외)×30%
      <br>ⓓ 신용카드사용분(전통시장&대중교통제외)×15%
      <br>ⓔ 다음 어느 항목에 해당하는 금액
      <br>&nbsp;&nbsp;&nbsp;&nbsp;-.총급여액의 25%≤신용카드사용분:최저사용금액×15%
      <br>&nbsp;&nbsp;&nbsp;&nbsp;-.총급여액의 25%＞신용카드사용분:신용카드사용분×15%＋(최저사용금액－신용카드사용분)×30%
      <br>ⓕ 본인이 사용한 '14년 신용카드등 사용분이 '13년 신용카드사용분이 많은 경우
      <br>&nbsp;&nbsp;&nbsp;&nbsp;전통시장,대중교통,직불카드,현금영수증이 다음에 해당하는 금액
      <br>&nbsp;&nbsp;&nbsp;&nbsp;-. (2014년 하반기 사용분－2013년 사용분×50%)×10%                        
     </td></tr>  
     <tr><td align=center><br><a href="javascript:this.close()"><IMG src="<%= WebUtil.ImageURL %>jms/btn_close.gif" BORDER=0></a></td>
     </tr>
 </table>
 
</form>
</BODY>
</HTML>
