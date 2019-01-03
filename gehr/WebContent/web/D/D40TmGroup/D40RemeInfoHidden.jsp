<%--
/********************************************************************************/
/*																				*/
/*   System Name	:  MSS														*/
/*   1Depth Name	:   부서근태													*/
/*   2Depth Name	:   사원지급 정보												*/
/*   Program Name	:   사원지급 정보												*/
/*   Program ID		: D40RemeInfoHidden.jsp										*/
/*   Description	: 입력 필드 조회												*/
/*   Note			:             												*/
/*   Creation		: 2017-12-08  정준현                                          		*/
/*   Update			: 2017-12-08  정준현                                          		*/
/*   				: 2018-06-18  성환희 [WorkTime52]                            */
/*                                                                             	*/
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
		D40RemeInfoFrameData getData = (D40RemeInfoFrameData)vt1.get(0);
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
			parent.$("#WWKTM"+<%=no%>).val('<%=getData.WWKTM%>');
			parent.$("#td_ENAME"+<%=no%>).text('<%=getData.ENAME%>');
			parent.$("#td_WWKTM"+<%=no%>).text('<%=getData.WWKTM%>');
			parent.$("#TIME_YN"+<%=no%>).val('<%=getData.TIME_YN%>');
			parent.$("#PTIME_YN"+<%=no%>).val('<%=getData.PTIME_YN%>');
			parent.$("#STDAZ_YN"+<%=no%>).val('<%=getData.STDAZ_YN%>');
			parent.$("#REASON_YN"+<%=no%>).val('<%=getData.REASON_YN%>');
			parent.$("#DETAIL_YN"+<%=no%>).val('<%=getData.DETAIL_YN%>');
			parent.$("#EDIT"+<%=no%>).val('<%=getData.EDIT%>');

			var select = parent.selectSearchList('<%=no%>', '<%=searchWTMCODE%>', '<%=getData.DETAIL%>');
			parent.$("#REASON<%=no%>").html(select);
			if('<%=getData.REASON_YN%>' != "Y"){
				parent.$("#REASON<%=no%>").attr('disabled', true);
				var reaHidden = '<input type=hidden id="REASON<%=no%>" name="REASON"  value="<%=getData.REASON%>" >';
				parent.$("#td_REASON<%=no%>").html(reaHidden);
			}else{
				parent.$("#REASON<%=no%>").attr('disabled', false);
				parent.$("#td_REASON<%=no%>").html("");
			}
			if('<%=getData.DETAIL_YN%>' != "Y"){
				parent.$("#DETAIL<%=no%>").attr('disabled', true);
				var detHidden = '<input type=hidden id="DETAIL<%=no%>" name="DETAIL"  value="<%=getData.DETAIL%>" >';
				parent.$("#td_DETAIL<%=no%>").html(detHidden);
			}else{
				parent.$("#DETAIL<%=no%>").attr('disabled', false);
				parent.$("#td_DETAIL<%=no%>").html("");
			}
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
			if('<%=getData.PTIME_YN%>' != "Y"){
				parent.$("#PBEG1<%=no%>").attr('disabled', true);
				parent.$("#PEND1<%=no%>").attr('disabled', true);
				var ptimHidden = '<input type=hidden id="PBEG1<%=no%>" name="PBEG1"  value="<%=getData.PBEG1%>" >';
					ptimHidden += '<input type=hidden id="PEND1<%=no%>" name="PEND1"  value="<%=getData.PEND1%>" >';
				parent.$("#td_PTIME<%=no%>").html(ptimHidden);
			}else{
				parent.$("#PBEG1<%=no%>").attr('disabled', false);
				parent.$("#PEND1<%=no%>").attr('disabled', false);
				parent.$("#td_PTIME<%=no%>").html("");
			}
			if('<%=getData.STDAZ_YN%>' != "Y"){
				parent.$("#STDAZ<%=no%>").attr('disabled', true);
				var stdazHidden = '<input type=hidden id="STDAZ<%=no%>" name="STDAZ"  value="<%=getData.STDAZ%>" >';
				parent.$("#td_STDAZ<%=no%>").html(stdazHidden);
			}else{
				parent.$("#STDAZ<%=no%>").attr('disabled', false);
				parent.$("#td_STDAZ<%=no%>").html("");
			}
			parent.$("#TPROG<%=no%>").val('<%=getData.TPROG%>');
			parent.$("#td_TPROG<%=no%>").html('<%=getData.TPROG%>');


			parent.parent.$.unblockUI();

		}else{

			alert('<%=getData.MSG%>');
			parent.parent.$.unblockUI();
		}

<%
	}
%>

</script>