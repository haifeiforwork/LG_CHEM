<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.common.constant.Area" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	WebUserData user = WebUtil.getSessionUser(request);
    Vector  HRChargeData_vt = new Vector();
    String  i_bukrs         = request.getParameter("I_BUKRS");
    String  i_grup_numb     = request.getParameter("I_GRUP_NUMB");
    String  i_upmu_code     = request.getParameter("I_UPMU_CODE");

    if (code != null && code.equals("ghreva")) {	// @v1.0

    	if (i_upmu_code == null || i_upmu_code.equals("")) {
			i_upmu_code = "04";		// '04'-Performance Management(평가)
		}

    } else {

    	if ( (i_grup_numb == null) || (i_grup_numb.equals("")) ) {
			i_grup_numb = user.e_werks;
		}
		if ( (i_upmu_code == null) || (i_upmu_code.equals("")) ) {
			i_upmu_code = "";
		}
    }

    //if( i_grup_numb == null ) {   i_grup_numb = "";   }
    //if( i_upmu_code == null ) {   i_upmu_code = "";   }

    try {
        HRChargeData_vt = ( new HRChargeRFC() ).getCharge( i_bukrs, i_grup_numb, i_upmu_code );
    } catch(Exception ex) {
        HRChargeData_vt = null;
    }

    //Logger.debug.println("i_grup_numb==================="+i_grup_numb);
    //Logger.debug.println("i_bukrs =======================::"+i_bukrs);
    //Logger.debug.println("i_upmu_code =======================::"+i_upmu_code);

%>

<jsp:include page="/include/header.jsp"/>

<SCRIPT LANGUAGE="JavaScript">
<!--
function pers_search() {
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/HRChargePop.jsp";
    document.form1.submit();
}
//-->
</SCRIPT>

<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.COMMON.0023"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
    <div class="tableInquiry">
        <table>
            <tr>
                <th><img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" /></th>
                <th><spring:message code='LABEL.COMMON.0017' /><!-- 사업장 --></th>
                <td>
                    <select name="I_GRUP_NUMB" style="width:120px;" >
                        <%
                            if( user.area == Area.KR ){
                        %>
                        <option value = ""><spring:message code='LABEL.COMMON.0024' /><!-- 전체 --></option>
                        <% } %>
                        <%= WebUtil.printOption( ( new HRGrupNumbRFC() ).getGrupNumb( i_bukrs ), i_grup_numb ) %>
                    </select>
                </td>
                <th><spring:message code='LABEL.COMMON.0025' /><!-- 업무분야 --></th>
                <td>
                    <select name="I_UPMU_CODE" style="width:150px;">
                        <%
                            if( user.area == Area.KR ){
                        %>
                        <option value = ""><spring:message code='LABEL.COMMON.0024' /><!-- 전체 --></option>
                        <% } %>
                        <%= WebUtil.printOption( ( new HRUpmuCodeRFC() ).getUpmuCode( i_bukrs ), i_upmu_code ) %>
                    </select>
                     <input type="hidden" name="I_BUKRS" value="<%= i_bukrs %>">

                    <div class="tableBtnSearch tableBtnSearch2">
                        <a href="javascript:;" onclick="pers_search()" class="search"><span><spring:message code="BUTTON.COMMON.SEARCH" /><!-- 조회 --></span></a>
                    </div>
                </td>

            </tr>
        </table>
    </div>

    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <caption></caption>
				<col width="8%" />
				<col width="15%" />
				<col width="12%" />
				<col width="12%" />
				<col />
                <thead>
                <tr>
                    <th><spring:message code='LABEL.COMMON.0017' /><!-- 사업장 --></th>
                    <th><spring:message code='LABEL.COMMON.0025' /><!-- 업무분야 --></th>
                    <th><spring:message code='LABEL.COMMON.0016' /><!-- 담당자 --></th>
                    <th><spring:message code='LABEL.COMMON.0018' /><!-- 연락처 --></th>
                    <th class="lastCol" width=""><spring:message code='LABEL.COMMON.0026' /><!-- 담당업무 --></th>
                </tr>
                </thead>
                <%
                    if( HRChargeData_vt != null && HRChargeData_vt.size() > 0 ){
//        old_GRUP_NAME = HRChargeData.GRUP_NAME;
                        for( int i = 0 ; i < HRChargeData_vt.size() ; i++ ) {
                            HRChargeData HRChargeData = (HRChargeData)HRChargeData_vt.get(i);
                %>
                <tr align="center" class="<%=WebUtil.printOddRow(i)%>">
                    <td ><%= HRChargeData.GRUP_NAME %></td>
                    <td ><%= HRChargeData.UPMU_NAME %></td>
                    <td ><%= HRChargeData.ENAME %>&nbsp;<%= HRChargeData.TITEL %></td>
                    <td ><%= HRChargeData.TELNUMBER %></td>
                    <td  class="lastCol" style="text-align:left;padding-left:2px"><%= HRChargeData.UPMU_DESC %></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td class="lastCol" colspan="5"><spring:message code='LABEL.COMMON.0027' /><!-- 등록된 사업장별 인사담당자 연락처가 없습니다. --></td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
            </ul>
        </div>
    </div>

</form>
<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>
