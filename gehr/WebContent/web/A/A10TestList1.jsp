<%@ page contentType="text/html; charset=utf-8" %>
<!--%@ include file="/web/common/commonProcess.jsp" %-->
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
//    	WebUserData user             = (WebUserData)session.getAttribute("user");
		    	
%>

<html>
<head>
<title>리더십 진단평가</title>
<link rel="stylesheet" href="<%= WebUtil.ServletURL %>css/ess1.css" type="text/css">
<SCRIPT LANGUAGE="JavaScript">
<!--
function trans_form() { 
   
    document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A10TestSV';
    document.form1.method = "post";
    document.form1.submit();
}
                
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="15">&nbsp; </td>
    <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td align="right">
              &nbsp; <img name="Image6" border="0" src=<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="도움말"></a>
            </td>
          </tr>
          <tr> 
            <td class="title01">진단대상자관리</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
    </td>
  </tr>
  <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <form name="form1" method="post" action="">
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
        <!-- 상단 입력 테이블 시작-->
        <table width="750" border="0" cellspacing="1" cellpadding="0" class="table01">
          <tr> 
            <td class="tr01"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="2">
                <tr> 
                  <td class="td01">년도&nbsp;<font color="#0000FF"><b>*</b></font></td>
                   <td class="td02">
                   <select name="YEAR" class="input03">
                    <option value="">-------------</option>
                         
                    </select>
                  </td>
                </tr>
                <tr> 
                  <td class="td01">차수&nbsp;<font color="#0000FF"><b>*</b></font></td>
                   <td class="td02">
                   <select name="CHASU" class="input03">
                    <option value="">-------------</option>
                    </select>
                  </td>
                </tr>
                <tr> 
                  <td width="13%" class="td01">조회구분&nbsp;<font color="#0000FF"><b>*</b></font></td>
                   <td class="td02">
                   <input type="radio" name="SEARCH_GUBUN" value="1" >
                   조직별조회
                   <input type="radio" name="SEARCH_GUBUN" value="2" >
                   계층별조회
                   </td>
                  <tr>
                   <td class="td01">사업본부&nbsp;</td>
                   <td class="td02" >
                   <select name="SAUPBONBU" class="input03">
                    <option value="">-------------</option>
                    </select>
                   </td>
                   <td class="td01">사업부&nbsp;</td>
                   <td class="td02">
                   <select name="SAUPBU" class="input03">
                    <option value="">-------------</option>
                    </select>
                   </td>
                   <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                   
                   </tr>                   
                   <td class="td01">계층&nbsp;</td>
                   <td class="td02">
                   <select name="CLSS" class="input03">
                    <option value="">-------------</option>
                    </select>
                 
                   </td>
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
      <td width="15">&nbsp;</td>
      <td class="td02">
        <font color="#0000FF"><b>&nbsp;&nbsp;*</b> 는 필수 입력사항입니다.</font>
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
            <td valign="top"><a href="javascript:trans_form();" ><img src="<%= WebUtil.ImageURL %>btn_serch.gif" width= "30" height="20" border="0" align="left"></a></td>
            <td valign="top">&nbsp;</td>
            <td align="right" class="td02">&nbsp;</td>
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
            <td class="td03" width="40">선택</td>
            <td class="td03" width="60" >사번</td>
            <td class="td03" width="116">이름</td>
            <td class="td03" width="80">계층</td>
            <td class="td03" width="130">소속</td>
            <td class="td03" width="80">신분</td>
            <td class="td03" width="80">직위</td>
            <td class="td03" width="80">직책</td>
          </tr>

          <tr align="center"> 
            <td class="td04" colspan="9">해당하는 데이터가 존재하지 않습니다.</td>
          </tr>
        </table>
        <!-- 조회 리스트 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td class="td04" height="25" valign="bottom">
	    </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>

<form name="form2" method="post" action="">
<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="page" value="">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
</body>
</html>
