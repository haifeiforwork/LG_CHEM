<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name		: Organization & Staffing                                                 													*/
/*   2Depth Name		: Time Management                                                															*/
/*   Program Name	: Monthly Time Statement                                             														*/
/*   Program ID   		: F42DeptMonthWorkConditionUsa.jsp                                             										*/
/*   Description  		: 부서별 월간 근태 집계표 조회를 위한 jsp 파일 (USA)                       												*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-10-22 jungin @v1.0																								*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.F.rfc.*" %>
<%
	request.setCharacterEncoding("utf-8");

	WebUserData user = (WebUserData)session.getAttribute("user");            			// 세션
	WebUserData user_m = (WebUserData)session.getAttribute("user");            		// 세션

    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"));          			// 부서코드
    String deptNm	= (WebUtil.nvl(request.getParameter("hdn_deptNm")));       		// 부서명
    String searchDay = WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));		// 대상년월
    String checkYN = WebUtil.nvl((String)request.getAttribute("checkYN"));

    if (deptId == null || deptId.equals("")) {
    	deptId = user.e_orgeh;
    }

    String year = "";
    String month = "";

    Vector vt = new Vector();
    String E_RETURN = "";
    String E_BUKRS   = (String)request.getParameter("E_BUKRS");
    String E_BUTXT = "";

    Vector F42DeptMonthWorkCondition_vt = (Vector)request.getAttribute("F42DeptMonthWorkCondition_vt");
    Vector F42DeptMonthWorkConditionTotal = (Vector)request.getAttribute("F42DeptMonthWorkConditionTotal");
    F42DeptMonthWorkConditionData todata = new F42DeptMonthWorkConditionData();
    if (F42DeptMonthWorkConditionTotal.size()>0) {
    	todata =(F42DeptMonthWorkConditionData)F42DeptMonthWorkConditionTotal.get(0);
    }

    DecimalFormat f1 = new DecimalFormat("0.0");		// 반올림후 첫째자리수까지.
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
	String subView       = WebUtil.nvl(request.getParameter("subView"));
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--

// 조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
    if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
    	 //alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
        alert("<%=g.getMessage("MSG.F.F41.0003")%>  ");
        return;
    }

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_Popflag.value = "Y";

    if ((frm.year != null) && (frm.month != null)) {
	    if (frm.year.tagName == 'SELECT') {
		    frm.year1.value = frm.year.options[frm.year.selectedIndex].text;
		    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    	}
    }

    frm.hdn_excel.value = "";
    frm.target = "_self";
	frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV";
	frm.submit();
	frm.hdn_Popflag.value = "N";
}


// Execl Down 하기.
function excelDown() {
    frm = document.form1;

    if ((frm.year != null) && (frm.month != null)) {
	    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
	    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }

    frm.hdn_excel.value = "ED";
    frm.target = "hidden";
	frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV";
	frm.submit();
    frm.hdn_excel.value = "";
}

function zocrsn_get() {
    frm = document.form1;

    if ((frm.year != null) && (frm.month != null)) {
	    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
	    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }

    frm.searchDay_bf.value = "<%= searchDay %>";
    frm.hdn_excel.value = "";
    frm.target = "_self";
    frm.method = "post";
	frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV";
	frm.submit();

}

function searchDayCheck() {
    frm = document.form1;
    var yymm = "";

    if (frm.month.value.length == 1) {
      yymm = frm.year.value + '0' + frm.month.value;
    } else {
      yymm = frm.year.value + frm.month.value;
    }

    if (frm.searchDay_bf != null && frm.searchDay_bf != null) {
    	if (frm.searchDay_bf.value != yymm && frm.searchDay_bf.value != "") {
			frm.year.value = frm.searchDay_bf.value.substring(0,4);
      			if (frm.searchDay_bf.value.substring(4,6) != 10 && frm.searchDay_bf.value.substring(4,6) != 11 && frm.searchDay_bf.value.substring(4,6) != 12) {
        			frm.month.value = frm.searchDay_bf.value.substring(5,6);
      			} else {
        			frm.month.value = frm.searchDay_bf.value.substring(4,6);
      			}
    	}
    }
}

// 상세 팝업 화면으로 이동.
function goDetail(pageCode, gubun, pernr, absty, value) {
    frm = document.form1;

    if (value != "" && value != "0.00") {
	    frm.PERNR.value = pernr;          	// 사번
	    frm.ABSTY.value = absty;  		// 유형 구분
	   	frm.ORGEH.value = pernr;  			// 조직코드

	    window.open('', 'mssDetailWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=660,height=480");
	    frm.target = "mssDetailWindow";
	    frm.action = "<%= WebUtil.ServletURL %>hris.F.Global.F00DeptDetailListUsaSV?pageCode="+pageCode+"&gubun="+gubun;
	    frm.method = "post";
	    frm.submit();
    }
}
$(document).ready(function(){
	searchDayCheck();
 });
//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="F42DeptMonthWorkConditionPl.html"/>
        <jsp:param name="click" value="Y"/>
    </jsp:include>

<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="E_BUKRS" value="<%= E_BUKRS %>">
<input type="hidden" name="hdn_deptId" value="<%= deptId %>">
<input type="hidden" name="hdn_deptNm" value="<%= deptNm %>">
<input type="hidden" name="hdn_excel" value="">
<input type="hidden" name="hdn_Popflag" value="N">

<input type="hidden" name="ORGEH" value="">
<input type="hidden" name="checkYN" value="<%= checkYN %>">

<input type="hidden" name="PERNR" value="">
<input type="hidden" name="BEGDA" value="">
<input type="hidden" name="ENDDA" value="">
<input type="hidden" name="ABSTY" value="">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >

<%
    // 부서명, 조회된 건수.
   if (F42DeptMonthWorkCondition_vt != null && F42DeptMonthWorkCondition_vt.size() > 0) {
%>

	<div class="listArea">
			<div class="listTop">
			<h2 class="subtitle withButtons"><%= todata.STEXT  %>&nbsp;<%= todata.ENAME %></h2>
			<div class="buttonArea">
	              <select name="year" onchange="javascript:">
					<%
						int year1;
					    for (int i = 2001; i <= Integer.parseInt(DataUtil.getCurrentYear()); i++) {
					        year1 = Integer.parseInt(searchDay.substring(0, 4));
					%>
			        <option value="<%= i %>" <%= year1 == i ? " selected " : "" %>><%= i %></option>
					<%
					    }
					%>
	              </select>

	              <select name="month">
					<%
					    for (int i = 1; i <= 12; i++) {
					        String temp = Integer.toString(i);
					        int mon = Integer.parseInt(searchDay.substring(4, 6));
					%>
			        <option value="<%= temp.length() == 1 ? '0' + temp : temp %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
					<%
					    }
					%>
	             </select>
	              <input type="hidden" name="year1" value="">
	              <input type="hidden" name="month1" value="">
	              <input type="hidden" name="searchDay_bf" value="">
	        	<a href="javascript:zocrsn_get();"><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0" align="absmiddle"></a>&nbsp;&nbsp;
				<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  />
	        	<ul class="btn_mdl displayInline">
	         		<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	         	</ul>
			</div>
			<div class="clear"></div>
		</div>
		<div class="table">
	    	<table class="listTable">
				<colgroup>
					<col width="8%"/>
					<col width="8%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="7%"/>
				</colgroup>
				<thead>
		        <tr>
		          <th rowspan="2"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
		          <th colspan="5"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
		          <th class="lastCol" rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></th>
		        </tr>
		        <tr>
		          <th><!--Vacation--><%=g.getMessage("LABEL.F.F42.0077")%></th>
		          <th><!--Personal Time--><%=g.getMessage("LABEL.F.F43.0080")%></th>
		          <th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
		          <th><!--Absence--><%=g.getMessage("LABEL.F.F42.0072")%></th>
		          <th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
		        </tr>
		        </thead>
		        <tr>
		          <td><a title="<%= deptId %>" href="javascript:goDetail('MT', 'O', '<%= deptId %>', 'OT', '<%=WebUtil.printNumFormat(todata.OT_HRS, 2) %>')"><%= todata.OT_HRS.equals("0") ? "0.00": WebUtil.printNumFormat(Double.parseDouble(todata.OT_HRS),2) %></a></td>
		          <td><a title="<%= deptId %>" href="javascript:goDetail('MT', 'O', '<%= deptId %>', '10', '<%=WebUtil.printNumFormat(todata.LE_ANN, 2) %>')"><%= todata.LE_ANN.equals("0") ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(todata.LE_ANN),2) %></a></td>
		          <td><a title="<%= deptId %>" href="javascript:goDetail('MT', 'O', '<%= deptId %>', '15', '<%=WebUtil.printNumFormat(todata.LE_PER, 2) %>')"><%= todata.LE_PER.equals("0") ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(todata.LE_PER),2) %></a></td>
		          <td><a title="<%= deptId %>" href="javascript:goDetail('MT', 'O', '<%= deptId %>', '20', '<%=WebUtil.printNumFormat(todata.LE_SIC, 2) %>')"><%= todata.LE_SIC.equals("0") ? "0.00" 	: WebUtil.printNumFormat(Double.parseDouble(todata.LE_SIC),2) %></a></td>
		          <td><a title="<%= deptId %>" href="javascript:goDetail('MT', 'O', '<%= deptId %>', '50', '<%=WebUtil.printNumFormat(todata.AB_ABS, 2) %>')"><%= todata.AB_ABS.equals("0") ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(todata.AB_ABS),2) %></a></td>
		          <td><a title="<%= deptId %>" href="javascript:goDetail('MT', 'O', '<%= deptId %>', '30', '<%=WebUtil.printNumFormat(todata.LE_OTH, 2) %>')"><%= todata.LE_OTH.equals("0") ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(todata.LE_OTH),2) %></a></td>
		          <td class="lastCol"><a title="<%= deptId %>" href="javascript:goDetail('MT', 'O', '<%= deptId %>', 'AT', '<%=WebUtil.printNumFormat(todata.ATTEN, 2) %>')"><%= todata.ATTEN.equals("0") ? "0.00" 	: WebUtil.printNumFormat(Double.parseDouble(todata.ATTEN),2) %></a></td>
		        </tr>
	    	</table>
	    </div>
	</div>

<%
		String tempDept = "";
		int i = 0;
		int j = 0;
		int k = 0;
		for (i = 0; i < F42DeptMonthWorkCondition_vt.size(); ) {
%>

	<h2 class="subtitle"><!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> : <%= ((F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(i)).STEXT %></h2>

	<div class="listArea">
		<div class="table">
	    	<table class="listTable">
				<colgroup>
					<col width="8%"/>
					<col width="8%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="7%"/>
				</colgroup>
				<thead>
				<tr>
	          		  <th rowspan="2"><!--Pers.No--><%=g.getMessage("LABEL.F.F42.0075")%></th>
	          		  <th rowspan="2"><!--Name--><%=g.getMessage("LABEL.F.F42.0076")%></th>
			          <th rowspan="2"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
			          <th colspan="5"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
			          <th class="lastCol" rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></th>
				</tr>
				<tr>
			          <th><!--Vacation--><%=g.getMessage("LABEL.F.F42.0077")%></th>
			          <th><!--Personal Time--><%=g.getMessage("LABEL.F.F43.0080")%></th>
			          <th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
			          <th><!--Absence--><%=g.getMessage("LABEL.F.F42.0072")%></th>
			          <th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
				</tr>
				</thead>
<%
			String orgCode = "";
			int tem = j;
	        for (; j < F42DeptMonthWorkCondition_vt.size(); j++ ) {
	            F42DeptMonthWorkConditionData deptData = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(j);

	            String tr_class = "";

	            if(i%2 == 0){
	                tr_class="oddRow";
	            }else{
	                tr_class="";
	            }

	            if (tempDept.equals("")) {
	            	tempDept = deptData.ORGEH;
	            }
				if (!(deptData.ORGEH.equals(tempDept))) {
					tempDept = deptData.ORGEH;
					break ;
				}
				i = j + 1;

				orgCode = deptData.ORGEH;
%>
		        <tr class="<%=tr_class%>">
		          <td><%= deptData.PERNR %></td>
		          <td><%= deptData.ENAME %></td>
		          <td><a title="<%= deptData.PERNR %>" href="javascript:goDetail('MT', 'E', '<%= deptData.PERNR %>', 'OT', '<%=WebUtil.printNumFormat(deptData.OT_HRS, 2) %>')"><%= deptData.OT_HRS.equals("0") ? "0.00"	: WebUtil.printNumFormat(Double.parseDouble(deptData.OT_HRS),2)	%></a></td>
		          <td><a title="<%= deptData.PERNR %>" href="javascript:goDetail('MT', 'E', '<%= deptData.PERNR %>', '10', '<%=WebUtil.printNumFormat(deptData.LE_ANN, 2) %>')"><%= deptData.LE_ANN.equals("0") ? "0.00" 	: WebUtil.printNumFormat(Double.parseDouble(deptData.LE_ANN),2) %></a></td>
		          <td><a title="<%= deptData.PERNR %>" href="javascript:goDetail('MT', 'E', '<%= deptData.PERNR %>', '15', '<%=WebUtil.printNumFormat(deptData.LE_PER, 2) %>')"><%= deptData.LE_PER.equals("0") ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(deptData.LE_PER),2) %></a></td>
		          <td><a title="<%= deptData.PERNR %>" href="javascript:goDetail('MT', 'E', '<%= deptData.PERNR %>', '20', '<%=WebUtil.printNumFormat(deptData.LE_SIC, 2) %>')"><%= deptData.LE_SIC.equals("0") ? "0.00" 	: WebUtil.printNumFormat(Double.parseDouble(deptData.LE_SIC),2) %></a></td>
		          <td><a title="<%= deptData.PERNR %>" href="javascript:goDetail('MT', 'E', '<%= deptData.PERNR %>', '50', '<%=WebUtil.printNumFormat(deptData.AB_ABS, 2) %>')"><%= deptData.AB_ABS.equals("0") ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(deptData.AB_ABS),2) %></a></td>
		          <td><a title="<%= deptData.PERNR %>" href="javascript:goDetail('MT', 'E', '<%= deptData.PERNR %>', '30', '<%=WebUtil.printNumFormat(deptData.LE_OTH, 2) %>')"><%= deptData.LE_OTH.equals("0") ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(deptData.LE_OTH),2) %></a></td>
		          <td class="lastCol"><a title="<%= deptData.PERNR %>" href="javascript:goDetail('MT', 'E', '<%= deptData.PERNR %>', 'AT', '<%=WebUtil.printNumFormat(deptData.ATTEN, 2) %>')"><%= deptData.ATTEN.equals("0") ? "0.00"	: WebUtil.printNumFormat(Double.parseDouble(deptData.ATTEN),2) %></a></td>
		        </tr>
<%
        } //end for
%>

<%
			double OT_HRS = 0;
			double LE_ANN = 0;
			double LE_PER = 0;
			double LE_SIC = 0;
			double LE_OTH = 0;
			double AB_ABS = 0;
			double ATTEN = 0;

            for (k = tem; k < j; k++ ) {
	            F42DeptMonthWorkConditionData data = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(k);

				OT_HRS	+= data.OT_HRS.equals("0") ? 0.00 : Double.parseDouble(data.OT_HRS);
				LE_ANN	+= data.LE_ANN.equals("0") ? 0.00 : Double.parseDouble(data.LE_ANN);
				LE_PER	+= data.LE_PER.equals("0") ? 0.00 : Double.parseDouble(data.LE_PER);
				LE_SIC	+= data.LE_SIC.equals("0") ? 0.00 : Double.parseDouble(data.LE_SIC);
				AB_ABS	+= data.AB_ABS.equals("0") ? 0.00 : Double.parseDouble(data.AB_ABS);
				LE_OTH	+= data.LE_OTH.equals("0") ? 0.00 : Double.parseDouble(data.LE_OTH);
				ATTEN 	+= data.ATTEN.equals("0") ? 0.00 : Double.parseDouble(data.ATTEN);
			}
%>
		        <tr>
		          <td class="td11">TOTAL</td>
		          <td class="td11"><%= j - tem %> person</td>
		          <td class="td11"><a title="" href="javascript:goDetail('MT', 'O', '<%= orgCode %>', 'OT', '<%=WebUtil.printNumFormat(OT_HRS, 2) %>')"><%= WebUtil.printNumFormat(OT_HRS,2) %></a></td>
		          <td class="td11"><a title="" href="javascript:goDetail('MT', 'O', '<%= orgCode %>', '10', '<%=WebUtil.printNumFormat(LE_ANN, 2) %>')"><%= WebUtil.printNumFormat(LE_ANN,2) %></a></td>
		          <td class="td11"><a title="" href="javascript:goDetail('MT', 'O', '<%= orgCode %>', '15', '<%=WebUtil.printNumFormat(LE_PER, 2) %>')"><%= WebUtil.printNumFormat(LE_PER,2) %></a></td>
		          <td class="td11"><a title="" href="javascript:goDetail('MT', 'O', '<%= orgCode %>', '20', '<%=WebUtil.printNumFormat(LE_SIC, 2) %>')"><%= WebUtil.printNumFormat(LE_SIC,2) %></a></td>
		          <td class="td11"><a title="" href="javascript:goDetail('MT', 'O', '<%= orgCode %>', '50', '<%=WebUtil.printNumFormat(AB_ABS, 2) %>')"><%= WebUtil.printNumFormat(AB_ABS,2) %></a></td>
		          <td class="td11"><a title="" href="javascript:goDetail('MT', 'O', '<%= orgCode %>', '30', '<%=WebUtil.printNumFormat(LE_OTH, 2) %>')"><%= WebUtil.printNumFormat(LE_OTH,2) %></a></td>
		          <td class="td11 lastCol"><a title="" href="javascript:goDetail('MT', 'O', '<%= orgCode %>', 'AT', '<%=WebUtil.printNumFormat(ATTEN, 2) %>')"><%= WebUtil.printNumFormat(ATTEN,2) %></a></td>
		        </tr>
			</table>
		</div>
	</div>
<%
		}
%>


<%
    } else {
%>




	<div class="listArea">
			<div class="listTop">
			<h2 class="subtitle withButtons"><%= todata.STEXT  %>&nbsp;<%= todata.ENAME %></h2>
			<div class="buttonArea">
	              <select name="year" onchange="javascript:">
					<%
						int year1;
					    for (int i = 2001; i <= Integer.parseInt(DataUtil.getCurrentYear()); i++) {
					        year1 = Integer.parseInt(searchDay.substring(0, 4));
					%>
			        <option value="<%= i %>" <%= year1 == i ? " selected " : "" %>><%= i %></option>
					<%
					    }
					%>
	              </select>

	              <select name="month">
					<%
					    for (int i = 1; i <= 12; i++) {
					        String temp = Integer.toString(i);
					        int mon = Integer.parseInt(searchDay.substring(4, 6));
					%>
			        <option value="<%= temp.length() == 1 ? '0' + temp : temp %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
					<%
					    }
					%>
	             </select>
	              <input type="hidden" name="year1" value="">
	              <input type="hidden" name="month1" value="">
	              <input type="hidden" name="searchDay_bf" value="">
	        	<a href="javascript:zocrsn_get();"><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0" align="absmiddle"></a>&nbsp;&nbsp;
				<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  />
	        	<ul class="btn_mdl displayInline">
	         		<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	         	</ul>
			</div>
			<div class="clear"></div>
		</div>
		<div class="table">
			<table class="listTable">
	      		<colgroup>
			      	<col width="8%"/>
			      	<col width="8%"/>
			      	<col width="7%"/>
			      	<col width="7%"/>
			      	<col width="7%"/>
			      	<col width="7%"/>
			      	<col width="7%"/>
			      	<col width="7%"/>
			      	<col width="7%"/>
		      	</colgroup>
				<tr>
		          <th rowspan="2"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
		          <th colspan="5"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
		          <th class="lastCol" rowspan="2"><!--Attendance<br>(Days)--></th>
	        	</tr>
		        <tr>
		          <th><!--Vacation--><%=g.getMessage("LABEL.F.F42.0077")%></th>
		          <th><!--Personal Time--><%=g.getMessage("LABEL.F.F43.0080")%></th>
		          <th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
		          <th><!--Absence--><%=g.getMessage("LABEL.F.F42.0072")%></th>
		          <th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
		        </tr>
		        <tr class="oddRow">
		        	<td class="lastCol" colspan="9"><!--No data--><%=g.getMessage("LABEL.F.F51.0029")%></td>
		        </tr>
	    	</table>
	    </div>
	</div>

<%
    } //end if.
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
