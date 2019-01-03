<%--
/********************************************************************************/
/*																				*/
/*   System Name	: MSS														*/
/*   1Depth Name	: 부서근태													*/
/*   2Depth Name	: 초과근무													*/
/*   Program Name	: 초과근무(개별)	 행추가 검색									*/
/*   Program ID		: D40OverTimeEachHidden.	jsp								*/
/*   Description	: 초과근무(개별) 행추가 검색									*/
/*   Note			:             												*/
/*   Creation		: 2017-12-08  정준현                                          		*/
/*   Update			: 2017-12-08  정준현                                          		*/
/*   				: 2018-06-18  성환희 [Worktime52]                            */
/*                                                                              */
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Map" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

	Vector vt1    = (Vector)request.getAttribute("OBJPS_OUT1");	//조회된 내용
	String no    = (String)request.getAttribute("no");	//조회된 내용
%>

<form name="form1">
</form>
<script>
<%
	if(vt1 != null){
		D40OverTimeFrameData getData = (D40OverTimeFrameData)vt1.get(0);
%>
		if('<%=getData.MSG%>' != ""){
			alert('<%=getData.MSG%>');
			parent.$("#CHKDT<%=no%>").val('X');
			parent.$("#MSG<%=no%>").val('<%=getData.MSG%>');
		}else{
			parent.$("#CHKDT<%=no%>").val('Y');
			parent.$("#MSG<%=no%>").val('');
		}
		var select = parent.selectList('<%=no%>', '<%=getData.PKEY%>');

		parent.$("#WWKTM"+<%=no%>).val('<%=getData.WWKTM%>');

		parent.$("#EDIT"+<%=no%>).val('<%=getData.EDIT%>');

		parent.$("#ENAME<%=no%>").val('<%=getData.ENAME%>');
		parent.$("#td_ENAME<%=no%>").text('<%=getData.ENAME%>');
		parent.$("#td_WWKTM<%=no%>").text('<%=getData.WWKTM%>');

		parent.$("#TPROG<%=no%>").val('<%=getData.TPROG%>');
		parent.$("#td_TPROG<%=no%>").html('<%=getData.TPROG%>');

		parent.$("#REASON_YN<%=no%>").val('<%=getData.REASON_YN%>');
		parent.$("#REASON<%=no%>").html(select);
		if('<%=getData.REASON_YN%>' != "Y"){
			parent.$("#REASON<%=no%>").attr('disabled', true);
			var reaHidden = '<input type=hidden id="REASON<%=no%>" name="REASON"  value="<%=getData.REASON%>" >';
			parent.$("#td_REASON<%=no%>").html(reaHidden);
		}else{
			parent.$("#REASON<%=no%>").attr('disabled', false);
			parent.$("#td_REASON<%=no%>").html("");
		}

		parent.$("#DETAIL_YN<%=no%>").val('<%=getData.DETAIL_YN%>');
		if('<%=getData.DETAIL_YN%>' != "Y"){
			parent.$("#DETAIL<%=no%>").attr('disabled', true);
			var detHidden = '<input type=hidden id="DETAIL<%=no%>" name="DETAIL"  value="<%=getData.DETAIL%>" >';
			parent.$("#td_DETAIL<%=no%>").html(detHidden);
		}else{
			parent.$("#DETAIL<%=no%>").attr('disabled', false);
			parent.$("#td_DETAIL<%=no%>").html("");
		}

		parent.parent.$.unblockUI();

<%
	}
%>

</script>