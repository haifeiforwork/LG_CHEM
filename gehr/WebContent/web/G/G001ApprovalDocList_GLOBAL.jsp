<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: HR Approval Box                                                 															*/
/*   2Depth Name  	: Requested Document                                                   													*/
/*   Program Name 	: Requested Document                                               														*/
/*   Program ID   		: G001ApprovalDocList.jsp                                              													*/
/*   Description  		: 결재해야할 문서 목록 화면                   																					*/
/*   Note         		: 없음                                                            																				*/
/*   Creation    		: 2003-03-26 이승희                                          																		*/
/*   Update       		: 2003-03-26 이승희                                         																			*/
/*   Update       		: 2008-04-10 jungin @v1.0 [C20080407_46962] Duty 일괄결제 가능도록 수정.							    */
/*							: 2008-06-18 jungin @v1.1 [C20080606_78689] 일괄결재시 근태마감일 flag check							*/
/*							: 2008-11-26 jungin @v1.2 [C20081125_62600] 체크박스 스크립트 check(index) 수정.						*/
/*   						: 2008-11-27 jungin @v1.3 [C20081125_62978] DAGU법인 누적 E_ANZHL 체크								*/
/*							: 2008-12-08 jungin @v1.4 [C20081202_66724] 근무시간과 Duty신청시간의 중복체크						*/
/*							: 2009-12-23 jungin	@v1.5 [C20091222_81370] BOHAI법인 통문시간 출력										*/
/*							: 2010-04-28 jungin	@v1.6 [C20100427_55533] DAGU법인 통문시간 출력										*/
/*							: 2010-12-07 jungin	@v1.7 미국법인 일괄결재 방지 항목 추가														*/
/*							: 2011-01-19 liu kuo @v1.8  [C20110118_09919]Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청	*/
/*							: 2012-10-12 dongxiaomian	@v1.9 [C20120921_87982] 定义变量，给审批返回值					    	*/
/*							: 2016-03-01 pangxiaolin @2.0 G280法人审批list画面增加申请加班reason*/
/*							: 2016-04-06 pang xiaolin @v2.1 [C20160328_22012]G280法人在审批list画面中增加duty type */
/*							: 2016-04-19 pang xiaolin @v2.2 [C20160324_18938]全法人增加leave的批量审批功能 */
/*							: 2017-04-03 eunha [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 */
/*							: 2017-04-19 eunha [CSR ID:3359686] 审批日期限制   남경 결재 5일제어                                           */
/*                         : 2018-03-19 강동민    @PJ.광저우 법인(G570) Roll-Out ( G180 남경 Copy )                                */
/*                         : 2018-08-01 변지현    @PJ.우시법인(G620) Roll-out                                                                */
/***************************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/G" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>"/>
<tags-approval:approval-list-layout>
    <tags:script>
        <script>

            /**
             *
             */
            function beforeApproval() {

                var resultVal = true;

                //**************************************************************************************************************
                // 근무시간과 Duty신청시간의 중복체크.		2008-12-08		jungin		@v1.4 [C20081202_66724]

                $(".upmuType[value=07]:checked, upmuType[value=08]:checked").each(function() {
                    var $this = $(this);
                    var Obj = $this.siblings(".BUKRS").val();
                    var ObBG = $this.siblings(".BEGUZ").val();
                    var ObED = $this.siblings(".ENDUZ").val();
                    var ObOB = $this.siblings(".OBEGUZ").val();
                    var ObOE = $this.siblings(".OENDUZ").val();
                    var ObTR = $this.siblings(".TPROG").val();

                    var $approvalSeq = $this.siblings(".approvalSeq");

                    // Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청  	2011-01-19		liukuo		@v1.8 [C20110118_09919]
                    if(Obj.value == "G110" || Obj.value == "G280" || Obj.value == "G370"){	// 다구.보하이법인

                        //******************************************************************************
                        if((ObBG.value != '' && ObED.value != '') && ObTR.value == "ODAY"){

                            //check whether overtime overlaps work time
                            if(ObOB.value < ObOE.value){
                                if(ObBG.value != ''){
                                    if(ObBG.value < ObOE.value && ObBG.value > ObOB.value){
                                        alert('<spring:message code="MSG.G.G01.0001" />'); //Duty time overlaps with working time , please enter right time period.
                                        $approvalSeq.prop("checked", false);
                                        resultVal = false;
                                    }
                                    if(ObED.value > ObOB.value && ObED.value < ObOE.value){
                                        alert('<spring:message code="MSG.G.G01.0001" />'); //Duty time overlaps with working time , please enter right time period.
                                        $approvalSeq.prop("checked", false);
                                        resultVal = false;
                                    }
                                    if(ObED.value >= ObOE.value && ObBG.value <= ObOB.value){
                                        alert('<spring:message code="MSG.G.G01.0001" />'); //Duty time overlaps with working time , please enter right time period.
                                        $approvalSeq.prop("checked", false);
                                        resultVal = false;
                                    }
                                    if(ObED.value <= ObOB.value && ObBG.value <= ObOB.value && ObBG.value >= ObED.value){
                                        alert('<spring:message code="MSG.G.G01.0001" />'); //Duty time overlaps with working time , please enter right time period.
                                        $approvalSeq.prop("checked", false);
                                        resultVal = false;
                                    }
                                    if(ObED.value >= ObOE.value && ObBG.value >= ObOE.value && ObBG.value >= ObED.value){
                                        alert('<spring:message code="MSG.G.G01.0001" />'); //Duty time overlaps with working time , please enter right time period.
                                        $approvalSeq.prop("checked", false);
                                        resultVal = false;
                                    }
                                }
                            }
                            if(ObOB.value > ObOE.value){
                                if(ObBG.value != ''){
                                    if(ObBG.value >= ObOB.value || ObBG.value < ObOE.value){
                                        alert('<spring:message code="MSG.G.G01.0001" />'); //Duty time overlaps with working time , please enter right time period.
                                        $approvalSeq.prop("checked", false);
                                        resultVal = false;
                                    }
                                    if(ObED.value > ObOB.value || ObED.value <= ObOE.value){
                                        alert('<spring:message code="MSG.G.G01.0001" />'); //Duty time overlaps with working time , please enter right time period.
                                        $approvalSeq.prop("checked", false);
                                        resultVal = false;
                                    }
                                    if(ObBG.value >= ObED.value && ObED.value > ObOE.value && ObBG.value < ObOB.value){
                                        alert('<spring:message code="MSG.G.G01.0001" />'); //Duty time overlaps with working time , please enter right time period.
                                        $approvalSeq.prop("checked", false);
                                        resultVal = false;
                                    }
                                }
                            }
                        }
                        //******************************************************************************
                    }
                });
                //**************************************************************************************************************


                //********************************************************************
                // DAGU법인 누적 E_ANZHL 체크.		2008-11-26		jungin		@v1.2 [C20081125_62978]

                $(".upmuType[value=01]:checked").each(function() {
                    var $this = $(this);
                    var Obj = $this.siblings(".BUKRS").val();
                    var ObjG = $this.siblings(".E_PERSG").val();
                    var ObjK = $this.siblings(".E_PERSK").val();
                    var ObjL = $this.siblings(".E_ANZHL").val();
                    var ObjZ = $this.siblings(".STDAZ").val();

                    var $approvalSeq = $this.siblings(".approvalSeq");

                    if( frm.AINF_SEQN[i].checked ){
                        if(Obj.value == "G110" && ObjG.value == "B"){	// 다구법인
                            //alert(i + "   /   " + Obj.value + "   /  " + ObjG.value  + "   /  " +  ObjK.value );
                            if(ObjK.value == "31"){
                                //alert("공장직인 사람.");
                            }else{
                                if( (eval(ObjL.value) + eval(ObjZ.value)) > eval(36) ){
                                    alert('<spring:message code="MSG.G.G01.0002" />');  //Office Worker can't be over 36 hours of overtime.
                                    $approvalSeq.prop("checked", false);
                                    resultVal = false;
                                    return false;
                                }
                            }
                        }
                    }	// end if

                });

                <%-- [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 START--%>
                $(".approvalSeq:enabled:checked").each(function() {
                    var $this = $(this);
                    var Obj = $this.siblings(".BUKRS").val();
                    var ObjG = $this.siblings(".E_PERSG").val();
                    var ObjK = $this.siblings(".E_PERSK").val();
                    var ObjL = $this.siblings(".E_ANZHL").val();
                    var ObjZ = $this.siblings(".STDAZ").val();

                    var $approvalSeq = $this.siblings(".approvalSeq");
                    var Obj46Over = $this.siblings(".E_46OVER_NOT_APPROVAL").val(); //2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한
                    var Obj7Over = $this.siblings(".E_7OVER_NOT_APPROVAL").val(); //2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한
                    var ObjUP = $this.siblings(".UPMU_NAME").val();
                    var ObjAI = $this.siblings(".AINF_SEQN").val();
                    var ObjCNT = $this.siblings(".statusCount").val();
                  if (Obj46Over =="E"){
            	 		alert("<spring:message code="MSG.D.D01.0109"/> =>"+"<spring:message code="LABEL.G.G01.0001" />  "+ObjCNT);//Your overtime hours of this payroll period are over 46 hours.
            	 		$("input:checkbox[name='approvalSeq']:checkbox[value='"+ObjAI+"']").prop("checked", false);
                        resultVal = false;
                        //return false;
            	 	}	// end if
            	 	<%--[CSR ID:3359686] 审批日期限制   남경 결재 5일제어 START--%>
                  if (Obj7Over =="E"){
          	 		alert("<spring:message code="MSG.D.D01.0108"/> =>"+"<spring:message code="LABEL.G.G01.0001" />  "+ObjCNT);//It needs to be approved in 5 working days.
          	 		$("input:checkbox[name='approvalSeq']:checkbox[value='"+ObjAI+"']").prop("checked", false);
                      resultVal = false;
                       //return false;
          	 		}	// end if
                  <%--[CSR ID:3359686] 审批日期限制   남경 결재 5일제어 END--%>
                  }	// end if
                );
                <%-- [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 END--%>
                return resultVal;
            }

        </script>
    </tags:script>

    <table class="listTable">
		<!-- 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out  start-->
		<!-- 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out -->
        <c:set var="lastCol" value="${user.companyCode != 'G110' && user.companyCode != 'G280' && user.companyCode != 'G370' && user.companyCode != 'G180' && user.companyCode != 'G570' && user.companyCode != 'G570' && user.companyCode != 'G620' ? 'lastCol' : ''}"/>
        <!-- 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out  end-->
        <c:set var="colCount" value="9"/>
        <thead>
            <tr>
                <th><input type="checkbox" id="allCheck" onClick = "checkAll(this.checked)"></th>
                <th><spring:message code="LABEL.G.G01.0001" /><!-- 순번 --></th>
                <th><spring:message code="LABEL.G.G01.0002" /><!-- Item --></th>
                <th><spring:message code="MSG.APPROVAL.0015" /><!-- 부서 --></th>
                <th><spring:message code="LABEL.G.G01.0003" /><!-- 신청자 --></th>
                <th><spring:message code="LABEL.G.G01.0004" /><!-- 신청일 --></th>

                <th><spring:message code="LABEL.G.G01.0005" /><!-- Appl.Date --></th>
                <th><spring:message code="LABEL.G.G01.0006" /><!-- Appl.period<br>(Hours/Days)--></th>
                <th class="${lastCol}"><spring:message code="LABEL.G.G01.0007" /><!-- Reason --></th>
                <c:if test="${user.companyCode == 'G280'}">
                    <c:set var="colCount" value="11"/>
                    <th><spring:message code="LABEL.G.G01.0008" /><!-- Duty Type --></th>
                </c:if>
                <!-- 2018-03-12 KDM @PJ.광저우 법인(G570) Roll-Out -->
                <!-- 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out -->
                <c:if test="${user.companyCode == 'G110' || user.companyCode == 'G280' || user.companyCode == 'G370' || user.companyCode == 'G180' || user.companyCode == 'G570' || user.companyCode == 'G620'}">
                    <c:set var="colCount" value="${colCount == '11' ? colCount : '10'}"/>
                    <th class="lastCol"><spring:message code="LABEL.G.G01.0009" /><!-- Act. Time --></th>
                </c:if>
            </tr>
        </thead>


        <c:set var="rowCount" value="0"/>

            <%--@elvariable id="resultList" type="java.util.Vector<hris.G.G001Approval.ApprovalDocList>"--%>
            <%--@elvariable id="g" type="com.common.Global"--%>
            <%--@elvariable id="pu" type="com.sns.jdf.util.PageUtil"--%>
        <c:forEach var="row" items="${resultList}" varStatus="status" begin="${pu.from}" end="${pu.to > 0 ? pu.to - 1 : pu.to}">
            <c:set var="rowCount" value="${status.count}"/>
            <tr id="row_${status.index}" class="${f:printOddRow(status.index)}" data-type="${row.UPMU_TYPE}" data-pernr="${row.PERNR}"  data-seq="${row.AINF_SEQN}" >
                <td >
                    <input type="checkbox" class="approvalSeq" name="approvalSeq" value="${row.AINF_SEQN}"  ${f:isMultiApproval(g.sapType, row.UPMU_TYPE, row.APPU_TYPE, row.APPR_SEQN) ? "" : "disabled"}>

                    <input type="hidden" class="AINF_SEQN" name="AINF_SEQN" value="${row.AINF_SEQN}" >
                    <input type="hidden" class="BUKRS" name="BUKRS" value = "${row.BUKRS}">
                    <input type="hidden" class="PERNR" name="PERNR" value = "${row.PERNR}">
                    <input type="hidden" name="ENAME" value = "${row.ENAME}">
                    <input type="hidden" name="BEGDA" value = "${f:printDate(row.BEGDA)}">
                    <input type="hidden" name="UPMU_FLAG" value = "${row.UPMU_FLAG}">
                    <input type="hidden" class="UPMU_TYPE" name="UPMU_TYPE" value = "${row.UPMU_TYPE}">
                    <input type="hidden" class="UPMU_NAME" name="UPMU_NAME"  value = "${row.UPMU_NAME}">
                    <input type="hidden" name="APPR_TYPE" value = "${row.APPR_TYPE}">
                    <input type="hidden" name="APPU_TYPE" value = "${row.APPU_TYPE}">
                    <input type="hidden" name="APPR_SEQN" value = "${row.APPR_SEQN}">

                    <input type="hidden" name="OBJID"     value = "${row.OBJID}">
                    <input type="hidden" name="APPU_NUMB" value = "${row.APPU_NUMB}">
                    <input type="hidden" name="APPR_STAT" value = "">
                    <input type="hidden" name="APPR_DATE" value = "${f:printDate(row.APPL_DATE) }">
                    <!-- 2012-10-12 dongxiaomian	@v1.9 [C20120921_87982] begin  ????? -->

                    <%--<input type="hidden" class="BEGUZ" name="BEGUZ" value = "${row.BEGUZ}">--%>
                    <%--<input type="hidden" class="ENDUZ" name="ENDUZ" value = "${row.ENDUZ}">--%>
                    <!-- 2012-10-12 dongxiaomian	@v1.9 [C20120921_87982] end  -->

<%--<c:choose>--%>
    <%--<c:when test="${row.BUKRS == 'G110' and row. UPMU_TYPE == '01'}">--%>
        <input type="hidden" class="E_BUKRS" name="E_BUKRS" 		value = "${row.personData.e_BUKRS}">
        <input type="hidden" class="E_PERSG" name="E_PERSG"		value = "${row.personData.e_PERSG}">
        <input type="hidden" class="E_PERSK" name="E_PERSK" 		value = "${row.personData.e_PERSK}">
        <input type="hidden" name="SHIFT" 		value = "${row.SHIFT}">
        <input type="hidden" class="E_ANZHL" name="E_ANZHL"		value = "${row.e_ANZHL}">
        <input type="hidden" class="STDAZ" name="STDAZ" 		value = "${row.d01OTData.STDAZ}">
        <%-- [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 START--%>
        <input type="hidden"  class="E_46OVER_NOT_APPROVAL" name="E_46OVER_NOT_APPROVAL" value = "${row.e_46OVER_NOT_APPROVAL}">
        <%-- [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 END--%>
        <%--[CSR ID:3359686] 审批日期限制   남경 결재 5일제어 START--%>
        <input type="hidden"  class="E_7OVER_NOT_APPROVAL" name="E_7OVER_NOT_APPROVAL" value = "${row.e_7OVER_NOT_APPROVAL}">
        <%--[CSR ID:3359686] 审批日期限制   남경 결재 5일제어 END--%>
    <%--</c:when>--%>
    <%--<c:otherwise>--%>
        <%--<input type="hidden" name="E_BUKRS" 					value = "">--%>
        <%--<input type="hidden" name="E_PERSG"	value = "">--%>
        <%--<input type="hidden" name="E_PERSK" 	value = "">--%>
        <%--<input type="hidden" name="SHIFT" 		value = "">--%>
        <%--<input type="hidden" name="E_ANZHL" 	value = "">--%>
        <%--<input type="hidden" name="STDAZ" 		value = "">--%>
    <%--</c:otherwise>--%>
<%--</c:choose>--%>
                    <input type="hidden" class="BEGUZ" name="BEGUZ" 		value = "${f:printTime(row.d19DutyData.BEGUZ)}">
                    <input type="hidden" class="ENDUZ" name="ENDUZ" 		value = "${f:printTime(row.d19DutyData.ENDUZ)}">
                    <input type="hidden" class="OBEGUZ" name="OBEGUZ" 	value = "${f:printTime(row.d19DutyData.BEGUZ1)}">
                    <input type="hidden" class="OENDUZ" name="OENDUZ" 	value = "${f:printTime(row.d19DutyData.ENDUZ1)}">
                    <input type="hidden" class="TPROG" name="TPROG" 		value = "${f:printTime(row.d19DutyData.TPROG1)}">
                     <input type="hidden" class="statusCount" name="statusCount" 		value = "${pu.from + status.count}">
                </td>
                <td>${pu.from + status.count}</td>
                <td style="cursor: pointer;" onClick="viewDetail(${status.index});">
                    ${row.UPMU_NAME}
                    <c:if test="${isLocal == true}">
                    <br>
                    ${row.AINF_SEQN}
                    </c:if>
                </td>
                <td class="align_left" style="cursor: pointer;" onClick="viewDetail(${status.index});">${row.STEXT}</td>
                <td>${row.ENAME}</td>
                <td>${f:printDate(row.BEGDA)}</td>
                <td>${f:printDate(row.APPL_DATE)}</td>
                <td>
                    <c:choose>
                        <c:when test="${fn:indexOf(row.UPMU_TYPE, '02') == '0'}">
                            ${f:printDate(row.APPL_TO)}<br>
                            <c:choose>
                                <c:when test="${f:parseFloat(row.ABRTG) >= 1}">
                                    (${row.ABRTG})
                                </c:when>
                                <c:otherwise>
                                    (${f:printTime(row.BEGUZ)}~${f:printTime(row.ENDUZ)})
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            ${f:printTime(row.BEGUZ)}~${f:printTime(row.ENDUZ)}
                        </c:otherwise>
                    </c:choose>
                </td>
                <td class="align_left ${lastCol}">${row.ZREASON }</td>

                <c:if test="${user.companyCode == 'G280'}">
                    <td>${row.DUTY_TXT }</td>
                </c:if>
                <!-- 2018-03-12 KDM @PJ.광저우 법인(G570) Roll-Out start-->
                <!-- 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out -->
                <c:if test="${user.companyCode == 'G110' || user.companyCode == 'G280' || user.companyCode == 'G370' || user.companyCode == 'G180' || user.companyCode == 'G570' || user.companyCode == 'G620'}">
                <!-- 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out  end-->
                    <c:if test="${row.UPMU_TYPE == '01' || row.UPMU_TYPE == '02' || row.UPMU_TYPE == '07' || row.UPMU_TYPE == '08' }">
                        <c:set var="actTime" value="${row.actTime}"/>
                    </c:if>
                    <td class="lastCol">${actTime}</td>
                </c:if>
                </tr>
        </c:forEach>
        <c:if test="${f:getSize(resultList) <= pu.from}">
            <tags:table-row-nodata list="${resultList}" col="${colCount}" />
        </c:if>
        <input type="hidden" name="rowCount" value="${rowCount}"/>

    </table>
</tags-approval:approval-list-layout>

<%--






<%@ page import="java.util.Vector" %>
<%@ page import="hris.G.G001Approval.*"%>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D01OT.D01OTData" %>
<%@ page import="hris.D.D01OT.rfc.D01OTRFC" %>
<%@ page import="hris.D.D19Duty.D19DutyData" %>
<%@ page import="hris.D.D19Duty.rfc.D19DutyEntryRFC" %>
<%@ page import="hris.D.D19Duty.rfc.D19DutyRFC" %>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.AppUtil" %>
<%@ page import="hris.D.D01OT.rfc.D010TOvertimeGlobalRFC" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");

    Vector vcApprovalDocList = (Vector)request.getAttribute("vcApprovalDocList");
    ApprovalListKey alk = (ApprovalListKey)request.getAttribute("ApprovalListKey");

    Vector vcUpmucode = (new UpmuCodeRFC()).getUpmuCode(user.companyCode, user.empNo);

	String E_BUKRS = user.companyCode;
    String paging = (String)request.getAttribute("page");

    //PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    try {
        pu = new PageUtil(vcApprovalDocList.size(), paging , 10, 10);
        Logger.debug.println(this, "page : "+paging);
    } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
    }
%>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/prototype.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
    var isChecked = false;

	function MM_preloadImages() { //v3.0
	  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

    //메시지
    function show_waiting_smessage(div_id ,message)
    {
        // alert(document.body.scrollLeft + "\t ," + document.body.scrollTop);
        var _x = document.body.clientWidth/2 + document.body.scrollLeft-120;
        var _y = document.body.clientHeight/2 + document.body.scrollTop-100;
        job_message.innerHTML = message;
        document.all[div_id].style.posLeft=_x;
        document.all[div_id].style.posTop=_y;
        document.all[div_id].style.visibility='visible';
    }

	function allSetValue(value) {
	    frm  = document.form1;
	    var i = 0;

	       if($(".approvalSeq").length > 1){
		        for (i = 0 ; i < parseInt($(".approvalSeq").length ,10) ; i ++ ) {
		             //Obj = eval("frm.AINF_SEQN" +i);
		             Obj = frm.AINF_SEQN[i];
		             if (!Obj.disabled && value == true) {
		                frm.checkIndex[i].value =  "ON";
		                Obj.checked = value;
		             }else{
		             	frm.checkIndex[i].value =  "OFF";
		                Obj.checked = value;
		             }
		        } // end for
	       }else if($(".approvalSeq").length <= 1){
	        Obj = frm.AINF_SEQN;
	             if (!Obj.disabled && value == true) {
	                frm.checkIndex.value =  "ON";
	                Obj.checked = value;
	             }else{
	             	frm.checkIndex.value =  "OFF";
	                Obj.checked = value;
	             }
	       }
	 }

	function setValue(state)
	{
	   frm  = document.form1;
	   var isSave = false;
	   var i = 0;

	   if($(".approvalSeq").length > 1){
		   for (i = 0 ; i < parseInt($(".approvalSeq").length ,10) ; i ++ ) {
			   //if (eval("frm.AINF_SEQN" +i+".checked") ){
		       if (frm.AINF_SEQN[i].checked){
		           Obj = eval("frm.APPR_STAT" +i);
		           Obj.value = state;
		           isSave = true;
		       } // end if
		   } // end for
	    }else if($(".approvalSeq").length <= 1){
		       if (frm.AINF_SEQN.checked){
		           Obj = eval("frm.APPR_STAT" +i);
		           Obj.value = state;
		           isSave = true;
		       } // end if
	    }
	   return isSave;
	}



    function delselect()
    {
	   frm  = document.form1;
	   var i = 0;

		 if($(".approvalSeq").length > 1){
			 for (i = 0 ; i < parseInt(document.form1.rowCount.value ,10) ; i ++ ) {
				   //eval("frm.AINF_SEQN" +i).checked = false;
				   //document.form1.AINF_SEQN[i].checked = false;
				   //document.form1.checkIndex[i].value =  "OFF";

				   frm.checkIndex[i].value =  "OFF";
				   frm.AINF_SEQN[i].checked = false;
				   frm.chkbox.checked = false;
			 }
		 }else if($(".approvalSeq").length <= 1){
				   frm.checkIndex.value =  "OFF";
				   frm.AINF_SEQN.checked = false;
				   frm.chkbox.checked = false;
		 }
    }

    function approval()	// 일괄결재
	{
	   if(!setValue("A")) {
	       alert("Please choose the application you would like to deal with.");
	       return;
	   } // end if
	   //2016-04-19 pang xiaolin @v2.2 [C20160324_18938]全法人增加leave的批量审批功能 start
	  // if(!setValue2("02")) {
	  //     alert("Can't approve a batch of leave.");
	  //   delselect();
	  //   return;
	  // } // end if
	   //2016-04-19 pang xiaolin @v2.2 [C20160324_18938]全法人增加leave的批量审批功能 end
	   if(!setValue2("03")) { // bank account
	       alert("Can't approve a batch of bank account.");
		   delselect();
	       return;
	   } // end if
	   if(!setValue2("04")) { // License $ Certificate
	       alert("Can't approve a batch of license & certificate.");
		   delselect();
	       return;
	   } // end if
	   if(!setValue2("06")) {	// Celebration & Condolence
	       alert("Can't approve a batch of celebration & condolence");
		   delselect();
	       return;
	   } // end if

	  /*
	   **************************************************************
	  // Duty 일괄결제 가능도록 수정.	2008-04-10		jungin		@v1.0 [C20080407_46962]
	  if(!setValue2("07")||!setValue2("08")) {
	       alert("Can't approve a batch of duty.");
		   delselect();
	       return;
	   } // end if
	   **************************************************************
	   */


	   //**************************************************************************************************************
	   // 근무시간과 Duty신청시간의 중복체크.		2008-12-08		jungin		@v1.4 [C20081202_66724]
	   if(!setValue2("07")||!setValue2("08")) {
			var frm  = document.form1;
			var i = 0;

			if($(".approvalSeq").length > 1){
				for (i =  0; i < parseInt($(".approvalSeq").length, 10) ; i ++ ) {
					Obj		= eval("frm.BUKRS" +i);
					ObBG		= eval("frm.BEGUZ" +i);
					ObED		= eval("frm.ENDUZ" +i);
					ObOB		= eval("frm.OBEGUZ" +i);
					ObOE		= eval("frm.OENDUZ" +i);
					ObTR		= eval("frm.TPROG" +i);

					if( frm.AINF_SEQN[i].checked ){
					    // Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청  	2011-01-19		liukuo		@v1.8 [C20110118_09919]
						if(Obj.value == "G110" || Obj.value == "G280" || Obj.value == "G370"){	// 다구.보하이법인

						    //******************************************************************************
							 if((ObBG.value != '' && ObED.value != '') && ObTR.value == "ODAY"){

								//check whether overtime overlaps work time
								if(ObOB.value < ObOE.value){
									if(ObBG.value != ''){
										if(ObBG.value < ObOE.value && ObBG.value > ObOB.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN[i].checked = false;
											frm.checkIndex[i].value = "OFF";
										}
										if(ObED.value > ObOB.value && ObED.value < ObOE.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN[i].checked = false;
											frm.checkIndex[i].value = "OFF";
										}
										if(ObED.value >= ObOE.value && ObBG.value <= ObOB.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN[i].checked = false;
											frm.checkIndex[i].value = "OFF";
										}
										if(ObED.value <= ObOB.value && ObBG.value <= ObOB.value && ObBG.value >= ObED.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN[i].checked = false;
											frm.checkIndex[i].value = "OFF";
										}
										if(ObED.value >= ObOE.value && ObBG.value >= ObOE.value && ObBG.value >= ObED.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN[i].checked = false;
											frm.checkIndex[i].value = "OFF";
										}
									}
								}
								if(ObOB.value > ObOE.value){
								     if(ObBG.value != ''){
								       if(ObBG.value >= ObOB.value || ObBG.value < ObOE.value){
								       	    alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN[i].checked = false;
											frm.checkIndex[i].value = "OFF";
										}
								       if(ObED.value > ObOB.value || ObED.value <= ObOE.value){
								       	    alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN[i].checked = false;
											frm.checkIndex[i].value = "OFF";
										}
								       if(ObBG.value >= ObED.value && ObED.value > ObOE.value && ObBG.value < ObOB.value){
								       	    alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN[i].checked = false;
											frm.checkIndex[i].value = "OFF";
										}
									 }
								}
							}
						    //******************************************************************************
						}
					}	// end if
				}	// end for

		 	}else if($(".approvalSeq").length <= 1){
				for (i =  0; i < parseInt($(".approvalSeq").length, 10) ; i ++ ) {
						Obj		= eval("frm.BUKRS" +i);
						ObBG		= eval("frm.BEGUZ" +i);
						ObED		= eval("frm.ENDUZ" +i);
						ObOB		= eval("frm.OBEGUZ" +i);
						ObOE		= eval("frm.OENDUZ" +i);
						ObTR		= eval("frm.TPROG" +i);

					if( frm.AINF_SEQN.checked ){
						// Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청  	2011-01-19		liukuo		@v1.8 [C20110118_09919]
						if(Obj.value == "G110" || Obj.value == "G280" || Obj.value == "G370"){	// 다구.보하이법인

						    //******************************************************************************
							 if((ObBG.value != '' && ObED.value != '') && ObTR.value == "ODAY"){

								//check whether overtime overlaps work time
								if(ObOB.value < ObOE.value){
									if(ObBG.value != ''){
										if(ObBG.value < ObOE.value && ObBG.value > ObOB.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN.checked = false;
											frm.checkIndex.value = "OFF";
											frm.chkbox.checked = false;
											return;
										}
										if(ObED.value > ObOB.value && ObED.value < ObOE.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN.checked = false;
											frm.checkIndex.value = "OFF";
											frm.chkbox.checked = false;
											return;
										}
										if(ObED.value >= ObOE.value && ObBG.value <= ObOB.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN.checked = false;
											frm.checkIndex.value = "OFF";
											frm.chkbox.checked = false;
											return;
										}
										if(ObED.value <= ObOB.value && ObBG.value <= ObOB.value && ObBG.value >= ObED.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN.checked = false;
											frm.checkIndex.value = "OFF";
											frm.chkbox.checked = false;
											return;
										}
										if(ObED.value >= ObOE.value && ObBG.value >= ObOE.value && ObBG.value >= ObED.value){
											alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN.checked = false;
											frm.checkIndex.value = "OFF";
											frm.chkbox.checked = false;
											return;
										}
									}
								}
								if(ObOB.value > ObOE.value){
								     if(ObBG.value != ''){
								       if(ObBG.value >= ObOB.value || ObBG.value < ObOE.value){
								       	    alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN.checked = false;
											frm.checkIndex.value = "OFF";
											frm.chkbox.checked = false;
											return;
										}
								       if(ObED.value > ObOB.value || ObED.value <= ObOE.value){
								       	    alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN.checked = false;
											frm.checkIndex.value = "OFF";
											frm.chkbox.checked = false;
											return;
										}
								       if(ObBG.value >= ObED.value && ObED.value > ObOE.value && ObBG.value < ObOB.value){
								       	    alert('Duty time overlaps with working time , please enter right time period.');
											frm.AINF_SEQN.checked = false;
											frm.checkIndex.value = "OFF";
											frm.chkbox.checked = false;
											return;
										}
									 }
								}
							}
						    //******************************************************************************
						}
					}	// end if
				}	// end for
		    }

		 	//delselect();

	     	//return;
	   } // end if
	   //**************************************************************************************************************

	   if(!setValue2("11")) {	// Medical Expenses
	       alert("Can't approve a batch of medical expenses.");
		   delselect();
	       return;
	   } // end if
	   if(!setValue2("12")) {	// School Expenses
	       alert("Can't approve a batch of school expenses.");
		   delselect();
	       return;
	   } // end if
	   if(!setValue2("13")) {	// Language Expenses
	       alert("Can't approve a batch of language expenses.");
		   delselect();
	       return;
	   } // end if
	   if(!setValue2("15")) {	// Time Sheet (USA -LGCPI(G400))
	       alert("Can't approve a batch of Time Sheet.");
		   delselect();
	       return;
	   } // end if
	   if(!setValue2("16")) {	// Contract Extension (USA)
	       alert("Can't approve a batch of Contract Extension.");
		   delselect();
	       return;
	   } // end if

		//********************************************************************
		// DAGU법인 누적 E_ANZHL 체크.		2008-11-26		jungin		@v1.2 [C20081125_62978]
		if(!setValue2("01")) {		// OverTime
			var frm  = document.form1;
			var i = 0;

			if($(".approvalSeq").length > 1){
				for (i =  0; i < parseInt($(".approvalSeq").length, 10) ; i ++ ) {
						Obj		= eval("frm.BUKRS" +i);
						ObjG		= eval("frm.E_PERSG" +i);
						ObjK		= eval("frm.E_PERSK" +i);
						ObjL		= eval("frm.E_ANZHL" +i);
						ObjZ		= eval("frm.STDAZ" +i);

					if( frm.AINF_SEQN[i].checked ){
						if(Obj.value == "G110" && ObjG.value == "B"){	// 다구법인
							//alert(i + "   /   " + Obj.value + "   /  " + ObjG.value  + "   /  " +  ObjK.value );

							if(ObjK.value == "31"){
								//alert("공장직인 사람.");
							}else{
								if( (eval(ObjL.value) + eval(ObjZ.value)) > eval(36) ){
									alert("Office Worker can't be over 36 hours of overtime.");
									frm.AINF_SEQN[i].checked = false;
									check(i);
									return;
								}
							}
						}
					}	// end if
				}	// end for

		 	}else if($(".approvalSeq").length <= 1){
				for (i =  0; i < parseInt($(".approvalSeq").length, 10) ; i ++ ) {
						Obj		= eval("frm.BUKRS" +i);
						ObjG		= eval("frm.E_PERSG" +i);
						ObjK		= eval("frm.E_PERSK" +i);
						ObjL		= eval("frm.E_ANZHL" +i);
						ObjZ		= eval("frm.STDAZ" +i);

					if( frm.AINF_SEQN.checked ){
						if(Obj.value == "G110" && ObjG.value == "B"){	// 다구법인
							if(ObjK.value == "31"){
								//alert("공장직인 사람.");
							}else{
								if( (eval(ObjL.value) + eval(ObjZ.value)) > eval(36) ){
									alert("Office Worker can't be over 36 hours of overtime.");
									frm.AINF_SEQN.checked = false;
									check(i);
									return;
								}
							}
						}
					}	// end if
				}	// end for
		    }

	   } // end if
	   //********************************************************************

		if(!confirm("Are you sure to approve?")) {
			delselect();
			return;
		} // end if

	   buttonDisabled();
	   show_waiting_smessage("waiting","Now approving..Please wait for a moment!");
	   var queryString = "";
	   queryString = "?BEGDA=<%=alk.I_BEGDA%>";
	   queryString = queryString + "|ENDDA=<%=alk.I_ENDDA%>";
	   queryString = queryString + "|UPMU_TYPE=<%=alk.I_UPMU_TYPE%>";
	   queryString = queryString + "|page=<%=pu.getPrivePage()%>";
	   queryString = queryString + "|jobid=search";


	   document.form1.RequestPageName.value = queryString;

	   document.form1.jobid.value = "save";
	   document.form1.action = '<%= WebUtil.ServletURL %>hris.G.G001ApprovalDocListSV';
       document.form1.submit();
	}

    //********************************************************************
	// 일괄결재시 근태마감일 flag check.		2008-06-18		jungin		@v1.1 [C20080606_78689]

	 function check(index){
	 	var frm2 = document.form1;
	    var i = 0;

		// frm2로 수정	2008-11-21		jungin
		if($(".approvalSeq").length > 1){
			for (i = 0 ; i < parseInt($(".approvalSeq").length ,10) ; i ++ ) {
				   //Obj = eval("frm.AINF_SEQN" +i);
				   //Obj = frm2.AINF_SEQN[i];
				   if (frm2.AINF_SEQN[i].checked) {
						frm2.checkIndex[i].value =  "ON";
				   } else{
						frm2.checkIndex[i].value =  "OFF";
				   }// end if
			} // end for
		}else if($(".approvalSeq").length <= 1){
					if (frm2.AINF_SEQN.checked) {
						frm2.checkIndex.value =  "ON";
				   } else{
						frm2.checkIndex.value =  "OFF";
				   }// end if
		}
	}


    //********************************************************************

	function doSubmit()
	{
		if(!dateFormat(document.form1.BEGDA))
			return ;
		if(!dateFormat(document.form1.ENDDA))
	    	return ;
	    var str=/\d{8}/;
 	    var text = document.form1.APPL_PERNR.value;
	    text = rtrim(ltrim(text));

	    if(document.form1.APPL_PERNR.value.length != 0){
		   if(!str.test(document.form1.APPL_PERNR.value))
			{
			  alert("Please input eight numerals.");
			  document.form1.APPL_PERNR.focus();
			   return;
			}
	    }
		if(changeChar( document.form1.BEGDA.value, ".", "" )>changeChar( document.form1.ENDDA.value, ".", "" )){
			alert("Please input right date.");
			document.form1.ENDDA.focus();
			return;
		}

	    show_waiting_smessage("waiting","Now searching.. Please wait for a moment!");
		document.form1.BEGDA.value = changeChar( document.form1.BEGDA.value, ".", "" );
		document.form1.ENDDA.value = changeChar( document.form1.ENDDA.value, ".", "" );
		document.form1.jobid.value = "search";
		document.form1.action = '<%= WebUtil.ServletURL %>hris.G.G001ApprovalDocListSV';
		document.form1.submit();
	}

	function viewDetail(UPMU_TYPE, AINF_SEQN, APPL_PERNR)
	{
	    var queryString = "";
        queryString = "?BEGDA=<%=alk.I_BEGDA%>";
        queryString = queryString + "|ENDDA=<%=alk.I_ENDDA%>";
        queryString = queryString + "|UPMU_TYPE=<%=alk.I_UPMU_TYPE%>";
        //queryString = queryString + "|UPMU_TYPE="+UPMU_TYPE;
        queryString = queryString + "|page=<%=pu.getPrivePage()%>";
        queryString = queryString + "|APPL_PERNR=<%=alk.I_APPL_PERNR%>" ;
        queryString = queryString + "|jobid=search";

	    document.form2.AINF_SEQN.value = AINF_SEQN;
	    document.form2.RequestPageName.value = "<%= WebUtil.ServletURL %>hris.G.G001ApprovalDocListSV"
	       + queryString;

	    document.form2.jobid.value = "search";
	    document.form2.action = '<%= WebUtil.ServletURL %>hris.G.G000ApprovalDocMapSV';

	    document.form2.submit();
	}

	// 달력 사용 시작
	function fn_openCal(Objectname)
	{
	   var lastDate;

	   lastDate = eval("document.form1." + Objectname + ".value");
	   small_window  = window.open("/web/common/calendar.jsp?formname=form1&fieldname="+ Objectname + "&curDate=" + lastDate + "&iflag=0&optionvalue=","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=285,top=" + document.body.clientHeight/2 + ",left=" + document.body.clientWidth/2);
	   small_window.focus();
	}
	// 달력 사용 끝

	// PageUtil 관련 script - page처리시 반드시 써준다...
	function pageChange(page)
	{
	  document.form1.page.value = page;
	  doSubmit();
	}

	// PageUtil 관련 script - selectBox 사용시 - Option
	function selectPage(obj)
	{
	  val = obj[obj.selectedIndex].value;
	  pageChange(val);
	}

	function EnterCheck()
	{
		if(event.keyCode == 13){
			doSubmit();
		}
	}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!---- waiting message start-->
<DIV id="waiting" style="Z-INDEX: 1; LEFT: 50px; VISIBILITY: hidden; WIDTH: 300px; POSITION: absolute; TOP: 120px; HEIGHT: 104px">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" align="left" valign="top"><img src="<%= WebUtil.ImageURL %>message_top.gif" width="300" height="9" /></td>
    </tr>
  <tr>
    <td width="19%" align="left" valign="top"><img src="<%= WebUtil.ImageURL %>message_left.gif" width="58" height="86" /></td>
    <td width="81%" align="left" valign="top" background="<%= WebUtil.ImageURL %>message_right.gif"  style="padding-top:30px;line-height:18px;">
	<span style=" font-family:Arial;font-size:9pt;color:#999999;" id = "job_message">Searching now... Please wait for a while.Searching now... Please wait for a .</span></td>
  </tr>
  <tr>
    <td colspan="2" align="left" valign="top"><img src="<%= WebUtil.ImageURL %>message_bottom.gif" width="300" height="9" /></td>
    </tr>
</table>
</DIV>
<!---- waiting message end-->

<form name="form1" method="post" action="">
<input type="hidden" name="RequestPageName" >
<input type="hidden" name="jobid" value="">
<input type="hidden" name="GUBUN" value="<%=alk.GUBUN%>">

  <table width="1045" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="1025" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="1025" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif" />Requested Document </td>
                  <td align="right"><a href="javascript:open_help('Approval.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"><img name="Image6" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="Guide"></a></td>
                </tr>
              </table></td>
          </tr>
          <tr><td height="3" align="left" valign="top" background="/web/images/maintitle_line.gif"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
            <td>
              <!--  검색테이블 시작 -->
              <table width="780" border="0" cellpadding="0" cellspacing="1" class="table02">
                <tr>
                  <td width="120" class="td03">Item</td>
                  <td width="200" class="td09">
                    <select name="UPMU_TYPE" class="input03" >
                      <option value="">Select</option>
                      <%= WebUtil.printOption(vcUpmucode, alk.I_UPMU_TYPE) %>
                    </select>
                  </td>
                  <td width="120" class="td03">Pers.No.</td>
                  <td class="td09">
                    <input type="text" name="APPL_PERNR" value="<%=alk.I_APPL_PERNR%>" size="6" maxlength = "8" class="input03" onkeypress="EnterCheck();">
                  </td>
                </tr>
                <tr>
                  <td class="td03">Appl.Date</td>
                  <td class="td09" colspan="3"><table border="0" cellspacing="0" cellpadding="0">
                  <input name="PERNR" type="hidden" size="11" maxlenth="10" value="<%= alk.I_PERNR %>">
                      <tr>
                        <td><input name="BEGDA" type="text" size="7" maxlenth="10" class="input03" value="<%=WebUtil.printDate(alk.I_BEGDA) %>" onkeypress="EnterCheck();" onblur="dateFormat(this);"></td>
                        <td width="2">&nbsp;</td>
                        <td><a href="javascript:fn_openCal('BEGDA')"><img src="<%= WebUtil.ImageURL %>icon_diary.gif" alt="" border="0"></a></td>
                        <td width="5">&nbsp;</td>
                        <td>~</td>
                        <td width="5">&nbsp;</td>
                        <td><input name="ENDDA" type="text"  size="7" maxlenth="10" class="input03" value="<%=WebUtil.printDate(alk.I_ENDDA) %>" onkeypress="EnterCheck();" onblur="dateFormat(this);"></td>
                        <td width="2">&nbsp;</td>
                        <td><a href="javascript:fn_openCal('ENDDA')"><img src="<%= WebUtil.ImageURL %>icon_diary.gif" alt="" border="0"></a></td>
                        <td width="5">&nbsp;</td>
                        <td width="10">&nbsp;</td>
                        <td style="text-align:right;"><a href="javascript:doSubmit()"><img src="<%= WebUtil.ImageURL %>btn_serch02.gif" border="0"></a></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!--  검색테이블 끝-->
            </td>
          </tr>
          <!-- 총 몇건 시작-->
          <tr>
            <td class="td08"><%= vcApprovalDocList.size() > 0? (pu == null ? "" : pu.pageInfo()) : "&nbsp;" %></td>
          </tr>
          <!-- 총 몇건 끝-->
          <tr>
            <td>
              <!-- 리스트테이블 시작 -->
              <table width="855" border="0" cellpadding="0" cellspacing="1" class="table02">
                <tr>
                  <td width="30" class="td03">
                    <input type="checkbox" name="chkbox" onClick = "allSetValue(this.checked)">
                  </td>
                  <td width="30" class="td03" align="center">No.</td>
                  <td width="75" class="td03" align="center">Item</td>
                  <td width="280" class="td03" align="center">Org.Unit</td>
                  <td width="75" class="td03"  align="center">Name</td>
                  <td width="75" class="td03"  align="center">Requst Date</td>
                  <td width="75" class="td03"  align="center">Appl.Date</td>
                  <td width="75" class="td03"  align="center">Appl.period<br>(Hours/Days)</td>
                  <td width="100" class="td03"  align="center">Reason</td>
                  <%
		  //2016-04-06 pang xiaolin @v2.1 [C20160328_22012]G280法人在审批list画面中增加duty type start
		  if(E_BUKRS.equals("G280")){ %>
                  <td width="75" class="td03"  align="center">Duty Type</td>
                  <%}
		  //2016-04-06 pang xiaolin @v2.1 [C20160328_22012]G280法人在审批list画面中增加duty type end %>

                  <% if(E_BUKRS.equals("G110") || E_BUKRS.equals("G280") || E_BUKRS.equals("G370")|| E_BUKRS.equals("G180")){  // Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청  	2011-01-19		liukuo		@v1.8 [C20110118_09919]%>
                  <td width="180" class="td03"  align="center">Act. Time</td>
                  <% } %>

                </tr>
              <%
                if(vcApprovalDocList.size() > 0){

                for( int i = pu.formRow() ; i < pu.toRow(); i++ ) { %>
                <% ApprovalDocList apl = (ApprovalDocList)vcApprovalDocList.get(i);%>
                <% int index = i - pu.formRow();%>

              <%
              		} // end for
               }else{
              %>
              <!-- 2016-04-06 pang xiaolin @v2.1 [C20160328_22012]G280法人在审批list画面中增加duty type start -->
                <tr>
                   <td colspan="11">No data</td>
                </tr>
              <!-- 2016-04-06 pang xiaolin @v2.1 [C20160328_22012]G280法人在审批list画面中增加duty type end -->

              <%} //end if%>

               <input type="hidden" name="rowCount" value = "<%=pu.toRow() - pu.formRow()%>">
              </table>
              <!-- 리스트테이블 끝-->
            </td>
          </tr>
          <tr>
            <td>
			<!-- 이동아이콘 테이블 시작 -->
			<table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td style="padding-top:10px"><input type="hidden" name="page" value="">
					<%= pu == null ? "" : pu.pageControl() %>
                  </td>
                </tr>
              </table>
			  <!-- 이동아이콘 테이블 끝 -->
			</td>
          </tr>

          <tr>
            <td>
			<!--결재버튼 들어가는 테이블 시작 -->
			<table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td>
                    <span id="sc_button">

                    <% if(vcApprovalDocList.size() > 0){ %>

                       <a href="javascript:approval()"><img src="<%= WebUtil.ImageURL %>btn_Decision.gif" border="0"></a>&nbsp;

                    <% } %>

                    &nbsp;&nbsp;
                    </span>
                  </td>
                </tr>
              </table>
			  <!--결재버튼 들어가는 테이블 끝 -->
			</td>
          </tr>
          <tr height="10"><td></td></tr>

        </table></td>
    </tr>
  </table>
  </form>
  <form name="form2" method="post">
    <input type="hidden" name="AINF_SEQN">
    <input type="hidden" name="isEditAble" value="false">
    <input type="hidden" name="RequestPageName">
    <input type="hidden" name="jobid">
  </form>
</body>
</html>

<%!

  // private String isCanBlock(ApprovalDocList apl)
  //  {
  //      String retValue = "disabled";

  //      if (apl.UPMU_TYPE.equals("17") || apl.UPMU_TYPE.equals("18") || apl.UPMU_TYPE.equals("23")) {
  //          retValue = "";
  //      } else if (apl.APPU_TYPE.equals("02") && apl.APPR_SEQN.equals("02")) {
   //         retValue = "";
  //      } // end if
 //       return retValue;
 //   }

%>--%>


