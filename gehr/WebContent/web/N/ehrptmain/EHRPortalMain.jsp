<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="com.sns.jdf.servlet.*"%>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>

<%@ page import="java.util.*" %>
<%@ page import="hris.common.*"%>

<%@ page import="hris.N.ehrptmain.*"%>
<%@ page import="hris.N.EHRComCRUDInterfaceRFC" %>
<%@ page import="hris.N.EHRCommonUtil" %>
<%@ page import=" lgcns.crypto.seed.SeedManager" %>
<%@include file="/include/includeCommon.jsp"%>

<%
	//[CSR ID:2953938] 개인 인사정보 확인기능 구축 및 반영의 件
	String InsaInfoYN = (String)request.getAttribute("InsaInfoYN");//인사정보 본인 확인버튼 확정 여부 Y : 메일발송&미확정, N : 확정완료

	//포털이미지 클릭하고 들어온 경우는 팝업을 안뜨게 제어
	String popUP =WebUtil.nvl(request.getParameter("popUP"));

	WebUserData user = WebUtil.getSessionUser(request);

	final String[] week = { "일", "월", "화", "수", "목", "금", "토" };
	Calendar oCalendar = Calendar.getInstance( );
	String curDay = week[oCalendar.get(Calendar.DAY_OF_WEEK) - 1];

	//사진 기본 URL  WebUtil.ImageURL main/pic_default.jpg
	Vector viewVT = (Vector)request.getAttribute("viewData");

	// 개인휴가
	ViewEmpVacationData empVacationData = (ViewEmpVacationData)((Vector)viewVT.get(2)).get(0);
	String sOCCUR  = WebUtil.printNumFormat(empVacationData.OCCUR,1);
	String sABWTG =  WebUtil.printNumFormat(empVacationData.ABWTG,1);
	double dOCCUR = Double.parseDouble(sOCCUR) ;
	double dABWTG = Double.parseDouble(sABWTG) ;
	double dPer =  dABWTG/dOCCUR *100;
	if(sOCCUR.equals("0.0") && sABWTG.equals("0.0")){
		 dPer =  0.0;
	 }
	 String vnctPer = WebUtil.printNumFormat(dPer,1);

	// 부서휴가 - structure없는 경우 발생
	String CONSUMRATE = "0.0";
	String OCCUR = "0.0";
	String ABWTG = "0.0";
	String ZKVRB = "0.0";

	String deptVctn = viewVT.get(3).toString();

	ViewDeptVacationData deptVacationData = new ViewDeptVacationData();

	if(!deptVctn.equals("[]")){

		deptVacationData = (ViewDeptVacationData)((Vector)viewVT.get(3)).get(0);
		CONSUMRATE = WebUtil.printNumFormat(deptVacationData.CONSUMRATE,1);
		OCCUR =  WebUtil.printNumFormat(deptVacationData.OCCUR,1);
		ABWTG =  WebUtil.printNumFormat(deptVacationData.ABWTG,1);
		ZKVRB =  WebUtil.printNumFormat(deptVacationData.ZKVRB,1);

	}

	//월평균 초과근무시간
    Vector otvt = (Vector) request.getAttribute("otData");

	OverTimeData bData =(OverTimeData)otvt.get(0);
	String bDay = bData.MONTH;
	String bS = bData.ANZHL;
	OverTimeData cData =(OverTimeData)otvt.get(1);
	String cDay = cData.MONTH;
	String cS = cData.ANZHL;
	OverTimeData ovData =(OverTimeData)otvt.get(2);
	String pnInfo = ovData.INNDE;

	//퀵메뉴
	HashMap quickVT = (HashMap)request.getAttribute("qmVTData");

	//초기 팝업 화면
	HashMap initPop_hm = (HashMap)request.getAttribute("initPop_hm");
	 Vector vt = new Vector();
	if(initPop_hm != null){
		  vt = (Vector)initPop_hm.get("T_EXPORT");
	}


	int cSize = vt.size() ;
	HashMap<String, String> T_EXPORT = new HashMap<String, String>();

	// OBJID 로 구분한다.

	String partDisable = "";

	String sexGubun = user.e_regno;

	sexGubun = sexGubun.substring(6,7);

	String YNcheck = "M";
	if(sexGubun.equals("2") || sexGubun.equals("4")){ //여자
		YNcheck = "F";
	}



 	Vector titleVT = (Vector)quickVT.get("T_TITLE");
 	int tSize = 0 ;
	if(titleVT != null){
		tSize = titleVT.size();

	}
	if(tSize == 0 ){
		partDisable = "optShow";
	}

	//우먼라우지 체크 여부  : 예외자 추가
	// return 값이 S일경우만  우먼라우지 display
	 EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
     String functionName = "ZHRA_RFC_CHECK_WLOUNGE";
     Box box = new Box("woman");
     box.put("I_PERNR",user.empNo);
     HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"RETURN");
     String sReturn = EHRCommonUtil.nullToEmpty((String)resultVT.get("RETURN"));
     if(sReturn.equals("")){
    	 sReturn ="E";
     }

%>


<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=9" />
	<title>LG화학 e-HR 시스템</title>
	<meta name="description" content="LG화학 e-HR 시스템" />
	<link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>css/ehr_style.css" />
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src="<%= WebUtil.ImageURL %>js/jquery.bxslider.js"></script>
	<script type="text/javascript">

		$(document).ready(function(){

		$('.bxslider').bxSlider();

	    var iLeft  = 100;
	    var itop = 100;

		//[CSR ID:2953938] 개인 인사정보 확인기능 구축 및 반영의 件
	    if("<%=InsaInfoYN%>" == "Y"){
		        //alert("ggg");
		    	pop_window=window.open("<%= WebUtil.ServletURL%>hris.N.essperson.A01SelfDetailNeoSV?jobid=popup","","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=850,height=900,left=10,top=10");
		      	pop_window.focus();
		}

		<%
		if(popUP.equals("")){
				if(initPop_hm != null){

					for(int t = 0 ; t < cSize ; t++){

						 T_EXPORT = (HashMap)vt.get(t);
					     String sOBJID =  T_EXPORT.get("OBJID");

		%>

			if ( getCookie( "<%=sOBJID %>" ) != "done" ){

				pop_window<%=sOBJID%>=window.open("<%= WebUtil.ServletURL%>hris.N.notice.EHRNoticeSV?OBJID=<%=sOBJID%>","<%=sOBJID%>","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=720,height=600,left="+iLeft+",top="+itop);
		      	pop_window<%=sOBJID%>.focus();
		      	iLeft += iLeft;
			    itop += itop;
		    }
		<%
					}
				}
		}
		%>
		});


		function open_charge()
	    {
	      	small_window=window.open("<%= WebUtil.JspURL %>common/HRChargePop.jsp?I_BUKRS=<%= user.companyCode %>&I_GRUP_NUMB=<%= user.e_grup_numb %>","Charge","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=722,height=420,left=100,top=100");
	      	small_window.focus();
	    }


	    function getCookie( name ){
			var nameOfCookie = name + "=";
			var x = 0;
			while ( x <= document.cookie.length ) {
				var y = (x+nameOfCookie.length);
				if ( document.cookie.substring( x, y ) == nameOfCookie ) {
					if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 ) endOfCookie = document.cookie.length;
					   return unescape( document.cookie.substring( y, endOfCookie ) );
					}
				  x = document.cookie.indexOf( " ", x ) + 1;
				  if ( x == 0 ) break;
			 }
			 return "";
		}

		function popupP(theURL,width, height) {
		  // var width=850;
		  // var height = 750;
		   var screenwidth = (screen.width-width)/2;
           var screenheight = (screen.height-height)/2;

		  pop_window = window.open(theURL,"_newfin","width="+width+",height="+height+",toolbar=no,location=no,resizable=no,scrollbars=yes,top="+screenheight+",left="+screenwidth);
		  	pop_window.focus();
		}

		function popupLink(theURL, thePopname) {


		   var height = 868;
		   var screenwidth = 50;
           var screenheight = (screen.height-height)/2;

		   pop_window = window.open(theURL,thePopname,"height=868,width=1280,toolbar=yes,location=yes,resizable=yes,scrollbars=auto,top="+screenheight+",left="+screenwidth);
		   pop_window.focus();
		}
		
		//[CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청
		var exeMember = new Array(
				"00215019" 
				,"00037466" 
				,"00218588" 
				,"00030041" 
				,"00037567" 
				,"00217852" 
				,"00006882" 
				,"00117332" 
				,"00022778" 
				,"00201234" 
				,"00212710" 
				,"00043713" 
				,"00204291" 
				,"00111090" 
				,"00219561" 
				,"00038096" 
				,"00219341" 
				,"00080798" 
				,"00003913" 
				,"00037916" 
				,"00027108" 
				,"00005487" 
				,"00116534" 
				,"00203593" 
		);
		
		function exeDocOpen(){
			var flag;                        
		       for (r=0;r< exeMember.length;r++) {
		          if ("<%=user.empNo%>" == exeMember[r]) {
		              flag = "exeOpen";            
		          }                             
		       }	
		       if(flag == "exeOpen"){
		    	   role.style.display = "block";
		       }
		}
	</script>
</head>
Locale : <%=g.getSessionUser(request).locale %> &nbsp;&nbsp; SAP : <%=g.getSapType() %>
<br>msg : <spring:message code="test"/>
<%=g.getMessage("test")%>
<body id="mainBody" onload="javascript:exeDocOpen();">
<div class="mainWrapper">
	<div class="topArea">
		<div id="prsnInfo">
			<div class="picArea"><img src="<%=request.getAttribute("imgUrl")%>" alt="사진" /><div class="frame"></div></div>
			<div class="prsnTxt"><span class="name"><%= user.ename %>님 좋은 하루 되세요!</span><span class="date"><%= DateTime.getDateString() %>&nbsp;<%=curDay %>요일</span></div>
		</div>
		<div id="myData">
			<ul>
				<li class="vacaPrsn">
					<h3>개인휴가 <br /><span class="data">(<span class="num"><%=vnctPer %></span>%)</span></h3>
					<div class="icon"><img src="<%= WebUtil.ImageURL %>main/mydata_ico_01.png" alt="개인휴가 아이콘" /></div>
					<ul>
						<li>발생일수 <span class="num"><%= sOCCUR %></span></li>
						<li>사용일수 <span class="num"><%= sABWTG%></span></li>
						<li>잔여일수 <span class="numStr"><%= WebUtil.printNumFormat(empVacationData.ZKVRB,1) %></span></li>
					</ul>
				</li>
				<li class="vacaPart">
					<h3>부서평균휴가 <br /><span class="data">(<span class="num"><%= CONSUMRATE %></span>%)</span></h3>
					<div class="icon"><img src="<%= WebUtil.ImageURL %>main/mydata_ico_02.png" alt="부서휴가 아이콘" /></div>
					<ul>
						<li>발생일수 <span class="num"><%=OCCUR %></span></li>
						<li>사용일수 <span class="num"><%= ABWTG %></span></li>
						<li>잔여일수 <span class="numStr"><%= ZKVRB %></span></li>
					</ul>
				</li>
				<li class="monthlyOverTime">
				<%



				//
				if(user.e_authorization.indexOf("M") > -1){ %>
					<h3>부서 월평균<br />초과근무시간</h3>
				<%}else{ %>
					<h3>개인 월평균<br />초과근무시간</h3>
				<%} %>

					<div class="icon"><img src="<%= WebUtil.ImageURL %>main/mydata_ico_03.png" alt="초과근무시간 아이콘" /></div>
					<ul>
						<li><%=bDay %>월 <span class="num"><%=EHRCommonUtil.dotCheck(bS)%></span></li>
						<li><%=cDay %>월 <span class="num"><%=EHRCommonUtil.dotCheck(cS) %></span></li>
						<li>증감 <span class="numStr"><%=pnInfo %></span></li>
					</ul>
				</li>
			</ul>
		</div>
		<div id="mainVisual"><span><div class="grTxt"></div>
			<ul class="bxslider">
				<li><img src="<%= WebUtil.ImageURL %>main/rollimg/visual_01.png" alt="lg화학 ehr" /></li>
				<li><img src="<%= WebUtil.ImageURL %>main/rollimg/visual_02.png" alt="lg화학 ehr" /></li>
				<li><img src="<%= WebUtil.ImageURL %>main/rollimg/visual_03.png" alt="lg화학 ehr" /></li>
			</ul></span>
		</div>
	</div><!-- /topArea -->
	<hr class="clear" />

	<div id="information">
		 <h2>HR Information</h2>
		 <ul>
		 	<li class="hrSystem"><a href="<%= WebUtil.JspURL %>ruleLink.jsp" target="hidden" onClick="hideIMG('9996');this.blur();">제도안내</a></li>
<%
//사번 데이터 암호화
				SeedManager seedMgr = new SeedManager();
                String PA_PERNR =  seedMgr.encryptData(user.empNo);
                // 실제 운영 URL : String elurl ="http://eloffice.lgchem.com:8001/intra/owa/insarule_popup?p_user="+PA_PERNR;
				//개발 : http://eloffice.lgchem.com:8001/intra/owa/insarule?p_user="+PA_PERNR;
               //String elurl = "http://eloffice.lgchem.com:8001/intra/owa/insarule?p_user="+PA_PERNR;


               String elurl ="http://eloffice.lgchem.com:8001/intra/owa/insarule_popup?p_user="+PA_PERNR;
               //@URL
               //http://gportal.lgchem.com/portal/lgchemmenu/lgchemAppLink.do?app=HRQnA => 변경

%>
		 	<li class="hrQna"><a href="javascript:popupP('http://gportal.lgchem.com/portal/lgchemmenu/lgchemAppLink.do?app=HRQnA','850','750')" > Q&A</a></li>
		 	<li class="hrFaq"><a href="javascript:popupP('<%=WebUtil.ServletURL %>hris.N.ehrFAQ.EHRfaqSV?I_PFLAG=X','850','680')">FAQ</a></li>
		 	<li class="hrManager"><a href="#" onClick="open_charge();hideIMG('9997');this.blur();">인사 담당자</a></li>
<%if(user.e_persk.endsWith("11") || user.e_persk.endsWith("12") || user.e_persk.endsWith("13")){ %>
		 	<div id="role" style="display:none"><li  class="hrHrRule"><a href="javascript:popupP('<%=elurl %>')" >집행임원인사관리규정</a></li></div>
<%} %>
		</ul>
	</div>
	<hr class="clear" />

 	<div class="bottomArea">


	<div id="quickMenu_p" class="<%=partDisable %>">
		 <h2>Quick Menu <img src="<%= WebUtil.ImageURL %>main/div_p_ico1.gif" alt="개인" /><!-- span class="divP">개인</span --></h2>
		 <ul>
		 <%
			Vector perskVT = (Vector)quickVT.get("T_PERSK");

			int perSize = 0 ;
			if(perskVT != null){
				 perSize = perskVT.size();
			}
		   if(perSize > 0 ){
			 for(int i = 0 ; i < perSize ; i++){
				 QuickMenuData qData =(QuickMenuData)perskVT.get(i);
			 %>
		 	<li><a href="javascript:parent.left.openDoc('<%=qData.MENUCODE %>');parent.left.hideIMG('<%=qData.MENUCODE %>')"><%=qData.MENUNAME %></a></li>

		 <%}
		 }
		 %>
		</ul>
	</div>
<%

 	if(tSize > 0 ){

%>
	<div id="quickMenu_m">
		 <h2>Quick Menu <img src="<%= WebUtil.ImageURL %>main/div_m_ico1.gif" alt="조직책임자" /><!-- span class="divM">조직책임자</span --></h2>
		 <ul>
		<%
		   	if(tSize > 0 ){
			 for(int k = 0 ; k < tSize ; k++){
				 QuickMenuData tData =(QuickMenuData)titleVT.get(k);
			 %>
		 	<li><a href="javascript:parent.left.openDoc('<%=tData.MENUCODE %>');parent.left.hideIMG('<%=tData.MENUCODE %>')"><%=tData.MENUNAME %></a></li>
		 	<%}
		   	}
			 %>
		</ul>
	</div>
	<%
	} %>
	<div id="siteLinks">
		 <h2>Site Links</h2>
		 <ul <%if(sReturn.equals("E")){ %>class="sceneM" <%} %>>
		 	<li class="trInstitute"><a href="javascript:popupLink('http://intra.lgchem.com:6103/jsp/adminNewFrm.jsp','tr')" ><span>생활연수원<br />/곤지암/강촌</span></a></li>
		 	<li class="selWelfare"><a href="javascript:popupLink('http://gportal.lgchem.com/portal/lgchemmenu/lgchemAppLink.do?app=lifecare','lifecare')" ><span>선택적복리후생</span></a></li>
		 	<!-- /ikep-webapp/portal/main/portalVirtualModuleMenu.do?moduleId=workingWC
		 	http://gportal.lgchem.com/portal/main/portalVirtualModuleMenu.do?moduleId=workingWC
		 	-->
		 	<li class="wWcenter"><a href="javascript:popupLink('http://gportal.lgchem.com/portal/main/portalVirtualModuleMenu.do?moduleId=workingWC&isTop=1','workingWC')" ><span>우먼라운지</span></a></li>
		</ul>
	</div>
	</div><!-- /bottomArea -->
	<hr class="clear" />
	<div id="pageFooter">
		(C) Copyright 2015 by LG Chem. All Rights reserved.
	</div><!-- /#pageFooter -->
</div><!-- /mainWrapper -->
</body>
</html>