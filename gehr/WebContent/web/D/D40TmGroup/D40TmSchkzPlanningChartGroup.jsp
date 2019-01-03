<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정	-근무계획표 조회(근무조)				*/
/*   Program Name	:   계획근무일정	-근무계획표 조회(근무조)				*/
/*   Program ID		: D40TmSchkzPlanningChartGroup.jsp				*/
/*   Description		: 계획근무일정-근무계획표 조회(근무조)				*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%@ include file="/web/common/commonProcess.jsp" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);

	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자

	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));
	String sMenuCode =  (String)request.getAttribute("sMenuCode");

	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_TPROG    = (Vector)request.getAttribute("T_TPROG");	//일일근무상세설명
	Vector T_EXPORTA    = (Vector)request.getAttribute("T_EXPORTA");	//근무계획표-TITLE
	Vector T_EXPORTB    = (Vector)request.getAttribute("T_EXPORTB");	//근무계획표-DATA

	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜
	String gubun    = (String)request.getAttribute("gubun");		//구분

%>
<jsp:include page="/include/header.jsp" />

<script language="JavaScript">

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

		//엑셀다운로드
		$("#excelDown").click(function(){
			//상단 공통 조회조건
		  	$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
			$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
			$("#searchDeptNm").val(parent.$("#searchDeptNm").val());

			var iSeqno = "";
			if(parent.$("#iSeqno").val() == ""){
				parent.$("#iSeqno option").each(function(){
					if($(this).val() != ""){
						iSeqno += $(this).val()+"-";
					}
				});
				$("#ISEQNO").val(iSeqno.slice(0, -1));
			}else{
				$("#ISEQNO").val( parent.$("#iSeqno").val());
			}
			if(parent.$(':input:radio[name=orgOrTm]:checked').val() == "2"){
				$("#I_SELTAB").val("C");
			}else{
				$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
			}

			$("#I_ACTTY").val("R");
			$("#gubun").val("EXCEL");

			$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmSchkzPlanningChartGroupSV");
		    $("#form1").attr("target", "ifHidden");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();

		});

		//조회
		$("#do_search").click(function(){
			//상단 공통 조회조건
			parent.blockFrame();
			$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
			$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
			$("#searchDeptNm").val(parent.$("#searchDeptNm").val());

			var iSeqno = "";
			if(parent.$("#iSeqno").val() == ""){
				parent.$("#iSeqno option").each(function(){
					if($(this).val() != ""){
						iSeqno += $(this).val()+"-";
					}
				});
				$("#ISEQNO").val(iSeqno.slice(0, -1));
			}else{
				$("#ISEQNO").val( parent.$("#iSeqno").val());
			}
			if(parent.$(':input:radio[name=orgOrTm]:checked').val() == "2"){
				$("#I_SELTAB").val("C");
			}else{
				$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
			}

			var vObj = document.form1;
			$("#I_ACTTY").val("R");
			$("#gubun").val("SEARCH");

			$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmSchkzPlanningChartGroupSV");
		    $("#form1").attr("target", "_self");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();

		});

		//인쇄
		$("#go_Rotationprint").click(function(){

			$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
			$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
			$("#searchDeptNm").val(parent.$("#searchDeptNm").val());
			$("#gubun").val("PRINT");

			var iSeqno = "";
			if(parent.$("#iSeqno").val() == ""){
				parent.$("#iSeqno option").each(function(){
					if($(this).val() != ""){
						iSeqno += $(this).val()+"-";
					}
				});
				$("#ISEQNO").val(iSeqno.slice(0, -1));
			}else{
				$("#ISEQNO").val( parent.$("#iSeqno").val());
			}
			if(parent.$(':input:radio[name=orgOrTm]:checked').val() == "2"){
				$("#I_SELTAB").val("C");
			}else{
				$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
			}

		    var popup = window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1300,height=662,left=0,top=2");
		    popup.focus();
		    $("#form1").attr("action","<%=WebUtil.JspURL%>"+"D/D40TmGroup/common/printFrame_planning_chart_group.jsp");
		    $("#form1").attr("target", "essPrintWindow");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();
		});


		var height = document.body.scrollHeight;
		parent.autoResize(height);
	});

</script>

	<jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value ="Y"/>
        <jsp:param name="help" value="X04Statistics.html'"/>
    </jsp:include>

<form id="form1" name="form1" method="post" onsubmit="return false">
	<input type="hidden" id="orgOrTm" name="orgOrTm" value="">
	<input type="hidden" id="searchDeptNo" name="searchDeptNo" value="">
	<input type="hidden" id="searchDeptNm" name="searchDeptNm" value="">
	<input type="hidden" id="iSeqno" name="iSeqno" value="">
	<input type="hidden" id="ISEQNO" name="ISEQNO" value="">
	<input type="hidden" id="I_SELTAB" name="I_SELTAB" value="">
	<input type="hidden" id="gubun" name="gubun" value="">
	<input type="hidden" id="pageGubun" name="pageGubun" value="">

	<div class="tableInquiry">
		<table>
			<colgroup>
				<col width="10%" /><!-- 현근무일정 조회 기준일 -->
				<col width="15%" /><!-- input -->
				<col width="7%" /><!-- 계획근무 -->
				<col width="10%" /><!--select  -->
                <col /><!--search button  -->
            </colgroup>
            <tr>
                <th>
                    <spring:message code='LABEL.D.D40.0030'/><!--조회시작일 -->
                </th>
                <td>
					<input type="text" id="I_DATUM" class="date" name="I_DATUM" value="<%= WebUtil.printDate(I_DATUM) %>" size="15" >
                </td>
                <th>
                    <spring:message code='LABEL.D.D40.0025'/><!-- 계획근무 -->
                </th>
                <td>
					<select name="I_SCHKZ" id="I_SCHKZ" style="width: 150px;">
						<option value=""><spring:message code='LABEL.COMMON.0024'/><!-- 전체 --></option>
<%
						if ( T_SCHKZ != null && T_SCHKZ.size() > 0 ) {
							for( int j = 0; j < T_SCHKZ.size(); j++ ) {
								D40TmSchkzPlanningChartCodeData vtData = (D40TmSchkzPlanningChartCodeData)T_SCHKZ.get(j);
%>
									<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(I_SCHKZ)){ %> selected <%} %>><%=vtData.CODE%> (<%=vtData.TEXT %>)</option>
<%
							}
						}
%>
						</select>
				</td>
				<td>
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:void();" id="do_search"><span><spring:message code="BUTTON.COMMON.SEARCH"/><!-- 조회 --></span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>
<%
	if ( T_EXPORTA != null && T_EXPORTA.size() > 0 ) {
        //타이틀 사이즈.
        int titlSize = T_EXPORTA.size();

%>

	<h2 class="subtitle withButtons"><%=E_INFO%></h2>
	<div class="buttonArea">
       	<ul class="btn_mdl displayInline">
               <li><a class="search" href="javascript:void(0);" id="excelDown"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
               <li><a class="search" href="javascript:void(0);" id="go_Rotationprint"><span><spring:message code='LABEL.F.F42.0002'/><!-- 인쇄 --></span></a></li>
           </ul>
	</div>

		<div class="listArea">

			<div class="table">
   				<div class="wideTable">
	      			<table class="listTable listTab">
	        			<tr>
							<th class="" rowspan="2" colspan="2"><!-- 계획근무--><spring:message code='LABEL.D.D40.0025'/></th>
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
							<th class='<%=tdColor%>'><%=titleData.DD%></th>
<%
                }//end for 타이틀(일자)
%>
						</tr>
						<tr>
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
                }//end for 타이틀(요일).

                for( int i = 0; i < T_EXPORTB.size(); i++ ){
                	D40TmSchkzPlanningChartNoteData data = (D40TmSchkzPlanningChartNoteData)T_EXPORTB.get(i);
                    String tr_class = "";
                    if(i%2 == 0){
                        tr_class="oddRow";
                    }else{
                        tr_class="";
                    }

%>
	        			<tr class="<%=tr_class%>">
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
				} //end for... 내용.
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
						}//end for... 일일근무일정
%>

					</table>
				</div>
			</div>
		</div>


<%
    }else{
%>
	<div class="listArea">
        <div class="table">
	        <div class="wideTable" >
	            <table class="listTable">
	    			 <tr>
	    			 	<td class="lastCol"><spring:message code="MSG.COMMON.0004"/></td><!-- 해당하는 데이타가 존재하지 않습니다 -->
	    			 </tr>
	            </table>
	        </div>
        </div>
    </div>
<%
    } //end if...
%>
</form>

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
