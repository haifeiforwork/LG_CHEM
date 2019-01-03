<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="ctl00_Head1"><meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /><title>
	LG 라이프케어 포탈입니다.
</title>
	
	
	

<link href="<%= WebUtil.ImageURL %>css/2013_common.css" type="text/css" rel="stylesheet" />
</head>
<body>
	
	<form method="post" action="shinhwa.aspx" id="aspnetForm">



    <div id="divProgress" style="z-index: 999;">
    </div>
	<div id="wrap">
		<!-- Header Area -->
		<div id="header">


<style type="text/css">
    .UpdateProgress
    {
        background-color: black;
        position: absolute;
        filter: alpha(opacity=60);        
    }
    td.ProgressText
    {
        position:fixed;  
        top:200px;
        left:50%;
        margin-left:-94px;  
        color: Black;        
    }
    
    .highlight { background-color: Yellow; color : Red; }
</style>



				
<style>
    div.LifeCare2012, 
	 .LifeCare2012 div,
	.LifeCare2012 dl,
	.LifeCare2012 dt,
	.LifeCare2012 dd,
	.LifeCare2012 ul,
	.LifeCare2012 ol,
	.LifeCare2012 li,
	.LifeCare2012 h1,
	.LifeCare2012 h2,
	.LifeCare2012 h3,
	.LifeCare2012 h4,
	.LifeCare2012 h5,
	.LifeCare2012 form,
	.LifeCare2012 fieldset,
	.LifeCare2012 p,
	.LifeCare2012 button{margin:0;padding:0}
	div.LifeCare2012,
	.LifeCare2012 h1,
	.LifeCare2012 h2,
	.LifeCare2012 h3,
	.LifeCare2012 h4,
	.LifeCare2012 input,
	.LifeCare2012 button{font-family:'돋움',dotum,Helvetica,sans-serif;font-size:12px;color:#666;}
	
	div.LifeCare2012{background-color:#fff;*word-break:break-all;-ms-word-break:break-all;line-height:normal;}
	.LifeCare2012 img,
	.LifeCare2012 fieldset,
	.LifeCare2012 iframe{border:0 none}
	.LifeCare2012 li{list-style:none}
	.LifeCare2012 input,
	.LifeCare2012 select,
	.LifeCare2012 button{vertical-align:middle}
	.LifeCare2012 img{vertical-align:top}
	.LifeCare2012 i,
	.LifeCare2012 em,
	.LifeCare2012 address{font-style:normal}
	.LifeCare2012 label,
	.LifeCare2012 button{cursor:pointer}
	.LifeCare2012 button{margin:0;padding:0}
	.LifeCare2012 a{color:#666;text-decoration:none}
	.LifeCare2012 a:hover{color:#666;text-decoration:underline}
	.LifeCare2012 button *{position:relative}
	.LifeCare2012 button img{left:-3px;*left:auto}
	.LifeCare2012 option{padding-right:6px}
	.LifeCare2012 hr{display:none}
	.LifeCare2012 legend{*width:0}
	.LifeCare2012 table{border-collapse:collapse;border-spacing:0}
	
	.LifeCare2012 {background-color:#FFFFFF; width:995px;}
	
	/* 테이블 */
	table {width:100%; border:0px; border-spacing:0px; border-collapse:collapse;}
	th {font-family:"NanumGothicBold"; font-weight:normal; color:#333; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
	th, td {border:0px; word-break:break-all; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
	
	/*신화 세무회계 사무소*/
	.Shinhwatax {padding-bottom:100px;}
	.Shinhwatax h2 {padding-top:50px;}
	.Shinhwatax h3 {margin-top:46px; padding-left:14px; background:url(/App_Themes/Default/images/shinhwa/icon_sub_title.gif) no-repeat}
	.Shinhwatax_tit {background:url('/App_Themes/Default/images/shinhwa/h2_shinhwabg.jpg') no-repeat right 10px;} 
	.Shinhwatax ul {margin-top:10px;}
	.Shinhwatax li {padding:0 0 0 32px; background:url(/App_Themes/Default/images/shinhwa/blt.jpg) no-repeat top 6px left 22px; line-height:20px;}
	.Shinhwatax caption {display:none;} 
	.Shinhwatax .type3-table {width:100%; margin-top:10px; border-top:solid 2px #000 !important}
	.Shinhwatax .type3-table .line {border-left:1px solid #c1c1c1; border-right:1px solid #c1c1c1;}
	.Shinhwatax .type3-table th {
						padding:12px 0 10px 0; 
						border-bottom:solid 1px #c1c1c1; 
						font-weight:bold; 
						padding-right:0;
						background-image:-webkit-gradient(linear, left top, left bottom, from(#fefeff), to(#e6e7e9)); /* Saf4+, Chrome */
						background-image:-webkit-linear-gradient(top, #fefeff, #e6e7e9); /* Chrome 10+, Saf5.1+ */
						background-image:   -moz-linear-gradient(top, #fefeff, #e6e7e9); /* FF3.6 */
						background-image:    -ms-linear-gradient(top, #fefeff, #e6e7e9); /* IE10 */
						background-image:     -o-linear-gradient(top, #fefeff, #e6e7e9); /* Opera 11.10+ */
						background-image:        linear-gradient(top, #fefeff, #e6e7e9);
						 -pie-background:        linear-gradient(top, #fefeff, #e6e7e9);
						background-color:#e6e7e9;
						}
	.Shinhwatax .type3-table td {padding:20px 0px; border-top:solid 1px #d8d8d8; border-right:solid 1px #d8d8d8; border-bottom:solid 1px #d8d8d8; line-height:22px;}
	.Shinhwatax .type3-table .l {text-align:left; padding-left:50px;}
	.Shinhwatax .c {text-align:center;}
	.Shinhwatax .type3-table .bor_none {border-right:0px;}
	.Shinhwatax .request {background-color:#fbfbfb;}
	.Shinhwatax .request ul {padding:17px 40px;}
	.Shinhwatax .request li {padding:0; background:none;}
	.Shinhwatax .request li img {margin-top:5px;}	
	.Shinhwatax .point1 {background:url(/App_Themes/Default/images/shinhwa/point2.jpg) no-repeat top 36px right 98px;}	
	.Shinhwatax .contact {padding-bottom:100px;}
	.Shinhwatax .button-big2-red  {
						width:254px;
						height:44px;
						margin-top:10px;
						display:inline-block;
						border-bottom:1px solid #961c37;
						background-image:-webkit-gradient(linear, left top, left bottom, from(#ee416a), to(#ea2750)); /* Saf4+, Chrome */
						background-image:-webkit-linear-gradient(top, #ee416a, #ea2750); /* Chrome 10+, Saf5.1+ */
						background-image:   -moz-linear-gradient(top, #ee416a, #ea2750); /* FF3.6 */
						background-image:    -ms-linear-gradient(top, #ee416a, #ea2750); /* IE10 */
						background-image:     -o-linear-gradient(top, #ee416a, #ea2750); /* Opera 11.10+ */
						background-image:        linear-gradient(top, #ee416a, #ea2750);
						background-color:#ea2750;
						}
	.Shinhwatax .button-big2-red a {display:block ;width:100%; height:100%; margin-top:2px; text-align:center; font-weight:bold;color:#fff; line-height:44px; font-size:14px; letter-spacing:-1px; text-decoration:none;}
	.Shinhwatax .button-big2-red img {margin:10px 0 0 19px;}
	*:first-child+html body .Shinhwatax .button-big2-red a {display:block ;width:100%; height:100%; margin-top:4px; text-align:center; font-weight:bold;color:#fff; line-height:44px; font-size:14px; letter-spacing:-1px; text-decoration:none;}
	*:first-child+html body .button-big2-red img {margin:-4px 0 0 19px;}
</style>


<div class="LifeCare2012">
	<div class="Shinhwatax">				
		<div class="content_header">
			<div class="Shinhwatax_tit"> 
				<h2><img src="<%= WebUtil.ImageURL %>h2_shinhwa.jpg" alt="신화세무회계사무소" title="" /></h2>
				<h3>&nbsp;&nbsp;EAP(Employee Assitance Program) 차원의 세무상담 서비스 도입</h3>
					<ul>
						<li> - 임직원들의 업무 집중과 성과창출에 몰입할 수 있는 환경조성을 위해, 세무관련 업무 外 Issue를 예방 및 해결/지원 할 수 있는 프로그램을 운영하고자 합니다.</li>
						<li> - 주요 Contents로는 종합소득세, 부동산 세제, 상속/증여세에 대한 On/Off-Line Q&A를 비롯하여 Tax Planning 및 신고 서비스 대행 등의 다양한 서비스를 제공합니다.</li>
						<li> - 본 서비스는 당사 선택적 복리후생관 Contents와 연계하여 임직원 여러분들이 보다 쉽게 이용하실 수 있도록, 선택적 복리후생관 內 세무상담 메뉴를 개설 하였사오니 <br />
                            &nbsp;관심 있으신 임직원 분들의 많은 참여 바랍니다.</li>
					</ul>
			</div>
		</div>
		<!-- Content Body-->	
		<div class="content_body">
			<!-- Supply Contents -->	
			<div class="Section Shinhwatax_Supply">
				<h3>&nbsp;&nbsp;제공 Contents 및 비용</h3>
				<table border="0" class="type3-table" summary="제공 Contents 및 비용-구분, 상담Process, 상담비용(부가세 포함)">
					<caption>
					제공 Contents 및 비용
					</caption>
					<colgroup>
						<col width="15%" />
						<col width="" />
						<col width="23%" />
					</colgroup>
					<thead>
					<tr class="line">
						<th>온라인 상담</th>
						<th>상담 Process</th>
						<th>상담비용(부가세 포함)</th>
					</tr>
					</thead>
					<tr>
						<td class="c">온라인 상담</td>
						<td class="l">세무법인 홈페이지 온라인 게시판에 상담신청<br />→ 담당 세무사 답변(24시간 이내)</td>
						<td class="c bor_none point1">무료<br />(세액산출내역 제공시 110,000원)</td>
					</tr>
					<tr>
						<td class="c">전화상담</td>
						<td class="l">세무법인 홈페이지 온라인 게시판에 상담신청(상담요청시간 기재)<br /> → 상담비용 결제 확인 → 담당 세무사 전화 상담</td>
						<td class="c bor_none">55,000원<br />(세액산출내역 제공시 110,000원)</td>
					</tr>
					<tr>
						<td class="c">출장상담</td>
						<td class="l">세무법인 홈페이지 온라인 게시판에 상담신청(상담요청시간/방문장소 기재)<br /> → 상담비용 결제 확인 → 방문 일정 확인 전화 →<br /> 담당 세무사 방문 상담</td>
						<td class="c bor_none">110,000원<br />(세액산출내역 제공시 220,000원)</td>
					</tr>
					<tr>
						<td class="c">Tax Planning<br />(리포트 제공)</td>
						<td class="l">세무법인 홈페이지 온라인 게시판에 신청<br />
										→ 상담 진행 일정 별도 협의</td>
						<td  class="c bor_none">별도 협의</td>
					</tr>
					<tr>
						<td class="c">양도소득세,<br />상속(증여)세 등<br />신고대행</td>
						<td class="l">세무법인 홈페이지 온라인 게시판에 신청<br />
									→ 전화 확인 및 비용(수수료) 결정<br />
									→ 비용결제 확인<br />
									→ 신고 첨부서류 수취(매매계약서, 필요경비 영수증 등)<br />
									→ 세금 신고 및 신고서 등기 접수<br />
									→ 납부서 및 신고서 사본 납세자에 송부</td>
						<td class="c bor_none">220,000원 ~<br />(상담후 신고의뢰시<br />우선 지출한 상담비용을<br />공제한 잔액만 추가 부담함)</td>
					</tr>
				</table>
				<div class="request">
					<ul>
						<li>*    온라인 상담 요청시 반드시 엘지화학 임직원임을 기재하여 주십시오. 다른 온라인 상담자와 구분하기 위해서 필요합니다.</li>
						<li>**	세액계산을 요청하시는 경우에는 사전정보가 필요하므로 담당 세무사에게 미리 문의 주시기 바랍니다.</li>
					</ul>	
				</div>
				<div class="c">
					<div class="button-big2-red"><a target="_blank" onclick="window.open('http://www.shinhwatax.co.kr/');" style="cursor:hand">신화세무회계사무소 바로가기</a></div> 
				</div>
			</div>
			<!-- //Supply Contents -->	
			<div class="Section">
				<h3>&nbsp;&nbsp;상담비용 결제방법</h3>
				<ul>
					<li> - Off-Line으로 LG 패밀리카드 비용 결재 후 선택적 복리후생 사이트를 통해 해당 비용을 포인트 차감 하시면 됩니다.<br />
                         - 세부적인 Off-Line 비용결재 방법은 담당 세무사<strong>(이대주 세무사 : 010-8146-9285)</strong>로 문의 바랍니다.</li>
				</ul>
			</div>
			<!-- Contact -->	
			<div class="Section contact">
				<h3>&nbsp;&nbsp;Contact</h3>
				<ul>
					<li> - 주관부서 : HR서비스팀 김동근 과장(T.02-3773-6579)</li>
					<li> - 신화세무사무소 : 이대주 세무사(M. 010-8146-9285), 홈페이지(http://www.shinhwatax.co.kr)</li>
				</ul>
			</div>
			<!-- //Contact -->	
		</div>
		<!-- //Content Body-->	
	</div>	
</div>


	

</body>
</html>