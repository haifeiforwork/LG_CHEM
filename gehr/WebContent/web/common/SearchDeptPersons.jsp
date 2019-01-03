<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--*****************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 검색하는 include 파일                                  */
/*   Program ID   : SearchDeptPersons.jsp                                       */
/*   Description  : 사원 검색하는 include 파일                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-26  이승희                                          */
/*   Update       : 2005-02-14  윤정현                                          */
/*						2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건  */
/*******************************************************************************--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*"%>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<SCRIPT LANGUAGE="JavaScript">
<!--

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

    var searchApprovalHeaderPop = window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=450,top=00");

    searchApprovalHeaderPop.focus();

    searchFrom.target = "DeptPers";
    searchFrom.action = "${g.jsp}common/SearchDeptPersonsWait_R.jsp?I_GUBUN=" + _gubun + "&I_VALUE1=" + encodeURIComponent(_value);
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

//-->
</SCRIPT>
<%
    PersonData oPersonData = (PersonData)request.getAttribute("PersonData");
%>

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


    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral perInfo">
            	<colgroup>
            		<col width="10%" />
            		<col width="17%" />
            		<col width="10%" />
            		<col width="12%" />
            		<col width="6%" />
            		<col width="12%" />
            		<col width="10%" />

            		<col />
            	</colgroup>
                <tr>
					<th><!--부서--><spring:message code="LABEL.COMMON.0007" /></th>
                    <td><input class="" size="30" style="border-width:0;" type="text" value="<%=oPersonData.E_ORGTX%>" readonly></td>
                    <th class="th02"><%-- //[CSR ID:3456352] <!--직위--><spring:message code="LABEL.COMMON.0008" /> --%>
                    <!--직위/직급호칭--><spring:message code="MSG.A.A01.0083" />
                    </th>
                    <td><input class="" size="12" style="border-width:0;" type="text" value="<%=oPersonData.E_JIKWT%>" readonly></td>
                    <th class="th02"><!--직책--><spring:message code="LABEL.COMMON.0009" /></th>
                    <td><input class="" size="12" style="border-width:0;" type="text" value="<%=oPersonData.E_JIKKT%>" readonly></td>
                    <th class="th02"><!--성명--><spring:message code="LABEL.COMMON.0010" /></th>
                    <td>
                    <%= oPersonData.E_ENAME %> (<%=oPersonData.E_PERNR%>)
                    <input class=""  style="border-width:0;" type="hidden" value="<%=oPersonData.E_ENAME%>" readonly>
                    <input class="" size="9" style="border-width:0;text-align:left" type="hidden" value="<%=oPersonData.E_PERNR%>" readonly></td>
                </tr>

                <input type="hidden" name="I_DEPT"   value="<%=oPersonData.E_PERNR%>">
                <input type="hidden" name="retir_chk" value="">
            </table>

        </div>
    </div>
  <!--   사원검색 보여주는 부분  끝    -->