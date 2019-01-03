<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%
    String I_DATE = request.getParameter("I_DATE");
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
    Vector main_vt    = (Vector)request.getAttribute("main_vt");
    String hdn_isPop = WebUtil.nvl(request.getParameter("hdn_isPop"));
    String I_GBN = WebUtil.nvl(request.getParameter("I_GBN"));
    String E_OTEXT = WebUtil.nvl(request.getParameter("E_OTEXT"));
    String I_SEARCHDATA = WebUtil.nvl(request.getParameter("I_SEARCHDATA"));
    if( I_DATE == null ) {
        I_DATE = DataUtil.getCurrentDate();           //1번째 조회시
    }

//out.println("deptId"+deptId );
//  out.println("main_vt"+main_vt.toString() );
//out.println("hdn_isPop"+hdn_isPop );
//out.println("I_GBN"+I_GBN );
//out.println("I_SEARCHDATA"+I_SEARCHDATA );
%>

<jsp:include page="/include/header.jsp" />
<script language="javascript">

function doSubmit(){
    if(document.form1.hdn_isPop.value != ""){
    	opener.document.form1.hdn_deptId.value = document.form1.hdn_deptId.value;
    	opener.document.form1.I_SEARCHDATA.value = document.form1.I_SEARCHDATA.value;
    	opener.document.form1.I_GBN.value = document.form1.I_GBN.value;

    	opener.popReload();
    	window.close();

    }else{
    	document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
    	//document.form1.target = "endPage";
        document.form1.submit();
    }
}

</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:doSubmit();MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<form name="form1" method="post" action="">
      <input type="hidden" name="I_DATE" value="<%= I_DATE %>">
      <input type="hidden" name="hdn_deptId" value="<%= deptId %>">
      <input type="hidden" name="hdn_isPop" value="<%= hdn_isPop %>">
      <input type="hidden" name="main_vt" value="<%= main_vt %>">
      <input type="hidden" name="I_SEARCHDATA" value="<%= I_SEARCHDATA %>">
      <input type="hidden" name="I_GBN" value="<%= I_GBN %>">
      <input type="hidden" name="E_OTEXT" value="<%= E_OTEXT %>">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr><td>&nbsp;</td></tr>
          <tr><td>&nbsp;</td></tr>
          <tr>
            <td class="td02" align="center"></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
