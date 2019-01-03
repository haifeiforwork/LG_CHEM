<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   공통														*/
/*   Program Name	:   근태그룹인원지정										*/
/*   Program ID		: D40OrganListHiddenPop.jsp							*/
/*   Description		: 근태그룹인원지정 부모창으로 전달						*/
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
// 	Vector vec = new Vector();
	String SPERNR     = WebUtil.nvl(request.getParameter("pop_SPERNR"));
	String SPERNR_TX     = WebUtil.nvl(request.getParameter("pop_SPERNR_TX"));
	String ORGEH_TX     = WebUtil.nvl(request.getParameter("pop_ORGEH_TX"));
	String returnGubun     = WebUtil.nvl(request.getParameter("returnGubun"));
	String rowindex     = WebUtil.nvl(request.getParameter("rowindex"),"0");
	String rowcount     = WebUtil.nvl(request.getParameter("rowcount"));
	String I_SEQNO     = WebUtil.nvl(request.getParameter("paramSEQNO"));
	String I_PABRJ     = WebUtil.nvl(request.getParameter("I_PABRJ"));
	String I_PABRP     = WebUtil.nvl(request.getParameter("I_PABRP"));
	String spernrValue[] = request.getParameterValues("SPERNR");

	String[] spernrs = SPERNR.split(",");
	String[] spernr_tx = SPERNR_TX.split(",");
	String[] orgeh_tx = ORGEH_TX.split(",");

%>

<form name="form1">
</form>
<script>

	var html = "";
	var rowcount = '<%=rowcount%>';
	var chkSpernrs = <%=spernrs.length%>;
	/* for(var i = 0; i < chkSpernrs; i++){ */
<%
	boolean isSame = false;
	int sameCnt = 0;
	String sameSpernrs = "";
	for(int i=0; i<spernrs.length; i++){
		if(spernrValue != null){
			for(int j=0; j<spernrValue.length; j++){
				if(spernrs[i].equals(spernrValue[j])){
					isSame = true;
					sameCnt++;
					sameSpernrs = spernrs[i];
				}
			}
		}
		if(!isSame){
%>
			html += '<tr id="tr'+rowcount+'">'+
				'<td>'+
				'	<input type="checkbox" name="chkbutton" class="chkbox" value="'+rowcount+'">'+
				'	<input type="hidden" id="SPERNR'+rowcount+'" name="SPERNR" value="<%=spernrs[i]%>"  maxlength="8" >'+
				'</td>'+
				'<td id="SPERNR'+rowcount+'"><%=spernrs[i]%></td>'+
				'<td id="SPERNR_TX'+rowcount+'"><%=spernr_tx[i]%></td>'+
				'<td></td>'+
				'<td style="display: none;"></td>'+
				'<td id="ORGEH_TX'+rowcount+'" class="lastCol" ><%=orgeh_tx[i]%></td>'+
				'<td style="display: none;"></td>'+
				'<td style="display: none;" class="lastCol"></td>'+
			'</tr>';
			rowcount++;
			parent.$("#rowcount").val(rowcount);
<%
		}
		if("ALL".equals(returnGubun)){
			isSame = false;
		}
	}
%>

	if("ALL" == '<%=returnGubun%>'){
		parent.$("#tmGroupTable").append(html);
	}else{


<%
		if(!"ALL".equals(returnGubun)){
			if(sameCnt < 2){

 				/* 단건  */
				//RFC 호출로직
				Vector get_vt = new Vector();
				D40TmGroupPersData data = new D40TmGroupPersData();
				data.SPERNR = WebUtil.nvl(SPERNR);
				get_vt.addElement(data);
				Vector ret = (new D40TmGroupPersRFC()).getTmGroupPers(user.empNo, "3", I_PABRJ, I_PABRP, I_SEQNO, get_vt);
				Vector vt = (Vector)ret.get(0);
				String E_RETURN = WebUtil.nvl((String)ret.get(1));
				String E_MESSAGE = WebUtil.nvl((String)ret.get(2));
				String persId = "";
				String persName = "";
				String persOrgeh = "";
				if(vt.size() > 0){
					D40TmGroupPersData getData = (D40TmGroupPersData)vt.get(0);
					persId = getData.SPERNR;
					persName = getData.SPERNR_TX;
					persOrgeh = getData.ORGEH_TX;
				}
%>

					parent.$("#SPERNR"+<%=rowindex%>).val('<%=persId%>');
					parent.$("#SPERNR"+<%=rowindex%>).text('<%=persId%>');
					parent.$("#SPERNR_TX").val('<%=persId%>');
					parent.$("#SPERNR_TX"+<%=rowindex%>).text('<%=persName%>');
					parent.$("#ORGEH_TX"+<%=rowindex%>).text('<%=persOrgeh%>');
<%
			}
		}else{
%>
			alert( "'<%=sameSpernrs%>'은 동일한 사번이 존재 합니다.");
			parent.$("#SPERNR"+<%=rowindex%>).val("");
			parent.$("#SPERNR"+<%=rowindex%>).focus();
<%
		}
%>
	}

</script>