<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   비근무/근무												*/
/*   Program Name	:   입력 필드 조회											*/
/*   Program ID		: D40AbscTimeExcelDown.jsp							*/
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
	String searchWTMCODE    = (String)request.getParameter("searchWTMCODE");
%>

<form name="form1">
</form>
<script>
<%
	if(vt1 != null){
		D40AbscTimeFrameData getData = (D40AbscTimeFrameData)vt1.get(0);
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

			parent.$("#REASON_YN"+<%=no%>).val('<%=getData.REASON_YN%>');
			var select = parent.selectSearchList('<%=no%>', '<%=searchWTMCODE%>', '<%=getData.REASON%>');
			parent.$("#REASON<%=no%>").html(select);
			if('<%=getData.REASON_YN%>' != "Y"){
				parent.$("#REASON<%=no%>").attr('disabled', true);
				var reaHidden = '<input type=hidden id="REASON<%=no%>" name="REASON"  value="<%=getData.REASON%>" >';
				parent.$("#td_REASON<%=no%>").html(reaHidden);
			}else{
				parent.$("#REASON<%=no%>").attr('disabled', false);
				parent.$("#td_REASON<%=no%>").html("");
			}

			parent.$("#DETAIL_YN"+<%=no%>).val('<%=getData.DETAIL_YN%>');
			parent.$("#DETAIL<%=no%>").val("");
			if('<%=getData.DETAIL_YN%>' != "Y"){
				parent.$("#DETAIL<%=no%>").attr('disabled', true);
				var detHidden = '<input type=hidden id="DETAIL<%=no%>" name="DETAIL"  value="<%=getData.DETAIL%>" >';
				parent.$("#td_DETAIL<%=no%>").html(detHidden);
			}else{
				parent.$("#DETAIL<%=no%>").attr('disabled', false);
				parent.$("#td_DETAIL<%=no%>").html("");
			}

			parent.$("#TIME_YN"+<%=no%>).val('<%=getData.TIME_YN%>');
			parent.$("#BEGUZ<%=no%>").val("");
			parent.$("#ENDUZ<%=no%>").val("");
			if('<%=getData.TIME_YN%>' != "Y"){
				parent.$("#BEGUZ<%=no%>").attr('disabled', true);
				parent.$("#ENDUZ<%=no%>").attr('disabled', true);
				var timHidden = '<input type=hidden id="BEGUZ<%=no%>" name="BEGUZ"  value="<%=getData.BEGUZ%>" >';
					timHidden += '<input type=hidden id="ENDUZ<%=no%>" name="ENDUZ"  value="<%=getData.ENDUZ%>" >';
				parent.$("#td_TIME<%=no%>").html(timHidden);
			}else{
				parent.$("#BEGUZ<%=no%>").attr('disabled', false);
				parent.$("#ENDUZ<%=no%>").attr('disabled', false);
				parent.$("#td_TIME<%=no%>").html("");
			}

			parent.$("#EDIT"+<%=no%>).val('<%=getData.EDIT%>');
			parent.$("#AWART<%=no%>").val('<%=getData.AWART%>');
			parent.$("#INFTY<%=no%>").val('<%=getData.INFTY%>');

			parent.$("#td_TPROG"+<%=no%>).text('<%=getData.TPROG%>');
			parent.$("#TPROG<%=no%>").val('<%=getData.TPROG%>');

			parent.parent.$.unblockUI();

		}else{

			alert('<%=getData.MSG%>');
			parent.$("#CHKDT<%=no%>").val('X');
			parent.$("#MSG<%=no%>").val('<%=getData.MSG%>');
			parent.parent.$.unblockUI();
		}

<%
	}
%>

</script>