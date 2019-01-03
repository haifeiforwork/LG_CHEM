<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회 가입                                                 */
/*   Program Name : 동호회 가입 신청                                            */
/*   Program ID   : E25InfojoinBuild.jsp                                        */
/*   Description  : 동호회 가입 신청할 수 있게 하는 화면                        */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-03-02  윤정현                                          */
/*                      2015-04-16 이지은D [CSR ID:2753943] 고문실 복리후생 신청 권한 제한 요청                                                        */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E25Infojoin.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    Vector InfoListData_vt = (Vector)request.getAttribute("InfoListData_vt");
    String PERNR = (String)request.getAttribute("PERNR");

    Vector newOpt = new Vector();
    for( int i = 0 ; i < InfoListData_vt.size() ; i++ ){
    	InfoListData  data = (InfoListData)InfoListData_vt.get(i);
        CodeEntity code_data = new CodeEntity();
        code_data.code =  data.MGART ;
        code_data.value =  data.STEXT ;
        newOpt.addElement(code_data);
    }

%>
<c:set var="newOpt" value="<%=newOpt %>"/>
<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css">

    <tags-approval:request-layout titlePrefix="LABEL.E.E26.0008"  disableApprovalLine="true">
                    <tags:script>

                    <script>

$(function() {
	if( "${user.e_persk}"== "14" ) $(".-request-button").hide();
	parent.resizeIframe(document.body.scrollHeight);
});

function doSubmit() {
    if(check_data()){
         buttonDisabled();
         document.form1.jobid.value     = "create";
         document.form1.BEGDA.value = changeChar( document.form1.todate.value, ".", "" );
         document.form1.action = "${g.servlet}hris.E.E25Infojoin.E25InfoBuildSV";
         document.form1.method = "post";
         document.form1.submit();
    }

}
function check_data() {
    if( document.form1.informal.value == "" ) {
        //alert("동호회를 선택하세요.");
        alert("<spring:message code='MSG.E.E26.0003'/>");
        document.form1.informal.focus();
        return false;
    }

    if(document.form1.MEMBER.value=="1") {
       //alert("이미 회원입니다.");
       alert("<spring:message code='MSG.E.E26.0004'/>");
        return false;
    }

    return true;
}

function viewDetail() {
    var idx = document.form1.informal.selectedIndex;

    document.form1.MGART.value = eval("document.form1.MGART"+ idx + ".value");
    document.form1.ENAME.value = eval("document.form1.ENAME"+ idx + ".value");
    document.form1.TITEL.value = eval("document.form1.TITEL"+ idx + ".value");
    document.form1.STEXT.value = eval("document.form1.STEXT"+ idx + ".value");
    document.form1.PERN_NUMB.value = eval("document.form1.PERN_NUMB"+ idx + ".value");
    document.form1.MEMBER.value = eval("document.form1.MEMBER"+ idx + ".value");
    document.form1.gansa.value =  eval("document.form1.gansa"+ idx + ".value");
    document.form1.USRID.value =  eval("document.form1.USRID"+ idx + ".value");
    document.form1.usridd.value =  eval("document.form1.USRID"+ idx + ".value");
    document.form1.APPLINE_APPU_ENC_NUMB.value = eval("document.form1.PERN_NUMB"+ idx + ".value");
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "${g.servlet}hris.E.E25Infojoin.E25InfoBuildSV";
    frm.target = "";
    frm.submit();
}
</script>
</tags:script>
	<!--동호회 테이블 시작-->
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral ">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
	                <th ><span class="textPink">*</span><%--동호회 --%><spring:message code="LABEL.E.E26.0002"/></th>
	                <td><input type="hidden" name="todate" size="14" value="${f:printDate(approvalHeader.RQDAT)}" >
						<select name="informal" onChange="javascript:viewDetail();" style="width:300px">
						<option value="">----------------------------------</option>
									${f:printCodeOption( newOpt, "") }
						</select>
					</td>
					<th><%--간사 --%><spring:message code="LABEL.E.E26.0004"/></th>
                    <td><input type="text" name="gansa" size="20" value="" readonly></td>

				</tr>
				<tr>
                    <th ><%--연락처 --%><spring:message code="LABEL.E.E26.0005"/></th>
                    <td colspan="3"><input type="text" name="usridd" style="width:295px" value="" readonly></td>
				</tr>
			</table>
			<div class="commentsMoreThan2">
				<div><%--신청 시 신청내용이 간사에게 전송됩니다 --%><spring:message code="MSG.E.E26.0001"/></div>
				<div><%--회비는 가입월까지 급여공제 됩니다. --%><spring:message code="MSG.E.E26.0008"/></div>
				<div><%--* 는 필수입력사항입니다. --%><spring:message code="MSG.E.E26.0002"/></div>
			</div>
		</div>
	</div>
	<!--동호회 테이블 끝-->



    <input type="hidden" name="BEGDA" value="">
    <input type="hidden" name="MGART0"     value="">
    <input type="hidden" name="ENAME0"     value="">
    <input type="hidden" name="TITEL0"     value="">
    <input type="hidden" name="STEXT0"     value="">
    <input type="hidden" name="PERN_NUMB0" value="">
    <input type="hidden" name="MEMBER0"    value="">
    <input type="hidden" name="gansa0"     value="">
    <input type="hidden" name="USRID0"     value="">

   <c:forEach var="row" items="${InfoListData_vt}" varStatus="status">
    <input type="hidden" name="MGART${status.count}"     value="${row.MGART }">
    <input type="hidden" name="ENAME${status.count}"     value="${row.ENAME}">
    <input type="hidden" name="TITEL${status.count}"     value="${ row.TITEL}">
    <input type="hidden" name="STEXT${status.count}"     value="${ row.STEXT}">
    <input type="hidden" name="PERN_NUMB${status.count}" value="${ row.PERN_NUMB}">
    <input type="hidden" name="MEMBER${status.count}"    value="${ row.MEMBER}">
    <input type="hidden" name="gansa${status.count}"     value="${ row.ENAME} ${ row.TITEL}">
    <input type="hidden" name="USRID${status.count}"    value="${row.USRID }">
</c:forEach>

    <input type="hidden" name="MGART"     value="">
    <input type="hidden" name="ENAME"     value="">
    <input type="hidden" name="TITEL"     value="">
    <input type="hidden" name="STEXT"     value="">
    <input type="hidden" name="PERN_NUMB" value="">
    <input type="hidden" name="MEMBER"    value="">
    <input type="hidden" name="USRID"     value="">


    <input type="hidden" name="APPLINE_APPU_ENC_NUMB" value="">

   </tags-approval:request-layout>
   </tags:layout>