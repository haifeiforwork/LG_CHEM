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
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-address" tagdir="/WEB-INF/tags/A/A13Address" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<jsp:useBean id="a13AddressListData_vt" type="java.util.Vector" scope="request" />
<tags-address:address-build-layout>
    <tags:script>
        <SCRIPT LANGUAGE="JavaScript">
            /*
             submit 이전 실행 될
             */
            function beforeSubmit() {
                document.form1.ANSSA.value     = document.form1.SUBTY.value;
                document.form1.LAND1.value =   'CN';
                document.form1.LANDX.value =   'China';
            }

            /**
             * 입력값 체크
             * @returns {boolean}
             */
            function validate() {
                /*if(document.form1.SUBTY.value == ""){
                    alert("Please select Address Information.");
                    document.form1.SUBTY.focus();
                    return false;
                }


                if(document.form1.PSTLZ.value.length==0){
                    alert("Please input Zip Code.");
                    document.form1.PSTLZ.focus();
                    return false;
                }*/
                return true;
            }

            function js_change() {
                document.form1.ANSSA.value     = document.form1.SUBTY.value;
                document.form1.ANSTX.value     = document.form1.SUBTY.options[document.form1.SUBTY.selectedIndex].text;
            }

            function onlychinese()
            {
                if ((window.event.keyCode<48) || (window.event.keyCode>57) )
                {
                    window.event.keyCode = 0 ;
                }
            }

            function f_pop() {
                window.open("/web/A/A13Address/A13AddressBuildCNPopup.jsp","DeptPers",
                        "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=680,height=480,left=100,top=100");
            }
            function display() {
                document.form1.ORT02.value = document.form1.PRVNCX.value + document.form1.CITYTX.value  + document.form1.CNTYTX.value + document.form1.ADDRESS.value ;
            }
            function display1() {
                document.form1.ORT02.value = document.form1.PRVNCX.value  + document.form1.CNTYTX.value + document.form1.ADDRESS.value ;
            }

            //-->
        </SCRIPT>
    </tags:script>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                <colgroup>
                    <col width="160">
                    <col >
                </colgroup>
                <input type="hidden" name="LANDX" size="8"       readonly>
                <input type="hidden" name="LAND1" size="12"       readonly>
                <input type="hidden" name="ANSSA"     value="">
                <input type="hidden" name="ANSTX"     value="">
                <input type="hidden" name="PRVNCX" >
                <input type="hidden" name="CITYTX"   >
                <input type="hidden" name="CNTYTX"  >
                <input type="hidden" name="ADDRESS"  >
                <input type="hidden" name="STATE"      >

                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A13.031"/><%--Address Information--%></th>
                    <td>
                        <select name="SUBTY" onchange="javascript:js_change()" class="required" placeholder="<spring:message code="MSG.A.A13.031"/>">
                            <option value=""><spring:message code="MSG.A.A03.0020"/><!-- Select --></option>
                                ${f:printCodeOption(subTypeList, subty1)}
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A13.007" /><%--ZIP Code--%></th>
                    <td>
                        <input type="text" name="PSTLZ" size="7"  style="text-align:right;" class="required" placeholder="<spring:message code="MSG.A.A13.007" />">
                        <img src="/web/images/btn_serch.gif" onclick="f_pop();" style="cursor:hand;"/>
                    </td>
                </tr>
                <tr>
                    <th rowspan="2"><spring:message code="MSG.A.A13.008" /><%--Address--%></th>
                    <td>
                        <input type="text" name="ORT02" size="90"  maxlength="80" >
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="text" name="LOCAT" size="90"  maxlength="80"  >
                    </td>
                </tr>
            </table>
        </div>
    </div>

</tags-address:address-build-layout>