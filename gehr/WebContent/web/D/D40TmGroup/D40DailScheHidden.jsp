<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   일일근무일정												*/
/*   Program Name	:   입력 필드 조회											*/
/*   Program ID		: D40DailScheHidden.jsp								*/
/*   Description		: 입력 필드 조회												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
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
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//조회된 내용
	String searchPERNR    = (String)request.getParameter("searchPERNR");
%>

<form name="form1">
</form>
<script>
<%
	if(!vt1.isEmpty()){
		D40DailScheFrameData getData = (D40DailScheFrameData)vt1.get(0);
%>
		if('<%=E_RETURN%>' == "S"){

			if('<%=getData.MSG%>' != ""){
				alert('<%=getData.MSG%>');
				parent.$("#CHKDT<%=no%>").val('X');
				parent.$("#MSG<%=no%>").val('<%=getData.MSG%>');
			}else{
				parent.$("#CHKDT<%=no%>").val('Y');
				parent.$("#MSG<%=no%>").val('');
			}

			parent.$("#ENAME"+<%=no%>).val('<%=getData.ENAME%>');
			parent.$("#td_ENAME"+<%=no%>).text('<%=getData.ENAME%>');
			parent.$("#EDIT"+<%=no%>).val('<%=getData.EDIT%>');
			if('<%=getData.EDIT%>' != "X"){
				parent.$("#TPROG<%=no%>").attr('disabled', true);
			}else{
				parent.$("#TPROG<%=no%>").attr('disabled', false);
			}
			parent.parent.$.unblockUI();
		}else{
			alert('<%=getData.MSG%>');
			parent.$("#CHKDT<%=no%>").val('X');
			parent.$("#MSG<%=no%>").val('<%=getData.MSG%>');
			parent.parent.$.unblockUI();
		}

<%
	}else{
%>
		alert('<spring:message code="LABEL.D.D05.0005"/> '+ "'<%=searchPERNR%>'"+'<spring:message code="MSG.D.D40.0038"/>');
		parent.$("#ENAME"+<%=no%>).val('');
		parent.parent.$.unblockUI();

<%
	}
%>
</script>