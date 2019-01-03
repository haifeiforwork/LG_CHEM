<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%-- 대리신청 가능 여부 default true --%>
<%@ attribute name="representative" type="java.lang.Boolean"  %>
<%@ attribute name="formName" type="java.lang.String"  %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>"/>
<c:set var="formName" value="${empty formName ? 'form1' : formName}"/>

<%-- 대리신청 시작 --%>
<c:if test="${user.e_representative == 'Y' }">
    <tags:script>
        <script>
            /*  공통 대리신청시 대상자 검색 */
            /*function pers_search() {
             //  ------------------------------------------------------------
             var win = window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");
             document.approvalHeaderSearchForm.submit();
             win.focus();
             }*/

            function reload() {
                var frm =  document.form1;
                frm.jobid.value = "first";
                frm.action = "";
                frm.target = "";
                frm.submit();
            }

            function pers_search() {

                if(event.keyCode && event.keyCode != 13) return;

                var searchFrom = document.form1;

                var _gubun = $("#APPR_SEARCH_GUBUN").val();
                var _value = $("#APPR_SEARCH_VALUE").val();

                if ( _.isEmpty(_value)) {
                    if(_gubun == "1")
                        alert("<spring:message code='MSG.APPROVAL.SEARCH.PERNR.REQUIRED'/>");//검색할 부서원 사번을 입력하세요
                    if(_gubun == "2")
                        alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.REQUIRED'/>");//검색할 부서원 성명을 입력하세요

                    _value.focus();
                    return;
                }

                if( _gubun == "1" ) {                   //사번검색
                    searchFrom.jobid.value = "pernr";
                } else if( _gubun == "2" ) {            //성명검색

                    if(_value.length < 2 ) {
                        alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.MIN'/>")
                        _value.focus();
                        return;
                    }

                    searchFrom.jobid.value = "ename";
                }

                var searchApprovalHeaderPop = window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=450,top=00");

                searchApprovalHeaderPop.focus();

                searchFrom.target = "DeptPers";
                searchFrom.action = "${g.jsp}common/SearchDeptPersonsWait_R.jsp";
                searchFrom.submit();
                //$(searchFrom).unloadingSubmit();
            }

            //조직도 검사Popup.
            function organ_search() {
                var searchFrom = document.form1;
                var searchApprovalHeaderPop = window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=520,left=450,top=0");
                searchFrom.target = "Organ";
                searchFrom.action = "${g.jsp}common/ApprovalOrganListFramePop.jsp";
                searchFrom.submit();

                searchApprovalHeaderPop.focus();

            }

            /*  공통 대리신청시 대상자 검색 끝*/
        </script>
    </tags:script>




    <div class="tableInquiry">
        <table>
            <tr>
                <th><img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" /></th>
                <th><!--선택구분--><spring:message code="LABEL.COMMON.0003" /></th>
                <td>
                    <select id="APPR_SEARCH_GUBUN" name="I_GUBUN" onChange="$('#APPR_SEARCH_VALUE').val('').focus();">
                        <option value="2"><!--성명별--><spring:message code="LABEL.COMMON.0004" /></option>
                        <option value="1"><!--사번별--><spring:message code="LABEL.COMMON.0005" /></option>
                    </select>
                    <input type="text"  id="APPR_SEARCH_VALUE" name="I_VALUE1" size="17"  maxlength="10"  onkeydown="pers_search();" style="ime-mode:active" >
                    <input type="hidden" name="jobid" />
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search"  onclick="pers_search();"><span><!--사원찾기--><spring:message code="LABEL.COMMON.0006" /></span></a>
                    </div>
                </td>
                <td>
                    <img class="searchIcon" src="<%= WebUtil.ImageURL %>sshr/icon_map_g.gif" />
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search"  onclick="organ_search()"><span><!--조직도로 찾기--><spring:message code="LABEL.COMMON.0011" /></span></a>
                    </div>
                </td>
            </tr>
                <%--            <input type="hidden" name="I_DEPT"   value="<%= user.empNo  %>">
                            <input type="hidden" name="E_RETIR"  value="<%= user.e_retir %>">
                            <input type="hidden" name="count"    value="<%= l_count %>">--%>

        </table>

    </div>

</c:if>