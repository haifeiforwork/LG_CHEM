<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.sys.*"%>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%
    String upMenuCode = request.getParameter("menuCode");
%>
<html>
<head>
<title>ESS 사용방법안내</title>
<link rel="stylesheet" type="text/css" href="/web/help_online/images/skin/style.css">
<script src="/web/images/MenuTree/MakeTree_Menu.js"></script>
<script language="javascript">
<!--
    function save() 
    {
        var source;
        frm = document.form1;
        source = frm.menuName;
        if(source.value == "" ) {
            alert("메뉴명을 입력하세요");
            source.focus();
            return;
        } // end if
        
        source = frm.prnMenu;
        if(source.value == "" ) {
            alert("출력 메뉴명을 입력하세요");
            source.focus();
            return;
        } // end if
        
        source = frm.realPath ;
        if(frm.menuClsf.value == "02" && source.value == "" ) {
            alert("프로그램은 경로를 하세요 ");
            source.focus();
            return;
        } // end if
        
        frm.jobid.value = "create";
        frm.action = "<%=WebUtil.ServletURL%>hris.sys.SysMenuDetailSV";
        frm.submit();
    }
    
//-->
</script>

</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:save()">저장</a>&nbsp;&nbsp;&nbsp;&nbsp;
<form name="form1" method="post" action="">
    <table>
        <input type="hidden" name="menuCode" value="">
        <input type="hidden" name="upMenuCode" value="<%=upMenuCode%>">
        <tr>
            <td>메 뉴 명 </td>
            <td><input type="text" name="menuName" size="50" value = ""></td>
        </tr>
        <tr>
            <td>출력 메뉴명 </td>
            <td><input type="text" name="prnMenu" size="50" value = ""></td>
        </tr>
	    <tr>
            <td> 메뉴 구분 </td>
            <td><select name="menuClsf">
                <%=WebUtil.printOption(hris.sys.db.MenuCodeDB.getMenuClsf() ,"01")%>
            </select>
        </tr>
        <tr>
            <td> 형태 구분 </td>
            <td><select name="mv_clsf">
                <%=WebUtil.printOption(hris.sys.db.MenuCodeDB.getMv_clsf() ,"01")%>
            </select>
        </tr>
    
        <tr>
            <td>프로그램 경로 </td>
            <td><input type="text" name="realPath" size="50" value = ""></td>
        </tr>

        <tr>
            <td> 배경 이미지 </td>
            <td><input type="text" name="cmm_img_path" size="50" value = ""></td>
        </tr>
        <tr>
            <td> 선택 이미지 </td>
            <td><input type="text" name="over_img_path" size="50" value = ""></td>
        </tr>
        <tr>
            <td> 순서 </td>
            <td><input type="text" name="orderSq" size="3" value = "01"></td>
        </tr>
        <tr>
            <td> 높이 </td>
            <td><input type="text" name="menuHeight" size="3" value = "27"></td>
        </tr>
	</table>
	<br>
<input type="hidden" name="jobid">
</form>
</body>
</html>	