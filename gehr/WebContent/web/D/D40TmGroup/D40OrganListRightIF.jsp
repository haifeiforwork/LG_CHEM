<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 조회                                                   */
/*   Program ID   : D40OrganListRightIF.jsp                                        */
/*   Description  : 조직도 조회 시 나타나는 사원리스트 iFrame                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2017-12-08  정준현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="hris.*" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@page import="org.apache.commons.lang.StringUtils"%>

<%
	WebUserData user     = (WebUserData)session.getAttribute("user");
	String gubun        = WebUtil.nvl(request.getParameter("gubun"));     //구분
	String deptNo        = WebUtil.nvl(request.getParameter("deptNo"));     //부서ID
	String I_SELTAB        = WebUtil.nvl(request.getParameter("I_SELTAB"));     //부서명
	String I_DATUM        = WebUtil.nvl(request.getParameter("I_DATUM"));     //부서명
	String E_RETURN      = WebUtil.nvl(request.getParameter("hdn_return"));     //E_RETURN 처리
	String E_MESSAGE     = WebUtil.nvl(request.getParameter("hdn_message"));    //E_MESSAGE 처리
    String I_IMWON = StringUtils.defaultString(request.getParameter("I_IMWON"));

	String I_PERNR     = WebUtil.nvl(request.getParameter("I_PERNR"));    //
	String I_ENAME     = WebUtil.nvl(request.getParameter("I_ENAME"));    //
	String I_GUBUN     = WebUtil.nvl(request.getParameter("I_GUBUN"));    //
	String I_RETIR     = WebUtil.nvl(request.getParameter("I_RETIR"));    //

	Vector OBJID = new Vector();
	Vector OrganPersList_vt = new Vector();
	if("1".equals(gubun)){
		String[] deptNos = deptNo.split(",");
		for(int i=0; i<deptNos.length; i++){
	    	D40OrganPersListData data = new D40OrganPersListData();
	    	data.OBJID = WebUtil.nvl(deptNos[i]);
	      	OBJID.addElement(data);
		}

		I_DATUM = I_DATUM.replace(".","");
		Vector ret = (new D40OrganPersListRFC()).getPersonList(user.empNo, I_SELTAB, I_DATUM, OBJID);
		E_RETURN = WebUtil.nvl((String)ret.get(0));
		E_MESSAGE = WebUtil.nvl((String)ret.get(1));
		OrganPersList_vt = (Vector)ret.get(2);
	}else{
		Vector ret = (new D40OrganPersListRFC()).getPersonEmpList(user.empNo, I_PERNR, I_ENAME, I_GUBUN, I_RETIR);
		E_RETURN = WebUtil.nvl((String)ret.get(0));
		E_MESSAGE = WebUtil.nvl((String)ret.get(1));
		OrganPersList_vt = (Vector)ret.get(2);
	}
%>

<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">

	$(function() {
		$("#allChk").click(function(){
			if(this.checked == true){
				$('input:checkbox[name="radiobutton"]').each(function(){
					this.checked = true;
				});
			}else{
				$('input:checkbox[name="radiobutton"]').each(function(){
					this.checked = false;
				});
			}
		});
	});

</SCRIPT>
<style>
	a {position:relative; top:-2px; left:5px;}
</style>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

	<form name="form1" method="post" onsubmit="return false">
		<input type="hidden" id="foo" name="foo" value="33">
		<div class="wideTable" style="border-top: 2px solid #c8294b; overflow: auto; width: 630px; height:410px;">
			<table class="listTable">
				<colgroup>
					<col width="">
					<col width="65px;">
					<col width="60px;">
					<col width="">
					<col width="">
					<col width="">
					<col width="">
					<col width="">
				</colgroup>
				<tr>
					<th><input type="checkbox" id="allChk" name="allChk" class="chkbox" ></th>
					<th><spring:message code="LABEL.D.D05.0005"/><%--사번--%></th>
					<th><spring:message code="LABEL.D.D12.0018"/><%--이름--%></th>
					<th><spring:message code="LABEL.COMMON.0029"/><%--소속--%></th>
					<th><spring:message code="LABEL.D.D40.0017"/><!-- 직위/<br>직급호칭 --></th>
					<th><spring:message code="LABEL.COMMON.0009"/><%--직책--%></th>
					<th><spring:message code="MSG.A.A01.0018"/><%--근무지--%></th>
					<th class="lastCol"><spring:message code="LABEL.D.D02.0003"/><%--구분--%></th>
				</tr>

<%
    // RFC로부터 검색 성공일 경우.
	if ( E_RETURN != null && !E_RETURN.equals("E") ){
        //조회된 데이터가 존재할 경우.
		if( OrganPersList_vt != null && OrganPersList_vt.size() > 0 ){
			for( int i = 0; i < OrganPersList_vt.size(); i++ ) {
                D40OrganPersListData persData = (D40OrganPersListData)OrganPersList_vt.get(i);
                String tr_class = "";
                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
				<tr class="<%=tr_class%>">
					<td>
						<input type="checkbox" name="radiobutton" class="chkbox" value="<%=persData.PERNR%>^<%=persData.ENAME%>^<%=persData.ORGTX%>" >
					</td>
					<td>
						<%=WebUtil.printString( persData.PERNR )%>
					</td>
					<td>
						<%=WebUtil.printString( persData.ENAME )%>
					</td>
					<td>
						<%=WebUtil.printString( persData.ORGTX )%>
					</td>
					<td>
						<%=StringUtils.replace(WebUtil.printString(persData.JIKWT ), "/", "/<br/>")%>
					</td>
					<td>
						<%=WebUtil.printString( persData.JIKKT )%>
					</td>
					<%-- <td><%=WebUtil.printString( persData.STLTX )%></td> --%>
					<td>
						<%=WebUtil.printString( persData.BTEXT )%>
					</td>
					<td class="lastCol">
						<%=WebUtil.printString( persData.PGTXT )%>
					</td>
				</tr>

<%
			} //end for
		} else {
%>
				<tr class="oddRow">
					<td class="lastCol" colspan="8"><spring:message code="MSG.COMMON.0004"/></td>
				</tr>
<%
		} // end if ~
	}else{

%>
				<tr class="oddRow">
					<td class="lastCol" colspan="8"><%=E_MESSAGE%></td>
				</tr>
<%
    }
%>

 			</table>
		</div>

	</form>
</body>