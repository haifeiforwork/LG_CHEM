<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="title" required="true" %>

<%--@elvariable id="resultData" type="hris.A.A20EmergencyContactsData"--%>

<tags:layout  help="A20EmergencyContactsUsa.html">
    <tags:script>
        <script language="JavaScript">
            <!--
            function check_data() {
                if (checkNull(document.form1.RLSHP, "<spring:message code='MSG.A.A20.0003' />" ) == false) {  //Relationship
                    return false;
                }
                if (checkNull(document.form1.ENACHN, "<spring:message code='MSG.A.A20.0004' />" ) == false) {  //Rel. Last Name
                    return false;
                }
                if (checkNull(document.form1.EVORNA, "<spring:message code='MSG.A.A20.0005' />" ) == false) {  //Rel. First Name
                    return false;
                }
                if (checkNull(document.form1.EMGPH1, "<spring:message code='MSG.A.A20.0006' />" ) == false) {  //Emerg. Ph#1
                    return false;
                }
                /*
                 if (checkNull(document.form1.EMGPH2, "Emerg. Ph#2" ) == false) {
                 return false;
                 }
                 */
                return true;
            }


            // 단순히 숫자와 '-'만을 체크한다.
            function onlyNumber(obj) {
                var resultVal = obj.value;
                var num="0123456789-";

                if( resultVal.length != 0 )	{
                    for( var i=0; i < resultVal.length ;i++ ) {
                        if( -1 == num.indexOf(resultVal.charAt(i)) ) {
                            alert("<spring:message code='MSG.A.A20.0010' />");  //Please input number.
                            obj.focus();
                            obj.select();
                            return false;
                        }
                    }
                }
                return true;
            }

            //-->
        </script>
    </tags:script>

    <h2 class="subtitle"><spring:message code="${title}"/><%--Emergency Contacts&nbsp;&nbsp;-&nbsp;&nbsp;Input--%></h2>

    <div class="tableArea">
        <div class="table">
            <form name="form1" method="post">
                <input type="hidden" name="jobid" />
            <table class="tableGeneral">
                <colgroup>
                    <col width="150">
                    <col >
                </colgroup>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A20.0003" /><%--Relationship--%></th>
                    <td>
                        <select name="RLSHP" class="input03">
                            <option value="">Select</option>
                                ${f:printCodeOption(relationList, resultData.RLSHP)}
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A20.0004" /><%--Rel. Last Name--%></th>
                    <td class="td09">
                        <input type="text" name="ENACHN" value="${resultData.ENACHN}" class="input03" size="30" maxlength="40" style="ime-mode:active;">
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A20.0005" /><%--Rel. First Name--%></th>
                    <td class="td09">
                        <input type="text" name="EVORNA" value="${resultData.EVORNA}" class="input03" size="30" maxlength="40" style="ime-mode:active;">
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A20.0006" /><%--Emerg. Ph#1--%></th>
                    <td class="td09">
                        <input type="text" name="EMGPH1" value="${f:insertStr(resultData.EMGPH1, "-", "3-3-4")}" class="input03" size="30" maxlength="12" style="ime-mode:active;" onkeyup="onlyNumber(this);">
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A20.0007" /><%--Emerg. Ph#2--%></th>
                    <td class="td09">
                        <input type="text" name="EMGPH2" value="${f:insertStr(resultData.EMGPH2, "-", "3-3-4")}" class="input03" size="30" maxlength="12" style="ime-mode:active;" onkeyup="onlyNumber(this);">
                    </td>
                </tr>
            </table>
            </form>
        </div>

        <div class="buttonArea">
                <%-- button --%>
            <ul class="btn_crud">

                <%-- button - 수정, 저장  --%>
                <jsp:doBody />

                <li><a href="${g.servlet}hris.A.A20EmergencyContactsListSV" ><span><spring:message code="BUTTON.COMMON.LIST" /></span></a></li>
            </ul>
        </div>
    </div>
</tags:layout>
