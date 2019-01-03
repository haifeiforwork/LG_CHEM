<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 코스트센터                                                  */
/*   Program Name : 부서별 코스트센터 조회                                      */
/*   Program ID   : F61DeptCostCenter.jsp                                       */
/*   Description  : 부서별 코스트센터 조회를 위한 jsp 파일                      */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptCostCenter_vt = (Vector)request.getAttribute("DeptCostCenter_vt");
%>

<SCRIPT LANGUAGE="JavaScript">
<!--

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
    if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
        alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
        return;
    }

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F61DeptCostCenterSV";
    frm.target = "_self";
    frm.submit();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F61DeptCostCenterSV";
    frm.target = "hidden";
    frm.submit();
}
//-->
</SCRIPT>

<html>
<head>
<title>MSS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">

<table width="796" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="780" border="0" cellpadding="0" cellspacing="0" align="left">
        <tr>
          <td height="10" colspan="2"></td> 
        </tr>
        <tr>
          <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">부서별 코스트센터 조회</td>
          <td class="titleRight"><a href="javascript:open_help('X04Statistics.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a></td>
        </tr>
         <tr>
          <td height="10" colspan="2"></td> 
        </tr>
      </table>
    </td>
  </tr>

<!--   부서검색 보여주는 부분 시작   -->
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <%@ include file="/web/common/SearchDeptInfo.jsp" %>
    </td>
  </tr>
<!--   부서검색 보여주는 부분  끝    -->

</table>

<%
    //부서명, 조회된 건수.
    if ( DeptCostCenter_vt != null && DeptCostCenter_vt.size() > 0 ) {
%>
<table border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16" nowrap>&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
          <td width="50%" class="td09">
            &nbsp;부서명 : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
            &nbsp;&nbsp;<a href="javascript:excelDown();"><img src="<%= WebUtil.ImageURL %>btn_EXCELdownload.gif" border="0" align="absmiddle"></a>
          </td>
          <td width="50%" class="td08"><총 <%=DeptCostCenter_vt.size()%> 건>&nbsp;</td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td >
        <table  border="0" cellspacing="1" cellpadding="4" class="table02" align="left">
          <tr>
            <td class="td03" nowrap>부서명</td>
            <td class="td03" nowrap>코스트센터명</td>
            <td class="td03" nowrap>코스트센터ID</td>
            <td class="td03" nowrap>시작일자</td>
            <td class="td03" nowrap>효력만료일</td>
          </tr>
<%
            for( int i = 0; i < DeptCostCenter_vt.size(); i++ ){
                F61DeptCostCenterData data = (F61DeptCostCenterData)DeptCostCenter_vt.get(i);
%>
          <tr align="center">
            <td class="td09" nowrap>&nbsp;<%= data.STEXT %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= data.KTEXT %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= data.KOSTL %>&nbsp;</td>
            <td class="td04" nowrap>&nbsp;<%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>&nbsp;</td>
            <td class="td04" nowrap>&nbsp;<%= (data.ENDDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.ENDDA) %>&nbsp;</td>
          </tr>
<%
            } //end for...
%>
        </table>
    </td>
    <td width="16" nowrap>&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>

<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr align="center">
    <td  class="td04" align="center" height="25" >해당하는 데이터가 존재하지 않습니다.</td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>
