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
/*                       20170821 이지은 안쓰는듯 (호출하는 곳 없음)                                                       */
/*						2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/*******************************************************************************--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*"%>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	String I_ORGEH  = WebUtil.nvl(request.getParameter("I_ORGEH"));          //
    String checkYn = WebUtil.nvl((String)request.getAttribute("I_LOWERYN")); //하위부서여부.
    String i_loweryn = checkYn;
	//하위부서여부.
	if (checkYn.equals("")) {
		checkYn = WebUtil.nvl(request.getParameter("checkYn"));
	}

	//check Flag.
	if (checkYn.equals("Y")) {
		checkYn = "checked";
	} else {
		checkYn = "";
	}

%>

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<SCRIPT LANGUAGE="JavaScript">
<!--
    function person_search()
    {
        i_gubun = document.approvalHeaderSearchForm.I_GUBUN.value;

        if( i_gubun == "1" ) {                   //사번검색

            val = document.approvalHeaderSearchForm.I_VALUE1.value;
            val = rtrim(ltrim(val));

            if ( val == "" ) {
                alert("<spring:message code='MSG.COMMON.SEARCH.DEPT.REQUIR'/>"); /* <!-- 검색할 부서원 사번을 입력하세요!")--> */
                document.approvalHeaderSearchForm.I_VALUE1.focus();
                return;
            } else {
                document.approvalHeaderSearchForm.jobid.value = "pernr";
            } // end if
        } else if( i_gubun == "2" ) {            //성명검색
            val1 = document.approvalHeaderSearchForm.I_VALUE1.value;
            val1 = rtrim(ltrim(val1));

            if ( val1 == "" ) {
                alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.REQUIRED'/>");/* <!-- 검색할 부서원 성명을 입력하세요!");--> */
                document.approvalHeaderSearchForm.I_VALUE1.focus();
                return;
            } else {
                if( val1.length < 2 ) {

                    alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.MIN'/>");/* <!-- 검색할 성명을 한 글자 이상 입력하세요!")--> */
                    document.approvalHeaderSearchForm.I_VALUE1.focus();
                    return;
                } else {
                    document.approvalHeaderSearchForm.jobid.value = "ename";
                } // end if
            } // end if
        } // end if

        //  2002.08.20. 퇴직자 검색이 check되었는지 여부 ---------------
        document.approvalHeaderSearchForm.retir_chk.value = "";
        //  ------------------------------------------------------------
        small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=100,top=100");
        small_window.focus();

        document.approvalHeaderSearchForm.target = "DeptPers";
        document.approvalHeaderSearchForm.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersonsWait.jsp";
        document.approvalHeaderSearchForm.submit();
    } // end function

<%--
    //조직도 검사Popup.
    function organ_search()
    {
        //세션에 권한코드가 준비되지 않아 권한 코드값 입력으로 임시처리함.
        if( document.approvalHeaderSearchForm.hdn_popCode.value == "A" ){ //조직도와 상세.
            small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=500,left=100,top=100");
            small_window.focus();
            document.approvalHeaderSearchForm.target = "Organ";
            document.approvalHeaderSearchForm.action = "<%=WebUtil.JspURL%>"+"common/OrganListFramePop.jsp";
            document.approvalHeaderSearchForm.submit();
        } else {  //조직도만...
            small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=500,left=100,top=100");
            small_window.focus();
            document.approvalHeaderSearchForm.target = "Organ";
            document.approvalHeaderSearchForm.action = "<%=WebUtil.JspURL%>"+"common/OrganListPop.jsp";
            document.approvalHeaderSearchForm.submit();
        } // end if
    }
--%>
    //조직도 검사Popup.
    function organ_search() {
        var searchFrom = document.approvalHeaderSearchForm;
        var searchApprovalHeaderPop = window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=520,left=450,top=0");
        searchFrom.target = "Organ";
        searchFrom.action = "${g.jsp}common/ApprovalOrganListFramePop.jsp";
        searchFrom.submit();

        searchApprovalHeaderPop.focus();

    }

    function EnterCheck()
    {
        if (event.keyCode == 13)  {
            person_search();
        } // end if
    } // end function

    function gubun_change()
    {
        document.approvalHeaderSearchForm.I_VALUE1.value    = "";
        document.approvalHeaderSearchForm.I_VALUE1.focus();
    } // end function


  //체크박스 선택
  function fncCheckbox(deptId) {
   var frm = document.approvalHeaderSearchForm;

   if ( frm.chk_organAll.checked == true )
       frm.I_LOWERYN.value = 'Y';
   else
       frm.I_LOWERYN.value = 'N';

   //체크박스 선택시 자동검색.
   //setDeptID(deptId, deptNm);
  }

//-->
</SCRIPT>
<%
    PersonData oPersonData = (PersonData)request.getAttribute("PersonData");
	/**            // 대리 신청 추가
	**/
	if (oPersonData==null){
	        PersonInfoRFC numfunc = new PersonInfoRFC();
	        PersonData phonenumdata;
	        phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
	}
%>
<c:set var="oPersonData" value="<%=oPersonData%>"/>


    <form id="approvalHeaderSearchForm" name="approvalHeaderSearchForm" method="post">
    <div class="tableInquiry">
        <table >
        	<colgroup>
        		<col width="20%" />
        		<col />
        	</colgroup>
          <tr>
            <th>
            	<img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
            	<!--선택구분--><spring:message code="LABEL.COMMON.0003" />
            </th>
            <td>
                <select name="I_GUBUN" onChange="javascript:gubun_change()">
                <option value="2" ><!--성명별--><spring:message code="LABEL.COMMON.0004" /></option>
                <option value="1" ><!--사번별--><spring:message code="LABEL.COMMON.0005" /></option>
<%-- 	            <option value="3" ><!-- 최근검색 --><spring:message code="LABEL.D.D12.0012"/></option> --%>
              </select>

              <input type="text"  id="I_VALUE1" name="I_VALUE1" size="16"  maxlength="10"  value=""  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
              <input type="hidden" name="jobid" />
                <div class="tableBtnSearch tableBtnSearch2" >
                    <a class="search unloading" href="javascript:person_search();"><span><!--사원찾기--><spring:message code="LABEL.COMMON.0006" /></span></a>
                </div>
            </td>
                <td>
                    <img class="searchIcon" src="<%= WebUtil.ImageURL %>sshr/icon_map_g.gif" />
		            <font color="#585858"><!--하위조직포함--><spring:message code="LABEL.F.FCOMMON.0003"/></font>
		            <input type="checkbox" name="chk_organAll" value="" onClick="javaScript:fncCheckbox('<%=I_ORGEH%>');" <%=checkYn%> >
		            <INPUT type='hidden' name='I_LOWERYN' value='<%= i_loweryn %>' >
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:;" onclick="organ_search()"><span><!--조직도로 찾기--><spring:message code="LABEL.COMMON.0011" /></span></a>
                    </div>
                </td>
          </tr>
        </table>
    </div>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral perInfo">
            	<colgroup>
            		<col width="10%" />
            		<col width="15%" />
            		<col width="10%" />
            		<col width="15%" />
            		<col width="10%" />
            		<col width="15%" />
            		<col width="13%" />
            		<col width="12%" />
            	</colgroup>
                <tr>
					<th><!--부서--><spring:message code="LABEL.COMMON.0007" /></th>
                    <td><input class="" size="25" style="border-width:0;" type="text"
                    		value="<c:out value='${oPersonData.e_ORGTX}'/>" readonly><td>
	                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    		        <%--<th class="th02"><!--직위--><spring:message code="LABEL.COMMON.0008" /></th> --%>
              	    <th class="th02"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                    <td><input class="" size="12" style="border-width:0;" type="text"
                    		value="<c:out value='${oPersonData.e_JIKWT}'/>" readonly></td>
                    <th class="th02"><!--직책--><spring:message code="LABEL.COMMON.0009" /></th>
                    <td><input class="" size="12" style="border-width:0;" type="text"
                    		value="<c:out value='${oPersonData.e_JIKKT}'/>" readonly></td>
                    <th class="th02"><!--성명--><spring:message code="LABEL.COMMON.0010" /></th>
                    <td><input class="" size="8" style="border-width:0;" type="text"
                    		value="<c:out value='${oPersonData.e_ENAME}'/>" readonly></td>
                    <td><input class="" size="9" style="border-width:0;text-align:left" type="text"
                   		 	value="<c:out value='${oPersonData.e_PERNR}'/>" readonly></td>
                    </td>
                </tr>

                <input type="hidden" name="I_DEPT"   value="<c:out value='${oPersonData.e_PERNR}'/>">
                <input type="hidden" name="retir_chk" value="">
            </table>

	      </div>
	  </div>
    </form>
  <!--   사원검색 보여주는 부분  끝    -->