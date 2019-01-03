<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                       			*/
/*   Program Name : 부서별 휴가 사용 현황                                       		*/
/*   Program ID   : F41DeptVacation.jsp                                         */
/*   Description  : 부서별 휴가 사용 현황 조회를 위한 jsp 파일                  		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2005-02-21 유용원                                           		*/
/*   Update       : [CSR ID:3038270] 근태 자동메일 관련 시스템 수정 요청 			*/
/*					       2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/*				  : 2018-05-18 성환희 [WorkTime52] 보상휴가 추가 건 				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>
<%
	//암호화 추가
    // 웹로그 메뉴 코드명
    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));

    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptVacation_vt = (Vector)request.getAttribute("DeptVacation_vt");
    String subView       = WebUtil.nvl(request.getParameter("subView"));
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
    if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
       // alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
        alert("<%=g.getMessage("MSG.F.F41.0003")%>   ");
        return;
    }

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F41DeptVacationSV";
    frm.target = "_self";
    frm.submit();
}




//Execl Down 하기.
function excelDown() {
    frm = document.form1;
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F41DeptVacationSV";
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
        <jsp:param name="help" value="X04Statistics.html'"/>
        <jsp:param name="click" value="Y'"/>
    </jsp:include>

<%-- html body 안 헤더부분 - 타이틀 등 --%>
 <form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="viewEmpno" value="">
<input type="hidden" name="ViewOrg" value="Y">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >


<%
    //부서명, 조회된 건수.
    if ( DeptVacation_vt != null && DeptVacation_vt.size() > 0 ) {
    	//[CSR ID:3038270]
    	double sumOCCUR1 = 0.0;
    	double sumABWTG1 = 0.0;
    	double sumZKVRB1 = 0.0;
    	String allAVG1 = "0.00";
    	double sumOCCUR2 = 0.0;
    	double sumABWTG2 = 0.0;
    	double sumZKVRB2 = 0.0;
    	String allAVG2 = "0.00";
%>

	<h2 class="subtitle"><!-- 부서명 --><%=g.getMessage("LABEL.F.FCOMMON.0001")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>

    <div class="listArea">
    	<div class="listTop">
    		<span class="listCnt"><!-- 총 --><%=g.getMessage("LABEL.F.FCOMMON.0006")%> <%=DeptVacation_vt.size()%> <!-- 건 --><%=g.getMessage("LABEL.F.FCOMMON.0007")%></span>
    		<div class="buttonArea">
	    		<ul class="btn_mdl">
	    			<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	    		</ul>
    		</div>
    	</div>
        <div class="table">
        <table class="listTable">
		<thead>
			<tr>
				<th rowspan="2"><!-- 사번 --><%=g.getMessage("LABEL.F.F41.0004")%></th>
				<th rowspan="2"><!-- 이름 --><%=g.getMessage("LABEL.F.F41.0005")%></th>
				<th rowspan="2"><!-- 소속 --><%=g.getMessage("LABEL.F.F41.0006")%></th>
				<th rowspan="2"><!-- 직책 --><%=g.getMessage("LABEL.F.F41.0007")%></th>
				<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
				<%--<th><!-- 직위 --><%=g.getMessage("LABEL.F.F41.0008")%></th> --%>
				<th rowspan="2"><!-- 직위/직급호칭 --><%=g.getMessage("MSG.A.A01.0083")%></th>
				<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th rowspan="2"><!-- 직급 --><%=g.getMessage("LABEL.F.F41.0009")%></th>
				<th rowspan="2"><!-- 호봉 --><%=g.getMessage("LABEL.F.F41.0010")%></th>
				<th rowspan="2"><!-- 연차 --><%=g.getMessage("LABEL.F.F41.0011")%></th>
				<th rowspan="2"><!-- 입사일자 --><%=g.getMessage("LABEL.F.F41.0012")%></th>
				<th colspan="4"><!-- 연차휴가 --><%=g.getMessage("LABEL.F.F41.0034")%></th>
				<th colspan="4" class="lastCol"><!-- 보상휴가 --><%=g.getMessage("LABEL.F.F41.0035")%></th>
			</tr>
			<tr>
				<th><!-- 발생일수 --><%=g.getMessage("LABEL.F.F41.0013")%></th>
				<th><!--사용일수 --><%=g.getMessage("LABEL.F.F41.0014")%></th>
				<th><!--잔여일수 --><%=g.getMessage("LABEL.F.F41.0015")%></th>
				<th><!-- 휴가사용율 --><%=g.getMessage("LABEL.F.F41.0016")%>(%)</th>
				<th><!-- 발생일수 --><%=g.getMessage("LABEL.F.F41.0013")%></th>
				<th><!--사용일수 --><%=g.getMessage("LABEL.F.F41.0014")%></th>
				<th><!--잔여일수 --><%=g.getMessage("LABEL.F.F41.0015")%></th>
				<th class="lastCol"><!-- 휴가사용율 --><%=g.getMessage("LABEL.F.F41.0016")%>(%)</th>
			</tr>
		</thead>
<%
			//전체 합계를 구함//[CSR ID:3038270]
			for( int i = 0; i < DeptVacation_vt.size(); i++ ){
			    F41DeptVacationData data = (F41DeptVacationData)DeptVacation_vt.get(i);
				sumOCCUR1 += Double.parseDouble(data.OCCUR1);
				sumABWTG1 += Double.parseDouble(data.ABWTG1);
				sumZKVRB1 += Double.parseDouble(data.ZKVRB1);
				sumOCCUR2 += Double.parseDouble(data.OCCUR2);
				sumABWTG2 += Double.parseDouble(data.ABWTG2);
				sumZKVRB2 += Double.parseDouble(data.ZKVRB2);
			}

			//평균 값 계산//[CSR ID:3038270]
			if(sumABWTG1 >0 && sumOCCUR1>0){
				allAVG1 = WebUtil.printNumFormat((sumABWTG1 / sumOCCUR1 )*100,2);
			}else{
				allAVG1 = "0.00";
			}
			if(sumABWTG2 >0 && sumOCCUR2>0){
				allAVG2 = WebUtil.printNumFormat((sumABWTG2 / sumOCCUR2 )*100,2);
			}else{
				allAVG2 = "0.00";
			}

            for( int i = 0; i < DeptVacation_vt.size(); i++ ){
                F41DeptVacationData data = (F41DeptVacationData)DeptVacation_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해

                //[CSR ID:3038270]
    			String class1 = "";
    			if (Double.parseDouble(data.CONSUMRATE1)>=Double.parseDouble(allAVG1)) {
					class1 = "";
				} else {
					class1 = "bgcolor='#f8f5ed'";
				}
              //[CSR ID:3038270]

%>
          <tr class="borderRow">
            <td <%=class1%>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td>
            <td <%=class1%>><%= data.KNAME %></td>
            <td <%=class1%>><%= data.ORGTX %></td>
            <td <%=class1%>><%= data.TITL2 %></td>
            <td <%=class1%>><%= data.TITEL %></td>
            <td <%=class1%>><%= data.TRFGR %></td>
            <td <%=class1%>><%= data.TRFST %></td>
            <td <%=class1%>><%= data.VGLST %></td>
            <td <%=class1%>><%= (data.DAT01).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT01) %></td>
            <td <%=class1%>><%= WebUtil.printNumFormat(data.OCCUR1,2) %></td>
            <td <%=class1%>><%= WebUtil.printNumFormat(data.ABWTG1,2) %></td>
            <td <%=class1%>><%= WebUtil.printNumFormat(data.ZKVRB1,2) %></td>
            <td <%=class1%>><%= data.CONSUMRATE1 %></td>
            <td <%=class1%>><%= WebUtil.printNumFormat(data.OCCUR2,2) %></td>
            <td <%=class1%>><%= WebUtil.printNumFormat(data.ABWTG2,2) %></td>
            <td <%=class1%>><%= WebUtil.printNumFormat(data.ZKVRB2,2) %></td>
            <td class="lastCol" <%=class1%>><%= data.CONSUMRATE2 %></td>
          </tr>
<%
	    } //end for...
%>
			<!-- //[CSR ID:3038270]  -->
          <tr class="sumRow">
          <td class="td11" colspan="9"> <!-- 팀 휴가 사용율 --><%=g.getMessage("LABEL.F.F41.0017")%></td>
          <td class="td11"><%=WebUtil.printNumFormat(sumOCCUR1,2) %></td>
          <td class="td11"><%=WebUtil.printNumFormat(sumABWTG1,2) %></td>
          <td class="td11" ><%=WebUtil.printNumFormat(sumZKVRB1,2) %></td>
          <td class="td11"><%=WebUtil.printNumFormat(allAVG1,2) %></td>
          <td class="td11"><%=WebUtil.printNumFormat(sumOCCUR2,2) %></td>
          <td class="td11"><%=WebUtil.printNumFormat(sumABWTG2,2) %></td>
          <td class="td11" ><%=WebUtil.printNumFormat(sumZKVRB2,2) %></td>
          <td class="td11"><%=WebUtil.printNumFormat(allAVG2,2) %></td>
          </tr>
        </table>
        </div>
        </div>
        <span class="commentOne">&nbsp;<!-- 건전한 휴가 사용 문화 정착을 위하여 조직책임자께서는  <font color="#CC3300" ><b><u>본인을 포함한</u></b></font> 조직 구성원 전체의 사전 휴가 계획 수립/관리 바랍니다. --><%=g.getMessage("MSG.F.F41.0001")%></span>


<%
    }else{
%>
  <div class="align_center">
    <span><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.F.FCOMMON.0002")%></span>
  </div>
<%
    } //end if...
%>

</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
