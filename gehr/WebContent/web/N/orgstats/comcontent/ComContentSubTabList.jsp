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

	String viewGubun =	 request.getParameter("viewGubun");


	WebUserData user    = (WebUserData)session.getAttribute("user");
	String sCommand = request.getParameter("command");
	String sapTabNo ="1";
	String tabName= g.getMessage("MSG.N.N02.0004"); //- 영어우수자
  	if(sCommand.equals("PIS0041")){
  		sapTabNo =  "2";
	 	tabName= g.getMessage("MSG.N.N02.0005"); //- 중국어우수자
   	}else if(sCommand.equals("PIS0042")){
   		sapTabNo =  "3";
	 	tabName= g.getMessage("MSG.N.N02.0006"); //- 특수언어우수자
   	}

	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	Vector orgVT = (Vector)qlHM.get("T_EXPORT"+sapTabNo);

	int qlSize = orgVT.size();
	HashMap<String, String> T_EXPORT = new HashMap<String, String>();

	String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                              //부서명
	String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                //부서코드

    String chck_sub = WebUtil.nvl(request.getParameter("chck_sub"));
	String callPrevbtn = WebUtil.nvl(request.getParameter("callPrevbtn"));

	//Subcode tab 추가
	Vector itemVT = (Vector)qlHM.get("T_ITEM");
	int itemSize = itemVT.size();
	String I_ITEM       =  WebUtil.nvl(request.getParameter("I_ITEM"));
	String I_ITEMTXT =  WebUtil.nvl(request.getParameter("I_ITEMTXT"));
	if( I_ITEMTXT == null){
		I_ITEMTXT = (String)request.getAttribute("F_ITEMTXT");
	}
	String F_ITEM = WebUtil.nvl((String)request.getAttribute("F_ITEM"));

    String tabSet = EHRCommonUtil.nullToEmpty(request.getParameter("tabSet"));
    if(tabSet.equals("")){
    	tabSet = "0";
    }




	Vector stextVT = (Vector)qlHM.get("T_TEXT");
	int tetSize = stextVT.size();
	HashMap<String, String> T_TEXT = new HashMap<String, String>();
	String ichck_yeno = WebUtil.nvl(request.getParameter("ichck_yeno"));
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
	String sMenuText = WebUtil.nvl(request.getParameter("sMenuText"));

%>

<jsp:include page="/include/header.jsp" />
<script language="javascript" src="<%= WebUtil.ImageURL %>js/N/rowspan.js"></script>
<script>
	function excelDown(gubun) {

	    frm = document.form1;
	    frm.command.value = gubun;
	    //frm.I_ITEM.value = <%=I_ITEM %>;
	    frm.targetpage.value ="excel";
	    frm.target = "hidden";
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.languageprsn.LanguagePrsnSV";
	    frm.submit();
	}

	function subTabMove(idName, gubun, subText){

		var code = eval("document.all.sub" + idName);
      	for(i = 0; i < <%=itemSize+1 %>; i++){
         	var tls = eval("document.all.sub" + i);
         	if(tls != undefined){
		        tls.className="subM";
	        }
      	}
      	code.className="selected";
	 	sendURL(idName, gubun, subText);
	}

	function sendURL(idName, gubun, subText){
		parent.switchScreen();
		var aform = document.form1;
	    aform.I_ITEM.value = gubun;
	    aform.I_ITEMTXT.value = subText;
	     //aform.tabSet.value = idName;
	     aform.targetpage.value ="";
	    aform.target = "listFrame";
		aform.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.languageprsn.LanguagePrsnSV";
        aform.submit();
	}


	function goDetail(orgdept,zcode,codtx,gubun,deptnm,command,item){
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
		frm.I_ITEM.value = item;
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
        frm.callPrevbtn.value = 'Y';
	    frm.command.value= "<%= sCommand %>";
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.languageprsn.LanguagePrsnSV";
	    frm.target = "listFrame";
	    frm.submit();
	}

	function tabMove(){

		$("#tabs").find(".selected").removeClass("selected");
			<% if (StringUtils.isEmpty(tabSet)){%>
					 $(".tab").find("a:first").trigger("click").addClass("selected");
			<%}else {	%>
				$("#<%=tabSet%>").addClass("selected");
			 <%}%>



	 	<%
	 	//for(int id = 0 ; id <= tetSize ; id ++){//tetSize는 colum size가 들어가야 함. 현재 row size로 들어가서 오류남.
 	 	for(int id = 0 ; id < 6 ; id ++){ // 어학, 어학시험명, 기준점수, 전공 , 학위, 주재원 (6개
	 	%>
		 	cellMergeChk(document.all.langTable, 0, <%=id%>); //1행 처음 필드
	 	<%
	 		}
	 	%>
	 	parent.switchScreen1();
	}



	function moveURL(idName, gubun){
		var aform = document.form1;
	    aform.command.value = gubun;
	    aform.tabSet.value = idName;
	    aform.targetpage.value = "";
	    aform.I_ITEM.value="<%=F_ITEM%>";
    	aform.I_ITEMTXT.value="<%=I_ITEMTXT%>";
		aform.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.languageprsn.LanguagePrsnSV";
		parent.switchScreen();
        aform.target = "listFrame";
        aform.submit();
	}

	function go_prev(){
	   history.back();
	}
    $(function() {
    	tabMove();
    });

</script>


 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="always" value="true"/>
     <jsp:param name="click" value="Y"/>
</jsp:include>
<form name="form1" method="post">
<input type="hidden" name="command"   value="<%=sCommand %>">
<input type="hidden" name="targetpage"   value="">
<input type="hidden" name="chck_yeno"   value="<%=chck_sub %>">
<input type="hidden" name="ichck_yeno"   value="<%=ichck_yeno %>">
<input type="hidden" name="chck_sub"   value="<%=chck_sub %>">
<input type="hidden" name="I_ORGEH"  value="<%=deptId%>">
<input type="hidden" name="I_ITEM"   value="<%=I_ITEM %>">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm %>">
<input type="hidden" name="orgcode"   value="">
<input type="hidden" name="deptnm"   value="">
<input type="hidden" name="gubun"   value="">
<input type="hidden" name="I_ITEMTXT"  value="<%=I_ITEMTXT %>">
<input type="hidden" name="viewGubun"   value="LA">
<input type="hidden" name="tabSet"  value="<%=tabSet%>">
<input type="hidden" name="callPrevbtn" value="<%=callPrevbtn %>">
<input type="hidden" name="sMenuText"   value="<%=sMenuText %>">
<input type="hidden" name="sMenuCode"  value="<%=sMenuCode%>">
<input type="hidden" name="tabName"   value="<%=tabName %>">


		<div id = "tabs" class="tabArea">
			<ul class="tab">
				<li><a id= "0"  href="javascript:;" class="selected"  onclick="moveURL('0','PIS0040')"><spring:message code="LABEL.N.N02.0009" /><!-- 영어 우수자 --></a></li>
				<li><a id= "1"  href="javascript:;"  onclick="moveURL('1','PIS0041')"><spring:message code="LABEL.N.N02.0010" /><!-- 중국어 우수자 --></a></li>
				<li><a id= "2"  href="javascript:;"  onclick="moveURL('2','PIS0042')"><spring:message code="LABEL.N.N02.0011" /><!-- 특수언어 우수자 --></a></li>
			</ul>
		</div>

	<!-- TAB sub menu START -->
			<div class="tabArea">
			<ul class="tab">
<%
	String allClass = "";
	if(I_ITEM.equals("")){
		allClass = "selected";
	}
%>
			<li ><a href="javascript:;"  onclick="sendURL('0','','전체')" id="sub0" class="<%=allClass %>" ><spring:message code="LABEL.N.N02.0012" /><!-- 전체 --></a></li>
<%

	for(int h=0; h < itemSize ; h ++){
		T_EXPORT = (HashMap)itemVT.get(h);
		 String  CODE = T_EXPORT.get("CODE");

		 String  TEXT = T_EXPORT.get("TEXT");
		 String classCode ="";
		 if(CODE.equals(I_ITEM)){
			 classCode = "selected";
		 }
%>
				<li ><a href="javascript:;"  onclick="sendURL('<%=h+1 %>','<%=CODE %>','<%=TEXT %>')"  id="sub<%=h+1 %>" class="<%=classCode %>" ><%=TEXT %></a></li>
<%} %>
</ul>
	<div class="clear"> </div>
</div>
	<h2 class="subtitle"><spring:message code="LABEL.N.N02.0004" /><!-- 부서명 --> :<%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>

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
				<thead>
				<tr>
							<th ><spring:message code="LABEL.N.N02.0007" /><!-- 구분 --></th>
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
							<th width="60" class=<%=j==8 ? "lastCol" :"" %>><%=COUNT %></th>

<%       		}
				}else{
					if(!GUBUN.equals("")){
%>
                           	<%if(j == 0){ %>
                           	<tr class="<%=qlSize-1 == h ? "td12" : WebUtil.printOddRow(h) %>">
										<%if(CODTX.equals("합계")){ %>
                           	<td class="td11"><%= CODTX %></td>
                           				<%}else{ %>
                           	<td class="colTitle"><a href="javascript:setUnderDeptID('<%=ZCODE %>','<%=DEPTNM %>');"><%= CODTX %></a></td>
                           				<%}} %>
							<td  class=<%=j==8 ? "lastCol" :"" %>>
							<% if( COUNT.equals("0")){ %>
								<%=COUNT %>
							<%}else{ %>
							<a href="javascript:goDetail('<%=deptId%>','<%=ZCODE %>','<%= CODTX %>','<%= GUBUN%>','<%=DEPTNM %>','<%=sCommand %>','<%=I_ITEM %>');"><%=WebUtil.printNumFormat(COUNT) %></a>
							<%} %>
							</td>

<%				}
				}
		}

	    %>
  <%
  		if(h == 0){
		%>
		</thead>
		<%
	}
	}
%>
				</table>
		</div>
	</div>

	<!-- * 어학 우수인재 선정기준  -->
	<h2 class="subtitle"><spring:message code="LABEL.N.N02.0013" /><!-- 어학 우수 선정기준 --></h2>

	<div class="listArea">
		<div class="table">
			<table class="listTable" id="langTable">
			<thead>
				<tr>
<%


	for(int t=0; t < tetSize ; t ++){
		 T_TEXT = (HashMap)stextVT.get(t);
	     String  CODTX = T_TEXT.get("CODTX");
		if(t ==0){
%>

						<th ><%=CODTX %></th>

		<%}else{ %>
				<tr class="borderRow"><td><%=CODTX %></td>
		<%} %>
<%
	     for( int k =0 ; k < 10 	; k++){
				String idx ="";
				if(k < 9){
					idx = "0"+(k+1);
				}else{
					idx =""+(k+1);
				}
				String SUBTY =  T_TEXT.get("SUBTY"+idx);
				String SUBTX =  T_TEXT.get("SUBTX"+idx);
				String TEXT =  T_TEXT.get("TEXT"+idx);
	     		if(t == 0){
					if(!SUBTY.equals("")){
						if(TEXT.equals("")){
%>
							<th  class=<%=k==4 ? "lastCol" :"" %>><%=SUBTX %></th>
						<%}else{ %>

							<th width="90"><%=TEXT %></th>

<%       				}
					}
				}else{
					if(!SUBTY.equals("")){
%>
                           	<td  class=<%=k==4? "lastCol" :"" %>><%= TEXT %></td>

<%				}
				}
		}

	    %>
  <%
  		if(t == 0){
		%>
		</thead>
		<%
	}
	}
%>
			</table>
		</div>
	</div>
	<!-- 어학 우수인재 선정기준  끝 -->

</div><!-- /subWrapper -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->