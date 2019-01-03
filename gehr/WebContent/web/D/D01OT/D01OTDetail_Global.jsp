<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Application                                                  																	*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Overtime                                               																		*/
/*   Program ID   		: D01OTDetail.jsp                                             																*/
/*   Description  		: 초과근무(OT/특근) 상세 보기 화면                           																	*/
/*   Note         		:                                                             																		*/
/*   Creation     		: 2002-01-15 박영락                                          																		*/
/*   Update       		: 2005-03-03 윤정현                                          																		*/
/*                  		: 2007-09-12 huang peng xiao			                           														*/
/*							: 2009-06-17 jungin @v1.0 [C20090609_70122] LGCC TJ 회사코드 변경(G250->G360)						*/
/*							: 2015-07-17 li ying zhe @v1.7  [SI -> SM]Global e-HR Add JV(G450)                                        */
/*                         : 2016-09-20 통합구축 - 김승철                  																			   */
/*							: 2017-04-03  eunha [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 */
/*							: 2017-04-19  eunha [CSR ID:3359686] 审批日期限制   남경 결재 5일제어                                                  */
/*                         : 2017-12-06 이지은   [CSR ID:3544114] [LGCTW]Request of Global HR Portal system Compensatory Leave(補休假) function increasing
	                                                           G220법인만 초과근무 신청 시 대체휴가 신청 옵션 기능 추가.
	                          2018-03-19 KDM      @PJ.광저우 법인(G570) Roll-Out
	                          2018-08-01 변지현     @PJ.우시법인(G620) Roll-out
/*******************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ page import="hris.G.rfc.ApprovalCancelCheckRFC" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.D.rfc.*" %>

<%--@elvariable id="g" type="com.common.Global"--%>
<%--@elvariable id="phonenumdata" type="hris.common.PersonData"--%>
<%--@elvariable id="PersonData" type="hris.common.PersonData"--%>
<%--@elvariable id="phonenum" type="hris.common.PersonData"--%>
<%
    WebUserData user = (WebUserData)session.getAttribute("user");

    Vector D01OTData_vt = (Vector)request.getAttribute("D01OTData_vt");
    D01OTData data = ( D01OTData )D01OTData_vt.get(0);

    String E_BUKRS = (String)request.getAttribute("E_BUKRS");
    String company = user.companyCode;

    Vector reasonCode         = (Vector)request.getAttribute("reasonCode");
    String E_ANZHL  = (String)request.getAttribute("E_ANZHL");

    String userRate  = WebUtil.printNumFormat((Double.parseDouble(E_ANZHL)/46)*100,2);
%>

<c:set var="user" value="<%=user%>"/>
<c:set var="data" value="<%=data%>"/>
<c:set var="E_BUKRS" value="<%=E_BUKRS%>"/>
<c:set var="company" value="<%=company%>"/>
<c:set var="reasonCode" value="<%=reasonCode%>"/>
<c:set var="userRate" value="<%=userRate%>"/>

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>


<%--
<SCRIPT LANGUAGE="JavaScript">
<!--

function go_change() {
    if(chk_APPR_STAT(0)){
        document.form1.jobid.value="";
        document.form1.action = '${ WebUtil.ServletURL %>hris.D.D01OT.D01OTChangeSV';
        document.form1.submit();
    }
}

function go_delete() {
    if( chk_APPR_STAT(1) && confirm("Are you sure to delete?") ) {
        document.form1.jobid.value="delete";
        document.form1.action = '${ WebUtil.ServletURL %>hris.D.D01OT.D01OTDetailSV';
        document.form1.submit();
    }
}

function do_list(){
    document.form1.action = "${RequestPageName.replace('|','&')}";
    document.form1.submit();
}
//-->
</SCRIPT>
 --%>


    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PT_STAT_APPL" updateUrl="${g.servlet}hris.D.D01OT.D01OTChangeSV">

 <input type="hidden" name = "PERNR" value="${data.PERNR}">
 <input type="hidden" name="BEGDA" size="7" class="input04" value="${ f:printDate( data.BEGDA ) }" readonly >
  	    <tags:script>
            <script>
	function beforeAccept()
{

 	<%--[CSR ID:3359686] 审批日期限制   남경 결재 5일제어 START--%>
	<c:if test="${E_7OVER_NOT_APPROVAL =='E'}">
		 alert("<spring:message code="MSG.D.D01.0108"/>");//The request date has passed 5 working days. You could not approve it.
         return;
	</c:if>
	<%--[CSR ID:3359686] 审批日期限制   남경 결재 5일제어 END--%>

	<%-- [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 START--%>
 	<c:if test="${E_46OVER_NOT_APPROVAL =='E'}">
	 	alert("<spring:message code="MSG.D.D01.0109"/>");//The Approved overtime hours of this payroll period are over 46 hours.
     	return;
    </c:if>
    <%-- [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 END--%>
	return true;
}
	 </script>
    </tags:script>

<div class="tableArea">
    <div class="table">
        <table class="tableGeneral tableApproval">

            	<colgroup>
            	<col width=15%/>
            	<col width=35%/>
            	<col width=15%/>
            	<col />
            	</colgroup>

                <tr>
                  <th >
                  		<spring:message code="LABEL.D.D01.0001"/><!--Overtime Date--></th>
                  <!-- <td colspan=3> -->
                  <td colspan="${E_BUKRS=='G220' ? '1':'3'}">
	                    <input type="text" name="WORK_DATE" size="10" class="input04"
	                    value="${ f:printDate( data.WORK_DATE ) }" readonly >
						<%--  2018-03-12 KDM @PJ.광저우 법인(G570) Roll-Out  ADD Start --%>
						<%--  2018-08-01 변지현 @PJ.우시법인(G620) Roll-out --%>
						<c:if test='${E_BUKRS != null and (E_BUKRS==("G180") or E_BUKRS==("G150") or E_BUKRS==("G240")
											or E_BUKRS==("G170") or E_BUKRS==("G360") or E_BUKRS==("G450") or E_BUKRS==("G570") or E_BUKRS==("G620") )}'>
						<%-- 2018-03-12 KDM @PJ.광저우 법인(G570) Roll-Out ADD End  --%>
						<%--//Global e-HR Add JV(G450)  	2015-07-17		li ying zhe	@v1.1 [SI -> SM] --%>
			                   <input type="checkbox" name="VTKEN" ${ (data.VTKEN)==("X") ? "checked" : "" } disabled >
		                  			<spring:message code="MSG.D.D01.0051"/><!-- Prev. Day-->
						</c:if>
                  </td>

<%--  [CSR ID:3544114]  --%>
<c:if test='${E_BUKRS==("G220") }'>
							<th class="th02"><span class="textPink">*</span> <spring:message code="LABEL.D.D01.0017" /></th><!--초과근무 보상-->
							<td>
								<input type="radio" name="VERSL" id="VERSL1" value="0" ${(data.VERSL == "" || data.VERSL == "0") ? "checked" : "" } disabled >
								<label for="contactChoice3"><spring:message code="LABEL.D.D01.0019" /></label>&nbsp;&nbsp;&nbsp;<!-- 초과근무수당 -->
								<input type="radio" name="VERSL" id="VERSL2" value="3"  ${(data.VERSL == "3") ? "checked" : "" } disabled >
								<label for="contactChoice3"><spring:message code="LABEL.D.D01.0018" /></label><!-- 대체휴가 -->
							</td>
</c:if>
<%--  [CSR ID:3544114]  --%>
                </tr>


                <tr>
                  <th ><spring:message code="LABEL.D.D12.0043"/><!--Time--></th>
                  <td >
                    <input type="text" name="BEGUZ" size="3" class="input04" value="${ f:printTime( data.BEGUZ )}" readonly >
                    ~
                    <input type="text" name="ENDUZ" size="3" class="input04" value="${ f:printTime( data.ENDUZ ) }" readonly >
                    <input type="text" name="STDAZ" size="3" class="input04" value="${ f:printNum(data.STDAZ) }" readonly style="text-align:right">
                    <spring:message code="LABEL.D.D01.0008"/><!--hour(s)-->
                   </td>
<!--                       //2016-10-24  pangmin	[] 南京法人加班审批界面实现打卡时间邀请 start -->
					<c:choose>
					<%--  2018-03-12 KDM @PJ.광저우 법인(G570) Roll-Out Start  --%>
					<%--  2018-08-01 변지현 @PJ.우시법인(G620) Roll-out  --%>
                     <c:when test='${E_BUKRS eq ("G110") || E_BUKRS eq ("G280") || E_BUKRS eq ("G370")|| E_BUKRS eq ("G180")|| E_BUKRS eq ("G450")|| E_BUKRS eq ("G570")|| E_BUKRS eq ("G620")}'>
					<%--  2018-03-12 KDM @PJ.광저우 법인(G570) Roll-Out End  --%>
	                  <th class="th02"><spring:message code="LABEL.D.D03.0042"/><!-- Act. Time --></th>
	                   <td >
	                   		${E_BEGDATE} ${f:printTime(E_BEGTIME)} ~ ${E_ENDDATE} ${f:printTime(E_ENDTIME)}
	                  </td>
                 </c:when>
                     <c:when test='${E_BUKRS eq ("G220") and approvalHeader.ACCPFL eq "X"}'>
	                  <th class="th02">Use rate(%)</th>
	                   <td >
	                   		${userRate}%(${f:printNum(E_ANZHL)}/46)
	                  </td>
                 </c:when>
                 <c:otherwise>
                 		<td></td><td></td>
                 </c:otherwise>
                 </c:choose>
<!--                  // 2016-10-24  pangmin	[] 南京法人加班审批界面实现打卡时间邀请   end  %> -->

                </tr>

                <tr>
                  <th  ><spring:message code="LABEL.D.D15.0157"/><!--Application Reason--></th>
                  <td colspan=3>

                        <!--  2016-10-09 pangmin [CSR ID:3187342] LG YX法人E-HR OT界面改善邀请 begin -->
                        <c:choose>
                        <c:when test='${E_BUKRS != null and (E_BUKRS eq ("G170"))}'>
							<input type="text" name="ZRCODE" size="10" class="input03" readonly
				                         	 value="${f:printOptionREasonText(reasonCode, data.ZRCODE)}  "/>
				            	 <input type="text" name="ZREASON" size="75" class="input03" readonly
				            	 	value="${data.ZREASON }" onKeyPress = "javascript:EnterCheck2();" maxlength="50">
                        </c:when>
                        <%-- //2016-10-09 pangmin [CSR ID:3187342] LG YX法人E-HR OT界面改善邀请 end --%>
                        <c:otherwise>
		                        <input type="text" name="REASON" class="required" size="75" value="${ data.ZREASON }"
		                          	placeholder="<spring:message code="LABEL.D.D15.0157"/>" readonly
		                    		onKeyPress = "javascript:EnterCheck2();" maxlength="100">
                        </c:otherwise>
                        </c:choose>
                  </td>
                </tr>
                </table>
            </div>
         </div>

    <div class="listArea">
        <div class="table">
            <table class="listTable">

<!--                   <table  class="innerTable" > -->
		            <colGroup>
			            <col width=15%/>
			            <col width=15%/>
			            <col width=15%/>
			            <col />
		            </colGroup>
                  	<thead>
                    <tr>
                      <th >&nbsp;</th>
                      <th  class="align_center th02"><spring:message code="LABEL.D.D15.0162"/><!--시작시간--></th>
                      <th  class="align_center th02"><spring:message code="LABEL.D.D15.0163"/><!--종료시간--></th>
                      <th class="lastCol th02" > </th>
<%--                       <th  style="display:none"><spring:message code="LABEL.D.D01.0005"/><!--유급--></th> --%>
                    </tr>
					</thead>

                    <tr class="oddRow">
                      <td ><spring:message code="LABEL.D.D01.0006"/><!--휴게시간1--></th>
                      <td class="align_center">
                        <input type="text" name="PBEG1" size="10" class="input04" value="${ f:printTime( data.PBEG1 ) }" readonly style="text-align:center" />
                      </td>
                      <td class="align_center th02">
                        <input type="text" name="PEND1" size="10" class="input04" value="${ f:printTime( data.PEND1 ) }" readonly style="text-align:center" />
                      </td>
                      <td class="align_center th02">
                        <input type="text" name="PUNB1" size="10" class="input04" value="${ data.PUNB1 eq '0' ? '' : f:printNum(data.PUNB1) }" readonly  style="text-align:center;display:none" />
                      </td>
<!--                       <td  style="display:none"> -->
<%--                         <input type="text" name="PBEZ1" size="10" class="input04" value="${  (data.PBEZ1)==("0") ? "" : f:printNum(data.PBEZ1) }" readonly  style="text-align:center"> --%>
<!--                       </td> -->
                    </tr>

                    <tr>
                      <td ><spring:message code="LABEL.D.D01.0007"/><!--휴게시간2--></th>
                      <td class="align_center">
                        <input type="text" name="PBEG2" size="10" class="input04" value="${ f:printTime( data.PBEG2 ) }" readonly style="text-align:center" />
                      </td>
                      <td class="align_center th02">
                        <input type="text" name="PEND2" size="10" class="input04" value="${ f:printTime( data.PEND2 ) }" readonly style="text-align:center" />
                      </td>
                      <td class="align_center th02">
                        <input type="text" name="PUNB2" size="10" class="input04" value="${ data.PUNB2 eq '0' ? '' : f:printNum(data.PUNB2) }" readonly style="text-align:center;display:none" />
                      </td>
<!--                       <td  style="display:none"> -->
<%--                         <input type="text" name="PBEZ2" size="10" class="input04" value="${  (data.PBEZ2)==("0") ? "" : f:printNum(data.PBEZ2) }" readonly style="text-align:center"> --%>
<!--                         </td> -->
                      </tr>

<!---- hidden ------>
  </table>
</div></div>

    </tags-approval:detail-layout>

</tags:layout>
