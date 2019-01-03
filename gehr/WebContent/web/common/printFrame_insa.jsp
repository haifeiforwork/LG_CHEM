<%@ page import="org.springframework.web.bind.ServletRequestUtils" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사기록부발행                                              */
/*   Program Name : 인사기록부발행                              */
/*   Program ID   : printFrame_insa.jsp                                     */
/*   Description  : 인사기록부발행         */
/*   Note         : 없음                                                        */
/*   Creation     :  								*/
/*   Update       : 2014-02-10 C20140210_84209  구분추가*/

/*   Update       : 2014-06-09 [CSR ID:2553584] 인사기록부 출력 포맷 변경  인사기록부 하단에 page 버튼 삭제*/
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<jsp:include page="/include/header.jsp" />
<script>
    $(function() {
        blockFrame();
    });

    function loadFrame() {
        window.frames['beprintedpage'].location.href = "<%=WebUtil.JspURL %>common/waitPop.jsp?&url=<%=WebUtil.ServletURL %>hris.A.A01PersonalCardSV_m";
    }
</script>
<%
    String printButtonURL = WebUtil.JspURL + "common/printTopPopUp_insa.jsp";
    printButtonURL = WebUtil.ServletURL + "hris.A.A01PersonalCardPrintButtonSV_m?viewEmpno=" + ServletRequestUtils.getStringParameter(request, "viewEmpno", "");
%>

<frameset rows="100,*" frameborder="NO" border="0" framespacing="0">
    <frame name="prt" scrolling="NO" noresize src="<%=printButtonURL %>" frameborder="NO" marginwidth="0" marginheight="0" >
    <frame id="beprintedpage" name="beprintedpage" src="<%=WebUtil.JspURL %>common/waitPop.jsp?&url=<%=WebUtil.ServletURL %>hris.A.A01PersonalCardSV_m" marginwidth="0" marginheight="0" scrolling="AUTO" frameborder="NO">
</frameset>
</html>
<jsp:include page="/include/footer.jsp" />
