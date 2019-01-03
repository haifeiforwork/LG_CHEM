<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주소                                                        */
/*   Program Name : 주소                                                        */
/*   Program ID   : A13AddressBuild_KR.jsp                                         */
/*   Description  : 주소 입력                                                   */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-27  윤정현                                          */
/*                                                                              */
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-util" tagdir="/WEB-INF/tags/util" %>
<%@ taglib prefix="tags-address" tagdir="/WEB-INF/tags/A/A13Address" %>
<%@ taglib prefix="un" uri="http://jakarta.apache.org/taglibs/unstandard-1.0" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<jsp:useBean id="resultData" class="hris.A.A13Address.A13AddressListData" scope="request"/>
<%--@elvariable id="g" type="com.common.Global"--%>
<tags-address:address-change-layout>
    <tags:script>
        <SCRIPT LANGUAGE="JavaScript">
            /*
             submit 이전 실행 될
             */
            function beforeSubmit() {
                document.form1.ANSSA.value = document.form1.SUBTY.value;
                document.form1.ANSTX.value = document.form1.STEXT.value;
            }

            /**
             * 입력값 체크
             * @returns {boolean}
             */
            function validate() {

                return true;
            }

            function onlychinese() {
                if ((window.event.keyCode >= 32) && (window.event.keyCode <= 126)) {
                    window.event.keyCode = 0;
                }
            }


            function js_change() {
                document.form1.ANSSA.value = document.form1.SUBTY.value;
                //document.form1.ANSTX.value     = document.form1.SUBTY.options[document.form1.SUBTY.selectedIndex].text;
                //document.form1.LANDX.value     = document.form1.LAND1.value;
                //document.form1.BEZEI2.value     = document.form1.SUBTY.options[document.form1.SUBTY.selectedIndex].text;

                document.form1.ADRTW.value = document.form1.BEZEI1.value + " " + document.form1.BEZEI2.value + " " + document.form1.STRAS.value;

            }
            function f_pop() {
                window.open("/web/A/A13Address/A13AddressBuildTWPopup.jsp", "DeptPers",
                        "toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");
            }
            function display() {
                document.form1.ADRTW.value = document.form1.BEZEI1.value + document.form1.BEZEI2.value + document.form1.STRAS.value;
            }

            //-->
        </SCRIPT>
    </tags:script>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                <input type="hidden" name="ANSSA" value="">
                <input type="hidden" name="ANSTX" value="">
                <input type="hidden" name="SUBTY" value='${resultData.SUBTY}'>
                <colgroup>
                    <col width="15%"/>
                    <col width="35%"/>
                    <col width="15%"/>
                    <col width="35%"/>
                </colgroup>
                <tr>
                    <th><spring:message code="MSG.A.A13.035"/><%--Address Type--%></th>
                    <td class="td09" colspan="3">
                        <input type="text" name="STEXT" size="20" class="input03"
                               value="${resultData.ANSTX}" readonly style="border:none">
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.007" /><%--ZIP Code--%></th>
                    <td class="td09" colspan="3">
                        <input type="text" name="PSTLZ" size="7" class="input03" style="text-align:right;" value="${resultData.PSTLZ}" readonly>
                        <img src="/web/images/btn_serch.gif" onclick="f_pop();" style="cursor:hand;"/>

                    </td>

                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.036"/><%--Region--%></th>
                    <td class="td09">
                        <input type="text" name="STATE" size="8" class="input03"
                               value="${resultData.STATE}"
                               style="border:none;text-align:center;" readonly>
                        <input type="text" name="BEZEI1" size="8" class="input03"
                               value="${resultData.BEZEI}" style="border:none" readonly>
                    </td>
                    <input type="hidden" name="LANDX" size="8" class="input03"
                           value="${resultData.LANDX}" readonly>
                    <input type="hidden" name="LAND1" size="12" class="input03"
                           value="${resultData.LAND1}" readonly>

                    <th><spring:message code="MSG.A.A13.011"/><%--County--%></th>
                    <td class="td09">
                        <input type="text" name="COUNC" size="8" class="input03"
                               value="${resultData.COUNC}"
                               style="border:none;text-align:center;" readonly>
                        <input type="text" name="BEZEI2" size="8" class="input03"
                               value="${resultData.BEZEI1}" style="border:none" readonly>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.037"/><%--Full add.--%></th>
                    <td class="td09" colspan="3">
                        <input type="text" name="STRAS" size="100" class="input03"
                               maxlength="80" value="${resultData.STRAS}" Onkeyup="display()"
                               onkeypress="onlychinese() ">
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td class="td09" colspan="3">
                        <input type="text" name="ADRTW" size="100" class="input03"
                               maxlength="80" readonly>
                    </td>
                </tr>

            </table>
        </div>
    </div>
</tags-address:address-change-layout>
