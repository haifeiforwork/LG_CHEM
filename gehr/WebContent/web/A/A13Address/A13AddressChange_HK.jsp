<%/******************************************************************************/
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
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-address" tagdir="/WEB-INF/tags/A/A13Address" %>
<%@ taglib prefix="un" uri="http://jakarta.apache.org/taglibs/unstandard-1.0" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>

<jsp:useBean id="resultData" class="hris.A.A13Address.A13AddressListData" scope="request"/>
<%--@elvariable id="g" type="com.common.Global"--%>
<tags-address:address-change-layout>
    <tags:script>
        <SCRIPT LANGUAGE="JavaScript">
            /*
             submit 이전 실행 될
             */
            function beforeSubmit() {
                document.form1.BEZEI4.value = document.form1.STATE.options[document.form1.STATE.selectedIndex].text;
                document.form1.ANSSA.value     = document.form1.SUBTY.value;
            }

            /**
             * 입력값 체크
             * @returns {boolean}
             */
            function validate() {

                return true;
            }

            function js_change() {
                js_change1();
                js_change2();
            }
            function js_change1() {
                document.form1.BEZEI.value     = document.form1.COUNC.value;
            }
            function js_change2() {
                document.form1.BEZEI2.value     = document.form1.STATE.value;
                document.form1.BEZEI4.value = document.form1.STATE.options[document.form1.STATE.selectedIndex].text;
            }

            function f_pop() {
                window.open("/web/A/A13Address/A13AddressBuildHkPopup.jsp?"+"BEZEI4="+document.form1.BEZEI2.value,"DeptPers",
                        "toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");
            }

            //-->
        </SCRIPT>
    </tags:script>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                <input type="hidden" name="ANSSA"     value="">
                <input type="hidden" name="ANSTX"     value="">
                <input type="hidden" name="SUBTY" value='${resultData.SUBTY}'>
                <colgroup>
                    <col width="160">
                    <col>
                </colgroup>
                <tr>
                    <th><spring:message code="MSG.A.A13.035"/><%--Address Type--%></th>
                    <td   class="td09">${resultData.ANSTX}</td>
                </tr>

                <tr>
                    <th nowrap><spring:message code="MSG.A.A13.032"/><%--2nd Address--%></th>
                    <td   class="td09">
                        <input type="text" name="LOCAT" size="60"   class="input03"   value="${resultData.LOCAT}" maxlength="60"  >
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.033"/><%--1st Address--%></th>
                    <td class="td09">
                        <input type="text" name="ORT01" size="60" class="input03" maxlength="60"  value="${resultData.ORT01}" >
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.034"/><%-- District--%></th>
                    <td  class="td09">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="width:58px"> <input type="text" name="COUNC" size="4"   class="input03"  value="${resultData.COUNC}"  readonly></td>
                                <td style="width:20px"><span style="display:inline;cursor:hand" ><img src="/web/images/btn_serch.gif" onclick="f_pop();"/></span></td>
                                <td><input type="text" name="BEZEI" size="20" class="input04" maxlength="20" value="${resultData.BEZEI}" readonly>
                                    <input type="hidden" name="BEZEI3" size="8"   class="input03"    readonly> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.039"/> <%--Area--%></th>
                    <td  class="td09">
                        <select name="STATE" class="input03" onchange="javascript:js_change2()">
                                ${f:printCodeOption(addressType, resultData.STATE)}
                        </select>
                        <input type="text" name="BEZEI2" size="20" class="input04" maxlength="20"  readonly>
                        <input type="hidden" name="BEZEI4" size="8"   class="input03"    readonly>
                    </td>
                </tr>
                <input type="hidden" name="LANDX" size="8"   class="input03"   value="${resultData.LANDX}" readonly>
                <input type="hidden" name="LAND1" size="12"   class="input03"   value="${resultData.LAND1}" readonly>

            </table>
        </div>
    </div>
</tags-address:address-change-layout>

