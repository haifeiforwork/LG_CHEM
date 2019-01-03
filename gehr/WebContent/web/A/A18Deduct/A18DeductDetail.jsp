<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 제증명신청                                                  */
/*   Program Name : 원천징수영수증 상세                                         */
/*   Program ID   : A18DeductDetail.jsp                                         */
/*   Description  : 원천징수영수증 상세내용 화면                                */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-03-04  유용원                                          */
/*                  2008-05-13  lsa  [CSR ID:1263333] 제증명서 발급 Process 개선*/
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<c:set var="buttonBody" value="${g.bodyContainer}" />

<c:if test="${approvalHeader.finish}">
    <c:if test="${(resultData.PRINT_CHK == '1' and user.empNo == resultData.PERNR and resultData.PRINT_END != 'X')}">
        <tags:script>
            <script language="JavaScript">
                <!--
                function go_print() {

                    if( "${resultData.PRINT_CHK}" == "1" && document.form1.PRINT_END.value == "X" ) {
                        alert('<spring:message code="MSG.A.A15.009" />'); //발행은 1회만 인쇄 가능합니다.
                        return;
                    }
                    if( "${resultData.PRINT_CHK}" == "1" ){//본인
                        if(!confirm('<spring:message code="MSG.A.A18.0006" />')){ //Acrobat Reader 버전 및 출력오류가이드를 확인하셨습니까?
                            return;
                        }
                        msg ="<spring:message code='MSG.A.A15.009' /> <spring:message code='MSG.A.A15.010' />"; //발행은 1회만 인쇄 가능합니다. 인쇄 하시겠습니까?
                    }else { //담당자
                        msg ="<spring:message code='MSG.A.A15.010' />"; //인쇄 하시겠습니까?
                    }
                    if( confirm(msg) ) {
                        window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=1,resizable=0,width=760,height=650,left=100,top=60");
                        document.form1.jobid.value = "print_certi";
                        document.form1.target      = "essPrintWindow";
                        document.form1.action      = '${g.servlet}hris.A.A18Deduct.A18DeductDetailSV';
                        document.form1.method      = "post";
                        document.form1.submit();

                        document.form2.target = "ifHidden";
                        document.form2.action = "${g.jsp}common/PrintCntUpdate.jsp";
                        document.form2.submit();
                    }
                }

                //[CSR ID:2940449]
                function fn_downGuide(){
                    //alert("본인발행 시 보아니2 버전이 58인지 확인하시고,\n원천징수영수증 출력오류 가이드를 참고해주시기 바랍니다.");[CSR ID:3021110]
                    location.href="${g.image}withholding_tax_install_guide.ppt";
                }

                $(function() {
                    init_alert();
                });

                //[CSR ID:2940449]
                //[CSR ID:3021110] 원천징수 영수증 출력 설정  -> 사용안함.
                //[CSR ID:3031090] 원천징수영수증 출력 관련 안내  -> 다시 사용
                function init_alert(){
//[CSR ID:3121978] 원천징수영수증 안내창 수정
//alert("★ Adobe Reader DC (G-cloud) 다운로드 후 출력해주시기 바랍니다.");
                    alert('<spring:message code="MSG.A.A18.0007" />'); //★출력 전 반드시 Acrobat Reader DC 설치 및 출력오류가이드 확인 후    출력바랍니다.★
                }

                //-->
            </script>
        </tags:script>

        <tags:body-container bodyContainer="${buttonBody}">
            <li><a href="${g.image}AcroRdrDC1500720033_ko_KR.exe" class="unloading" target="ifHidden"><span>Acrobat Reader DC download</span></a></li>
            <li><a href="javascript:;" class="unloading" onclick="fn_downGuide();"><span><spring:message code="LABEL.A.A18.0001" /><%--원천징수영수증 출력오류가이드--%></span></a></li>
            <li><a href="javascript:go_print();" class="unloading"><span><spring:message code="LABEL.COMMON.0001" /><!-- 인쇄하기 --></span></a></li>
        </tags:body-container>

    </c:if>
</c:if>





<tags:layout css="ui_library_approval.css" script="dialog.js" >
    <%--@elvariable id="resultData" type="hris.A.A18Deduct.A18DeductData"--%>
    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="MSG.A.A18.TITLE" button="${buttonBody}"
                                 updateUrl="${g.servlet}hris.A.A18Deduct.A18DeductChangeSV">

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tr>
                        <th><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></th>
                        <td>
                            ${f:printOptionValueText(gubunList, resultData.GUEN_TYPE)}
                            <input type="hidden" name="PRINT_END"   value="${resultData.PRINT_END}">
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.A.A15.0012" /><!-- 발행부수 --></th>
                        <td>${f:parseLong(resultData.PRINT_NUM)}</td>
                    </tr>
                    <!--[CSR ID:1263333]-->
                    <tr>
                        <th><spring:message code="LABEL.A.A15.0014" /><!-- 발행방법 --></th>
                        <td>
                            <input type="radio" name="PRINT_CHK" value="1" ${resultData.PRINT_CHK == "1" ? "checked" : "" } disabled>본인발행
                            <input type="radio" name="PRINT_CHK" value="2" ${resultData.PRINT_CHK == "2" ? "checked" : "" } disabled>담당부서 요청발행
                        </td>
                    </tr>
                <c:if test="${approvalHeader.MODFL != 'X'}">
                    <tr>
                        <th><spring:message code="MSG.A.A13.014" /><!-- 전화번호 --></th>
                        <td>${resultData.PHONE_NUM}</td>
                    </tr>
                </c:if>
                    <tr>
                        <th><spring:message code="LABEL.A.A15.0018" /><!-- 제출처 --></th>
                        <td>${resultData.SUBMIT_PLACE}</td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.A.A18.0003" /><!-- 사용목적 --></th>
                        <td>${resultData.USE_PLACE }</td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.A.A18.0004" /><!-- 선택기간 --></th>
                        <td>
                            ${f:printDate(resultData.EBEGDA)} 부터 ${f:printDate(resultData.EENDDA)} 까지
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.A.A15.0020" /><!-- 특기사항 --></th>
                        <td>
                            ${resultData.SPEC_ENTRY1} <br>
                            ${resultData.SPEC_ENTRY2} <br>
                            ${resultData.SPEC_ENTRY3} <br>
                            ${resultData.SPEC_ENTRY4} <br>
                            ${resultData.SPEC_ENTRY5}
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="commentsMoreThan2">
            <div><spring:message code="LABEL.A.A18.0010" /><!-- * 출력 전 Acrobat Reader DC 이하 버젼인 경우는 반드시 아래 버젼을 설치후 인쇄하기를 클릭하시기 바라며 --><br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.A.A18.0011" /><!-- 원천징수영수증 출력오류가이드를 확인하여주시기바랍니다. --></div>
        </div>
    </tags-approval:detail-layout>

    <iframe id="ifHidden" name="ifHidden" width="0" height="0" style="top:-99999px;" frameborder="0"></iframe>
    <form id="form2" name="form2" method="post" action="">
        <input type="hidden" name="PERNR"     value="${resultData.PERNR}">
        <input type="hidden" name="AINF_SEQN" value="${resultData.AINF_SEQN}">
        <input type="hidden" name="MENU" value="DEDUCT">
    </form>
</tags:layout>

