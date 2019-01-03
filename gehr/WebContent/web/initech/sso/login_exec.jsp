<%-- --------------------------------------------------------------------------
 - Display     : none
 - File Name   : login_exec.jsp
 - Description : SSO 인증토큰 유효성 검증 및 업무시스템의 세션 생성
 - Include     : config.jsp
 - Submit      : none
 - Transaction : none
 - DB          : none
 - Author      : 가원호
 - Last Update : 2005/07/07
-------------------------------------------------------------------------- --%>

<%@ page
	language="java"
	contentType="text/html;charset=utf-8"
	import="java.io.*"
%>
<%@ include file="./config.jsp" %>

<% out.println("dd1");
%>

<%	
	String sso_id = null;
	String uurl = null;
	String[] sso_data = null;
	String system_id = null;
	String system_pw = null;
	boolean conTest = false;


	//NLS 장애 여부 판단.
	int port = Integer.parseInt(NLS_PORT);
	conTest = connectionTest(CHECK_IP,port);

	
	//SSO 장애시 장애처리 redirect :: JAVA SE와 함께 쓰일 경우 아래 IF문 주석 처리한다.
	
	if(!conTest){

		
		//out.println("장애발생");
		response.sendRedirect(SSO_FAIL_URL);
		return;
	}


	// 1. SSO ID 수신
	sso_id = getSsoId(request);

	
	// 2. UURL 수신
	uurl = request.getParameter("UURL");






	if (sso_id == null) {

										
		if (uurl == null)	uurl = ASCP_URL;
		
		//3. SSO ID 가 없다면 로그인 페이지로 이동

		goLoginPage(response, uurl);
		return;
	} else {


		String retCode = getEamSessionCheck(request,response);

		//4. 인증토큰이 유효여부에 따른 처리
		/*if(!retCode.equals("0")){
			//CookieManager.removeNexessCookie(NLS_DOMAIN, response);
			goErrorPage(response, 1200);	
			return;
		}else{		*/
			sso_data = getSystemAccount(sso_id);

			if (sso_data == null) {
				goErrorPage(response, 2400);
				return;
			}else{
				//4.1. 외부계정 정보가 있는 경우 처리
				system_id = sso_data[0];
				system_pw = sso_data[1];

			

				//[시스템 담당자 확인]
				/*-----------------------------------------------------------------'
				'시스템에 제공할 세션 생성 
				'기본적으로 통합인증 아이디(Email ID), 시스템 아이디(Email ID 또는 사번),
				'시스템 패스워드를 세션으로 생성한다.
				'시스템에서 필요하지 않은 세션에 대해서는 주석처리 한다.
				'-----------------------------------------------------------------*/
				session.setAttribute("SSO_ID", sso_id);
				session.setAttribute("SYSTEM_ID", system_id);
				//session.setAttribute("SYSTEM_PW", system_pw);
				
				//4.2 uurl 설정
				if (checkUurl(uurl) == null)	uurl = ASCP_URL;			

				
				if(!uurl.equals(ASCP_URL)&&uurl!=null){
					response.sendRedirect(uurl);				
				}else{						
					response.sendRedirect("../index.jsp");	
				}
			}
		/*}*/
	}	
	


%>
