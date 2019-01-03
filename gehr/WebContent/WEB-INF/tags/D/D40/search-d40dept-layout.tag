<%--
/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 상단 조회 공통                                                   */
/*   Program ID   : search-d40dept-layout.tag                                          */
/*   Description  : 상단 조회 공통 tag 파일                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2017-12-08 정준현                                           */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
--%>
<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag import="com.common.Utils" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="d40" tagdir="/WEB-INF/tags/D/D40" %>
<%-- <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> --%>

<%@ attribute name="deptId" type="java.lang.String" %>
<%@ attribute name="deptNm" type="java.lang.String" %>
<%@ attribute name="deptTimelink" type="java.lang.String" %>

<%@ attribute name="disabledSubOrg" type="java.lang.Boolean" %>
<%@ attribute name="resultList" type="java.util.Vector" %>

<%-- <%@ attribute name="url" type="java.lang.String" required="true" %> --%>

<c:set var="g" value="<%=Utils.getBean("global")%>"/>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="checkYn" value="${empty checkYn ? param.checkYn : checkYn}" />


<SCRIPT LANGUAGE="JavaScript">

	$(function() {

		$("input[type=radio][name=orgOrTm]").click(function(){
			if($(this).val() == "2"){
				$(".orgSelect").hide();
				$(".tmSelect").show();
				$("#searchDeptNo").val("");
				$("#searchDeptNm").val("");
			}else{
				$(".tmSelect").hide();
	    		$(".orgSelect").show();
	    		$("#iSeqno").val("");
	    		$("#I_SELTAB").val("");
			}
		});

	    $("#iSeqno").change(function (){
	    	if($("#iSeqno").val() == ""){
	    		$("#I_SELTAB").val("");
	    	}else{
	    		$("#I_SELTAB").val("C");
	    	}
	    });

	    $("#dept_clear").click(function (){
			$("#searchDeptNo").val("");
			$("#searchDeptNm").val("");
			return false;
		});

	});

    //부서명 검색 사용안함
    function dept_search() {

    	var frm = document.form1;
        var dept_search_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=550,height=550,left=100,top=100");
        dept_search_window.focus();
        frm.target = "DeptNm";
        frm.action = "${g.jsp}"+"D/D40TmGroup/common/SearchD40DeptNamePop.jsp";
	    frm.submit();
    }


    //조직도 Popup.
    function organ_search() {

        var frm = document.form1;
        var organ_search_window = window.open("","organList","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=400,height=550,left=100,top=100");
	    organ_search_window.focus();
	    frm.target = "organList";
	    frm.action = "<%=WebUtil.JspURL%>"+"D/D40TmGroup/common/D40OrganSmListPop.jsp";
	    frm.submit();
    }

</SCRIPT>

<link rel="stylesheet" href="${g.image}css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="${g.image}css/ehr_wsg.css" type="text/css">
<div class="tableInquiry ">
    <table>
        <colgroup>
		<col width="8%"/>
		<col width="20%"/>
		<col width="20%"/>
		<col />
<%-- 		<col width="10%"/> --%>
        </colgroup>
        <tbody>
        <tr>
			<td>
                <img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
            </td>
            <th>
        		<input type="radio" id="orgOrTmA" name="orgOrTm" value="1"><label for="orgOrTmA"><spring:message code="LABEL.D.D40.0034"/><!-- 조직도 --></label>&nbsp; &nbsp;
        		<input type="radio" id="orgOrTmB" name="orgOrTm" value="2"><label for="orgOrTmB"><spring:message code="LABEL.D.D40.0004"/><!-- 근태그룹 --></label>
        	</th>
			<td class="orgSelect">
				<div class="tableBtnSearch"><a class="search" onClick="javascript:organ_search();"><span><!--조직도로 부서찾기--><spring:message code="LABEL.SEARCH.ORGEH" /></span></a></div>
			</td>
			<td class="orgSelect">
                <!-- 부서명 --><spring:message code="LABEL.F.FCOMMON.0001" />
                <input type="hidden" id ="I_SELTAB" name ="I_SELTAB" value ="">
                <input type="hidden" id ="searchDeptNo" name ="searchDeptNo" value ="">
                <input type="text" id="searchDeptNm" name="searchDeptNm" value="" readonly="readonly" style="width:300px; ime-mode:active;" >
				<a class="floatLeft" href="javascript:void(0);"><img src="/web/images/eloffice/images/ico/ico_inline_reset.png" id="dept_clear" alt="초기화"/></a>
			</td>
			<td class="tmSelect" style="display: none;">
				<select id="iSeqno" name="iSeqno">
					<option value=""><spring:message code='LABEL.COMMON.0024'/><!-- 전체 --></option>
					<c:forEach items="${resultList}" var="row" varStatus="status">
                		<option value="${row.CODE }">${row.TEXT }</option>
            		</c:forEach>
				</select>
			</td>
            <td class="tmSelect" style="display: none;" colspan="2">

			</td>
        </tr>
        </tbody>
    </table>
</div>

