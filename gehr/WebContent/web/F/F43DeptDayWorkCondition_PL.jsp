<%/**********************************************************************************/
/*	  System Name  	: g-HR																													*/
/*   1Depth Name		: Organization & Staffing                                                 											*/
/*   2Depth Name		: Time Management                                                													*/
/*   Program Name	: Daily Time Statement                                             													*/
/*   Program ID   		: F43DeptDayWorkConditionPl.jsp                               													*/
/*   Description  		: 부서별 일간 근태 집계표 조회를 위한 jsp[폴란드]                												*/
/*   Note         		: 없음                                                        																		*/
/*   Creation     		: 2010-07-21 yji                                           															*/
/***********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.common.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
	WebUserData user	= (WebUserData) session.getAttribute("user"); 								// 세션.
	WebUserData user_m    = (WebUserData)session.getAttribute("user_m");            //세션.

    String deptId			= WebUtil.nvl(request.getParameter("hdn_deptId"));                  		//부서코드
    String deptNm 			= (WebUtil.nvl(request.getParameter("hdn_deptNm")));                  	//부서명
    String searchDay    	= WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));           	//대상년월
    String year      		= "";
    String month     		= "";
    String dayCnt       	= WebUtil.nvl((String)request.getAttribute("E_DAY_CNT"), "28");     	//일자수

    Vector vt = new Vector();
    String E_RETURN = "";
    String E_BUKRS   = (String)request.getAttribute("E_BUKRS");
    String E_BUTXT   = "";

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
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_Popflag.value = "Y";
    frm.hdn_excel.value = "";
    frm.target = "_self";

    // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
    if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
    	// alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
        alert("<%=g.getMessage("MSG.F.F41.0003")%>  ");
        return;
    }
	frm.action = "<%= WebUtil.ServletURL %>hris.F.Global.F43DeptDayWorkConditionEurpSV";
	frm.submit();
	frm.hdn_Popflag.value = "N";
}


//Execl Down 하기.
function excelDown() {
    frm = document.form1;
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_excel.value = "ED";
    frm.target = "hidden";

	frm.action = "<%= WebUtil.ServletURL %>hris.F.Global.F43DeptDayWorkConditionEurpSV";
	frm.submit();
}

function zocrsn_get() {
    frm = document.form1;
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_excel.value = "";
    frm.target = "_self";
    frm.method = "post";
	frm.action = "<%= WebUtil.ServletURL %>hris.F.Global.F43DeptDayWorkConditionEurpSV";
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
        <jsp:param name="help" value="F43DeptDayWorkConditionPl.html'"/>
    </jsp:include>

<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="E_BUKRS"   value="<%= E_BUKRS %>">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="hdn_Popflag"   value="N">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >
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

	<h2 class="subtitle"><!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> : <%=data.STEXT %></h2>

	<div class="listArea">
		<div class="table">
		 <div class="wideTable" >
			<table class="listTable">
			  <thead>
				<tr>
					<th><!--Seq No.--><%=g.getMessage("LABEL.F.F43.0011")%> </th>
					<th><!--Pers.No--><%=g.getMessage("LABEL.F.F43.0012")%> </th>
					<th><!--Name--><%=g.getMessage("LABEL.F.F43.0013")%> </th>
					<th><!--Quata<br>Balance<br>(Days)--><%=g.getMessage("LABEL.F.F43.0014")%> </th>
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
					<td><%=data.PERNR %></td>
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
					<td colspan="<%=detailDataAll_vt.size() + 5%>"  class="lastCol"><!--No data--><%=g.getMessage("LABEL.F.F51.0029")%></td>
				</tr>
				<%
				}
				%>
			</table>
		</div>
	</div>
  </div>

	<h2 class="subtitle"><!--Time Type--><%=g.getMessage("LABEL.F.F43.0015")%></h2>

  	<div class="listArea">
  		<div class="table">
            <table class="listTable">
              <thead>
				<tr>
	                <th class="divide"><!--Category--><%=g.getMessage("LABEL.F.F43.0016")%> </th>
	                <th class="lastCol" colspan="5"><!--Type--><%=g.getMessage("LABEL.F.F43.0049")%></th>

            	</tr>
             </thead>
            	<tr class="borderRow">
	                <td class="divide" rowspan="2"><!--Absence--><%=g.getMessage("LABEL.F.F43.0017")%></td>
	                <td>A&nbsp;:&nbsp;<!-- Annual Leave--><%=g.getMessage("LABEL.F.F43.0013")%></td>
	                <td>B&nbsp;:&nbsp;<!--On Demand--><%=g.getMessage("LABEL.F.F43.0071")%></td>
	                <td>H&nbsp;:&nbsp;<!--Others--><%=g.getMessage("LABEL.F.F43.0072")%></td>
	                <td>J&nbsp;:&nbsp;<!--Sick Leave--><%=g.getMessage("LABEL.F.F43.0073")%></td>
	                <td class="lastCol">O&nbsp;:&nbsp;<!--Not explained--><%=g.getMessage("LABEL.F.F43.0074")%></td>
	            </tr>
	            <tr class="borderRow">
	            	<td colspan="2">S&nbsp;:&nbsp;<!--Tardiness--><%=g.getMessage("LABEL.F.F43.0075")%></td>
	            	<td class="lastCol" colspan="3">R&nbsp;:&nbsp;<!--Suspension--><%=g.getMessage("LABEL.F.F43.0076")%></td>
	            </tr>
	            <tr class="borderRow">
	                <td class="divide"><!--Attendance--><%=g.getMessage("LABEL.F.F43.0050")%></td>
	            	<td colspan="2">1&nbsp;:&nbsp;<!--Business Trip--><%=g.getMessage("LABEL.F.F43.0037")%></td>
	            	<td class="lastCol" colspan="3">2&nbsp;:&nbsp;<!--Education--><%=g.getMessage("LABEL.F.F43.0038")%></td>
            	</tr>
            	<tr>
                	<td class="divide"><!--Overtime--><%=g.getMessage("LABEL.F.F43.0039")%></td>
                    <td>OA&nbsp;:&nbsp;50%</td>
                    <td>OB&nbsp;:&nbsp;100%</td>
                    <td>OC&nbsp;:&nbsp;<!--Night--><%=g.getMessage("LABEL.F.F43.0077")%></td>
                    <td class="lastCol" colspan="2">OD&nbsp;:&nbsp;<!--Holiday--><%=g.getMessage("LABEL.F.F43.0078")%></td>
            	</tr>
            </table>
        </div>
	</div>
<%
}else{
%>
<span style="text-align:center;"  width="70%"><!--No data--><%=g.getMessage("LABEL.F.F51.0029")%></span>
<%
}%>
</div>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->