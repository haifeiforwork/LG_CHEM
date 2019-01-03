<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 가족사항                                                    */
/*   Program ID   : A12FamilyChange.jsp                                         */
/*   Description  : 가족사항수정입력                                            */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-02  윤정현                                          */
/*                  2007-8-30    heli  global hr update                                                            */
/*				  : 2011-07-13 liukuo @v1.3 [C20110707_21496] Family 增加家属来排遣地日期		    */
/*				  : 2011-08-12 liukuo @v1.4 [C20110728_35671] Family 有关家属医疗费逻辑条件增加申请		    */
/*               : 2012-07-11 lixinxin@v1.5 [C20120710_44214] Family 相关信息添加 电话号、邮箱*/
/*				  : 2012-07-17 lixinxin@v1.6 [C20120716_47583 ] Family 替换详细信息 将油箱换成现居住地址*/
/*               : 2012-08-06 lixinxin@v1.7 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<%--@elvariable id="phonenumdata" type="hris.common.PersonData"--%>
<%--@elvariable id="a04FamilyDetailData" type="hris.A.A04FamilyDetailData"--%>

<tags-family:family-build-layout><%--@elvariable id="PersonData" type="hris.common.PersonData"--%>
    <tags:script>
        <script>
            function add_name(){
                if(checkEnglish(document.form1.FANAM.value) && checkEnglish(document.form1.FAVOR.value)){
                    document.form1.ENAME.value=document.form1.FAVOR.value+' '+document.form1.FANAM.value;
                }else{
                    document.form1.ENAME.value=document.form1.FANAM.value+' '+document.form1.FAVOR.value;
                }
            }

            /*function do_input() {
                if(document.form1.FANAM.value==''){
                    alert('<spring:message code="MSG.A.A12.0029" />'); //Last Name is empty
                    document.form1.FANAM.focus();
                    return;
                }else if(document.form1.FAVOR.value==''){
                    alert('<spring:message code="MSG.A.A12.0030" />'); //First Name is empty
                    document.form1.FAVOR.focus();
                    return;
                }else if(document.form1.FGBDT.value==''){
                    alert('<spring:message code="MSG.A.A12.0031" />'); //birthday is empty
                    document.form1.FGBDT.focus();
                    return;
                }else if(document.form1.SUBTY.value==''){
                    alert('<spring:message code="MSG.A.A12.0032" />'); //Family Type is empty
                    document.form1.SUBTY.focus();
                    return;
                }else if(document.form1.TELNR.value ==''){ //2012-07-11 lixinxin@v1.5 [C20120710_44214] Family 相关信息添加 电话号、邮箱
                    alert('<spring:message code="MSG.A.A12.0033" />'); //Tel. Number is empty
                    document.form1.TELNR.focus();
                    return;
                }else if(document.form1.FAMIADDR.value ==''){ //2012-07-17 lixinxin@v1.6 [C20120716_47583 ] Family 替换详细信息 将油箱换成现居住地址
                    alert('<spring:message code="MSG.A.A12.0034" />'); //Current home address is empty
                    document.form1.FAMIADDR.focus();
                    return;
                }

                <%--begin 2015-12-01 pangmin@ [CSR ID:2957295] 黑客攻击预防XSS改善 文本编辑区字符转义 --%>
                if(document.form1.FAMIADDR.value!=''){

                    var content = document.form1.FAMIADDR.value;
                    content = content.replace(new RegExp(/(<)/g),'&lt;');
                    content = content.replace(new RegExp(/(>)/g),'&gt;');
                    content = content.replace(new RegExp(/({)/g),'&#40;');
                    content = content.replace(new RegExp(/(})/g),'&#41;');
                    content = content.replace(new RegExp(/(#)/g),'&#35;');
                    content = content.replace(new RegExp(/(&)/g),'&#38;');

                    <%--
                            content = content.replace(new RegExp(/(<script>)/g),' ');
                             content = content.replace(new RegExp(/(<object>)/g),' ');
                             content = content.replace(new RegExp(/(<applet>)/g),' ');
                             content = content.replace(new RegExp(/(<form>)/g),' ');
                             content = content.replace(new RegExp(/(<embed>)/g),' ');
                             content = content.replace(new RegExp(/(<iframe>)/g),' ');
                             content = content.replace(new RegExp(/(<base>)/g),' ');
                             content = content.replace(new RegExp(/(<body>)/g),' ');
                             content = content.replace(new RegExp(/(<frameset>)/g),' ');
                             content = content.replace(new RegExp(/(<html>)/g),' ');
                             content = content.replace(new RegExp(/(<img>)/g),' ');
                             content = content.replace(new RegExp(/(<layer>)/g),' ');
                             content = content.replace(new RegExp(/(<ilayer>)/g),' ');
                             content = content.replace(new RegExp(/(<meta>)/g),' ');
                             content = content.replace(new RegExp(/(<style>)/g),' ');
                             content = content.replace(new RegExp(/(<xxx src>)/g),' ');
                             content = content.replace(new RegExp(/(<p>)/g),' ');
                             content = content.replace(new RegExp(/(<a href>)/g),' ');
                              --%>

                    document.form1.FAMIADDR.value =content;

                }
                <%--end 2015-12-01 pangmin@ [CSR ID:2957295] 黑客攻击预防XSS改善  文本编辑区字符转义--%>

                <%--begin 2012-08-06 lixinxin@v1.7 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                if(document.form1.E_PERSG.value=='A'){
                    if(document.form1.ENTDT.value==''){
                        alert('<spring:message code="MSG.A.A12.0035" />'); //Entry Date is empty
                        document.form1.ENTDT.focus();
                        return;
                    }
                }
                <%--end 2012-08-06 lixinxin@v1.7 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                document.form1.jobid.value = "change";
                // 관계, 학력, 출생국, 국적명을 가져간다.
                if(!confirm('<spring:message code="MSG.A.A04.0002" />')) { //Are you sure to save?
                    return;
                } // end if
                document.form1.FGBDT.value=removePoint(document.form1.FGBDT.value);
                <%--2012-08-06 lixinxin@v1.7 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                if(document.form1.E_PERSG.value=='A'){
                    document.form1.ENTDT.value=removePoint(document.form1.ENTDT.value);
                }
                document.form1.action = '${g.servlet}hris.A.A12Family.A12FamilyChangeSV';
                document.form1.method = "post";
                document.form1.submit();

            }
            function checkNull(){
                if(document.form1.FANAM.value==''){
                    alert('<spring:message code="MSG.A.A12.0029" />'); //Last Name is empty
                    document.form1.FANAM.focus();
                    return;
                }else if(document.form1.FAVOR.value==''){
                    alert('<spring:message code="MSG.A.A12.0030" />'); //First Name is empty
                    document.form1.FAVOR.focus();
                    return;
                }else if(document.form1.ENTDT.value==''){
                    alert('<spring:message code="MSG.A.A12.0035" />'); //Entry Date is empty
                    document.form1.ENTDT.focus();
                    return;
                }else if(document.form1.FGBDT.value==''){
                    alert('<spring:message code="MSG.A.A12.0031" />'); //birthday is empty
                    document.form1.FGBDT.focus();
                    return;
                }else if(document.form1.SUBTY.value==''){
                    alert('<spring:message code="MSG.A.A12.0032" />'); //Family Type is empty
                    document.form1.SUBTY.focus();
                    return;
                }
            }
*/

            function beforeSubmit() {
                <%--begin 2015-12-01 pangmin@ [CSR ID:2957295] 黑客攻击预防XSS改善  文本编辑区字符转义--%>
                if(document.form1.FAMIADDR.value!=''){

                    var content = document.form1.FAMIADDR.value;
                    content = content.replace(new RegExp(/(<)/g),'&lt;');
                    content = content.replace(new RegExp(/(>)/g),'&gt;');
                    content = content.replace(new RegExp(/({)/g),'&#40;');
                    content = content.replace(new RegExp(/(})/g),'&#41;');
                    content = content.replace(new RegExp(/(#)/g),'&#35;');
                    content = content.replace(new RegExp(/(&)/g),'&#38;');

                    document.form1.FAMIADDR.value =content;

                }
                <%--end 2015-12-01 pangmin@ [CSR ID:2957295] 黑客攻击预防XSS改善  文本编辑区字符转义--%>
            }

        </script>
    </tags:script>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                <colgroup>
                    <col width="15%">
                    <col width="35%">
                    <col width="15%">
                    <col width="35%">
                </colgroup>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A14.0014"/><%--Last Name--%></th>
                    <td>
                        <input type="text" name="FANAM" value="${a04FamilyDetailData.FANAM}" size="30" class="required" onkeyup="javascript:add_name()"  maxlength="40"
                               placeholder="<spring:message code="MSG.A.A14.0014"/>" style="ime-mode:active;">
                    </td>
                    <th><span class="textPink">*</span><spring:message code="LABEL.A.A12.0002"/> <%--Family Type--%></th>
                    <td >
                        <c:choose>
                            <c:when test="${!isUpdate}">
                                <select name="SUBTY" class="required" placeholder="<spring:message code="LABEL.A.A12.0002"/>">
                                    <option value=""><spring:message code="MSG.A.A03.0020"/><!-- Select --></option>
                                        ${f:printOption(subTypeList, 'code', 'value', a04FamilyDetailData.SUBTY)}
                                </select>
                            </c:when>
                            <c:otherwise>
                                ${a04FamilyDetailData.FAMSA}
                                <input type="hidden" name="SUBTY"  value="${a04FamilyDetailData.SUBTY}">
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A14.0015"/><%--First Name--%></th>
                    <td ${PersonData.e_PERSG == 'A' ? "" : "colspan='3'"}>
                        <input type="text" name="FAVOR" class="required"  value="${a04FamilyDetailData.FAVOR}" style="ime-mode:active;" onkeyup="javascript:add_name()"  size="30"
                               placeholder="<spring:message code="MSG.A.A14.0015"/>">
                    </td>
                        <%--begin 2012-08-06 lixinxin@v1.7 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                    <c:if test="${PersonData.e_PERSG == 'A'}">
                        <!--添加了家属来排遣地日期的字段：ENTDT 2011-08-12 liukuo   @v1.4  [C20110728_35671]-->
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A12.0041"/> <%--Entry Date--%></th>
                        <td >
                            <input type="text" name="ENTDT" class="date required"  value="${f:printDate(a04FamilyDetailData.ENTDT) }" placeholder="<spring:message code="LABEL.A.A12.0041"/>">
                        </td>
                    </c:if>
                        <%--end 2012-08-06 lixinxin@v1.7 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A01.0002"/><%--Name--%></th>
                    <td colspan="3">
                        <input type="text" name="ENAME"  value="${a04FamilyDetailData.FANAM} ${a04FamilyDetailData.FAVOR}" class="input04" style="ime-mode:active;padding-top:3px;" size="30" readonly>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.A.A12.0006"/><%--Gender--%></th>
                    <td>
                        <input type="radio" name="FASEX" value="2" ${a04FamilyDetailData.FASEX != "1" ? "checked" : "" }>
                        <spring:message code="LABEL.A.A12.0020"/> <%--Female--%>
                        <input type="radio" name="FASEX" value="1" ${a04FamilyDetailData.FASEX == "1" ? "checked" : "" }>
                        <spring:message code="LABEL.A.A12.0019"/><%--Male--%>
                    </td>
                    <th><spring:message code="LABEL.A.A04.0003"/><!-- Corporation& Name --></th>
                    <td><input type="text" name="ERNAM2" maxlength="50" value="${a04FamilyDetailData.ERNAM2}"  size="20" ></td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A01.0026"/><%--Birth Date--%>&nbsp;</th>
                    <td >
                        <input type="text" id="FGBDT" name="FGBDT" class="date required" value="${f:printDate(a04FamilyDetailData.FGBDT)}" placeholder="<spring:message code="MSG.A.A01.0026"/>" >
                    </td>
                    <th><spring:message code="LABEL.A.A12.0010"/><!-- Occupation -->&nbsp;</th>
                    <td >
                        <select name="OCCUP" style="width:180px">
                            <option value=""><spring:message code="MSG.A.A03.0020"/><!-- Select --></option>
                            ${f:printOption(familyEntry1, "OCCUP", "OCTXT", a04FamilyDetailData.OCCUP)}
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A01.0024"/><!-- Nationality -->&nbsp;</th>
                    <td>
                        <select name="FANAT"  class="required" placeholder="<spring:message code="MSG.A.A01.0024"/>" >
                            ${f:printOption(nationList, "LAND1", "CNATIO", f:defaultString(a04FamilyDetailData.FANAT, user.area))}
                        </select>
                            <%--                          <input type="text" name="LANDX" size="20"   class="input04"    readonly>
                                                      <input type="hidden" name="FANAT" size="8"      readonly>    --%>
                    </td>
                    <th><spring:message code="MSG.A.A01.0033"/><!-- Political&nbsp;Status --></th>
                    <td >
                        <select name="PSTAT" style="width:180px">
                            <option value=""><spring:message code="MSG.A.A03.0020"/><!-- Select --></option>
                            ${f:printOption(familyEntry4, "PCODE", "PTEXT", a04FamilyDetailData.PSTAT)}
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.A.A04.0004"/><!-- Ctry of Birth --></th>
                    <td>
                        <select name="FGBLD"     >
                                ${f:printOption(nationList, "LAND1", "CNATIO", f:defaultString(a04FamilyDetailData.FGBLD, user.area))}
                        </select>
                            <%--                          <input type="text" name="FGBLD1" size="20"   class="input04"    readonly>
                                                      <input type="hidden" name="FGBLD" size="8"      readonly>  --%>
                    </td>
                    <th><spring:message code="LABEL.A.A12.0046"/><!-- Work in same company --></th>
                    <td> <input style="width:14px;" type="checkbox" name="SAMER" value="X" ${a04FamilyDetailData.SAMER == "X" ? "checked" : ""}> </td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A01.0025"/><!-- Birth Place --></th>
                    <td> <input type="text" name="FGBOT"  value="${a04FamilyDetailData.FGBOT}" size="20" > </td>
                    <!--  : 2012-07-11 lixinxin@v1.5 [C20120710_44214] Family 相关信息添加 电话号、邮箱 Tel. Number 、E-mail -->
                    <th><span class="textPink">*</span><spring:message code="LABEL.A.A04.0005"/><!-- Tel. Number --></th>
                    <td> <input type="text" name="TELNR"   value="${a04FamilyDetailData.TELNR}" class="required" placeholder="<spring:message code="LABEL.A.A04.0005"/>"  maxlength="20" size="20" > </td>
                </tr>
                <tr>
                    <!--    2012-07-17 lixinxin@v1.6 [C20120716_47583 ] Family 替换详细信息 将油箱换成现居住地址 -->
                        <%--
                            <th>E-mail</th>
                            <td  colspan="3"> <input type="text" name="NUMMAIL"  value="${a04FamilyDetailData.NUMMAIL}"   maxlength="132" size="30" > </td>
                        --%>

                    <th><spring:message code="MSG.A.A01.0043"/><!-- Current home address --></th>
                    <td  colspan="3"> <input type="text" name="FAMIADDR"  value="${a04FamilyDetailData.FAMIADDR}" placeholder="<spring:message code="MSG.A.A01.0043"/>"  maxlength="80" size="90" > </td>
                </tr>
            </table>
        </div>
    </div>
    <input type="hidden" name="ANREX"  value="${a04FamilyDetailData.ANREX}"  size="20" >
    <input type="hidden" name="FKNZN"  value="${f:defaultString(a04FamilyDetailData.FKNZN, "00")}"  size="20" >

    <input type="hidden" name="FAMSA"  value="">
    <input type="hidden" name="OBJPS"  value="${a04FamilyDetailData.OBJPS}">
    <input type="hidden" name="BEGDA"  value="${f:printDate(a04FamilyDetailData.BEGDA)}">
    <input type="hidden" name="ENDDA"  value="${f:printDate(a04FamilyDetailData.ENDDA)}">
    <input type="hidden" name="FGBNA"  value="${a04FamilyDetailData.FGBNA}">
    <input type="hidden" name="ERNAM"  value="${a04FamilyDetailData.ERNAM}">

    <input type="hidden" name="CNNAM"  value="${a04FamilyDetailData.CNNAM}">
    <input type="hidden" name="IDNUM"  value="${a04FamilyDetailData.IDNUM}">
    <input type="hidden" name="FINIT"  value="${a04FamilyDetailData.FINIT}">
    <input type="hidden" name="GBDEP"  value="${a04FamilyDetailData.GBDEP}">
    <input type="hidden" name="FAMST"  value="${a04FamilyDetailData.FAMST}">
    <input type="hidden" name="FASAR"  value="${a04FamilyDetailData.FASAR}">
    <input type="hidden" name="FASIN"  value="${a04FamilyDetailData.FASIN}">
    <input type="hidden" name="ADDAT"  value="${a04FamilyDetailData.ADDAT}">
    <input type="hidden" name="SAMER"  value="${a04FamilyDetailData.SAMER}">
</tags-family:family-build-layout>
