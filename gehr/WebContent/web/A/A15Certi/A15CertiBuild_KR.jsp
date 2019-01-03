<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청                                             */
/*   Program ID   : A15CertiBuild_KR.jsp                                           */
/*   Description  : 재직증명서를 신청할 수 있도록 하는 화면                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-02-18  윤정현                                          */
/*                  2008-05-08  lsa  [CSR ID:1263333] 제증명서 발급 Process 개선*/
/*                  2015-08-07  이지은  [CSR ID:2844968] 제증명 부수 선택 오류*/
/*                  2017-11-28  김주영  [CSR ID:3529076] 영문 주소 입력 수정*/
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="currentTime" value="<%=DataUtil.getCurrentTime() %>"/>

<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">
    <li><a href="javascript:;" onclick="go_print();" ><span><spring:message code="LABEL.A.A15.0008" /><%--보증금 발급 합의서--%></span></a></li>
</tags:body-container>


<tags:layout css="ui_library_approval.css" >

    <tags-approval:request-layout titlePrefix="MSG.A.A15.TITLE" button="${buttonBody}">
        <%--@elvariable id="resultData" type="hris.A.A15Certi.A15CertiData"--%>
        <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
        <tags:script>

            <script>
                function beforeSubmit() {
                    if (check_data()) {

                        //[CSR ID:1263333]
                        if (document.form1.PRINT_CHK[0].checked == true) {
                            document.form1.PRINT_NUM.value = 1;
                            document.form1.PRINT_NUM.disabled = 0;
                        }
// 서울사업장(01)만 해당. 2005.9.2. mkbae
                    <c:if test="${user.e_grup_numb == '01'}">
                        var currentDate = ${currentTime};
                        if (document.form1.PRINT_CHK[0].checked == false) {
                            if (currentDate < 140000) {
                                alert('<spring:message code="MSG.A.A15.004" />'); //2시 이전의 신청건으로 오늘 오후 3시에 발급됩니다.
                            } else {
                                alert('<spring:message code="MSG.A.A15.005" />'); //2시 이후의 신청건으로 내일 오전 10시에 발급됩니다.
                            }
                        }
                    </c:if>

                        return true;
                    }

                    return false;
                }

                function check_data() {
                    var address1 = document.form1.ADDRESS1.value;//주소
                    var address2 = document.form1.ADDRESS2.value;
                    var use_place = document.form1.USE_PLACE.value;
                    var spec_entry = document.form1.SPEC_ENTRY.value;

                    if (document.form1.LANG_TYPE[document.form1.LANG_TYPE.selectedIndex].value == 2) {
                        if (!checkEnglish(document.form1.ADDRESS1.value)) {
                            alert('<spring:message code="MSG.A.A15.006" />'); //영문 주소 입력만 가능합니다.
                            document.form1.ADDRESS1.focus();
                            document.form1.ADDRESS1.select();
                            return false;
                        }
                        if (document.form1.ADDRESS2.value != "") {
                            if (!checkEnglish(document.form1.ADDRESS2.value)) {
                                alert('<spring:message code="MSG.A.A15.006" />'); //영문 주소 입력만 가능합니다.
                                document.form1.ADDRESS2.focus();
                                document.form1.ADDRESS2.select();
                                return false;
                            }
                        }
                    }

//subtype = document.form1.SUBF_TYPE[document.form1.SUBF_TYPE.selectedIndex].value;

                    var submit_plac = document.form1.SUBMIT_PLACE.value;//제출처
                    //[CSR ID:1263333]
                    if (document.form1.PRINT_CHK[0].checked == false && document.form1.PRINT_CHK[1].checked == false) {
                        alert('<spring:message code="MSG.A.A15.007" />'); //발행방법을 입력하여 주십시요
                        document.form1.PRINT_CHK.focus();
                        return false;
                    }

                    if (spec_entry != "") {
                        textArea_to_TextFild(spec_entry);
                    }

                    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);

                    return true;
                }

                // 글자수입력제한
                function check_length(obj) {

                    val = obj.value;
                    nam = obj.name;
                    len = checkLength(obj.value);

                    if (event.keyCode == 13) {
                        if (nam == "ADDRESS1") {
                            document.form1.ADDRESS2.focus();
                        } else if (nam == "ADDRESS2") {
                            obj.blur();
                        }
                    }

                  	//[CSR ID:3529076] 영문 주소 입력 수정 start
                    if(document.form1.LANG_TYPE.value == "2"){
                    	if (len > 60) {
                    		alert('<spring:message code="MSG.A.A15.012" />'); //현주소는 60자리 보다 작아야 합니다.
                            vala = limitKoText(val, 60);
                            obj.blur();
                            obj.value = vala;
                            obj.focus();

                        }
                    }//[CSR ID:3529076] 영문 주소 입력 수정 end
                    else{
                    	if (len > 79) {
                            vala = limitKoText(val, 79);
                            obj.blur();
                            obj.value = vala;
                            obj.focus();

                        }
                    }

                }

                function textArea_to_TextFild(text) {
                    var tmpText = "";
                    var tmplength = 0;
                    var count = 1;
                    var flag = true;
                    for (var i = 0; i < text.length; i++) {
                        tmplength = checkLength(tmpText);
                        if (text.charCodeAt(i) != 13 && Number(tmplength) < 60) {
                            tmpText = tmpText + text.charAt(i);
                            flag = true
                        } else {
                            flag = false;
                            tmpText.trim;
                            eval("document.form1.SPEC_ENTRY" + count + ".value=" + "tmpText");
                            //alert(tmpText+"*****"+count+"*****"+i);
                            tmpText = text.charAt(i);
                            count++;
                            if (count > 5) {
                                break;
                            }

                        }
                    }

                    if (flag) {
                        eval("document.form1.SPEC_ENTRY" + count + ".value=" + "tmpText");
                    }
                    //debug();
                }

                function go_print() {
                    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650,left=100,top=60");
                    document.form1.jobid.value = "print_form";
                    document.form1.target = "essPrintWindow";
                    document.form1.action = '${g.servlet}hris.A.A15Certi.A15CertiBuildSV';
                    document.form1.method = "post";
                    document.form1.submit();
                }

                //[CSR ID:1263333]
                function setPRINT_NUM(gubun) {
                    if (gubun == "1") {
                        document.form1.PRINT_NUM.disabled = 1;
                        document.form1.PRINT_NUM.value = 1;

                        //document.form1.USE_PLACE.value="";
                        //document.form1.USE_PLACE.disabled=0;
                    } else {
                        document.form1.PRINT_NUM.disabled = 0;

                        //document.form1.USE_PLACE.value="보증용";
                        //document.form1.USE_PLACE.disabled=1;
                    }
                }

                function f_LangChang() {

                    if (document.form1.LANG_TYPE.value == "2" && document.form1.PRINT_CHK[0].checked == true) {
                        alert('<spring:message code="MSG.A.A15.008" />'); //영문은 본인발행을 선택할 수 없습니다.
                        document.form1.PRINT_CHK[1].checked = true;
                        setPRINT_NUM(2);  //[CSR ID:2844968] 제증명 부수 선택 오류
                        return;
                    }
                }
            </script>
        </tags:script>

        <!-- 상단 입력 테이블 시작-->
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral tableApproval">
                    <colgroup>
                        <col width="15%" />
                        <col width="85%" />
                    </colgroup>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.APPROVAL.0012" /><%--구분--%>&nbsp;</th>
                        <td>
                            <select name="LANG_TYPE" onChange="javascript:f_LangChang();">
                                <option value="1" ${resultData.LANG_TYPE != '2' ? 'selected' : ''}><spring:message code="LABEL.A.A15.0009" /><%--한글--%></option>
                                <option value="2" ${resultData.LANG_TYPE == '2' ? 'selected' : ''}><spring:message code="LABEL.A.A15.0010" /><%--영문--%></option>
                            </select>
                            <input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" >
                            <span class="inlineComment"><spring:message code="LABEL.A.A15.0011" /><%--※ 본인발행시에는 1회/1부만 가능합니다.--%></span>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0012" /><%--발행부수--%>&nbsp;</th>
                        <td>
                            <select name="PRINT_NUM" ${resultData.PRINT_CHK != '2' ? 'disabled' : ''} >
                                <c:forEach begin="1" end="10" varStatus="status">
                                    <option value="${status.count}" ${f:parseLong(resultData.PRINT_NUM) == status.count ? 'selected' : ''}>${status.count}</option>
                                </c:forEach>
                            </select>
                            <span class="inlineComment"><spring:message code="LABEL.A.A15.0013" /><%--※ 2부 이상 필요시에는 담당부서 발행으로 신청하시어 수령바랍니다.--%></span>
                        </td>
                    </tr>
                    <tr> <!--[CSR ID:1263333]-->
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0014" /><%--발행방법--%></th>
                        <td>
                            <input type="radio" name="PRINT_CHK" value="1" ${resultData.PRINT_CHK != '2' ? 'checked' : ''}
                                   onClick="javascript:setPRINT_NUM('1');f_LangChang();" ><spring:message code="LABEL.A.A15.0015" /><%--본인발행--%>
                            <input type="radio" name="PRINT_CHK" value="2" ${resultData.PRINT_CHK == '2' ? 'checked' : ''}
                                   onClick="javascript:setPRINT_NUM('2');"><spring:message code="LABEL.A.A15.0016" /><%--담당부서 요청발행--%>
                        </td>
                    </tr>

                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A01.0043" /><%--현주소--%>&nbsp;</th>
                        <td>
                            <input type="text" class="vertical required" style="width: 700px;" placeholder="<spring:message code="MSG.A.A01.0043" />" name="ADDRESS1" size="60" Maxlength="80"
                                   value='${isUpdate ? resultData.ADDRESS1 : personInfo.e_STRAS}' onKeyUp="check_length(this)">
                            <br/>
                            <input type="text" name="ADDRESS2" size="60" Maxlength="80" style="width: 700px;"
                                   value='${isUpdate ? resultData.ADDRESS2 : personInfo.e_LOCAT}' onKeyUp="check_length(this)">
                            <br/>
                            <span class="inlineComment"><spring:message code="LABEL.A.A15.0017" /><%--※ 영문증명서를 신청하실 경우 현주소에 영문으로 입력해주세요.--%></span>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0018" /><%--제출처--%>&nbsp;</th>
                        <td>
                            <input type="text" name="SUBMIT_PLACE" size="60" Maxlength="60" style="width: 700px;" class="required" placeholder="<spring:message code="LABEL.A.A15.0018" />" value="${resultData.SUBMIT_PLACE}">
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0019" /><%--용도--%>&nbsp;</th>
                        <td>
                            <input type="text" name="USE_PLACE" size="60" class="required" style="width: 700px;" placeholder="<spring:message code="LABEL.A.A15.0019" />" value="${resultData.USE_PLACE}">
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.A.A15.0020" /><%--특기사항--%></th>
                        <td>
                            <textarea name="SPEC_ENTRY" wrap="VIRTUAL" cols="60" rows="5" style="width: 700px;">${resultData.SPEC_ENTRY1}${resultData.SPEC_ENTRY2}${resultData.SPEC_ENTRY3}${resultData.SPEC_ENTRY4}${resultData.SPEC_ENTRY5}</textarea>
                            <input type="hidden" name="SPEC_ENTRY1">
                            <input type="hidden" name="SPEC_ENTRY2">
                            <input type="hidden" name="SPEC_ENTRY3">
                            <input type="hidden" name="SPEC_ENTRY4">
                            <input type="hidden" name="SPEC_ENTRY5">
                        </td>
                    </tr>
                </table>
            </div>
            <span class="inlineComment">&nbsp;&nbsp;<spring:message code="LABEL.A.A15.0021" /><%--※ 비자발급용은 국문으로 신청하셔도 가능합니다.--%></span>
            <div class="commentsMoreThan2">
                <div> <spring:message code="LABEL.A.A15.0022" /><%--보증용의 경우 배우자 또는 배우자 부재시 부모 합의서 제출요망--%></div>
                <div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
            </div>
        </div>
        <!-- 상단 입력 테이블 끝-->

    </tags-approval:request-layout>

    <div class="commentsMoreThan2">
        <div><spring:message code="LABEL.A.A15.0007" /><%--본부 Staff의 경우 증명서 발급 업무가 HR Service Desk로 이관되었습니다.--%></div>
    </div>

</tags:layout>

