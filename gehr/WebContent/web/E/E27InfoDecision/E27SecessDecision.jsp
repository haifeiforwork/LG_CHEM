<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회 간사결재                                             */
/*   Program Name : 탈퇴신청 결재                                               */
/*   Program ID   : E27SecessDecision.jsp                                       */
/*   Description  : 탈퇴신청 결재                                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.E.E27InfoDecision.*" %>    

<%
    E27InfoDecisionData data = (E27InfoDecisionData)request.getAttribute("E27InfoDecisionData");
	E27InfoDecisionKey  key  = (E27InfoDecisionKey)request.getAttribute("E27InfoDecisionKey");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function doSubmit() {
    document.form1.BEGDA.value = changeChar( document.form1.BEGDA.value, "-", "" );
    document.form1.jobid.value     = "create";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E27InfoDecision.E27JoinDecisionSV";
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780">
              <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">탈퇴신청 결재</td>
                  <td align="right"><a href="#"><img src="<%= WebUtil.ImageURL %>ehr/bt_start.gif" border="0"></a></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
    <tr> 
      <td> 
        <table width="750" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 신청정보</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td> 
        <!--신청정보 테이블 시작-->
        <table width="780" border="0" cellspacing="1" cellpadding="0" class="table01">
                <tr> 
                  <td width="100" class="td01">동호회</td>
                  <td class="td09"><%= data.STEXT %></td>
                </tr>
                <tr> 
                  <td class="td01">신청구분</td>
                  <td class="td09"><%= data.INFO_TEXT %></td>
                </tr>
                <tr> 
                  <td class="td01">신청일</td>
                  <td class="td09"><%= WebUtil.printDate(data.BEGDA) %></td>
                </tr>
                <tr> 
                  <td class="td01">성명</td>
                  <td class="td09"><%= data.ENAME %></td>
                </tr>
                <tr> 
                  <td class="td01">사번</td>
                  <td class="td09"><%= WebUtil.printNum(data.PERNR) %></td>
                </tr>
        </table>
        <!--신청정보 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td> 
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td align="center"><td align="center"><%= data.APPR_STAT.equals("A") ? "" : "<a href=\"javascript:doSubmit()\"><img src='"+WebUtil.ImageURL+"btn_Decision.gif'\" border=\"0\" align=\"absmiddle\"></a>" %>  
              <a href="javascript:history.back()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" align="absmiddle" border="0"></a> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
<INPUT TYPE="hidden" name="jobid"     value="">
<INPUT TYPE="hidden" name="AINF_SEQN" value="<%= data.AINF_SEQN %>">
<INPUT TYPE="hidden" name="MGART"     value="<%= data.MGART %>">
<INPUT TYPE="hidden" name="STEXT"     value="<%= data.STEXT %>">
<INPUT TYPE="hidden" name="INFO_TYPE" value="<%= data.INFO_TYPE %>">
<INPUT TYPE="hidden" name="INFO_TEXT" value="<%= data.INFO_TEXT %>">
<INPUT TYPE="hidden" name="BEGDA"     value="<%= data.BEGDA %>">
<INPUT TYPE="hidden" name="PERNR"     value="<%= data.PERNR %>">
<INPUT TYPE="hidden" name="ENAME"     value="<%= data.ENAME %>">
<INPUT TYPE="hidden" name="APPR_STAT" value="<%= data.APPR_STAT %>">
<INPUT TYPE="hidden" name="APPR_TEXT" value="<%= data.APPR_TEXT %>">
<INPUT TYPE="hidden" name="BETRG" value="<%= data.BETRG %>">
<INPUT TYPE="hidden" name="APPL_DATE" value="">


<INPUT TYPE="hidden" name="P_INFO_TYPE" value="<%= key.P_INFO_TYPE %>">   
<INPUT TYPE="hidden" name="P_PERNR"     value="<%= key.P_PERNR %>">   
<INPUT TYPE="hidden" name="P_BEGDA"     value="<%= key.P_BEGDA %>">
<INPUT TYPE="hidden" name="P_ENDDA"     value="<%= key.P_ENDDA %>">   
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
