<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태그룹관리												*/
/*   Program Name	:   근태그룹 인원 지정										*/
/*   Program ID		: D40TmGroupPers.jsp									*/
/*   Description		: 근태그룹 인원 지정										*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%@ include file="/web/common/popupPorcess.jsp" %>
<%

	WebUserData user = (WebUserData)session.getAttribute("user");
	String gubun = WebUtil.nvl(request.getParameter("gubun"));
	String paramSEQNO = WebUtil.nvl(request.getParameter("paramSEQNO"));
	String paramTIME_GRUP = WebUtil.nvl(request.getParameter("paramTIME_GRUP"));
	String paramBEGDA = WebUtil.nvl(request.getParameter("paramBEGDA"));
	String paramPABRJ = WebUtil.nvl(request.getParameter("I_PABRJ"));
	String paramPABRP = WebUtil.nvl(request.getParameter("I_PABRP"));
	String I_SEQNO = WebUtil.nvl(request.getParameter("I_SEQNO"));
	String cnt = WebUtil.nvl(request.getParameter("cnt"));
	Vector vt    = (Vector)request.getAttribute("vt");

%>

<jsp:include page="/include/header.jsp" />

<script language="JavaScript">
	var rowindex = '<%=vt.size()%>';

	function spernr_search(){
		rowindex = $("input[name=chkbutton]:checkbox").length;
		$("#returnGubun").val("ALL");
		$("#form1").attr("action","<%=WebUtil.JspURL%>D/D40TmGroup/D40OrganListHiddenPop.jsp");
		$("#form1").attr("target", "ifHidden");
	    $("#form1").attr("method", "post");
	    $("#form1").submit();
	}

	function saveBlockFrame() {
        $.blockUI({ message : '<spring:message code="MSG.D.D40.0001"/>' });
    }

	$(function() {

		//목록
		$("#do_list").click(function(){
			$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmGroupFrameSV");
		    $("#form1").attr("target", "_self");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();
		});

		//사원검색 Popup.
		$("#organ_search").click(function(){

			var small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=1030,height=580,left=100,top=100");
		    small_window.focus();
		    $("#pageGubun").val("A");

		    $("#form1").attr("action","<%=WebUtil.JspURL%>"+"D/D40TmGroup/D40OrganListFramePop.jsp");
		    $("#form1").attr("target", "Organ");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();
		});

		//저장
		$("#do_save, #save").click(function(){
			saveBlockFrame();
			$("#gubun").val("SAVE");
			$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmGroupFramePersSV");
		    $("#form1").attr("target", "_self");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();

		});

		//엑셀다운로드
		$("#excelDown").click(function(){
			$("#gubun").val("EXCEL");
			$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmGroupFramePersSV");
		    $("#form1").attr("target", "ifHidden");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();
		});

		//행삭제
		$("#deleteRow").click(function(){
			$("input[name=chkbutton]:checked").each(function() {
				$("#tr"+$(this).val()).remove();
			});
		});


	});


</script>

<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D40.0011"/>
</jsp:include>

	<form id="form1" name="form1" method="post" action="">
		<input type="hidden" id="pop_SPERNR" name="pop_SPERNR">
		<input type="hidden" id="pop_SPERNR_TX" name="pop_SPERNR_TX">
		<input type="hidden" id="pop_ORGEH_TX" name="pop_ORGEH_TX">
		<input type="hidden" id="pageGubun" name="pageGubun">
		<input type="hidden" id="returnGubun" name="returnGubun">
		<input type="hidden" id="rowindex" name="rowindex">
		<input type="hidden" id="rowcount" name="rowcount" value="<%=vt.size()%>">
		<input type="hidden" id="gubun" name="gubun">
		<input type="hidden" id="deptNo" name="deptNo">
		<input type="hidden" id="I_SELTAB" name="I_SELTAB">
		<input type="hidden" id="I_ENAME" name="I_ENAME">
		<input type="hidden" id="I_PERNR" name="I_PERNR">

		<input type="hidden" id="paramSEQNO" name="paramSEQNO" value="<%=paramSEQNO%>">
		<input type="hidden" id="paramTIME_GRUP" name="paramTIME_GRUP" value="<%=paramTIME_GRUP%>">
		<input type="hidden" id="paramBEGDA" name="paramBEGDA" value="<%=paramBEGDA%>">
		<input type="hidden" id="I_PABRJ" name="I_PABRJ" value="<%=paramPABRJ%>">
		<input type="hidden" id="I_PABRP" name="I_PABRP" value="<%=paramPABRP%>">
		<input type="hidden" id="I_SEQNO" name="I_SEQNO" value="<%=I_SEQNO%>">

		<div class="tableArea">
		    <!-- 개인 인적사항 조회 -->
		    <div class="table">
		        <table border="0" cellspacing="0" cellpadding="0" class="tableGeneral">
					<colgroup>
				      	<col width=15%/>
				      	<col width=25%/>
				      	<col width=15%/>
				      	<col width=15%/>
				      	<col width=15%/>
				      	<col width=15%/>
			      	</colgroup>
					<tr>
			        	<th style="text-align: center;"><spring:message code="LABEL.D.D40.0004" /><!-- 근태그룹 --></th>
			          	<td><%=paramTIME_GRUP%></td>
			          	<th style="text-align: center;"><spring:message code="LABEL.D.D40.0016" /><!-- 입력자 --></th>
			          	<td><%=user.ename %></td>
			          	<th style="text-align: center;"><spring:message code="LABEL.D.D40.0006" /><!-- 적용일자 --></th>
			          	<td><%=paramBEGDA %></td>
			        </tr>
			    </table>
			</div>
		</div>

		<div class="listArea">
	 		<div class="listTop">
	 		<span class="listCnt"><spring:message code="LABEL.D.D12.0081" /><!-- 총 --> <span><%=vt.size() %></span><spring:message code="LABEL.D.D12.0083" /><!-- 건 --></span>
	           	<div class="buttonArea">
	                <ul class="btn_mdl displayInline" style="margin-left: 10px;">
	                    <li><a class="search" href="javascript:void(0);" id="organ_search"><span><spring:message code="BUTTON.D.D40.0003" /><%-- 인원추가 --%></span></a></li>
	                    <li><a class="search" href="javascript:void(0);" id="deleteRow"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><%-- 행삭제 --%></span></a></li>
	                    <li><a class="search" href="javascript:void(0);" id="excelDown"><span><spring:message code="BUTTON.D.D40.0002" /><%-- 엑셀다운로드 --%></span></a></li>
	                	<li><a class="darken" href="javascript:void(0);" id="do_save"><span><spring:message code="BUTTON.COMMON.SAVE" /><!-- 저장 --></span></a></li>
	                </ul>
	           	</div>
	       	</div>
			<div class="table" >
 				<table class="listTable" id="tmGroupTable" >
 			   		<colgroup>
				      	<col width=6%/>
				      	<col width=8%/>
				      	<col width=8%/>
				      	<col width=10%/>
				      	<col width=22%/>
				      	<col width=22%/>
				      	<col width=10%/>
				      	<col width=10%/>
			      	</colgroup>
 			   		<thead>
	      				<tr>
		        			<th><spring:message code='LABEL.D.D11.0047' /><!-- 선택 --></th>
		         			<th><spring:message code='LABEL.D.D12.0017' /><!-- 사번 --></th>
		         			<th><spring:message code='LABEL.D.D12.0018' /><!-- 이름 --></th>
		         			<th><spring:message code='LABEL.D.D40.0012' /><!-- 지정일자 --></th>
		         			<th style="display: none;"><spring:message code='LABEL.D.D12.0051' /><!-- 부서 --></th>
		         			<th class="lastCol"><spring:message code="LABEL.COMMON.0029"/><%--소속--%></th>
		         			<th style="display: none;"><spring:message code='LABEL.D.D40.0014' /><!-- 현부서일자 --></th>
		        			<th style="display: none;" class="lastCol"><spring:message code='LABEL.D.D40.0015' /><!-- 퇴직일자 --></th>
	      				</tr>
      				</thead>
<%
					if( vt != null && vt.size() > 0 ){
						for( int i = 0; i < vt.size(); i++ ) {
							D40TmGroupPersData data = (D40TmGroupPersData)vt.get(i);
					        String tr_class = "";
					        if(i%2 == 0){
					            tr_class="oddRow";
					        }else{
					            tr_class="";
					        }
%>
						<tr class="<%=tr_class%>" id="tr<%=i%>">
					    	<td>
					      		<input type="checkbox" id="chkbutton<%=i%>" name="chkbutton" class="chkbox" value="<%=i%>">
					      		<input type="hidden" id="SPERNR<%=i%>" name="SPERNR" value="<%=data.SPERNR%>" maxlength="8"><!-- 사번 -->
<%-- 					      			<input type="hidden" id="SORGEH" name="SORGEH" value="<%=WebUtil.printString( data.SORGEH )%>" ><!-- 생성시 소속부서 코드 --> --%>
<%-- 					      			<input type="hidden" id="PERSG" name="PERSG" value="<%=WebUtil.printString( data.PERSG )%>" ><!-- 구분코드 --> --%>
<%-- 					      			<input type="hidden" id="PERSG_TX" name="PERSG_TX" value="<%=WebUtil.printString( data.PERSG_TX )%>" ><!-- 구분텍스트 --> --%>
<%-- 					      			<input type="hidden" id="PERSG_DT" name="PERSG_DT" value="<%=WebUtil.printString( data.PERSG_DT )%>" ><!-- 구분일자 --> --%>
<%-- 					      			<input type="hidden" id="AEZET" name="AEZET" value="<%=WebUtil.printString( data.AEZET )%>" ><!-- 최종변경시간 --> --%>
<%-- 					      			<input type="hidden" id="UNAME" name="UNAME" value="<%=WebUtil.printString( data.UNAME )%>" ><!-- 사용자이름 --> --%>
					      	</td>
					      	<td id="SPERNR<%=i%>">
					      		<%=WebUtil.printString( data.SPERNR )%>
					      	</td>
					      	<td id="SPERNR_TX<%=i%>">
					      		<%=WebUtil.printString( data.SPERNR_TX )%>
<%-- 					     			<input type="hidden" id="SPERNR_TX" name="SPERNR_TX" value="<%=WebUtil.printString( data.SPERNR_TX )%>" ><!--이름  --> --%>
					      	</td>
					      	<td>
					      		<%=WebUtil.printString( data.OBEGDA ).replace("-",".")%>
<%-- 					      			<input type="hidden" id="OBEGDA" name="OBEGDA" value="<%=WebUtil.printString( data.OBEGDA ).replace("-","")%>" ><!-- 지정일자 --> --%>
					      	</td>
					      	<td style="display: none;">
					      		<%=WebUtil.printString( data.SORGEH_TX )%>
<%-- 					      			<input type="hidden" id="SORGEH_TX" name="SORGEH_TX" value="<%=WebUtil.printString( data.SORGEH_TX )%>"  ><!-- 부서 --> --%>
					      	</td>
					      	<td id="ORGEH_TX<%=i%>" class="lastCol">
					      		<%=WebUtil.printString( data.ORGEH_TX )%>
<%-- 					     			<input type="hidden" id="ORGEH_TX" name="ORGEH_TX" value="<%=WebUtil.printString( data.ORGEH_TX )%>" ><!-- 현부서 --> --%>
					      	</td>
					      	<td style="display: none;">
					      		<%
					     			if(!"0000-00-00".equals(data.ORGEH_DT)){
					     		%>
					     			<%=WebUtil.printString( data.ORGEH_DT ).replace("-",".")%>
					     		<%
					     			}
					     		%>
<%-- 					      		<%=WebUtil.printString( data.ORGEH_DT ).replace("-",".")%> --%>
<%-- 					      			<input type="hidden" id="ORGEH_DT" name="ORGEH_DT" value="<%=WebUtil.printString( data.ORGEH_DT ).replace("-","")%>"  ><!-- 현부서일자 --> --%>
					      	</td>
					     	<td style="display: none;" class="lastCol">
					     		<%
					     			if(!"0000-00-00".equals(data.PERSG_DT)){
					     		%>
					     			<%=WebUtil.printString( data.PERSG_DT ).replace("-",".")%>
					     		<%
					     			}
					     		%>
<%-- 					     		<%=WebUtil.printString( data.PERSG_DT ).replace("-",".")%> --%>
<%-- 					    			<input type="hidden" id="AEDTM" name="AEDTM" value="<%=WebUtil.printString( data.AEDTM ).replace("-","")%>" ><!-- 퇴직일자 --> --%>
					     	</td>
			     		</tr>
<%
			} //end for
		}
%>

      					</table>
      				</div>
      			</div>


    			<div class="buttonArea">
			        <ul class="btn_crud">
			            <li><a class="darken" href="javascript:void(0);" id="save"><span><!-- 저장 --><%=g.getMessage("BUTTON.COMMON.SAVE")%></span></a></li>
			            <li><a class="search" href="javascript:void(0);" id="do_list"><span><!-- 목록 --><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
			        </ul>
			    </div>
		</form>
		<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
