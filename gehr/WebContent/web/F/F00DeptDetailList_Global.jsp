<%/**********************************************************************************
*    System Name   : g-HR
*   1Depth Name        : Organization & Staffing
*   2Depth Name    : Headcount
*   Program Name   : Org.Unit/Level (Staff Present State Detail)
*   Program ID         : F00DeptDetailList_Global.jsp
*   Description        : 인원현황 각각의 상세화면 조회를 위한 jsp 파일
*   Note               : 없음
*   Creation           :
*   Update             :
***********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.common.util.*" %>

<%@ page import="hris.N.AES.AESgenerUtil"%>

<%

	// 웹로그 메뉴 코드명
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));

    request.setCharacterEncoding("utf-8");

    WebUserData user    = (WebUserData)session.getAttribute("user");                    //세션.

    String deptId           = WebUtil.nvl(request.getParameter("hdn_deptId"));              //부서코드
    String deptNm           = (WebUtil.nvl(request.getParameter("hdn_deptNm")));        //부서명
    String gubun            = WebUtil.nvl(request.getParameter("hdn_gubun"));               //구분값.
    String checkYN          = WebUtil.nvl(request.getParameter("chck_yeno"));               //하위부서여부.

    String paramA           = WebUtil.nvl(request.getParameter("hdn_paramA"));          //파라메타
    String paramB           = WebUtil.nvl(request.getParameter("hdn_paramB"));          //파라메타
    String paramC           = WebUtil.nvl(request.getParameter("hdn_paramC"));          //파라메타
    String paramD           = WebUtil.nvl(request.getParameter("hdn_paramD"));          //파라메타
    String paramE           = WebUtil.nvl(request.getParameter("hdn_paramE"));          //파라메타
    String paramF           = WebUtil.nvl(request.getParameter("hdn_paramF"));          //파라메타
    Vector F00DeptDetailListData_vt  = (Vector)request.getAttribute("F00DeptDetailListData_vt");    //내용
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--

//목록으로 가기.
function do_list(){
    history.back();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_gubun.value     = "<%= gubun %>";       //구분값
    frm.hdn_deptId.value    = "<%= deptId %>";      //부서코드
    frm.chck_yeno.value     = "<%= checkYN %>";     //하위부서여부
    frm.hdn_paramA.value    = "<%= paramA %>";      //파라메타
    frm.hdn_paramB.value    = "<%= paramB %>";      //파라메타
    frm.hdn_paramC.value    = "<%= paramC %>";      //파라메타
    frm.hdn_paramD.value    = "<%= paramD %>";      //파라메타
    frm.hdn_paramE.value    = "<%= paramE %>";      //파라메타
    frm.hdn_paramF.value    = "<%= paramF %>";      //파라메타
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
    frm.target = "hidden";
    frm.submit();
    frm.hdn_excel.value = "";
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
<input type="hidden" name="hdn_excel"   value="">

<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="chck_yeno"   value="">
<input type="hidden" name="hdn_paramA"  value="">
<input type="hidden" name="hdn_paramB"  value="">
<input type="hidden" name="hdn_paramC"  value="">
<input type="hidden" name="hdn_paramD"  value="">
<input type="hidden" name="hdn_paramE"  value="">
<input type="hidden" name="hdn_paramF"  value="">
<input type="hidden" name="viewEmpno" value="">
<input type="hidden" name="ViewOrg" value="Y">

<%
    if ( F00DeptDetailListData_vt != null && F00DeptDetailListData_vt.size() > 0 ) {
%>
<h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt">< <spring:message code='LABEL.F.FCOMMON.0006'/> <!-- 총 --><%=F00DeptDetailListData_vt.size()%><spring:message code='LABEL.F.FCOMMON.0007'/><!-- 건 -->></span>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:do_list();"><span><spring:message code='LABEL.F.F01.0038'/><!-- 목록 --></span></a></li>
                    <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
        </div>
        <div class="wideTable" style="border-top: 2px solid #c8294b;">
            <table class="listTable">
                <tr>
                    <th><spring:message code='LABEL.F.F01.0029'/><!-- Corp. --></th>
                    <th><spring:message code='LABEL.COMMON.0005'/><!-- Pers.No --></th>
                    <th><spring:message code='LABEL.COMMON.0004'/><!-- Name --></th>
                    <th><spring:message code='LABEL.F.F00.0004'/><!-- Org.Unit --></th>
                    <th><spring:message code='LABEL.F.F01.0030'/><!-- Emp. Subgroup --></th>
                    <th><spring:message code='LABEL.F.F01.0031'/><!-- Res. of Office --></th>
                    <th><spring:message code='LABEL.F.F01.0032'/><!-- Title of Level --></th>
                    <th><spring:message code='LABEL.F.F01.0033'/><!-- Level --></th>
                    <th><spring:message code='LABEL.F.F01.0034'/><!-- Annual --></th>
                    <th><spring:message code='LABEL.F.F01.0035'/><!-- Job Title --></th>
                    <th><spring:message code='LABEL.F.F01.0036'/><!-- Hiring Date --></th>
                    <!-- <th>Birth Date</th> -->
                    <th class="lastCol"><spring:message code='LABEL.F.F01.0037'/><!-- Area --></th>
                </tr>
<%
        //내용.
        for( int i = 0; i < F00DeptDetailListData_vt.size(); i++ ){
            F00DeptDetailListGlobalData data = (F00DeptDetailListGlobalData)F00DeptDetailListData_vt.get(i);
            String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td><%= data.PBTXT %></td>
					<td><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td>
                    <td><%= data.ENAME %></td>
                    <td><%= data.STEXT %></td>
                    <td><%= data.PTEXT %></td>
                    <td><%= data.JIKKT %></td>
                    <td><%= data.JIKWT %></td>
                    <td><%= data.JIKCT %></td>
                    <td><%= data.ANNUL %></td>
                    <td><%= data.STELL_TEXT %></td>
                    <td><%= (data.DAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT) %></td>
                    <!-- <tdn= (data.GBDAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.GBDAT) %></th> -->
                    <td class="lastCol"><%= data.BTEXT %></td>
                </tr>
<%
            } //end for.
%>
            </table>
        </div>
    </div>

    <div class="buttonArea">
        <ul class="btn_mdl">
            <li><a href="javascript:do_list();"><span><spring:message code='LABEL.F.F01.0038'/><!-- List --></span></a></li>
            <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
        </ul>
    </div>

</div>

<%
    }else{
%>
    <div class="align_center">
         <div class="table">
            <table class="listTable">
                <tr>
                    <th><spring:message code='LABEL.F.F01.0029'/><!-- Corp. --></th>
                    <th><spring:message code='LABEL.COMMON.0005'/><!-- Pers.No --></th>
                    <th><spring:message code='LABEL.COMMON.0004'/><!-- Name --></th>
                    <th><spring:message code='LABEL.F.F00.0004'/><!-- Org.Unit --></th>
                    <th><spring:message code='LABEL.F.F01.0030'/><!-- Emp. Subgroup --></th>
                    <th><spring:message code='LABEL.F.F01.0031'/><!-- Res. of Office --></th>
                    <th><spring:message code='LABEL.F.F01.0032'/><!-- Title of Level --></th>
                    <th><spring:message code='LABEL.F.F01.0033'/><!-- Level --></th>
                    <th><spring:message code='LABEL.F.F01.0034'/><!-- Annual --></th>
                    <th><spring:message code='LABEL.F.F01.0035'/><!-- Job Title --></th>
                    <th><spring:message code='LABEL.F.F01.0036'/><!-- Hiring Date --></th>
                    <!-- <th>Birth Date</th> -->
                    <th class="lastCol"><spring:message code='LABEL.F.F01.0037'/><!-- Area --></th>
                </tr>
                <tr>
                	<td colspan="12"><spring:message code='MSG.F.FCOMMON.0002'/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
                </tr>
            </table>
    </div>
        <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:do_list();"><span><spring:message code='LABEL.F.F01.0038'/><!-- List --></span></a></li>
        </ul>
    </div>
</div>
<%
    } //end if...
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
