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
/*                                                                              */
/*   Update       : 2012-09-13 lilonghai @v1.1 [C20120911_81003 ] 进入Personal HR Info-Address 页面，点击correction按钮进到detail画面，直接点击保存，提示信息，保存不成功。*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
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
                document.form1.ANSSA.value     = document.form1.SUBTY.value;
                //2012-09-13 lilonghai @v1.1 [C20120911_81003 ] 进入Personal HR Info-Address 页面，点击correction按钮进到detail画面，直接点击保存，提示信息，保存不成功。
                if(document.form1.STATE.value == ""){
                    document.form1.STATE.value =  document.form1.STATE_OLD.value;
                }
            }

            /**
             * 입력값 체크
             * @returns {boolean}
             */
            function validate() {
               /* if(document.form1.PSTLZ.value.length==0){
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
                <input type="hidden" name="ANSSA"     value="">
                <input type="hidden" name="ANSTX"     value="${resultData.ANSTX}">
                <input type="hidden" name="PRVNCX">
                <input type="hidden" name="CITYTX"  >
                <input type="hidden" name="CNTYTX" >
                <input type="hidden" name="ADDRESS" >
                <input type="hidden" name="STATE"     >
                <!-- 2012-09-13 lilonghai @v1.1 [C20120911_81003 ] 进入Personal HR Info-Address 页面，点击correction按钮进到detail画面，直接点击保存，提示信息，保存不成功。 -->
                <input type="hidden" name="STATE_OLD"     value="${resultData.STATE}">
                <input type="hidden" name="SUBTY" value='${resultData.SUBTY}'>
                <colgroup>
                    <col width="160">
                    <col>
                </colgroup>
                <input type="hidden" name="LANDX" size="8"    value="${resultData.LANDX}"  readonly>
                <input type="hidden" name="LAND1" size="12"    value="${resultData.LAND1}"  readonly>
                <tr>
                    <th><spring:message code="MSG.A.A13.035"/><%--Address Type--%></th>
                    <td  class="td09">
                            ${resultData.ANSTX}
                    </td>
                </tr>
                <tr>
                    <th> <spring:message code="MSG.A.A13.007" /><%--ZIP Code--%></th>
                    <td  class="td09"  >
                        <table><tr><td>
                            <input type="text" name="PSTLZ" size="7"   class="required"   value="${resultData.PSTLZ}" style="text-align:right;" placeholder="<spring:message code="MSG.A.A13.007" />" ></td>
                            <td><img src="/web/images/btn_serch.gif" onclick="f_pop();" style="cursor:hand;"/></td>
                        </tr></table>
                    </td>
                </tr>

                <tr>
                    <th rowspan="2"><spring:message code="MSG.A.A13.008" /><%--Address--%></th>
                    <td class="td09"  >
                        <table><tr><td>
                            <input type="text" name="ORT02" size="90" value="${resultData.ORT02}" maxlength="80" >
                        </td></tr></table>
                    </td>
                </tr>
                <tr>

                    <td  class="td09" >
                        <table><tr><td>
                            <input type="text" name="LOCAT" size="90" value="${resultData.LOCAT}" maxlength="80"  >
                        </td></tr></table>
                    </td>
                </tr>

            </table>
        </div>
    </div>
</tags-address:address-change-layout>
