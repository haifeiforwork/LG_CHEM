<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 조회                                                 */
/*   Program ID   : E17HospitalDetail.jsp                                       */
/*   Description  : 의료비를 조회할 수 있도록 하는 화면                         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김성일                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                  2005-12-26  @v1.1 C2005121301000001097 신용카드/현금구분추가*/
/*                  2006-01-19  @v1.2 연말정산제외 제거 연말정산반영액추가      */
/*					 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건*/
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="medi_count" value="${f:getSize(E17HospitalData_vt)}" />

<%--@elvariable id="g" type="com.common.Global"--%>
<%--@elvariable id="e17SickData" type="hris.E.E17Hospital.E17SickData"--%>
<%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
<c:set var="buttonBody" value="${g.bodyContainer}"/>

<c:set var="msg40" value="<%=g.getMessage("LABEL.E.E18.0040")%>"/>
<c:set var="msg41" value="<%=g.getMessage("LABEL.E.E18.0041")%>"/>
<c:set var="msg42" value="<%=g.getMessage("LABEL.E.E18.0042")%>"/>

<tags:body-container bodyContainer="${buttonBody}">
    <c:if test="${!approvalHeader.finish}">
    <li><a onclick="go_print();" ><span><spring:message code="LABEL.E.E17.0020" /><!-- 의료비 지원 신청서 --></span></a></li>
    </c:if>
</tags:body-container>

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_MEDI_FEE" updateUrl="${g.servlet}hris.E.E17Hospital.E17HospitalChangeSV" button="${buttonBody}">
        <tags:script>
            <script language="JavaScript">
                <!--

                $(function() {
                    <c:if test="${param.afterRequest == 'true'}">
                        //  신청 후 조회된 경우 - 학자금ㆍ장학금 신청서를 먼저 띄워준다.
                        go_print();
                    </c:if>

                    multiple_won();
                    change_child();
                });


                /* 본인 실부담액 합계구하기 */
                function multiple_won() {
                    var hap = 0;
                    for( k = 0 ; k < ${fn:length(E17HospitalData_vt)} ; k++){
                        val = eval("removeComma(document.form1.EMPL_WONX"+k+".value)");
                        hap = hap + Number(val);
                    }
                    if( hap > 0 ) {
                        hap = pointFormat(hap, ${currencyValue});
                        document.form1.EMPL_WONX_tot.value = insertComma(hap+"");
                    }
                }

                function go_print(){
                    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=740,height=650,left=100,top=60");
                    document.form1.jobid.value = "print_hospital";
                    document.form1.AINF_SEQN.value = "${e17SickData.AINF_SEQN }";
                    document.form1.target = "essPrintWindow";
                    document.form1.action = '${g.servlet}hris.E.E17Hospital.E17HospitalDetailSV';
                    document.form1.method = "post";
                    document.form1.submit();
                }

                function go_bill_detail(){

                    var command = "";
                    var size = "";
                    flag = false;
                    if( isNaN( document.form1.radiobutton.length ) ){
                        size = 1;
                    } else {
                        size = document.form1.radiobutton.length;
                    }
                    for (var i = 0; i < size ; i++) {
                        if ( size == 1 ){
                            command = "0";
                            flag = true;
                        } else if ( document.form1.radiobutton[i].checked == true ) {
                            command = i+"";
                            flag = true;
                        }
                    }
                    if( ! flag ){
                        alert("<spring:message code='MSG.E.E17.0029' />"); //조회할 진료비계산서 항목을 먼저 선택하세요
                        return;
                    }
                    gubun = eval("document.form1.RCPT_CODE"+command+".value;");
                    if( gubun != "0002" ){//영수증 구분이 진료비계산서(0002) 가 아니면 에러
                        alert("<spring:message code='MSG.E.E17.0007' />"); //선택한 항목의 영수증은 진료비계산서가 아닙니다. \n\n  '영수증 구분'을 확인해 주세요
                        return;
                    }

                    for(var ii = 0 ; ii < ${fn:length(E17BillData_vt)} ; ii++){
                        val = eval("document.form1.RCPT_NUMB"+command+".value;");
                        x_val = eval("document.form1.x_RCPT_NUMB"+ii+".value;");
                        if(val == x_val){
                            document.form1.radio_index.value = ii+"";
                        }
                    }

                    document.form1.jobid.value = "detail_first";
                    document.form1.AINF_SEQN.value = "${e17SickData.AINF_SEQN }";
                    document.form1.action = '${g.servlet}hris.E.E17Hospital.E17BillControlSV';
                    document.form1.target = "menuContentIframe";
                    document.form1.method = "post";
                    document.form1.submit();
                }

                function change_child() {
                    <c:if test="${e17SickData.GUEN_CODE == '0003' and not empty e17SickData.REGNO}">
                    document.form1.REGNO_dis.value = "${f:printRegNo(e17SickData.REGNO, 'LAST')}";

                    var begin_date = removePoint(document.form1.BEGDA.value);
                    var d_datum    = addSlash("${e17SickData.DATUM_21}");

                    dif = dayDiff(addSlash(begin_date), d_datum);

                    if( dif < 0 ) {
                        document.form1.Message.value = document.form1.ENAME.value + "는 " + d_datum.substring(0,4) + "년 " + d_datum.substring(5,7) + "월 부터 자녀의료비지원 대상에서 제외되며, " + d_datum.substring(5,7) + "월 전월 의료비까지 지원 가능합니다."
                    }
                    </c:if>
                }
                //-->
            </script>
        </tags:script>



        <!-- 상단 입력 테이블 시작-->
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral  tableApproval">
                    <colgroup>
                        <col width="15%"/>
                        <col width="85%"/>
                    </colgroup>
                    <tr>
                        <th><spring:message code="LABEL.E.E18.0016" /><!-- 관리번호 --></th>
                        <td>
                            <input type="text" name="CTRL_NUMB"  value="${e17SickData.CTRL_NUMB }" size="20" readonly>
                            <input type="hidden" name="BEGDA"  value="${e17SickData.BEGDA }">

                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.E.E18.0017" /><!-- 구분 --></th>
                        <td>
                            <input type="text" name="GUEN_CODE"  value="${f:printOptionValueText(guenCodeList, e17SickData.GUEN_CODE)}" size="20" readonly>

                                <%--<%
                                    if( e17SickData.GUEN_CODE.equals("0002")||e17SickData.GUEN_CODE.equals("0003") ) {
                                %>
                                &nbsp;&nbsp;&nbsp;<input type="checkbox" name="PROOF" value="" size="20" ${e17SickData.PROOF.equals("X") ? "checked" : "checked" } >&nbsp;연말정산반영여부--%>
                            <c:if test="${e17SickData.GUEN_CODE == '0002' || e17SickData.GUEN_CODE == '0003' || e17SickData.GUEN_CODE == '0001'}" >
                                &nbsp;&nbsp;&nbsp;<input type="checkbox" name="PROOF" value="${e17SickData.PROOF}" size="20" ${e17SickData.PROOF == "X" ? "checked" : "" } disabled>&nbsp;<spring:message code="LABEL.E.E18.0021" /><!-- 연말정산반영여부 -->
                            </c:if>
                        </td>
                    </tr>
                    <!--@v1.3-->
                    <c:if test="${e17SickData.GUEN_CODE == '0003'}">
                        <tr>
                            <th><spring:message code="LABEL.E.E17.0011" /><!-- 자녀이름 --></th>
                            <td>
                                <input type="text" name="ENAME"     value="${e17SickData.ENAME }" size="14" readonly>
                                <input type="text" name="REGNO_dis" value="" size="14" readonly><br>
                                <input type="text" name="Message"   value="" size="100" readonly>
                            </td>
                        </tr>
                        <!--@v1.3-->
                    </c:if>
                    <tr>
                        <th><spring:message code="LABEL.E.E18.0022" /><!-- 진료과 --></th>
                        <td>
                        <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
							<c:choose>
                                <c:when test="${approvalHeader.PMANFL=='X' and empty approvalHeader.DMANFL and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                	<input type="hidden" name="TREA_CODE" value="${f:printOptionValueText(MedicTrea_vt, e17SickData.TREA_CODE)}">
                                </c:when>
                                <c:otherwise>
									<input type="text" name="TREA_CODE" value="${f:printOptionValueText(MedicTrea_vt, e17SickData.TREA_CODE)}" size="14" readonly>
                                </c:otherwise>
                            </c:choose>
                         <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>

                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.E.E17.0012" /><!-- 상병명 --></th>
                        <td>
                        <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
							<c:choose>
                                <c:when test="${approvalHeader.PMANFL=='X' and empty approvalHeader.DMANFL and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                	<input type="hidden" name="SICK_NAME" value="${e17SickData.SICK_NAME }" >
                                </c:when>
                                <c:otherwise>
									<input type="text" name="SICK_NAME" value="${e17SickData.SICK_NAME }" size="40" readonly>
                                </c:otherwise>
                            </c:choose>
                         <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.E.E18.0023" /><!-- 구체적증상 --></th>
                        <td>
                        <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
							<c:choose>
                                <c:when test="${approvalHeader.PMANFL=='X'  and empty approvalHeader.DMANFL and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                	<input type="hidden"  name="SICK_DESC"  value="${e17SickData.SICK_DESC1}${e17SickData.SICK_DESC2}${e17SickData.SICK_DESC3}${e17SickData.SICK_DESC4}">
                                </c:when>
                                <c:otherwise>
									<textarea name="SICK_DESC" wrap="VIRTUAL" cols="70" rows="4" readonly>${e17SickData.SICK_DESC1}${e17SickData.SICK_DESC2}${e17SickData.SICK_DESC3}${e17SickData.SICK_DESC4}</textarea>
                                </c:otherwise>
                            </c:choose>
                        <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                        </td>
                    </tr>
                    <c:if test="${approvalHeader.finish}">
                    <tr>
                        <th><spring:message code='LABEL.COMMON.0015' /><!-- 비고 --></th>
                        <td colspan="3">${e17SickData.BIGO_TEXT1}<br>${e17SickData.BIGO_TEXT2}</td>
                    </tr>
                    </c:if>
                </table>
            </div>
        </div>
       <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
               <c:if test="${approvalHeader.PMANFL=='X'  and empty approvalHeader.DMANFL and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                  <div class="commentsMoreThan2">
                     <div><spring:message code='MSG.E.E17.0030' /><!-- 개인정보보호 차원에서 배우자 및 자녀에 대한 진료세부사항을 제공하지 않습니다. --></div>
                   </div>
                </c:if>
       <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end--%>
        <!-- 상단 입력 테이블 시작-->
        <div class="listArea">
            <div class="table">
                <table class="listTable">
                    <thead>
                    <tr>
                        <c:if test="${!approvalHeader.finish}">
                        <th><spring:message code="LABEL.D.D03.0033" /><!-- 선택 --></th>
                        </c:if>
                        <th><spring:message code="LABEL.E.E18.0028" /><!-- 의료기관 --></th>
                        <th><spring:message code="LABEL.E.E17.0013" /><!-- 사업자등록번호 --></th>
                        <th><spring:message code="LABEL.E.E18.0030" /><!-- 전화번호 --></th>
                        <th><spring:message code="LABEL.E.E18.0031" /><!-- 진료일 --></th>
                        <th><spring:message code="LABEL.E.E17.0014" /><!-- 입원/외래 --></th>
                        <th><spring:message code="LABEL.E.E18.0033" /><!-- 영수증 구분 --></th>
                        <th><spring:message code="LABEL.E.E18.0034" /><!-- No. --></th>
                        <th><spring:message code="LABEL.E.E18.0035" /><!-- 결재수단 --></th>
                        <th><spring:message code="LABEL.E.E18.0036" /><!-- 본인 실납부액 --></th>
                        <th class="lastCol"><spring:message code="LABEL.E.E18.0037" /><!-- 연말정산 반영액 --></th>
                    </tr>
                    </thead>
                    <c:forEach var="e17HospitalData" items="${E17HospitalData_vt}" varStatus="status">
                        <tr class="${f:printOddRow(status.index)}">
                            <c:if test="${!approvalHeader.finish}">
                            <td>
                                <input type="radio" name="radiobutton" value="${status.index}" ${status.index == 0 ? "checked" : ""}>
                            </td>
                            </c:if>
                            <td>
                            <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
							<c:choose>
                                <c:when test="${approvalHeader.PMANFL=='X'  and empty approvalHeader.DMANFL and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                	<input type="hidden" name="MEDI_NAME${status.index}" value="${e17HospitalData.MEDI_NAME}" >
                                </c:when>
                                <c:otherwise>
									<input type="text" name="MEDI_NAME${status.index}" value="${e17HospitalData.MEDI_NAME}" size="16" readonly>
                                </c:otherwise>
                            </c:choose>
                            <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                            </td>
                            <td>
                            <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
                     			<c:choose>
                                <c:when test="${approvalHeader.PMANFL=='X'  and empty approvalHeader.DMANFL and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                	<input type="hidden" name="MEDI_NUMB${status.index}" value="${f:companyCode(e17HospitalData.MEDI_NUMB)}" size="11" maxlength="12" readonly>
                                </c:when>
                                <c:otherwise>
									<input type="text" name="MEDI_NUMB${status.index}" value="${f:companyCode(e17HospitalData.MEDI_NUMB)}" size="11" maxlength="12" readonly>
                                </c:otherwise>
                            </c:choose>
                            <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                            </td>
                            <td>
                            <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
							<c:choose>
                                <c:when test="${approvalHeader.PMANFL=='X'   and empty approvalHeader.DMANFL and (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                	<input type="hidden" name="TELX_NUMB${status.index}" value="${e17HospitalData.TELX_NUMB}" size="12" maxlength="13"  readonly>
                                </c:when>
                                <c:otherwise>
									<input type="text" name="TELX_NUMB${status.index}" value="${e17HospitalData.TELX_NUMB}" size="12" maxlength="13"  readonly>
                                </c:otherwise>
                            </c:choose>
                            <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                            </td>
                            <td>
                                <input type="text" name="EXAM_DATE${status.index}" value="${f:printDate(e17HospitalData.EXAM_DATE)}" size="10"  readonly>
                            </td>
                            <td>
                                <input type="hidden" name="MEDI_CODE${status.index}" value="${e17HospitalData.MEDI_CODE }">
                                <input type="text" name="MEDI_TEXT${status.index}" value="${e17HospitalData.MEDI_TEXT}" size="5" style="text-align:center" readonly>
                            </td>
                            <td>
                                <input type="hidden" name="RCPT_CODE${status.index}" value="${e17HospitalData.RCPT_CODE }">
                                <input type="text" name="RCPT_TEXT${status.index}" value="${e17HospitalData.RCPT_TEXT}" size="15" style="text-align:center" readonly>
                            </td>

                            <td>
                                <input type="text" name="RCPT_NUMB${status.index}" value="${e17HospitalData.RCPT_NUMB }"  style="text-align:center" size="3" style="text-align:center" readonly>
                            </td>
                            <td><!--@v1.1-->
                                <c:set var="MEDI_MTHD_TEXT" value=""/>
                                <c:choose>
                                    <c:when test="${e17HospitalData.MEDI_MTHD == '1'}"><c:set var="MEDI_MTHD_TEXT" value="${msg40}"/></c:when>
                                    <c:when test="${e17HospitalData.MEDI_MTHD == '2'}"><c:set var="MEDI_MTHD_TEXT" value="${msg41}"/></c:when>
                                    <c:when test="${e17HospitalData.MEDI_MTHD == '3'}"><c:set var="MEDI_MTHD_TEXT" value="${msg42}"/></c:when>
                                </c:choose>
                                <input type="text" name="MEDI_MTHD${status.index}" value="${MEDI_MTHD_TEXT}" size="7" style="text-align:left" readonly>
                            </td>
                            <td>
                                <input type="text" name="EMPL_WONX${status.index}" value="${f:printNumFormat(e17HospitalData.EMPL_WONX, currencyDecimalSize)}" size="10" style="text-align:right" readonly >
                            </td>
                            <td class="lastCol">
                                <input type="text" name="YTAX_WONX ${status.index}" value="${f:printNumFormat(e17HospitalData.YTAX_WONX, currencyDecimalSize)}" size="11" style="text-align:right"  readonly>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
            <div class="buttonArea " style="margin-bottom: 50px;">
                <c:if test="${!approvalHeader.finish}">
                <ul class="btn_mdl" style="float:left;">
                    <li><a href="javascript:go_bill_detail();"><span><spring:message code="LABEL.E.E17.0019" /><!-- 진료비 계산서 조회 --></span></a></li>
                </ul>
                </c:if>
                <div style="float:right; position:relative; top:8px; margin-right:10px;">
                    <span><spring:message code="LABEL.E.E18.0039" /><!-- 계 --> :</span>
                    <input type="text" name="EMPL_WONX_tot" size="17"  style="text-align:right" readonly>
                        ${e17SickData.WAERS}
                </div>
            </div>
        </div>
        <%-- 결재 완료 또는 (결재 진행 상태 and 담당자, 부서장) 일 경우 조회 --%>
        <c:if test="${approvalHeader.finish or (approvalHeader.AFSTAT != '01' and (approvalHeader.DMANFL == '01' or approvalHeader.PMANFL == 'X'))}">
        <div class="tableArea" style="margin-top: 70px;">
            <div class="table">
                <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    <%--<c:if test="${e17SickData.GUEN_CODE != '0001' and approvalHeader.finish}">
                        <th><spring:message code="LABEL.E.E18.0038" /><!-- 회사지원 총액 --></th>
                        <td>${f:printNumFormat(COMP_sum, currencyDecimalSize)} ${e17SickData.WAERS }</td>
                    </c:if>--%>
                        <th><spring:message code="LABEL.E.E18.0037" /><!-- 연말정산반영액 --></th>
                        <td>
                            ${f:printNumFormat(e17SickData.YTAX_WONX,currencyValue)} ${e17SickData.WAERS }
                        </td>
                        <th><spring:message code="LABEL.E.E18.0019" /><!-- 회사지원액 --></th>
                        <td>
                            ${f:printNumFormat(e17SickData.COMP_WONX,currencyValue)} ${e17SickData.WAERS }
                        </td>
                    <c:if test="${approvalHeader.finish}">
                        <th><spring:message code="LABEL.E.E19.0049" /><!-- 회계 전표 번호 --></th>
                        <td>
                             ${e17SickData.BELNR }
                        </td>
                    </c:if>
                    </tr>
                </table>
            </div>
        </div>
        </c:if>

        <!-- hidden field : common -->
        <input type="hidden" name="radio_index"       value="">
        <input type="hidden" name="RowCount_hospital" value="${fn:length(e17HospitalData_vt)}">
        <input type="hidden" name="RowCount_bill"     value="${fn:length(E17BillData_vt)} %>">
        <!-- hidden field : common -->

        <c:forEach var="e17BillData" items="${E17BillData_vt}" varStatus="status">
        <input type="hidden" name="CTRL_NUMB${status.index}" value="${e17BillData.CTRL_NUMB }"> <!-- 관리번호          -->
        <input type="hidden" name="x_RCPT_NUMB${status.index}" value="${e17BillData.RCPT_NUMB }"> <!-- 영수증번호        -->
        <input type="hidden" name="AINF_SEQN${status.index}" value="${e17BillData.AINF_SEQN }"> <!-- 결재정보 일련번호 -->
        <input type="hidden" name="TOTL_WONX${status.index}" value="${e17BillData.TOTL_WONX }"> <!-- 총 진료비         -->
        <input type="hidden" name="ASSO_WONX${status.index}" value="${e17BillData.ASSO_WONX }"> <!-- 조합 부담금       -->
        <input type="hidden" name="x_EMPL_WONX${status.index}" value="${e17BillData.EMPL_WONX }">  <!--본인 부담금       -->
        <input type="hidden" name="MEAL_WONX${status.index}" value="${e17BillData.MEAL_WONX }"> <!-- 식대              -->
        <input type="hidden" name="APNT_WONX${status.index}" value="${e17BillData.APNT_WONX }"> <!-- 지정 진료비       -->
        <input type="hidden" name="ROOM_WONX${status.index}" value="${e17BillData.ROOM_WONX }"> <!-- 상급 병실료 차액  -->
        <input type="hidden" name="CTXX_WONX${status.index}" value="${e17BillData.CTXX_WONX }"> <!-- C T 검사비        -->
        <input type="hidden" name="MRIX_WONX${status.index}" value="${e17BillData.MRIX_WONX }"> <!-- M R I 검사비      -->
        <input type="hidden" name="SWAV_WONX${status.index}" value="${e17BillData.SWAV_WONX }"> <!-- 초음파 검사비     -->
        <input type="hidden" name="DISC_WONX${status.index}" value="${e17BillData.DISC_WONX }"> <!-- 할인금액          -->
        <input type="hidden" name="ETC1_WONX${status.index}" value="${e17BillData.ETC1_WONX }"> <!-- 기타1 의 금액     -->
        <input type="hidden" name="ETC1_TEXT${status.index}" value="${e17BillData.ETC1_TEXT }"> <!-- 기타1 의 항목명   -->
        <input type="hidden" name="ETC2_WONX${status.index}" value="${e17BillData.ETC2_WONX }"> <!-- 기타2 의 금액     -->
        <input type="hidden" name="ETC2_TEXT${status.index}" value="${e17BillData.ETC2_TEXT }"> <!-- 기타2 의 항목명   -->
        <input type="hidden" name="ETC3_WONX${status.index}" value="${e17BillData.ETC3_WONX }"> <!-- 기타3 의 금액     -->
        <input type="hidden" name="ETC3_TEXT${status.index}" value="${e17BillData.ETC3_TEXT }"> <!-- 기타3 의 항목명   -->
        <input type="hidden" name="ETC4_WONX${status.index}" value="${e17BillData.ETC4_WONX }"> <!-- 기타4 의 금액     -->
        <input type="hidden" name="ETC4_TEXT${status.index}" value="${e17BillData.ETC4_TEXT }"> <!-- 기타4 의 항목명   -->
        <input type="hidden" name="ETC5_WONX${status.index}" value="${e17BillData.ETC5_WONX }"> <!-- 기타5 의 금액     -->
        <input type="hidden" name="ETC5_TEXT${status.index}" value="${e17BillData.ETC5_TEXT }"> <!-- 기타5 의 항목명   -->
        <input type="hidden" name="WAERS${status.index}"     value="${e17BillData.WAERS     }"> <!-- 통화키            -->
        </c:forEach>
        <!-- hidden field : E17BillData -->


    </tags-approval:detail-layout>
</tags:layout>






<%--








<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>
<%@ page import="hris.common.util.*" %>

<%
    E17SickData e17SickData = (E17SickData)request.getAttribute("e17SickData");

    Vector E17BillData_vt     = (Vector)request.getAttribute("E17BillData_vt");
    Vector E17HospitalData_vt = (Vector)request.getAttribute("E17HospitalData_vt");
    Vector AppLineData_vt     = (Vector)request.getAttribute("AppLineData_vt");
    String COMP_sum           = (String)request.getAttribute("COMP_sum");

    String RequestPageName = (String)request.getAttribute("RequestPageName");

    int medi_count = E17HospitalData_vt.size();

//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e17SickData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다


    // 현재 결재자 구분
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    DocumentInfo docinfo = new DocumentInfo(e17SickData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:on_Load();multiple_won();change_child();">
<form name="form1" method="post">
  <table width="810" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="800" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="800">
              <table width="800" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="title02" width="800"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">의료비 신청 조회</td>
                  <td class="titleRight"></td>
                </tr>
              </table></td>
          </tr>

          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/PersonInfo.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    }
%>
          <tr>
            <td>
              <!-- 상단 입력 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr>
                  <td class="tr01">
                    <table width="770" border="0" cellspacing="1" cellpadding="0">
                      <tr>
                        <td width="130" class="td01" nowrap>신청일자</td>
                        <td width="640" class="td09">
                          <table width="650" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="432">
                                <input type="text" name="BEGDA" value="${e17SickData.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(e17SickData.BEGDA)  }" size="20" readonly>
                              </td>
                              <td width="200" align="right"> <a href="javascript:go_print();">
                                <img src="<%= WebUtil.ImageURL %>btn_print_e17_b.gif" align="absmiddle" border="0" ></a>
                              </td>
                            <td width="28"></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td class="td01">관리번호</td>
                      <td class="td09">
                        <input type="text" name="CTRL_NUMB"  value="${e17SickData.CTRL_NUMB }" size="20" readonly>
                      </td>
                    </tr>
                    <tr>
                      <td class="td01">구분</td>
                      <td class="td09">
                        <input type="text" name="GUEN_CODE"  value="<%= WebUtil.printOptionText((new E17GuenCodeRFC()).getGuenCode(e17SickData.PERNR), e17SickData.GUEN_CODE) %>" size="20" readonly>
<%
    if( e17SickData.GUEN_CODE.equals("0002")||e17SickData.GUEN_CODE.equals("0003")||e17SickData.GUEN_CODE.equals("0001") ) {
%>
                        &nbsp;&nbsp;&nbsp;<input type="checkbox" name="PROOF" value="${e17SickData.PROOF%>" size="20" <%= e17SickData.PROOF.equals("X") ? "checked" : "" } disabled>&nbsp;연말정산반영여부
<%
    }
%>
                      </td>
                    </tr>
<%
//  자녀일때 자녀를 선택할 수 있도록 한다.
    if( e17SickData.GUEN_CODE.equals("0003") ) {
%>
                    <tr>
                      <td class="td01">자녀이름</td>
                      <td class="td09">
                        <input type="text" name="ENAME"     value="${e17SickData.ENAME }" size="14" readonly>
                        <input type="text" name="REGNO_dis" value="" size="14" readonly><br>
                        <input type="text" name="Message"   value="" size="100" readonly>
                      </td>
                    </tr>
<%
    }
%>
<!--@v1.3-->
                      <tr>
                        <td class="td01">진료과&nbsp;</td>
                        <td class="td09">
                          <input type="text" name="TREA_CODE"     value="<%= WebUtil.printOptionText((new E17MedicTreaRFC()).getMedicTrea(), e17SickData.TREA_CODE) %>" size="14" readonly>
                        </td>
                      </tr>
                    <tr>
                      <td class="td01">상병명</td>
                      <td class="td09">
                        <input type="text" name="SICK_NAME" value="${e17SickData.SICK_NAME }" size="40" readonly>
                      </td>
                    </tr>
                    <tr>
                      <td class="td01">구체적증상</td>
                      <td class="td09">
                        <textarea name="SICK_DESC" wrap="VIRTUAL" cols="70" rows="4" readonly>${e17SickData.SICK_DESC1 +"\n"+ e17SickData.SICK_DESC2 +"\n"+ e17SickData.SICK_DESC3 +"\n"+ e17SickData.SICK_DESC4  }</textarea>
                      </td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td>&nbsp; </td>
                    </tr>
                    <tr>
                      <td colspan="2">
                        <table width="770" border="0" cellspacing="1" cellpadding="2" class="table02">
                          <tr>
                            <td class="td03" width="45">선택</td>
                            <td class="td03" width="100">의료기관</td>
                            <td class="td03" width="85">사업자<br>등록번호</td>
                            <td class="td03" width="85">전화번호</td>
                            <td class="td03" width="60">진료일</td>
                            <td class="td03" width="40">입원/외래</td>
                            <td class="td03" width="80">영수증 구분</td>
                            <td class="td03" width="30">No.</td>
                            <td class="td03" width="70">결재<br>수단</td>
                            <td class="td03" width="90" align=center>본인<br>실납부액</td>
                            <td class="td03" width="90" align=center>연말정산<br>반영액</td>
                          </tr>
<%
            String MEDI_MTHD_TEXT = ""; //@v1.1
            for( int i = 0 ; i < E17HospitalData_vt.size() ; i++ ){
                E17HospitalData e17HospitalData = (E17HospitalData)E17HospitalData_vt.get(i);
		//@v1.1
		if (e17HospitalData.MEDI_MTHD.equals("1"))
                    MEDI_MTHD_TEXT = "현금";
                else if (e17HospitalData.MEDI_MTHD.equals("2"))
                    MEDI_MTHD_TEXT = "신용카드";
                else if (e17HospitalData.MEDI_MTHD.equals("3"))
                    MEDI_MTHD_TEXT = "현금영수증";
                else  MEDI_MTHD_TEXT = "";
%>
                          <tr>
                            <td class="td04">
                              <input type="radio" name="radiobutton" value="${status.index}" <%=(i==0) ? "checked" : "" %>>
                            </td>
                            <td class="td04">
                              <input type="text" name="MEDI_NAME${status.index}" value="${e17HospitalData.MEDI_NAME.trim() }" size="14" style="text-align:center" readonly>
                            </td>
                            <td class="td04">
                              <input type="text" name="MEDI_NUMB${status.index}" value="${e17HospitalData.MEDI_NUMB.equals("") ? "" : DataUtil.addSeparate2(e17HospitalData.MEDI_NUMB) }" size="11" readonly>
                            </td>
                            <td class="td04">
                              <input type="text" name="TELX_NUMB${status.index}" value="${e17HospitalData.TELX_NUMB }" size="11" style="text-align:center" maxlength="13" readonly>
                            </td>
                            <td class="td04">
                              <input type="text" name="EXAM_DATE${status.index}" value="${e17HospitalData.EXAM_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(e17HospitalData.EXAM_DATE) }" size="9" style="text-align:center" readonly>
                            </td>
                            <td class="td04">
                              <!-- 영수증 구분   -->
                              <input type="hidden" name="MEDI_CODE${status.index}" value="${e17HospitalData.MEDI_CODE }">
                              <input type="text" name="MEDI_TEXT${status.index}" value="${e17HospitalData.MEDI_TEXT.trim() }" size="5" style="text-align:center" readonly>
                            </td>
                            <td class="td04">
                              <!-- 영수증 구분   -->
                              <input type="hidden" name="RCPT_CODE${status.index}" value="${e17HospitalData.RCPT_CODE }">
                              <input type="text" name="RCPT_TEXT${status.index}" value="${e17HospitalData.RCPT_TEXT.trim() }" size="15" style="text-align:center" readonly>
                            </td>
                            <td class="td04">
                              <input type="text" name="RCPT_NUMB${status.index}" value="${e17HospitalData.RCPT_NUMB }"  style="text-align:center" size="3" style="text-align:center" readonly>
                            </td>
                            <td class="td04"><!--@v1.1-->
                                  <input type="text" name="MEDI_MTHD${status.index}" value="<%= MEDI_MTHD_TEXT %>" size="7" style="text-align:left" readonly>
                            </td>
                            <td class="td04">
                              <input type="text" name="EMPL_WONX${status.index}" value="<%= WebUtil.printNumFormat(e17HospitalData.EMPL_WONX,currencyValue) %>" size="11" style="text-align:right" readonly>
                            </td>
                            <td class="td04"><!--@v1.2-->
                              <input type="text" name="YTAX_WONX ${status.index}" value="<%= WebUtil.printNumFormat(e17HospitalData.YTAX_WONX ,currencyValue) %>" size="11" style="text-align:right" readonly>
                            </td>
                          </tr>
<%
            }
%>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="2">
                        <table width="705" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="190"> <a href="javascript:go_bill_detail();">
                              <img src="<%= WebUtil.ImageURL %>btn_billDetail.gif" align="absmiddle" border="0">
                              </a> </td>
                            <td width="510">
                              <table width="510" border="0" cellspacing="0" cellpadding="0">
                                <tr>
<%
    if( hris.common.util.AppUtil.getAppState(AppLineData_vt) ) {        // 승인완료일 경우 회사지원총액(배우자일경우)을 보여준다.
        if( e17SickData.GUEN_CODE.equals("0001") ) {
%>
                                  <td width="110" class="td04">&nbsp;</td>
                                  <td width="130" class="td04">&nbsp;</td>
<%
//      배우자일 경우 회사지원 총액을 보여준다.
        } else {
%>
                                  <td width="110" class="td03">회사지원총액</td>
                                  <td width="130" class="td04">
                                    <input type="text" value="<%= COMP_sum.equals("0.0") ? "" : WebUtil.printNumFormat(COMP_sum,currencyValue) %>" size="13" style="text-align:right" readonly>
                                    ${e17SickData.WAERS }
                                  </td>
<%
        }
    } else {
%>
                                  <td width="110" class="td04">&nbsp;</td>
                                  <td width="130" class="td04">&nbsp;</td>
<%
    }
%>
                                  <td width="30"  class="td04">&nbsp;</td>
                                  <td width="110" class="td03">계</td>
                                  <td width="130" class="td04">
                                    <input type="text" name="EMPL_WONX_tot" size="13" style="text-align:right" readonly>
                                    ${e17SickData.WAERS }
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>

                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
            <!--상단 입력 테이블 끝-->
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="750" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="font01"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                  결재정보</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <!-- 결재자 입력 테이블 시작-->
            <%= hris.common.util.AppUtil.getAppDetail(AppLineData_vt) %>
            <!-- 결재자 입력 테이블 End-->
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
         <td>
            <table width="780" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="center">
<%  // 결재목록 보기 추가
    if ( RequestPageName != null && !RequestPageName.equals("")) {
%>
                  <a href="javascript:do_list();"> <img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0" align="absmiddle"></a>
                  <%
    }
%>
                <% if (docinfo.isModefy()) { %>
                  <a href="javascript:do_change();"> <img src="<%= WebUtil.ImageURL %>btn_change.gif" align="absmiddle" border="0"></a>
                  <a href="javascript:do_delete();"> <img src="<%= WebUtil.ImageURL %>btn_delete.gif" align="absmiddle" border="0"></a>
                <% } // end if %>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<!-- hidden field : common -->
    <input type="hidden" name="jobid"             value="">
    <input type="hidden" name="radio_index"       value="">
    <input type="hidden" name="fromJsp"           value="E17HospitalDetail.jsp">
    <input type="hidden" name="AINF_SEQN"         value="">
    <input type="hidden" name="RowCount_hospital" value="${e17HospitalData.vt.size() }">
    <input type="hidden" name="RowCount_bill"     value="<%= E17BillData_vt.size() %>">
    <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
<!-- hidden field : common -->
<%
    for( int i = 0 ; i < E17BillData_vt.size() ; i++ ){
        E17BillData e17BillData = (E17BillData)E17BillData_vt.get(i);
%>
    <input type="hidden" name="CTRL_NUMB${status.index}" value="<%= e17BillData.CTRL_NUMB %>"> <!-- 관리번호          -->
    <input type="hidden" name="x_RCPT_NUMB${status.index}" value="<%= e17BillData.RCPT_NUMB %>"> <!-- 영수증번호        -->
    <input type="hidden" name="AINF_SEQN${status.index}" value="<%= e17BillData.AINF_SEQN %>"> <!-- 결재정보 일련번호 -->
    <input type="hidden" name="TOTL_WONX${status.index}" value="<%= e17BillData.TOTL_WONX %>"> <!-- 총 진료비         -->
    <input type="hidden" name="ASSO_WONX${status.index}" value="<%= e17BillData.ASSO_WONX %>"> <!-- 조합 부담금       -->
    <input type="hidden" name="x_EMPL_WONX${status.index}" value="<%= e17BillData.EMPL_WONX %>">  <!--본인 부담금       -->
    <input type="hidden" name="MEAL_WONX${status.index}" value="<%= e17BillData.MEAL_WONX %>"> <!-- 식대              -->
    <input type="hidden" name="APNT_WONX${status.index}" value="<%= e17BillData.APNT_WONX %>"> <!-- 지정 진료비       -->
    <input type="hidden" name="ROOM_WONX${status.index}" value="<%= e17BillData.ROOM_WONX %>"> <!-- 상급 병실료 차액  -->
    <input type="hidden" name="CTXX_WONX${status.index}" value="<%= e17BillData.CTXX_WONX %>"> <!-- C T 검사비        -->
    <input type="hidden" name="MRIX_WONX${status.index}" value="<%= e17BillData.MRIX_WONX %>"> <!-- M R I 검사비      -->
    <input type="hidden" name="SWAV_WONX${status.index}" value="<%= e17BillData.SWAV_WONX %>"> <!-- 초음파 검사비     -->
    <input type="hidden" name="DISC_WONX${status.index}" value="<%= e17BillData.DISC_WONX %>"> <!-- 할인금액          -->
    <input type="hidden" name="ETC1_WONX${status.index}" value="<%= e17BillData.ETC1_WONX %>"> <!-- 기타1 의 금액     -->
    <input type="hidden" name="ETC1_TEXT${status.index}" value="<%= e17BillData.ETC1_TEXT %>"> <!-- 기타1 의 항목명   -->
    <input type="hidden" name="ETC2_WONX${status.index}" value="<%= e17BillData.ETC2_WONX %>"> <!-- 기타2 의 금액     -->
    <input type="hidden" name="ETC2_TEXT${status.index}" value="<%= e17BillData.ETC2_TEXT %>"> <!-- 기타2 의 항목명   -->
    <input type="hidden" name="ETC3_WONX${status.index}" value="<%= e17BillData.ETC3_WONX %>"> <!-- 기타3 의 금액     -->
    <input type="hidden" name="ETC3_TEXT${status.index}" value="<%= e17BillData.ETC3_TEXT %>"> <!-- 기타3 의 항목명   -->
    <input type="hidden" name="ETC4_WONX${status.index}" value="<%= e17BillData.ETC4_WONX %>"> <!-- 기타4 의 금액     -->
    <input type="hidden" name="ETC4_TEXT${status.index}" value="<%= e17BillData.ETC4_TEXT %>"> <!-- 기타4 의 항목명   -->
    <input type="hidden" name="ETC5_WONX${status.index}" value="<%= e17BillData.ETC5_WONX %>"> <!-- 기타5 의 금액     -->
    <input type="hidden" name="ETC5_TEXT${status.index}" value="<%= e17BillData.ETC5_TEXT %>"> <!-- 기타5 의 항목명   -->
    <input type="hidden" name="WAERS${status.index}"     value="<%= e17BillData.WAERS     %>"> <!-- 통화키            -->
<%  }%>
<!-- hidden field : E17BillData -->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
--%>
