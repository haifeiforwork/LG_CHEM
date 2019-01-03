<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서명 검색                                                 */
/*   Program ID   : SearchDeptNamePop_Rot.jsp                                       */
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
    String deptNm  = WebUtil.nvl(request.getParameter("txt_deptNm")); //부서명,성명
    String I_GBN  = WebUtil.nvl(request.getParameter("I_GBN")); //구분 ORGEH 부서명,PERNR 성명

    String authClsf  = WebUtil.nvl(request.getParameter("authClsf")); //권한 그룹
%>

<html>
<head>
<title>부서명 검색</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript">
<!--
    // 부서 검색
    function init()
    {
        var frm = document.form1;
        frm.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.SearchDeptNameRotSV"
        frm.target = "iFrame";
        frm.submit();
    }


//-->
</script>
</head>

<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" onload="init()">
<form name="form1" method="post" action="">
    <input type="hidden" name="txt_deptNm" value="<%=deptNm%>">
    <input type="hidden" name="I_GBN" value="<%=I_GBN%>">

    <input type="hidden" name="authClsf" value="<%=authClsf%>">
</form>
<div class="winPop">

    <div class="header">
        <span><!--부서명 검색--><%=g.getMessage("LABEL.D.D12.0048")%></span>
        <a href="javascript:self.close()"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
    </div>

    <div class="body">
        <div class="align_center">
            <IFRAME  name="iFrame" frameborder="0" leftmargin="0" height="310" width="300" marginheight="0" marginwidth="0" topmargin="0" scrolling="auto" ></IFRAME>
        </div>

        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:self.close()"><span><%=g.getMessage("BUTTON.COMMON.CLOSE")%></span></a></li>
            </ul>
        </div>
    </div>

</div>
</body>
</html>

