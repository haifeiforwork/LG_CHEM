<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Personal HR Info                                                  															*/
/*   2Depth Name  	: Time management                                                     														*/
/*   Program Name 	: Leave                                               																			*/
/*   Program ID   		: D04VocationDetailEurp.jsp                                              													*/
/*   Description  		: 개인의 휴가현황 정보 조회 [유럽]                           																*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-07-30  yji                                          																	*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
  	WebUserData  user = (WebUserData)session.getAttribute("user");

  	String year = (String)request.getAttribute("year");

  	Vector dataITAB2_vt = (Vector)request.getAttribute("dataITAB2_vt");

  	D03RemainVocationData dataITABData = (D03RemainVocationData)request.getAttribute("dataITABData");
  	D03VacationUsedData dataITAB3Data = (D03VacationUsedData)request.getAttribute("dataITAB3Data");

	  DataUtil.fixNull(dataITABData);
	  DataUtil.fixNull(dataITAB3Data);
	  DataUtil.fixNull(dataITAB3Data);


	int startYear = 2006;
  	int endYear = Integer.parseInt(DataUtil.getCurrentYear());

   	if ((endYear - startYear) > 10) {
        startYear = endYear - 10;
   	}

   	Vector CodeEntity_vt = new Vector();
	for (int i = startYear; i <= endYear; i++ ) {
        CodeEntity entity = new CodeEntity();
        entity.code = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }
%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
function doSubmit(obj) {
    if (obj.value == "" ) {
       alert("Please select year.");
       return;
    }
    document.form1.jobid.value = "search";
    document.form1.year.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D04Vocation.D04VocationDetailEurpSV";
    document.form1.method = "post";
    document.form1.submit();

}
//-->
</script>
<%-- html body 안 헤더부분 - 타이틀 등 --%>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.MSS_PT_LEAV_INFO"/>
    </jsp:include>
<form name="form1" method="post">

	<!--조회년월 검색 테이블 시작-->
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral perInfo">
				<colgroup>
					<col width="12%" />
					<col width="13%" />
					<col width="12%" />
					<col width="13%" />
					<col width="12%" />
					<col width="13%" />
					<col width="12%" />
					<col width="13%" />
				</colgroup>
			<thead>
	         <tr>
	          <th><!-- Year --><%=g.getMessage("LABEL.D.D04.0002")%></th><!-- 조회년도 -->
	          <td>
	            <select name="year" onChange="javascript:doSubmit(this);">
	             <%= WebUtil.printOption(CodeEntity_vt, year) %>
	            </select>
	          </td>
	          <th class="th02"><!--Total Generated --><%=g.getMessage("LABEL.D.D04.0003")%></th>
	          <td>
	            <input type="text" name="ANZHL_GEN" value= "<%= dataITABData.ANZHL_GEN %>" size="10" style="border:none" readonly>
	          </td>
	          <th class="th02"><!-- Total Used --><%=g.getMessage("LABEL.D.D04.0004")%></th>
	          <td>
	            <input type="text" name="ANZHL_USE" value= "<%= dataITABData.ANZHL_USE %>" size="10" style="border:none" readonly>
	          </td>
	          <th class="th02"><!-- Total Balance--><%=g.getMessage("LABEL.D.D04.0005")%></th>
	          <td>
	            <input type="text" name="ANZHL_BAL" value= "<%= dataITABData.ANZHL_BAL %>" size="10" style="border:none" readonly>
	          </td>
	        </tr>
	        </thead>
			</table>
		</div>
	</div>
	<!--조회년월 검색 테이블 끝-->

	<!--Quota Generated  테이블 시작-->


	<div class="listArea">
	<div class="listTop">
            <h2 class="subtitle withButtons"><!-- Quota Generated --><%=g.getMessage("LABEL.D.D04.0007")%></h2>
            <div class="buttonArea">
                <!--Initial Date of Continuous Service--><%=g.getMessage("LABEL.D.D04.0006")%>:
	    	<%= WebUtil.printDate(dataITABData.CSDAT) %></div>
            </div>
		<div class="table">
	       <table class="listTable">
	         	<colgroup>
			       <col width="10%"/>
			       <col width="20%"/>
			       <col width="15%"/>
			       <col width="15%"/>
			       <col width="15%"/>
			       <col />
		     	</colgroup>
		     	<thead>
	         	<tr>
					<th colspan="2"><!-- Quota Type --><%=g.getMessage("LABEL.D.D04.0008")%></th>
					<th><!--Generated --><%=g.getMessage("LABEL.D.D04.0009")%></th>
					<th><!--Used--><%=g.getMessage("LABEL.D.D04.0010")%></th>
					<th><!-- Balance --><%=g.getMessage("LABEL.D.D04.0011")%></th>
					<th class="lastCol"><!-- Validity Limit --><%=g.getMessage("LABEL.D.D04.0012")%></th>
	         	</tr>
	         	</thead>

 <%
 	if (dataITAB2_vt.size() > 0) {
		for (int i=0; i < dataITAB2_vt.size(); i++) {
			D03VacationGeneratedDataEurp data = (D03VacationGeneratedDataEurp)dataITAB2_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
 %>
				<tr class="<%=tr_class%>">
	               <td><%= data.QYEAR %></td>
	               <td><%= data.KTEXT %></td>
	               <td><%= WebUtil.printNumFormat(Double.parseDouble(data.ANZHL),2) %></td>
	               <td><%= WebUtil.printNumFormat(Double.parseDouble(data.KVERB),2) %></td>
	               <td><%= WebUtil.printNumFormat(Double.parseDouble(data.ANZHL_BAL),2) %></td>
	               <td class="lastCol"><%= data.DEEND.equals("0000-00-00")?"":WebUtil.printDate(data.DEEND) %></td>
				</tr>
 <%
 		}
     } else {
 %>
	         	<tr class="oddRow">
	         		<td class="lastCol" colspan="6"><!--No data --><%=g.getMessage("LABEL.D.D04.0039")%></td>
	         	</tr>
 <%
 	}
 %>
			</table>
		</div>

	<!--Quota Generated 테이블 끝-->

	<!-- 테이블 시작-->
	<div class="commentsMoreThan2">
		<div><!-- Carry Over:&nbsp;Accumulated Quota generated in past years. --><%=g.getMessage("LABEL.D.D04.0020")%></div>
	</div>
	</div>
	<!--Quota Used  Details 테이블 시작-->
	<h2 class="subtitle"><!-- Quota Used  Details--><%=g.getMessage("LABEL.D.D04.0036")%></h2>

	<div class="listArea">
		<div class="table">
			<table class="listTable">
			  <thead>
				<tr>
			    	<th class="divide">&nbsp;</th>
				    <th><!-- Jan --><%=g.getMessage("LABEL.D.D04.0022")%></th>
			    	<th><!-- Feb --><%=g.getMessage("LABEL.D.D04.0023")%></th>
					<th><!-- Mar --><%=g.getMessage("LABEL.D.D04.0024")%></th>
					<th><!-- Apr --><%=g.getMessage("LABEL.D.D04.0025")%></th>
					<th><!-- May --><%=g.getMessage("LABEL.D.D04.0026")%></th>
					<th><!-- Jun --><%=g.getMessage("LABEL.D.D04.0027")%></th>
					<th><!-- Jul --><%=g.getMessage("LABEL.D.D04.0028")%></th>
					<th><!-- Aug --><%=g.getMessage("LABEL.D.D04.0029")%></th>
					<th><!-- Sep --><%=g.getMessage("LABEL.D.D04.0030")%></th>
					<th><!-- Oct --><%=g.getMessage("LABEL.D.D04.0031")%></th>
					<th><!-- Nov --><%=g.getMessage("LABEL.D.D04.0032")%></th>
					<th><!-- Dec --><%=g.getMessage("LABEL.D.D04.0033")%></th>
					<th class="lastCol"><!-- Total --><%=g.getMessage("LABEL.D.D04.0034")%></th>
			 	</tr>
			   </thead>
			 	<tr class="oddRow">
			       <td class="divide"><!-- Using Count --><%=g.getMessage("LABEL.D.D04.0037")%></td>
			       <td><%= dataITAB3Data.JANUA %></td>
			       <td><%= dataITAB3Data.FEBRU %></td>
			       <td><%= dataITAB3Data.MARCH %></td>
			       <td><%= dataITAB3Data.APRIL %></td>
			       <td><%= dataITAB3Data.MAY %></td>
			       <td><%= dataITAB3Data.JUNE %></td>
			       <td><%= dataITAB3Data.JULY %></td>
			       <td><%= dataITAB3Data.AUGUS %></td>
			       <td><%= dataITAB3Data.SEPTE %></td>
			       <td><%= dataITAB3Data.OCTOB %></td>
			       <td><%= dataITAB3Data.NOVEM %></td>
			       <td><%= dataITAB3Data.DECEM %></td>
			       <td class="lastCol"><%= dataITAB3Data.TOTAL %></td>
			 	</tr>
			</table>
		</div>
	</div>
	<!--Quota Used  Details 테이블 끝-->

</div>
  <!-- hidden 처리부분 -->
  <input type="hidden" name="jobid" value="">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
