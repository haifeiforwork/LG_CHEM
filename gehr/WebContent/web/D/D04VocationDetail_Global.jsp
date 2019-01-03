<%/******************************************************************************/
/*                                                                              																*/
/*   System Name  	: MSS                                                         													*/
/*   1Depth Name  	: MY HR 정보                                                  															*/
/*   2Depth Name  	: 휴가실적정보                                                    															*/
/*   Program Name 	: 휴가실적정보                                               																*/
/*   Program ID   		: D04VocationDetail.jsp                                              										*/
/*   Description  		: 개인의 휴가현황 정보 조회                           																*/
/*   Note         		:                                                             														*/
/*   Creation    		: 2002-01-21  chldudgh                                          											*/
/*   Update       		: 2005-01-24  윤정현                                         														*/
/*                  		: 2007-09-12  huang peng xiao                           												*/
/*   						: 2007-09-13  zhouguangwen  global e-hr update                                       			*/
/*   						: 2008-03-25  김정인                                       															*/
/*							  [CSR번호 : C20080325_39053] Welfare Leave(복리휴가) 필드추가								*/
/*							: 2015-01-06 pangxiaolin@2.0[C20150106_74180] 【紧急】E-HR年假显示界面异常处理   */
/*                         : 2017-12-18 이지은 [CSR ID:3544114] [LGCTW]Request of Global HR Portal system Compensatory Leave(補休假) function increasing */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>

<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
  WebUserData  user = (WebUserData)session.getAttribute("user");

  String year         = ( String ) request.getAttribute( "year"  ) ;
  Vector d04VocationDetailData_vt = (Vector)request.getAttribute("d04VocationDetailData_vt");
  D03RemainVocationData remainVocationData =(D03RemainVocationData)Utils.indexOf(d04VocationDetailData_vt, 0, D03RemainVocationData.class);
  D03VacationGeneratedData vcationGenerateData =(D03VacationGeneratedData) Utils.indexOf(d04VocationDetailData_vt, 1, D03VacationGeneratedData.class);
  D03VacationUsedData vocationUsedData = (D03VacationUsedData)Utils.indexOf(d04VocationDetailData_vt, 2, D03VacationUsedData.class);

  DataUtil.fixNull(remainVocationData);
  DataUtil.fixNull(vcationGenerateData);
  DataUtil.fixNull(vocationUsedData);

  int startYear       = 2006;
  int endYear         = Integer.parseInt( DataUtil.getCurrentYear() );

   if( ( endYear - startYear ) > 10 ){
        startYear = endYear - 10;
    }
    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

%>

<jsp:include page="/include/header.jsp"/>
<script language="JavaScript">
<!--
function doSubmit(obj) {
    if ( obj.value =="") {
       alert("Please select year.");
       return;
    }
    document.form1.jobid.value = "search";
    document.form1.year.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D04Vocation.D04VocationDetailGlobalSV";
    document.form1.method = "post";
    document.form1.submit();

}
//-->
</script>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.MSS_PT_LEAV_INFO"/>
    </jsp:include>
	<form name="form1" method="post">

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
                <tr>
                  <th><!-- Year --><%=g.getMessage("LABEL.D.D04.0002")%></th>
                  <td>
                    <select name="year" onChange="javascript:doSubmit(this);">
                     <%= WebUtil.printOption(CodeEntity_vt, year)%>
                    </select>
                  </td>
                  <th class="th02"><!--Total Generated --><%=g.getMessage("LABEL.D.D04.0003")%></th>
                  <td>
                    <input type="text" name="ANZHL_GEN" value= "<%= (remainVocationData.ANZHL_GEN.equals("0")||remainVocationData.ANZHL_GEN.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(remainVocationData.ANZHL_GEN),2) %>" size="10" style="border:none" readonly>
                  </td>
                  <th class="th02"><!-- Total Used --><%=g.getMessage("LABEL.D.D04.0004")%></th>
                  <td>
                    <input type="text" name="ANZHL_USE" value= "<%= (remainVocationData.ANZHL_USE.equals("0")||remainVocationData.ANZHL_USE.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(remainVocationData.ANZHL_USE),2) %>&nbsp;" size="10" style="border:none;" readonly>
                  </td>
                  <th class="th02"><!-- Total Balance--><%=g.getMessage("LABEL.D.D04.0005")%></th>
                  <td>
                    <input type="text" name="ANZHL_BAL" value= "<%= (remainVocationData.ANZHL_BAL.equals("0")||remainVocationData.ANZHL_BAL.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(remainVocationData.ANZHL_BAL),2) %>&nbsp;" size="10" style="border:none;" readonly>
                  </td>
                </tr>
			</table>
		</div>
	</div>
	<!--조회년월 검색 테이블 끝-->

	<!--교육이수현황 리스트 테이블 시작-->


  <h2 class="subtitle "><!-- Quota Generated --><%=g.getMessage("LABEL.D.D04.0007")%></h2>
    <div  style="float:right">
          <!--Initial Date of Continuous Service--><%=g.getMessage("LABEL.D.D04.0006")%>:<%= WebUtil.printDate(remainVocationData.CSDAT) %>
    </div>
	<div class="listArea">
		<div class="table">
           <table class="listTable">
	            <colgroup>
			      	<col width="130"/>
			      	<col width="130"/>
			      	<col width="130"/>
			      	<col width="130"/>
			      	<col width="130"/>
			      	<col width="130"/>
			    </colgroup>
			    <thead>
	            <tr>
	                <th colspan="2" class="divide"><!-- Quota Type --><%=g.getMessage("LABEL.D.D04.0008")%></th>
	                <th><!--Generated --><%=g.getMessage("LABEL.D.D04.0009")%></th>
	                <th><!--Used--><%=g.getMessage("LABEL.D.D04.0010")%></th>
	                <th><!-- Balance --><%=g.getMessage("LABEL.D.D04.0011")%></th>
	                <th class="lastCol"><!-- Validity Limit --><%=g.getMessage("LABEL.D.D04.0012")%></th>
	            </tr>
	            </thead>
<%
	int odd=0;
	String tr_class="";

	int i=0,j=0;
	//vcationGenerateData.COMGE = "1";
	//vcationGenerateData.COAGE = "1";
	if(vcationGenerateData.COMGE.equals("0")||vcationGenerateData.COMGE.equals("")){
		if(vcationGenerateData.COMUS.equals("0")||vcationGenerateData.COMUS.equals("")){
			if(vcationGenerateData.COMBA.equals("0")||vcationGenerateData.COMBA.equals("")){
				i = 1;
			}
		}
	}
	if(vcationGenerateData.COAGE.equals("0")||vcationGenerateData.COAGE.equals("")){
		if(vcationGenerateData.COAUS.equals("0")||vcationGenerateData.COAUS.equals("")){
			if(vcationGenerateData.COABA.equals("0")||vcationGenerateData.COABA.equals("")){
				j = 1;
			}
		}
	}

	if( i != 1){
		odd=odd+1;
		  if(odd%2 == 0){
              tr_class="oddRow";
          }else{
              tr_class="";
          }
%>
	             <tr class=class="<%=tr_class %>">
	                   <td <%= j != 1?"rowspan=\"2\"":"" %>><!-- Last Year --><%=g.getMessage("LABEL.D.D04.0040")%></td>
	                   <td class="divide"><!-- Monthly Leave --><%=g.getMessage("LABEL.D.D04.0014")%></td>
	                   <td style="text-align:center"><%= (vcationGenerateData.COMGE.equals("0")||vcationGenerateData.COMGE.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.COMGE),2) %></td>
	                   <td style="text-align:center"><%= (vcationGenerateData.COMUS.equals("0")||vcationGenerateData.COMUS.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.COMUS),2) %></td>
	                   <td style="text-align:center"><%= (vcationGenerateData.COMBA.equals("0")||vcationGenerateData.COMBA.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.COMBA),2) %></td>
	              <%-- <td align="left"><%= (vcationGenerateData.COMVA.replace("-","").equals("00000000"))?"&nbsp;":WebUtil.printDate(vcationGenerateData.COMVA.replace("-","")) %></td> --%>
	                   <td class="lastCol"><%= vcationGenerateData.COMVA.equals("0000-00-00")?"":WebUtil.printDate(vcationGenerateData.COMVA).equals("9999.12.31")?"Limitless":WebUtil.printDate(vcationGenerateData.COMVA) %></td>
	             </tr>
<%} if( j != 1){
	odd=odd+1;
	  if(odd%2 == 0){
        tr_class="oddRow";
    }else{
        tr_class="";
    }

%>
	             <tr class="<%=tr_class %>">
<%if( i != 0){  %>
	             	   <td><!-- Last Year --><%=g.getMessage("LABEL.D.D04.0040")%></td>
<% } %>
	                   <td class="divide"><!-- Annual Leave --><%=g.getMessage("LABEL.D.D04.0015")%></td>
	                   <td><%= (vcationGenerateData.COAGE.equals("0")||vcationGenerateData.COAGE.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.COAGE),2) %></td>
	                   <td><%= (vcationGenerateData.COAUS.equals("0")||vcationGenerateData.COAUS.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.COAUS),2) %></td>
	                   <td><%= (vcationGenerateData.COABA.equals("0")||vcationGenerateData.COABA.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.COABA),2) %></td>
	             <%--  <td><%= (vcationGenerateData.COAVA.replace("-","").equals("00000000"))?"&nbsp;":WebUtil.printDate(vcationGenerateData.COAVA.replace("-",""))%></td> --%>
	                   <td class="lastCol"><%= vcationGenerateData.COAVA.equals("0000-00-00")?"-":WebUtil.printDate(vcationGenerateData.COAVA).equals("9999.12.31")?"Limitless":WebUtil.printDate(vcationGenerateData.COAVA)%></td>
	             </tr>
<% }

		odd=odd+1;
		if(odd%2 == 0){
  				tr_class="oddRow";
		}else{
  			tr_class="";
		}

%>
				<tr class="<%=tr_class %>">
	                   <td><!--Current Year --><%=g.getMessage("LABEL.D.D04.0018")%></td>
	                   <td class="divide"><!-- Annual Leave --><%=g.getMessage("LABEL.D.D04.0015")%></td>
	                   <td><%= (vcationGenerateData.CYAGE.equals("0")||vcationGenerateData.CYAGE.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.CYAGE),2) %></td>
	                   <td><%= (vcationGenerateData.CYAUS.equals("0")||vcationGenerateData.CYAUS.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.CYAUS),2) %></td>
	                   <td><%= (vcationGenerateData.CYABA.equals("0")||vcationGenerateData.CYABA.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.CYABA),2) %></td>
	                   <td class="lastCol"><%= vcationGenerateData.CYAVA.equals("0000-00-00")?"-":WebUtil.printDate(vcationGenerateData.CYAVA).equals("9999.12.31")?"Limitless":WebUtil.printDate(vcationGenerateData.CYAVA)%></td>
	             </tr>

                 <%
                 	//Welfare Leave(복리휴가) 필드추가.		[CSR번호 : C20080325_39053]	2008-03-25.	김정인.
                 	int iu=0,jf=0;
                 	if(vcationGenerateData.WUAGE.equals("0")||vcationGenerateData.WUAGE.equals("")){
                 		if(vcationGenerateData.WUAUS.equals("0")||vcationGenerateData.WUAUS.equals("")){
                 			if(vcationGenerateData.WUABA.equals("0")||vcationGenerateData.WUABA.equals("")){
                 				iu = 1;
                 			}
                 		}
                 	}
                 	if(vcationGenerateData.WFAGE.equals("0")||vcationGenerateData.WFAGE.equals("")){
                 		if(vcationGenerateData.WFAUS.equals("0")||vcationGenerateData.WFAUS.equals("")){
                 			if(vcationGenerateData.WFABA.equals("0")||vcationGenerateData.WFABA.equals("")){
                  				jf = 1;
                 			}
                 		}
                 	}

                 	if( iu != 1){

                		odd=odd+1;
                		if(odd%2 == 0){
                  				tr_class="oddRow";
                		}else{
                  			tr_class="";
                		}
                 %>
                 <tr class="<%=tr_class %>">
				 <%--2015-01-06 pangxiaolin@2.0[C20150106_74180] 【紧急】E-HR年假显示界面异常处理 begin
                 	   if( iu != 0){  --%>
                 	   <td><!-- Last Year --><%=g.getMessage("LABEL.D.D04.0040")%></td>
                 	   <%-- }
			    2015-01-06 pangxiaolin@2.0[C20150106_74180] 【紧急】E-HR年假显示界面异常处理 end--%>
                       <td class="divide"><!-- Welfare Leave --><%=g.getMessage("LABEL.D.D04.0017")%></td>
                       <td><%= (vcationGenerateData.WUAGE.equals("0")||vcationGenerateData.WUAGE.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.WUAGE),2) %></td>
                       <td><%= (vcationGenerateData.WUAUS.equals("0")||vcationGenerateData.WUAUS.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.WUAUS),2) %></td>
                       <td><%= (vcationGenerateData.WUABA.equals("0")||vcationGenerateData.WUABA.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.WUABA),2) %></td>
                       <td class="lastCol"><%= vcationGenerateData.WUAVA.equals("0000-00-00")?"-":WebUtil.printDate(vcationGenerateData.WUAVA).equals("9999.12.31")?"Limitless":WebUtil.printDate(vcationGenerateData.WUAVA)%></td>
                 </tr>
                 <%} if( jf != 1){
             		odd=odd+1;
            		if(odd%2 == 0){
              				tr_class="oddRow";
            		}else{
              			tr_class="";
            		}


                 %>
                 <tr class="<%=tr_class %>">
                       <td><!--Current Year --><%=g.getMessage("LABEL.D.D04.0018")%></td>
                       <td class="divide"><!-- Welfare Leave --><%=g.getMessage("LABEL.D.D04.0017")%></td>
                       <td><%= (vcationGenerateData.WFAGE.equals("0")||vcationGenerateData.WFAGE.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.WFAGE),2) %></td>
                       <td><%= (vcationGenerateData.WFAUS.equals("0")||vcationGenerateData.WFAUS.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.WFAUS),2) %></td>
                       <td><%= (vcationGenerateData.WFABA.equals("0")||vcationGenerateData.WFABA.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.WFABA),2) %></td>
                       <td><%= vcationGenerateData.WFAVA.equals("0000-00-00")?"-":WebUtil.printDate(vcationGenerateData.WFAVA).equals("9999.12.31")?"Limitless":WebUtil.printDate(vcationGenerateData.WFAVA)%></td>
                 </tr>
                 <% } %>
                 
<!-- [CSR ID:3544114] 시작 -->
<%	if(remainVocationData.BUKRS.equals("G220") ) { %>                 
                 <tr class=class="<%=tr_class %>">
	                   <%-- <td <%= j != 1?"rowspan=\"2\"":"" %>><!-- Last Year --><%=g.getMessage("LABEL.D.D04.0040")%></td> --%>
	                   <td>Last Payroll Period</td>
	                   <td class="divide">Compensatory Leave</td>
	                   <td style="text-align:center"><%= (vcationGenerateData.CLLGE.equals("0")||vcationGenerateData.CLLGE.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.CLLGE),2) %></td><!-- 대체휴가 생긴 거 -->
	                   <td style="text-align:center"><%= (vcationGenerateData.CLLUS.equals("0")||vcationGenerateData.CLLUS.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.CLLUS),2) %></td><!-- 대체휴가 사용한 거  -->
	                   <td style="text-align:center"><%= (vcationGenerateData.CLLBA.equals("0")||vcationGenerateData.CLLBA.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.CLLBA),2) %></td><!-- 대체휴가 남은 거 -->
	                   <td class="lastCol"><%= vcationGenerateData.CLLVA.equals("0000-00-00")?"":WebUtil.printDate(vcationGenerateData.CLLVA).equals("9999.12.31")?"Limitless":WebUtil.printDate(vcationGenerateData.CLLVA) %></td><!-- 사용 제한 기한 -->
	             </tr>
	             <tr class="<%=tr_class %>">
                       <td >This Payroll Period</td>
                       <td class="divide">Compensatory Leave</td>
                       <td><%= (vcationGenerateData.CLCGE.equals("0")||vcationGenerateData.CLCGE.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.CLCGE),2) %></td>
                       <td><%= (vcationGenerateData.CLCUS.equals("0")||vcationGenerateData.CLCUS.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.CLCUS),2) %></td>
                       <td><%= (vcationGenerateData.CLCBA.equals("0")||vcationGenerateData.CLCBA.equals("")) ? "0.00" : WebUtil.printNumFormat(Double.parseDouble(vcationGenerateData.CLCBA),2) %></td>
                       <td><%= vcationGenerateData.CLCVA.equals("0000-00-00")?"-":WebUtil.printDate(vcationGenerateData.CLCVA).equals("9999.12.31")?"Limitless":WebUtil.printDate(vcationGenerateData.CLCVA)%></td>
                 </tr>
<%} %>
<!-- [CSR ID:3544114] 종료 -->
                 
			</table>
		</div>

	<!--조회년월 검색 테이블 끝-->
	<div class="clearfix">
	<!--교육이수현황 리스트 테이블 시작-->
	<div class=commentsMoreThan2>
<%
if((i == 0 || j == 0))
	if(!remainVocationData.BUKRS.equals("G220") ) {%>

		<div><!-- *&nbsp;Last Year:&nbsp;Quota generated in previous year. --><%=g.getMessage("LABEL.D.D04.0035")%></div>

<%}else{ %>

		<div>&nbsp;<!-- *&nbsp;Carry Over:&nbsp;Accumulated Quota generated in past years. --><%=g.getMessage("LABEL.D.D04.0020")%></div>

<%} %>

		<div>&nbsp;<!-- *&nbsp;Generated Quotas of year 2007 is the remainder quotas not total generated quotas. --><%=g.getMessage("LABEL.D.D04.0021")%></div>
	</div>
</div>
</div>
	<!--교육이수현황 리스트 테이블 시작-->
	<div class="clearfix">

	<h2 class="subtitle"><!-- Quota Used  Details--><%=g.getMessage("LABEL.D.D04.0036")%></h2>
	</div>

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
               <%--    <td><%= (vocationUsedData.JANUA.equals("0")||vocationUsedData.JANUA.equals("")) ? "&nbsp;" : WebUtil.printNumFormat(Double.parseDouble(vocationUsedData.JANUA),1) %></td>  --%>
                       <td><%= vocationUsedData.JANUA.equals("")? "&nbsp;" : vocationUsedData.JANUA%></td>
	                   <td><%= vocationUsedData.FEBRU.equals("")? "&nbsp;" : vocationUsedData.FEBRU%></td>
	                   <td><%= vocationUsedData.MARCH.equals("")? "&nbsp;" : vocationUsedData.MARCH%></td>
	                   <td><%= vocationUsedData.APRIL.equals("")? "&nbsp;" : vocationUsedData.APRIL%></td>
	                   <td><%= vocationUsedData.MAY.equals("")? "&nbsp;" : vocationUsedData.MAY  %></td>
	                   <td><%= vocationUsedData.JUNE.equals("")? "&nbsp;" : vocationUsedData.JUNE %></td>
	                   <td><%= vocationUsedData.JULY.equals("")? "&nbsp;" : vocationUsedData.JULY%></td>
	                   <td><%= vocationUsedData.AUGUS.equals("")? "&nbsp;" : vocationUsedData.AUGUS%></td>
	                   <td><%= vocationUsedData.SEPTE.equals("")? "&nbsp;" : vocationUsedData.SEPTE %></td>
	                   <td><%= vocationUsedData.OCTOB.equals("")? "&nbsp;" : vocationUsedData.OCTOB%></td>
	                   <td><%= vocationUsedData.NOVEM.equals("")? "&nbsp;" : vocationUsedData.NOVEM%></td>
	                   <td><%= vocationUsedData.DECEM.equals("") ? "&nbsp;" : vocationUsedData.DECEM %></td>
	                   <td class="lastCol"><%= vocationUsedData.TOTAL.equals("") ? "&nbsp;" : vocationUsedData.TOTAL %></td>
                 </tr>
			</table>
		</div>
	</div>
	<!--조회년월 검색 테이블 끝-->


</div>
  <!-- hidden 처리부분 -->
  <input type="hidden" name="jobid"     value="">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
