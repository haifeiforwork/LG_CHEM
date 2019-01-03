<%/******************************************************************************/
/*   Update      :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건  */
/*   				   2017/12/07 cykim [CSR ID:3551070] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 */

/********************************************************************************/%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="hris.N.EHRCommonUtil"%>
<%@ page import="hris.N.AES.AESgenerUtil"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%

    // 웹로그 메뉴 코드명
    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));



	//선택된 조직 이름
	String orgName= WebUtil.nvl(request.getParameter("I_ORGEHTX"));
	String I_ORGEH = WebUtil.nvl((String)request.getParameter("I_ORGEH"));
	String UP_ORGEH = WebUtil.nvl((String)request.getParameter("UP_ORGEH"));
	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	String E_UPORG ="";
	Vector orgVT = new Vector();


	int qlSize = 0;
;

	String ORGTX ="";
	if(qlHM != null){
		orgVT = (Vector)qlHM.get("T_RESULT");
		qlSize = orgVT.size();

		E_UPORG = WebUtil.nvl((String) qlHM.get("E_UPORG"));
	}
	if(ORGTX.equals("")){
		ORGTX = orgName;
	}

	HashMap<String, String> qlhm = new HashMap<String, String>();
	//
%>

<jsp:include page="/include/header.jsp"/>
	<script type="text/javascript">

		//document.body.scrollTop = 0;
		function popup(theURL,winName,features) {
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




		function popupView(pernr) {
		  var formN = document.viewForm;

		  formN.viewEmpno.value = pernr;
		  var screenwidth = (screen.width-1024)/2;
		  var screenheight = (screen.height-700)/2;
		  var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?ViewOrg=Y&sMenuCode=<%=sMenuCode%>&viewEmpno="+pernr;
		  var retData = showModalDialog(theURL,"orgView", "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:1024px;dialogHeight:700px");


		  //var winitem = 'height='+height+',width='+width+',top='+screenheight+',left='+screenwidth+',scrollbars=yes';
		  //window.open(theURL,winName,winitem);
		}


		function serarchNode(topOrg, deptId, deptNm) {
			 parent.orgList.node(topOrg, deptNm);
			 parent.orgList.fol(deptId, deptNm);
		}


		function init(){
			/*switchScreen1();*/
			<%if(!I_ORGEH.equals("")){ %>
			<%--parent.orgList.selectIMG('<%=I_ORGEH%>'); ?? 알수 없음--%>
			parent.orgList.selectOrg = <%=I_ORGEH%>;
			<%}%>
		}

		function switchScreen() {

		    document.getElementById("divLoading").style.display = "";
		    document.getElementById("divBody").style.display = "none";
		}
		function switchScreen1() {

		    document.getElementById("divLoading").style.display = "none";
		    document.getElementById("divBody").style.display = "";

		}
	</script>

<body id="subBody"  onload="init()" class="organBody" style="overflow-x: hidden; margin-bottom:0; height: 430px;" >
<form name="viewForm" method="post">
<input type="hidden" name="viewEmpno" value="">
<input type="hidden" name="ViewOrg" value="Y">
<input type="hidden" name="sMenuCode" value="<%=sMenuCode %>">
<%--<div id="divLoading" style="position:absolute; top:35%; left:0; width:100%; text-align:center; margin:0 auto;">
    &lt;%&ndash;<img src="<%=WebUtil.ImageURL %>download.gif" alt="잠시만 기다려 주세요. 로딩중입니다." />&ndash;%&gt;
	<img src="<%=WebUtil.ImageURL %>viewLoading.gif" alt="<spring:message code="MSG.COMMON.WAIT"/>">
</div>--%>

<div id="divBody" <%--style="display:none;"--%>>

<div style="padding:20px 0 30px 15px;">
	<div class="">
		<div class="organTreeWrap"><div class="imgBg">

			<div class="innerWrap">
<%
     String topOrg ="";
	 if(qlSize > 0  ){

		for(int k = 0 ; k < qlSize ; k++){
		qlhm = (HashMap)orgVT.get(k);
		//
		String PERNR =  AESgenerUtil.encryptAES(qlhm.get("PERNR"),request);
		String ENAME = qlhm.get("ENAME");
		String STEXT = qlhm.get("ORGTX");
		String TITL2 = qlhm.get("JIKKT");
		String TITEL = qlhm.get("JIKWT");
		String STLTX = qlhm.get("STLTX");
		String BTEXT = qlhm.get("BTEXT");
		String HIRDT = qlhm.get("HIRDT");//자사입사일
		String UPDAT = WebUtil.printDate(qlhm.get("DAT03"));//현직위승진일
		String ORGEH = qlhm.get("ORGEH");
		String URI = qlhm.get("PHOTO");
		String ENTDT = WebUtil.printDate(qlhm.get("DAT01"));//그룹입사일자
		String JIKK_TEXT =  qlhm.get("JIKK_TEXT");

		String CHIEF = qlhm.get("CHIEF");

		if( k ==0){

			if(CHIEF.equals("X")){ //장이면 view
			topOrg = ORGEH;
			 %>
			<div class="organ_1">
				<div class="picWrap">
					<%	if(StringUtils.isBlank(URI)) { %>
					<div class="frame"></div>
					<%	} %>
					<img src="<%= URI %>" alt="<spring:message code="LABEL.PICTURE"/> <%--사진--%>" />
				</div>
				<a href="javascript:popupView('<%= PERNR%>')"  class="btn unloading"><span class="textPink"><spring:message code="MSG.A.MSS.CARD.VIEW"/><%--인사기록보기--%></span></a>
				<%--CSR ID:3551070] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 start--%>
				<h4 style="line-height: 18px; width:230px; word-break:normal"><%=ENAME %><br><%=TITL2 %></h4>
				<%--CSR ID:3551070] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 end--%>
				<ul>
					<li><span style="float:left;display:block;"><spring:message code="MSG.A.A01.0006"/><%--소속--%> :</span>
					 <%if(E_UPORG.equals("00000000")){ %>
					 <span style="display:block;float:left;width:115px;color:#d7335e;font-size:11px;"><%=STEXT %></span>
					 <%}else{ %>
					 <a href="javascript:serarchNode('<%=E_UPORG %>','<%=E_UPORG %>','<%=STEXT %>')" style="display:block;float:left;width:115px;color:#d7335e;font-size:11px;"><%=STEXT %></a>
					 <%} %>
					 <div class="clear"></div></li>
					<li><spring:message code="MSG.A.A01.0013"/><%--직무--%> : <%=STLTX %></li>
					<li>
		            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                    <%--<spring:message code="MSG.A.A01.0007"/> --%>
                    <spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 -->
                     <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
					: <%=TITEL %></li>
					<li><spring:message code="MSG.A.A01.0017"/><%--현직위승진--%> : <%=UPDAT %></li>
					<li><spring:message code="MSG.A.A01.0011"/><%--그룹 입사일--%> : <%=ENTDT %></li>
				</ul>
				</ul>
			 </div>
			 <%
			 }else{
			 %>

			 <div class="organ_1">
				<div class="picWrap">

				</div>

			 </div>
			  <!-- 직원박스 시작 -->

			 <div class="organ_2">
				<div class="picWrap">
					<%	if(StringUtils.isBlank(URI)) { %>
					<div class="frame"></div>
					<%	} %>
					<img src="<%= URI %>" alt="<spring:message code="LABEL.PICTURE"/> <%--사진--%>" />
				</div>
				<a href="javascript:popupView('<%= PERNR%>')" class="btn"><span class="unloading textPink"><spring:message code="MSG.A.MSS.CARD.VIEW"/><%--인사기록보기--%></span></a>
				<%--CSR ID:3551070] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 start--%>
				<h4 style="line-height: 18px; width:230px; word-break:normal"><%=ENAME %><br><%=TITL2 %></h4>
				<%--CSR ID:3551070] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 end--%>
				<ul>
					<li><span style="float:left;display:block;"><spring:message code="MSG.A.A01.0006"/><%--소속--%> :</span> <a href="javascript:serarchNode('<%=topOrg %>','<%=ORGEH %>','<%=STEXT %>')" style="display:block;float:left;width:115px;color:#d7335e;font-size:11px;"><%=STEXT %></a><div class="clear"></div></li>
					<li><spring:message code="MSG.A.A01.0013"/><%--직무--%> : <%=STLTX %></li>
					<li>
		            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                    <%--<spring:message code="MSG.A.A01.0007"/> --%>
                    <spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 -->
                     <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>

					: <%=TITEL %></li>
					<li><spring:message code="MSG.A.A01.0017"/><%--현직위승진--%> : <%=UPDAT %></li>
					<li><spring:message code="MSG.A.A01.0011"/><%--그룹 입사일--%> : <%=ENTDT %></li>
				</ul>
			</div>

			 <%
			 }
			%>


<%   }else{ %>
			 <!-- 직원박스 시작 -->

			 <div class="organ_2">
				<div class="picWrap">
					<%	if(StringUtils.isBlank(URI)) { %>
					<div class="frame"></div>
					<%	} %>
					<img src="<%= URI %>" alt="<spring:message code="LABEL.PICTURE"/> <%--사진--%>" />
				</div>
				<a href="javascript:popupView('<%= PERNR%>')" class="btn"><span class="unloading textPink"><spring:message code="MSG.A.MSS.CARD.VIEW"/><%--인사기록보기--%></span></a>
				<%--CSR ID:3551070] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 start--%>
				<h4 style="line-height: 18px; width:230px; word-break:normal;"><%=ENAME %><br><%=TITL2%></h4>
				<%--CSR ID:3551070] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 end--%>
				<ul>
					<li><span style="float:left;display:block;"><spring:message code="MSG.A.A01.0006"/><%--소속--%> :</span> <a href="javascript:serarchNode('<%=topOrg %>','<%=ORGEH %>','<%=STEXT %>')" style="display:block;float:left;width:115px;color:#d7335e;font-size:11px;"><%=STEXT %></a><div class="clear"></div></li>
					<li><spring:message code="MSG.A.A01.0013"/><%--직무--%> : <%=STLTX %></li>
					<li>
				    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                    <%--<spring:message code="MSG.A.A01.0007"/> --%>
                    <spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 -->
                     <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
					: <%=TITEL %>
					</li>
					<li><spring:message code="MSG.A.A01.0017"/><%--현직위승진--%> : <%=UPDAT %></li>
					<li><spring:message code="MSG.A.A01.0011"/><%--그룹 입사일--%> : <%=ENTDT %></li>
				</ul>
			</div>
<%	}
	}
 }
		 %>
		 <div class="clear"></div>
		</div>


			</div>
		</div><!-- /organTreeWrap -->

	</div><!-- /organContentWrapper -->
</div><!-- /subWrapper -->

</div>
</form>
<iframe name='hiddenFrame' id='hiddenFrame' src="" width='0' height='0' frameborder='0' marginwidth='0' marginheight='0'  ></iframe>
</body>

<jsp:include page="/include/footer.jsp"/>