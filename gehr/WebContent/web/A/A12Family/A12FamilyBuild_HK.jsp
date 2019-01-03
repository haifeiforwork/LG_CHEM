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

            /*
             function doSubmit() {
             if(document.form1.FANAM.value==''){
             alert('<spring:message code="MSG.A.A12.0029" />'); //Last Name is empty
             document.form1.FANAM.focus();
             return;
             }else if(document.form1.FAVOR.value==''){
             alert('<spring:message code="MSG.A.A12.0030" />');  //First Name is empty
             document.form1.FAVOR.focus();
             return;
             }else if(document.form1.FGBDT.value==''){
             alert('<spring:message code="MSG.A.A12.0036" />');//Date of Birth  is empty
             document.form1.FGBDT.focus();
             return;
             }else if(document.form1.SUBTY.value==''){
             alert('<spring:message code="MSG.A.A12.0032" />'); //Family Type is empty
             document.form1.SUBTY.focus();
             return;
             }
            <%--begin 2012-08-06 lixinxin@v1.5 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
             if(document.form1.E_PERSG.value=='A'){
             if(document.form1.ENTDT.value==''){
             alert('<spring:message code="MSG.A.A12.0035" />');//Entry Date is empty
             document.form1.ENTDT.focus();
             return;
             }
             }
            <%--end 2012-08-06 lixinxin@v1.5 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
             if(!confirm('<spring:message code="MSG.A.A04.0002" />')) { //Are you sure to save?
             return;
             } // end if
             document.form1.jobid.value = "create";
             document.form1.FGBDT.value=removePoint(document.form1.FGBDT.value);
            <%--2012-08-06 lixinxin@v1.5 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
             if(document.form1.E_PERSG.value=='A'){
             document.form1.ENTDT.value=removePoint(document.form1.ENTDT.value);
             }
             document.form1.action = "${g.servlet}hris.A.A12Family.A12SupportBuildSV";
             document.form1.method = "post";
             document.form1.submit();

             }
*/

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
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A14.0014" /><!-- Last Name -->&nbsp;</th>
                    <td>
                        <input type="text" name="FANAM" value="${a04FamilyDetailData.FANAM}" class="required" onkeyup="javascript:add_name()" placeholder="<spring:message code="MSG.A.A14.0014" />" >
                    </td>
                    <th><span class="textPink">*</span><spring:message code="LABEL.A.A04.0001" /><!-- Family&nbsp;Type --></th>
                    <td>
                        <c:choose>
                            <c:when test="${!isUpdate}">
                                <select name="SUBTY" class="required" placeholder="<spring:message code="LABEL.A.A04.0001" />">
                                    <option value=""><spring:message code="MSG.A.A03.0020" /><!-- Select --></option>
                                        ${f:printOption(subTypeList, 'code', 'value', null)}
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
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A14.0015" /><!-- First Name -->&nbsp;</th>
                    <td>
                        <input type="text" name="FAVOR" class="required"  value="${a04FamilyDetailData.FAVOR}" onkeyup="javascript:add_name()" placeholder="<spring:message code="MSG.A.A14.0015" />">
                    </td>
                    <th><spring:message code="LABEL.A.A04.0006" /><!-- Birth name --></th>
                    <td>
                        <input type="text" name="FGBNA" value="${a04FamilyDetailData.FGBNA }" size="20"  >
                    </td>

                </tr>
                <tr>
                    <th><spring:message code="LABEL.A.A12.0006" /><!-- Gender --></th>
                    <td>
                        <input type="radio" name="FASEX" value="2" ${a04FamilyDetailData.FASEX != "1" ? "checked" : "" }>
                        <spring:message code="LABEL.A.A12.0020" /><!-- Female -->
                        <input type="radio" name="FASEX" value="1" ${a04FamilyDetailData.FASEX == "1" ? "checked" : "" }>
                        <spring:message code="LABEL.A.A12.0019" /><!-- Male -->
                    </td>
                    <th><spring:message code="LABEL.A.A04.0007" /><!-- Initials --></th>
                    <td>
                        <input type="text" name="FINIT" value="${a04FamilyDetailData.FINIT }" size="20"  >
                    </td>
                </tr>

                <tr>
                    <th><spring:message code="LABEL.A.A12.0009" /><!-- Nationality --></th>
                    <td colspan="3">
                        <select name="FANAT">
                            ${f:printOption(nationList, "LAND1", "CNATIO", f:defaultString(a04FamilyDetailData.FANAT, user.area))}
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.A.A12.0005" /><!-- Birth&nbsp;Date --></th>
                    <td>
                        <input type="text" id="FGBDT" name="FGBDT" class="date required" value="${f:printDate(a04FamilyDetailData.FGBDT)}" placeholder="<spring:message code="LABEL.A.A12.0005" />" >
                    </td>
                    <th><spring:message code="LABEL.A.A12.0007" /><!-- Birth Place --></th>
                    <td>
                        <input type="text" name="FGBOT" value="${a04FamilyDetailData.FGBOT }" size="20"  >
                    </td>
                </tr>
                    <%--begin 2012-08-06 lixinxin@v1.5 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                <c:if test="${PersonData.e_PERSG == 'A'}">
                <tr>
                    <!--添加了家属来排遣地日期的字段：ENTDT 2011-08-12 liukuo   @v1.4  [C20110728_35671]-->
                    <th><span class="textPink">*</span><spring:message code="LABEL.A.A12.0041" /><!-- Entry Date --></th>
                    <td colspan="3">
                        <input type="text" name="ENTDT" class="date required"  value="${f:printDate(a04FamilyDetailData.ENTDT) }" placeholder="<spring:message code="LABEL.A.A12.0041" />">
                    </td>
                </tr>
                </c:if>
                    <%--end 2012-08-06 lixinxin@v1.5 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                    <%--                       <tr>
                                            <th>Marital Status</th>
                                            <td colspan="3" >
                    <%
                        if((data!=null)&&(data.SUBTY.equals("1"))){
                     %>
                                             <input type="text" name="FAMST1" value="<%= WebUtil.printOptionText((Vector)((new A12FamilyUtil()).getElements(user.empNo)).get(3),data==null ? "0" : data.FAMST) %>" size="1" maxlength="1" readonly >
                    <% }else{ %>
                                            <select name="FAMST2" onchange="javascript:js_change4()">
                                                <option value="">Select</option>
                                               <%= WebUtil.printOption((Vector)((new A12FamilyUtil()).getElements(user.empNo)).get(3),data==null ? "" : data.FAMST) %>
                                            </select>
                                                <input type="hidden" name="FAMST1" size="8"      readonly>
                                                <input type="hidden" name="FAMST" size="8"      readonly>
                    <%} %>
                                            </td>
                                          </tr> --%>
                <tr>
                    <th><spring:message code="LABEL.A.A04.0008" /><!-- Academic Background --></th>
                    <td >

                        <select name="FASAR" >
                            <option value=""><spring:message code="MSG.A.A03.0020" /><!-- Select --></option>
                            ${f:printOption(familyEntry, "SLART", "STEXT", a04FamilyDetailData.FASAR)}
                        </select>
                    </td>
                    <th><spring:message code="LABEL.A.A04.0009" /><!-- Institute --></th>
                    <td > <input type="text" name="FASIN"  value="${a04FamilyDetailData.FASIN }" size="20"  >
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.A.A12.0010" /><!-- Occupation --></th>
                    <td >
                        <select name="OCCUP" >
                            <option value=""><spring:message code="MSG.A.A03.0020" /><!-- Select --></option>
                            ${f:printOption(familyEntry1, "OCCUP", "OCTXT", a04FamilyDetailData.OCCUP)}
                        </select>
                    </td>
                    <th><spring:message code="LABEL.A.A04.0003" /><!-- Coporation Name --></th>
                    <td >
                        <input type="text" name="ERNAM"  value="${a04FamilyDetailData.ERNAM }"  >
                    </td>
                </tr>
            </table>
        </div>
    </div>


    <input type="hidden" name="FAMSA"  value="">
    <input type="hidden" name="OBJPS"  value="${a04FamilyDetailData.OBJPS }">
    <input type="hidden" name="BEGDA"  value="${data.BEGDA }">
    <input type="hidden" name="ENDDA"  value="${f:printDate(data.ENDDA) }">
    <input type="hidden" name="GBDEP"  value="${a04FamilyDetailData.GBDEP }">
    <input type="hidden" name="FGBLD"  value="${a04FamilyDetailData.FGBLD }">
    <input type="hidden" name="PSTAT"  value="${a04FamilyDetailData.PSTAT }">
    <input type="hidden" name="CNNAM"  value="${a04FamilyDetailData.CNNAM }">
    <input type="hidden" name="IDNUM"  value="${a04FamilyDetailData.IDNUM }">
    <input type="hidden" name="ADDAT"  value="${a04FamilyDetailData.ADDAT }">
    <input type="hidden" name="SAMER"  value="${a04FamilyDetailData.SAMER }">
    <input type="hidden" name="ENAME"  value="${a04FamilyDetailData.ENAME }">
</tags-family:family-build-layout>
