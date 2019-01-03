<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 원천징수영수증 신청                                         */
/*   Program Name : 원천징수영수증 신청                                         */
/*   Program ID   : A18DeductBuild.jsp                                          */
/*   Description  : 근로소득 원천징수 영수증, 갑근세 원천징수 증명서 신청을     */
/*                  할수 있도록 하는 화면                                       */
/*   Note         :                                                             */
/*   Creation     : 2002-10-22  김도신                                          */
/*   Update       : 2005-02-18  윤정현                                          */
/*                  2008-05-13  lsa  [CSR ID:1263333] 제증명서 발급 Process 개선*/
/*                  2012-07-23  lsa  [CSR ID:1263333] 원천징수영수증년도추가    */
/*                  2014-01-17  lsa  [C20140106_63914] 원천징수영수증년도로직변경    */
/*                   2015-03-06  이지은 [CSR ID:2717992] HR 내 제증명신청 날짜 오류    */
/*                  2015/05/15 이지은 [CSR ID:2777506] 근로소득원천징수영수증 시스템 제한의 건                                                            */
/*                  2015/12/16 이지은 [CSR ID:2940449] 원천징수영수증 출력오류가이드 설정   */
/*                  2016/03/28 이지은  [CSR ID:3021110] 원천징수 영수증 출력 설정  */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="currentTime" value="<%=DataUtil.getCurrentTime() %>"/>
<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">
    <li><a href="javascript:fn_downGuide();" class="unloading" ><span><spring:message code="LABEL.A.A18.0001" /><%--원천징수영수증 출력오류가이드--%></span></a></li>
</tags:body-container>

<tags:layout css="ui_library_approval.css" >

    <tags-approval:request-layout titlePrefix="MSG.A.A18.TITLE"  button="${buttonBody}" >
        <%--@elvariable id="resultData" type="hris.A.A18Deduct.A18DeductData"--%>

        <tags:script>
            <script language="JavaScript">
                <!--
                function change_type(obj) {

                    // 근로소득 원천징수 영수증
                    if( $("#GUEN_TYPE").val() == "01" ) {
                        $("#year,#year1").show();
                        $("#EBEGDA,#EENDDA").val("").prop("readonly", true).next("img").hide();
                    } else if( $("#GUEN_TYPE").val() == "02" ) {           // 갑근세 원천징수 증명서
                        $("#year,#year1").hide();
                        $("#EBEGDA,#EENDDA").val("").prop("readonly", false).next("img").show();
                    }
                }

                function change_year(obj) {
                    var p_idx = obj.selectedIndex;
                    var year=obj.value;

                    document.form1.EBEGDA.value = "";
                    document.form1.EENDDA.value = "";
                    if( year!="" ) {
                        document.form1.EBEGDA.value = year+"0101";
                        document.form1.EENDDA.value = year+"1231";
                    }
                }

                function fn_downGuide(){
                    //alert("본인발행 시 보아니2 버전이 58인지 확인하시고,\n원천징수영수증 출력오류 가이드를 참고해주시기 바랍니다.");[CSR ID:3021110]
                    location.href="${g.image}withholding_tax_install_guide.ppt";
                }

                function beforeSubmit() {
                    if( check_data() ) {
                        //[CSR ID:1263333]
                        if( document.form1.PRINT_CHK[0].checked == true ) {
                            document.form1.PRINT_NUM.value=1;
                            document.form1.PRINT_NUM.disabled=0;
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

                function check_data(){
//R3에서 필드 길이의 원인모를 에러로 도메인의 데이터 타입, 길이를 테이블과 맞출수가 없어서.. 이 방법으로 처리함.
                    var guen_type = document.form1.GUEN_TYPE.value;
                    /*document.form1.GUEN_TYPE.value = guen_type.substring(2, 4);*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

                    if( guen_type == "01" ) {
                        if( checkNull(document.form1.PRINT_YEAR, "<spring:message code='MSG.A.A18.0001' />") == false ) { //신청년도를
                            document.form1.PRINT_YEAR.focus();
                            return false;
                        }
                    }
                    if( guen_type == "02" ) {
                        if( checkNull(document.form1.EBEGDA, "<spring:message code='MSG.A.A18.0002' />") == false ) { //선택기간 시작일을
                            document.form1.EBEGDA.focus();
                            return false;
                        }
                        if( checkNull(document.form1.EENDDA, "<spring:message code='MSG.A.A18.0003' />") == false ) { //선택기간 종료일을
                            document.form1.EENDDA.focus();
                            return false;
                        }

                        var date_fr = removePoint(document.form1.EBEGDA.value);
                        var date_to = removePoint(document.form1.EENDDA.value);

                        if( date_fr > date_to ) {
                            alert('<spring:message code="MSG.A.A18.0004" />'); //선택기간 시작일이 종료일보다 큽니다.
                            return false;
                        }

//[CSR ID:2717992] HR 내 제증명신청 날짜 오류
// 갑근세 신청 시 validation 추가. limit날짜를 넘기면 에러, 이전이면 ok
                        var selectedcombo = document.form1.GUEN_TYPE.value;
                        if(selectedcombo == "02"){// 갑근세 원천징수
                            var today = "${f:currentDate()}";

                            var date_to_month = date_to.substr(0,6);
                            var approval_check = getAfterMonth(addSlash(today),-1);
                            var approval_check_month = approval_check.substr(0,6);
							var before_date = addSlash(getLastDay(approval_check.substr(0,4),approval_check.substr(4,2)));
                            if(date_to_month > approval_check_month){
                            	alert("<spring:message code='MSG.A.A18.0005' arguments='"+before_date+"'/>");
                                /* alert("선택기간은 "+addSlash(getLastDay(approval_check.substr(0,4),approval_check.substr(4,2)))+" 이전의 날짜를 선택하시기 바랍니다."); */
                                return false;
                            }
                        }

                        document.form1.EBEGDA.value = date_fr;
                        document.form1.EENDDA.value = date_to;
                    }

                    //[CSR ID:2777506] 근로소득원천징수영수증 시스템 제한의 건 근로소득 원천징수 출력의 경우 ~5/21까지 신청을 막음
                    <%--
                    var curDate = ${f:currentDate()};
                    if(document.form1.TYPE.value == "0001" && curDate < 20150522 ){
                        alert("2014 연말정산 재정산 실시로 인해 \n근로소득 원천징수 영수증은 2015/05/22 이후부터 신청 가능합니다");
                        return false;
                    }
                    --%>

                    if ( document.form1.SPEC_ENTRY.value != "" ) {
                        textArea_to_TextFild( document.form1.SPEC_ENTRY.value );
                    }

                    var begdate = removePoint(document.form1.BEGDA.value);
                    document.form1.BEGDA.value = begdate;

                    return true;
                }

                <%--
                /*[CSR ID:2717992] HR 내 제증명신청 날짜 오류
                 갑근세원천징수 신청 시 신청 가능 기한 계산
                 - if 월급 받았다면(오늘이 25일 이후)
                 => 오늘 "년월" 까지 신청가능
                 - if 월급 안받았다면(오늘이 10일이라면)
                 => 오늘 "년월" -1 month 까지 신청가능

                 function gabgunse_limit(){
                 var returndate = "";
                 var today = <%= WebUtil.printDate(DataUtil.getCurrentDate(),"") %>;
                 today = today+"";
                 var day25 = today.substr(6,2);
                 if(day25<25){//25일 전이면 -1month가 max 신청월이다.
                 returndate = getAfterMonth(addSlash(today),-1);
                 }else{
                 returndate = today;
                 }
                 return returndate;
                 }*/
                --%>

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
                    } else {
                        document.form1.PRINT_NUM.disabled=0;
                    }
                }

                $(function() {
                    change_type(document.all.GUEN_TYPE);
                });
                //-->
            </script>
        </tags:script>

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral" >
                    <colgroup>
                        <col width="15%" />
                        <col width="85%" />
                    </colgroup>

                    <tr id="year" style="display: ${resultData.GUEN_TYPE == '01' ? 'block' : 'none'};">
                        <th><spring:message code="LABEL.A.A18.0002" /><%--신청년도--%></th>
                        <td>
                            <select name="PRINT_YEAR" onChange="javascript:change_year(this);">
                                <option value="">-----------</option>
                            <c:forEach begin="${openDYear - 2}" end="${openDYear}" varStatus="status" >
                                <c:set var="optionYear" value="${status.end - status.count + 1}" scope="page"/>
                            <option value="${optionYear}" ${optionYear == fn:substring(resultData.EBEGDA, 0, 4) ? "selected" :"" }>${optionYear}</option>
                            </c:forEach>
                            </select>
                            <input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" >
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.APPROVAL.0012" /><%--구분--%></th>
                        <td>
                            <select id="GUEN_TYPE" name="GUEN_TYPE" onChange="javascript:change_type(this);" class="required" placeholder="구분">
                                <option value="">-------------------------</option>
                                ${f:printCodeOption(gubunList, resultData.GUEN_TYPE)}
                            </select>
                            <span class="inlineComment"><spring:message code="LABEL.A.A15.0011" /><%--※ 본인발행시에는 1회/1부만 가능합니다.--%></span>
                        </td>
                        <%--<input type="hidden" name="GUEN_TYPE" value=""--%>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0012" /><%--발행부수--%></th>
                        <td>
                            <select name="PRINT_NUM" ${resultData.PRINT_CHK == "1" ? "disabled" : "" } class="required" placeholder="<spring:message code="MSG.APPROVAL.0012" /><%--구분--%>">
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
                                   class="required" onClick="setPRINT_NUM('1');" ><spring:message code="LABEL.A.A15.0015" /><%--본인발행--%>
                            <input type="radio" name="PRINT_CHK" value="2" ${resultData.PRINT_CHK == '2' ? 'checked' : ''}
                                   class="required" onClick="setPRINT_NUM('2');"><spring:message code="LABEL.A.A15.0016" /><%--담당부서 요청발행--%>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0018" /><%--제출처--%></th>
                        <td>
                            <input type="text" name="SUBMIT_PLACE" size="60" Maxlength="60" style="width: 700px;" class="required" placeholder="<spring:message code="LABEL.A.A15.0018" />" value="${resultData.SUBMIT_PLACE}">
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A18.0003" /><%--사용목적--%></th>
                        <td>
                            <input type="text" name="USE_PLACE" size="60" style="width: 700px;" class="required" placeholder="<spring:message code="LABEL.A.A18.0003" />" value="${resultData.USE_PLACE}">
                        </td>
                    </tr>

                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A18.0004" /><%--선택기간--%></th>
                        <td>
                            <input type="text" id="EBEGDA" name="EBEGDA" value="${resultData.EBEGDA}" size="20" class="date" placeholder="<spring:message code="LABEL.A.A18.0008" /><%--선택기간 시작일--%>">
                            <spring:message code="LABEL.A.A18.0006" /><%--부터--%>
                            <input type="text" id="EENDDA" name="EENDDA" value="${resultData.EENDDA}" size="20" class="date" placeholder="<spring:message code="LABEL.A.A18.0009" /><%--선택기간 종료일--%>">

                            <spring:message code="LABEL.A.A18.0007" /><%--까지--%>
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
                <div class="commentsMoreThan2">
                    <div><spring:message code="LABEL.A.A18.0005" /><%--선택기간은 출력하기를 원하는 1년 단위의 기간을 입력한다.--%></div>
                    <div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
                </div>

            </div>
        </div>

    </tags-approval:request-layout>
</tags:layout>


