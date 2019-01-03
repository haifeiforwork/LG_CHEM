<%--
	program id; search-dept-layout.tag
 --%>

<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag import="com.common.Utils" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="deptId" type="java.lang.String" %>
<%@ attribute name="deptNm" type="java.lang.String" %>

<%@ attribute name="disabledSubOrg" type="java.lang.Boolean" %>
<%@ attribute name="deptTimelink" type="java.lang.Boolean" %>

<c:set var="g" value="<%=Utils.getBean("global")%>"/>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="checkYn" value="${empty checkYn ? param.checkYn : checkYn}" />


<SCRIPT LANGUAGE="JavaScript">
    <!--
    //부서명 검색
    function dept_search() {
        var frm = document.form1;
        var val = document.form1.txt_deptNm.value;
        document.form1.I_VALUE1.value = document.form1.txt_deptNm.value;


        val = rtrim(ltrim(val));

        if (document.form1.I_GBN.value == "ORGEH" && frm.txt_deptNm.value == "" ) {
            alert("<spring:message code='MSG.F.FCOMMON.0003' />"); //검색할 부서명을 입력하세요!
            frm.txt_deptNm.focus();
            return;
        }else if (document.form1.I_GBN.value=="RECENT"){
            document.form1.txt_deptNm.value = "";
         }
        var dept_search_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=500,height=550,left=100,top=100");
        dept_search_window.focus();
        frm.target = "DeptNm";
    <c:choose>
  	   	<c:when  test="${deptTimelink != true}" >
  	         frm.action = "${g.jsp}"+"common/SearchDeptNamePop.jsp";
           </c:when>
          <c:otherwise>
              frm.action = "${g.jsp}"+"D/D12Rotation/SearchDeptPersonsWait_Rot.jsp";
  		</c:otherwise>
  	</c:choose>
	          frm.submit();
    }


    //조직도 검사Popup.
    function organ_search() {
        var frm = document.form1;

        var organ_search_window = window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=400,height=550,left=100,top=100");
        organ_search_window.focus();
        frm.target = "Organ";
        frm.action = "${g.servlet}hris.common.OrganListPopSV";
        frm.submit();
    }

    function pop_search(){

        if(document.form1.I_GBN.value == "ORGEH"||document.form1.I_GBN.value=="RECENT"){
            dept_search();
        }else if(document.form1.I_GBN.value == "PERNR"){
            pers_search();
        }
    }

    function pers_search(){
        var val = document.form1.txt_deptNm.value;
        document.form1.I_VALUE1.value = document.form1.txt_deptNm.value;

        val = rtrim(ltrim(val));

        if ( val == "" ) {
            alert("<spring:message code='MSG.F.FCOMMON.0004' />"); // 검색할 부서원 성명을 입력하세요!
            document.form1.txt_deptNm.focus();

            return;
        } else {
            if( val.length < 2 ) {
                alert("<spring:message code='MSG.F.FCOMMON.0005' />"); //검색할 성명을 한 글자 이상 입력하세요!
                document.form1.txt_deptNm.focus();

                return;
            }
        }

        document.form1.retir_chk.value = "";

        var pers_searchPop =
                window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=550,height=550,left=100,top=100");
        pers_searchPop.focus();

        var oldTarget = document.form1.target;
        var oldAction = document.form1.action;

        document.form1.target = "DeptPers";





        document.form1.action = "${g.jsp}"+"D/D12Rotation/SearchDeptPersonsWait_Rot.jsp";
        document.form1.submit();

        document.form1.target = oldTarget;
        document.form1.action = oldAction;
    }

    // 체크박스 선택
    function fncCheckbox(deptId, deptNm) {
        var frm = document.form1;
        var deptNm = document.form1.hdn_deptNm.value;
        var deptId = document.form1.hdn_deptId.value;
        if ( frm.chk_organAll.checked == true )
            frm.chck_yeno.value = 'Y';
        else
            frm.chck_yeno.value = 'N';

        //체크박스 선택시 자동검색.
        setDeptID(deptId, deptNm);
    }
    //-->
</SCRIPT>

<link rel="stylesheet" href="${g.image}css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="${g.image}css/ehr_wsg.css" type="text/css">
<div class="tableInquiry ">
    <table>
        <colgroup>
		<col width="20%"/>
		<col width="30%"/>
		<col />
		<c:if test="${deptTimelink != true}">
		<col width="15%"/>
		<col />
		</c:if>
        </colgroup>
        <tbody>
        <tr>
            <th>
               <input type="hidden" name ="I_DeptTime" value='${deptTimelink != true ? 'N' : 'Y'}' >
                <img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
                <c:choose>
                <c:when test="${user.area == 'KR'}">
                <select id="I_GBN" name="I_GBN">
                    <option value="ORGEH"><!--부서명--><spring:message code="LABEL.F.FCOMMON.0001" /></option>
                    <option value="PERNR"><!--사원명--><spring:message code="LABEL.F.FCOMMON.0009" /></option>
                    <c:if test="${deptTimelink == true}">
                    <option value="RECENT"><!--  최근검색--><spring:message code="LABEL.D.D12.0007"/></option>
                    </c:if>
                </select>
                </c:when>
                <c:otherwise>
                <!--부서명--><spring:message code="LABEL.F.FCOMMON.0001" />
                <input type="hidden" name ="I_GBN" value ="ORGEH">
                </c:otherwise>
                </c:choose>
             </th>
             <td>
                <input type="text" id="searchDeptNm" name="txt_deptNm" value="${deptNm}" onKeyDown="if(event.keyCode == 13) pop_search();" style="width:300px; ime-mode:active" >
            </td>
            <td>
                <div class="tableBtnSearch"><a class="search" onClick="javascript:pop_search();"><span><!--부서찾기--><spring:message code="LABEL.F.FCOMMON.0002" /></span></a></div>
            </td>

            <c:if test="${deptTimelink != true}">
            <th class="divider">
                <img class="searchIcon" src="<%= WebUtil.ImageURL %>sshr/icon_map_g.gif" />
                <c:if test="${disabledSubOrg != true}">
                <span><!--하위조직포함--><spring:message code="LABEL.F.FCOMMON.0003" /></span>
                <input type="checkbox" name="chk_organAll" value="" onClick="javaScript:fncCheckbox('${deptId}', '${deptNm}');" ${checkYn == 'Y' ? 'checked' : ''} >
                <INPUT type='hidden' name='chck_yeno' value='${checkYn == 'Y' ? 'Y' : 'N'}' >
                </c:if>
            </th>
            <td>
                <div class="tableBtnSearch"><a class="search" onClick="javascript:organ_search();"><span><!--조직도로 부서찾기--><spring:message code="LABEL.SEARCH.ORGEH" /></span></a></div>
            </td>
            </c:if>

        </tr>
        </tbody>
    </table>
</div>
<c:if test="${disabledSubOrg != true}">
<div class="searchOrg_ment" style="margin-top:20px;text-align:right"><!--* 하위조직포함을 선택하면 하위조직까지 조회됩니다.--><div class="searchOrg_ment" style="margin-top:-20px;"><!--* 하위조직포함을 선택하면 하위조직까지 조회됩니다.--><spring:message code="LABEL.F.FCOMMON.0005" /></div></div>
</c:if>