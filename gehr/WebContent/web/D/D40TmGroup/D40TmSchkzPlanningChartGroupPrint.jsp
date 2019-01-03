<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정	-근무계획표 조회						*/
/*   Program Name	:   계획근무일정	-근무계획표 출력을 위한 jsp 파일		*/
/*   Program ID		: D40TmSchkzPlanningChartPrint.jsp					*/
/*   Description		: 계획근무일정-근무계획표 출력을 위한 jsp 파일		*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
	WebUserData user = (WebUserData)session.getAttribute("user");

	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자

	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));

	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_TPROG    = (Vector)request.getAttribute("T_TPROG");	//일일근무상세설명
	Vector T_EXPORTA    = (Vector)request.getAttribute("T_EXPORTA");	//근무계획표-TITLE
	Vector T_EXPORTB    = (Vector)request.getAttribute("T_EXPORTB");	//근무계획표-DATA

	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜
	String gubun    = (String)request.getAttribute("gubun");	//선택날짜
%>

<jsp:include page="/include/header.jsp" />
<!-- Page Skip 해서 프린트 하기 -->
<style type = "text/css">
P.breakhere {page-break-before: always}
</style>
<SCRIPT LANGUAGE="JavaScript">
<!--
function prevDetail() {
  switch (location.hash)  {
    case "#page2":
      location.hash ="#page1";
    break;
  } // end switch
}

function nextDetail() {
  switch (location.hash)  {
    case "":
    case "#page1":
      location.hash ="#page2";
    break;
  } // end switch
}

function click() {
    if (event.button==2) {
      //alert('마우스 오른쪽 버튼은 사용할수 없습니다.');
      //alert('오른쪽 버튼은 사용할수 없습니다.');
      alert('<%=g.getMessage("MSG.F.F41.0006")%>');

   return false;
    }
  }

 function keypressed() {
      //alert('키를 사용할 수 없습니다.');
       return false;
  }

  document.onmousedown=click;
  document.onkeydown=keypressed;

  $(function() {
		$('.listTab').find('tr').each(function(i,val){

			$(val).find('td').each(function(j,val2){
				var title = $(val2).html();
				if(title == "OFF" || title == "OFFH"){
					$(val2).css("color", "red");
				}
			});

			$(val).find('th').each(function(j,val2){
				if($(val2).attr("class") != ""){
					var tdClass = $(val2).attr("class").split(" ");
    				var tdId = tdClass[1];
//     				$("."+tdId).addClass("td11");
    				$(".td_"+tdId).css({'color':'red'});
				}
			});

		});
	});
//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">

<div class="winPop">

<%
	if ( T_EXPORTA != null && T_EXPORTA.size() > 0 ) {
        //타이틀 사이즈.
        int titlSize = T_EXPORTA.size();

%>


<!--   <div class="header"> -->
<%--     <span><!-- 근무계획표 --><%=g.getMessage("LABEL.D.D40.0029")%></span> --%>
<%--     <a href="" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a> --%>
<!--   </div> -->




		<div class="listArea">
			<div class="listTop">
		  		<span class="listCnt">
		  			<spring:message code="LABEL.D.D12.0081" /><!-- 총 --> <span><%=T_EXPORTB.size() %></span><spring:message code="LABEL.D.D12.0083" /><!-- 건 -->
		  		</span>
		  		<div style="position:relative; display:block; text-align:right; margin-right: 8px;margin-left: 2px;top:8px; ">
		  		<%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %>
		  		</div>
			</div>
			<div class="table">
   				<div class="wideTable">
	      			<table class="listTable listTab">
	      				<thead>
	        			<tr style="border-top:1px solid #dddddd;  font-size: 9px">
<%-- 							<th rowspan="2"><!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%></th> --%>
							<th class="" rowspan="2" colspan="2"><!-- 계획근무--><%=g.getMessage("LABEL.D.D40.0025")%></th>
<%-- 							<th class="" rowspan="2"><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th> --%>
<%
                //타이틀(일자).
				for( int h = 0; h < titlSize; h++ ){
					D40TmSchkzPlanningChartData titleData = (D40TmSchkzPlanningChartData)T_EXPORTA.get(h);
                    String tdColor = "";
                    if (titleData.HOLIDAY.equals("Y")) {
                        tdColor = "td11";
                    }
                    if (titleData.HOLIDAY.equals("X")) {
                        tdColor = "td11 T"+(h+1);
                    }
%>
							<th class='<%=tdColor%>' ><%=titleData.DD%></th>
<%
                }
%>
						</tr>
						<tr style="font-size: 9px">
<%
                //타이틀(요일).
                for( int k = 0; k < titlSize; k++ ){
                	D40TmSchkzPlanningChartData titleData = (D40TmSchkzPlanningChartData)T_EXPORTA.get(k);
                	String tdColor = "";
                    if (titleData.HOLIDAY.equals("Y")) {
                        tdColor = "td11";
                    }
                    if (titleData.HOLIDAY.equals("X")) {
                        tdColor = "td11 T"+(k+1);
                    }
%>
							<th class='<%=tdColor%>'  nowrap><%=titleData.KURZT%></th>
<%
                }//end if


                for( int i = 0; i < T_EXPORTB.size(); i++ ){
                	D40TmSchkzPlanningChartNoteData data = (D40TmSchkzPlanningChartNoteData)T_EXPORTB.get(i);
                    String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해
                    String tr_class = "";
                    if(i%2 == 0){
                        tr_class="oddRow";
                    }else{
                        tr_class="";
                    }

%>
	      				</thead>
	        			<tr class="<%=tr_class%>" style="font-size: 9px">
							<td class="align_left" nowrap><%=data.SCHKZ%></td>
							<td class="align_left" nowrap><%=data.SCHKZ_TX%></td>
							<td class="td_T1"><%=data.T1 %></td>
							<td class="td_T2"><%=data.T2 %></td>
							<td class="td_T3"><%=data.T3 %></td>
							<td class="td_T4"><%=data.T4 %></td>
							<td class="td_T5"><%=data.T5 %></td>
							<td class="td_T6"><%=data.T6 %></td>
							<td class="td_T7"><%=data.T7 %></td>
							<td class="td_T8"><%=data.T8 %></td>
							<td class="td_T9"><%=data.T9 %></td>
							<td class="td_T10"><%=data.T10%></td>
							<td class="td_T11"><%=data.T11%></td>
							<td class="td_T12"><%=data.T12%></td>
							<td class="td_T13"><%=data.T13%></td>
							<td class="td_T14"><%=data.T14%></td>
							<td class="td_T15"><%=data.T15%></td>
							<td class="td_T16"><%=data.T16%></td>
							<td class="td_T17"><%=data.T17%></td>
							<td class="td_T18"><%=data.T18%></td>
							<td class="td_T19"><%=data.T19%></td>
							<td class="td_T20"><%=data.T20%></td>
							<td class="td_T21"><%=data.T21%></td>
							<td class="td_T22"><%=data.T22%></td>
							<td class="td_T23"><%=data.T23%></td>
							<td class="td_T24"><%=data.T24%></td>
							<td class="td_T25"><%=data.T25%></td>
							<td class="td_T26"><%=data.T26%></td>
							<td class="td_T27"><%=data.T27%></td>
							<td class="td_T28"><%=data.T28%></td>
							<% if( titlSize >= 29 ){%><td class='td_T29'><%=data.T29%></td><% } %>
							<% if( titlSize >= 30 ){%><td class='td_T30'><%=data.T30%></td><% } %>
							<% if( titlSize >= 31 ){%><td class='td_T31'><%=data.T31%></td><% } %>
						</tr>
<%
				} //end for...
%>
	      			</table>
				</div>
			</div>
		</div>

		<div class="listArea">
			<div class="listTop">
		  		<span class="listCnt">
		  			<h2 class="subtitle"><spring:message code='LABEL.D.D40.0026'/><!-- 일일근무일정 설명 --></h2>
		  		</span>
			</div>
			<div class="table">
   				<div class="wideTable">
	      			<table class="listTable">
	      				<thead>
	        			<tr>
							<th><!-- 코드--><spring:message code='LABEL.D.D13.0004'/></th>
							<th><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
							<th><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
							<th><!-- 코드--><spring:message code='LABEL.D.D13.0004'/></th>
							<th><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
							<th><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
						</tr>
						</thead>
<%
						if(T_TPROG.size()%2 != 0){
							D40TmSchkzPlanningChartCodeData addDt = new D40TmSchkzPlanningChartCodeData();
							addDt.CODE = "";
							addDt.TEXT = "";
							addDt.DESC = "";
							T_TPROG.addElement(addDt);
						}
						for( int i = 0; i < T_TPROG.size(); i++ ){
							D40TmSchkzPlanningChartCodeData data = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(i);
							String tr_class = "";
		                    if(i%4 == 0){
		                        tr_class="oddRow";
		                    }else{
		                        tr_class="";
		                    }
%>
						<%if(i%2 == 0){ %>
						<tr class="<%=tr_class%>">
							<td><%=data.CODE %></td>
							<td><%=data.TEXT %></td>
							<td><%=data.DESC %></td>
						<%}else{ %>
							<td><%=data.CODE %></td>
							<td><%=data.TEXT %></td>
							<td><%=data.DESC %></td>
						</tr>
						<%} %>

<%
						}
%>

					</table>
				</div>
			</div>
		</div>
		<div style="page-break-before:always"></div>

<%
    }
%>

</div>


</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
