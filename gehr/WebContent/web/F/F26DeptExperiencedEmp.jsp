<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 경력입사자
*   Program ID   : F26DeptExperiencedEmp.jsp
*   Description  : 부서별 경력입사자 조회를 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>

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
    Vector DeptExperiencedEmp_vt = (Vector)request.getAttribute("DeptExperiencedEmp_vt");

    HashMap empCnt1 = (HashMap)request.getAttribute("empCnt1");
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F26DeptExperiencedEmpSV";
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
<input type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >
<%
    //부서명, 조회된 건수.
    if ( DeptExperiencedEmp_vt != null && DeptExperiencedEmp_vt.size() > 0 ) {
%>
 <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
<div class="listArea">
	<div class="listTop">
		<span class="listCnt"><<!-- 총 --><spring:message code='LABEL.F.FCOMMON.0006'/> <%=DeptExperiencedEmp_vt.size()%><spring:message code='LABEL.F.FCOMMON.0007'/><!-- 건 -->></span>
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
<%
	if( user.area == Area.KR ){
%>
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
<%}else{%>
				<th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
<%} %>
				<th><spring:message code="LABEL.F.F26.0001"/><!-- 근무기간 --></th>
				<th><spring:message code="LABEL.F.F26.0002"/><!-- 근무처 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th class="lastCol"><spring:message code="LABEL.F.F00.0012"/><!-- 직무 --></th>
			</tr>
			</thead>
<%
		if( user.area == Area.KR ){
			String oldPer="";
			String sRow = "";

            for( int i = 0; i < DeptExperiencedEmp_vt.size(); i++ ){
        		F26DeptExperiencedEmpData data = (F26DeptExperiencedEmpData)DeptExperiencedEmp_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작

                if(oldPer.equals(data.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(data.PERNR);
                }
                oldPer = data.PERNR;
                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
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
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00")?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
				<td><%= data.PERIOD %></td>
				<td><%= data.ARBGB %></td>
				<td><%= data.CJIKWT %></td>
				<td class="lastCol"><%= data.CSTLTX %></td>
			</tr>
<%		}
		}else{
			String oldPer="";
			String sRow = "";

		    for( int i = 0; i < DeptExperiencedEmp_vt.size(); i++ ){
		    	F26DeptExperiencedEmpGlobalData dataG = (F26DeptExperiencedEmpGlobalData)DeptExperiencedEmp_vt.get(i);
		    	String PERNR =  AESgenerUtil.encryptAES(dataG.PERNR, request); //암호화를 위한 작

                if(oldPer.equals(dataG.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(dataG.PERNR);
                }
                oldPer = dataG.PERNR;
		    	String tr_class = "";

		        if(i%2 == 0){
		            tr_class="oddRow";
		        }else{
		            tr_class="";
		        }
%>
			<tr class="borderRow">
          	<%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><%= dataG.NAME1 %></td>
				<td nowrap <%= sRow %>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= dataG.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= dataG.ENAME %></td>
				<td nowrap <%= sRow %>><%= dataG.ORGTX %></td>
				<td nowrap <%= sRow %>><%= dataG.JIKKT %></td>
				<td nowrap <%= sRow %>><%= dataG.JIKWT %></td>
				<td nowrap <%= sRow %>><%= dataG.VGLST %></td>
				<td nowrap <%= sRow %>><%= (dataG.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(dataG.DAT01) %></td>
			<%} %>
				<td nowrap><%= dataG.PERIOD %></td>
				<td nowrap><%= dataG.ARBGB %></td>
				<td nowrap><%= dataG.CJIKWT %></td>
				<td nowrap class="lastCol"><%= dataG.CSTLTX %></td>
			</tr>
<%		}
		}%>
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
	<%
		int colSpan = 0;
		if( user.area == Area.KR ){
			colSpan = 13;
	%>
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
	<%}else{
			colSpan = 12;
	%>
					<th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
					<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
					<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
					<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
					<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
					<th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
					<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
	<%} %>
				<th><spring:message code="LABEL.F.F41.0008"/><!-- 근무기간 --></th>
				<th><spring:message code="LABEL.F.F26.0001"/><!-- 근무처 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th class="lastCol"><spring:message code="LABEL.F.F00.0012"/><!-- 직무 --></th>
			</tr>
			<tr class="oddRow">
				<td class="lastCol" colSpan="<%=colSpan %>"><spring:message code="MSG.F.FCOMMON.0002"/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
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