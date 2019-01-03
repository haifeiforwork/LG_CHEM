<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag import="hris.common.WebUserData" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="buttonBody" type="com.common.vo.BodyContainer" %>
<%@ attribute name="detailBody" type="com.common.vo.BodyContainer" %>
<%--@elvariable id="familyEntry" type="java.util.Map<String, java.util.Vector>"--%>
<%--@elvariable id="a04FamilyDetailData_vt" type="java.util.Vector<hris.A.A04FamilyDetailData>"--%>
<%--@elvariable id="g" type="com.common.Global"--%>
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />

<tags-family:family-layout help="A04Family.html" detailBody="${detailBody}" buttonBody="${buttonBody}">
    <div class="listArea">
    	<div class="table">
	        <table class="listTable">
	            <thead>
	            <tr>
	                <th><spring:message code="MSG.A.A03.0020" /><!-- Select --></th>
	                <th><spring:message code="LABEL.A.A12.0002" /><!-- Family Type --></th>
	                <th><spring:message code="MSG.A.A01.0002" /><!-- Name --></th>
	                <th class="lastCol"><spring:message code="LABEL.A.A12.0005" /><!-- Birth Date --></th>
	            </tr>
	            </thead>
	            <tbody>

	            <c:forEach var="row" items="${a04FamilyDetailData_vt}" varStatus="status">

	                <tr class="${status.index % 2 == 0 ? 'oddRow' : ''}">
	                    <td>
	                        <input type="radio" name="radiobutton" value="radiobutton" onclick="detail($(this));">
	                        <input type="hidden" name="SUBTY"  value="${row.SUBTY}">
	                        <input type="hidden" name="FAMSA"  value="${row.FAMSA}">
	                        <input type="hidden" name="OBJPS"  value="${row.OBJPS}">
	                        <!--添加了家属来排遣地日期的字段：ENTDT 2011-08-12 liukuo   @v1.6  [C20110728_35671]-->
	                        <input type="hidden" name="ENTDT"  value="${row.ENTDT}">
	                        <input type="hidden" name="BEGDA"  value="${row.BEGDA}">
	                        <input type="hidden" name="ENDDA"  value="${row.ENDDA}">
	                        <input type="hidden" name="FGBDT"  value="${f:printDate(row.FGBDT)}">
	                        <input type="hidden" name="FGBLD"  value="${row.FGBLD}">
	                        <input type="hidden" name="F28address" value="${f:findOption(nationList, "LAND1", empty row.FGBLD ? user.area : row.FGBLD).LANDX}">

	                        <input type="hidden" name="FANAT"   value="${row.FANAT}">
	                        <input type="hidden" name="address"   value="${f:findOption(nationList, "LAND1", empty row.FANAT ? user.area : row.FANAT).CNATIO}">
	                        <input type="hidden" name="LANDX"   value="${f:findOption(nationList, "LAND1", empty row.FANAT ? user.area : row.FANAT).CNATIO}">


	                        <input type="hidden" name="FASEX"  value="${row.FASEX}">
	                        <input type="hidden" name="FAVOR" value="${row.FAVOR}">
	                        <input type="hidden" name="ALLNAM" value="${isEU ? row.ALLNAM_EU : row.ALLNAM}">
	                        <input type="hidden" name="ALLN42" value="${isEU ? row.ALLNAM_EU : row.ALLNAM}">
	                        <input type="hidden" name="FANAM"  value="${row.FANAM}">
	                        <input type="hidden" name="FGBOT"  value="${row.FGBOT}">
	                        <input type="hidden" name="FGBNA"  value="${row.FGBNA}">
	                        <input type="hidden" name="ERNAM"  value="${row.ERNAM}">
	                        <input type="hidden" name="OCCUP"  value="${row.OCCUP}">
							<c:set var="occup" value="${f:findRow(familyEntry['T_ITAB1'], 'OCCUP', row.OCCUP)}"/>
	                        <input type="hidden" name="OCCUPS"  value="${occup != null ? occup.OCTXT : ''}">
	                        <input type="hidden" name="PSTAT"  value="${row.PSTAT}">
	                        <input type="hidden" name="FANA2"  value="${row.FANA2}">
	                        <input type="hidden" name="FANA3"  value="${row.FANA3}">
	                        <input type="hidden" name="faddress2"  value="${f:findOption(nationList, "LAND1", empty row.FANA2 ? user.area : row.FANA2).CNATIO}">
	                        <input type="hidden" name="faddress3"  value="${f:findOption(nationList, "LAND1", empty row.FANA3 ? user.area : row.FANA3).CNATIO}">

	                        <input type="hidden" name="OCCTX"  value="${row.OCCTX}">
	                        <input type="hidden" name="PSTXT"  value="${row.PSTXT}">
	                        <input type="hidden" name="ERNAM2"  value="${row.ERNAM2}">
	                        <input type="hidden" name="STEXT"  value="${row.STEXT}">
	                        <input type="hidden" name="ANREX"  value="${row.ANREX}">
	                        <input type="hidden" name="avalue28"  value="${f:printOptionValueText(familyEntry['T_ITAB5'], empty row.ANREX ? "1" : row.ANREX)}">

	                        <input type="hidden" name="CNNAM"  value="${row.CNNAM}">
	                        <input type="hidden" name="IDNUM"  value="${row.IDNUM}">
	                        <input type="hidden" name="FINIT"  value="${row.FINIT}">
	                        <input type="hidden" name="GBDEP"  value="${row.GBDEP}">
	                        <input type="hidden" name="FAMST"  value="${f:printOptionValueText(familyEntry['T_ITAB3'], empty row.FAMST ? "0" : row.FAMST)}">
	                        <input type="hidden" name="FASAR"  value="${row.FASAR}">
	                        <input type="hidden" name="FASIN"  value="${row.FASIN}">
	                        <input type="hidden" name="ADDAT"  value="${row.ADDAT}">
	                        <input type="hidden" name="SAMER"  value="${row.SAMER}">
	                        <input type="hidden" name="ENAME"  value="${row.ENAME}">
	                        <input type="hidden" name="NHIFA"  value="${row.NHIFA}">
	                        <input type="hidden" name="NHIST"  value="${row.NHIST}">
	                        <input type="hidden" name="NHISR"  value="${row.NHISR}">
	                        <!--2012-07-11 lixinxin@v1.7 [C20120710_44214] Family 添加详细信息 联系方式电话号 和邮箱 -->
	                        <input type="hidden" name="TELNR"  value="${row.TELNR}">
	                        <!--  2012-07-17 lixinxin@v1.8 [C20120716_47583 ] Family 替换详细信息 将油箱换成现居住地址 -->
	                            <%--  input type="hidden" name="NUMMAIL"  value="${row.NUMMAIL}">  --%>
	                        <input type="hidden" name="FAMIADDR"  value="${row.FAMIADDR}">

	                        <%--
	                        <input type="hidden" name="ALLNAM<%= i %>" value="<%= (AppUtil.checkEnglish(data.FAVOR)&&AppUtil.checkEnglish(data.FANAM))?(data.FAVOR + " " + data.FANAM):(data.FANAM + " " + data.FAVOR) %>">
	                        <input type="hidden" name="ALLN42<%= i %>" value="<%= (AppUtil.checkEnglish(data.FAVOR)&&AppUtil.checkEnglish(data.FANAM))?(data.FAVOR + " " + data.FANAM):(data.FANAM + " " + data.FAVOR) %>">
	                        --%>

	                    </td>
	                    <td>${row.FAMSA} </td>
	                    <td>${isEU ? row.ALLNAM_EU : row.ENAME}</td>
	                    <td class="lastCol">${f:printDate(row.FGBDT)}</td>
	                </tr>

	            </c:forEach>
	            <tags:table-row-nodata list="${a04FamilyDetailData_vt}" col="4" />

	            </tbody>
	        </table>
		</div>
    </div>

</tags-family:family-layout>


