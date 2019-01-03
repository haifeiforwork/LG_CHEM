<%/***************************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Unit/Contract Type
*   Program ID   		: F77DeptUnitContractType.jsp
*   Description  		: 부서별 계약 유형 조회를 위한 jsp 파일
*   Note         		: 없음
*   Creation     		:
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.*" %>
<%
	request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");                      	// 세션

    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);		// 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                 	// 부서명

    Vector F77DeptUnitContractTypeTitle_vt = (Vector)request.getAttribute("F77DeptUnitContractTypeTitle_vt");   // 제목
    Vector F77DeptUnitContractTypeNote_vt = (Vector)request.getAttribute("F77DeptUnitContractTypeNote_vt");   // 내용

    HashMap meta = (HashMap)request.getAttribute("meta");
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--


// 상세화면으로 이동.
function goDetail(paramA, paramC, paramD, value){

    frm = document.form1;

    if (value!= "" && value!= "0") {
        frm.hdn_gubun.value = "23";             				// 부서별 계약 유형 현황
        frm.hdn_deptId.value = "<%= deptId %>";		// 조회된 부서코드
        frm.hdn_paramA.value = paramA;
        frm.hdn_paramC.value = paramC;					// Contract Extension 구분자
        frm.hdn_paramD.value = paramD;					// Contract Type
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
        frm.target = "_self";
        frm.submit();
    }
}

// Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F77DeptUnitContractTypeSV";
    frm.target = "hidden";
    frm.submit();
}

//-->
</SCRIPT>
 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId" value="<%= deptId %>">
<input type="hidden" name="hdn_deptNm" value="<%= deptNm %>">
<input type="hidden" name="hdn_excel" value="">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">
<input type="hidden" name="hdn_Popflag" value="N">

<input type="hidden" name="hdn_gubun" value="">
<input type="hidden" name="hdn_paramA" value="">
<input type="hidden" name="hdn_paramB" value="">
<input type="hidden" name="hdn_paramC" value="">
<input type="hidden" name="hdn_paramD" value="">
<input type="hidden" name="hdn_paramE" value="">

<%
	if (F77DeptUnitContractTypeNote_vt !=null && F77DeptUnitContractTypeNote_vt.size() > 0 && F77DeptUnitContractTypeTitle_vt != null && F77DeptUnitContractTypeTitle_vt.size() > 0) {
%>
    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
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
					<th><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --></th>
					<%
					String tmp = "";
					// 타이틀.
					for (int i = 0; i < F77DeptUnitContractTypeTitle_vt.size(); i++) {
						F77DeptUnitContractTypeTitleData titleData = (F77DeptUnitContractTypeTitleData)F77DeptUnitContractTypeTitle_vt.get(i);
		 				int cols = ((Integer)meta.get(titleData.CLSFY)).intValue();
					%>
					<th nowrap><%= titleData.CTTXT %></th>
					<%} %>
				</tr>
				</thead>
				<%
				int tok = 0;
				for (int i = 0 ; i < F77DeptUnitContractTypeNote_vt.size() ; i ++) {
					F77DeptUnitContractTypeNoteData entity = (F77DeptUnitContractTypeNoteData)F77DeptUnitContractTypeNote_vt.get(i);
					if ((entity.ZLEVEL != null && !entity.ZLEVEL.equals("") && Integer.parseInt(entity.ZLEVEL) != 0 && Integer.parseInt(entity.ZLEVEL) < tok) || i == 0) {
						tok = Integer.parseInt(entity.ZLEVEL);
       				}
				}

       			 // 타이틀에 맞추어 내용영역 보여주기위한 개수.
        		int noteSize = F77DeptUnitContractTypeTitle_vt.size();

       			 // 내용.
				for (int i = 0; i < F77DeptUnitContractTypeNote_vt.size(); i++) {
					F77DeptUnitContractTypeNoteData data = (F77DeptUnitContractTypeNoteData)F77DeptUnitContractTypeNote_vt.get(i);

				    String strBlank = "";
				    String titlClass = "";
				    String noteClass = "";
		            int blankSize = Integer.parseInt(WebUtil.nvl(data.ZLEVEL, "0"));

					int bstyle = 0 ;
		        	if (blankSize >= tok)
		        		bstyle = 5 * (blankSize - tok) + 10;

		            // 클래스 설정.
		            if (!data.STEXT.equals("TOTAL")) {
						titlClass = "class=td09_1 style='padding-left:"+ bstyle +"'";
						noteClass = "class=";
					} else {
		                titlClass = "class=td11 style='text-align:center;padding-left:"+ bstyle +"'";
		                noteClass = "class=td11";
					}

		            String tr_class = "";
		            if( i%2 == 0 ){
		            	tr_class = "oddRow";
		            }else{
		            	tr_class = "";
		            }
					// 부서명 앞에 공백넣기.
					%>
				<tr class = "borderRow">
					<td <%= titlClass %> nowrap><%= strBlank %><%= data.STEXT %></td>
				          <% if (noteSize >= 1)   	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS01+"','"+data.CTT01+"','"+data.CNT01+"');\">"+WebUtil.printNumFormat(data.CNT01)+"</a></td>"); %>
				          <% if (noteSize >= 2)   	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS02+"','"+data.CTT02+"','"+data.CNT02+"');\">"+WebUtil.printNumFormat(data.CNT02)+"</a></td>"); %>
				          <% if (noteSize >= 3)   	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS03+"','"+data.CTT03+"','"+data.CNT03+"');\">"+WebUtil.printNumFormat(data.CNT03)+"</a></td>"); %>
				          <% if (noteSize >= 4)   	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS04+"','"+data.CTT04+"','"+data.CNT04+"');\">"+WebUtil.printNumFormat(data.CNT04)+"</a></td>"); %>
				          <% if (noteSize >= 5)   	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS05+"','"+data.CTT05+"','"+data.CNT05+"');\">"+WebUtil.printNumFormat(data.CNT05)+"</a></td>"); %>
				          <% if (noteSize >= 6)   	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS06+"','"+data.CTT06+"','"+data.CNT06+"');\">"+WebUtil.printNumFormat(data.CNT06)+"</a></td>"); %>
				          <% if (noteSize >= 7)   	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS07+"','"+data.CTT07+"','"+data.CNT07+"');\">"+WebUtil.printNumFormat(data.CNT07)+"</a></td>"); %>
				          <% if (noteSize >= 8)   	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS08+"','"+data.CTT08+"','"+data.CNT08+"');\">"+WebUtil.printNumFormat(data.CNT08)+"</a></td>"); %>
				          <% if (noteSize >= 9)   	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS09+"','"+data.CTT09+"','"+data.CNT09+"');\">"+WebUtil.printNumFormat(data.CNT09)+"</a></td>"); %>
				          <% if (noteSize >= 10)  	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS10+"','"+data.CTT10+"','"+data.CNT10+"');\">"+WebUtil.printNumFormat(data.CNT10)+"</a></td>"); %>
				          <% if (noteSize >= 11)   out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS11+"','"+data.CTT11+"','"+data.CNT11+"');\">"+WebUtil.printNumFormat(data.CNT11)+"</a></td>"); %>
				          <% if (noteSize >= 12)   out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS12+"','"+data.CTT12+"','"+data.CNT12+"');\">"+WebUtil.printNumFormat(data.CNT12)+"</a></td>"); %>
				          <% if (noteSize >= 13)   out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS13+"','"+data.CTT13+"','"+data.CNT13+"');\">"+WebUtil.printNumFormat(data.CNT13)+"</a></td>"); %>
				          <% if (noteSize >= 14)   out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS14+"','"+data.CTT14+"','"+data.CNT14+"');\">"+WebUtil.printNumFormat(data.CNT14)+"</a></td>"); %>
				          <% if (noteSize >= 15)   out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS15+"','"+data.CTT15+"','"+data.CNT15+"');\">"+WebUtil.printNumFormat(data.CNT15)+"</a></td>"); %>
				          <% if (noteSize >= 16)   out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS16+"','"+data.CTT16+"','"+data.CNT16+"');\">"+WebUtil.printNumFormat(data.CNT16)+"</a></td>"); %>
				          <% if (noteSize >= 17)   out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS17+"','"+data.CTT17+"','"+data.CNT17+"');\">"+WebUtil.printNumFormat(data.CNT17)+"</a></td>"); %>
				          <% if (noteSize >= 18)   out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS18+"','"+data.CTT18+"','"+data.CNT18+"');\">"+WebUtil.printNumFormat(data.CNT18)+"</a></td>"); %>
				          <% if (noteSize >= 19)   out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS19+"','"+data.CTT19+"','"+data.CNT19+"');\">"+WebUtil.printNumFormat(data.CNT19)+"</a></td>"); %>
				          <% if (noteSize >= 20)  	out.println("<td "+noteClass+" nowrap><a title='"+data.STEXT+"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.CLS20+"','"+data.CTT20+"','"+data.CNT20+"');\">"+WebUtil.printNumFormat(data.CNT10)+"</a></td>"); %>
        		</tr>
        		<%
					} //end for
				%>
			</table>
		</div>
	</div>

<%
    }else{
%>
    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
		</div>
		<div class="table">
			<table class="listTable">
				<tr>
					<th><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --></th>
					<th><spring:message code='LABEL.F.F77.0001'/><!-- Direct --></th>
					<th><spring:message code='LABEL.F.F77.0002'/><!-- Long Term Contract --></th>
					<th><spring:message code='LABEL.F.F77.0003'/><!-- Consultant --></th>
					<th><spring:message code='LABEL.F.F77.0004'/><!-- Part time / Short term --></th>
					<th><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
		        </tr>
				<tr class ="oddRow">
				    <td><spring:message code='MSG.F.FCOMMON.0002'/></td>
				</tr>
			</table>
		</div>
	</div>
<%
    } //end if.
%>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->