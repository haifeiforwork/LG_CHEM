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

	WebUserData user    = (WebUserData)session.getAttribute("user");
	String sCommand = WebUtil.nvl(request.getParameter("command"));
	if(sCommand.equals("")){
		sCommand = "0011";
	}
    String tabNo =  "2";
    String tabName= g.getMessage("MSG.N.N02.0010"); //- 차세대
    if( sCommand.equals("0001")){
    	tabName= g.getMessage("MSG.N.N02.0011"); //- HPI
    	tabNo =  "3";
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
    	tabSet = "1";
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
      frm.target = "listFrame";
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

 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y"/>
</jsp:include>

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
<input type="hidden" name="tabSet"  value="<%=tabSet%>">
<input type="hidden" name="callPrevbtn" value="<%=callPrevbtn %>">
<input type="hidden" name="ichck_yeno"   value="<%=ichck_yeno %>">
<input type="hidden" name="tabName"   value="<%=tabName %>">
<input type="hidden" name="I_INOUT"   value="2">
<%
//class="subWrapper" 추후에 길이 조절
%>

	<div class="tabArea">
		<ul class="tab">
			<li><a id= "1"  href="javascript:;" class="selected"  onclick="sendURL('1','0011')"><spring:message code="TAB.COMMON.0101" /></a></li>
			<li><a id= "2"  href="javascript:;"  onclick="sendURL('2','0001')"><spring:message code="TAB.COMMON.0102" /></a></li>
		</ul>
	</div>

	<%  if(viewGubun.equals("BP")){%>
	<!-- 상단 검색테이블 시작-->
	<div class="tableInquiry">
		<table>
			<tr>
				<td>
					<select name="selectYear">
					<%= WebUtil.printOption(CodeEntity_vt,searchYear)%>
					</select>
	        			<div class="tableBtnSearch tableBtnSearch2">
						<a class="search" href="javascript:change_year('<%=sCommand %>');"><span><spring:message code='BUTTON.COMMON.SEARCH'/></span></a>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<%} %>

	<!-- 테이블 시작 -->
	<div class="listArea">
		<div class="listTop">
			<h2 class="subtitle withButtons"><spring:message code="LABEL.N.N02.0004" /><!-- 부서명 --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
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
					<th class=<%=j==qlSize ? "lastCol" :"" %>><%=COUNT %></th>
			<!--  <th><%=COUNT %></th>  -->

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
		</div>
	</div>
	<!-- 테이블 끝 -->


</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
<iframe id="excel" name="listFrame" src="" width="0" height="0" marginwidth="0" marginheight="0" scrolling="auto"  frameborder=0 ></iframe>