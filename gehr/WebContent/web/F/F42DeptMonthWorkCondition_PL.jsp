<%/**********************************************************************************/
/*	  System Name  	: MSS																													*/
/*   1Depth Name		: Organization & Staffing                                                 											*/
/*   2Depth Name		: Time Management                                                													*/
/*   Program Name	: Monthly Time Statement                                             												*/
/*   Program ID   		: F42DeptMonthWorkConditionPl.jsp                               												*/
/*   Description  		: 부서별 월간 근태 집계표 조회를 위한 jsp 파일[폴란드]                											*/
/*   Note         		: 없음                                                        																		*/
/*   Creation     		: 2010-07-21  yji                                           															*/
/***********************************************************************************/%>
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
	WebUserData user_m    = (WebUserData)session.getAttribute("user_m");            //세션.
	WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.

    String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));          		//부서코드
    String deptNm		= (WebUtil.nvl(request.getParameter("hdn_deptNm")));       	//부서명
    String searchDay	= WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));   	//대상년월
    String year      	= "";
    String month     	= "";

    Vector vt = new Vector();
    String E_RETURN = "";
    String E_BUKRS   = (String)request.getAttribute("E_BUKRS");
    String E_BUTXT   = "";

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
<jsp:include page="/include/header.jsp" />
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
    frm.hdn_Popflag.value = "Y";

    if((frm.year!==null)&&(frm.month!=null)){
	    if(frm.year.tagName=='SELECT'){
		    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
		    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    	}
    }

    frm.hdn_excel.value = "";
    frm.target = "_self";
	frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV";
	frm.submit();
    frm.hdn_Popflag.value = "N";
}


//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    if((frm.year!==null)&&(frm.month!=null)){
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

    if((frm.year!==null)&&(frm.month!=null)){
	    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
	    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }

    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_excel.value = "";

    frm.target = "_self";
    frm.method = "post";
	frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV";
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
        <jsp:param name="help" value="F42DeptMonthWorkConditionPl.html"/>
        <jsp:param name="click" value="Y"/>
    </jsp:include>


<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="E_BUKRS" value="<%= E_BUKRS %>">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="hdn_Popflag"   value="N">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >
<!--   부서검색 보여주는 부분  끝    -->

<%
    //부서명, 조회된 건수.
   if ( F42DeptMonthWorkCondition_vt != null && F42DeptMonthWorkCondition_vt.size() > 0 ) {
%>

<div class="buttonArea">
                <td><select name="year" onchange="javascript:">
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
               &nbsp;&nbsp;
               <ul class="btn_mdl displayInline">
                	<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
               </td>
	</div>

	<h2 class="subtitle"><%= todata.STEXT  %>:&nbsp;<%= todata.ENAME %></h2>

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
			      </colgroup>
			       <thead>
			        <tr>
			          <th colspan="4"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
			          <th colspan="4"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
			          <th rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></th>
			          <th colspan="2" class="lastCol"><!--Absence(Account)--><%=g.getMessage("LABEL.F.F42.0064")%></th>
			        </tr>
			        <tr>
			          <th>50%</th>
			          <th>100%</th>
			          <th><!--Night--><%=g.getMessage("LABEL.F.F42.0081")%></th>
			          <th><!--Holiday--><%=g.getMessage("LABEL.F.F42.0067")%></th>
			          <th><!--Vacation--><%=g.getMessage("LABEL.F.F42.0077")%></th>
			          <th><!--On<br>Demand--><%=g.getMessage("LABEL.F.F42.0082")%></th>
			          <th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
			          <th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
			          <th><!--Not explained--><%=g.getMessage("LABEL.F.F42.0083")%></th>
			          <th class="lastCol'"><!--Tardiness--><%=g.getMessage("LABEL.F.F42.0073")%></th>
			        </tr>
			        </thead>
			        <tr>
			          <td><%= todata.OT_ADD.equals("") ? "0"	: f1.format(Double.parseDouble(todata.OT_ADD))  %></td>
			          <td><%= todata.OT_WOR.equals("") ? "0"	: f1.format(Double.parseDouble(todata.OT_WOR))  %></td>
			          <td><%= todata.OT_OFF.equals("") ? "0"	: f1.format(Double.parseDouble(todata.OT_OFF))   %></td>
			          <td><%= todata.OT_HRS.equals("") ? "0"	: f1.format(Double.parseDouble(todata.OT_HRS))   %></td>
			          <td><%= todata.LE_ANN.equals("") ? "0"	: f1.format(Double.parseDouble(todata.LE_ANN))   %></td>
			          <td><%= todata.LE_DMD.equals("") ? "0"	: f1.format(Double.parseDouble(todata.LE_DMD))   %></td>
			          <td><%= todata.LE_OTH.equals("") ? "0"	: f1.format(Double.parseDouble(todata.LE_OTH))   %></td>
			          <td><%= todata.LE_SIC.equals("") ? "0"	: f1.format(Double.parseDouble(todata.LE_SIC))    %></td>
			          <td><%= todata.ATTEN.equals("") ? "0"	: f1.format(Double.parseDouble(todata.ATTEN))    %></td>
			          <td><%= todata.AB_ABS.equals("") ? "0"	: f1.format(Double.parseDouble(todata.AB_ABS))   %></td>
			          <td class="lastCol"><%= todata.AB_TAR.equals("") ? "0"	: f1.format(Double.parseDouble(todata.AB_TAR))   %></td>
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
			      	<col width="12%"/>
			      	<col width="14%"/>
			      	<col width="8%"/>
			      	<col width="8%"/>
			      	<col width="8%"/>
			      	<col width="8%"/>
			      	<col width="8%"/>
			      	<col width="8%"/>
			      	<col width="8%"/>
			      	<col width="8%"/>
			      </colgroup>
			      <thead>
			        <tr>
			          <th rowspan="2"	class="th03"><!--Pers.No--><%=g.getMessage("LABEL.F.F42.0075")%></th>
			          <th rowspan="2"	class="th03"><!--Name--><%=g.getMessage("LABEL.F.F42.0076")%></th>
			          <th colspan="4"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
			          <th colspan="4"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
			          <th rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></th>
			          <th class="lastCol" colspan="2"><!--Absence(Account)--><%=g.getMessage("LABEL.F.F42.0064")%></th>
			        </tr>
			        <tr>
			          <th>50%</th>
			          <th>100%</th>
			          <th><!--Night--><%=g.getMessage("LABEL.F.F42.0081")%></th>
			          <th><!--Holiday--><%=g.getMessage("LABEL.F.F42.0067")%></th>
			          <th><!--Vacation--><%=g.getMessage("LABEL.F.F42.0077")%></th>
			          <th><!--On<br>Demand--><%=g.getMessage("LABEL.F.F42.0082")%></th>
			          <th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
			          <th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
			          <th><!--Not explained--><%=g.getMessage("LABEL.F.F42.0083")%></th>
			          <th class="lastCol"><!--Tardiness--><%=g.getMessage("LABEL.F.F42.0073")%></th>
			        </tr>
			       </thead>


<%
		int tem = j;
        for(; j < F42DeptMonthWorkCondition_vt.size(); j++ ){
            F42DeptMonthWorkConditionData deptData = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(j);

            String tr_class = "";

            if(j%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

            if(tempDept.equals("")){
            	tempDept = deptData.ORGEH;
            }
			if(!(deptData.ORGEH.equals(tempDept))){
				tempDept = deptData.ORGEH;
				break ;
			}
			i=j+1;
%>
			        <tr class="<%=tr_class%>">
			          <td><%= deptData.PERNR     %></td>
			          <td><%= deptData.ENAME    %></td>
			          <td><%= deptData.OT_ADD.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.OT_ADD)) %></td>
			          <td><%= deptData.OT_WOR.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.OT_WOR)) %></td>
			          <td><%= deptData.OT_OFF.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.OT_OFF))  %></td>
			          <td><%= deptData.OT_HRS.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.OT_HRS))  %></td>
			          <td><%= deptData.LE_ANN.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.LE_ANN))  %></td>
			          <td><%= deptData.LE_DMD.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.LE_DMD))  %></td><!-- on Demand -->
			          <td><%= deptData.LE_OTH.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.LE_OTH))  %></td>
			          <td><%= deptData.LE_SIC.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.LE_SIC))   %></td>
			          <td><%= deptData.ATTEN.equals("") ? "0"		: f1.format(Double.parseDouble(deptData.ATTEN))   %></td>
			          <td><%= deptData.AB_ABS.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.AB_ABS))  %></td>
			          <td class="lastCol"><%= deptData.AB_TAR.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.AB_TAR))  %></td>
			        </tr>
  <%
        }//end for
%>
<%
			double      OT_ADD=0;
            double	 	OT_WOR=0;
            double		OT_OFF=0;
            double		OT_HRS=0;
            double		DUTY  =0;
            double		LE_ANN=0;
            double	    LE_SIC=0;
            double		LE_PER=0;
            double	    LE_OTH=0;
            double		ATTEN =0;
            double		AB_ABS=0;
            double		AB_TAR=0;
            double		LE_DMD=0;

                for(k = tem; k < j; k++ ){
                    F42DeptMonthWorkConditionData data = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(k);
                    OT_ADD	+= data.OT_ADD.equals("") ? 0 :  Double.parseDouble(data.OT_ADD);
                    OT_WOR	+= data.OT_WOR.equals("") ? 0 :  Double.parseDouble(data.OT_WOR);
					OT_OFF	+= data.OT_OFF.equals("") ? 0 :  Double.parseDouble(data.OT_OFF);
					OT_HRS	+= data.OT_HRS.equals("") ? 0 :  Double.parseDouble(data.OT_HRS);
					LE_ANN	+= data.LE_ANN.equals("") ? 0 :  Double.parseDouble(data.LE_ANN);
					LE_DMD	+= data.LE_DMD.equals("") ? 0 :  Double.parseDouble(data.LE_DMD);
					LE_OTH	+= data.LE_OTH.equals("") ? 0 :  Double.parseDouble(data.LE_OTH);
					LE_SIC	+= data.LE_SIC.equals("") ? 0 :  Double.parseDouble(data.LE_SIC);
					ATTEN 	+= data.ATTEN.equals("") ? 0 :  Double.parseDouble(data.ATTEN);
					AB_ABS	+= data.AB_ABS.equals("") ? 0 :  Double.parseDouble(data.AB_ABS);
					AB_TAR	+= data.AB_TAR.equals("") ? 0 :  Double.parseDouble(data.AB_TAR);
	}
%>
			        <tr>
			          <td class="td11">TOTAL</td>
			          <td  class="td11"><%=j-tem %> person</td>
			          <td  class="td11"><%= f1.format(OT_ADD) %></td>
			          <td  class="td11"><%= f1.format(OT_WOR) %></td>
			          <td  class="td11"><%= f1.format(OT_OFF) %></td>
			          <td  class="td11"><%= f1.format(OT_HRS) %></td>
			          <td  class="td11"><%= f1.format(LE_ANN) %></td>
			          <td  class="td11"><%= f1.format(LE_DMD) %></td><!-- on Demand -->
			          <td  class="td11"><%= f1.format(LE_OTH) %></td>
			          <td  class="td11"><%= f1.format(LE_SIC) %></td>
			          <td  class="td11"><%= f1.format(ATTEN) %></td>
			          <td  class="td11"><%= f1.format(AB_ABS) %></td>
			          <td class="lastCol td11"><%= f1.format(AB_TAR) %></td>
			        </tr>
			</table>
		</div>
	</div>
<%
	}
 %>

</div>
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
                <a><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0" style="cursor:hand;" onclick="javascript:zocrsn_get();"></a>
			</td>
		</tr>
	</table>
	</div>

	<h2 class="subtitle">TOTAL:&nbsp;0&nbsp;Person</h2>

	<div class="listArea">
		<div class="table">
	    	<table class="listTable">
		      <colgroup>
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
	          		<th colspan="4"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
	          		<th colspan="4"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
	          		<th rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></th>
	          		<th class="lastCol" colspan="2"><!--Absence(Account)--><%=g.getMessage("LABEL.F.F42.0064")%></th>
		        </tr>
		        <tr>
		            <th>50%</th>
		            <th>100%</th>
	          	    <th><!--Night--><%=g.getMessage("LABEL.F.F42.0081")%></th>
	          	    <th><!--Holiday--><%=g.getMessage("LABEL.F.F42.0067")%></th>
	          		<th><!--Vacation--><%=g.getMessage("LABEL.F.F42.0077")%></th>
	          		<th><!--On<br>Demand--><%=g.getMessage("LABEL.F.F42.0082")%></th>
	          		<th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
	          		<th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
	          		<th><!--Not explained--><%=g.getMessage("LABEL.F.F42.0083")%></th>
	          		<th class="lastCol"><!--Tardiness--><%=g.getMessage("LABEL.F.F42.0073")%></th>
		        </tr>
	            <tr class="oddRow">
		        	<td class="lastCol" colspan="12"><!--No data--><%=g.getMessage("LABEL.F.F51.0029")%></td>
		        </tr>
	    	</table>
	    </div>
	</div>

    <h2 class="subtitle"><!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> :</h2>

    <div class="listArea">
    	<div class="table">
	      <table class="listTable">
		      <colgroup>
		      	<col width="12%"/>
		      	<col width="14%"/>
		      	<col width="7%"/>
		      	<col width="7%"/>
		      	<col width="7%"/>
		      	<col width="7%"/>
		      	<col width="8%"/>
		      	<col width="8%"/>
		      	<col width="8%"/>
		      	<col width="8%"/>
		      	<col width="8%"/>
		      </colgroup>
		        <tr>
		          <th rowspan="2"><!--Pers.No--><%=g.getMessage("LABEL.F.F42.0075")%></th>
		          <th rowspan="2"><!--Name--><%=g.getMessage("LABEL.F.F42.0076")%></th>
		          <th colspan="4"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></th>
		          <th colspan="4"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></th>
		          <th rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></th>
		          <th class="lastCol" colspan="2"><!--Absence(Account)--><%=g.getMessage("LABEL.F.F42.0064")%></th>
		        </tr>
		        <tr>
		          <th>50%</th>
		          <th>100%</th>
		          <th><!--Night--><%=g.getMessage("LABEL.F.F42.0081")%></th>
		          <th><!--Holiday--><%=g.getMessage("LABEL.F.F42.0067")%></th>
		          <th><!--Vacation--><%=g.getMessage("LABEL.F.F42.0077")%></th>
		          <th><!--On<br>Demand--><%=g.getMessage("LABEL.F.F42.0082")%></th>
		          <th><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></th>
		          <th><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></th>
		          <th><!--Not explained--><%=g.getMessage("LABEL.F.F42.0083")%></th>
		          <th class="lastCol"><!--Tardiness--><%=g.getMessage("LABEL.F.F42.0073")%></th>
		        </tr>
			    <tr class="oddRow">
			      <td class="lastCol" colspan="13"><!--No data--><%=g.getMessage("LABEL.F.F51.0029")%></td>
			    </tr>
<%
    } //end if...
%>
			</table>
		</div>
	</div>
</div>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
