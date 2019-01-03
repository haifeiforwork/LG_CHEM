<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서 검색                                                   */
/*   Program ID   : D12SearchDeptInfo.jsp                                          */
/*   Description  : 부서 검색을 위한 jsp 파일                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-27 유용원                                           */
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
function pop_search(){

	if(document.form1.I_GBN.value == "ORGEH" ){
		dept_search();
	}else if(document.form1.I_GBN.value == "PERNR"){
		pers_search();
	}
}

//부서명 검색
function dept_search() {
    var frm = document.form1;

    if (   frm.txt_deptNm.value == "" ) {
        //alert("검색할 부서명을 입력하세요!")
        alert("<%=g.getMessage("MSG.D.D12.0001")%>");
        frm.txt_deptNm.focus();
        return;
    }
    small_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=420,left=100,top=100");
    small_window.focus();
    frm.target = "DeptNm";
    frm.action = "/web/common/SearchDeptNamePop.jsp";
<%--     frm.action = "<%=WebUtil.JspURL%>"+"D/D12Rotation/SearchDeptNamePop_Rot.jsp"; --%>
    frm.submit();
}

function pers_search(){
	//var val = document.form1.txt_searchNm.value;
	//document.form1.I_VALUE1.value = document.form1.txt_searchNm.value;
	var val = document.form1.txt_deptNm.value;
	document.form1.I_VALUE1.value = document.form1.txt_deptNm.value;

        if ( val == "" ) {
	    //alert("검색할 부서원 성명을 입력하세요!")
	    alert("<%=g.getMessage("MSG.D.D13.0001")%>");
	    document.form1.txt_deptNm.focus();

	    return;
	} else {
	    if( val.length < 2 ) {
	        //alert("검색할 성명을 한 글자 이상 입력하세요!");
	        alert("<%=g.getMessage("MSG.D.D12.0002")%>");
	        document.form1.txt_deptNm.focus();

	        return;
	    }
	}



	small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=550,height=460,left=100,top=100");
        small_window.focus();

	var oldTarget = document.form1.target;
	var oldAction = document.form1.action;

    document.form1.target = "DeptPers";
    document.form1.action = "<%=WebUtil.JspURL%>"+"D/D12Rotation/SearchDeptPersonsWait_Rot.jsp";
    document.form1.submit();

    document.form1.target = oldTarget;
    document.form1.action = oldAction;
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
        pop_search();
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
                  <td width="300" align="right">
                    <!--<font color="#585858">부서명</font>&nbsp;
                    -->
          <select name="I_GBN" class="input03">
            <option value="ORGEH"><!-- 부서명 --><%=g.getMessage("LABEL.D.D15.0119")%></option>
            <option value="PERNR"><!-- 사원명 --><%=g.getMessage("LABEL.F.FCOMMON.0009")%></option>
          </select>
<input type="text" name="txt_deptNm" size="30" maxlength="30" class="input03" value="<%=deptNm%>" onKeyDown="javascript:EnterCheck();" style="ime-mode:active" >
                  </td>
                  <td width="150" align="left">
                    <a href="javascript:pop_search();"><img src="<%= WebUtil.ImageURL %>r_ico_search.gif" border="0"></a>
                  </td>
                  <td width="1"><img src="<%= WebUtil.ImageURL %>line_dot_g.gif"></td>
                  <td width="25" align="right"><img src="<%= WebUtil.ImageURL %>icon_map_g.gif"></td>
                  <td width="80" align="right"><font color="#585858"><!-- 하위조직포함 --><%=g.getMessage("LABEL.F.FCOMMON.0003")%></font></td>
                  <td width="26"><input type="checkbox" name="chk_organAll" value="" onClick="javaScript:fncCheckbox('<%=deptId%>', '<%=deptNm%>');" <%=checkYn%> ><INPUT type='hidden' name='chck_yeno' value='N' ></td>
                  <!--<td width="140" align="left">
                    <a href="javascript:organ_search();"><img src="<%= WebUtil.ImageURL %>btn_serch03_g.gif" border="0"></a>
                  </td-->
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
            <td width="40%" align="center" style="font-size: 11px;"><!-- * 하위조직포함을 선택하면 하위조직까지 조회됩니다. --><%=g.getMessage("LABEL.F.FCOMMON.0005")%></td>
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