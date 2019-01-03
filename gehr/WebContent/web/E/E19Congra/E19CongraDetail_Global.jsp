<%/***************************************************************************************//*	  System Name  	: g-HR																															*//*   1Depth Name		: Application                                                 																	*//*   2Depth Name		: Benefit Management                                                														*//*   Program Name	: Celebration & Condolence                                             													*//*   Program ID   		: E19CongraDetail.jsp                                         																*//*   Description  		: 경조금 신청 조회                                            																			*//*   Note         		: 없음                                                        																				*//*   Creation     		: 2001-12-19  김성일                                          																		*//*   Update       		: 2005-02-14  이승희                                          																		*//*                  		: 2005-02-24  윤정현                                          																		*//*   Update       		: 2007-10-23  li hui  @v1.0                                     															*//*							: 2008-01-22  jungin  @v1.1  최대지급한도 추가.                                          							*//*							: 2009-03-19  jungin  @v1.2  'Base Amount'영역 display 방지.(LG BOHAI한함)								*//*							: 2009-03-26  jungin  @v1.3  'Base Amount'영역 display 방지.(LG BOHAI한함) - 주석해제					*//***************************************************************************************/%><%@ page contentType="text/html; charset=utf-8" %><%@ include file="/web/common/commonProcess.jsp" %><%@ page import="java.util.Vector" %><%@ page import="hris.common.util.*" %><%@ page import="hris.E.E19Congra.*" %><%@ page import="hris.E.E19Congra.rfc.*" %><%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %><%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %><%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %><%    WebUserData user = (WebUserData)session.getAttribute("user");    E19CongcondGlobalData e19CongcondData = (E19CongcondGlobalData)request.getAttribute("e19CongcondData");	String disabled= "";	String  _NAME ="";	if (e19CongcondData.CERT_FLAG.equals("Y")) {		disabled = "disabled";		_NAME = "_1";	}%><c:set var="user" value="<%=user%>" /><c:set var="disabled" value="<%=disabled%>" /><c:set var="_NAME" value="<%=_NAME%>" /><tags:layout css="ui_library_approval.css" script="dialog.js" >    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_CONG_COND"  updateUrl="${g.servlet}hris.E.E19Congra.E19CongraChangeGlobalSV">    <div class="tableArea">        <div class="table">            <table class="tableGeneral">                <colgroup>                    <col width="15%"/>                    <col width="85%"/>                </colgroup>                <tr>                    <th><spring:message code='LABEL.E.E20.0033' /><!-- Cel/Con&nbsp;Type --></th>                    <td>                        <input type="text" name="CELTX" size="15" value="${f:printOptionValueText(Code_vt0,e19CongcondData.CELTY)}" readonly>                        <input type="hidden" name="CELTY" value="${e19CongcondData.CELTY }">                        <input type="hidden" name="BEGDA" value="${e19CongcondData.BEGDA}">                    </td>                </tr>                <tr>                    <th><spring:message code='LABEL.E.E24.0006' /><!-- Family&nbsp;Type --></th>                    <td>                        <input type="text" name="FAMY_TEXT" size="15" value="${f:printOptionValueText(Code_vt3,e19CongcondData.FAMY_CODE)}" readonly>                        <input type="hidden" name="FAMY_CODE" value="${e19CongcondData.FAMY_CODE }">                        <input type="hidden" name="FAMSA" value="${e19CongcondData.FAMSA }">                    </td>                </tr>                <tr>                    <th><spring:message code='LABEL.E.E24.0007' /><!-- Name --></th>                    <td>                        <span id="ename" name="ename">                            <input type="text" name="ENAME"   value="${e19CongcondData.ENAME }" size="100" readonly>                        </span>                    </td>                </tr>                <tr>                    <th><spring:message code='LABEL.E.E20.0036' /><!-- Cel/Con&nbsp;Date --></th>                    <td>                        <input type="text" name="CELDT" value="${ f:printDate(e19CongcondData.CELDT) }" size="15" readonly>                    </td>                </tr>            </table>        </div>    </div>    <div class="tableArea" style="display:${(user.empNo eq e19CongcondData.PERNR or bFlag) ? 'block':'none' }">        <div class="table">            <table class="tableGeneral">                <colgroup>                    <col width="15%"/>                    <col width="35%"/>                    <col width="15%"/>                    <col width="35%"/>                </colgroup>                <%--<tr style="display:<%= user.e_werks != null && ! user.e_werks.equals("2800") && ! user.e_werks.equals("3700") ?"block":"none" --%>                <tr>                    <th><spring:message code='LABEL.E.E19.0015' /><!-- Base&nbsp;Amount --></th>                    <td>                        <span id="base" name="base">                            <input type="text" name="BASE_AMNT" style="text-align:right;" value="${f:printNumFormat(e19CongcondData.BASE_AMNT, 2)}"  size="10" readonly>&nbsp;<input type="text" value="${e19CongcondData.CURRENCY }" readonly>                        </span>                    </td>                    <th class="th02"><spring:message code='LABEL.E.E21.0013' /><!-- Payment&nbsp;Rate --></th>                    <td>                        <span id="paym" name="paym">                            <input type="text" name="PAYM_RATE" style="text-align:right;" value="${e19CongcondData.PAYM_RATE }"  size="10" readonly>&nbsp;<input type="text" value="%" readonly>                        </span>                    </td>                </tr>                <%-- <tr style="display:%{<%= user.e_werks != null && ! user.e_werks.equals("2800") && ! user.e_werks.equals("3700") ?"block":"none" %>"> --%>                <tr>                    <th><spring:message code='LABEL.E.E18.0008' /><!-- Payment&nbsp;Amount --></th>                    <td>                        <span id="clac" name="clac">                            <input type="text" name="CLAC_AMNT" style="text-align:right;" value="${f:printNumFormat(e19CongcondData.CLAC_AMNT, 2)}"   size="10" readonly>&nbsp;<input type="text" value="${e19CongcondData.CURRENCY }" readonly>                        </span>                    </td>                    <th class="th02"><spring:message code='LABEL.E.E19.0016' /><!-- Payment&nbsp;Limit --></th>                    <td>                        <span id="limit" name="limit">                            <input type="text" name="MAXM_PAY" style="text-align:right;"  value="${f:printNumFormat(e19CongcondData.MAXM_PAY, 2)}"  size="10" readonly>&nbsp;<input type="text" name="CURRENCY" value="${e19CongcondData.CURRENCY }" readonly>                        </span>                    </td>                </tr>                <tr>                    <th><spring:message code='LABEL.E.E19.0017' /><!-- Absence&nbsp;Days --></th>                    <td>                        <span id="absn" name="absn">                            <input type="text" name="ABSN_DATE" style="text-align:right;" value="${!empty e19CongcondData ? e19CongcondData.ABSN_DATE:''}"  size="10" readonly>&nbsp;<input type="text" value="Days" readonly>                        </span>                    </td>                    <th class="th02"><spring:message code='LABEL.E.E05.0003' /><!-- Service&nbsp;Period --></th>                    <td>                        <span id="syear" name="syear" >                            <input type="text" name="SYEAR" style="text-align:right;" value="${e19CongcondData.SYEAR}" size="6" readonly>&nbsp;<input type="text" value="Year" readonly size="5">                            <input type="text" name="SMNTH" style="text-align:right;" value="${e19CongcondData.SMNTH}" size="6" readonly>&nbsp;<input type="text" value="Month" readonly size="5">                        </span>                    </td>                </tr>            </table>        </div>    </div>    <c:choose>	<c:when test="${approvalHeader.chargeArea or approvalHeader.finish}">	<c:if test ="${approvalHeader.finish }">		<c:set var="disabled" value="disabled" />	</c:if>	    <tags:script>            <script>	function beforeAccept(){   var frm = document.form1;   if(frm.CERT_DATE != undefined){	   <c:if test="${disabled !='disabled'}">     	 if (frm.CERT_DATE.value == "") {           alert("<spring:message code='MSG.E.E19.0039' />"); //Please input submit date.           frm.CERT_DATE.focus();           return;         } // end if     	 if (frm.CERT_BETG.value == "") {           alert("<spring:message code='MSG.E.E19.0040' />"); //please input Reimburse Amount           frm.CERT_BETG.focus();           return;         } // end if        var radios = document.getElementsByName('CERT_FLAG');        for (var i =0; i<radios.length; i++){        	if (radios[i].checked && radios[i].value=="N"){        	  alert("<spring:message code='MSG.E.E19.0041' />"); //Please check document evidence.              return;        	}        } // end if      </c:if>		frm.CERT_DATE.value	= removePoint(frm.CERT_DATE.value);		frm.PAYM_DATE.value	= removePoint(frm.CERT_DATE.value);		frm.CERT_BETG.value	= removeComma(frm.CERT_BETG.value);		frm.PAYM_AMNT.value	= frm.CERT_BETG.value ;		//alert("[frm.PAYM_AMNT.value]	:	" + frm.PAYM_AMNT.value  + "     /    " + "[ frm.CERT_BETG.value]:		" +  frm.CERT_BETG.value);    }    frm.CELDT.value = removePoint(frm.CELDT.value);    frm.BEGDA.value = removePoint(frm.BEGDA.value);	frm.BASE_AMNT.value = removeComma(frm.BASE_AMNT.value);	frm.CLAC_AMNT.value = removeComma(frm.CLAC_AMNT.value);	return true;}	 </script>    </tags:script>    <div class="tableArea" style="display:${(user.empNo eq e19CongcondData.PERNR or bFlag or approvalHeader.finish) ? 'block':'none' }">        <div class="table">            <table class="tableGeneral">                 <colgroup>                    <col width="15%"/>                    <col width="35%"/>                    <col width="15%"/>                    <col width="35%"/>                </colgroup>			  <tr>              	    <th><spring:message code='LABEL.E.E18.0064' /><!-- Document Evidence --></th>              		<td >              			<input type="radio" name="CERT_FLAG${_NAME}" value="Y"              			 <c:if  test="${ e19CongcondData.CERT_FLAG eq 'Y' }" >					     checked					    </c:if>					    ${disabled}>Yes              			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              			<input type="radio" name="CERT_FLAG${_NAME}" value="N" <c:if  test="${ e19CongcondData.CERT_FLAG eq '' }" >					     checked					    </c:if>					    ${disabled}>No              		</td>              		<th class="th02"><spring:message code='LABEL.E.E18.0065' /><!-- Submit Date --></th>              		<td >	                    <input type="text"	                <c:if  test="${ disabled ne 'disabled' }" >	                     class= "date"	                 </c:if>	                     name="CERT_DATE${_NAME}" size="15" maxlength="15"  value="${f:printDate( e19CongcondData.CERT_DATE)}" ${disabled}>                    </td>              	</tr>              	<tr>              		<th><spring:message code='LABEL.E.E21.0030' /><!-- Payment&nbsp;Amount --></th>              		<td              		<c:if test="${!approvalHeader.finish}">              		colspan="3"              		</c:if>              		>              		  <input type="text" name="CERT_BETG${_NAME}" style="text-align:right;" onkeyup="moneyChkEventForWorld(this);"  value="${e19CongcondData.CERT_BETG == '0' ?f:printNumFormat(e19CongcondData.CLAC_AMNT,2 ): f:defaultString(f:printNumFormat(e19CongcondData.CERT_BETG,2), f:printNumFormat(e19CongcondData.CLAC_AMNT,2 ))}"  ${disabled}>&nbsp;              		  <input type="text" name="CURRENCY${_NAME}"  value="${e19CongcondData.CURRENCY }" readonly>              		</td>              		<c:if test="${approvalHeader.finish}">              		<th class="th02"><spring:message code='LABEL.E.E18.0063' /><!-- Account&nbsp;Document --></th>                      <td >                       <input type="text" name="BELNR"   value="${ e19CongcondData.BELNR }"  readonly>                      </td>                    </c:if>              	</tr>              </table>        </div>    </div>		</c:when>		 </c:choose>					<input type="hidden" name="PAYM_DATE" value="">					<input type="hidden" name="PAYM_AMNT" value="">					<input type="hidden" name="AWART" value="${e19CongcondData.AWART}">					<input type="hidden" name="OBJPS"  value="${e19CongcondData.OBJPS}">	<c:if test="${disabled eq 'disabled'}">			<input type="hidden" name="CERT_FLAG" value="${ e19CongcondData.CERT_FLAG}">			<input type="hidden" name="CERT_DATE" value="${f:printDate(e19CongcondData.CERT_DATE )}">			<input type="hidden" name="CERT_BETG" value="${e19CongcondData.CERT_BETG == '0' ?f:printNumFormat(e19CongcondData.CLAC_AMNT,2 ): f:defaultString(f:printNumFormat(e19CongcondData.CERT_BETG,2), f:printNumFormat(e19CongcondData.CLAC_AMNT,2 ))}" >			<input type="hidden" name="CURRENCY" value="${ e19CongcondData.CURRENCY}">	</c:if>    </tags-approval:detail-layout></tags:layout>