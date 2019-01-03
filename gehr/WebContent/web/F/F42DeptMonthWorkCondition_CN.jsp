<%/**********************************************************************************/
/*	  System Name  	: g-HR																													*/
/*   1Depth Name		: Organization & Staffing                                                 											*/
/*   2Depth Name		: Time Management                                                													*/
/*   Program Name	: Monthly Time Statement                                             												*/
/*   Program ID   		: F42DeptMonthWorkCondition.jsp                               												*/
/*   Description  		: 부서별 월간 근태 집계표 조회를 위한 jsp 파일                														*/
/*   Note         		: 없음                                                        																		*/
/*   Creation     		: 2005-02-17  유용원                                           																*/
/*   Update       		: 2008-11-12  김정인  @v 1.0  [C20081110_55600] data 출력 소수점 첫째자리수(반올림)로 변경 	*/
/***********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.F.Global.*" %>

<%
	request.setCharacterEncoding("utf-8");

    String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));          		//부서코드
    String deptNm		= (WebUtil.nvl(request.getParameter("hdn_deptNm")));       	//부서명
    String searchDay	= WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));   	//대상년월
    String year      	= "";
    String month     	= "";

    Vector F42DeptMonthWorkCondition_vt = (Vector)request.getAttribute("F42DeptMonthWorkCondition_vt");
    Vector F42DeptMonthWorkConditionTotal = (Vector)request.getAttribute("F42DeptMonthWorkConditionTotal");
    F42DeptMonthWorkConditionData todata  = new F42DeptMonthWorkConditionData();
    if(F42DeptMonthWorkConditionTotal.size()>0){
    	todata =(F42DeptMonthWorkConditionData)F42DeptMonthWorkConditionTotal.get(0);
    }

    DecimalFormat f1 = new DecimalFormat("0.0");		// 반올림후 첫째자리수까지.
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
        //alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
        alert("<%=g.getMessage("MSG.F.F41.0003")%>  ");
        return;
    }

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;

    if((frm.year!==null)&&(frm.month!=null)){
	    if(frm.year.tagName=='SELECT'){
		    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
		    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    	}
    }

    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV";
    frm.target = "_self";
    frm.submit();
}



//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    if((frm.year!==null)&&(frm.month!=null)){
	    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
	    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV";
    frm.target = "hidden";
    frm.submit();
}

function zocrsn_get() {
    frm = document.form1;

    if((frm.year!==null)&&(frm.month!=null)){
	    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
	    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }

    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV";
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

    if(frm.searchDay_bf!=null&&frm.searchDay_bf!=null){
    	if(frm.searchDay_bf.value!=yymm&&frm.searchDay_bf.value!="") {
			frm.year.value = frm.searchDay_bf.value.substring(0,4);
      			if(frm.searchDay_bf.value.substring(4,6)!=10&&frm.searchDay_bf.value.substring(4,6)!=11&&frm.searchDay_bf.value.substring(4,6)!=12) {
        			frm.month.value = frm.searchDay_bf.value.substring(5,6);
      			} else {
        			frm.month.value = frm.searchDay_bf.value.substring(4,6);
      			}
    	}
    }
}
$(document).ready(function(){
	searchDayCheck();
 });
//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="F42DeptMonthWorkCondition.html"/>
    </jsp:include>


<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >


<%
    //부서명, 조회된 건수.
   if ( F42DeptMonthWorkCondition_vt != null && F42DeptMonthWorkCondition_vt.size() > 0 ) {
%>
  <div class="listArea">
  	<div class="listTop">
  		<span class="listCnt">
	      <h2 class="subtitle"><%= todata.STEXT  %>:&nbsp;<%= todata.ENAME %></h2>
	    </span>
        <div class="buttonArea">
                	<select name="year" onchange="javascript:">
<%
	int year1;
    for( int i = 2001 ; i <= Integer.parseInt( DataUtil.getCurrentYear() ) ; i++ ) {
        year1 = Integer.parseInt(searchDay.substring(0, 4));
%>
                      <option value="<%= i %>" <%= year1 == i ? " selected " : "" %>><%= i %></option>
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
                <a><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0" style="cursor:hand;margin-top:3px;" onclick="javascript:zocrsn_get();"></a>
				&nbsp;&nbsp;
				<ul class="btn_mdl displayInline">
                	<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
	</div>
   </div>
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
			      	<col width="7%"/>
			      	<col width="7%"/>
			      	<col width="7%"/>
			      	<col width="7%"/>
			      	<col width="7%"/>
			      </colgroup>
			       <thead>
			        <tr>
			          <th colspan="3"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
			          <th rowspan="2"><!--Duty<br>(Account)--><%=g.getMessage("LABEL.F.F42.0060")%></th>
			          <th colspan="2"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
			          <th colspan="2"><!--Leave(Hours)--><%=g.getMessage("LABEL.F.F42.0062")%></th>
			          <th rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></th>
			          <th class="lastCol" colspan="3"><!--Absence(Account)--><%=g.getMessage("LABEL.F.F42.0064")%></th>
			          <!-- th rowspan="2">Confirm</th -->
			        </tr>
			        <tr>
			          <th><!--Workday--><%=g.getMessage("LABEL.F.F42.0065")%></th>
			          <th><!--Offday--><%=g.getMessage("LABEL.F.F42.0066")%></th>
			          <th><!--Holiday--><%=g.getMessage("LABEL.F.F42.0067")%></th>
			          <th><!--Annual--><%=g.getMessage("LABEL.F.F42.0068")%></th>
			          <th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
			          <th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
			          <th><!--Personal--><%=g.getMessage("LABEL.F.F42.0071")%></th>
			          <th><!--Absence--><%=g.getMessage("LABEL.F.F42.0072")%></th>
			          <th><!--Tardiness--><%=g.getMessage("LABEL.F.F42.0073")%></th>
			          <th class="lastCol"><!--Early<br>Dismissal--><%=g.getMessage("LABEL.F.F42.0085")%></th>
			        </tr>
			        </thead>
			        <tr>
			          <td><%= todata.OT_WOR.equals("") ? "0"	:WebUtil.printNumFormat(todata.OT_WOR,1)  %></td>
			          <td><%= todata.OT_OFF.equals("") ? "0"	:WebUtil.printNumFormat(todata.OT_OFF,1)   %></td>
			          <td><%= todata.OT_HOL.equals("") ? "0"	:WebUtil.printNumFormat(todata.OT_HOL,1)   %></td>
			          <td><%= todata.DUTY.equals("") ? "0"		:WebUtil.printNumFormat(todata.DUTY,1)      %></td>
			          <td><%= todata.LE_ANN.equals("") ? "0"	:WebUtil.printNumFormat(todata.LE_ANN,1)   %></td>
			          <td><%= todata.LE_OTH.equals("") ? "0"	:WebUtil.printNumFormat(todata.LE_OTH,1)   %></td>
			          <td><%= todata.LE_SIC.equals("") ? "0"	:WebUtil.printNumFormat(todata.LE_SIC,1)    %></td>
			          <td><%= todata.LE_PER.equals("") ? "0"	:WebUtil.printNumFormat(todata.LE_PER,1)    %></td>

			          <td><%= todata.ATTEN.equals("") ? "0"	:WebUtil.printNumFormat(todata.ATTEN,1)    %></td>
			          <td><%= todata.AB_ABS.equals("") ? "0"	:WebUtil.printNumFormat(todata.AB_ABS,1)   %></td>
			          <td><%= todata.AB_TAR.equals("") ? "0"	:WebUtil.printNumFormat(todata.AB_TAR,1)   %></td>
			          <td class="lastCol"><%= todata.AB_EAR.equals("") ? "0"	:WebUtil.printNumFormat(todata.AB_EAR,1)   %></td>
			        </tr>
			</table>
		</div>
	</div>

<%
	String tempDept = "";
	int i=0;
	int j=0;
	int k=0;
	for(i=0;i<F42DeptMonthWorkCondition_vt.size();){
 %>

	<h2 class="subtitle"><!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> : <%= ((F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(i)).STEXT%></h2>

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
		          <th colspan="3"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
		          <th rowspan="2"><!--Duty<br>(Account)--><%=g.getMessage("LABEL.F.F42.0060")%></th>
		          <th colspan="2"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
		          <th colspan="2"><!--Leave(Hours)--><%=g.getMessage("LABEL.F.F42.0062")%></th>
		          <th rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></th>
		          <th class="lastCol" colspan="3"><!--Absence(Account)--><%=g.getMessage("LABEL.F.F42.0064")%></th>
		          <!-- th rowspan="2">Confirm</th -->

		        </tr>
		        <tr>
		          <th><!--Workday--><%=g.getMessage("LABEL.F.F42.0065")%></th>
		          <th><!--Offday--><%=g.getMessage("LABEL.F.F42.0066")%></th>
		          <th><!--Holiday--><%=g.getMessage("LABEL.F.F42.0067")%></th>
		          <th><!--Annual--><%=g.getMessage("LABEL.F.F42.0068")%></th>
		          <th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
		          <th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
		          <th><!--Personal--><%=g.getMessage("LABEL.F.F42.0071")%></th>
		          <th><!--Absence--><%=g.getMessage("LABEL.F.F42.0072")%></th>
		          <th><!--Tardiness--><%=g.getMessage("LABEL.F.F42.0073")%></th>
		          <th class="lastCol"><!--Early<br>Dismissal--><%=g.getMessage("LABEL.F.F42.0085")%></th>
		        </tr>
		       </thead>

<%
		int tem = j;
        for(; j < F42DeptMonthWorkCondition_vt.size(); j++ ){
            F42DeptMonthWorkConditionData deptData = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(j);
            if(tempDept.equals("")){
            	tempDept = deptData.ORGEH;
            }
			if(!(deptData.ORGEH.equals(tempDept))){
				tempDept = deptData.ORGEH;
				break ;
			}
			i=j+1;
%>
		        <tr class="<%=WebUtil.printOddRow(i+1)%>">
		          <td>&nbsp;&nbsp;<%= deptData.PERNR     %>&nbsp;&nbsp;</td>
		          <td>&nbsp;&nbsp;<%= deptData.ENAME    %></td>
		          <td><%= deptData.OT_WOR.equals("") ? "0"	: WebUtil.printNumFormat(deptData.OT_WOR,1) %></td>
		          <td><%= deptData.OT_OFF.equals("") ? "0"	: WebUtil.printNumFormat(deptData.OT_OFF,1)  %></td>
		          <td><%= deptData.OT_HOL.equals("") ? "0"	: WebUtil.printNumFormat(deptData.OT_HOL,1)  %></td>
		          <td><%= deptData.DUTY.equals("") ? "0"		: WebUtil.printNumFormat(deptData.DUTY,1)     %></td>
		          <td><%= deptData.LE_ANN.equals("") ? "0"	: WebUtil.printNumFormat(deptData.LE_ANN,1)  %></td>
		          <td><%= deptData.LE_OTH.equals("") ? "0"	: WebUtil.printNumFormat(deptData.LE_OTH,1)  %></td>
		          <td><%= deptData.LE_SIC.equals("") ? "0"	: WebUtil.printNumFormat(deptData.LE_SIC,1)   %></td>
		          <td><%= deptData.LE_PER.equals("") ? "0"	: WebUtil.printNumFormat(deptData.LE_PER,1)   %></td>

		          <td><%= deptData.ATTEN.equals("") ? "0"		: WebUtil.printNumFormat(deptData.ATTEN,1)   %></td>
		          <td><%= deptData.AB_ABS.equals("") ? "0"	: WebUtil.printNumFormat(deptData.AB_ABS,1)  %></td>
		          <td><%= deptData.AB_TAR.equals("") ? "0"	: WebUtil.printNumFormat(deptData.AB_TAR,1)  %></td>
		          <td class="lastCol"><%= deptData.AB_EAR.equals("") ? "0"	: WebUtil.printNumFormat(deptData.AB_EAR,1)   %></td>
		        </tr>
  <%
        }//end for
%>
<%
            double	 	OT_WOR=0;
            double		OT_OFF=0;
            double		OT_HOL=0;
            double		DUTY  =0;
            double		LE_ANN=0;
            double	    LE_SIC=0;
            double		LE_PER=0;
            double	    LE_OTH=0;
            double		ATTEN =0;
            double		AB_ABS=0;
            double		AB_TAR=0;
            double		AB_EAR=0;

                for(k = tem; k < j; k++ ){
                    F42DeptMonthWorkConditionData data = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(k);
				 	OT_WOR	+= data.OT_WOR.equals("") ? 0 :  Double.parseDouble(data.OT_WOR);
					OT_OFF	+= data.OT_OFF.equals("") ? 0 :  Double.parseDouble(data.OT_OFF);
					OT_HOL	+= data.OT_HOL.equals("") ? 0 :  Double.parseDouble(data.OT_HOL);
					DUTY  	+= data.DUTY.equals("") ? 0 :  Double.parseDouble(data.DUTY);
					LE_ANN	+= data.LE_ANN.equals("") ? 0 :  Double.parseDouble(data.LE_ANN);
					LE_SIC	+= data.LE_SIC.equals("") ? 0 :  Double.parseDouble(data.LE_SIC);
					LE_PER	+= data.LE_PER.equals("") ? 0 :  Double.parseDouble(data.LE_PER);
					LE_OTH	+= data.LE_OTH.equals("") ? 0 :  Double.parseDouble(data.LE_OTH);
					ATTEN 	+= data.ATTEN.equals("") ? 0 :  Double.parseDouble(data.ATTEN);
					AB_ABS	+= data.AB_ABS.equals("") ? 0 :  Double.parseDouble(data.AB_ABS);
					AB_TAR	+= data.AB_TAR.equals("") ? 0 :  Double.parseDouble(data.AB_TAR);
					AB_EAR	+= data.AB_EAR.equals("") ? 0 :  Double.parseDouble(data.AB_EAR);
	}
%>
		        <tr>
		          <td class="td11">TOTAL</td>
		          <td class="td11"><%=j-tem %> person</td>
		          <td class="td11"><%= WebUtil.printNumFormat(OT_WOR,1) %></td>
		          <td class="td11"><%= WebUtil.printNumFormat(OT_OFF,1)%></td>
		          <td class="td11"><%= WebUtil.printNumFormat(OT_HOL,1) %></td>
		          <td class="td11"><%= WebUtil.printNumFormat(DUTY,1) %></td>
		          <td class="td11"><%= WebUtil.printNumFormat(LE_ANN,1) %></td>
		          <td class="td11"><%= WebUtil.printNumFormat(LE_OTH,1) %></td>
		          <td class="td11"> <%= WebUtil.printNumFormat(LE_SIC,1) %></td>
		          <td class="td11"><%= WebUtil.printNumFormat(LE_PER,1) %></td>

		          <td class="td11"><%= WebUtil.printNumFormat(ATTEN,1) %></td>
		          <td class="td11"><%= WebUtil.printNumFormat(AB_ABS,1) %></td>
		          <td class="td11" ><%= WebUtil.printNumFormat(AB_TAR,1) %></td>
		          <td class="lastCol td11"><%= WebUtil.printNumFormat(AB_EAR,1) %></td>
		        </tr>
			</table>
    	</div>
    </div>
<%
	}
 %>

<%
    }else{
%>

	<div class="tableInquiry">
           <table>
              <tr>
                <td>
                	<select name="year" onchange="javascript:">
<%
	int year1;
    for( int i = 2007 ; i <= Integer.parseInt( DataUtil.getCurrentYear() ) ; i++ ) {
        year1 = Integer.parseInt(searchDay.substring(0, 4));
%>
                      <option value="<%= i %>" <%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
    }
%>
                    </select>
                    <select name="month" >
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
                <a><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0" style="cursor:hand;" onclick="javascript:zocrsn_get();"></a>
               </td>
               </tr>
           </table>
	</div>

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
		      	<col width="7%"/>
		      	<col width="7%"/>
		      	<col width="7%"/>
		      	<col width="7%"/>
		      	<col width="7%"/>
		      </colgroup>
		       <tr>
		          <th colspan="3"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
		          <th rowspan="2"><!--Duty<br>(Account)--><%=g.getMessage("LABEL.F.F42.0060")%></th>
		          <th colspan="2"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
		          <th colspan="2"><!--Leave(Hours)--><%=g.getMessage("LABEL.F.F42.0062")%></th>
		          <th rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></th>
		          <th class="lastCol" colspan="3"><!--Absence(Account)--><%=g.getMessage("LABEL.F.F42.0064")%></th>
		          <!-- th rowspan="2">Confirm</th -->
		        </tr>
		        <tr>
		          <th><!--Workday--><%=g.getMessage("LABEL.F.F42.0065")%></th>
		          <th><!--Offday--><%=g.getMessage("LABEL.F.F42.0066")%></th>
		          <th><!--Holiday--><%=g.getMessage("LABEL.F.F42.0067")%></th>
		          <th><!--Annual--><%=g.getMessage("LABEL.F.F42.0068")%></th>
		          <th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
		          <th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
		          <th><!--Personal--><%=g.getMessage("LABEL.F.F42.0071")%></th>
		          <th><!--Absence--><%=g.getMessage("LABEL.F.F42.0072")%></th>
		          <th><!--Tardiness--><%=g.getMessage("LABEL.F.F42.0073")%></th>
		          <th class="lastCol"><!--Early<br>Dismissal--><%=g.getMessage("LABEL.F.F42.0085")%></th>
		        </tr>

		        <tr class="oddRow">
		        	<td class="lastCol" colspan="12"><!--No data--><%=g.getMessage("LABEL.F.F51.0029")%></td>
		        </tr>
			</table>
		</div>
	</div>


<%
    } //end if...
%>
</div>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
