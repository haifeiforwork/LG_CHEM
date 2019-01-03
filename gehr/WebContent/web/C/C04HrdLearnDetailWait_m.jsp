<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육이력                                                    */
/*   Program Name : 교육이력                                                    */
/*   Program ID   : C04HrdLearnDetailWait.jsp                                   */
/*   Description  : 교육 이력 조회                                              */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2008-08-21  lsa                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.Vector" %>
<%
    String pernr = (String)request.getParameter("pernr"); 
    String IM_SORTKEY = (String)request.getParameter("IM_SORTKEY"); 
    String IM_SORTDIR = (String)request.getParameter("IM_SORTDIR"); 
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function doSubmit(){
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04HrdLearnDetailSV_m";
    document.form1.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:doSubmit()">
<form name="form1" method="post">
  <table width="766" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="760" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td><table width="760" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td height="5" colspan="2"></td>
                </tr>
                <tr> 
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">교육이력 조회</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td> 
              <!--교육이수현황 리스트 테이블 시작-->
              <table width="760" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td align="left">
                  <a href="javascript:excelDown();"><img src="<%= WebUtil.ImageURL %>btn_EXCELdownload.gif" border="0" align="absmiddle"></a>
                  </td>
                  <td class="td02" align="right"><font color="#006699">※ Y : 이수, N : 미이수&nbsp;</font></td>
                </tr>
              </table></td>
          </tr>
 
    <tr> 
      <td> 
        <!--교육이수현황 리스트 테이블 시작-->
        <table width="760" border="0" cellspacing="1" cellpadding="2" class="table02">
          <tr> 
            <td class="td03" width="140">과정명</td>
            <td class="td03" width="100">차수명</td>
            <td class="td03" width="130">교육기간</td>
            <td class="td03" width="140">주관부서</td>
            <td class="td03" width="40">이수</td>
            <td class="td03" width="40">평가</td>
            <td class="td03" width="60">필수과정</td>
            <td class="td03" width="60">교육형태</td>      
          </tr>
        </table>
        <!--교육이수현황 리스트 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td>
        <table width="760" border="0" cellspacing="1" cellpadding="2">
          <tr><td>&nbsp;</td></tr>
          <tr><td>&nbsp;</td></tr>
          <tr><td>&nbsp;</td></tr>
          <tr> 
            <td class="td04" align="center"><font color="#006699">조회중입니다. 잠시만 기다려주십시요.</font></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <input type="hidden" name="pernr" value="<%=pernr%>">
  <input type="hidden" name="jobid2" value="detail">
<input type="hidden" name="IM_SORTKEY" value="<%=IM_SORTKEY%>">
<input type="hidden" name="IM_SORTDIR" value="<%=IM_SORTDIR%>">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
