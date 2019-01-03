<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="hris.N.EHRCommonUtil"%>
<%@ page import="hris.N.AES.AESgenerUtil"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%

	//선택된 조직 이름
	String orgName= WebUtil.nvl(request.getParameter("I_ORGEHTX"));
	String I_ORGEH= WebUtil.nvl(request.getParameter("I_ORGEH"));
	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	Vector qlVT = new Vector();
	Vector spVT = new Vector();
	Vector listVT = new Vector();
	HashMap<String, String> exportField = new HashMap<String, String>();
	int qlSize = 0;
	int spSize = 0;
	int listSize = 0;

	String ORGTX ="";
	String ePERNR = "";
	String RETURN ="";
	String POINT = "";

	if(qlHM != null){
		qlVT = (Vector)qlHM.get("T_QK"); //검색조건 List
		qlSize = qlVT.size();

		spVT = (Vector)qlHM.get("T_SP");
		spSize = spVT.size();

		listVT = (Vector)qlHM.get("T_LIST");


		listSize = listVT.size();
		exportField = (HashMap)qlHM.get("EXPORT_FIELD");

		if(exportField != null) {
			ORGTX = exportField.get("E_ORGTX");
			ePERNR = exportField.get("E_PERNR");
			RETURN = (String) qlHM.get("E_RETURN");
			POINT = exportField.get("E_POINT");
		}

	}

	if(ORGTX.equals("")){
		ORGTX = orgName;
	}
    ePERNR =  AESgenerUtil.encryptAES(ePERNR, request); //암호화를 위해
	//Vector qlVT = (Vector)qlHM.get("T_QK");

	//

%>


<jsp:include page="/include/header.jsp"/>
	<script type="text/javascript">
	//document.body.scrollTop = 0;
		function popupback(theURL,winName,features, pernr) {
		  window.open(theURL+"?I_ORGEH=<%= I_ORGEH%>&searchPrsn="+pernr,winName,features);

		}

		function popup(pernr, gubun) {
		//var page="<%=WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendPTSV?I_ORGEH=<%=I_ORGEH%>&searchPrsn="+pernr;

		 var width=970;
         var height=630;
		 var screenwidth = (screen.width-width)/2;
         var screenheight =(screen.height-height)/2;
         //var features = 'height='+height+',width='+width+',top='+screenheight+',left='+screenwidth+',toolbar=no,status=no,menubar=no,location=no,scrollbars=yes';
         var retData = showModalDialog("<%=WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendPTSV?I_ORGEH=<%=I_ORGEH%>&searchPrsn="+pernr+"&command="+gubun, window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");
		 //window.open("","presentaion",features);
		 //document.form1.target = "presentaion";
		 document.form1.I_ORGEH.value = '<%= I_ORGEH%>';
		 document.form1.searchPrsn.value = pernr;
		 document.form1.submit();
		}

		function editPopup(theURL,winName,features, pernr) {
		  window.open(theURL,winName,features);
		}
		function tabMove() {
			document.all.area1Wrap.className="recoBsn_div2_hide";
			document.all.area2.className="recoBsn_div3_wide";
		}
		function tabShow() {
			document.all.area1Wrap.className="recoBsn_div2";
			document.all.area2.className="recoBsn_div3";
		}

		$(function() {
			parent.$.unblockUI();
		});

	</script>

<body id="subBody" oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
<form name="form1" method="post">
<input type="hidden" name="searchPrsn">
<input type="hidden" name="I_ORGEH">
<input type="hidden" name="I_ORGEHTX">
</form>
<div class="subFrameWrapper">

	<div class="contentBody">

		<div class="recoBsn_div2" id="area1Wrap">
			<div class="recoBsn_btn"><a href="javascript:tabMove();"><img src="<%= WebUtil.ImageURL %>ehr_common/btn_bsnm_hide.gif" alt="Hide" id="closeBtn" class="btnHide" /></a><a href="javascript:tabShow()"><img src="<%= WebUtil.ImageURL %>ehr_common/btn_bsnm_show.gif" alt="Show" id="openBtn" class="btnShow" /></a></div>

			<div class="recoB_area1" id="area1">
				<h2 class="subtitle"><spring:message code="LABEL.N.N01.0013" /><!-- Step 2. 검색 조건 확인 --></h2>
				<h4><spring:message code="LABEL.N.N01.0014" /><!-- 대상 Post --></h4>
				<div class="recoB_conditionT"><%if(RETURN.equals("S")){ %><a href="javascript:popup('<%= ePERNR%>','')"><%} %><%= ORGTX %></a><%if(RETURN.equals("S")){ %>&nbsp;<a href="javascript:popup('<%= ePERNR%>','G')">(<%=POINT %>)</a><%} %></div>
				<h4><spring:message code="LABEL.N.N01.0015" /><!-- 필수조건(And) --></h4>

					<!-- 테이블 시작 -->
					<div class="table">
					<table class="listTable"  style="margin-bottom:10px;">
						<caption></caption>
						<col /><col width="80" />
						<tbody>
							<tr>
								<th ><spring:message code="LABEL.N.N01.0016" /><!-- 구분 --></th>
								<th class="lastCol"><spring:message code="LABEL.N.N01.0008" /><!-- 기준 --></th>
							</tr>
<%
 if(qlSize > 0 ){
	 HashMap<String, String> qlhm = new HashMap<String, String>();

	 for(int k = 0 ; k < qlSize ; k++){
		 qlhm = (HashMap)qlVT.get(k);
		 String OPTIO = qlhm.get("OPTIO");
		 if(OPTIO.equals("1")){
			 String QK_ITEM_TX = qlhm.get("QK_ITEM_TX");
			 String GUBUN_TX = qlhm.get("GUBUN_TX");
%>
							<tr>
								<td><%= QK_ITEM_TX%></td>
								<td class="lastCol"><%= GUBUN_TX %></td>
							</tr>
<%	}
	}
 }
	 %>


						</tbody>
					</table>
					</div>
					<!-- 테이블 끝 -->

					<!-- div class="recoB_plus">+</div> -->
					<!-- 테이블 시작 -->
					<h4><spring:message code="LABEL.N.N01.0017" /><!-- 추가조건(Or) --></h4>
					<div class="table">
					<table class="listTable" summary="" >
						<caption></caption>
						<col /><col width="80" />
						<tbody>
							<tr>
								<th ><spring:message code="LABEL.N.N01.0016" /><!-- 구분 --></th>
								<th class="lastCol"><spring:message code="LABEL.N.N01.0008" /><!-- 기준 --></th>
							</tr>
<%
 if(qlSize > 0 ){
	 HashMap<String, String> qlhm2 = new HashMap<String, String>();

	 for(int k = 0 ; k < qlSize ; k++){
		 qlhm2 = (HashMap)qlVT.get(k);

		 String OPTIO2 = qlhm2.get("OPTIO");
		 if(OPTIO2.equals("2")){
			 String QK_ITEM_TX2 = qlhm2.get("QK_ITEM_TX");
			 String GUBUN_TX2 = qlhm2.get("GUBUN_TX");
%>
							<tr>
								<td><%= QK_ITEM_TX2%></td>
								<td class="lastCol"><%= GUBUN_TX2 %></td>
							</tr>
<%	}
	}
 }
	 %>
						</tbody>
					</table>
					</div>
					<!-- 테이블 끝 -->
					<div class="buttonArea">
						<ul class="btn_crud">
							<li><a href="javascript:editPopup('<%=WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendListSV?command=EDIT&I_ORGEH=<%=I_ORGEH %>','','scrollbars=yes,width=600,height=500')"><span><spring:message code="LABEL.N.N01.0018" /><!-- 조건수정 --></span></a></li>
						</ul>
					</div>

			</div>
		</div>

		<div class="recoBsn_div3" id="area2" >
			<h2 class="subtitle"><spring:message code="LABEL.N.N01.0019" /><!-- Step 3. S/P 현황 확인 --></h2>

			<!-- 테이블 시작 -->
			<div class="table">
			<table class="listTable" summary="" >
				<caption></caption>
				<%--<col width="30" /><col  /><col width="60" /><col width="75" /><col width="55" /><col width="20" /><col width="20" /><col width="20" /><col width="25" />--%>
				<thead>
					<tr>
						<th><spring:message code="LABEL.N.N01.0020" /><!-- 순위 --></th>
						<th><spring:message code="LABEL.N.N01.0021" /><!-- 소속 --></th>
						<th><spring:message code="LABEL.N.N01.0022" /><!-- 성명 --></th>
						<th><%-- //[CSR ID:3456352]<spring:message code="LABEL.N.N01.0023" /><!-- 직위/연차 --> --%>
						<spring:message code="LABEL.N.N01.0094" />/<spring:message code="LABEL.N.N02.0027" /><!-- 직위/직급호칭/연차 -->
						</th>
						<th><spring:message code="LABEL.N.N01.0024" /><!-- 직책 --></th>
						<th><spring:message code="LABEL.N.N01.0025" /><!-- 14 --></th>
						<th><spring:message code="LABEL.N.N01.0026" /><!-- 13 --></th>
						<th><spring:message code="LABEL.N.N01.0027" /><!-- 12 --></th>
						<th class="lastCol"><spring:message code="LABEL.N.N01.0028" /><!-- LAP --></th>
					</tr>
				</thead>
				<tbody>
<%


if(spSize > 0 ){
	 HashMap<String, String> sphm = new HashMap<String, String>();

	 for(int k = 0 ; k < spSize ; k++){
		 sphm = (HashMap)spVT.get(k);
		 String RANK = sphm.get("ORANK");
		 String STEXT = sphm.get("STEXT");
		 String ENAME = sphm.get("ENAME");
		 String TITEL = sphm.get("TITEL");
		 String TITLE_YEAR = EHRCommonUtil.reIntString(sphm.get("TITLE_YEAR"));
		 String TITL2 = sphm.get("TITL2");
		 String PERS_APP1 = sphm.get("PERS_APP1");
		 String PERS_APP2 = sphm.get("PERS_APP2");
		 String PERS_APP3 = sphm.get("PERS_APP3");
		 String LGAX_SCOR =  sphm.get("LGAX_SCOR");
		 String PERNR =  AESgenerUtil.encryptAES(sphm.get("PERNR"), request);
		 String VFLAG =  WebUtil.nvl(sphm.get("VFLAG")); // N이면
		 String sPOINT = sphm.get("POINT");

         String tr_class = "";

         if(k%2 == 0){
             tr_class="oddRow";
         }else{
             tr_class="";
         }
%>
					<tr class="oddRow">
						<td><%=RANK %></td>
						<td class="left"><%=STEXT %></td>
						<td><a href="javascript:popup('<%= PERNR%>','<%= VFLAG%>')"><%=ENAME %></a><br><a href="javascript:popup('<%= PERNR%>','G')">(<%=sPOINT %>)</a></td>
						<td><%=TITEL %>/<%=TITLE_YEAR %></td>
						<td><%=TITL2 %></td>
						<td><%=PERS_APP1 %></td>
						<td><%=PERS_APP2 %></td>
						<td><%=PERS_APP3 %></td>
						<td class="lastCol"><%=LGAX_SCOR %></td>
					</tr>
<% }

	 }%>

				</tbody>
			</table>
			</div>
			<!-- 테이블 끝 -->


			<h2 class="subtitle"><spring:message code="LABEL.N.N01.0029" /><!-- Step 4. Post別 적합 후보자 확인 --></h2>

			<!-- 테이블 시작 -->
			<div class="table">
			<table class="listTable" summary="" >
				<caption></caption>
				<%--<col width="30" /><col  /><col width="60" /><col width="75" /><col width="55" /><col width="20" /><col width="20" /><col width="20" /><col width="25" />--%>
				<thead>
					<tr>
						<th><spring:message code="LABEL.N.N01.0020" /><!-- 순위 --></th>
						<th><spring:message code="LABEL.N.N01.0021" /><!-- 소속 --></th>
						<th><spring:message code="LABEL.N.N01.0022" /><!-- 성명 --></th>
						<th><%-- //[CSR ID:3456352]<spring:message code="LABEL.N.N01.0023" /><!-- 직위/연차 --> --%>
						<spring:message code="LABEL.N.N01.0094" />/<spring:message code="LABEL.N.N02.0027" /><!-- 직위/직급호칭/연차 -->
						</th>
						<th><spring:message code="LABEL.N.N01.0024" /><!-- 직책 --></th>
						<th><spring:message code="LABEL.N.N01.0025" /><!-- 14 --></th>
						<th><spring:message code="LABEL.N.N01.0026" /><!-- 13 --></th>
						<th><spring:message code="LABEL.N.N01.0027" /><!-- 12 --></th>
						<th class="lastCol"><spring:message code="LABEL.N.N01.0028" /><!-- LAP --></th>
					</tr>
				</thead>
				<tbody>
<%


if(listSize > 0 ){
	 HashMap<String, String> listhm = new HashMap<String, String>();

	 for(int k = 0 ; k < listSize ; k++){
		 listhm = (HashMap)listVT.get(k);
		 String RANK = listhm.get("RANK");
		 String STEXT = listhm.get("STEXT");
		 String ENAME = listhm.get("ENAME");
		 String TITEL = listhm.get("TITEL");
		 String TITLE_YEAR = EHRCommonUtil.reIntString(listhm.get("TITLE_YEAR"));
		 String TITL2 = listhm.get("TITL2");
		 String PERS_APP1 = listhm.get("PERS_APP1");
		 String PERS_APP2 = listhm.get("PERS_APP2");
		 String PERS_APP3 = listhm.get("PERS_APP3");
		 String LGAX_SCOR =  listhm.get("LGAX_SCOR");
		 String PERNR =  AESgenerUtil.encryptAES(listhm.get("PERNR"), request);

		 int ind = 0;
		 ind = ENAME.indexOf("(");
		 String sENAME = ENAME.substring(0,ind);

		 String sPOINT = listhm.get("POINT");

         String tr_class = "";

         if(k%2 == 0){
             tr_class="oddRow";
         }else{
             tr_class="";
         }
%>
					<tr class="<%=tr_class%>">
						<td><%=RANK %></td>
						<td class="left"><%=STEXT %></td>
						<td><a href="javascript:popup('<%= PERNR%>','')"><%=sENAME %></a> <br><a href="javascript:popup('<%= PERNR%>','G')">(<%=sPOINT %>)</a></td>
						<td><%=TITEL %>/<%=TITLE_YEAR %></td>
						<td><%=TITL2 %></td>
						<td><%=PERS_APP1 %></td>
						<td><%=PERS_APP2 %></td>
						<td><%=PERS_APP3 %></td>
						<td class="lastCol"><%=LGAX_SCOR %></td>
					</tr>
<%	}
}
	 %>

				</tbody>
			</table>
			</div>
			<!-- 테이블 끝 -->


		</div>




	</div>
</div><!-- /subWrapper -->
</body>
<jsp:include page="/include/footer.jsp"/>