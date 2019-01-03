<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>

<%@ page import="java.io.*,java.util.*,java.net.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="hris.common.util.PdfUtil" %>


<%@ page import="etiming.astdts.apl3161.TSSPdfTSTValidator"%>
<%@ page import="etiming.astdts.apl3161.CertVerifyConst" %>
<%@ page import="PDFExport.ezPDFExportFile"%>
<%@ page import="com.sns.jdf.*"%>
<%@ page import="sun.misc.BASE64Decoder"%>


<%
	// 2015.11.30
	WebUserData  user = (WebUserData)session.getAttribute("user");
	D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
	D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
	//taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);
	taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode);

	String targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;

	application.setAttribute("targetYear", targetYear);
	application.setAttribute("empNo", user.empNo);

	//2002.12.04. 연말정산 확정여부 조회
	String o_flag = "";
	D11TaxAdjustYearCheckRFC rfc_o = new D11TaxAdjustYearCheckRFC();
	o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

	//2002.12.03 내역조회가 가능한지 날짜를 체크한다.
	String currentDate = DataUtil.getCurrentDate();
	int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));
	String Gubn = "PDF";
	//세대주여부
	//D11TaxAdjustHouseEssentialChkRFC HouseEChkRFC           = new D11TaxAdjustHouseEssentialChkRFC();
    //String E_CHECK = HouseEChkRFC.getYn( user.empNo,targetYear);

	//PDF 데이터를 지워줘야함
	application.removeAttribute(session.getId());
	application.removeAttribute("msg");
%>

<html>
<head>
<title>ESS</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" src="uploadFileNew.js"></script>
<script src="http://code.jquery.com/jquery-1.9.1.min.js" type="text/javascript" language="javascript"></script>
<script src="jquery.MultiFile.js" type="text/javascript" language="javascript"></script>

<script language="JavaScript">
<!--
	function checkForm(){

		//이미 체크되어 있을 경우 체크 해제할 수 없다.

		//if (document.form1.FSTID.value=="X" && document.form1.FSTID.checked != true) {
	        // alert("다른 화면에서 입력한 주택자금 관련 공제항목이 있으니 세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.");
	        // return;
    		//}

		if(confirm("이미 업로드된 파일이 있는 경우,\n이전 자료는 삭제되고 새로 업로드한 파일로 반영 됩니다.\n계속 진행하시겠습니까?")){

		}else{
			return false;
		}

		eval("document.form1.FSTID.disabled = false;") ; //세대주여부
		if(document.form1.FSTID.checked){
			document.form1.FSTID.value = "X";
		} /* else {
			if(confirm("세대주가 아니면 공제대상에서 제외되는 항목이 있습니다.\n세대주가 맞는지 확인 후 세대주일 경우 [확인]을 클릭하시고 세대주가 아닐 경우 [취소]를 클릭하세요.\n[취소]를 클릭하실 경우 일부 항목이 연말정산 공제대상에 포함되지 않을 수 있습니다.")){
				document.form1.FSTID.checked = true;
				document.form1.FSTID.value = "X";

			} else {
				document.form1.FSTID.checked = false;
				document.form1.FSTID.value = "";

			}
		} */

		// 파일 오브젝트 처리
		var fileTags = document.body.getElementsByTagName('input');
		var arr = new Array();
		var cnt = 0;

		for (var tg = 0; tg< fileTags.length; tg++) {
			var tag = fileTags[tg];

			if (tag.name =='Filename') {
				tag.name = tag.id;   // tag.name이 모두 Filename 으로 된 것을 바꾸도록 처리함 (MultiFile.js 의 버그? )
			}
		}
		document.getElementById("form1").target = "hiddenFrame";
		document.getElementById("form1").action = "upNew.jsp";
		document.getElementById("form1").submit();
	}

	function resetAll(){
		if(confirm("파일 재선택 후 반드시 파일전송을 클릭하셔야 내용이 수정됩니다.")){
			location.href = "<%= WebUtil.JspPath %>upload/D11TaxAdjust/upload_new.jsp";
		}else{
			return false;
		}
	}

	// PFD 전체 파일 업로드
	function batchUpload(){

		if( confirm("담당자 작업으로 기업로드 된 PDF파일 전체를 재업로드 합니다.\n정말로 작업을 진행 하시겠습니까?")){
			document.body.style.cursor="wait";
			document.getElementById("resultTd").innerHTML = "일괄 PDF 업로드가 진행 중 입니다......";
			document.getElementById("form1").target = "hiddenFrame";
			document.getElementById("form1").action = "upNewBatch.jsp";
			document.getElementById("form1").submit();
		}
	}

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" id="form1" method="post" action="upNew.jsp"  enctype="multipart/form-data" >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="840" border="0" cellspacing="0" cellpadding="0">
    <%@ include file="../../D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>
<tr><td height="3" colspan="3"></td></tr>
		<tr><td>
		<b style="color: #DB0000;">&nbsp;&nbsp;&nbsp;※ 국세청자료(PDF) 업로드를 하게 되면 기존에 국세청자료(PDF) 업로드로 반영한 모든 데이터가 삭제 되오니 이점 주의  하시기 바랍니다.</b>
		</td></tr>
  <tr>
    <td>
<table width="100%">
<tr><td height="2" colspan="3"></td></tr>
<tr><td height="1" colspan="3" bgcolor="c0b89f"></td></tr>
<tr>
	<td class="td03" style="width:54px;text-align:center;">&nbsp;&nbsp;파일<br/>업로드</td>
	<td valign="top">
		<table width="100%" border="0">
			<tr>
				<td width="70%" height="10px"></td>
				<td width="30%" height="10px"></td>
			</tr>
			<tr>
				<td>
					<input class="multi" type="file" id="Filename" name="Filename" width="200" accept="pdf" style="width:300"/>
					<div id="fileList" style="border:#999 solid 3px; padding:10px;">

					</div>
    			</td>
				<td valign="top"></td>
			</tr>
		</table>
	</td>
	<td valign="top" class="td03" style="width:380px;">
		<table width="100%" height="100%" border="0" cellspacing="5" cellpadding="0">
		<tr><td with="30px" >&nbsp;</td><td>
		<b style="color:#DB0000;">[파일 업로드 시 주의사항]</b>
		</td></tr>
		<tr><td with="50px" >&nbsp;</td><td>
		1. 국세청자료(PDF) 파일만 업로드하실 수 있습니다.<br/>&nbsp;&nbsp;&nbsp;
		(ex. 김길동(600101)-2015년도자료.pdf)<!-- @2014 연말정산 -->
		</td></tr>
		<tr><td with="50px" >&nbsp;</td><td>
		2. 파일에 비밀번호가 설정된 경우 업로드가 불가능<br/>&nbsp;&nbsp;&nbsp;
		하니 국세청에서 <font color="#DB0000">비밀번호 설정을 해제</font>한 후 파일<br/>&nbsp;&nbsp;&nbsp;
		을 다시 다운로드하셔야 합니다.
		</td></tr>
		<tr><td with="50px" >&nbsp;</td><td>
		3. 파일 업로드 시 연말정산 공제에 반영 처리되며<br/>&nbsp;&nbsp;&nbsp;
		연말정산 기간 내에 파일을 다시 업로드 하게 되면<br/>&nbsp;&nbsp;&nbsp;
		<font color="#DB0000">이전 자료는 삭제</font>되고 업로드한 파일로 반영됩니다.
		</td></tr>
		<tr><td with="50px" >&nbsp;</td><td>
		4. 파일 업로드 후 아래의 [처리결과]에서 연말정산<br/>&nbsp;&nbsp;&nbsp;
		반영내역을 확인하실 수 있습니다.
		</td></tr>
		<tr><td with="50px" >&nbsp;</td><td>
		5. 파일을 다시 업로드해야 할 경우 아래의 [수정]<br/>&nbsp;&nbsp;&nbsp;
		버튼을 클릭하세요.<br/>&nbsp;&nbsp;&nbsp;
		단, 클릭시 이전 [처리결과]는 보이지 않게 됩니다.
		</td></tr>
<!--		<tr><td>
		6. 문서중앙화파일이 아닌 <font color="#DB0000">원본파일</font>만 가능합니다.<br/>&nbsp;&nbsp;&nbsp;
		[D\LGC_MyFolder]밑의 파일만 첨부가능합니다.
		</td></tr>-->
		</table>
	</td>
</tr>
<tr><td height="1" colspan="3" bgcolor="c0b89f"></td></tr>
<tr>
<td class="td03">처리결과</td>
<td class="td04" valign="top" id="resultTd" style="text-align:left;height:40px" colspan="2">
&nbsp;
</td>
</tr>
<tr><td height="1" colspan="3" bgcolor="c0b89f"></td></tr>
<%
    if(  !o_flag.equals("X") ) {
%>
<tr height = "40">
	<td colspan="3" align = "center" valign="bottom">
    <a href="javascript:history.back();">
     <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" align="absmiddle" border="0"></a>
<%
	if( "00204304".equals( (String)user.empNo )){    // 연말정산 담당자. 홍이나 주임만 일괄업로드 버튼이 보임
%>
		<img src="<%= WebUtil.ImageURL %>btn_build2.gif" onClick="batchUpload();" style="cursor:pointer;">	<!--  PDF 일괄 업로드 담당자용 -->
<% }  %>
	</td>
</tr>
<%
    }
%>
</table>
</td>
  </tr>
    <!--<tr>
      <td height="8"></td>
    </tr>-->


 </table>
 <!--업로드프로세스를 hiddenFrame에 호출  -->
 <iframe name="hiddenFrame" 		width="0" height="0"></iframe>
 <iframe name="hiddenFramePro" 	width="0" height="0"></iframe>
 <%@ include file="/web/common/commonEnd.jsp" %>
</form>

</body>
</html>