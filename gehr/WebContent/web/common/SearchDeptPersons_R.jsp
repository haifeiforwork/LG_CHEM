<%/********************************************************************** *******/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 검색하는 include 파일                                  */
/*   Program ID   : SearchDeptPersons_R.jsp                                      */
/*   Description  : 대리신청할 때 사원 검색시 퇴직자도 가져올수 있도록 함.      */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-04-13  윤정현                                          */
/*   Update       :  20170821 이지은 해당 소스 안쓰는듯.(호출하는 곳 없음.)                                                           */
/*                      2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건  */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*"%>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<SCRIPT LANGUAGE="JavaScript">
<!--
    function pers_search()
    {
        i_gubun = document.form1.I_GUBUN.value;

        if( i_gubun == "1" ) {                   //사번검색

            val = document.form1.I_VALUE1.value;
            val = rtrim(ltrim(val));

            if ( val == "" ) {
                alert("<spring:message code='MSG.APPROVAL.SEARCH.PERNR.REQUIRED'/>"); //검색할 부서원 사번을 입력하세요!
                document.form1.I_VALUE1.focus();
                return;
            } else {
                document.form1.jobid.value = "pernr";
            } // end if
        } else if( i_gubun == "2" ) {            //성명검색
            val1 = document.form1.I_VALUE1.value;
            val1 = rtrim(ltrim(val1));

            if ( val1 == "" ) {
                alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.REQUIRED'/>"); //검색할 부서원 성명을 입력하세요!
                document.form1.I_VALUE1.focus();
                return;
            } else {
                if( val1.length < 2 ) {

                    alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.MIN'/>"); //검색할 성명을 한 글자 이상 입력하세요!
                    document.form1.I_VALUE1.focus();
                    return;
                } else {
                    document.form1.jobid.value = "ename";
                } // end if
            } // end if
        } // end if

        //  2002.08.20. 퇴직자 검색이 check되었는지 여부 ---------------
        document.form1.retir_chk.value = "";
        //  ------------------------------------------------------------
        small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=100,top=100");
        small_window.focus();

        document.form1.target = "DeptPers";
        document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersonsWait_R.jsp";
        document.form1.submit();
    } // end function


    //조직도 검사Popup.
    function organ_search()
    {
        //세션에 권한코드가 준비되지 않아 권한 코드값 입력으로 임시처리함.
        if( document.form1.hdn_popCode.value == "A" ){ //조직도와 상세.
            small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=500,left=100,top=100");
            small_window.focus();
            document.form1.target = "Organ";
            document.form1.action = "<%=WebUtil.JspURL%>"+"common/OrganListFramePop.jsp";
            document.form1.submit();
        } else {  //조직도만...
            small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=500,left=100,top=100");
            small_window.focus();
            document.form1.target = "Organ";
            document.form1.action = "<%=WebUtil.JspURL%>"+"common/OrganListPop.jsp";
            document.form1.submit();
        } // end if
    }

    function EnterCheck()
    {
        if (event.keyCode == 13)  {
            pers_search();
        } // end if
    } // end function

    function gubun_change()
    {
        document.form1.I_VALUE1.value    = "";
        document.form1.I_VALUE1.focus();
    } // end function
//-->
</SCRIPT>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<%
    PersonData oPersonData = (PersonData)request.getAttribute("PersonData");
%>
<style type="text/css">
	.tb_box1 td, .tb_box1 td input, .tb_box1 td img {vertical-align:middle;}
	.tb_box1  {margin-top:0px;color:#888}
</style>

          <div class="tableInquiry">
            <table>
              <tr>
                <th width="20%">
                	<img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
                	<spring:message code='LABEL.COMMON.0003'/><!-- 선택구분 -->
                </th>
                <td width="30">
                	<select name="I_GUBUN" onChange="javascript:gubun_change()">
	                    <option value="2" ><spring:message code='LABEL.COMMON.0020'/><!-- 성명별 --></option>
	                    <option value="1" ><spring:message code='LABEL.COMMON.0005'/><!-- 사번별 --></option>
                  	</select>
                </td>
                <td>
                	<input type="text"   name="I_VALUE1"  size="20"  maxlength="10"  value=""  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                	<div class="tableBtnSearch tableBtnSearch2">
                		<a class="search" href="javascript:pers_search();"><span><spring:message code='LABEL.COMMON.0006'/><!-- 사원찾기 --></span></a>
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
          			<col width="20%" />
          			<col width="10%" />
          			<col width="10%" />
          			<col width="10%" />
          			<col width="10%" />
          			<col width="10%" />
          			<col width="20%" />
          		</colgroup>
	        <tr>
	          <th><spring:message code='LABEL.COMMON.0007'/><!-- 부서 --></th>
	          <td><input size="30" style="border-width:0;text-align:left" type="text" value="<%=oPersonData.E_ORGTX%>" readonly></td>
              <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              <%--<th class="th02"><spring:message code='LABEL.COMMON.0008'/><!-- 직위 --></th> --%>
              <th class="th02"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
			  <td><input size="20" style="border-width:0;text-align:left" type="text" value="<%=oPersonData.E_JIKWT%>" readonly></td>
			  <th class="th02"><spring:message code='LABEL.COMMON.0009'/><!-- 직책 --></th>
			  <td><input size="20" style="border-width:0;text-align:left" type="text" value="<%=oPersonData.E_JIKKT%>" readonly></td>
			  <th class="th02"><spring:message code='MSG.APPROVAL.0013'/><!-- 성명 --></th>
			  <td>
                <input class="noBorder"  type="text" id="view_ename" name="view_ename" value="<%= oPersonData.E_ENAME %><%=oPersonData.E_PERNR%>" readonly>
			  	<input style="border-width:0;text-align:left" type="hidden" value="<%=oPersonData.E_ENAME%>" readonly>
	            <input style="border-width:0;text-align:left" type="hidden" value="<%=oPersonData.E_PERNR%>" readonly>
	          </td>
	        </tr>
	        <input type="hidden" name="I_DEPT"   value="<%=oPersonData.E_PERNR%>">
	        <input type="hidden" name="retir_chk" value="">
	        </table>
		</div>
	</div>

  <!--   사원검색 보여주는 부분  끝    -->