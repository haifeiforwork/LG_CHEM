<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.N.EHRCommonUtil"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    //Global 해외경험 인원(viewGubun = EX)  =>인재 국내 외국인 근로자 추후에 추가

	String viewGubun =	 request.getParameter("viewGubun");
	String searchRegion = WebUtil.nvl((String)request.getAttribute("I_AREA"));

 //   Vector hidden_nation = (Vector)request.getAttribute("hidden_nation");

  //   StringBuffer bfbu = new StringBuffer();
//	  int nationSize = 0;
//	  if(hidden_nation != null ){

//	  nationSize = hidden_nation.size();
//	  if(nationSize > 0 ){
//
//	  for(int i=0; i<nationSize; i++){
//		  bfbu.append(hidden_nation.get(i));
//		  bfbu.append(",");
//	  }

//	  }
//	  }

	WebUserData user    = (WebUserData)session.getAttribute("user");
	String command = request.getParameter("command");
	String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                              //부서명
	String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                //부서코드
	String sCommand = WebUtil.nvl(request.getParameter("command"));

	String tabNo =  "1";
	String tabName= "";
	if(viewGubun.equals("GP")){
		tabName= g.getMessage("MSG.N.N02.0001");  //- 학위
	 	if(sCommand.equals("")){
	    	sCommand ="G1";
	    }

	    if(sCommand.equals("E")){
	    	tabNo =  "2";
	    	tabName= g.getMessage("MSG.N.N02.0002"); //- 주재원
	    }else if(sCommand.equals("0002")){
	    	tabNo =  "3";
	    	tabName= g.getMessage("MSG.N.N02.0003"); //- 지역전문가
	    }
	}else if(viewGubun.equals("LF")){
		tabNo = "";
	}

	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	Vector orgVT = (Vector)qlHM.get("T_EXPORT"+tabNo);
	//
	int qlSize = orgVT.size();
	HashMap<String, String> T_EXPORT = new HashMap<String, String>();

	String chck_sub = WebUtil.nvl(request.getParameter("chck_sub"));
	String callPrevbtn = WebUtil.nvl(request.getParameter("callPrevbtn"));

	//코드의 text를 찾고 서브그룹이 몇개인지 체크한다.
	String subTemp ="";
	int subcount = 0;

	Vector codeVT = new Vector();
	Vector codeSizeVT = new Vector();

	if(qlSize > 0){
		for(int h=0; h < 1 ; h ++){
			 T_EXPORT = (HashMap)orgVT.get(h);

		     for( int j =0 ; j < 20 	; j++){
					String idx ="";
					if(j < 9){
						idx = "0"+(j+1);
					}else{
						idx =""+(j+1);
					}
					String SUBTY =  T_EXPORT.get("SUBTY"+idx);
					String SUBTX =  T_EXPORT.get("SUBTX"+idx);
					if(!SUBTY.equals(subTemp)){
						if(!SUBTY.equals("")){
							codeVT.add(SUBTX);
						}
						if(j !=0){
							codeSizeVT.add(subcount+"");
							subcount =0;
						}
					}
					subTemp = SUBTY;
					subcount ++;

		     }
		}
	}

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
	    frm.selectRegTxt.value = parent.document.form1.selectRegTxt.value;
		frm.searchNation.value = parent.document.form1.searchNation.value;
	    frm.targetpage.value ="excel";
	    frm.target = "hidden";
	    <%
	    if(viewGubun.equals("GP")){
	    %>
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.globalprsn.GlobalPrsnSV";
	    <%}else if(viewGubun.equals("LF")){ %>
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.localforeign.LocalForeignSV";
	    <%}%>

	    frm.submit();
	}

	function goDetail(orgdept,zcode,codtx,subty,gubun,deptnm,command){
		frm = document.form1;
		parent.switchScreen();
		if(orgdept == zcode && codtx!="합계"){
			frm.ichck_yeno.value = "";
		}else{
			frm.ichck_yeno.value = "Y";
		}
	    frm.I_INOUT.value="2";
	    frm.selectRegTxt.value = parent.document.form1.selectRegTxt.value;
		frm.searchNation.value = parent.document.form1.searchNation.value;
		frm.command.value = command;
		frm.orgcode.value = zcode;
		frm.subty.value = subty;
		frm.deptnm.value = deptnm;
		frm.gubun.value = gubun;
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.CommonOrgDetailSV";
		frm.target = "menuContentIframe";
		frm.submit();

	}
	//조회에 의한 부서ID와 그에 따른 조회.
	function setUnderDeptID(deptId, deptNm){
	    frm = document.form1;
	    frm.hdn_deptId.value = deptId;
	    frm.I_ORGEH.value = deptId;
	    frm.hdn_deptNm.value = deptNm;
	    frm.chck_yeno.value = "Y";
	    frm.chck_sub.value ="Y";
	    frm.command.value= "<%= sCommand %>";

	     frm.callPrevbtn.value = 'Y';
	   <%
	    if(viewGubun.equals("GP")){
	    %>
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.globalprsn.GlobalPrsnSV";
	    <%}else if(viewGubun.equals("LF")){ %>
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.localforeign.LocalForeignSV";
	    <%}%>
	    frm.target = "listFrame";
	    frm.submit();
	}

   function tabMove(){

		 $(".tab").find(".selected").removeClass("selected");
		<% if (StringUtils.isEmpty(tabSet)){%>
				 $(".tab").find("a:first").trigger("click").addClass("selected");
		<%}else {	%>
			$("#<%=tabSet%>").addClass("selected");
		 <%}%>

		 parent.switchScreen1();
	}

	function sendURL(idName, gubun){
		var aform = document.form1;
	    aform.command.value = gubun;
	    aform.tabSet.value = idName;
	    parent.document.form1.tabSet.value = idName;
	    parent.document.form1.command.value = gubun;
	    aform.targetpage.value = "";
	    <%
	    if(viewGubun.equals("GP")){
	    %>
	    aform.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.globalprsn.GlobalPrsnSV";
	    <%}else if(viewGubun.equals("LF")){ %>
	    aform.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.localforeign.LocalForeignSV";
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
<input type="hidden" name="command"   value="<%= sCommand%>">
<input type="hidden" name="targetpage"   value="">
<input type="hidden" name="chck_yeno"   value="<%=chck_sub %>">
<input type="hidden" name="chck_sub"   value="<%=chck_sub %>">
<input type="hidden" name="I_ORGEH"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="orgcode"   value="">
<input type="hidden" name="deptnm"   value="">
<input type="hidden" name="gubun"   value="">
<input type="hidden" name="subty"   value="">
<input type="hidden" name="viewGubun"   value="<%=viewGubun %>">
<input type="hidden" name="sMenuCode"  value="<%=sMenuCode%>">
<input type="hidden" name="sMenuText"   value="<%=sMenuText %>">
<input type="hidden" name="tabSet"  value="<%=tabSet%>">
<input type="hidden" name="callPrevbtn" value="<%=callPrevbtn %>">
<input type="hidden" name="ichck_yeno"   value="<%=ichck_yeno %>">
<input type="hidden" name="searchRegion"   value="<%=searchRegion %>">
<input type="hidden" name="I_INOUT"   value="2">

<input type="hidden" name="selectRegTxt"   value="">
<input type="hidden" name="searchNation"   value="">
<input type="hidden" name="tabName"   value="<%=tabName %>">

<%  Vector checkBox = (Vector)request.getAttribute("checkBox");
	if(checkBox != null){

	  int size = checkBox.size();
	  for(int i=0; i<size; i++){

%>
<input type="hidden" name="checkBox"   value="<%=checkBox.get(i) %>">

<%
		}
	}
%>
<div class="subWrapper iframeWrap" >

<%
if(viewGubun.equals("GP")){ %>

		<div class="tabArea">
			<ul class="tab">
				<li><a id= "0"  href="javascript:;" class="selected"  onclick="sendURL('0','G1')"><spring:message code="LABEL.N.N02.0001" /><!-- 학위 --></a></li>
				<li><a id= "1"  href="javascript:;"  onclick="sendURL('1','E')"><spring:message code="LABEL.N.N02.0002" /><!-- 주재원 --></a></li>
				<li><a id= "2"  href="javascript:;"  onclick="sendURL('2','0002')"><spring:message code="LABEL.N.N02.0003" /><!-- 지역전문가 --></a></li>
			</ul>
		</div>

<%} %>

	<h2 class="subtitle"><spring:message code="LABEL.N.N02.0004" /><!-- 부서명 --> :  <span><%=WebUtil.nvl(deptNm, user.e_obtxt)%></span></h2>

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
		<div class="table" style="border-top: 2px solid #c8294b;">
			<table class="listTable">
			<thead>
						<tr>
							<th width="190" rowspan="2"><spring:message code="LABEL.N.N02.0007" /><!-- 구분 --></th>

<%                      // 헤더중 top헤더를 만든다.
							int hSize = codeVT.size();
							for(int n = 0; n < hSize ; n ++){
								String sText =(String)codeVT.get(n);
								String sCol = (String)codeSizeVT.get(n);

								if(sCol.equals("1")){
%>

							<th rowspan="2" class=<%=n==hSize-1 ? "lastCol" :"" %>><%=sText %></th>
<%
							}else {
%>
							<th colspan="<%= sCol%>"  ><%=sText %></th>

	<%					}
   						}
	%>
					</tr>

					<tr>
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
				String SUBTY =  T_EXPORT.get("SUBTY"+idx);
				String ZCODE = T_EXPORT.get("ZCODE");

				//헤더이면
	     		if(h == 0){
	     			if(!GUBUN.equals("")){
				%>

							<th><%=COUNT %></th>
				<%}
				//헤더가 아니면
				}else{
					if(!SUBTY.equals("")){
%>
                            <%if(j == 0){ %>
                           	<tr class="<%=qlSize-1 == h ? "td12" : WebUtil.printOddRow(h) %>">
                           	<%if(CODTX.equals("합계")){ %>
                           	<td class="td11"><%= CODTX %></td>
                           	<%}else{ %>
                           	<td ><a href="javascript:setUnderDeptID('<%=ZCODE %>','<%=DEPTNM %>');"><%= CODTX %></a></td>
                           	<%} %>
                           		<%} %>
                           			    <%
	   											 if(viewGubun.equals("GP")){
	    								%>
	    									<td class=<%=j==12 ? "lastCol" :"" %>>
	    								<%}else if(viewGubun.equals("LF")){ %>
	    									<td class=<%=j==13 ? "lastCol" :"" %>>
	    								 <%}%>


							<% if( COUNT.equals("0")){ %>
								<%=COUNT %>
							<%}else{ %>
								<a href="javascript:goDetail('<%=deptId%>','<%=ZCODE %>','<%= CODTX %>','<%=SUBTY %>','<%= GUBUN%>','<%=DEPTNM %>','<%=sCommand %>');"><%=WebUtil.printNumFormat(COUNT) %></a>
							<%} %>
							</td>

<%				}
				}
		}

 %>
	    </tr>

	    <%
  		if(h == 0){
		%>
		</thead>
		<%
	}

  		}
%>
				</table>
<%if(viewGubun.equals("LF")){ %>
			<span class="commentOne"><spring:message code="LABEL.N.N02.0008" /><!-- 계약직 포함 --></span>
<%} %>

		</div>
	</div>
	<!-- 테이블 끝 -->

</div><!-- /subWrapper -->

</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
<iframe id="excel" name="listFrame" src="" width="0" height="0" marginwidth="0" marginheight="0" scrolling="auto"  frameborder=0 ></iframe>

