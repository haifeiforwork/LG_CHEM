<%/******************************************************************************/
/*																				*/
/*   System Name  : MSS															*/
/*   1Depth Name  : 신청															*/
/*   2Depth Name  : 부서근태														*/
/*   Program Name : 일일근무일정변경													*/
/*   Program ID   : D13SceduleChange|D13SceduleChange.jsp						*/
/*   Description  : 일일근무일정변경 화면												*/
/*   Note         : 															*/
/*   Creation     : 2009-03-20  김종서												*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ taglib prefix="tags-common" tagdir="/WEB-INF/tags/common" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ page import="hris.D.D13ScheduleChange.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
    String jobid      = WebUtil.nvl(request.getParameter("jobid"));
	Vector scheduleChangeData_vt       = (Vector)request.getAttribute("scheduleChangeData_vt"); //일일근무일정 데이터
    String I_DATE  = WebUtil.nvl(request.getParameter("I_DATE"));          //기간
    String I_ORGEH  = WebUtil.nvl(request.getParameter("I_ORGEH"));          //기간
    String deptNm = WebUtil.nvl((String)request.getAttribute("deptNm"));
    String I_GBN  = WebUtil.nvl(request.getParameter("I_GBN"));
    String I_SEARCHDATA  = WebUtil.nvl(request.getParameter("I_SEARCHDATA"));

    if( I_DATE == null|| I_DATE.equals("")) {
        I_DATE = DataUtil.getCurrentDate();
    }
    if(I_ORGEH == null || I_ORGEH.equals("")){
    	WebUserData user = WebUtil.getSessionUser(request);
    	I_ORGEH = user.e_orgeh;
    }

    String deptId       = I_ORGEH;                      //부서코드
%>


<c:set var="deptId" value="<%=deptId%>" />
<c:set var="deptNm" value="<%=deptNm%>" />
<c:set var="disabledSubOrg" value="true" />

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--


function handleError (err, url, line) {
   alert('Error : '+err + '\nURL : ' + url + '\n줄 : '+line);
   return true;
}

function EnterCheck(){
    if (event.keyCode == 13)  {
        pop_search();
    }
}



function setPersInfo( obj ){
	frm = document.all.form1;
    frm.hdn_deptId.value = obj.OBJID;
    frm.txt_deptNm.value = obj.STEXT;
    frm.hdn_deptNm.value = obj.STEXT;
    frm.hdn_excel.value = "";
// 	listFrame.form1.chck_yeno.value = document.form1.chck_yeno.value;
	eval("setDeptID(obj.OBJID, obj.STEXT)");
}

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
  frm = document.form1;

  frm.I_ORGEH.value = deptId;
  frm.I_SEARCHDATA.value = deptId;
  frm.txt_deptNm.value = deptNm;
  frm.jobid.value = "search";
	document.form1.I_DATE.value  = removePoint(document.form1.I_DATE.value);
  frm.action = "<%= WebUtil.ServletURL %>hris.D.D14PlanWorkTime.D14PlanWorkTimeSV";

  frm.target = "_self";
//   frm.submit();
	  listSetting();
}
<c:set var="deptTimelink" value="true" />
<%--

function pop_search(){

	if(document.form1.I_GBN.value == "ORGEH"||document.form1.I_GBN.value=="RECENT"){
		dept_search();
	}else if(document.form1.I_GBN.value == "PERNR"){
		pers_search();
	}
}

// 부서 검색
function dept_search()
{
	var frm = document.form1;
	document.form1.txt_deptNm.value = document.form1.txt_searchNm.value;

	if ( document.form1.I_GBN.value == "ORGEH"&&frm.txt_searchNm.value == "" ) {
		alert("<spring:message code='MSG.D.D12.0001'/>")//검색할 부서명을 입력하세요!
		frm.txt_searchNm.focus();
		return;
	}else if (document.form1.I_GBN.value=="RECENT"){
	   document.form1.txt_deptNm.value = "";
	}
	small_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=420,left=100,top=100");
	small_window.focus();

	var oldTarget = frm.target;
	var oldAction = frm.action;

	frm.target = "DeptNm";
	frm.action = "/web/common/SearchDeptNamePop.jsp";
// 	frm.action = "/web/D/D12Rotation/SearchDeptNamePop_Rot.jsp";
	frm.submit();
	frm.target = oldTarget;
    frm.action = oldAction;
}
//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    frm.I_ORGEH.value = deptId;
    frm.I_SEARCHDATA.value = deptId;
    frm.txt_deptNm.value = deptNm;
    frm.jobid.value = "search";
	document.form1.I_DATE.value  = removePoint(document.form1.I_DATE.value);
    frm.action = "<%= WebUtil.ServletURL %>hris.D.D13ScheduleChange.D13ScheduleChangeSV";

    frm.submit();
}

function pers_search(){
	var val = document.form1.txt_searchNm.value;
	document.form1.I_VALUE1.value = document.form1.txt_searchNm.value;

    val = rtrim(ltrim(val));

	if ( val == "" ) {
	    alert("<spring:message code='MSG.D.D13.0001'/>")//검색할 부서원 성명을 입력하세요!")
	    document.form1.txt_searchNm.focus();

	    return;
	} else {
	    if( val.length < 2 ) {
	        alert("<spring:message code='MSG.D.D12.0017'/>")//검색할 성명을 한 글자 이상 입력하세요!")
	        document.form1.txt_searchNm.focus();

	        return;
	    } else {
	        document.form1.jobid.value = "ename";
	    }
	}
	document.form1.retir_chk.value = "";

	small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");
    small_window.focus();

    var oldTarget = document.form1.target;
	var oldAction = document.form1.action;

    document.form1.target = "DeptPers";
    //document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersonsWait_T.jsp";
    document.form1.action = "<%=WebUtil.JspURL%>"+"D/D12Rotation/SearchDeptPersonsWait_Rot.jsp";
    document.form1.submit();
    document.form1.target = oldTarget;
    document.form1.action = oldAction;
}

function setPersInfo( obj ){

	//document.form1.I_SEARCHDATA.value = obj.PERNR;
    document.form1.I_SEARCHDATA.value = obj.EPERNR;
	document.form1.txt_searchNm.value = obj.ENAME;

    document.form1.I_ORGEH.value = obj.OBJID;
    document.form1.txt_deptNm.value = obj.STEXT;
	document.form1.jobid.value = "search";
	document.form1.I_DATE.value  = removePoint(document.form1.I_DATE.value);
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D13ScheduleChange.D13ScheduleChangeSV";

    document.form1.submit();
}
--%>


// 저장
function doSaveData() {
	if( check_data() ) {
		//buttonDisabled();

		document.form1.I_DATE.value  = removePoint(document.form1.I_DATE.value);
		document.form1.jobid.value = "save";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D13ScheduleChange.D13ScheduleChangeSV";
        document.form1.method = "post";
        document.form1.submit();
	}
}



function check_data(){

	if(!confirm("<spring:message code='MSG.COMMON.SAVE.CONFIRM'/>")){//저장 하시겠습니까?")){
		return false;
	}


	return true;
}

//기준일자 변경시 교대조 리스트를 다시 조회한다.
function after_listSetting(){
    listSetting();
}

function listSetting() {


    document.form1.I_DATE.value = removePoint(document.form1.I_DATE.value);

	document.form1.jobid.value   = "search";

	document.form1.jobid.value = "";
	document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D13ScheduleChange.D13ScheduleChangeSV";
	document.form1.method        = "post";
	document.form1.submit();
}

function doSearchTprog( idx, i_datum, _pernr ){

	var retVal = window.showModalDialog("<%= WebUtil.ServletURL %>hris.D.D13ScheduleChange.D13ScheduleChangePopupSV?PERNR="+_pernr +"&I_DATE="+removePoint(document.form1.I_DATE.value), null, "center:yes; dialogWidth:520px; dialogHeight:450px; status:no; help:no; scroll:no");
	if(retVal == undefined) return;
	eval("document.form1.TPROG2_"+idx+".value = retVal.TPROG");
	eval("document.form1.TTEXT2_"+idx+".value = retVal.TTEXT");
	eval("document.form1.VARIA2_"+idx+".value = retVal.VARIA");

	var codText = retVal.TPROG +"("+ retVal.TTEXT +")";
	eval("document.form1.sTTEXT2_"+idx+".value = codText");

}

function doSearchTprog_new( idx, i_datum){
<%--
	$('#ifpopup').attr("src","<%= WebUtil.ServletURL %>hris.D.D13ScheduleChange.D13ScheduleChangePopupSV?I_DATE="+removePoint(document.form1.I_DATE.value)  +
			"&rowNum="+idx);
	showPop();
 --%>
	var retVal = window.showModalDialog('${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangePopupSV?I_DATE=' +"&rowNum="+idx,
			'', "dialogWidth:650px,dialogHeight:450");
	if(retVal != undefined){

		$("#TPROG2_" + idx).val(retVal.TPROG);
		$("#TPROG_" + idx).val(retVal.TPROG);
		$("#VARIA2_" + idx).val(retVal.VARIA);
		$("#TTEXT2_" + idx).val(retVal.TTEXT);
		var codText = retVal.TPROG +"("+ retVal.TTEXT +")";
		$("#sTTEXT2_" + idx).val(codText);
	}
}

function showPop(){
	$('#popupframe').show();
}

function hidePop(){
	$('#popupframe').hide();
}

$(function(){
	//$('#popupframe').hide();
	var height = document.body.scrollHeight;
	parent.resizeIframe(height);
});

function blockFrame() {
}

//-->
</script>



<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp"/>


<form name="form1" method="post" onsubmit="return false">

<input type="hidden" name="jobid"   value="<%=jobid %>">
<input type="hidden" name="I_ORGEH"  value="<%=I_ORGEH%>">
<input type="hidden" name="row_count"  value="<%=scheduleChangeData_vt.size()%>">
<input type="hidden" name="I_SEARCHDATA"  value="<%=I_SEARCHDATA%>">
<input type="hidden" name="retir_chk"  value="">
<input type="hidden" name="I_GUBUN"  value="2">
<input type="hidden" name="I_VALUE1"  value="">
<%-- <input type="hidden" name="txt_deptNm"  value="<%=deptNm%>"> --%>

<input type="hidden" name="hdn_isPop"   value="<%=WebUtil.nvl(request.getParameter("hdn_isPop"))%>">
<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">

<!--   부서검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>
<!--   부서검색 보여주는 부분  끝    -->

  <div class="tableInquiry">
    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <th width="90"><spring:message code='LABEL.D.D14.0003'/><!-- 조회일자 --></th>
        <td>
          <input type="text" class="date" name="I_DATE" value="<%= WebUtil.printDate(I_DATE) %>" size="10" onBlur="">

          <div class="tableBtnSearch tableBtnSearch2">
          	<a href="javascript:after_listSetting()" class="search">
          		<span><spring:message code='BUTTON.COMMON.SEARCH'/><!--조회--></span></a>
          </div>
        </td>
        <%--
        <td class="divider">&nbsp;</td>
        <td width="50">
          <select name="I_GBN" width="100%">
            <option value="ORGEH" <%=I_GBN.equals("ORGEH")? "selected" : "" %>><spring:message code='LABEL.D.D12.0005'/><!--부서명--></option>
            <option value="PERNR" <%=I_GBN.equals("PERNR")? "selected" : "" %>><spring:message code='LABEL.D.D12.0006'/><!--사원명--></option>
          </select>
         </td>
         <td>
          <input type="text" name="txt_searchNm" size="20" maxlength="30" value="" onKeyDown="javascript:EnterCheck();" style="ime-mode:active" >
          <div class="tableBtnSearch tableBtnSearch2">
          	<a href="javascript:pop_search();" class="search">
          		<span><spring:message code='LABEL.D.D13.0002'/><!--부서명으로 조회--></span></a>
          </div>
        </td> --%>
      </tr>
    </table>
  </div>

  <div class="tableArea">
  <div class="table">
    <table class="listTable" >
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
      <tr>
        <th width="90"><spring:message code='LABEL.D.D12.0017'/><!--사원번호--></th>
        <th width="100"><spring:message code='LABEL.D.D12.0018'/><!--성명--></th>
        <th width="130"><spring:message code='LABEL.D.D13.0003'/><!--적용일--></th>
        <th width="50"><spring:message code='LABEL.D.D13.0004'/><!--코드--></th>
        <th width="150"><spring:message code='LABEL.D.D13.0005'/><!--정상 일일근무일정--></th>
        <th class="lastCol" width=""><spring:message code='LABEL.D.D13.0006'/><!--수정 일일근무일정--></th>
      </tr>
			<%
			for(int i=0; i<scheduleChangeData_vt.size(); i++){
			  D13ScheduleChangeData data = (D13ScheduleChangeData)scheduleChangeData_vt.get(i);
			%>
		      <input type="hidden" id="PERNR_<%=i%>" 		name="PERNR_<%=i%>" value="<%= data.PERNR %>">
		      <input type="hidden" id="ENAME_<%=i%>" 	name="ENAME_<%=i%>"value="<%= data.ENAME %>">
		      <input type="hidden" id="BEGDA_<%=i%>" 		name="BEGDA_<%=i%>" value="<%= data.BEGDA %>">
		      <input type="hidden" id="TPROG_<%=i%>" 	name="TPROG_<%=i%>"value="<%= data.TPROG %>">
		      <input type="hidden" id="TPROG2_<%=i%>" 	name="TPROG2_<%=i%>" value="<%= data.TPROG2 %>">
		      <input type="hidden" id="VARIA2_<%=i%>" 	name="VARIA2_<%=i%>"value="<%= data.VARIA2 %>">
		      <input type="hidden" id="TTEXT2_<%=i%>" 	name="TTEXT2_<%=i%>"value="">
      <tr  height=25>
	        <td><%= data.PERNR %></td>
	        <td><%= data.ENAME %></td>
	        <td><%= data.BEGDA %></td>
	        <td><%= data.TPROG %></td>
	        <td><%= data.TTEXT %></td>
	        <td class="lastCol">
		          <input type="text" id="sTTEXT2_<%=i%>" name="sTTEXT2_<%=i%>" value="<%= data.TTEXT2 %>" size="22"  style="ime-mode:active" disabled>
		          <a href="javascript:doSearchTprog('<%= i %>',removePoint(document.form1.I_DATE.value), '<%=data.PERNR%>' );">
           			 <img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png"  name="image" align="absmiddle" border="0">
          		  </a>
        	</td>
      </tr>
<%} %>


    </table>
  </div>
  </div>

      <!-- 상단 입력 테이블 끝-->
  <div class="buttonArea underList">
    <ul class="btn_crud">
      <li><a class="darken" href="javascript:doSaveData();"><span><spring:message code="BUTTON.COMMON.SAVE"/></span></a></li>
    </ul>
  </div>
</div>


<!-- HIDDEN  처리해야할 부분 시작 -->
<!-- HIDDEN  처리해야할 부분 끝   -->
</form>

<div id="popupframe" style="border:1px #b4b4b4 solid; display:none; position:absolute; top:100px; right:200px; width:570px; height:450px ;">
	<iframe id="ifpopup" name="ifpopup" width="100%" height="100%"
		src="" scrolling="no"  />
</div>

<iframe name="ifHidden" width="0" height="0"  />

<!-------hidden------------>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->