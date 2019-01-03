<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 임원 profile 조회  (임원용)                                          */
/*   Program Name : 임원 profile 조회   (임원용)                                         */
/*   Program ID   : A22ExecutiveProfilePrint.jsp                                         */
/*   Description  : 임원 profile 조회                                              */
/*   Note         :                                                             */
/*   Creation     : 2016-03-09    [CSR ID:3089281] 임원 1Page 프로파일 시스템 개발 요청의 건.                                                         */
/*   Update       : 2017-09-08   [CSR ID:3460886] 임원 프로파일 시스템 수정 요청의 건.                     */
/*                   : 2017-10-19   [CSR ID:3509208] 임원 프로파일 시스템 글자 선명화 요청                  */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
	WebUserData user_m = WebUtil.getSessionMSSUser(request);
	WebUserData user = WebUtil.getSessionUser(request);

	Vector<A22resultOfProfileData> a22StrengthData_vt    = (Vector)request.getAttribute("a22StrengthData_vt");     // 성과:text
	Vector<A22resultOfProfileData> a22LeadershipData_vt    = (Vector)request.getAttribute("a22LeadershipData_vt");     //리더십:text

	Vector<A22resultOfProfileData> a22busi_vt    = (Vector)request.getAttribute("a22busi_vt");     //사업가후보
	Vector<A22resultOfProfileData> a22punish_vt    = (Vector)request.getAttribute("a22punish_vt");     //징계
	Vector<A22resultOfProfileData> a22edu_vt    = (Vector)request.getAttribute("a22edu_vt");     //교육이력
	Vector<A22resultOfProfileData> a22role_vt    = (Vector)request.getAttribute("a22role_vt");     //역할급
//	Vector a22career_vt    = (Vector)request.getAttribute("a22career_vt");     //직위
	Vector<A22resultOfProfileData> a22career_vt    = (Vector)request.getAttribute("actionList");     //직위

	Vector<A22resultOfProfileData> a22school_vt    = (Vector)request.getAttribute("a22school_vt");     //학력
	Vector<A22resultOfProfileData> a22language_vt    = (Vector)request.getAttribute("a22language_vt");     //어학
	Vector<A22resultOfProfileData> a22Info_vt    = (Vector)request.getAttribute("a22Info_vt");     //인사기본정보

	Vector<A22resultOfProfileData> sPlanList = (Vector) request.getAttribute("sPlanList");
	Vector<A22resultOfProfileData> sPlanListPost = (Vector) request.getAttribute("sPlanListPost");//[CSR ID:3460886]SuccessPlan 현Post

	String imwonAge = (String)request.getAttribute("imwonAge");
	String geunsokAge = (String)request.getAttribute("geunsokAge");

	//String imgUrl = (String)request.getAttribute("imgUrl");
	Double age = 0.00;

	A22resultOfProfileData data   = new A22resultOfProfileData();
	if (Utils.getSize(a22Info_vt) > 0 ) {
		data = a22Info_vt.get(0);
	}

	//화상조직도에서  조회하는 화면일 경우 처리 2015-06-18
	//String ViewOrg = WebUtil.nvl(request.getParameter("ViewOrg"));
	//int row_num = 21;//직위/직책 line 수
	int row_num = 10;//직위/직책 line 수

	//@rdcamel
	Vector a22resultOfThreeYear_vt   = (Vector)request.getAttribute("a22resultOfThreeYear_vt");    // 3개년 평가:성과/리더십
	//A22resultOfProfileData data = new A22resultOfProfileData();
	String l1 = "";
	String l2 = "";
	String l3 = "";
	String ap1 = "";
	String ap2 = "";
	String ap3 = "";
	String year = "";
	String year_1="";
	String year_2="";
	String m1 = "";
	String m2 = "";
	String m3 = "";

	if (Utils.getSize(a22resultOfThreeYear_vt) > 0 ) {
		A22resultOfProfileData threeYearData = (A22resultOfProfileData)a22resultOfThreeYear_vt.get(0);
		l1  = threeYearData.LEADAP1;
		l2  = threeYearData.LEADAP2;
		l3  =  threeYearData.LEADAP3;
		ap1  = threeYearData.MBOAP1;
		ap2  = threeYearData.MBOAP2;
		ap3  = threeYearData.MBOAP3;
		year  = threeYearData.YEAR1;

		m1  = threeYearData.MISSAP1;//16
		m2  = threeYearData.MISSAP2;//15
		m3  = threeYearData.MISSAP3;//14

		// leadership
		if(l1.equals("1")) {
			l1 = "上";
		}else if(l1.equals("2")) {
			l1 = "中";
		}else if(l1.equals("3")) {
			l1 = "下";
		}

		if(l2.equals("1")) {
			l2 = "上";
		}else if(l2.equals("2")) {
			l2 = "中";
		}else if(l2.equals("3")) {
			l2 = "下";
		}

		if(l3.equals("1")) {
			l3 = "上";
		}else if(l3.equals("2")) {
			l3 = "中";
		}else if(l3.equals("3")) {
			l3 = "下";
		}
		// 성과
		if(ap1.equals("1")) {
			ap1 = "上";
		}else if(ap1.equals("2")) {
			ap1 = "中";
		}else if(ap1.equals("3")) {
			ap1 = "下";
		}

		if(ap2.equals("1")) {
			ap2 = "上";
		}else if(ap2.equals("2")) {
			ap2 = "中";
		}else if(ap2.equals("3")) {
			ap2 = "下";
		}

		if(ap3.equals("1")) {
			ap3 = "上";
		}else if(ap3.equals("2")) {
			ap3 = "中";
		}else if(ap3.equals("3")) {
			ap3 = "下";
		}
		// mission
		if(m1.equals("1")) {
			m1 = "上";
		}else if(m1.equals("2")) {
			m1 = "中";
		}else if(m1.equals("3")) {
			m1 = "下";
		}

		if(m2.equals("1")) {
			m2 = "上";
		}else if(m2.equals("2")) {
			m2 = "中";
		}else if(m2.equals("3")) {
			m2 = "下";
		}

		if(m3.equals("1")) {
			m3 = "上";
		}else if(m3.equals("2")) {
			m3 = "中";
		}else if(m3.equals("3")) {
			m3 = "下";
		}
	}
	if(!year.equals("")){
		year_1 = DataUtil.getAfterYear(year+"0101", -1).substring(0, 4);
		year_2 = DataUtil.getAfterYear(year+"0101", -2).substring(0, 4);
	}

%>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>ESS</title>
	<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
	<style>
		/*A4용지에 맞게 출력하기*/
body {
    margin: 0;
    padding: 0;
    /* background-color: #FAFAFA; */
    font: 10pt "Malgun Gothic";
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.page {
    width: 21cm;
    /* min-height: 29.7cm; */
    padding: 1cm;
    /* margin: 1cm auto; */
    /* border: 1px #D3D3D3 solid; */
    /* border-radius: 5px; */
    /* background: white; */
    /* box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); */
}
/* .subpage {
    padding: 1cm;
    border: 5px red solid;
    height: 256mm;
    outline: 2cm #FFEAEA solid;
} */

@page {
    size: A4;
    margin: 0;
}
@media print {
    .page {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
}




		.txtr  {text-align:right !important; padding-right:10px !important; font-weight:bold;}
		.table02 {background-color : rgba(86, 86, 86, 1);}
		.table021 {border:0px; height:800;width:1250;table-layout:fixed; border-top:solid 2px #c8294b;}
		textarea {border:0px; overflow-y: auto; font-size: 10pt; color: #333333; word-spacing: -1;font-family:"Malgun Gothic", "Simsun";}
		table, td, tr{font-size: 10pt; }
		.tableborder3 {border:3px solid #000;}
		/*[CSR ID:3509208] 임원 프로파일 시스템 글자 선명화 요청*/
		.td03{font-weight:bold;color: #222;}
		.td04{font-weight:bold;color: #222;}
		.td09{font-weight:bold;color: #222;}
		/* .up01{height:140;width:1250;table-layout:fixed;} */

	</style>
	<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
	<SCRIPT LANGUAGE="JavaScript">
        <!--
        //상단 인원 검색 용 공통 function
        function  doSearchDetail() {
            document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A22ExecutiveProfile.A22ExecutiveProfileSV_m";
            document.form1.method = "post";
            document.form1.target = "menuContentIframe";
            document.form1.submit();
        }

        function printBy(){
            if( confirm("[파일]->[페이지 설정]에서 다음과 같이 설정하시기 바랍니다.  \n\n배경색 및 이미지 앤쇄 \t: 체크\n크기에 맞게 축소 사용 \t: 체크\n용지크기\t\t: A4\n머리글/바닥글\t: 내용 삭제\n방향\t\t: 가로\n여백(밀리미터)\t: 왼쪽 10 오른쪽 10 위쪽 5 아래쪽 5\n\n해당 설정이 완료되셨으면 출력하시기 바랍니다. 출력하시겠습니까?") ) {
            	window.print();
            }
        }

    	function autoRow(){
    		var frm = document.form1;
    		var size1 = frm.text1.scrollHeight;
    		var size2 = frm.text2.scrollHeight;
    		var size_fix = frm.text1.style.pixelHeight;
    		if(size1 > size_fix){
    			frm.text1.style.pixelHeight = size1;
    		}
    		if(size2 > size_fix){
    			frm.text2.style.pixelHeight = size2;
    		}
    	}

        //-->
	</SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload ="autoRow();">
<form name="form1" method="post">
	<table  border="0" cellspacing="0" cellpadding="0" class="page" >
		<tr>
			<td width="16">&nbsp;</td>
			<td><table width="1250" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="1250" class="tr01">
						<!-- title -->
						<table width="1250" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">임원 Profile
									<div style="float:right"> &nbsp;<a href="javascript:printBy();"><img src="<%= WebUtil.ImageURL %>btn_print.gif" border="0" align="absmiddle"></a></div></td>

							</tr>
						</table></td>
				</tr>

				<%
					if ( user_m != null ) {
				%>
				<tr>
					<td align="right" style="padding-bottom:5px">(연령/근속 기준일 : 익년도 1.1字)</td>
				</tr>
				<tr>
					<td  width="1250" class="tr01">
						<!-- 상단 -->
						<table  border="0" cellspacing="0" cellpadding="10"  height="100" width = "1250" class="table02 up01">

							<tr>
								<td bgcolor="#FFFFFF" style="padding:0;">
									<table width="100%" border="0" cellpadding="0" cellspacing="" bgcolor="#FFFFFF">
										<tr>
											<td style="vertical-align:top;border:none;background:#fff;padding:0;">
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td style="vertical-align:middle;padding:0 0px 0 0px" width = "120">
															<table width="100" border="0" cellspacing="1" cellpadding="0" height="140" width = "110" class="table02 picTable" >
																<tr>
																	<td class="td04"><img name="photo" border="0" src="<%=data.PHOTO %>" width="116.1" height="138" ></td>
																</tr>
															</table></td>
														<td><table width="600" border="0" cellspacing="1.5" cellpadding="3" class="table02" style="border-top:none;">
															<tr style="height: 35px;">
																<td class="td03 txtr" width="10%" height="35">성명(직위)</td>
																<td class="td09 " width="20%" ><%= data.CENAME %></td>
																<td class="td03 txtr" width="10%">생년월일(연령)</td>
																<td class="td09" width="20%"><%=data.CGBDAT %></td>
																<td class="td03 txtr" width="10%" rowspan="2" >학력</td>
																<td class="td09" width="30%" rowspan="2">
																	<%
																		int nSchoolSize = Utils.getSize(a22school_vt);
																		//a22school_vt = com.sns.jdf.util.SortUtil.sort(a22school_vt, "BEGDA", "desc");
																		for (int i = 0; i < nSchoolSize; i++ ){
																			A22resultOfProfileData dataSchool = a22school_vt.get(i);
																			out.println(dataSchool.CRESULT);
																			if(i + 1 < nSchoolSize) out.println("<br>");
																	%>
																	<%
																		}
																	%>
																</td>
															</tr>
															<tr style="height: 35px;">
																<td class="td03 txtr" height="35">직책(역할급)</td>
															<%
																String roleString = "";
																if(Utils.getSize(a22role_vt) > 0) {
																	roleString = a22role_vt.get(0).CRESULT;
																}
															%>
																<td class="td09"><%=data.CTITL2 %><%--(<%=roleString %>)--%></td>
																<td class="td03 txtr">입사일자(근속)</td>
																<td class="td09"><%=data.CDAT01 %></td>

															</tr>
															<tr style="height: 35px;">
																<td class="td03 txtr" height="35">임원 선임일</td>
																<td class="td09"><%= (data.DAT02).replace("-",	".") %></td>
																<td class="td03 txtr">최종 승진일</td>
																<td class="td09"><%= (data.DAT03).replace("-",	".") %></td>
																<td class="td03 txtr" rowspan="2" >어학</td>
																<td class="td09" rowspan="2" >
																	<%
																		int nLangSize = Utils.getSize(a22language_vt);
																		//a22school_vt = com.sns.jdf.util.SortUtil.sort(a22school_vt, "BEGDA", "desc");
																		for (int i = 0; i < nLangSize; i++ ){
																			A22resultOfProfileData dataSchool = a22language_vt.get(i);
																			out.println(dataSchool.CRESULT);
																			if(i + 1 < nLangSize) out.println("<br>");
																	%>
																	<%
																		}
																	%>
																</td>
															</tr>
															<tr style="height: 35px;">
																<td class="td03 txtr" height="35">현 직책 선임일</td>
																<td class="td09"><%= (data.DAT04).replace("-",	".") %></td>
																<td class="td03 txtr">근무지</td>
																<td class="td09"><%= data.BTEXT %></td>
																<!-- 어학 -->
															</tr>
														</table></td>
													</tr>
												</table></td>
										</tr>
									</table></td>
							</tr>
						</table></td>
				</tr>
				<tr><td  width="1300" >
					<!-- 하단 -->

					<table width="100%" border="0" cellspacing="1" cellpadding="5">
					<colgroup>
					<col width="30%"/>
					<col width="43%"/>
					<col width="27%"/>
					</colgroup>
						<tr>
							<!-- 3개년 평가 -->
							<td>
								<table width="100%" border="0" cellspacing="1.5" cellpadding="3" class="table02">
									<tr><td class="td03">
									3개년 평가
									</td></tr>
								</table>
							</td>



							<!-- 경력/이력 -->
							<td width = "600" valign="top" style="padding:5px 5px 5px 5px" rowspan="2">
								<table  border="0" cellspacing="0" cellpadding="0" width="100%" >
									<tr>
										<td >
										<table width="100%" border="0" cellspacing="1.5" cellpadding="3" class="table02" >
											<tr>
												<td class="td03" colspan="4" >발 령 사 항</td>
											</tr>
											<tr>
												<td class="td03" width="70">발령일</td>
												<td class="td03" width="90">구분</td>
												<td class="td03" width="90">직위</td>
												<td class="td03" width="">소속/직책</td>
											</tr>
										<%
											int careerSize = Utils.getSize(a22career_vt);
											for(int n = 0; n < row_num; n++) {
												A22resultOfProfileData dataCareer;
											    if(n + 1 <= careerSize) {
													dataCareer = a22career_vt.get(n);
												} else {
													dataCareer = new A22resultOfProfileData();
												}
												DataUtil.fixNull(dataCareer);
										%>
											<tr style="height: 28px;">
												<td class="td04" ><%=WebUtil.printDate(dataCareer.BEGDA) %></td>
												<td class="td04" ><%=dataCareer.MNTXT %></td>
												<td class="td04" ><%=dataCareer.JIKWT %></td>
												<td class="td04" ><%=dataCareer.CTITL2 %></td>
											</tr>
										<%
											}
										%>
										</table>
									</td>
									</tr>

								</table>
							</td>

							<%
								//성과
								StringBuffer strengthPrint = new StringBuffer();
								int nStrengthSize = Utils.getSize(a22StrengthData_vt);
								for(int i = 0; i < nStrengthSize ; i++){
									A22resultOfProfileData a22SData = a22StrengthData_vt.get(i);
									strengthPrint.append(a22SData.TDLINE);
									if(i + 1 < nStrengthSize) strengthPrint.append("\n");
									/*if(a22SData.TDFORMAT.equals("*")){
										if(i !=0){
											strengthPrint += "\n";
										}
										strengthPrint += "*&nbsp;";
										strengthPrint += a22SData.TDLINE;
									}else if(a22SData.TDFORMAT.equals("")){
										strengthPrint += a22SData.TDLINE;
									}
									strengthPrint = strengthPrint.replaceAll("  "," ");
									strengthPrint = strengthPrint.replaceAll("   "," ");*/
								}

//리더십
								StringBuffer weaknessPrint = new StringBuffer();
								int nLeaderSize = Utils.getSize(a22LeadershipData_vt);

								for(int i = 0; i < nLeaderSize ; i++){

									A22resultOfProfileData a22WData = a22LeadershipData_vt.get(i);
									weaknessPrint.append(a22WData.TDLINE);
									if(i + 1 < nLeaderSize) weaknessPrint.append("\n");
									/*
									if(a22WData.TDFORMAT.equals("*")){
										if(i !=0){
											weaknessPrint += "\n";
										}
										weaknessPrint += "*&nbsp;";
										weaknessPrint += a22WData.TDLINE;
									}else if(a22WData.TDFORMAT.equals("")){
										weaknessPrint += a22WData.TDLINE;
									}
									weaknessPrint = weaknessPrint.replaceAll("  "," ");
									weaknessPrint = weaknessPrint.replaceAll("   "," ");*/
								}
							%>

							<!-- open question -->
							<td valign="top" style="padding-right:0px" rowspan="3">
								<table  width="100%" border="0" cellspacing="1.5" cellpadding="1" class="table02">
									<tr><td class="td03">성과</td></tr>
									<%--[CSR ID:3509208] 임원 프로파일 시스템 글자 선명화 요청 --%>
									<tr><td class="td04"><textarea  cols="30" rows="16" name="text1" style="width:307px; height: 270px;color: #222;font-weight:bold;" readonly><%=strengthPrint.toString()%></textarea></td></tr>

									<tr><td class="td03">리더십</td></tr>
									<%--[CSR ID:3509208] 임원 프로파일 시스템 글자 선명화 요청 --%>
									<tr><td class="td04"><textarea cols="30" rows="16" name="text2" style="width:307px; height: 270px;color: #222;font-weight:bold;" readonly><%=weaknessPrint.toString()%></textarea></td></tr>

								</table>
							</td></tr>

							<tr><td >
								<table>
									<colgroup>
										<col width="57%"/>
										<col width="43%"/>
									</colgroup>
									<tr>
										<!-- 성과 / 리더십 -->
										<td >
											<table border= 0 >
												<tr><td rowspan=5><font size =3><b>성<br><br>과</b></font></td></tr>
												<tr><td valign="bottom">&nbsp;</td>
													<td colspan = 4 rowspan=4>  <iframe  scrolling="no" width="170" height="250" src="<%=WebUtil.ServletURL %>hris.A.A22ExecutiveProfile.A22ExecutiveProfileSV_m?jobid2=leader" frameborder="0"></iframe></td></tr>
												<tr><td valign="top">上</td></tr>
												<tr><td valign="top">中</td></tr>
												<tr><td valign="top">下</td></tr>
												<tr><td></td><td></td><td>&nbsp;</td><td align = "center" width = "34%">&nbsp;下</td><td align = "center" width = "33%">中</td><td width = "33%" align = "center" >上&nbsp;&nbsp;&nbsp;</td></tr>
												<tr><td></td><td></td><td colspan = "4" align = "center" ><font size =3><b>리&nbsp;더&nbsp;십</b></font></td></tr>
											</table>
										</td>

										<!-- Mission -->
										<td >
											<table border= 0 >
												<tr><td> <iframe  scrolling="no" width="150" height="290" src="<%=WebUtil.ServletURL %>hris.A.A22ExecutiveProfile.A22ExecutiveProfileSV_m?jobid2=mission" frameborder="0"></iframe>
												</td></tr>
											</table>
										</td>
									</tr>
								</table>
							</td></tr>
							<tr><td>
							<table  width="100%" border="0" cellspacing="1.5" cellpadding="3" class="table02">
								<tr style="height: 50px;">
									<td class="td03" width="31%" height="50">구분</td>
									<td class="td03" width="23%" height="50"><%=year_2 %></td>
									<td class="td03" width="23%" height="50"><%=year_1 %></td>
									<td class="td03" width="23%" height="50"><%=year %></td>
								</tr>

								<tr style="height: 50px;">
									<td class="td03" width="30%" >성과평가</td>
									<td class="td04" ><%=ap3 %></td>
									<td class="td04" ><%=ap2 %></td>
									<td class="td04" ><%=ap1 %></td>
								</tr>
								<tr style="height: 50px;">
									<td class="td03" width="30%" >종합리더십평가</td>
									<td class="td04" ><%=l3 %></td>
									<td class="td04" ><%=l2 %></td>
									<td class="td04" ><%=l1 %></td>
								</tr>
								<tr style="height: 50px;">
									<td class="td03" width="30%" >미션평가</td>
									<td class="td04" ><%=m3 %></td>
									<td class="td04" ><%=m2 %></td>
									<td class="td04" ><%=m1 %></td>
								</tr>
							</table>
						</td>
						<td valign="top" style="padding:5px 5px 5px 5px">
									<%--//[CSR ID:3460886] --%>
										<table  width="100%" border="0" cellspacing="1.5" cellpadding="3" class="table02" style="">
											<colgroup>
												<col width="18%"/>
												<col width="13%"/>
												<col />
											</colgroup>
											<tr style="height: 40px;">
												<td class="td03 txtr" rowspan="2" >Succession<br>Plan</td>
												<td class="td03 txtr" >現Post</td>
												<td class="td09" >
												<%
													int nPlanPostSize = Utils.getSize(sPlanListPost);
													for (int i = 0; i < nPlanPostSize; i++ ) {
														A22resultOfProfileData row = sPlanListPost.get(i);
														out.println(row.CRESULT);

														if(i + 1 < nPlanPostSize) out.println(", ");
													}
												%>
												</td>
											</tr>
											<tr style="height: 40px;">
											<td class="td03 txtr">대상자</td>
											<td class="td09">
											<%
													int nPlanSize = Utils.getSize(sPlanList);
													for (int i = 0; i < nPlanSize; i++ ) {
														A22resultOfProfileData row = sPlanList.get(i);
														out.println(row.CRESULT);

														if(i + 1 < nPlanSize) out.println(", ");
													}
												%>
											</td>
											</tr>
											<tr style="height: 40px;">
												<td class="td03 txtr" colspan="2" >사업가 후보</td>
												<td class="td09" >
												<%
													int nBusiSize = Utils.getSize(a22busi_vt);
													for (int i = 0; i < nBusiSize; i++ ) {
														A22resultOfProfileData dataBusi = a22busi_vt.get(i);
														out.println(dataBusi.CRESULT);

														if(i + 1 < nBusiSize) out.println(", ");
													}
												%>
												</td>
											</tr>
											<tr style="height: 40px;">
												<td class="td03 txtr" colspan="2">주요 교육이력</td>
												<td class="td09">
												<%
													int nEduSize = Utils.getSize(a22edu_vt);
													for (int i = 0; i < nEduSize; i++ ) {
														A22resultOfProfileData row = a22edu_vt.get(i);
														out.println(row.CRESULT);

														if(i + 1 < nEduSize) out.println(", ");
													}
												%>
												</td>
											</tr>
											<%--<tr style="height: 39px;">
												<td class="td03 txtr" height="39">역할급</td>
												<td class="td09">
												<%
													int nRoleSize = Utils.getSize(a22role_vt);
													for (int i = 0; i < nRoleSize; i++ ) {
														A22resultOfProfileData row = a22role_vt.get(i);
														out.println(row.CRESULT);

														if(i + 1 < nRoleSize) out.println(", ");
													}
												%>
												</td>
											</tr>--%>
											<tr style="height: 40px;">
												<td class="td03 txtr" colspan="2">징계</td>
												<td class="td09">
												<%
													int nPunishSize = Utils.getSize(a22punish_vt);
													for (int i = 0; i < nPunishSize; i++ ) {
														A22resultOfProfileData row = a22punish_vt.get(i);
														out.println(row.CRESULT);

														if(i + 1 < nPunishSize) out.println(", ");
													}
												%>
												</td>
											</tr>
										</table>
									</td></tr>
					</table>
</td></tr>
			</table>


				<%
					}
				%>


				<input type="hidden" name="jobid2"   value="">
				<input type="hidden" name="licn_code" value="">
			</td>
		</tr>
	</table>
</form>
</body>
</html>