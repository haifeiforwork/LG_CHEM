<%/**********************************************************************************/
/*	  System Name  	: g-HR																													*/
/*   1Depth Name		: Organization & Staffing                                                 											*/
/*   2Depth Name		: Time Management                                                													*/
/*   Program Name	: Daily Time Statement                                             													*/
/*   Program ID   		: F43DeptDayWorkCondition.jsp                               													*/
/*   Description  		: 부서별 일간 근태 집계표 조회를 위한 jsp 파일                														*/
/*   Note         		: 없음                                                        																		*/
/*   Creation     		: 2005-02-17  유용원                                           																*/
/*   Update       		: 2007-09-21  huang peng xiao                           														*/
/*							: 2008-11-19  김정인  @v 1.0  [C20081118_59757] Absence Type 항목 변경							*/
/*                         : 2017-11-06  eunha  [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건     */
/***********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.common.constant.Area" %>

<%
	request.setCharacterEncoding("utf-8");
	WebUserData user	= (WebUserData) session.getAttribute("user"); 								// 세션.

    String deptId			= WebUtil.nvl(request.getParameter("hdn_deptId"));                  		//부서코드
    String deptNm 			= (WebUtil.nvl(request.getParameter("hdn_deptNm")));                  	//부서명
    String searchDay    	= WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));           	//대상년월
    String year      		= "";
    String month     		= "";
    String dayCnt       	= WebUtil.nvl((String)request.getAttribute("E_DAY_CNT"), "28");     	//일자수
    String E_BUKRS   = (String)request.getAttribute("E_BUKRS");

    Vector detailDataAll_vt 			= (Vector)request.getAttribute("detailDataAll_vt");
    Vector F43DeptDayTitle_vt 	= (Vector)request.getAttribute("F43DeptDayTitle_vt");       //제목
    Vector F43DeptDayData_vt 	= (Vector)request.getAttribute("F43DeptDayData_vt");       //내용
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
	String subView       = WebUtil.nvl(request.getParameter("subView"));
%>
<jsp:include page="/include/header.jsp"/>
<SCRIPT LANGUAGE="JavaScript">
<!--



//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
    if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
        alert("<%=g.getMessage("MSG.F.F41.0003")%>  ");
        return;
    }
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.Global.F43DeptDayWorkConditionEurpSV";
    frm.target = "_self";
    frm.submit();
}


//Execl Down 하기.
function excelDown() {
    frm = document.form1;
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.Global.F43DeptDayWorkConditionEurpSV";
    frm.target = "hidden";
    frm.submit();
}

function zocrsn_get() {
    frm = document.form1;
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.Global.F43DeptDayWorkConditionEurpSV";
    frm.target = "_self";
    frm.method = "post";
    frm.submit();
}

function searchDayCheck() {
    frm = document.form1;
    var yymm = "";
    if(frm.month.value.length==1) {
      yymm = frm.year.value + '0' + frm.month.value;
    } else {
      yymm = frm.year.value + frm.month.value;
    }
    if(frm.searchDay_bf.value!=yymm&&frm.searchDay_bf.value!="") {
      frm.year.value = frm.searchDay_bf.value.substring(0,4);
      if(frm.searchDay_bf.value.substring(4,6)!=10&&frm.searchDay_bf.value.substring(4,6)!=11&&frm.searchDay_bf.value.substring(4,6)!=12) {
        frm.month.value = frm.searchDay_bf.value.substring(5,6);
      } else {
        frm.month.value = frm.searchDay_bf.value.substring(4,6);
      }
    }
}

$(document).ready(function(){
	searchDayCheck();
 });
//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="F43DeptDayWorkCondition.html''"/>
    </jsp:include>

<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >
<input type="hidden" name="E_BUKRS"   value="<%= E_BUKRS %>">
<!--   부서검색 보여주는 부분  끝    -->
<%
    if(deptNm == null || deptNm.equals(""))
    	deptNm = user.e_obtxt;

%>

<%
if(detailDataAll_vt.size() > 0){
%>

<div class="buttonArea">
                    <select name="year">
<%
    for( int i = 2007 ; i <= Integer.parseInt( DataUtil.getCurrentYear() ) ; i++ ) {
        int year1 = Integer.parseInt(searchDay.substring(0, 4));
%>
                      <option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
    }
%>
                    </select>
                    <select name="month">
<%
    for( int i = 1 ; i <= 12 ; i++ ) {
        String temp = Integer.toString(i);
        int mon = Integer.parseInt(searchDay.substring(4, 6));
%>
                      <option value="<%= i %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
    }
%>
                    </select>
            <input type="hidden" name="year1" value="">
            <input type="hidden" name="month1" value="">
            <input type="hidden" name="searchDay_bf" value="">
            <a href="javascript:zocrsn_get();"><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0" align="absmiddle"></a>
             &nbsp;&nbsp;
             <ul class="btn_mdl displayInline">
             	<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
             </ul>
    </div>

    <h2 class="subtitle"><!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> : <%=deptNm %></h2>

    <div class="listArea">
    	<div class="table">
    <div class="wideTable" >
      <table class="listTable">
            <thead>
				<tr>
					<th width="5%"><!--Seq No.--><%=g.getMessage("LABEL.F.F43.0011")%> </th>
					<th width="8%"><!--Pers.No--><%=g.getMessage("LABEL.F.F43.0012")%> </th>
					<th width="15%"><!--Name--><%=g.getMessage("LABEL.F.F43.0013")%> </th>
					<th width="7%"><!--Quata<br>Balance<br>(Days)--><%=g.getMessage("LABEL.F.F43.0014")%> </th>

					<!-- column head -->
					<%
						for( int i = 0 ; i < detailDataAll_vt.size() ; i ++){
						BetweenDateData time = (BetweenDateData)detailDataAll_vt.get(i);
					%>
						<th><%=Integer.parseInt(time.CAL_DATE.substring(8)) %></th>
					<%
						}
					%>
					<!-- td width="100">Confirm</td -->
				</tr>
			</thead>

				<%
				String tmp = "";
				int no = 0 ;
				for( int i = 0 ; i < F43DeptDayTitle_vt.size() ; i ++){
					no ++;
					F43DeptDayTitleWorkConditionData data = (F43DeptDayTitleWorkConditionData)F43DeptDayTitle_vt.get(i);
					if(i != 0 && !data.STEXT.equals(tmp)){
					no = 0 ;
					no ++;
				%>
			</table>
		</div>
		</div>
	</div>

	<h2 class="subtitle"><!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%>  : <%=data.STEXT %></h2>

	<div class="listArea">
		<div class="table">
			    <div class="wideTable" >
      				<table class="listTable">
      			<thead>
				<tr>
					<th width="5%"><!-- Seq No.--><%=g.getMessage("LABEL.F.F43.0011")%> </th>
					<th width="8%"><!--Pers.No--><%=g.getMessage("LABEL.F.F43.0012")%> </th>
					<th width="15%"><!--Name--><%=g.getMessage("LABEL.F.F43.0013")%> </th>
					<th width="7%"><!--Quata<br>Balance<br>(Days)--><%=g.getMessage("LABEL.F.F43.0014")%> </th>

					<!-- column head -->
					<%
						for( int j = 0 ; j < detailDataAll_vt.size() ; j ++){
						BetweenDateData time = (BetweenDateData)detailDataAll_vt.get(j);
					%>
						<th><%=Integer.parseInt(time.CAL_DATE.substring(8)) %></th>
					<%
						}
					%>
					<!--  td width="100">Confirm</td -->
				</tr>
				</thead>

				<%
					}
				%>
				<tr class="<%=WebUtil.printOddRow(i)%>">
					<td><%=no%></td>
					<td ><%=data.PERNR %></td>
					<td nowrap><%=data.ENAME %></td>
					<td><%=WebUtil.printNumFormat(data.QU_BAL,2)%></td>
					<%

					for( int j = 0 ; j < detailDataAll_vt.size() ; j ++){
						BetweenDateData time = (BetweenDateData)detailDataAll_vt.get(j);
					%>
						<td><%=data.MAP.get(time.CAL_DATE)==null?"":data.MAP.get(time.CAL_DATE)%></td>
					<%
					}
					%>
				</tr>
				<%
					tmp = data.STEXT;
				}
				if(F43DeptDayTitle_vt.size() == 0)
				{
				%>
					<tr class="oddRow">
						<td colspan="<%=detailDataAll_vt.size() + 5%>"  class="lastCol">No data</td>
					</tr>
				<%
				}
				%>
			</table>
		</div>
	   </div>
	</div>

	<h2 class="subtitle"><!--Time Type--><%=g.getMessage("LABEL.F.F43.0015")%> </h2>
<%-- 2017-11-06  eunha  [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건  start --%>
	<%if(user.area == Area.TH){ %>
	<div class="listArea">
		<div class="table">
            <table class="listTable">
              <thead>
                  <tr class="borderRow">
	                <td class="divide" rowspan="3">Absence</td>
                  	<td>A&nbsp;:&nbsp;Annual Leave</td>
                  	<td>B&nbsp;:&nbsp;Sick Leave</td>
                  	<td>C&nbsp;:&nbsp;Sterilization Leave </td>
                  	<td>D&nbsp;:&nbsp;Marriage Leave</td>
                  	<td class="lastCol">E&nbsp;:&nbsp;Maternity Leave</td>
				</tr>
                <tr class="borderRow">
                   <td>F&nbsp;:&nbsp;Paternity Leave</td>
                   <td>G&nbsp;:&nbsp;Military Leave</td>
                   <td>H&nbsp;:&nbsp;Religious Leave</td>
                   <td>I&nbsp;:&nbsp;Ordination Leave</td>
                   <td class="lastCol">J&nbsp;:&nbsp;Funeral Leave</td>
                </tr>
                <tr class="borderRow">
                    <td>K&nbsp;:&nbsp;Business Leave</td>
                    <td>L&nbsp;:&nbsp;Leave without pay</td>
                    <td></td>
                    <td></td>
                    <td class="lastCol"> </td>
                </tr>
             	<tr class="borderRow">
	                <td class="divide">Overtime</td>
                  	<td>OT&nbsp;:&nbsp;Overtime</td>
                  	<td></td>
                  	<td></td>
                  	<td ></td>
                  	<td  class="lastCol"></td>
                </tr>

            </table>
		</div>
	</div>
<%}else{ %>
<%-- 2017-11-06  eunha  [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건  end --%>
	<div class="listArea">
		<div class="table">
            <table class="listTable">
              <thead>
            	<tr>
	                <th class="divide"><!--Category--><%=g.getMessage("LABEL.F.F43.0016")%> </th>
	                <th class="lastCol" colspan="5"><!--Type--><%=g.getMessage("LABEL.F.F43.0049")%> </th>
				</tr>
				</thead>
                <tr class="borderRow">
	                <td class="divide" rowspan="4"><!--Absence--><%=g.getMessage("LABEL.F.F43.0017")%> </td>
                  	<td>A&nbsp;:&nbsp;<!--有薪年假--><%=g.getMessage("LABEL.F.F43.0018")%> </td>
                  	<td>B&nbsp;:&nbsp;<!--有薪年假(半天)--><%=g.getMessage("LABEL.F.F43.0019")%> </td>
                  	<td>C&nbsp;:&nbsp;<!-婚假--><%=g.getMessage("LABEL.F.F43.0020")%> </td>
                  	<td>D&nbsp;:&nbsp;<!--丧假--><%=g.getMessage("LABEL.F.F43.0021")%> </td>
                  	<td class="lastCol">E&nbsp;:&nbsp;<!--夏季休假--><%=g.getMessage("LABEL.F.F43.0022")%> </td>
				</tr>
                <tr class="borderRow">
                   <td>F&nbsp;:&nbsp;<!--产假--><%=g.getMessage("LABEL.F.F43.0023")%> </td>
                   <td>G&nbsp;:&nbsp;<!--流产假--><%=g.getMessage("LABEL.F.F43.0024")%> </td>
                   <td>H&nbsp;:&nbsp;<!--护理假--><%=g.getMessage("LABEL.F.F43.0025")%> </td>
                   <td>I&nbsp;:&nbsp;<!--哺乳假--><%=g.getMessage("LABEL.F.F43.0026")%> </td>
                   <td class="lastCol">J&nbsp;:&nbsp;<!--病假--><%=g.getMessage("LABEL.F.F43.0027")%> </td>
                </tr>
                <tr class="borderRow">
                    <td>K&nbsp;:&nbsp;<!--病假(半天)--><%=g.getMessage("LABEL.F.F43.0028")%> </td>
                    <td>L&nbsp;:&nbsp;<!--事假--><%=g.getMessage("LABEL.F.F43.0029")%> </td>
                    <td>M&nbsp;:&nbsp;<!--事假(半天)--><%=g.getMessage("LABEL.F.F43.0030")%> </td>
                    <td>N&nbsp;:&nbsp;<!--公假--><%=g.getMessage("LABEL.F.F43.0031")%> </td>
                    <td class="lastCol">O&nbsp;:&nbsp;<!--旷工--><%=g.getMessage("LABEL.F.F43.0032")%> </td>
                </tr>
                <tr class="borderRow">
                    <td>P&nbsp;:&nbsp;<!--旷工(半天)--><%=g.getMessage("LABEL.F.F43.0033")%> </td>
                    <td>Q&nbsp;:&nbsp;<!--迟到--><%=g.getMessage("LABEL.F.F43.0034")%> </td>
                    <td>R&nbsp;:&nbsp;<!--早退--><%=g.getMessage("LABEL.F.F43.0035")%> </td>
                    <td>S&nbsp;:&nbsp;<!--不工作--><%=g.getMessage("LABEL.F.F43.0036")%> </td>
                    <td class="lastCol">&nbsp;</td>
                </tr>
             	<tr class="borderRow">
	                <td class="divide"><!--Attendance--><%=g.getMessage("LABEL.F.F43.0050")%> </td>
                  	<td colspan="2"> 1&nbsp;:&nbsp;<!--Business Trip--><%=g.getMessage("LABEL.F.F43.0037")%> </td>
                    <td colspan="3" class="lastCol"> 2&nbsp;:&nbsp;<!--Education--><%=g.getMessage("LABEL.F.F43.0038")%> </td>
             	</tr>
             	<tr class="borderRow">
	                <td class="divide"><!--Overtime--><%=g.getMessage("LABEL.F.F43.0039")%> </td>
                  	<td>OA&nbsp;:&nbsp;<!--Night--><%=g.getMessage("LABEL.F.F43.0040")%> </td>
                  	<td>OB&nbsp;:&nbsp;<!--Shift--><%=g.getMessage("LABEL.F.F43.0041")%> </td>
                  	<td>OC&nbsp;:&nbsp;<!--Weekday--><%=g.getMessage("LABEL.F.F43.0042")%> </td>
                  	<td >OD&nbsp;:&nbsp;<!--Off day--><%=g.getMessage("LABEL.F.F43.0043")%> </td>
                  	<td  class="lastCol">OE&nbsp;:&nbsp;<!--Holiday--><%=g.getMessage("LABEL.F.F42.0026")%> </td>
                </tr>
             	<tr>
	                <td class="divide"><!--Duty--><%=g.getMessage("LABEL.F.F43.0045")%></td>
                  	<td>DA&nbsp;:&nbsp;<!--Duty--><%=g.getMessage("LABEL.F.F43.0045")%> </td>
                  	<td>DB&nbsp;:&nbsp;<!--Workday Duty--><%=g.getMessage("LABEL.F.F43.0046")%> </td>
                  	<td>DC&nbsp;:&nbsp;<!--Offday Duty--><%=g.getMessage("LABEL.F.F43.0047")%> </td>
                  	<td colspan="2" class="lastCol">DD&nbsp;:&nbsp;<!--Holiday Duty--><%=g.getMessage("LABEL.F.F43.0048")%> </td>
                </tr>
            </table>
		</div>
	</div>
<%} %>
<%
}else{
%>
<span style="text-align:center;"  width="70%"><!--No data--><%=g.getMessage("LABEL.F.F51.0029")%> </span>
<%
}%>
</div>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

