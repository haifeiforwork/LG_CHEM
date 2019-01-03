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

            /*function doSubmit() {
             if(document.form1.FANAM.value==''){
             alert('<spring:message code="MSG.A.A12.0029" />'); //Last Name is empty
             document.form1.FANAM.focus();
             return;
             }else if(document.form1.FAVOR.value==''){
             alert('<spring:message code="MSG.A.A12.0030" />'); //First Name is empty
             document.form1.FAVOR.focus();
             return;
             }else if(document.form1.FGBDT.value==''){
             alert('<spring:message code="MSG.A.A12.0036" />'); //Date of Birth  is empty
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
             alert('<spring:message code="MSG.A.A12.0035" />'); //Entry Date is empty
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
                        <%--begin 2012-08-06 lixinxin@v1.5 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A14.0014"/><%--Last Name--%>&nbsp;</th>
                    <td  ${PersonData.e_PERSG == 'A' ? "" : "colspan='3'"}>
                        <input type="text" name="FANAM" value="${a04FamilyDetailData.FANAM }" class="required" placeholder="<spring:message code="MSG.A.A14.0014"/>" onkeyup="javascript:add_name()">
                    </td>
                    <!--添加了家属来排遣地日期的字段：ENTDT 2011-08-12 liukuo   @v1.4 [C20110728_35671] -->
                    <c:if test="${PersonData.e_PERSG == 'A'}">
                    <th><span class="textPink">*</span><spring:message code="LABEL.A.A12.0041"/><%--Entry Date--%>&nbsp;</th>
                        <%--2014-09-17 pangxiaolin@v1.6 [C20140916_08441] 修改E-HR设置申请 start
                        <td  > <input type="text" name="ENTDT"  value="<%= (data==null ||"0000-00-00".equals(a04FamilyDetailData.ENTDT))? "" : WebUtil.printDate(a04FamilyDetailData.ENTDT) %>" onBlur="f_dateFormat(this);" onkeypress="EnterCheck2(this)" class="input03" size="7" ><a href="javascript:fn_openCal('ENTDT')"> <img src="<%= WebUtil.ImageURL %>icon_diary.gif" align="absmiddle" style="cursor:hand;" border="0" ></a></td> --%>
                    <td>
                        <input type="text" name="ENTDT" class="required ${isUpdate ? "" : "date"}" placeholder="<spring:message code="LABEL.A.A12.0041"/>"
                               value="${f:printDate(a04FamilyDetailData.ENTDT)}" ${isUpdate ? "readonly='true'" : ""}>
                    </td>
                        <%--2014-09-17 pangxiaolin@v1.6 [C20140916_08441] 修改E-HR设置申请 end--%>
                    </c:if>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A14.0015"/><%--First Name--%>&nbsp;</th>
                    <td  >
                        <input type="text" name="FAVOR"  value="${a04FamilyDetailData.FAVOR }" class="required" placeholder="<spring:message code="MSG.A.A14.0015"/>"  onkeyup="javascript:add_name()">
                    </td>
                    <th><span class="textPink">*</span><spring:message code="LABEL.A.A12.0002"/> <%--Family Type--%></th>
                    <td  >
                        <c:choose>
                            <c:when test="${!isUpdate}">
                                <select name="SUBTY" class="required" placeholder="<spring:message code='LABEL.A.A12.0002'/>">
                                    <option value=""><spring:message code="MSG.A.A03.0020"/><!-- Select --></option>
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
                    <th><spring:message code="LABEL.A.A12.0042"/> <%--Chinese Name--%></th>
                    <td  > <input type="text" name="CNNAM"  value="${a04FamilyDetailData.CNNAM }" class="input03" > <spring:message code="LABEL.A.A12.0043"/> <%--Must Input Chinese--%>
                    </td>
                    <th><spring:message code="LABEL.A.A12.0006"/><%--Gender--%></th>
                    <td >
                        <input type="radio" name="FASEX" value="2" ${a04FamilyDetailData.FASEX != "1" ? "checked" : "" }>
                        <spring:message code="LABEL.A.A12.0020"/> <%--Female--%>
                        <input type="radio" name="FASEX" value="1" ${a04FamilyDetailData.FASEX == "1" ? "checked" : "" }>
                        <spring:message code="LABEL.A.A12.0019"/><%--Male--%>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="MSG.A.A01.0026"/><%--Birth Date--%>&nbsp;</th>
                    <td >
                        <input type="text" id="FGBDT" name="FGBDT" class="date required" value="${f:printDate(a04FamilyDetailData.FGBDT)}" placeholder="<spring:message code="MSG.A.A01.0026"/>" >
                    <th><spring:message code="LABEL.A.A12.0009"/><%--Nationality--%></th>
                    <td >
                        <select name="FANAT"   class="input03"  >
                            ${f:printOption(nationList, "LAND1", "CNATIO", f:defaultString(a04FamilyDetailData.FANAT, user.area))}
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.A.A12.0007"/><!-- Birth Place --></th>
                    <td  colspan="3"> <input type="text" name="FGBOT"  value="${a04FamilyDetailData.FGBOT }" class="input03" size="20" >
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.A.A04.0010"/><!-- ID number --></th>
                    <td  colspan="3"> <input type="text" name="IDNUM"  value="${a04FamilyDetailData.IDNUM }" class="input03" size="20"  >
                    </td>

                </tr>
            </table>
        </div>
    </div>
    <%--end 2012-08-06 lixinxin@v1.5 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
    <input type="hidden" name="FKNZN"  value="${f:defaultString(a04FamilyDetailData.FKNZN, "00")}" >

    <input type="hidden" name="FAMSA"  value="">
    <input type="hidden" name="OBJPS"  value="${a04FamilyDetailData.OBJPS }">
    <input type="hidden" name="BEGDA"  value="${f:printDate(a04FamilyDetailData.BEGDA) }">
    <input type="hidden" name="ENDDA"  value="${f:printDate(a04FamilyDetailData.ENDDA) }">

    <input type="hidden" name="FGBNA"  value="${a04FamilyDetailData.FGBNA }">
    <input type="hidden" name="ERNAM"  value="${a04FamilyDetailData.ERNAM }">
    <input type="hidden" name="OCCUP"  value="${a04FamilyDetailData.OCCUP }">
    <input type="hidden" name="PSTAT"  value="${a04FamilyDetailData.PSTAT }">


    <input type="hidden" name="FINIT"  value="${a04FamilyDetailData.FINIT }">
    <input type="hidden" name="GBDEP"  value="${a04FamilyDetailData.GBDEP }">
    <input type="hidden" name="FAMST"  value="${a04FamilyDetailData.FAMST }">
    <input type="hidden" name="FASAR"  value="${a04FamilyDetailData.FASAR }">
    <input type="hidden" name="FASIN"  value="${a04FamilyDetailData.FASIN }">
    <input type="hidden" name="ADDAT"  value="${a04FamilyDetailData.ADDAT }">
    <input type="hidden" name="SAMER"  value="${a04FamilyDetailData.SAMER }">
    <input type="hidden" name="ENAME"  value="${a04FamilyDetailData.ENAME }">

    <input type="hidden" name="FGBLD"  value="${a04FamilyDetailData.FGBLD }">

    <input type="hidden" name="NHIFA"  value="${a04FamilyDetailData.NHIFA }">
    <input type="hidden" name="NHIST"  value="${a04FamilyDetailData.NHIST }">
    <input type="hidden" name="NHISR"  value="${a04FamilyDetailData.NHISR }">
</tags-family:family-build-layout>
