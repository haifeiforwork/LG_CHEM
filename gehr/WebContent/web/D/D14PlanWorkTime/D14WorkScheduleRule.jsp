<%/******************************************************************************/
/*																				              */
/*   System Name  : GEHR															  */
/*   1Depth Name  : My HR															  */
/*   2Depth Name  : 부서근태														  */
/*   Program Name : 근무일정규칙 변경											  */
/*   Program ID   : D14PlanWorkTime|D14WorkScheduleRule.jsp		  */
/*   Description  : 근무일정규칙 조회/변경 화면(TD44)						  */
/*   Note         : 															              */
/*   Creation     : 2009-03-25 김종서											       */
/*   Update       : 2016-08-30  GEHR 김승철											               */
/*																				                      */
/********************************************************************************/%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D14PlanWorkTime.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
	String jobid      = WebUtil.nvl(request.getParameter("jobid"));
	Vector workScheduleRule_vt       = (Vector)request.getAttribute("workScheduleRule_vt"); //일일근무일정 데이터
    String I_DATE  = WebUtil.nvl(request.getParameter("I_DATE"));          //기간
    String I_ORGEH  = WebUtil.nvl(request.getParameter("I_ORGEH"));          //
    String deptNm = (String)request.getAttribute("deptNm");

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

//     String checkYn = WebUtil.nvl((String)request.getAttribute("checkYN")); //하위부서여부.
	//하위부서여부.
// 	if (checkYn.equals("")) {
// 		checkYn = WebUtil.nvl(request.getParameter("checkYn"));
// 	}


    String isPop = WebUtil.nvl(request.getParameter("hdn_isPop"));
%>
<c:set var="deptId" value="<%=deptId%>" />
<c:set var="deptNm" value="<%=deptNm%>" />
<c:set var="disabledSubOrg" value="true" />
<c:set var="deptTimelink" value="true" />

<jsp:include page="/include/header.jsp" />


<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />


<!-- body header 부 title 및 body 시작 부 선언 -->
    <jsp:include page="/include/body-header.jsp" />

    <!-- 내용부 선언 -->

<form name="form1" method="post" onsubmit="return false">

<input type="hidden" name="jobid"   value="<%=jobid %>">
<input type="hidden" name="I_ORGEH"  value="<%=I_ORGEH%>">
<input type="hidden" name="row_count"  value="<%=workScheduleRule_vt.size()%>">
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

  <div class="title">
    <h1><spring:message code="LABEL.D.D14.0002"/></h1> <!-- 근무일정규칙 변경 -->
  </div>

<!--   부서검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>
<!--   부서검색 보여주는 부분  끝    -->

  <div class="tableInquiry">
    <table>
    	<colgroup>
    		<col width="15%" />
    		<col />
    	</colgroup>
      <tr>

        <th>

        	<label for ="I_DATE"><!-- 조회일자 --><spring:message code="LABEL.D.D14.0003"/></label>
        </th>

        <td >
          <input type="text" id="I_DATE" size="10"  name="I_DATE" value="<%= WebUtil.printDate(I_DATE) %>" onBlur=""/>
          <div class="tableBtnSearch tableBtnSearch2">
	           		<a href="javascript:after_listSetting()" class="search"><span><spring:message code="BUTTON.COMMON.SEARCH"/></span></a>
	          </div>
        </td>
<%--
        <th>
          <select name="I_GBN">
            <option value="ORGEH" <%=I_GBN.equals("ORGEH")? "selected" : "" %>><spring:message code="LABEL.D.D12.0005"/></option> <!-- 부서명 -->
            <option value="PERNR" <%=I_GBN.equals("PERNR")? "selected" : "" %>><spring:message code="LABEL.D.D12.0006"/></option> <!-- 사원명 -->
            <option value="RECENT" <%=I_GBN.equals("RECENT")? "selected" : "" %>><spring:message code="LABEL.D.D12.0007"/></option> <!-- 최근검색 -->
          </select>
          <input type="text" name="txt_searchNm" size="20" maxlength="20" value="" onKeyDown="javascript:EnterCheck();" style="ime-mode:active" />
          	<a  href="javascript: pop_search();">
                <img class="inquiryBtn" src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png"  alt="검색"/>
          	</a>
		</th>
		<td>

	          <!--
	          <span class="tableBtnSearch tableBtnSearch2">
	          <a class="floatLeft" href="javascript: pop_search();"><img class="inquiryBtn" src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" alt="검색"/></a>
	          	<a href="" class="search"><span><spring:message code="BUTTON.COMMON.SEARCH"/></span></a>
	          </span>
         	 -->
        </td>

       <th class="divider">
       		<img class="searchIcon" src="<%= WebUtil.ImageURL %>sshr/icon_map_g.gif" />
            <font color="#585858"><!--하위조직포함--><%=g.getMessage("LABEL.F.FCOMMON.0003")%></font>
            <input type="checkbox" name="chk_organAll" value="" onClick="javaScript:fncCheckbox('<%=deptId%>', '<%=deptNm%>');" <%=checkYn%> >
            <INPUT type='hidden' name='checkYN' value='<%= checkYN %>' >
            <div class="tableBtnSearch tableBtnSearch2"><a class="search" href="javascript:organ_search();">
                <span><!--조직도로 찾기--><%=g.getMessage("LABEL.COMMON.0011")%></span></a>
            </div>
        </th>
      </tr>
 --%>
    </table>
  </div>



 <div class="listArea">
  <div class="table">
    <table class="listTable" >
    <caption></caption>
    <colgroup>
        <col class="col_11p" />
        <col class="col_11p" />
        <col class="col_11p" />
        <col class="col_11p" />
        <col />
        <col />
    </colgroup>
    <tbody>
      <tr>

        <th><spring:message code="LABEL.D.D12.0017"/></th>         <!--  사원번호-->
        <th ><spring:message code="LABEL.D.D12.0018"/></th>              <!-- 성명 -->
        <th ><spring:message code="LABEL.D.D15.0152"/></th>            <!--  시작일-->
        <th><spring:message code="LABEL.D.D15.0153"/></th>            <!-- 종료일 -->
        <th class="lastCol"><spring:message code="LABEL.D.D14.0001"/></th>       <!-- 근무일정규칙 -->

      </tr>
<%
for(int i=0; i<workScheduleRule_vt.size(); i++){
D14PlanWorkTimeData data = (D14PlanWorkTimeData)workScheduleRule_vt.get(i);

String tr_class = "";

if(i%2 == 0){
  tr_class="oddRow";
}else{
  tr_class="";
}

%>
      <input type="hidden" name="PERNR_<%=i%>" value="<%= data.PERNR %>">
      <input type="hidden" name="ENAME_<%=i%>" value="<%= data.ENAME %>">
      <input type="hidden" name="BEGDA_<%=i%>" value="<%= data.BEGDA %>">
      <input type="hidden" name="ENDDA_<%=i%>" value="<%= data.ENDDA %>">
      <input type="hidden" name="SCHKZ_<%=i%>" value="<%= data.SCHKZ %>">
      <input type="hidden" name="RTEXT_<%=i%>" value="">
      <tr class="<%=tr_class%>" >
        <td><%= data.PERNR %></td>
        <td><%= data.ENAME %></td>
        <td><%= data.BEGDA %></td>
        <td><%= data.ENDDA %></td>
        <td class="lastCol">

        <input type="text" class="tdAlignLeft " name="sRTEXT_<%=i%>" value="<%= data.RTEXT %>" size="40"  style="ime-mode:active" disabled>

        <a href="javascript:doSearchPop('<%= i %>',removePoint(document.form1.I_DATE.value), '<%= data.PERNR %>');">
            <img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0">
        </a>
        </td>
      </tr>
<%} %>
    </tbody>
    </table>
   </div>
  </div>

  <div class="buttonArea">
    <ul class="btn_crud">
      <li><a class="darken" href="javascript:doSaveData();">
            <span id="sc_button"><spring:message code="BUTTON.COMMON.SAVE"/></span></a></li>
    </ul>
  </div>

</div>


<script language="JavaScript">
<!--
$(function () {
	addDatePicker($('#I_DATE'));
});






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


// 저장
function doSaveData() {
	if( check_data() ) {
// 		buttonDisabled();

		document.form1.I_DATE.value  = removePoint(document.form1.I_DATE.value);
		document.form1.jobid.value = "save";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D14PlanWorkTime.D14PlanWorkTimeSV";
        document.form1.method = "post";
        document.form1.submit();
	}
}



function check_data(){

	if(!confirm(document.form1.I_DATE.value+"<%=g.getMessage("MSG.D.D14.0002","" )%>")){     // "로 시작일이 저장됩니다\n\n 저장 하시겠습니까?"
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
	document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D14PlanWorkTime.D14PlanWorkTimeSV";
	document.form1.method        = "post";
	document.form1.submit();
}

function doSearchPop( idx, i_datum, i_pernr){

	var retVal = window.showModalDialog("<%= WebUtil.ServletURL %>hris.D.D14PlanWorkTime.D14WorkScheduleRulePopupSV?I_DATE="+removePoint(document.form1.I_DATE.value)+"&I_PERNR="+i_pernr, null, "center:yes; dialogWidth:580px; dialogHeight:450px; status:no; help:no; scroll:yes");

	if(retVal==null) return;
	eval("document.form1.SCHKZ_"+idx+".value = retVal.SCHKZ");
	eval("document.form1.RTEXT_"+idx+".value = retVal.RTEXT");
	var codText = retVal.SCHKZ +"("+ retVal.RTEXT+")";
	eval("document.form1.sRTEXT_"+idx+".value = codText");

}

-->
</script>

<!-- HIDDEN  처리해야할 부분 시작 -->
<!-- HIDDEN  처리해야할 부분 끝   -->
</form>
<iframe name="ifHidden" width="0" height="0" />
<!-------hidden------------>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->