<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서 검색                                                   */
/*   Program ID   : SearchDeptInfo.jsp                                          */
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
<%--@ include file="/include/includeCommon.jsp"--%>

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
        //alert("검색할 부서명을 입력하세요!");
        alert("<%=g.getMessage("MSG.F.FCOMMON.0001")%>");
        frm.txt_deptNm.focus();
        return;
    }
    small_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=420,left=100,top=100");
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
    frm.action = "<%=WebUtil.ServletURL%>"+"hris.common.OrganListPopSV";
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

<link rel="stylesheet" href="${g.image}css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="${g.image}css/ehr_wsg.css" type="text/css">

<style type="text/css">
table {font-size:12px;}
img, td {vertical-align:middle;}
.searchOrg {padding-left:10px;background:url(<%= WebUtil.ImageURL %>/ehr_common/bull_dot.gif) no-repeat 2px 7px;}
.searchOrg_ment {text-align:right;font-size:11px;color:#999;margin-bottom:15px;}
.searchOrg_box {width:780px;height:47px;background:url(<%= WebUtil.ImageURL %>/ehr_common/searchorg_bg.gif) no-repeat;margin:0 0 10px 0;;}
.searchL {padding:0 0 4px 150px;}
.searchL input {border:solid 1px #ddd;line-height:19px;height:19px;margin:0 4px 0 4px;font-family:malgun gothic;font-size:12px;color:#666;}
.searchR {padding:0 20px 4px 0;text-align:right;}
.searchR img {margin-right:6px;}
</style>
<div class="tableInquiry ">
	<table border="0">
	<colgroup>
		<col width="20%"/>
		<col width="15%"/>
		<col width="20%" />
		<col />
		<col />
	</colgroup>
	<tbody>
		<tr>
			<th>
				<img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
				<!--부서명--><%=g.getMessage("LABEL.F.FCOMMON.0001")%>
			</th>
			<td>
				<input type="text" name="txt_deptNm" size="25" maxlength="30" value="<%=deptNm%>" onKeyDown="javascript:EnterCheck();" style="ime-mode:active" >
			</td>
			<td>
				<div class="tableBtnSearch"><a class="search" href="javascript:dept_search();"><span><!--부서찾기--><%=g.getMessage("LABEL.F.FCOMMON.0002")%></span></a></div>
			</td>
			<th class="divider">
				<img class="searchIcon" src="<%= WebUtil.ImageURL %>sshr/icon_map_g.gif" />
				<span><!--하위조직포함--><%=g.getMessage("LABEL.F.FCOMMON.0003")%></span>
				<input type="checkbox" name="chk_organAll" value="" onClick="javaScript:fncCheckbox('<%=deptId%>', '<%=deptNm%>');" <%=checkYn%> >
				<INPUT type='hidden' name='chck_yeno' value='N' >
			</th>
			<td>
				<div class="tableBtnSearch"><a class="search" href="javascript:organ_search();"><span><!--조직도로 부서찾기--><%=g.getMessage("LABEL.SEARCH.ORGEH")%></span></a></div>
			</td>
		</tr>
	</tbody>
	</table>
</div>


<!--
		<div class="searchOrg_box">
              <table width="780" height="47" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td class="searchL">
                    <font color="#585858">부서명</font>&nbsp;
                    <input type="text" name="txt_deptNm" size="25" maxlength="30" class="input03" value="<%=deptNm%>" onKeyDown="javascript:EnterCheck();" style="ime-mode:active" >
                    <a href="javascript:dept_search();"><img src="<%= WebUtil.ImageURL %>btn_serch04_g.gif" border="0"></a>
                  </td>
                  <td class="searchR">
                  	<img src="<%= WebUtil.ImageURL %>icon_map_g.gif">
                  	<font color="#585858">하위조직포함</font>
                  	<input type="checkbox" name="chk_organAll" value="" onClick="javaScript:fncCheckbox('<%=deptId%>', '<%=deptNm%>');" <%=checkYn%> >
                  	<INPUT type='hidden' name='chck_yeno' value='N' >
                    <a href="javascript:organ_search();"><img src="<%= WebUtil.ImageURL %>btn_serch03_g.gif" border="0"></a>
                  </td>
                </tr>
               </table>
		</div>
 -->
		<div class="searchOrg_ment" style="margin-top:-15px;"><!--* 하위조직포함을 선택하면 하위조직까지 조회됩니다.--><%=g.getMessage("LABEL.F.FCOMMON.0005")%></div>


<SCRIPT LANGUAGE="JavaScript">
<!--
// 체크박스 선택시 chck_yeno에 값 'Y'할당.
if( "<%=checkYn%>" == "checked" ){
    var frm = document.form1;
    frm.chck_yeno.value = 'Y';
}
//-->
</SCRIPT>