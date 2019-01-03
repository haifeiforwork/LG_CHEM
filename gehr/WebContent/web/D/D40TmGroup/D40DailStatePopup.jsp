<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
/******************************************************************************/
/*																								*/
/*   System Name  : MSS																*/
/*   1Depth Name  : 근태집계표                                                        			*/
/*   2Depth Name  : 일간근태집계표 - 상세 팝업 									*/
/*   Program Name : 근태그룹인원지정 팝업                                                 	*/
/*   Program ID   : D40DailStatePopup.jsp                               			*/
/*   Description  : 근태그룹인원지정 PopUp                                         */
/*   Note         :                                                         					*/
/*   Creation     : 2017-12-08  정준현                                          				*/
/*   Update       :                                                             			*/
/*                                                                              				*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileNotFoundException" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>

<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.ss.usermodel.Cell" %>
<%@ page import="org.apache.poi.ss.usermodel.CellStyle" %>
<%@ page import="org.apache.poi.ss.usermodel.Font" %>
<%@ page import="org.apache.poi.ss.usermodel.Row" %>
<%@ page import="org.apache.poi.ss.usermodel.Sheet" %>
<%@ page import="org.apache.poi.ss.usermodel.Workbook" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>

<%@ include file="/web/common/popupPorcess.jsp" %>
<%

	WebUserData user = (WebUserData)session.getAttribute("user");
	String gubun = WebUtil.nvl(request.getParameter("gubun"));
	String emp = WebUtil.nvl(request.getParameter("emp"));
	String dt = WebUtil.nvl(request.getParameter("dt"));

	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	String I_BEGDA    = (String)request.getAttribute("I_BEGDA");	//시작일
	String I_ENDDA    = (String)request.getAttribute("I_ENDDA");	//종료일
	String E_ENAME    = (String)request.getAttribute("E_ENAME");	//이름
	String I_PERNR    = (String)request.getAttribute("I_PERNR");	//사번
	Vector T_EXLIST    = (Vector)request.getAttribute("T_EXLIST");	//계획근무

%>

<jsp:include page="/include/header.jsp" />

<script>

	function closePop(){
		self.close();
	}

</script>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
	<form name="form1" method="post" action="">


		<div class="winPop">
			<div class="header">
		    	<span><spring:message code="LABEL.D.D40.0060"/> <%--일일근태 입력 현황--%></span>
		    	<a href="javascript:closePop()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
		    </div>

			<div class="body">

				<div class="tableArea" >
	    			<div class="table">
	      				<table class="tableGeneral">
				      	<colgroup>
					      	<col width=15%/>
					      	<col width=18%/>
					      	<col width=15%/>
					      	<col width=18%/>
					      	<col width=15%/>
					      	<col width=19%/>
				      	</colgroup>
						<tr>
				        	<th style="text-align: center;"><spring:message code="LABEL.D.D12.0017"/></th><!-- 근태그룹 -->
				          	<td><%=I_PERNR%></td>
				          	<th style="text-align: center;"><spring:message code="LABEL.D.D11.0005"/></th><!--이름  -->
				          	<td><%=E_ENAME %></td>
				          	<th style="text-align: center;"><spring:message code="LABEL.D.D14.0003"/></th><!-- 조회일자 -->
				          	<td><%=I_BEGDA.replace("-",".") %></td>
				        </tr>
				      	</table>
					</div>
				</div>

    			<div class="listArea">
    				<div class="listTop">
    					<span class="listCnt"><spring:message code="LABEL.D.D40.0061"/><!-- 근태평가결과와 입력현황은 시점차이로 상이할 수 있습니다. --></span>
		        	</div>
    				<div class="table" style="overflow-x:hidden; overflow-y:auto; width: 990px; height: 340px;">
      					<table class="listTable" id="tmGroupTable" style="width: 990px">
      			   			<colgroup>
						      	<col width=4%/>
						      	<col width=13%/>
						      	<col width=6%/>
						      	<col width=6%/>
						      	<col width=5%/>
						      	<col width=5%/>
						      	<col width=5%/>
						      	<col width=5%/>
						      	<col width=5%/>
						      	<col width=5%/>
						      	<col width=5%/>
						      	<col width=12%/>
						      	<col width=12%/>
						      	<col width=6%/>
						      	<col width=6%/>
					      	</colgroup>
      			   			<thead>
			        		<tr>
			          			<th><spring:message code='LABEL.D.D02.0003' /><!-- 구분 --></th>
			           			<th><spring:message code='LABEL.D.D40.0052' /><!-- 유형 --></th>
			           			<th><!-- 시작일--><spring:message code="LABEL.D.D15.0152"/></th>
								<th><!-- 종료일--><spring:message code="LABEL.D.D15.0153"/></th>
			           			<th><!-- 시작시간--><spring:message code="LABEL.D.D12.0020"/></th>
								<th><!-- 종료시간--><spring:message code="LABEL.D.D12.0021"/></th>
								<th><!-- 휴식시간1--><spring:message code="LABEL.D.D12.0068"/></th>
								<th><!-- 휴식종료1--><spring:message code="LABEL.D.D12.0069"/></th>
								<th><!-- 휴식시간2--><spring:message code="LABEL.D.D12.0070"/></th>
								<th><!-- 휴식종료2--><spring:message code="LABEL.D.D12.0071"/></th>
								<th><!-- 근무시간 수--><spring:message code="LABEL.D.D40.0124"/></th>
								<th><!-- 사유--><spring:message code="LABEL.D.D12.0024"/></th>
								<th><!-- 상세사유--><spring:message code="LABEL.D.D40.0053"/></th>
								<th><!-- 최종변경일--><spring:message code="LABEL.D.D40.0054"/></th>
			          			<th class="lastCol"><spring:message code="LABEL.D.D40.0055"/><!-- 최종변경자 --></th>
			        		</tr>
			        		</thead>
<%

					if( T_EXLIST != null && T_EXLIST.size() > 0 ){
						for( int i = 0; i < T_EXLIST.size(); i++ ) {
							D40DailStatePopupData data = (D40DailStatePopupData)T_EXLIST.get(i);
					        String tr_class = "";
					        if(i%2 == 0){
					            tr_class="oddRow";
					        }else{
					            tr_class="";
					        }

					        String BEGUZ = "";
							if(!"".equals(data.BEGUZ)){
								if(data.BEGUZ.length() > 3){
									String bun = (!"24".equals(data.BEGUZ.substring(0,2)))?data.BEGUZ.substring(0,2):"00";
									BEGUZ = bun+":"+data.BEGUZ.substring(2,4);
								}
							}
							String ENDUZ = "";
							if(!"".equals(data.ENDUZ)){
								if(data.ENDUZ.length() > 3){
									String bun = (!"24".equals(data.ENDUZ.substring(0,2)))?data.ENDUZ.substring(0,2):"00";
									ENDUZ = bun+":"+data.ENDUZ.substring(2,4);
								}
							}
							String PBEG1 = "";
							if(!"".equals(data.PBEG1)){
								if(data.PBEG1.length() > 3){
									String bun = (!"24".equals(data.PBEG1.substring(0,2)))?data.PBEG1.substring(0,2):"00";
									PBEG1 = bun+":"+data.PBEG1.substring(2,4);
								}
							}
							String PEND1 = "";
							if(!"".equals(data.PEND1)){
								if(data.PEND1.length() > 3){
									String bun = (!"24".equals(data.PEND1.substring(0,2)))?data.PEND1.substring(0,2):"00";
									PEND1 = bun+":"+data.PEND1.substring(2,4);
								}
							}
							String PBEG2 = "";
							if(!"".equals(data.PBEG2)){
								if(data.PBEG2.length() > 3){
									String bun = (!"24".equals(data.PBEG2.substring(0,2)))?data.PBEG2.substring(0,2):"00";
									PBEG2 = bun+":"+data.PBEG2.substring(2,4);
								}
							}
							String PEND2 = "";
							if(!"".equals(data.PEND2)){
								if(data.PEND2.length() > 3){
									String bun = (!"24".equals(data.PEND2.substring(0,2)))?data.PEND2.substring(0,2):"00";
									PEND2 = bun+":"+data.PEND2.substring(2,4);
								}
							}
%>
							<tr class="<%=tr_class%>">
					      		<td>
									<%=i+1 %>
					      		</td>
					      		<td style="text-align: left;">
					      			<%= data.WTMCODE_TX%><!-- 유형 -->
					      		</td>
					      		<td>
					      			<%if(!"0000-00-00".equals(data.BEGDA)){ %>
				                  		<%=data.BEGDA.replace("-",".") %>	<!--시작일  -->
				                  	<%} %>
					      		</td>
					      		<td>
					      			<%if(!"0000-00-00".equals(data.ENDDA)){ %>
				                  		<%=data.ENDDA.replace("-",".") %>	<!--종료일  -->
				                  	<%} %>
					      		</td>
					      		<td>
					      			<%= BEGUZ%><!-- 시작시간 -->
					      		</td>
					      		<td>
					      			<%= ENDUZ%><!-- 종료시간 -->
					      		</td>
					      		<td>
					      			<%= PBEG1%><!-- 휴식1시작시간 -->
					      		</td>
					      		<td>
					      			<%= PEND1%><!-- 휴식1종료시간 -->
					      		</td>
					      		<td>
					      			<%= PBEG2%><!-- 휴식2시작시간 -->
					      		</td>
					      		<td>
					      			<%= PEND2%><!-- 휴식2종료시간 -->
					      		</td>
					      		<td>
					      			<%if(!"0".equals(data.STDAZ)){ %>
				                		<%=data.STDAZ%>		<!-- 근무시간 수 -->
				                	<%}else{ %>
				                		-
				                	<%} %>
					      		</td>
					      		<td  style="text-align: left;">
					      			<%= data.REASON_TX%>	<!-- 근태사유 -->
					      		</td>
					      		<td  style="text-align: left;">
					      			<%= data.DETAIL%>	<!-- 상세사유 -->
					      		</td>
					      		<td>
					      			<%if(!"0000-00-00".equals(data.AEDTM_TX)){ %>
				                  		<%=data.AEDTM_TX.replace("-",".") %> <!-- 최종변경일 -->
				                  	<%} %>
					      		</td>
					     		<td class="lastCol">
					     			<%= data.UNAME_TX%><!-- 최종변경자 -->
					     		</td>
			     			</tr>
<%
			} //end for
		}else{
%>
							<tr>
								<td colspan="15"><spring:message code="MSG.COMMON.0004"/></td><!-- 해당하는 데이타가 존재하지 않습니다. -->
							</tr>
<%
		}
%>
      					</table>
      				</div>
      			</div>
    			<ul class="btn_crud close">
    				<li><a href="javascript:closePop()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a>
    			</ul>
    		</div>
		</div>
	</form>
<iframe name="ifHidden" width="0" height="0" /></iframe>
</body>
