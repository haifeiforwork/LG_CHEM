<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>

<%
	WebUserData  user = (WebUserData)session.getAttribute("user");
	D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
	D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
	taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

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
<script language="JavaScript" src="uploadFile.js"></script>

<script language="JavaScript">
<!--
	function checkForm(){
		var objectTags = document.getElementsByTagName('object');
		var movie;
		if(document.getElementsByName(objectTags[0].getAttribute("id"))[0]) {
			movie = document.getElementsByName(objectTags[0].getAttribute("id"))[0];
		}else{
			movie = document.getElementById(objectTags[0].getAttribute("id"));
		}

		if(movie.GetVariable("totalSize")==0){
			alert("[파일선택] 버튼을 클릭하시고 업로드할 파일을 선택하세요.");
			return;
		}

		//이미 체크되어 있을 경우 체크 해제할 수 없다.

		//if (document.form1.FSTID.value=="X" && document.form1.FSTID.checked != true) {
	        // alert("다른 화면에서 입력한 주택자금 관련 공제항목이 있으니 세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.");
	        // return;
    		//}

		if(document.form1.FSTID.checked){
			document.form1.FSTID.value = "X";
		} else {
			if(confirm("세대주가 아니면 공제대상에서 제외되는 항목이 있습니다.\n세대주가 맞는지 확인 후 세대주일 경우 [확인]을 클릭하시고 세대주가 아닐 경우 [취소]를 클릭하세요.\n[취소]를 클릭하실 경우 일부 항목이 연말정산 공제대상에 포함되지 않을 수 있습니다.")){
				document.form1.FSTID.checked = true;
				document.form1.FSTID.value = "X";

			} else {
				document.form1.FSTID.checked = false;
				document.form1.FSTID.value = "";

			}
		}

			document.form1.target = "hiddenFrame";
			callSwfUpload('form1');
	}

	function resetAll(){
		 location.href = "<%= WebUtil.JspPath %>upload/D11TaxAdjust/upload.jsp";
	}

//-->
</script>
</head>

<body leftmargin="15" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->


<form name="form1" method="post" action="pro.jsp" >

<pre>
<table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
    <%@ include file="../../D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>
    <br>
<tr><td height="3" colspan="3"></td></tr>
		<tr><td>
		<font color=red>&nbsp;&nbsp;&nbsp;※ PDF 업로드를 하게 되면 기존에 PDF업로드로 반영한 모든 데이타가 삭제  되오니 이점 주의  하시기 바랍니다.</font>
		</td></tr>
  <tr>
    <td>
<table width="100%">
<tr><td height="2" colspan="3"></td></tr>
<tr><td height="1" colspan="3" bgcolor="c0b89f"></td></tr>
<tr>
	<td class="td03" style="width:54px;text-align:center;">&nbsp;&nbsp;파일<br/>업로드</td>
	<td valign="top">
		<script language="javascript">
			makeSwfMultiUpload(
				movie_id='smu03', //파일폼 고유ID
				flash_width='420', //파일폼 너비 (기본값 400, 권장최소 300)
				list_rows='10', // 파일목록 행 (기본값:3)
				limit_size='30', // 업로드 제한용량 (기본값 10)
				file_type_name='PDF 파일', // 파일선택창 파일형식명 (예: 그림파일, 엑셀파일, 모든파일 등)
				allow_filetype='*.pdf', // 파일선택창 파일형식 (예: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl', // 업로드 불가형식
				upload_exe='up.jsp', // 업로드 담당프로그램
				browser_id='<%=session.getId()%>'
			);
		</script>
	</td>
	<td valign="top" class="td03" style="width:295px;">
		<table width="100%" height="100%" border="0" cellspacing="5" cellpadding="0">
		<tr><td>
		<b style="color:red;">[파일 업로드 시 주의사항]</b>
		</td></tr>
		<tr><td>
		1. 국세청 PDF 파일만 업로드하실 수 있습니다.<br/>&nbsp;&nbsp;&nbsp;
		(ex. 홍길동(700101)-<%=targetYear %>년자료(신용카드).pdf)<!-- @2015 연말정산 -->
		</td></tr>
		<tr><td>
		2. 파일에 비밀번호가 설정된 경우 업로드가 불가능<br/>&nbsp;&nbsp;&nbsp;
		하니 국세청에서 <font color="red">비밀번호 설정을 해제</font>한 후 파일<br/>&nbsp;&nbsp;&nbsp;
		을 다시 다운로드하셔야 합니다.
		</td></tr>
		<tr><td>
		3. 파일 업로드 시 연말정산 공제에 반영 처리되며<br/>&nbsp;&nbsp;&nbsp;
		연말정산 기간 내에 파일을 다시 업로드 하게 되면<br/>&nbsp;&nbsp;&nbsp;
		<font color="red">이전 자료는 삭제</font>되고 업로드한 파일로 반영됩니다.
		</td></tr>
		<tr><td>
		4. 파일 업로드 후 아래의 [처리결과]에서 연말정산<br/>&nbsp;&nbsp;&nbsp;
		반영내역을 확인하실 수 있습니다.
		</td></tr>
		<tr><td>
		5. 파일을 다시 업로드해야 할 경우 아래의 [새로고침]<br/>&nbsp;&nbsp;&nbsp;
		버튼을 클릭하세요.<br/>&nbsp;&nbsp;&nbsp;
		단, 클릭시 이전 [처리결과]는 보이지 않게 됩니다.
		</td></tr>
<!--		<tr><td>
		6. 문서중앙화파일이 아닌 <font color="red">원본파일</font>만 가능합니다.<br/>&nbsp;&nbsp;&nbsp;
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
		<img src="<%= WebUtil.ImageURL %>btn_file_save.gif" onClick="checkForm();" style="cursor:pointer;">
		<img src="<%= WebUtil.ImageURL %>btn_reset.gif" onClick="resetAll();" style="cursor:pointer;">
	</td>
</tr>
<%
    }
%>
</table>
</pre>

</td>
  </tr>
    <!--<tr>
      <td height="8"></td>
    </tr>-->


 </table>
 <!--업로드프로세스를 hiddenFrame에 호출  -->
 <iframe name="hiddenFrame" width="0" height="0"></iframe>
 <%@ include file="/web/common/commonEnd.jsp" %>
</form>

</body>
</html>