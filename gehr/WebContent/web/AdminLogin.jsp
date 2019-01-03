<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="err/error.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="com.sns.jdf.sap.SAPType" %>
<%@ page import="hris.A.A13Address.rfc.A13AddressNationRFC" %>
<%@ page import="com.common.constant.Server" %>
<%@ page session="false" %>
<%
    try{
        Config conf = new Configuration();
        boolean isLoadBalancing = conf.getBoolean("com.sns.jdf.sap.SAP_LOAD");
        String  SAP_R3NAME          = conf.get("com.sns.jdf.sap.SID");
        String  SAP_CLIENT          = conf.get("com.sns.jdf.sap.SAP_CLIENT");
        String  SAP_USERNAME          = conf.get("com.sns.jdf.sap.SAP_USERNAME");

        out.println("<center><font color=red size=-1> 현재 "+SAP_R3NAME+" ( "+SAP_CLIENT+":"+SAP_USERNAME+" ) 로 연결되었습니다</font></center>" );
    } catch (Exception ex) {
        Logger.error(ex);
    }


%>
<html>
<head>
    <title>ESS[Jeus 97]</title>
    <link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">

    <Script Language="javascript">
        <!--
        function EnterCheck(){
            if (event.keyCode ==13)  {
                Check_Data() ;
            }
        }

        function Check_Data(){

            if ( document.log.webUserId.value == "" )
            {
                alert("Login ID를 확인 하세요!")
                document.log.webUserId.focus();
                return ;
            }
            if (document.log.webUserPwd.value == "" ){
                alert("PassWord를 확인 하세요!") ;
                document.log.webUserPwd.focus() ;
                return ;
            }
            if (document.log.empNo.value == "" ){
                alert("검색사번을 확인 하세요!") ;
                document.log.empNo.focus() ;
                return ;
            }
            _actionPerform();
        }

        function _actionPerform() {
            //"로그인" 버튼을 누른경우

            document.log.method = "post";
            document.log.action = "<%= WebUtil.ServletURL %>hris.AdminLoginSV";
            //document.log.action = "<%= WebUtil.ServletURL %>hris.DirectLoginSV";
            _submit();
        }

        function _submit() {
            document.log.submit();
        }

        function chgPassword()
        {
            //C20130813_86689
            window.open( "<%= WebUtil.JspURL %>newpopup.jsp?webUserId=" +document.log.webUserId.value, "chgPW", "width=440,height=350,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100");
        }
        //-->
    </Script>
<style>
body {font-family: dotum, '돋움', Arial, Helvetica, sans-serif;}
ul, li {list-style:none;}
img {border:none;}
.loginBox {
	position: absolute;
	left: 50%;
	top: 50%;
	width: 704px;
	height: 321px;
	margin: -160px 0 0 -352px;
	background: #ffffff;
}
.loginHeader {
	position: relative;
	height: 39px;
	border-top: 1px solid #000000;
	border-bottom: 1px solid #000000;
	background: url(<%= WebUtil.ImageURL %>bg_header.gif) repeat-x;
	margin-bottom:-16px;
	margin-bottom:0 \0;
}

@media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {
.loginHeader {margin-bottom:-16px;}
}

.loginHeader img {
	position: absolute;
	left: 0px;
	top: 0px;
}
.loginContent {
	position: relative;
	height: 233px;
	width: 702px;
	border-left: 1px solid #d9d9d9;
	border-right: 1px solid #d9d9d9;
}


.loginContent .mainImage {
	position: absolute;
	left: 24px;
	top: 22px;
}
.loginContent ul {
	position: absolute;
	top: 24px;
	left: 359px;
}
.loginContent ul.inputGr {
	position: absolute;
	left: 320px;
	top: 6px;
}
.loginContent ul.inputGr li {
	width: 219px;
	height: 32px;
}
.loginContent ul.inputGr li.input_id {
	background: url(<%= WebUtil.ImageURL %>sshr/input_login.gif) no-repeat;
}
.loginContent ul.inputGr li.input_pw {
	background: url(<%= WebUtil.ImageURL %>sshr/input_password.gif) no-repeat;
	margin: 8px 0 0 0;
}
.loginContent ul.inputGr li.input_pn {
	background: url(<%= WebUtil.ImageURL %>sshr/input_personalNo.gif) no-repeat;
	margin: 8px 0 0 0;
}
.loginContent ul.inputGr li input {
	background: none;
	border: none;
	color: #000000;
    font-size: 14px;
    margin: 7px 0 0 90px;
	width: 120px;
}
.loginContent .btn_login {
	position: absolute;
	top: 22px;
	left: 587px;
}
.loginContent div.option {
	position: absolute;
	top: 127px;
	left: 210px;
}
.loginContent div.option label.chck01 {
	font-weight: bold;
	color: #888;
}
.loginContent div.option ul {
	position: absolute;
	top: 0;
	left: 110px;
	width: 300px;
	text-align: left;
}
.loginContent div.option ul li {
	display: inline;
	color: #888888;
	margin-left:5px;
}
.loginContent div.option ul li input {position:relative; top:2px;}
.loginContent div.option ul label {
	font-size: 11px;
}
.loginContent ul.btnArea {
	position: relative;
	top: 175px;
}
.loginContent ul.btnArea li {
	display: inline;
	margin-right: 2px;
}
.loginFooter {
	position: relative;
	height: 45px;
	width: 702px;
	background: #f1f1f1;
	border: 1px solid #d9d9d9;
	border-top: none;
}
.loginFooter h1 {
	font-size: 11px;
	color: #888888;
	position: absolute;
	top: 12px;
	left: 25px;
}
.loginFooter h1 span {
	margin: 0 10px 0 7px;
	font-weight: 100;
}
.loginFooter img {
	position: absolute;
	right: 27px;
	top: 15px;
}

/* ie8 hack */
.loginHeader {
	()width:702px;
	()height: 41px;
	()margin-bottom:0;
}
.loginContent ul.inputGr {
	()top: 22px;
}
.loginContent div.option {
	()top: 135px;
}
.loginFooter h1 {
	()top: 18px;
}
</style>

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div class="loginBox">
	<div class="loginHeader">
		<img src="<%= WebUtil.ImageURL %>sshr/logo_header.gif" alt="로고 엘리안2.0 이미지" />
	</div>
	<div class="loginContent">
        <form name="log" method="post">
		<img class="mainImage" src="<%= WebUtil.ImageURL %>sshr/img_main.png" alt="메인이미지" />
		<ul class="inputGr">
		    <li class="input_id"><input type="text" id="webUserId" name="webUserId" value="" onKeyDown="EnterCheck()" style="ime-mode:inactive" /></li>
		    <li class="input_pw"><input type="password" name="webUserPwd" value="" onKeyDown="EnterCheck()"/></li>
		    <li class="input_pn"><input type="text" name="empNo" value="" onKeyDown="EnterCheck()"/></li>
 		</ul>
	    <a class="btn_login" href="javascript:;" onclick="Check_Data();"><img src="<%= WebUtil.ImageURL %>sshr/btn_login.gif" alt="로그인" /></a>

	    <div class="option">
            <ul>
                <li>
                    <select id="sapServer" name="sapServer">
                        <option selected value="<%=Server.DEFAULT%>">기본서버</option>
                        <option value="<%=Server.QAS%>">QAS</option>
                        <option value="<%=Server.DEV%>">DEV</option>
                        <option value="<%=Server.QASN%>">신규QAS</option>
                        <option value="<%=Server.QASN1%>">신규QAS-조원일K</option>
                        <option value="<%=Server.QASN2%>">신규QAS-DHR002</option>
                        <option value="<%=Server.QASN3%>">신규QAS-이창덕D</option>
                        <option value="<%=Server.QASN4%>">신규QAS-박형순D</option>
                        <%--<option value="<%=Server.PRD%>">PRD</option>--%>
                    </select>
                </li>
                <li><input type="radio" id="rdo01" class="radio" name="lang" value="<%=Locale.KOREAN %>" checked="checked"><label for="rdo01">Korean</label></li>
                <li><input type="radio" id="rdo02" class="radio" name="lang" value="<%=Locale.CHINESE %>"><label for="rdo02">Chinese</label></li>
                <li><input type="radio" id="rdo03" class="radio" name="lang" value="<%=Locale.ENGLISH %>"><label for="rdo03">English</label></li>
            </ul>
	    </div>
            <div class="option" style="top: 157px;" >
                <ul>
                    <li><input type="radio"  class="radio" name="sysid" value="0"><label for="rdo01">국내사번</label></li>
                    <li><input type="radio"  class="radio" name="sysid" value="1"><label for="rdo02">해외사번</label></li>
                    <li><a href="javascript:chgPassword();"><img src="<%= WebUtil.ImageURL %>login/btn_modify.gif" border="0"></a></li>
                </ul>

            </div>
		<%--<div class="option" style="	top: 157px;">
			<ul>
				<li><input type="radio" id="rdo04" class="radio" name="sapType" value="<%=SAPType.LOCAL %>" checked="checked"><label for="rdo01">국내</label></li>
				<li><input type="radio" id="rdo05" class="radio" name="sapType" value="<%=SAPType.GLOBAL %>"><label for="rdo02">해외</label></li>
			</ul>
		</div>--%>
        </form>
	</div>
<div class="loginFooter">
	<h1><span>You need an ID, password, Personnel Number.</span></h1>
	<img src="<%= WebUtil.ImageURL %>logo_lgchem.gif" alt="logo" />
</div>
</div>
</body>
</html>

