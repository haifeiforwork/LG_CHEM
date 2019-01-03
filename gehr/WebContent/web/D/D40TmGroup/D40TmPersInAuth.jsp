<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   조직관리													*/
/*   2Depth Name		:   조직/인원현황 - 근태현황								*/
/*   Program Name	:   부서근태담당자											*/
/*   Program ID		: D40TmPersInAuth.jsp									*/
/*   Description		: 부서근태담당자											*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%@ include file="/web/common/commonProcess.jsp" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);

	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"),"");  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"),"");  				//부서명
	String chck_yeno =  WebUtil.nvl(request.getParameter("chck_yeno"),"");

	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜

	Vector dataList = (Vector)request.getAttribute("T_EXLIST");	//리스트데이터

%>
<jsp:include page="/include/header.jsp" />

<script language="JavaScript">
<!--

	function do_search(){
		parent.blockFrame();
		var vObj = document.form1;
	    vObj.target = "_self";
	    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmPersInAuthSV";
	    vObj.method = "post";
	    vObj.submit();

	}

	function setDeptID(deptId, deptNm){

		$("#hdn_deptId").val(deptId);
		$("#hdn_deptNm").val(deptNm);

		do_search();
	}


	$(function() {

		$("#I_DATUM").change(function(){
			do_search();
		});
		var height = document.body.scrollHeight;
		parent.autoResize(height);
	});
	//-->
</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<form name="form1" method="post" onsubmit="return false">
	<input type="hidden" id="hdn_deptId" name="hdn_deptId"  value="<%=deptId%>">
	<input type="hidden" id="hdn_deptNm" name="hdn_deptNm"  value="<%=deptNm%>">
	<input type="hidden" id="chck_yeno" name="chck_yeno"  value="<%=chck_yeno%>">

	<h2 class="subtitle"><!--  부서명--><spring:message code='LABEL.D.D15.0146'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
	<div class="listArea">
		<div class="listTop">
			<span class="listCnt"><spring:message code="LABEL.D.D12.0081" /><!-- 총 --> <span><%=dataList.size() %></span><spring:message code="LABEL.D.D12.0083" /><!-- 건 --></span>
			<div class="buttonArea">
				<spring:message code='LABEL.D.D40.0031'/> : <!-- 기준일 --> <input type="text" id="I_DATUM" class="date" name="I_DATUM" value="<%= WebUtil.printDate(I_DATUM) %>" size="15" >
			</div>
			<div class="clear"> </div>
		</div>

		<div class="table">
			<div class="wideTable" >
				<table class="listTable" >
					<colgroup>
						<col width="8%" />
						<col width="34%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
						<col width="34%" />
					</colgroup>
					<thead>
					<tr>
						<th><!-- 조직약어--><spring:message code='LABEL.D.D40.0154'/></th>
						<th><!-- 조직--><spring:message code='LABEL.D.D40.0155'/></th>
						<th><!-- 하위조직포함여부--><spring:message code='LABEL.D.D40.0156'/></th>
						<th><!-- 담당자사번--><spring:message code='LABEL.D.D40.0157'/></th>
						<th><!-- 담당자성명--><spring:message code='LABEL.D.D40.0158'/></th>
						<th><!-- 담당자소속--><spring:message code='LABEL.D.D40.0159'/></th>
					</tr>
					</thead>
					<tbody>

<%
			if( dataList != null && dataList.size() > 0 ){
				for( int i = 0; i < dataList.size(); i++ ) {
					D40TmPersInAuthData data = (D40TmPersInAuthData)dataList.get(i);
%>
						<tr class="<%= WebUtil.printOddRow(i) %>">
							<td><%= data.SHORT %></td>
							<td><%= data.DORGEH_TX %></td>
							<td><%= data.SINCLUDE %></td>
							<td><%= data.APERNR %></td>
							<td><%= data.ENAME %></td>
							<td><%= data.ORGEH_TX %></td>
						</tr>
<%
			} //end for
		}else{

%>
						<tr class="oddRow">
							<td class="lastCol" colspan="6"><spring:message code="MSG.COMMON.0004"/></td>
						</tr>
<%
		}//end if
%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</form>

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
