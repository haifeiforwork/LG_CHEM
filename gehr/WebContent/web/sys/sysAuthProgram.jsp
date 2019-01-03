<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.sys.*"%>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ page import="java.util.*"%>

<%
    Vector vcAuthProgramCode = (Vector)request.getAttribute("vcAuthProgramCode");
    Vector vcAuthCode = (Vector)request.getAttribute("vcAuthCode");
    String userGroup = request.getParameter("userGroup");
    if (userGroup == null) {
        userGroup = "";
    } // end if
   int rowIndex = 0;
%>
<html>
<head>
<title>ESS 사용방법안내</title>
<link rel="stylesheet" type="text/css" href="/help_online/images/skin/style.css">
<script src="/images/MenuTree/MakeTree_Menu.js"></script>
<script language="javascript">
<!--
    
    function setAssignValue()
    {
        var chObj;
        var hObj;
        for ( var i = 0 ; i < document.form1.rowNum.value ; i ++) {
            chObj = eval("document.form1.vState" + i);
            hObj = eval("document.form1.state" + i);
            if (chObj.checked) {
                hObj.value = chObj.value;
            } else {
                hObj.value = "";
            } // end if
        } // end for
    }// end function
    
    function setValue(statIndex ,endIndex ,value)
    {
        for ( var i = statIndex ; i < endIndex ; i ++) {
            Obj = eval("document.form1.vState" + i);
            Obj.checked = value;
        } // end for
    }// end function
    
    
    //전부 할당
    function allAssign(value)
    {
        frm = document.form1;
        setValue(frm.rowIndex.value ,frm.rowNum.value ,value);
    } 
    
    //전부 제거
    function allRemove(value)
    {
        frm = document.form1;
        setValue(0 ,frm.rowIndex.value ,value);
    } 
    
    // 할당 
    function assign()
    {
        frm = document.form1;
        setValue(0 ,frm.rowIndex.value ,false);
        save();
    } 
    //제거
    function remove()
    {
        frm = document.form1;
        setValue(frm.rowIndex.value ,frm.rowNum.value ,false);
        save()
    } 
    
    
    function search() 
    {
        var source;
        frm = document.form1;
        source = frm.userGroup;
        if (source.value == "") {
            alert("권한 그룹을 선택하세요");
        } // end if
        frm.jobid.value = "view";
        frm.action = "<%=WebUtil.ServletURL%>hris.sys.SysAuthProgramSV";
        frm.submit();
    }
    
    function save() 
    {
        var source;
        frm = document.form1;
        source = frm.userGroup;
        if (source.value == "") {
            alert("권한 그룹을 선택하세요");
        } // end if
        setAssignValue();
        frm.jobid.value = "save";
        frm.action = "<%=WebUtil.ServletURL%>hris.sys.SysAuthProgramSV";
        frm.submit();
    }
//-->
</script>

</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
<table width="790" border="0" cellspacing="0" cellpadding="0">
<tr> 
    <td colspan="4" height="15"></td>
  </tr>
  <tr class="bg_0"> 
    <td width="20"></td>    
    <td width="200">&nbsp;`</td>
    <td width="400">권한 그룹&nbsp; 
      <select name="userGroup" size="1" onChange="search()" class="input">
        <option value="">선택</option>
        <%=WebUtil.printOption(vcAuthCode ,userGroup)%>
      </select>
      &nbsp;&nbsp; <b><font color="#FF6600">*</font></b> 선택 클릭시 전체선택 </td>
    <td align="right">
        <a href="javascript:search();"><img src="<%=WebUtil.ImageURL%>btn_search_02.gif" width="55" height="21" border="0" align="absmiddle"></a>&nbsp;
        <a href="javascript:save();"><img src="<%=WebUtil.ImageURL%>btn_save.gif" width="55" height="21" border="0" align="absmiddle"></a>&nbsp;
    </td>
  </tr>
  <tr> 
    <td colspan="4" height="15"></td>
  </tr>
</table>
<table boder = "0">
    <tr>
        <td valign="top">
            <table width="370" border="1" cellspacing="1" cellpadding="0">
                <tr>
                  <td width="100">메뉴이름</td>
                  <td>사용프로그램명</td>
                  <td width="30" align="center"><INPUT type=checkbox name="vDel2" onClick="allRemove(this.checked)" class="chk"></td>       
                      <input type="hidden" name="del" value="false">
                </tr>
<%  for (int i = 0; i < vcAuthProgramCode.size(); i++) { %>
    <%  AuthProgramCode atpc = (AuthProgramCode) vcAuthProgramCode.get(i);%>
    <%  if ("D".equals(atpc.state)) {%>
	            <tr>
	                <td><%=atpc.upFullMenuName%></td>
	                <td><%=atpc.menuName%></td>
	                <td align="center"><input type="checkbox" name="vState<%=rowIndex%>" value="<%=atpc.state%>"></td>
	                <input type="hidden" name="menuCode<%=rowIndex%>" value = "<%=atpc.menuCode%>">
	                <input type="hidden" name="state<%=rowIndex%>" value = "">
	                <input type="hidden" name="authKind<%=rowIndex%>" value = "01">
	            </tr>
	    <% rowIndex ++;%>
    <%  } // end if %>
<%  } // end for %>
            </table>
        </td>
        <input type="hidden" name="rowIndex" value="<%=rowIndex%>">
        <td width="50" valign="top" >
            <table width="100%" height="200">
                <tr> 
                    <td width="100%" valign="middle"  align="center">
                    <a href="javascript:assign();"><img src="<%=WebUtil.ImageURL%>btn_b_pre.gif"  border="0" align="absmiddle"></a><br>
                    <br>
                    <a href="javascript:remove();"><img src="<%=WebUtil.ImageURL%>btn_b_next.gif" border="0"  align="absmiddle"></a>
                    </td>
                </tr>
            </table>
        </td>
        <td valign="top">
            <table width="370" border="1" cellspacing="1" cellpadding="0">
                <tr >
                    <td width="30" align="center"><INPUT type=checkbox name="vDel2" onClick="allAssign(this.checked)" class="chk"></td>
                    <td width="100">메뉴</td>
                    <td>비사용프로그램명</td>
                </tr>
<%  for (int i = 0; i < vcAuthProgramCode.size(); i++) { %>
    <%  AuthProgramCode atpc = (AuthProgramCode) vcAuthProgramCode.get(i);%>
    <%  if ("I".equals(atpc.state)) {%>
                <tr>
                    <td align="center"><input type="checkbox" name="vState<%=rowIndex%>" value="<%=atpc.state%>"></td>
                    <td><%=atpc.upFullMenuName%></td>
                    <td><%=atpc.menuName%></td>
                    <input type="hidden" name="menuCode<%=rowIndex%>" value = "<%=atpc.menuCode%>">
                    <input type="hidden" name="state<%=rowIndex%>" value = "">
                    <input type="hidden" name="authKind<%=rowIndex%>" value = "01">
                </tr>
        <% rowIndex ++;%>
    <%  } // end if %>
<%  } // end for %>                       
            </table>
        </td>
    </tr>
</tabel>
<input type="hidden" name="jobid">
<input type="hidden" name="rowNum" value = "<%=vcAuthProgramCode.size()%>">
</form>
</body>
</html>	