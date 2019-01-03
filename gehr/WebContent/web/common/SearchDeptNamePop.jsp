<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서명 검색                                                 */
/*   Program ID   : SearchDeptNamePop.jsp                                       */
/*   Description  : 부서명 검색 PopUp                                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-20  유용원                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    String deptNm  = WebUtil.nvl(request.getParameter("txt_deptNm")); //부서명
    String authClsf  = WebUtil.nvl(request.getParameter("authClsf")); //권한 그룹
%>

<jsp:include page="/include/header.jsp"/>

<script language="JavaScript">
<!--
    // 부서 검색
    function init()
    {
        var frm = document.form1;
        frm.action = "<%= WebUtil.ServletURL %>hris.common.SearchDeptNameSV";
        frm.target = "iFrame";
        frm.submit();
    }


//-->
</script>
</head>

<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" onload="init()">
<form name="form1" method="post" action="">
    <input type="hidden" name="txt_deptNm" value="<%=deptNm%>">
    <input type="hidden" name="authClsf" value="<%=authClsf%>">
</form>
<div class="winPop">

    <div class="header">
        <span><%=g.getMessage("LABEL.D.D12.0048")%><%--부서명 검색--%></span>
        <a onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
    </div>

    <div class="body">

        <div style="margin-bottom:10px;">
            <IFRAME  name="iFrame" frameborder="0" leftmargin="0" height="310" width="100%" marginheight="0" marginwidth="0" topmargin="0" scrolling="auto" ></IFRAME>
        </div>

        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:self.close()"><span><%=g.getMessage("BUTTON.COMMON.CLOSE")%><%--닫기--%></span></a></li>
            </ul>
        </div>

    </div>

</div>
</body>
<jsp:include page="/include/footer.jsp"/>