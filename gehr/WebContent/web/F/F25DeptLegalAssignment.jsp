<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 법정선임 내역
*   Program ID   : F25DeptLegalAssignmen.jsp
*   Description  : 부서별 법정선임 내역 조회를 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       ::2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
	// 웹로그 메뉴 코드명
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));

    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptLegalAssignment_vt = (Vector)request.getAttribute("DeptLegalAssignment_vt");
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

    HashMap empCnt1 = (HashMap)request.getAttribute("empCnt1");
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F25DeptLegalAssignmentSV";
    frm.target = "hidden";
    frm.submit();
}

function popupView(winName, width, height, pernr) {
    var formN = document.form1;
    formN.viewEmpno.value = pernr;
    var screenwidth = (screen.width-width)/2;
    var screenheight = (screen.height-height)/2;
    var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=<%=sMenuCode%>&ViewOrg=Y&viewEmpno="+pernr;
    var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");
}
//-->
</SCRIPT>

 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="viewEmpno"   value="">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">
<%
    //부서명, 조회된 건수.
    if ( DeptLegalAssignment_vt != null && DeptLegalAssignment_vt.size() > 0 ) {
%>
<h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
<div class="listArea">
	<div class="listTop">
			<span class="listCnt"><<!-- 총 --><spring:message code='LABEL.F.FCOMMON.0006'/> <%=DeptLegalAssignment_vt.size()%><spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건  -->></span>
           <div class="buttonArea">
               <ul class="btn_mdl">
                   <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
               </ul>
           </div>
	</div>
	<div class="wideTable" style="border-top: 2px solid #c8294b;">
	    <table class="listTable">
	    	<thead>
	        <tr>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
				<th><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
				<th><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
				<th><spring:message code="LABEL.F.F25.0001"/><!-- 자격면허 --></th>
				<th><spring:message code="LABEL.F.F25.0002"/><!-- 취득일 --></th>
				<th><spring:message code="LABEL.F.F25.0003"/><!-- 등급 --></th>
				<th><spring:message code="LABEL.F.F25.0004"/><!-- 발행기관 --></th>
				<th class="lastCol"><spring:message code="LABEL.F.F25.0005"/><!-- 선임부서 --></th>
			</tr>
			</thead>
<%
			String oldPer="";
			String sRow = "";
            for( int i = 0; i < DeptLegalAssignment_vt.size(); i++ ){
                F25DeptLegalAssignmentData data = (F25DeptLegalAssignmentData)DeptLegalAssignment_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작

                if(oldPer.equals(data.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(data.PERNR);
                }
                oldPer = data.PERNR;
%>
			<tr class="borderRow">
          	<%if (!sRow.equals("")) {%>
	            <td nowrap <%= sRow %>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= data.ENAME %></td>
				<td nowrap <%= sRow %>><%= data.ORGTX %></td>
				<td nowrap <%= sRow %>><%= data.JIKKT %></td>
				<td nowrap <%= sRow %>><%= data.JIKWT %></td>
				<td nowrap <%= sRow %>><%= data.JIKCT %></td>
				<td nowrap <%= sRow %>><%= data.TRFST %></td>
				<td nowrap <%= sRow %>><%= data.VGLST %></td>
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
				<td nowrap><%= data.LICNNM%></td>
				<td nowrap><%= (data.OBNDAT).equals("0000-00-00") ? "" : WebUtil.printDate(data.OBNDAT) %></td>
				<td nowrap><%= data.LGRDNM  %></td>
				<td nowrap><%= data.PBORGH  %></td>
				<td nowrap class="lastCol"><%= data.LAW %></td>
			</tr>
<%
            } //end for...
%>
         </table>
     </div>
     <div class="buttonArea">
        <ul class="btn_mdl">
            <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
        </ul>
    </div>
 </div>
 <!-- 화면에 보여줄 영역 끝 -->

<%
    }else{
%>
<div class="listArea">
	<div class="table">
	    <table class="listTable">
	        <tr>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
				<th><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
				<th><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
				<th><spring:message code="LABEL.F.F25.0001"/><!-- 자격면허 --></th>
				<th><spring:message code="LABEL.F.F25.0002"/><!-- 취득일 --></th>
				<th><spring:message code="LABEL.F.F25.0003"/><!-- 등급 --></th>
				<th><spring:message code="LABEL.F.F25.0004"/><!-- 발행기관 --></th>
				<th class="lastCol"><spring:message code="LABEL.F.F25.0005"/><!-- 선임부서 --></th>
			</tr>
			<tr class="oddRow">
				<td class="lastCol" colspan="14"><spring:message code="MSG.F.FCOMMON.0002"/></td>
			</tr>
		</table>
	</div>
</div>
<%
    } //end if...
%>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
