<%@ page contentType="text/html; charset=utf-8" %>
<!--%@ page language="java" import="common.NameCheck"%-->
<%@ page import="com.NameCheck" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<jsp:useBean id="NC" class="com.NameCheck" scope="application"/>
<%

String SITEID = "I850";
String SITEPW = "26684208";
HttpSession s = request.getSession(true);
/*if(!StringUtils.equals((String) s.getValue("NmChkSec"), "98u9iuhuyg87"))
{
	// 인증이 안되는 경우...
}*/

//s.invalidate();

String sJumin1 = StringUtils.defaultString(request.getParameter("jumin1"));
String sJumin2 = request.getParameter("jumin2");
String sJumin = sJumin1 + sJumin2;
//String sName = new String(request.getParameter("name").getBytes("8859_1"),"KSC5601");
String sName =  StringUtils.defaultString(request.getParameter("name"));

if((!sJumin.equals("")) && (!sName.equals("")))
{
	String Rtn = "";
	NC.setChkName(sName);				//

	try {
		Rtn = NC.setJumin(sJumin + SITEPW);
	} catch(Exception e) {
	    Rtn = "ERROR";
	}

	if(Rtn.equals("0"))
	{
		NC.setSiteCode(SITEID);
		NC.setTimeOut(30000);
		Rtn = NC.getRtn().trim();
	}
	//out.println(Rtn);

        if (Rtn.equals("1")){
%>
            <script language="javascript">
               function f_return() {
                    jumin = document.form1.jumin1.value + "-" + document.form1.jumin2.value;

                    alert('<spring:message code="MSG.A.A12.0037" />'); //인증에 성공하였습니다
                    opener.JuminSetting(jumin,document.form1.name.value);
                    self.close();
               }
            </script>
			<html>
				<head>
				</head>
				<!--<body onLoad="document.form1.submit()">-->
				<body onLoad="f_return()">
					<form name="form1" method="post" action=index.jsp>
						<input type="hidden" name="jumin1" value="<%=sJumin1%>">
						<input type="hidden" name="jumin2" value="<%=sJumin2%>">
						<input type="hidden" name="name" value="<%=sName%>">
					</form>
				</body>
			</html>
<%
		}else if (Rtn.equals("2")){
%>
            <script language="javascript">
				alert("실명확인이 안되니, 소속 사업장 담당부서로 연락주시기 바랍니다.");
               history.go(-1);
               /*var URL ="https://www.namecheck.co.kr/front/personal/register_online.jsp?menu_num=1&page_num=0&page_num_1=0";
               var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no, width= 640, height= 480, top=0,left=20";
               window.open(URL,"",status);*/
            </script>
<%
		}else if (Rtn.equals("3")){
%>
            <script language="javascript">
                alert("실명확인이 안되니, 소속 사업장 담당부서로 연락주시기 바랍니다.");
               history.go(-1);
               /*var URL ="https://www.namecheck.co.kr/front/personal/register_online.jsp?menu_num=1&page_num=0&page_num_1=0";
               var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no, width= 640, height= 480, top=0,left=20";
               window.open(URL,"",status);*/
            </script>
<%
		}else if (Rtn.equals("50")){
%>
            <script language="javascript">
                alert("실명확인이 안되니, 소속 사업장 담당부서로 연락주시기 바랍니다.");
               history.go(-1);
               /*var URL ="https://www.credit.co.kr/ib20/mnu/BZWPNSOUT01";
               var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no, width= 640, height= 480, top=0,left=20";
               window.open(URL,"",status);*/
            </script>

<%
		}else{
%>
			<script language='javascript'>
                alert("실명확인이 안되니, 소속 사업장 담당부서로 연락주시기 바랍니다.");
				/*alert('<spring:message code="MSG.A.A12.0038" />'); //인증에 실패 하였습니다.*/
				history.go(-1);
			</script>
<%
		}
}else{
	out.println("성명이나 주민번호를 확인하세요.");
}
%>
