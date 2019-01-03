<%/********************************************************************************/
/*                                                                                */
/*   System Name   : MSS                                                          */
/*   1Depth Name   : MY HR 정보                                                   */
/*   2Depth Name   : 경력증명서 신청                                              */
/*   Program Name  : 경력증명서 신청                                              */
/*   Program ID    : A19CareerBuild.jsp                                           */
/*   Description   : 경력증명서를 신청할 수 있도록 하는 화면                      */
/*   Note          :                                                              */
/*   Creation      : 2006-04-11  김대영                                           */
/*   Update        : 2008-05-13  lsa  [CSR ID:1263333] 제증명서 발급 Process 개선 */
/*                  2015-08-07  이지은  [CSR ID:2844968] 제증명 부수 선택 오류*/
/*                  2017-11-28  김주영  [CSR ID:3529076] 영문 주소 입력 수정*/
/*                                                                                */
/**********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<c:set var="currentTime" value="<%=DataUtil.getCurrentTime() %>"/>

<tags:layout css="ui_library_approval.css" >

    <tags-approval:request-layout titlePrefix="MSG.A.A19.TITLE" >

        <tags:script>
            <script language="JavaScript">
                <!--
                function beforeSubmit() {

                    if( check_data() ) {
                        //[CSR ID:1263333]
                        if( document.form1.PRINT_CHK[0].checked == true ) {
                            document.form1.PRINT_NUM.value=1;
                            document.form1.PRINT_NUM.disabled=0;
                        }

// 서울사업장(01)만 해당.
                        <c:if test="${user.e_grup_numb == '01'}">
                        var currentDate = ${currentTime};
                        if (document.form1.PRINT_CHK[0].checked == false) {
                            if (document.form1.CAREER_TYPE.selectedIndex == 2) { //영문

                                if(currentDate < 140000) {
                                    alert('<spring:message code="MSG.A.A19.0001" />'); //2시 이전의 신청건으로 오늘 오후 2시 이후에 발급됩니다.
                                } else {
                                    alert('<spring:message code="MSG.A.A19.0002" />'); //2시 이후의 신청건으로 내일 오후 3시에 발급됩니다.
                                }
                            }else{ //국문
                                if(currentDate < 140000) {
                                    alert('<spring:message code="MSG.A.A15.004" />'); //2시 이전의 신청건으로 오늘 오후 3시에 발급됩니다.
                                } else {
                                    alert('<spring:message code="MSG.A.A15.005" />'); //2시 이후의 신청건으로 내일 오전 10시에 발급됩니다.
                                }
                            }
                        }
                        </c:if>

                        return true;
                    }

                    return false;
                }

                function check_data(){
                    var address1 = document.form1.ADDRESS1.value;
                    var address2 = document.form1.ADDRESS2.value;
                    var use_place   = document.form1.USE_PLACE.value;
                    var spec_entry  = document.form1.SPEC_ENTRY.value;
                    var career_type = document.form1.CAREER_TYPE.value;
                    var career_flag;
                    //주소

                    if( document.form1.CAREER_TYPE[ document.form1.CAREER_TYPE.selectedIndex].value == 4 ){
                        if( !checkEnglish( document.form1.ADDRESS1.value ) ){
                            alert('<spring:message code="MSG.A.A15.006" />'); //영문 주소 입력만 가능합니다.
                            document.form1.ADDRESS1.focus();
                            document.form1.ADDRESS1.select();
                            return false;
                        }
                        if( document.form1.ADDRESS2.value != "" ){
                            if( !checkEnglish( document.form1.ADDRESS2.value ) ){
                                alert('<spring:message code="MSG.A.A15.006" />'); //영문 주소 입력만 가능합니다.
                                document.form1.ADDRESS2.focus();
                                document.form1.ADDRESS2.select();
                                return false;
                            }
                        }
                    }

                   /* //[CSR ID:1263333]
                    if( document.form1.PRINT_CHK[0].checked == false && document.form1.PRINT_CHK[1].checked == false  ){
                        alert("발행방법을 입력하여 주십시요");
                        document.form1.PRINT_CHK.focus();
                        return false;
                    }
                    //제출처
                    var submit_plac = document.form1.SUBMIT_PLACE.value;
                    if( submit_plac == "" ){
                        alert("제출처를 입력하여 주십시요");
                        document.form1.SUBMIT_PLACE.focus();
                        return false;
                    }
                    //용도
                    if( use_place == "" ){
                        alert("용도를 입력하여 주십시요");
                        document.form1.USE_PLACE.focus();
                        return false;
                    }*/
                    // 이동발령유형
                    if (career_type == "2"){
                        for(i=0;i<3;i++){
                            if(document.form1.ORDER_TYPE[i].checked){
                                career_flag = true;
                                break;
                            } else {
                                career_flag = false;
                            }
                        }
                        if (career_flag == false){
                            alert('<spring:message code="MSG.A.A19.0003" />'); //이동발령유형을 선택하십시요
                            return false;
                        }
                    }


                    if ( spec_entry != "" ) {
                        textArea_to_TextFild( spec_entry );
                    }

                    begdate = removePoint(document.form1.BEGDA.value);
                    document.form1.BEGDA.value = begdate;

                    return true;
                }

                // 글자수입력제한
                function check_length(obj) {

                    val = obj.value;
                    nam = obj.name;
                    len = checkLength(obj.value);

                    if (event.keyCode == 13 )  {
                        if(nam=="ADDRESS1"){
                            document.form1.ADDRESS2.focus();
                        }else if(nam=="ADDRESS2"){
                            obj.blur();
                        }
                    }

                  	//[CSR ID:3529076] 영문 주소 입력 수정 start
                    if(document.form1.CAREER_TYPE.value =="4"){
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
                    var tmpText="";
                    var tmplength = 0;
                    var count = 1;
                    var flag = true;
                    for ( var i = 0; i < text.length; i++ ){
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

                function gubun_change2(){
                    if( document.form1.CAREER_TYPE.value == "2" ){
                        $("#gubun2").show();
                    } else{
                        $("#gubun2").hide();
                    }
                }


                //[CSR ID:1263333]
                function setPRINT_NUM(gubun){
                    if( gubun == "1" ) {
                        document.form1.PRINT_NUM.disabled=1;
                        document.form1.PRINT_NUM.value=1;
                    } else {
                        document.form1.PRINT_NUM.disabled=0;
                    }
                }
                function f_LangChang(){
                    if( document.form1.CAREER_TYPE.value =="2"  ){
                        alert('<spring:message code="MSG.A.A19.0004" />'); //국문 이동발령인 경우 향후 본인발행 서비스를 제공할 예정입니다.
                        document.form1.PRINT_CHK[1].checked =true ;
                        setPRINT_NUM(2);  //[CSR ID:2844968] 제증명 부수 선택 오류
                        return;
                    }
                    if( document.form1.CAREER_TYPE.value =="4" && document.form1.PRINT_CHK[0].checked ==true  ){
                        alert('<spring:message code="MSG.A.A15.008" />'); //영문은 본인발행을 선택할 수 없습니다.
                        document.form1.PRINT_CHK[1].checked =true ;
                        setPRINT_NUM(2);  //[CSR ID:2844968] 제증명 부수 선택 오류
                        return;
                    }
                }
                //-->
            </script>

        </tags:script>


        <!-- 상단 입력 테이블 시작-->
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.APPROVAL.0012" /><%--구분--%></th>
                        <td>
                            <select name="CAREER_TYPE" onchange="javascript:gubun_change2();f_LangChang();" class="required" placeholder="구분">
                                <option value="1" ${empty resultData.CAREER_TYPE or resultData.CAREER_TYPE == '1' ? 'selected' : ''} ><spring:message code="LABEL.A.A19.0001" /><%--국문 일반--%></option>
                                <option value="2" ${resultData.CAREER_TYPE == '2' ? 'selected' : ''}><spring:message code="LABEL.A.A19.0002" /><%--국문 이동발령 포함--%></option>
                                <option value="4" ${resultData.CAREER_TYPE == '4' ? 'selected' : ''}><spring:message code="LABEL.A.A15.0010" /><%--영문--%></option>
                            </select>
                            <input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" >
                            <span class="commentOne"><spring:message code="LABEL.A.A15.0011" /><%--본인발행시에는 1회/1부만 가능합니다.--%></span>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0012" /><%--발행부수--%></th>
                        <td>
                            <select name="PRINT_NUM" ${resultData.PRINT_CHK != '2' ? 'disabled' : ''} class="required" placeholder="<spring:message code="LABEL.A.A15.0012" /><%--발행부수--%>">
                                <c:forEach begin="1" end="10" varStatus="status">
                                    <option value="${status.count}" ${f:parseLong(resultData.PRINT_NUM) == status.count ? 'selected' : ''}>${status.count}</option>
                                </c:forEach>
                            </select>
                            <span class="commentOne"><spring:message code="LABEL.A.A15.0013" /><%--2부 이상 필요시에는 담당부서 발행으로 신청하시어 수령바랍니다.--%></span>
                        </td>
                    </tr>
                    <tr> <!--[CSR ID:1263333]-->
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0014" /><%--발행방법--%></th>
                        <td>
                            <input type="radio" name="PRINT_CHK" value="1" ${resultData.PRINT_CHK != '2' ? 'checked' : ''}
                                   class="required" placeholder="<spring:message code="LABEL.A.A15.0014" /><%--발행방법--%>"
                                   onClick="javascript:setPRINT_NUM('1');f_LangChang();" ><spring:message code="LABEL.A.A15.0015" /><%--본인발행--%>
                            <input type="radio" name="PRINT_CHK" value="2" ${resultData.PRINT_CHK == '2' ? 'checked' : ''}
                                   class="required" placeholder="<spring:message code="LABEL.A.A15.0014" /><%--발행방법--%>"
                                   onClick="javascript:setPRINT_NUM('2');"><spring:message code="LABEL.A.A15.0016" /><%--담당부서 요청발행--%>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A01.0043" /><%--현주소--%></th>
                        <td>
                            <input type="text" class="vertical required" style="width: 700px;" placeholder="<spring:message code="MSG.A.A01.0043" /><%--현주소--%>" name="ADDRESS1" size="60" Maxlength="80"
                                   value='${isUpdate ? resultData.ADDRESS1 : personInfo.e_STRAS}' onKeyUp="check_length(this)">
                            <br/>
                            <input type="text" name="ADDRESS2" size="60" Maxlength="80" style="width: 700px;"
                                   value='${isUpdate ? resultData.ADDRESS2 : personInfo.e_LOCAT}' onKeyUp="check_length(this)">
                            <br/>
                            <br><span class="commentOne"><spring:message code="LABEL.A.A15.0017" /><%--영문증명서를 신청하실 경우 현주소에 영문으로 입력해주세요.--%></span>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0018" /><%--제출처--%></th>
                        <td>
                            <input type="text" name="SUBMIT_PLACE" size="60" style="width: 700px;" Maxlength="60" class="required" placeholder="<spring:message code="LABEL.A.A15.0018" /><%--제출처--%>" value="${resultData.SUBMIT_PLACE}">
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0019" /><%--용도--%></th>
                        <td>
                            <input type="text" name="USE_PLACE" size="60" style="width: 700px;" class="required" placeholder="<spring:message code="LABEL.A.A15.0019" /><%--용도--%>" value="${resultData.USE_PLACE}">
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
                    <tr id="gubun2" style="${resultData.CAREER_TYPE ==  '2' ? '' : 'display:none'}" >
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A18.0012" /><%--이동발령유형--%></th>
                        <td>
                            <input type="radio" value="01" name="ORDER_TYPE" ${resultData.ORDER_TYPE == "01" ? "checked" : "" }><spring:message code="MSG.A.A01.0013" /><%--직무--%>&nbsp;
                            <input type="radio" value="02" name="ORDER_TYPE" ${resultData.ORDER_TYPE == "02" ? "checked" : "" }><spring:message code="MSG.APPROVAL.0015" /><%--부서--%>&nbsp;
                            <input type="radio" value="03" name="ORDER_TYPE" ${resultData.ORDER_TYPE == "03" ? "checked" : "" }><spring:message code="MSG.A.A01.0018" /><%--근무지--%>
                        </td>
                    </tr>
                </table>
                <span class="commentOne"><span class="textPink">*</span> <spring:message code="LABEL.A.A19.0003" /><%--는 필수입력사항입니다.--%></span>
            </div>
        </div>
    </tags-approval:request-layout>

    <span class="commentOne"><spring:message code="LABEL.A.A15.0007" /><%--본부 Staff의 경우 증명서 발급 업무가 HR Service Desk로 이관되었습니다.--%></span>

</tags:layout>
