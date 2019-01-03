<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript"> 
function f_print(){
     if( confirm("① [도구]->[인터넷 옵션]->[고급]->[인쇄]의 [배경색 및 이미지 인쇄]를 체크하시기 바랍니다.") ) {
             self.print();  
     }
 
}                
</SCRIPT>              
</head>                        
                               
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <table width="620" border="0" cellspacing="1" cellpadding="2" align="center">
    <tr>
      <td width="810">&nbsp;</td>
    </tr>
    <tr>
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810" align="center">
        <font size="5" face="굴림, 굴림체"><u><b>보증용 재직증명서 발급합의서</b></u></font>
      </td>
    </tr>
    <tr>
      <td width="810">&nbsp;</td>
    </tr>
    <tr>
      <td width="810">&nbsp;</td>
    </tr>
    <tr>
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810" align="center">
        <font size="3" face="굴림, 굴림체"><b>본인은 아래 합의자의 합의하에 보증용 재직증명서 발급을 신청합니다.</b></font>
      </td>
    </tr>
    <tr>
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810" align="center">
        <font size="3" face="굴림, 굴림체"><b>▣&nbsp;&nbsp;아&nbsp;&nbsp;&nbsp;&nbsp;래&nbsp;&nbsp;▣</b></font>
      </td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810"> 
        <table width="620" border="1" cellspacing="0" cellpadding="4" bordercolor="#000000">
          <tr>
            <td width="25" rowspan="4" align="center">
              <font size="2" face="굴림, 굴림체"><b>보증인</b></font>
            </td>
            <td width="130" align="center">
              <font size="2" face="굴림, 굴림체"><b>사&nbsp;&nbsp;번</b></font>
            </td>
            <td width="150" align="center">
              <font size="2" face="굴림, 굴림체"><b>성&nbsp;&nbsp;명</b></font>
            </td>
            <td width="185" align="center">
              <font size="2" face="굴림, 굴림체"><b>주민등록번호</b></font>
            </td>
            <td width="130" align="center">
              <font size="2" face="굴림, 굴림체"><b>연락처</b></font>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
              <font size="2" face="굴림, 굴림체"><b>본&nbsp;&nbsp;적</b></font>
            </td>
            <td colspan="2">&nbsp;</td>
            <td align="center">
              <font size="2" face="굴림, 굴림체"><b>발급매수</b></font>
            </td>
          </tr>
          <tr>
            <td align="center">
              <font size="2" face="굴림, 굴림체"><b>현주소</b></font>
            </td>
            <td colspan="2">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810"> 
        <table width="620" border="1" cellspacing="0" cellpadding="4" bordercolor="#000000">
          <tr>
            <td width="25" rowspan="4" align="center">
              <font size="2" face="굴림, 굴림체"><b>합의자</b></font>
            </td>
            <td width="130" align="center">
              <font size="2" face="굴림, 굴림체"><b>관&nbsp;&nbsp;계</b></font>
            </td>
            <td width="150" align="center">
              <font size="2" face="굴림, 굴림체"><b>성&nbsp;&nbsp;명</b></font>
            </td>
            <td width="185" align="center">
              <font size="2" face="굴림, 굴림체"><b>주민등록번호</b></font>
            </td>
            <td width="130" align="center">
              <font size="2" face="굴림, 굴림체"><b>연락처</b></font>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810"> 
        <table width="620" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="400">&nbsp;</td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="60" align="right">&nbsp;</td>
            <td width="40" align="left">
              <font size="2" face="굴림, 굴림체"><b>&nbsp;년</b></font>
            </td>
            <td width="40" align="right">
              <font size="2" face="굴림, 굴림체"><b>월</b></font>
            </td>
            <td width="40" align="right">&nbsp;</td>
            <td width="40" align="center">
              <font size="2" face="굴림, 굴림체"><b>일</b></font>
            </td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="60" align="right">
              <font size="2" face="굴림, 굴림체"><b>보 증 인</b></font>
            </td>
            <td width="120" align="left" colspan="3">
              <font size="2" face="굴림, 굴림체"><b>&nbsp;:</b></font>
            </td>
            <td width="40" align="left">
              <font size="2" face="굴림, 굴림체"><b>(印)</b></font>
            </td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="60" align="right">
              <font size="2" face="굴림, 굴림체"><b>합 의 자</b></font>
            </td>
            <td width="120" align="left" colspan="3">
              <font size="2" face="굴림, 굴림체"><b>&nbsp;:</b></font>
            </td>
            <td width="40" align="left">
              <font size="2" face="굴림, 굴림체"><b>(印)</b></font>
            </td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400">&nbsp;</td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400" align="left">
              <font size="2" face="굴림, 굴림체"><b>* 합의자 자격 : 기혼자 - 배우자, 미혼자 - 부모</b></font>
            </td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
          <tr>
            <td width="400" align="left">
              <font size="2" face="굴림, 굴림체"><b>* 보증인과 합의자란은 서명 또는 날인함.</b></font>
            </td>
            <td width="220" colspan="5">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
