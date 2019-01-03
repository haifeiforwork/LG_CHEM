<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재해야할 문서                                             */
/*   2Depth Name  :                                                             */
/*   Program Name : 근로소득/갑근세 결재                                        */
/*   Program ID   : G059ApprovalDeduct.jsp                                      */
/*   Description  : 근로소득/갑근세 결재를 위한 jsp 파일                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-11 유용원                                           */
/*   Update       : 2008-04-28  [CSR ID:1257249] HR센터 제증명서 반려오류       */
/*   Update       : 2008-05-13  lsa  [CSR ID:1263333] 제증명서 발급 Process 개선*/
/*   Update       : 2012-07-30  lsa  [CSR ID: ] 사업장삭제 및 갑근세 pdf 추가  */
/*					 2015-03-06  이지은 [CSR ID:2717992] HR 내 제증명신청 날짜 오류    */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="MSG.A.A18.TITLE"
                                 updateUrl="${g.servlet}hris.A.A18Deduct.A18DeductChangeSV">

        <tags:script>

            <script language="JavaScript">
                <!--

                function beforeAccept(){
                    date_fr = removePoint(document.form1.EBEGDA.value);
                    date_to = removePoint(document.form1.EENDDA.value);

                    if( date_fr > date_to ) {
                        alert("<spring:message code='MSG.A.A18.0004'/>"); //선택기간 시작일이 종료일보다 큽니다.
                        return false;
                    }

//[CSR ID:2717992] HR 내 제증명신청 날짜 오류
// 갑근세 신청 시 validation 추가. limit날짜를 넘기면 에러, 이전이면 ok
                    var guentype_v = document.form1.GUEN_TYPE.value;
                    if(guentype_v == "갑근세 원천징수 증명서"){
                        var today = "${f:currentDate()}";

                        var date_to_month = date_to.substr(0,6);
                        var approval_check = getAfterMonth(addSlash(today),-1);
                        var approval_check_month = approval_check.substr(0,6);

                        if(date_to_month > approval_check_month){
                            alert("<spring:message code='MSG.A.A18.0005' arguments='addSlash(getLastDay(approval_check.substr(0,4),approval_check.substr(4,2)))'/>");  //선택기간은 "+addSlash(getLastDay(approval_check.substr(0,4),approval_check.substr(4,2)))+" 이전의 날짜를 선택하시기 바랍니다.
                            return false;
                        }
                    }

                    document.form1.EBEGDA.value = date_fr;
                    document.form1.EENDDA.value = date_to;
                    //}

                    if ( document.form1.SPEC_ENTRY.value != "" ) {
                        textArea_to_TextFild( document.form1.SPEC_ENTRY.value );
                    }
                    return true;
                }


                function textArea_to_TextFild(text) {
                    var tmpText   = "";
                    var tmplength = 0;
                    var count     = 1;
                    var flag      = true;

                    for( var i = 0; i < text.length; i++ ){
                        tmplength = checkLength(tmpText);
                        if( text.charCodeAt(i) != 13 && Number( tmplength ) < 60 ){
                            tmpText = tmpText+text.charAt(i);
                            flag = true
                        } else {
                            flag = false;
                            tmpText.trim;
                            eval("document.form1.SPEC_ENTRY"+count+".value="+"tmpText");

                            tmpText=text.charAt(i);
                            count++;
                            if( count > 5 ){
                                break;
                            }
                        }
                    }

                    if( flag ) {
                        eval("document.form1.SPEC_ENTRY"+count+".value="+"tmpText");
                    }
                }
                //[CSR ID:1263333]
                function setPRINT_NUM(gubun){
                    if( gubun == "1" ) {
                        document.form1.PRINT_NUM.disabled=1;
                        document.form1.PRINT_NUM.value=1;

                        //document.form1.USE_PLACE.value="";
                        //document.form1.USE_PLACE.disabled=0;
                    } else {
                        document.form1.PRINT_NUM.disabled=0;

                        //document.form1.USE_PLACE.value="보증용";
                        //document.form1.USE_PLACE.disabled=1;
                    }
                }


                //-->
            </script>



        </tags:script>

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <%--
                     <tr id="year" style="display: ${resultData.GUEN_TYPE == '01' ? 'block' : 'none'};">

                        <th>신청년도</th>
                        <td>
                            <select name="PRINT_YEAR" onChange="javascript:change_year(this);">
                                <option value="">-----------</option>
                                <c:forEach begin="${openDYear - 2}" end="${openDYear}" varStatus="status" >
                                    <c:set var="optionYear" value="${status.end - status.count + 1}" scope="page"/>
                                    <option value="${optionYear}" ${optionYear == resultData.PRINT_YEAR ? "selected" :"" }>${optionYear}</option>
                                </c:forEach>
                            </select>
                            <input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" >
                        </td>
                    </tr>--%>
                    <tr>
                        <th><spring:message code="LABEL.COMMON.0043"/><!-- 구분 --></th>
                        <td>
                            ${f:printOptionValueText(gubunList, resultData.GUEN_TYPE)}
                            <input type="hidden" name="GUEN_TYPE" value="${resultData.GUEN_TYPE}" />
                        </td>

                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0001"/><!-- 발행부수 --></th>
                        <td>
                            <%--<input type="text" name="PRINT_NUM" size="12" value="${f:parseLong(resultData.PRINT_NUM)}" >--%>
                            <select name="PRINT_NUM" ${resultData.PRINT_CHK == "1" ? "disabled" : "" } class="required" placeholder="<spring:message code='LABEL.COMMON.0043'/>">
                                <c:forEach begin="1" end="10" varStatus="status">
                                    <option value="${status.count}" ${f:parseLong(resultData.PRINT_NUM) == status.count ? 'selected' : ''}>${status.count}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th><spring:message code="LABEL.G.G06.0013"/><!-- 전화번호 --></th>
                        <td colspan="3">
                            <input type="text" name="PHONE_NUM" size="20"   value="${resultData.PHONE_NUM}" readonly>
                        </td>
                    </tr>

                    <tr> <!--[CSR ID:1263333]-->
                        <th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0002"/><!-- 발행방법 --></th>
                        <td>
                            <input type="radio" name="PRINT_CHK" value="1" ${resultData.PRINT_CHK != '2' ? 'checked' : ''}
                                   class="required" placeholder="<spring:message code='LABEL.G.G26.0002'/>" onClick="setPRINT_NUM('1');" ><spring:message code="LABEL.G.G26.0003"/><!-- 본인발행 -->
                            <input type="radio" name="PRINT_CHK" value="2" ${resultData.PRINT_CHK == '2' ? 'checked' : ''}
                                   class="required" placeholder="<spring:message code='LABEL.G.G26.0002'/>" onClick="setPRINT_NUM('2');"><spring:message code="LABEL.G.G26.0004"/><!-- 담당부서 요청발행 -->
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0011"/><!-- 제출처 --></th>
                        <td>
                            <input type="text" name="SUBMIT_PLACE" size="60" Maxlength="60" class="required" placeholder="<spring:message code='LABEL.G.G26.0011'/>" value="${resultData.SUBMIT_PLACE}">
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A18.0003"/><!-- 사용목적 --></th>
                        <td>
                            <input type="text" name="USE_PLACE" size="60" class="required" placeholder="<spring:message code='LABEL.A.A18.0003'/>" value="${resultData.USE_PLACE}">
                        </td>
                    </tr>

                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A18.0004"/><!-- 선택기간 --></th>
                        <td>
                                <%--${resultData.GUEN_TYPE == '01' ? 'readonly' : ''}--%><%--${resultData.GUEN_TYPE == '01' ? '' : 'date'}--%>
                            <input type="text" id="EBEGDA" name="EBEGDA" value="${resultData.EBEGDA}" size="20" ${resultData.GUEN_TYPE == '01' ? '' : ''}
                                   class="required ${resultData.GUEN_TYPE == '01' ? 'date' : 'date'}" placeholder="<spring:message code='LABEL.A.A18.0008'/>" >  <!-- 선택기간 시작일 -->
                            <spring:message code="LABEL.A.A18.0006"/><!-- 부터 -->
                            <input type="text" id="EENDDA" name="EENDDA" value="${resultData.EENDDA}" size="20" ${resultData.GUEN_TYPE == '01' ? '' : ''}
                                   class="required ${resultData.GUEN_TYPE == '01' ? 'date' : 'date'}" placeholder="<spring:message code='LABEL.A.A18.0009'/>">  <!--선택기간 종료일  -->
                            <spring:message code="LABEL.A.A18.0007"/><!-- 까지 -->
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.A.A15.0020"/><!-- 특기사항 --></th>
                        <td>
                            <textarea name="SPEC_ENTRY" wrap="VIRTUAL" cols="60" rows="5">${resultData.SPEC_ENTRY1}${resultData.SPEC_ENTRY2}${resultData.SPEC_ENTRY3}${resultData.SPEC_ENTRY4}${resultData.SPEC_ENTRY5}</textarea>
                            <input type="hidden" name="SPEC_ENTRY1">
                            <input type="hidden" name="SPEC_ENTRY2">
                            <input type="hidden" name="SPEC_ENTRY3">
                            <input type="hidden" name="SPEC_ENTRY4">
                            <input type="hidden" name="SPEC_ENTRY5">
                            <input type="hidden" name="JUSO_CODE"       value="${resultData.JUSO_CODE}">
                        </td>
                    </tr>
                </table>
                <div class="commentsMoreThan2">
                    <div><spring:message code="LABEL.A.A18.0005"/><!-- 선택기간은 출력하기를 원하는 1년 단위의 기간을 입력한다. --></div>
                    <div><span class="textPink">*</span> <spring:message code="LABEL.G.G59.0001"/><!--  는 필수입력사항입니다(선택기간은 갑근세 원천징수 증명서 선택시에만 필수사항입니다). --></div>
                </div>

            </div>
        </div>

    </tags-approval:detail-layout>
</tags:layout>
