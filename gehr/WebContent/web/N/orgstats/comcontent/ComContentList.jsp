<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.N.EHRCommonUtil"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%

    //석박사 or 예비사업가 Pool 구분 => 추후에 Language 인재 추가

	String viewGubun =	EHRCommonUtil.nullToEmpty(request.getParameter("viewGubun"));
	String searchRegion = WebUtil.nvl((String)request.getAttribute("I_AREA"));
	String I_INOUT = WebUtil.nvl((String)request.getAttribute("I_INOUT"));
	String I_INOUTXT = EHRCommonUtil.nullToEmpty((String)request.getParameter("I_INOUTXT"));
	if(I_INOUTXT.equals("")){
		I_INOUTXT  = g.getMessage("LABEL.N.N02.0012");  //전체
	}

	WebUserData user    = (WebUserData)session.getAttribute("user");
	String sCommand = EHRCommonUtil.nullToEmpty(request.getParameter("command"));

	String tabNo =  "1";
	String tabName=g.getMessage("MSG.N.N02.0007"); //- 박사 인원현황
    if(sCommand.equals("")){
   		sCommand ="01";
    }

    if(sCommand.equals("02")){
    	tabNo =  "2";
    	tabName= g.getMessage("MSG.N.N02.0008"); //- 석사 인원현황
    }else if(sCommand.equals("03")){
    	tabNo =  "3";
    	tabName= g.getMessage("MSG.N.N02.0009"); //- LG MBA 인원현황
    }

	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	Vector orgVT = (Vector)qlHM.get("T_EXPORT"+tabNo);

	int qlSize = orgVT.size();
	HashMap<String, String> T_EXPORT = new HashMap<String, String>();

	String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                              //부서명
	String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                //부서코드

	String chck_sub = WebUtil.nvl(request.getParameter("chck_sub"));

	String callPrevbtn = WebUtil.nvl(request.getParameter("callPrevbtn"));
	//  최근3개년 연도 가져옴
    Vector CodeEntity_vt = new Vector();
	int currentYear =  Integer.parseInt(DataUtil.getCurrentYear());
    for( int i = currentYear  ; i >= ( currentYear - 2)  ; i-- ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    String searchYear = EHRCommonUtil.nullToEmpty(request.getParameter("searchYear"));
    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    String sMenuText = WebUtil.nvl(request.getParameter("sMenuText"));
    String tabSet = EHRCommonUtil.nullToEmpty(request.getParameter("tabSet"));
    if(tabSet.equals("")){
    	tabSet = "0";
    }
    String ichck_yeno = WebUtil.nvl(request.getParameter("ichck_yeno"));
%>

<jsp:include page="/include/header.jsp" />

<script>

	$(function() {
		tabMove();
	});

	function excelDown(gubun) {
	    frm = document.form1;
	    frm.command.value = gubun;
	    frm.targetpage.value ="excel";
	    frm.target = "hidden";
   		frm.selectRegTxt.value = parent.document.form1.selectRegTxt.value;
		frm.searchNation.value = parent.document.form1.searchNation.value;
	    <%
	    if(viewGubun.equals("BP")){
	    %>
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.prebusnpool.PreBusnPoolSV";
	    <%}else if(viewGubun.equals("GD")){ %>
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.gradudoctor.GraduDoctorSV";
	    <%}%>
	    frm.submit();
	}

	function goDetail(orgdept,zcode,codtx,gubun,deptnm,command,year){
		frm = document.form1;

		parent.switchScreen();
		if(orgdept == zcode && codtx!="합계"){
			frm.ichck_yeno.value = "";
		}else{
			frm.ichck_yeno.value = "Y";
		}

		frm.selectRegTxt.value = parent.document.form1.selectRegTxt.value;
		frm.searchNation.value = parent.document.form1.searchNation.value;
		frm.command.value = command;
		frm.orgcode.value = zcode;
		frm.deptnm.value = deptnm;
		frm.gubun.value = gubun;
		frm.searchYear.value = year;
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.CommonOrgDetailSV";
		frm.target = "menuContentIframe";
		frm.submit();

	}
	//조회에 의한 부서ID와 그에 따른 조회.
	function setUnderDeptID(deptId, deptNm){
	    frm = document.form1;
	    //alert(frm.callPrevbtn.value);
	    frm.hdn_deptId.value = deptId;
	    frm.I_ORGEH.value = deptId;
	    frm.hdn_deptNm.value = deptNm;
	    frm.chck_yeno.value = "Y";
	    frm.chck_sub.value ="Y";
	    frm.command.value= "<%= sCommand %>";

	    frm.callPrevbtn.value = 'Y';
	   <%
	    if(viewGubun.equals("BP")){
	    %>
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.prebusnpool.PreBusnPoolSV";
	    <%}else if(viewGubun.equals("GD")){ %>
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.gradudoctor.GraduDoctorSV";
	    <%}%>
	    frm.target = "listFrame";
	    frm.submit();
	}

	function change_year(command) {
	  frm = document.form1;
	 parent.switchScreen();
	  var year=frm.selectYear.value;
	  frm.searchYear.value = year;
	  frm.targetpage.value="";
	  frm.command.value = command;
	  frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.prebusnpool.PreBusnPoolSV";
	  frm.submit();
	}

	function tabMove(){

		$(".tab").find(".selected").removeClass("selected");
		<% if (StringUtils.isEmpty(tabSet)){%>
				 $(".tab").find("a:first").trigger("click").addClass("selected");
		<%}else {	%>
			$('#<%=tabSet%>').addClass('selected');
		 <%}%>

		 parent.switchScreen1();
	}

	function sendURL(idName, gubun){
		var aform = document.form1;
	    aform.command.value = gubun;
	    aform.tabSet.value = idName;
	    aform.targetpage.value = "";
	     parent.document.form1.tabSet.value = idName;
	      parent.document.form1.command.value = gubun;
	     <%
	    if(viewGubun.equals("BP")){
	    %>
	    aform.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.prebusnpool.PreBusnPoolSV";
	    <%}else if(viewGubun.equals("GD")){ %>
	    aform.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.gradudoctor.GraduDoctorSV";
	    <%}%>
		parent.switchScreen();
        aform.target = "listFrame";
        aform.submit();

	}

	function go_prev(){
	   history.back();
	}

</script>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">

<form name="form1" method="post">
<input type="hidden" name="command"   value="<%=sCommand %>">
<input type="hidden" name="targetpage"   value="">
<input type="hidden" name="chck_yeno"   value="<%=chck_sub %>">
<input type="hidden" name="chck_sub"   value="<%=chck_sub %>">
<input type="hidden" name="I_ORGEH"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="orgcode"   value="">
<input type="hidden" name="deptnm"   value="">
<input type="hidden" name="gubun"   value="">
<input type="hidden" name="searchYear"   value="<%= searchYear%>">
<input type="hidden" name="viewGubun"   value="<%=viewGubun %>">
<input type="hidden" name="sMenuCode"  value="<%=sMenuCode%>">
<input type="hidden" name="sMenuText"   value="<%=sMenuText %>">
<input type="hidden" name="tabName"   value="<%=tabName %>">
<input type="hidden" name="tabSet"  value="<%=tabSet%>">
<input type="hidden" name="callPrevbtn" value="<%=callPrevbtn %>">
<input type="hidden" name="ichck_yeno"   value="<%=ichck_yeno %>">
<input type="hidden" name="I_INOUT"   value="<%=I_INOUT %>">
<input type="hidden" name="I_INOUTXT"   value="<%=I_INOUTXT %>">
<input type="hidden" name="searchRegion"   value="<%=searchRegion %>">
<input type="hidden" name="selectRegTxt"   value="">
<input type="hidden" name="searchNation"   value="">


<%  Vector checkBox = (Vector)request.getAttribute("checkBox");

	  int size = checkBox.size();
	  for(int i=0; i<size; i++){
%>
<input type="hidden" name="checkBox"   value="<%=checkBox.get(i) %>">
<%} %>

<%
//class="subWrapper" 추후에 길이 조절
%>

<div class="subWrapper iframeWrap" >
	<div class="tabArea">
		<ul class="tab">

			<li><a id= "0"  href="javascript:;" class="selected"  onclick="sendURL('0','01')"><spring:message code="TAB.COMMON.0103" /></a><!-- 박사 --></li>
			<li><a id= "1"  href="javascript:;" onclick="sendURL('1','02')"><spring:message code="TAB.COMMON.0104" /></a><!-- 석사 --></li>
			<li><a id= "2"  href="javascript:;" onclick="sendURL('2','03')"><spring:message code="TAB.COMMON.0105" /></a><!-- LG MBA --></li>
		</ul>
	</div>

	<h2 class="subtitle"><spring:message code="LABEL.N.N02.0004" /><!-- 부서명 --> : <span><%=WebUtil.nvl(deptNm, user.e_obtxt)%></span></h2>

	<!-- 테이블 시작 -->
	<div class="listArea">
		<div class="listTop">
			<div class="buttonArea">
				<ul class="btn_mdl">
					<%  if(callPrevbtn.equals("Y")){%>
					<li><a href="javascript:go_prev();"><span><spring:message code="LABEL.N.N02.0005" /><!-- 이전 --></span></a></li>
					<%} %>
					<li><a href="javascript:excelDown('<%=sCommand %>');"><span><spring:message code="LABEL.N.N02.0006" /><!-- Excel Download --></span></a></li>
				</ul>
			</div>
		</div>

		<div class="table">
			<table class="listTable">
				<tr>
					<th><spring:message code="LABEL.N.N02.0007" /><!-- 구분 --></th>
<%
	for(int h=0; h < qlSize ; h ++){
		 T_EXPORT = (HashMap)orgVT.get(h);
	     String  CODTX = T_EXPORT.get("CODTX");
	     String  DEPTNM = null;
	     if(T_EXPORT.get("CODTX").equals("합계")){
	    	   DEPTNM = WebUtil.nvl(deptNm, user.e_obtxt);
	     }else{
	    	   DEPTNM = T_EXPORT.get("CODTX");
	     }

		 for( int j =0 ; j < 20 	; j++){
				String idx ="";
				if(j < 9){
					idx = "0"+(j+1);
				}else{
					idx =""+(j+1);
				}
				String GUBUN =  T_EXPORT.get("GUBUN"+idx);
				String COUNT =  T_EXPORT.get("COUNT"+idx);
				String  ZCODE = T_EXPORT.get("ZCODE");
	     		if(h == 0){
					if(!GUBUN.equals("")){
%>
							<th class=<%=j==qlSize - 2 ? "lastCol" :"" %>><%=COUNT %></th>

<%       			}
				}else{
					if(!GUBUN.equals("")){
%>
                           	<%if(j == 0){ %>
                           	<tr class="<%=qlSize-1 == h ? "td12" : WebUtil.printOddRow(h) %>">
                           	<%if(CODTX.equals("합계")){ %>
                           	<td class="td11"><%= CODTX %></td>
                           	<%}else{ %>
                           	<td><a href="javascript:setUnderDeptID('<%=ZCODE %>','<%=DEPTNM %>');"><%= CODTX %></a></td>
                           	<%} %>

                           	<%} %>
							<td class="right">
							<% if( COUNT.equals("0")){ %>
								<%=COUNT %>
							<%}else{ %>
							<a href="javascript:goDetail('<%=deptId%>','<%=ZCODE %>','<%= CODTX %>','<%= GUBUN%>','<%=DEPTNM %>','<%=sCommand %>','<%= searchYear %>');"><%=WebUtil.printNumFormat(COUNT) %></a>
							<%} %>
							</td>

<%				}
				}
		}

		    %>
		    </tr>
		    <%
	}
%>
				</table>
				<!-- 테이블 끝 -->
			</div>

	</div>

</div>

</form>
</body>

<jsp:include page="/include/footer.jsp" />
<iframe id="excel" name="listFrame" src="" width="0" height="0" marginwidth="0" marginheight="0" scrolling="auto"  frameborder=0 ></iframe>