<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.sys.*"%>
<%@ page import="java.util.Vector" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    MenuCodeData menuCodeData = (MenuCodeData)request.getAttribute("MenuCodeData");
    Vector vcChildMenuCodeData = (Vector)request.getAttribute("vcChildMenuCodeData");
%>
<html>
<head>
<title>ESS 사용방법안내</title>
<link rel="stylesheet" type="text/css" href="/help_online/images/skin/style.css">
<script src="<%= WebUtil.ImageURL %>MenuTree/MakeTree_Menu.js"></script>
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
        frm.jobid.value = "update";
        frm.action = "<%=WebUtil.ServletURL%>hris.sys.SysMenuDetailSV";
        frm.submit();
    }
    
    function del() 
    {
        var source;
        frm = document.form1;
        source = frm.menuName;
        frm.jobid.value = "delete";
        frm.action = "<%=WebUtil.ServletURL%>hris.sys.SysMenuDetailSV";
        frm.submit();
    } 
    
    function creat() 
    {
        var source;
        frm = document.form1;
        source = frm.menuName;
        frm.jobid.value = "newCreate";
        frm.action = "<%=WebUtil.ServletURL%>hris.sys.SysMenuDetailSV";
        frm.submit();
    } 
    
//-->
</script>

</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:save()">저장</a>&nbsp;&nbsp;&nbsp;&nbsp;
<% if ("01".equals(menuCodeData.menuClsf)) { %> 
    <a href="javascript:creat()">하위메뉴등록</a>&nbsp;&nbsp;&nbsp;&nbsp;
<% } // end if%>    
<% if (("01".equals(menuCodeData.menuClsf) && vcChildMenuCodeData.size() == 0) || "02".equals(menuCodeData.menuClsf)) { %>
    <a href="javascript:del()">삭제</a>&nbsp;&nbsp;&nbsp;&nbsp;
<% } // end if %>
<form name="form1" method="post" action="">
    <table>
        <input type="hidden" name="menuCode" value="<%=menuCodeData.menuCode%>">
        <input type="hidden" name="upMenuCode" value="<%=menuCodeData.upMenuCode%>">
        <input type="hidden" name="menuClsf" value="<%=menuCodeData.menuClsf%>">
        <tr>
            <td>메뉴 코드</td>
            <td><input type="text" name="vMenuCode" size="50" value = "<%=menuCodeData.menuCode%>" readonly></td>
        </tr>
        <tr>
            <td>메 뉴 명 </td>
            <td><input type="text" name="menuName" size="50" value = "<%=menuCodeData.menuName%>"></td>
        </tr>
        <tr>
            <td>출력 메뉴명 </td>
            <td><input type="text" name="prnMenu" size="50" value = "<%=menuCodeData.prnMenu%>"></td>
        </tr>
	<% if ("01".equals(menuCodeData.menuClsf)) { %>
        <tr>
            <td> 형태 구분 </td>
            <td><select name="mv_clsf">
                <%=WebUtil.printOption(hris.sys.db.MenuCodeDB.getMv_clsf() ,menuCodeData.mv_clsf)%>
            </select>
        </tr>
    <%  } else { %>
        <tr>
            <input type="hidden" name="mv_clsf" value="<%=menuCodeData.mv_clsf%>">
            <td>프로그램 경로 </td>
            <td><input type="text" name="realPath" size="50" value = "<%=menuCodeData.pgDetail.realPath%>"></td>
        </tr>
    <% } // end if%>
        <tr>
            <td> 배경 이미지 </td>
            <td><input type="text" name="cmm_img_path" size="50" value = "<%=menuCodeData.cmm_img_path%>"></td>
        </tr>
        <tr>
            <td> 선택 이미지 </td>
            <td><input type="text" name="over_img_path" size="50" value = "<%=menuCodeData.over_img_path%>"></td>
        </tr>
        <tr>
            <td> 높이 </td>
            <td><input type="text" name="menuHeight" size="3" value = "<%=menuCodeData.menuHeight%>"></td>
        </tr>
	</table>
	<br>
<%  if ("01".equals(menuCodeData.menuClsf)) { %>	
	<table border ="1">
		<tr>
		   <td> 메뉴명 </td>
		   <td> 구분</td>
		   <td>메뉴 순서</td>
		</tr>
	<%
	   Vector vcMenuClsf = hris.sys.db.MenuCodeDB.getMenuClsf();
	%>	
	<% for (int i = 0; i < vcChildMenuCodeData.size(); i++) {%>
	    <% MenuCodeData mncd = (MenuCodeData)vcChildMenuCodeData.get(i);%>
	    <tr>
	        <input type="hidden" name="menuCode<%=i%>" value="<%=mncd.menuCode%>">
		    <td><%=mncd.menuName%></td>
			<td><%=WebUtil.printOptionText(vcMenuClsf ,mncd.menuClsf)%></td>
			<td><input type="text" name="orderSq<%=i%>" size="3" maxlength="2" value = "<%=mncd.orderSq%>"></td>
		</tr>
	<% } // end for%>
    </tabel>
<%  } // end if %>    
<input type="hidden" name="jobid">
<input type="hidden" name="rowNum" value = "<%=vcChildMenuCodeData.size()%>">
</form>
</body>
</html>	