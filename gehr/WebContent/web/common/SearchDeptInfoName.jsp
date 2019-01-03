<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서명만 검색                                                   */
/*   Program ID   : SearchDeptInfo.jsp                                          */
/*   Description  : 부서 검색을 위한 jsp 파일                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2008-11-10 lsa                                           */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.Vector" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
    String checkYn = WebUtil.nvl((String)request.getAttribute("checkYn"));     //하위부서여부.

    //하위부서여부.
    if (checkYn.equals("")) {
        checkYn = WebUtil.nvl(request.getParameter("checkYn"));
    }

    //check Flag.
    if (checkYn.equals("Y")) {
        checkYn = "checked";
    }else{
        checkYn = "";
    }
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
//부서명 검색
function dept_search() {
    var frm = document.form1;

    if ( frm.txt_deptNm.value == "" ) {
        alert("<spring:message code='MSG.COMMON.SEARCH.DEPT.REQUIR' />"); //검색할 부서명을 입력하세요!
        frm.txt_deptNm.focus();
        return;
    }
    small_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=500,height=420,left=100,top=100");
    small_window.focus();
    frm.target = "DeptNm";
    frm.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptNamePop.jsp";
    frm.submit();
}


//조직도 검사Popup.
function organ_search() {
    var frm = document.form1;

    small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=480,left=100,top=100");
    small_window.focus();
    frm.target = "Organ";
    frm.action = "<%=WebUtil.JspURL%>"+"common/OrganListPop.jsp";
    frm.submit();
}

function EnterCheck(){
    if (event.keyCode == 13)  {
        dept_search();
    }
}

// 체크박스 선택
function fncCheckbox(deptId, deptNm) {
    var frm = document.form1;

    if ( frm.chk_organAll.checked == true )
        frm.chck_yeno.value = 'Y';
    else
        frm.chck_yeno.value = 'N';

    //체크박스 선택시 자동검색.
    setDeptID(deptId, deptNm);
}
//-->
</SCRIPT>

  <table width="764" border="0" cellpadding="0" cellspacing="0" align="left">
    <tr>
      <td>
        <table width="764" height="29" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td background="<%= WebUtil.ImageURL %>bg_search_g.gif">
              <table width="764" height="29" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="152" align="center"><img src="<%= WebUtil.ImageURL %>search02.gif"></td>
                  <td width="1"><img src="<%= WebUtil.ImageURL %>line_dot_g.gif"></td>
                  <td width="220" align="right">
                    <font color="#585858"><spring:message code='LABEL.SEARCH.ORGEH.NAME' /><!-- 부서명 --></font>&nbsp;
                    <input type="text" name="txt_deptNm" size="25" maxlength="30" class="input03" value="<%=t_deptNm%>" onKeyDown="javascript:EnterCheck();" style="ime-mode:active" >
                  </td>
                  <td width="90" align="left">
                    <a href="javascript:dept_search();"><img src="<%= WebUtil.ImageURL %>btn_serch04_g.gif" border="0"></a>
                  </td>
                  <td width="1"><img src="<%= WebUtil.ImageURL %>line_dot_g.gif"></td>
                  <td width="271 align="right">&nbsp;</td>
                 <!-- <td width="25" align="right"><img src="<%= WebUtil.ImageURL %>icon_map_g.gif"></td>
                  <td width="80" align="right"><font color="#585858">하위조직포함</font></td>
                  <td width="26"><input type="checkbox" name="chk_organAll" value="" onClick="javaScript:fncCheckbox('<%=deptId%>', '<%=deptNm%>');" <%=checkYn%> ><INPUT type='hidden' name='chck_yeno' value='N' ></td>
                  <td width="140" align="left">
                    <a href="javascript:organ_search();"><img src="<%= WebUtil.ImageURL %>btn_serch03_g.gif" border="0"></a>
                  </td>-->
                </tr>
               </table>
             </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <table width="764" height="4" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="3"></td>
            <td><img src="<%= WebUtil.ImageURL %>ehr/space.gif" height="4"></td>
            <td width="3"></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td >
        <table width="764" height="20" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="60%" align="center"></td>
            <td width="40%" align="center" style="font-size: 11px;"><spring:message code='MSG.COMMON.0078' /><!-- * 하위조직포함을 선택하면 하위조직까지 조회됩니다. --></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>

<SCRIPT LANGUAGE="JavaScript">
<!--
// 체크박스 선택시 chck_yeno에 값 'Y'할당.
if( "<%=checkYn%>" == "checked" ){
    var frm = document.form1;
    frm.chck_yeno.value = 'Y';
}
//-->
</SCRIPT>