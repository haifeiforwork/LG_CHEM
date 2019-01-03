<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주소                                                        */
/*   Program Name : 주소                                                        */
/*   Program ID   : A13AddressChange.jsp                                        */
/*   Description  : 주소 수정                                                   */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-27  윤정현                                          */
/*                      2015-05-21 이지은 [CSR ID:2781990] 사보 주소 안내 문구 수정 요청                                                         */
/*                      2015-06-15 이지은 [CSR ID:2801513] 주소 입력/수정화면 수정   */
/*                      2015-08-13 이지은 [CSR ID:2849215] G-Portal 내 신주소 시스템 구축 요청  */
/*                      2017-09-28 이지은 [CSR ID:3497450] 주소 검색 창 오픈 안됨   */
/*                      2017-11-28 김주영 [CSR ID:3538214] 주소 변경시 하단 안내문구 수정 요청   */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-address" tagdir="/WEB-INF/tags/A/A13Address" %>
<%@ taglib prefix="un" uri="http://jakarta.apache.org/taglibs/unstandard-1.0" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />

<c:set var="direct" value="${user.e_oversea == 'X'}" />

<jsp:useBean id="resultData" class="hris.A.A13Address.A13AddressListData" scope="request" />
<%--@elvariable id="g" type="com.common.Global"--%>
<tags-address:address-change-layout>
    <tags:script>
        <%--<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>--%>
        <!-- [CSR ID:3497450] header 로 포함<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script> -->

        <SCRIPT LANGUAGE="JavaScript">
            /*
             submit 이전 실행 될
             */
            function beforeSubmit() {
                // 유형명, 국가명, 주거형태명을 가져간다.
                document.form1.LANDX.value     = document.form1.LAND1.options[document.form1.LAND1.selectedIndex].text;
                document.form1.LIVE_TEXT.value = document.form1.LIVE_TYPE.options[document.form1.LIVE_TYPE.selectedIndex].text;
            }

            /**
             * 입력값 체크
             * @returns {boolean}
             */
            function validate() {
                //////////////////////////////////////////////////////////

                // 상위주소-60 입력시 길이 제한
                x_org_value = document.form1.STRAS.value;
                x_obj = document.form1.STRAS;
                y_obj = document.form1.LOCAT;//[CSR ID:2849215] G-Portal 내 신주소 시스템 구축 요청
                xx_value = x_obj.value;

                /*[CSR ID:2849215] G-Portal 내 신주소 시스템 구축 요청
                 if( xx_value != "" && checkLength(xx_value) != 7 ){
                 alert("우편번호는 '-'를 포함하여 7자리여야 합니다.");
                 x_obj.focus();
                 x_obj.select();
                 return false;
                 }
                 */

                if (xx_value != "" && checkLength(xx_value) > 60) {
                    x_obj.value = limitKoText(x_org_value, 60);
                    y_obj.value = limitKoText2(x_org_value, 60) + " " + y_obj.value;
                    //alert("상위주소는 한글 30자, 영문 60자 이내여야 합니다.");
                    //x_obj.focus();
                    //x_obj.select();
                    //return false;
                }

                // 하위주소-40 입력시 길이 제한
                x_obj = document.form1.LOCAT;
                xx_value = x_obj.value;
                if (xx_value != "" && checkLength(xx_value) > 40) {
                    x_obj.value = limitKoText(xx_value, 40);
                    alert('<spring:message code="MSG.A.A13.028"/>'); //하위주소는 한글 20자, 영문 40자 이내여야 합니다.
                    x_obj.focus();
                    x_obj.select();
                    return false;
                }
               /* if (document.form1.SUBTY.value == "4" && checkNull(document.form1.TELNR, "전화번호를") == false) {
                    return false;
                }*/

                return true;
            }


            // 우편번호 버튼 클릭시 주소를 찾는 창이 뜬다.
            function fn_openZipCode() {
                small_window = window.open("${g.jsp}common/SearchAddr.jsp", "essPost", "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=no,scrollbars=yes,width=388,height=393,left=100,top=100");
                small_window.focus();
            }

            // 주소를 검색하여 우편번호와 주소를 받아온다.
            function searchAddrData(zip_code, address) {
                document.form1.PSTLZ.value = zip_code;
                document.form1.STRAS.value = address;
                document.form1.LOCAT.value = "";
                document.form1.LOCAT.focus();
            }

            function nation_get(obj) {
                var val = obj[obj.selectedIndex].value;     // 국가 코드 값..

                if (_.isEqual(val, 'KR')) {
                    $("#layer1").show();
                    <c:if test="${direct != true}">
                    $("#PSTLZ, #STRAS").attr("readonly", true);
                    </c:if>
                } else {
                    $("#layer1").hide();
                    <c:if test="${direct != true}">
                    $("#PSTLZ, #STRAS").attr("readonly", false);
                    </c:if>
                }
            }

            function js_change() {
                subty = document.form1.SUBTY.value;
                if (subty == "4") {
                    $("#TELNR").addClass("required");
                    $("#TELNRMask").show();
                    $(".tel-required").show();
                }
                else {
                    $("#TELNR").removeClass("required");
                    $("#TELNRMask").hide();
                    $(".tel-required").hide();

                }
            }


            // [CSR ID:2781990] 사보 주소 안내 문구 수정 요청
            function open_charge()
            {
                small_window=window.open("${g.jsp}common/HRChargePop.jsp?I_BUKRS=${user.companyCode}&I_GRUP_NUMB=${user.e_grup_numb}","Charge","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=712,height=420,left=100,top=100");
                small_window.focus();
            }

            //-->
        </SCRIPT>
    </tags:script>
    <div class="tableArea">
    <div class="table">
    <table class="tableGeneral">
        <colgroup>
            <col width="100">
            <col >
        </colgroup>
        <tr>
            <th><spring:message code="MSG.A.A13.010" /><%--주소유형--%></th>
            <td>
                <input type="text" name="ANSTX" size="8" value="${resultData.ANSTX}" readonly>

                <input type="hidden" name="LANDX"     value="">
                <input type="hidden" name="LIVE_TEXT" value="">
                <input type="hidden" name="SUBTY" value='${resultData.SUBTY}'>
                <input type="hidden" name="I_SUBTY" value='${resultData.SUBTY}'>
            </td>
        </tr>
        <tr>
            <th><spring:message code="MSG.A.A13.011" /><%--국가--%></th>
            <td>
                <select name="LAND1" onChange="javascript:nation_get(this);">
                    ${f:printOption(addressNation, "LAND1", "LANDX", resultData.LAND1)}
                </select>
            </td>
        </tr>
        <tr>
            <!-- [CSR ID:2801513] 우편번호, 주소 key in 가능하도록 변경 -->
            <th><span class="textPink">*</span><spring:message code="MSG.A.A13.007" /><%--우편번호--%></th>
            <c:set var="isKR" value="${resultData.LAND1 == 'KR'}" />
            <td>
                <input type="text" id="PSTLZ" name="PSTLZ" size="7" value="${resultData.PSTLZ}" maxlength="7" onBlur="phone_1(this);" ${isKR and direct != true? "readonly" : "" } class="required" placeholder="<spring:message code="MSG.A.A13.007" />">
                <c:if test="${direct != true}">
                <span id="layer1">
                    <a href="javascript:execDaumPostcode()"><img src="${g.image}sshr/ico_magnify.png" border="0"></a>
                </span>
                </c:if>
            </td>
        </tr>
        <tr>
            <th rowspan="2"><span class="textPink">*</span><spring:message code="MSG.A.A13.008" /><%--주소--%></th>
            <td>
                <input type="text" id="STRAS" name="STRAS" size="120" maxlength="60" value="${resultData.STRAS }" style="ime-mode:active" ${isKR and direct != true? "readonly" : "" } class="required" placeholder="<spring:message code="MSG.A.A13.008" />">
                <!-- <input type="text" name="STRAS" size="55" class="input03" maxlength="60" value="${resultData.STRAS}" style="ime-mode:active"> -->
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="text" id="LOCAT" name="LOCAT" size="120" maxlength="40" value="${resultData.LOCAT}" style="ime-mode:active" class="required" placeholder="<spring:message code="MSG.A.A13.008" />">
            </td>
        </tr>
        <!-- [CSR ID:2849215] G-Portal 내 신주소 시스템 구축 요청 -->
        <tr>
            <td>&nbsp;</td>
            <!-- <td colspan="2"><font color=blue> ※ 도로명 주소로 등록하실 경우 우편번호 및 주소를 직접 입력하여 주시기 바랍니다.</font></td> -->
            <td colspan="2"> <span id="guide" style="color:#999"></span></td>
        </tr>
        <tr>
            <%--<th id="tel" ><spring:message code="MSG.A.A13.014" />&lt;%&ndash;전화번호&ndash;%&gt;</th>--%>
            <th id="tel1" ><span id="TELNRMask" class="textPink">*</span><spring:message code="MSG.A.A13.014" /><%--전화번호--%></th>
            <td>
            	<input type="text" name="TELNR" size="20" value="${resultData.TELNR}" maxlength="14" onBlur="phone_bar(this);" placeholder="<spring:message code="MSG.A.A13.014" />">
                <span id="tel1_txt1" class="commentOne tel-required"><spring:message code="MSG.A.A13.029" /><%--배송시 연락가능한 전화번호(지역번호포함) 입력바람--%></span>
            </td>
        </tr>
        <tr>
            <th><spring:message code="MSG.A.A13.009" /><%--주거형태--%></th>
            <td>
                <select name="LIVE_TYPE" >
                    <option value="10">------------</option>
                    ${f:printCodeOption(addressLiveType, resultData.LIVE_TYPE)}
                </select>
                <span id="tel1_txt2" class="commentOne tel-required"><spring:message code="MSG.A.A13.030"/><%--주거형태는 입력필요없음--%></span>
            </td>
        </tr>

        <%--<c:if test="${resultData.SUBTY == '4'}">
        <tr >
            <th>색상</th>
            <td>
                <select name="ACOLOR" >
                    <option value="1" ${resultData.ACOLOR == '1' ? 'selected' : ''}>블루</option>
                    <option value="2" ${resultData.ACOLOR == '2' ? 'selected' : ''}>화이트</option>
                    <option value="3" ${resultData.ACOLOR == '3' ? 'selected' : ''}>핑크</option>
                </select>
            </td>
        </tr>
        </c:if>--%>
    </table>
    </div>
    <span class="commentOne"><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></span>
        <c:if test="${direct == true}">
        <div>
             <span class="commentOne"> 해외주재원은 우편번호 자동 검색기능이 불가하오니 직접 입력 바라며, 오배송 방지를 위하여 반드시 사전에 정확한 우편번호인지 확인하시기 바랍니다.</span>
        </div>
        </c:if>
    </div>
    <c:if test="${resultData.ANSTX == '현주소'}">
        <span class="inlineComment">
            <b>&nbsp;&nbsp;※</b>
            <!-- [CSR ID:2781990] 사보 주소 안내 문구 수정 요청 -->
            <!-- [CSR ID:3538214] 주소 변경시 하단 안내문구 수정 요청   start -->
            <spring:message code="MSG.A.A17.024"/>
            <%--위의 주소를 변경하시면 사보'LG화학 Family'도 변경된 주소로 발송됩니다. <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            신규/최신 주소는 향후 시스템에 추가할 예정이며, 추가전까지는 변경이 필요한 경우 담당자에게 메일로 요청해주시기 바랍니다.--%>
            <a href="javascript:open_charge();">[담당자 확인]</a><br>&nbsp;&nbsp;&nbsp;&nbsp;
		 <!-- [CSR ID:3538214] 주소 변경시 하단 안내문구 수정 요청 -->
            기타 사보관련 문의사항은 커뮤니케이션팀(lgsabo@lgchem.com, 02-3773-3186)으로 연락 바랍니다.
       </span>
    </c:if>

</tags-address:address-change-layout>



