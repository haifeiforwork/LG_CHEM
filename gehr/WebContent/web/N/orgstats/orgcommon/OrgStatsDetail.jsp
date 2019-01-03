<%/******************************************************************************/
/*   Update      :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건  */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/web/common/commonProcess.jsp"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="hris.N.EHRCommonUtil"%>
<%@ page import="hris.N.AES.AESgenerUtil"%>
<%@ page import="com.sns.jdf.servlet.*"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%

	String viewGubun = WebUtil.nvl((String) request.getParameter("viewGubun"));

	HashMap qlHM = (HashMap) request.getAttribute("resultVT");

	String deptNm = WebUtil.nvl((String) request.getAttribute("deptNm"));
	String orgcode = WebUtil.nvl((String) request.getAttribute("orgcode"));
	String chck_yeno = WebUtil.nvl((String) request.getAttribute("chck_yeno"));
	String gubun = WebUtil.nvl((String) request.getAttribute("gubun"));
	String command = WebUtil.nvl((String)request.getAttribute("command"));
	String ichck_yeno = WebUtil.nvl(request.getParameter("ichck_yeno"));


	String searchRegion = WebUtil.nvl((String)request.getParameter("searchRegion"));


    Box box = WebUtil.getBox(request);
    Vector cb = box.getVector("checkBox");



	//평가3개년 컬럼 이름
	String  I_YEAR = ((String)request.getAttribute("I_YEAR")).substring(2);
	int yearN1 = Integer.parseInt(I_YEAR);

	if(I_YEAR.equals(DataUtil.getCurrentYear().substring(2))){
		 yearN1 =  Integer.parseInt(I_YEAR) -1 ;
	}
	int yearN2 = yearN1  -1;
	int yearN3 = yearN1 -2;

	Vector detailVT = (Vector) qlHM.get("T_EXPORT");
	HashMap<String, String> qlhm = new HashMap<String, String>();







	//	 웹로그 메뉴 코드명 2015-09-08
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));

	String hdn_deptId = WebUtil.nvl(request.getParameter("hdn_deptId"));
	String hdn_deptNm = WebUtil.nvl(request.getParameter("hdn_deptNm"));
	String searchYear = WebUtil.nvl(request.getParameter("searchYear"));
	String I_ITEM = WebUtil.nvl(request.getParameter("I_ITEM"));
	String I_ITEMTXT =  EHRCommonUtil.nullToEmpty(request.getParameter("I_ITEMTXT"));
	if(I_ITEMTXT.equals("")){
		I_ITEMTXT = g.getMessage("LABEL.N.N02.0012"); //전체
	}
	String tabSet = WebUtil.nvl(request.getParameter("tabSet"));


	//엑셀 데이터제목들
    String I_INOUT = EHRCommonUtil.nullToEmpty((String)request.getParameter("I_INOUT"));
	String sMenuText = EHRCommonUtil.nullToEmpty((String)request.getParameter("sMenuText"));
	String tabName = EHRCommonUtil.nullToEmpty((String)request.getParameter("tabName"));
	String I_INOUTXT = EHRCommonUtil.nullToEmpty((String)request.getParameter("I_INOUTXT"));
	String selectRegTxt = EHRCommonUtil.nullToEmpty((String)request.getParameter("selectRegTxt"));
	if(selectRegTxt.equals("")){
		selectRegTxt = g.getMessage("LABEL.N.N02.0012"); //전체
	}
	String searchNation = EHRCommonUtil.nullToEmpty((String)request.getParameter("searchNation"));
	String subty = EHRCommonUtil.nullToEmpty((String)request.getParameter("subty"));


%>
<jsp:include page="/include/header.jsp" />

<script type="text/javascript" src="<%= WebUtil.ImageURL %>js/N/gs_sortable.js"></script>


<style>
	/*  조직도테이블 */
.tb_org {
	table-layout:fixed;
	border-collapse:collapse;
	margin:0;
	padding:0;
	width:100%;
	margin-bottom:15px;
	border:0;
	text-align:center;
	border-top:solid 2px #ee8aa3;
	/* border-bottom:solid 3px #e8e8e8; */
}
.tb_org th {
	vertical-align:middle;
	line-height:18px;
	padding:8px 0 7px 0;
	font-weight:normal;
	font-size:12px;
	background:#f8f8f8;
	border-left:solid 1px #e1e1e1;
	border-right:solid 1px #e1e1e1;
	border-bottom:solid 1px #e1e1e1;
	color:#585858;
}
.tb_org td {
	vertical-align:middle;
	font-size:12px;
	line-height:18px;
	color:#6a6a6a;
	padding:4px 0 3px 0;
	border-left:solid 1px #e1e1e1;
	border-right:solid 1px #e1e1e1;
	border-bottom:solid 1px #e1e1e1;
	overflow:hidden;
}
.tb_org th.first, .tb_org td.first {
	border-left:0 none;
}
.tb_org td.left , .tb_org th.left{
	padding-left:12px;
	text-align:left;
}
.tb_org td.colorStr {background:#fbeef0;}
.tb_org td.right , .tb_org th.right {
	text-align:right;
	padding-right:12px;
}
.tb_org a {
	color:#333;
	text-decoration:underline;
}
.tb_org a:hover, .tb_def a:active{
	color:#888;
	text-decoration:none;
}

.tb_org th.bd_right, .tb_org td.bd_right{
  border-right-width: 1px;
  border-right-color:#888;

}

/* tab line */
.tabLine {
	height:20px;
	overflow:hidden;
	margin-bottom:0;
}
.tabLine a {
	text-decoration:none;
}
.tabLine.narrow .tl, .tabLine.narrow .tr{width:5px;}

.tabLine .tl, .tabLine .tc, .tabLine .tr , .tabLine .tl_on, .tabLine .tc_on, .tabLine .tr_on{
	float:left;
	height:20px;
}
.tabLine .tl{
	width:8px;
	background:url('<%= WebUtil.ImageURL %>tab_left.gif') no-repeat;
}
.tabLine .tr{
	width:29px;
	margin-right:0px;
	background:url('<%= WebUtil.ImageURL %>tab_right.gif') no-repeat top right;
}
.tabLine .tc{
	background:url('<%= WebUtil.ImageURL %>tab_center.gif') repeat-x top center;
	padding:0 3px 0 10px;
}
 .tabLine .tc span {
	display:block;
	padding-top:3px;
	color:#fff;
	font-weight:bold;
}
 .tabLine .on .tl{
	background:url('<%= WebUtil.ImageURL %>tableft_on.gif') no-repeat;
}
 .tabLine .on .tr{
	background:url('<%= WebUtil.ImageURL %>tabright_on.gif') no-repeat top right;
}
 .tabLine .on .tc{
	background:url('<%= WebUtil.ImageURL %>tabcenter_on.gif') repeat-x top center;
}
 .tabLine .on .tc span {
	display:block;
	padding-top:3px;
	color:#fff;
	font-weight:bold;
}

.clear {clear:both;}


</style>
<script type="text/javascript">


		function tabOn_1() {
			$(".tab").find(".selected").removeClass("selected");
			$("#open1").addClass("selected");
			document.all.tb1.style.display="";document.all.tb2.style.display="none";document.all.tb3.style.display="none";document.all.tb4.style.display="none";
			}
		function tabOn_2() {
			$(".tab").find(".selected").removeClass("selected");
			$("#open2").addClass("selected");
			document.all.tb2.style.display="";document.all.tb1.style.display="none";document.all.tb3.style.display="none";document.all.tb4.style.display="none";
			}
		function tabOn_3() {
			$(".tab").find(".selected").removeClass("selected");
			$("#open3").addClass("selected");
			document.all.tb3.style.display="";document.all.tb1.style.display="none";document.all.tb2.style.display="none";document.all.tb4.style.display="none";
			}
		function tabOn_4() {
			$(".tab").find(".selected").removeClass("selected");
			$("#open4").addClass("selected");
			document.all.tb4.style.display="";document.all.tb1.style.display="none";document.all.tb2.style.display="none";document.all.tb3.style.display="none";
			}

		$(function() {
			tabOn_1();
		});
//Execl Down 하기.
function excelDown() {
    frm = document.form1;
    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.CommonOrgDetailSV";
    frm.excel.value="Y";
    frm.targetpage.value ="excel";
    frm.target = "hidden";
    frm.submit();

}


function popupView(winName, width, height, pernr) {
	var formN = document.form1;
	formN.viewEmpno.value = pernr;

	var screenwidth = (screen.width-width)/2;
    var screenheight = (screen.height-height)/2;
    var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=<%=sMenuCode%>&ViewOrg=Y&viewEmpno="+pernr;

	 var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");

}

function do_list(){
	//window.frames["listFrame"].contentWindow.history.back();
	//parent.location.href=document.referrer
	 // location.href = "javascript:history.back()";
	 //var aform = document.form1;
	 history.back();
	 //aform.target ="menuContentIframe";

	 //aform.submit();
}
<%
//http://www.allmyscripts.com/Table_Sort/#example
//'i' - Column contains integer data. If the column data contains a number followed by text then the text will ignored. For example, "54note" will be interpreted as "54".

//'n' - Column contains integer number in which all three-digit groups are optionally separated from each other by commas. For example, column data "100,000,000" is treated as "100000000" when type of data is set to 'n', or as "100" when type of data is set to 'i'.

//'f' - Column contains floating point numbers in the form ###.###.

//'g' - Column contains floating point numbers in the form ###.###. Three-digit groups in the floating-point number may be separated from each other by commas. For example, column data "65,432.1" is treated as "65432.1" when type of data is set to 'g', or as "65" when type of data is set to 'f'.

//'h' - column contains HTML code. The script will strip all HTML code before sorting the data.

//'s' - column contains plain text data.

//'c' - column contains dollar amount, prefixed by '$' character. The amount may contain commas, separating three-digit groups, like this: $1,234,567.89

//'d' - column contains a date.


%>
var TSort_Data = new Array ('my_table',  's', 's','s','s','s','s','s','s','s','f','f','s','s','s');
tsRegister();
var TSort_Data = new Array ('my_table2',  's', 's','s','s','s','s','s','s','s','s','s','s','s','s');
tsRegister();
var TSort_Data = new Array ('my_table3',  's', 's','s','s','s','s','s','s','s');
tsRegister();
var TSort_Data = new Array ('my_table4', 's', 's', 's','s','s','s','s','s', 's','s','s','s');
tsRegister();

</script>
</head>

<body id="subBody" >
<div class="subWrapper" >
<form name="form1" method="post">
	<input type="hidden" 	name="viewEmpno" value="">
	<input type="hidden" 	name="ViewOrg"	value="Y">
	<input type="hidden" 	name="excel" value="">
	<input type="hidden" 	name="targetpage" value="main">
	<input  type="hidden" 	name="chck_yeno" value="<%= chck_yeno %>">

	<input type="hidden" 	name="orgcode" value="<%=orgcode %>">
	<input type="hidden" 	name="deptnm" value="<%= deptNm %>">
	<input type="hidden" 	name="gubun" value="<%=gubun %>">
	<input type="hidden" 	name="command" value="<%=command %>">
	<%
	   //목록보기에 필요한 파라미터
	%>

	<input type="hidden" 	name="I_ORGEH" value="<%=hdn_deptId %>">
	<input type="hidden" name="hdn_deptId"  value="<%=hdn_deptId%>">
    <input type="hidden" name="hdn_deptNm"  value="<%=hdn_deptNm%>">
    <input type="hidden" name="searchYear"  value="<%=searchYear%>">
    <input type="hidden" name="I_ITEM"  value="<%=I_ITEM%>">
    <input type="hidden" name="I_ITEMTXT"  value="<%=I_ITEMTXT%>">
    <input type="hidden" name="tabSet"  value="<%=tabSet%>">
    <input type="hidden" name="ichck_yeno"   value="<%=ichck_yeno %>">
	<input type="hidden" name="I_INOUT"   value="<%=I_INOUT %>">
	<input type="hidden" name="searchRegion"   value="<%=searchRegion %>">

	<input type="hidden" name="viewGubun"   value="<%= viewGubun%>">
	<input type="hidden" name="sMenuText"   value="<%=sMenuText %>">
	<input type="hidden" name="tabName"   value="<%=tabName %>">
	<input type="hidden" name="I_INOUTXT"   value="<%=I_INOUTXT %>">
	<input type="hidden" name="selectRegTxt"   value="<%= selectRegTxt%>">
	<input type="hidden" name="searchNation"   value="<%= searchNation%>">
	<input type="hidden" name="subty"   value="<%= subty%>">



<%
	  Vector checkBox = cb;
	  int size = checkBox.size();
	  for(int i=0; i<size; i++){
%>
<input type="hidden" name="checkBox"   value="<%=checkBox.get(i) %>">
<%} %>
<div class="title"><h1><%=sMenuText %> <spring:message code="LABEL.N.N02.0017" /><!-- 인원 상세 정보 --> <%= tabName%>&nbsp;<spring:message code="LABEL.N.N02.0018" arguments="<%=detailVT.size() %>"/><%-- (총 : <%=detailVT.size() %>건) --%> <%if(viewGubun.equals("LF")){ %>&nbsp;<b><spring:message code="LABEL.N.N02.0019" /><!-- - 계약직 포함 --></b><%} %></h1></div>
	<div class="listArea">
		<div class="listTop">
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a href="javascript:excelDown('Y');"><span><spring:message code="LABEL.N.N02.0006" /><!-- Excel Download --></span></a></li>
					<li><a href="javascript:do_list();"><span><spring:message code="BUTTON.COMMON.LIST" /><!-- 목록 --></span></a></li>
				</ul>
			</div>
		</div>
		<div class="tabArea">
			<ul class="tab">
				<li><a id= "open1"  href="javascript:;" class="selected"  onclick="tabOn_1()"><spring:message code="LABEL.N.N02.0020" /><!-- 인사정보 --></a></li>
				<li><a id= "open2"  href="javascript:;"  onclick="tabOn_2()"><spring:message code="LABEL.N.N02.0021" /><!-- 평가/어학 --></a></li>
				<li><a id= "open3"  href="javascript:;"  onclick="tabOn_3()"><spring:message code="LABEL.N.N02.0022" /><!-- 핵심인재 --></a></li>
				<li><a id= "open4"  href="javascript:;"  onclick="tabOn_4()"><spring:message code="LABEL.N.N02.0023" /><!-- 해외경험 --></a></li>
			</ul>
		</div>

<div class="table" id="tb1" style="diplay: "><!-- 테이블 시작 -->
<table class="listTable " id="my_table" summary=""  >
	<caption></caption>
                <colgroup>
                    <col width="6%" />
                    <col />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                </colgroup>

	 <thead>
		<tr>
			<th height="52" scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0024" /><!-- 성명 --></th>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0025" /><!-- 부서 --></th>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
            <%--<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0026" /><!-- 직위 --></th> --%>
            <th scope="col" rowspan="2"><spring:message code='MSG.A.A01.0084'/><!-- 직위/직급호칭 --></th>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0027" /><!-- 연차 --></th>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0028" /><!-- 직책 --></th>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0029" /><!-- 성별 --></th>
			<th scope="col" rowspan="2" class="bd_right"><spring:message code="LABEL.N.N02.0030" /><!-- 입사일 --></th>
			<th height="52" rowspan="2" class="first" scope="col"><spring:message code="LABEL.N.N02.0031" /><!-- 직무 --></th>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0032" /><!-- 근무지 --></th>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0033" /><!-- 연령 --></th>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0034" /><!-- 근속 --></th>
			<th scope="col" height="18" colspan="3" class="lastCol"><spring:message code="LABEL.N.N02.0035" /><!-- 학력사항 -->
		<tr>
			<th height="18" scope="col"><spring:message code="LABEL.N.N02.0036" /><!-- 학력 --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0037" /><!-- 학교 --></th>
			<th scope="col"  class="lastCol"><spring:message code="LABEL.N.N02.0038" /><!-- 전공 --></th>
		</tr>
	  </thead>
		<%
				for (int i = 0; i < detailVT.size(); i++) {
				qlhm = (HashMap) detailVT.get(i);
				String PERNR = AESgenerUtil.encryptAES(qlhm.get("PERNR"), request);

				String enDate = WebUtil.printDate(qlhm.get("LDAT"));
				if(enDate.length() > 0){
					enDate = enDate.substring(2);
				}
				String tyear = qlhm.get("TITLE_YEAR").substring(1);
				if(tyear.equals("00")){
					tyear = "";
				}
		%>
	<tbody>
		<tr class="borderRow">
			<td ><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font 	color=blue><%=qlhm.get("ENAME")%></font></a></td>
			<td style="text-align:left">&nbsp;<%=qlhm.get("STEXT")%></td>
			<td><%=qlhm.get("TITEL")%></td>
			<td><%=EHRCommonUtil.reIntString(tyear)%></td>
			<td><%= qlhm.get("TITL2") %></td>
			<%
			if (qlhm.get("GENDER").equals("M")) {
			%>
			<td><spring:message code="LABEL.N.N02.0039" /><!-- 남자 --></td>
			<%
			} else {
			%>
			<td><spring:message code="LABEL.N.N02.0040" /><!-- 여자 --></td>
			<%
			}
			%>
			<td class="bd_right"><%=enDate%></td>
			<td class="first"><%=qlhm.get("STELL_TEXT")%></td>
			<td><%=qlhm.get("BTEXT")%></td>
			<td><%=qlhm.get("OLDS")%></td>
			<td><%=qlhm.get("GNSOK")%></td>
			<td><%=qlhm.get("FMCNTXT")%></td>
			<td><%=qlhm.get("LART_TEXT")%></td>
			<td  class="lastCol"><%=qlhm.get("FTEXT1")%></td>
		</tr>

		<%
		}
		%>
	</tbody>
</table>
</div>

<div class="table"   id="tb2" style="display:none"><!-- 테이블 시작 -->
<table class="listTable"   id="my_table2" summary="">
	<caption></caption>
                <colgroup>
                    <col width="6%" />
                    <col />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                </colgroup>

	  <thead>
		<tr>
			<th height="52" scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0024" /><!-- 성명 --></th>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0025" /><!-- 부서 --></th>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
            <%--<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0026" /><!-- 직위 --></th> --%>
            <th scope="col" rowspan="2"><spring:message code='MSG.A.A01.0084'/><!-- 직위/직급호칭 --></th>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0027" /><!-- 연차 --></th>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0028" /><!-- 직책 --></th>
			<th scope="col" rowspan="2"><spring:message code="LABEL.N.N02.0029" /><!-- 성별 --></th>
			<th scope="col" rowspan="2" class="bd_right"><spring:message code="LABEL.N.N02.0030" /><!-- 입사일 --></th>
			<th height="18" scope="col" class="first" colspan="3"><spring:message code="LABEL.N.N02.0041" /><!-- 평가 --></th>
			<th scope="col" colspan="4" class="lastCol"><spring:message code="LABEL.N.N02.0042" /><!-- 어학 --></th>
		</tr>
		<tr>
			<th height="18" scope="col" class="first"><%=yearN1 %><spring:message code="LABEL.N.N02.0043" /><!-- 년 --></th>
			<th scope="col"><%=yearN2 %><spring:message code="LABEL.N.N02.0043" /><!-- 년 --></th>
			<th scope="col"><%=yearN3 %><spring:message code="LABEL.N.N02.0043" /><!-- 년 --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0044" /><!-- LAP --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0045" /><!-- TOEIC --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0046" /><!-- HSK --></th>
			<th scope="col" class="lastCol"><spring:message code="LABEL.N.N02.0047" /><!-- JPT --></th>
		</tr>
	  </thead>
		<%
				for (int i = 0; i < detailVT.size(); i++) {
				qlhm = (HashMap) detailVT.get(i);
				String PERNR = AESgenerUtil.encryptAES(qlhm.get("PERNR"), request);
				String enDate = WebUtil.printDate(qlhm.get("LDAT"));
				if(enDate.length() > 0){
					enDate = enDate.substring(2);
				}
				String tyear = qlhm.get("TITLE_YEAR").substring(1);
				if(tyear.equals("00")){
					tyear = "";
				}
		%>
	<tbody>
		<tr class="borderRow">
			<td><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font 	color=blue><%=qlhm.get("ENAME")%></font></a></td>
			<td style="text-align:left">&nbsp;<%=qlhm.get("STEXT")%></td>
			<td><%= qlhm.get("TITEL") %></td>
			<td><%=EHRCommonUtil.reIntString(tyear)%></td>
			<td><%= qlhm.get("TITL2") %></td>
			<%
			if (qlhm.get("GENDER").equals("M")) {
			%>
			<td><spring:message code="LABEL.N.N02.0039" /><!-- 남자 --></td>
			<%
			} else {
			%>
			<td><spring:message code="LABEL.N.N02.0040" /><!-- 여자 --></td>
			<%
			}
			%>
			<td class="bd_right"><%=enDate%></td>
			<td height="18" class="first"><%=qlhm.get("PERS_APP1")%></td>
			<td><%=qlhm.get("PERS_APP2")%></td>
			<td><%=qlhm.get("PERS_APP3")%></td>
			<td height="18"><%=qlhm.get("LGAX_SCOR")%></td>
			<td><%=WebUtil.nvl(qlhm.get("TOEI_SCOR"))%></td>
			<td><%=WebUtil.nvl(qlhm.get("LANG_LEVL"))%></td>
			<td class="lastCol">
			<%
			if (!"000".equals(qlhm.get("JPT_SCOR"))) {
			%>
			<%=qlhm.get("JPT_SCOR")%>
			<%
			}
			%>
			</td>
		</tr>
		<%
		}
		%>
	</tbody>
</table>
</div>

<div class="table" id="tb3" style="display:none"><!-- 테이블 시작 -->
<table class="listTable"  id="my_table3" summary="">
				<colgroup>
                    <col width="6%" />
                    <col />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                 	<col width="20%" />
	                <col width="20%" />
	              </colgroup>
      <thead>
		<tr>
			<th height="52" scope="col"><spring:message code="LABEL.N.N02.0024" /><!-- 성명 --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0025" /><!-- 부서 --></th>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
            <%--<th scope="col" ><spring:message code="LABEL.N.N02.0026" /><!-- 직위 --></th> --%>
            <th scope="col" ><spring:message code='MSG.A.A01.0084'/><!-- 직위/직급호칭 --></th>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
			<th scope="col"><spring:message code="LABEL.N.N02.0027" /><!-- 연차 --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0028" /><!-- 직책 --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0029" /><!-- 성별 --></th>
			<th scope="col" class="bd_right"><spring:message code="LABEL.N.N02.0030" /><!-- 입사일 --></th>
<!--<th height="52" scope="col" class="first">사업가</th>  -->
			<th scope="col" class="first"><spring:message code="LABEL.N.N02.0048" /><!-- 차세대 --></th>
			<th scope="col" class="lastCol"><spring:message code="LABEL.N.N02.0049" /><!-- HPI --></th>
		</tr>
	  </thead>

		<%
				for (int i = 0; i < detailVT.size(); i++) {
				qlhm = (HashMap) detailVT.get(i);
				String PERNR = AESgenerUtil.encryptAES(qlhm.get("PERNR"), request);
				String enDate = WebUtil.printDate(qlhm.get("LDAT"));
				if(enDate.length() > 0){
					enDate = enDate.substring(2);
				}
				String tyear = qlhm.get("TITLE_YEAR").substring(1);
				if(tyear.equals("00")){
					tyear = "";
				}
		%>
			<tbody>
		<tr class="borderRow">
			<td><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font 	color=blue><%=qlhm.get("ENAME")%></font></a></td>
			<td style="text-align:left">&nbsp;<%=qlhm.get("STEXT")%></td>
			<td><%= qlhm.get("TITEL") %></td>
			<td><%=EHRCommonUtil.reIntString(tyear)%></td>
			<td><%= qlhm.get("TITL2") %></td>

			<%
			if (qlhm.get("GENDER").equals("M")) {
			%>
			<td><spring:message code="LABEL.N.N02.0039" /><!-- 남자 --></td>
			<%
			} else {
			%>
			<td><spring:message code="LABEL.N.N02.0040" /><!-- 여자 --></td>
			<%
			}
			%>
			<td class="bd_right" ><%=enDate%></td>
		<!-- <td class="first" height="18" ><%=qlhm.get("BIZ_CAN")%></td>  -->
			<td class="first"><%=qlhm.get("FGLEADER")%></td>
			<td class="lastCol"><%=qlhm.get("HPI")%></td>
		</tr>
		<%
		}
		%>
	</tbody>
</table>
</div>
<div class="table" id="tb4" style="display:none"><!-- 테이블 시작 -->
<table class="listTable" id="my_table4" summary="">
	<caption></caption>
                    <col width="6%" />
                    <col />
                    <col width="6%" />
                    <col width="6%" />
                    <col width="6%" />
                     <col width="6%" />
                    <col width="6%" />
                     <col width="6%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />

	 <thead>
		<tr>
			<th height="52" scope="col" ><spring:message code="LABEL.N.N02.0024" /><!-- 성명 --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0025" /><!-- 부서 --></th>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
            <%--<th scope="col" ><spring:message code="LABEL.N.N02.0026" /><!-- 직위 --></th> --%>
            <th scope="col" ><spring:message code='MSG.A.A01.0084'/><!-- 직위/직급호칭 --></th>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
			<th scope="col"><spring:message code="LABEL.N.N02.0027" /><!-- 연차 --></th>
			<th scope="col" ><spring:message code="LABEL.N.N02.0028" /><!-- 직책 --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0029" /><!-- 성별 --></th>
			<th scope="col" class="bd_right"><spring:message code="LABEL.N.N02.0030" /><!-- 입사일 --></th>
			<th scope="col" class="first"><spring:message code="LABEL.N.N02.0050" /><!-- 국적 --></th>
			<th height="52" scope="col" ><spring:message code="LABEL.N.N02.0001" /><!-- 학위 --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0002" /><!-- 주재원 --></th>
			<th scope="col"><spring:message code="LABEL.N.N02.0051" /><!-- 연수파견 --></th>
			<th scope="col" class="lastCol"><spring:message code="LABEL.N.N02.0003" /><!-- 지역전문가 --></th>
		</tr>
	   </thead>
		<%
				for (int i = 0; i < detailVT.size(); i++) {
				qlhm = (HashMap) detailVT.get(i);
				String PERNR = AESgenerUtil.encryptAES(qlhm.get("PERNR"), request);
				String enDate = WebUtil.printDate(qlhm.get("LDAT"));
				if(enDate.length() > 0){
					enDate = enDate.substring(2);
				}
				String tyear = qlhm.get("TITLE_YEAR").substring(1);
				if(tyear.equals("00")){
					tyear = "";
				}
		%>
			<tbody>
		<tr class="borderRow">
			<td><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font 	color=blue><%=qlhm.get("ENAME")%></font></a></td>
			<td style="text-align:left">&nbsp;<%=qlhm.get("STEXT")%></td>
			<td><%= qlhm.get("TITEL") %></td>
			<td><%=EHRCommonUtil.reIntString(tyear)%></td>

			<td><%= qlhm.get("TITL2") %></td>
			<%
			if (qlhm.get("GENDER").equals("M")) {
			%>
			<td><spring:message code="LABEL.N.N02.0039" /><!-- 남자 --></td>
			<%
			} else {
			%>
			<td><spring:message code="LABEL.N.N02.0040" /><!-- 여자 --></td>
			<%
			}
			%>
			<td class="bd_right"><%=enDate%></td>
			<td class="first"><%=qlhm.get("NATIO")%></td>
			<td height="18" ><%=qlhm.get("OSDEGR")%></td>
			<td><%=qlhm.get("RESIDENT")%></td>
			<td><%=qlhm.get("LEDU_DEGR")%></td>
			<td class="lastCol"><%=qlhm.get("AMASTER")%></td>
		</tr>
		<%
		}
		%>
	</tbody>
</table>
</div>
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a href="javascript:excelDown('Y');"><span><spring:message code="LABEL.N.N02.0006" /><!-- Excel Download --></span></a></li>
					<li><a href="javascript:do_list();"><span><spring:message code="BUTTON.COMMON.LIST" /><!-- 목록 --></span></a></li>
				</ul>
			</div>
</div>



</form>
<!-- /subWrapper -->
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />