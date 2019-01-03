<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ include file="./config.jsp" %>
<%

	String uurl = null;

	//http://nlstest.initech.com:8090/agent/sso/login_exec.jsp : 꼭 도메인으로 호출해야 된다.
	//
	//1.SSO ID 수신
	String sso_id = getSsoId(request);

	if (sso_id == null) {
		goLoginPage(response);
		return;
	} else {

		//4.쿠키 유효성 확인 :0(정상)
		String retCode = getEamSessionCheck(request,response);

		if(!retCode.equals("0")){
			goErrorPage(response, Integer.parseInt(retCode));
			return;
		}
		//
		//5.업무시스템에 읽을 사용자 아이디를 세션으로 생성
		String EAM_ID = (String)session.getAttribute("SSO_ID");
		if(EAM_ID == null || EAM_ID.equals("")) {
			session.setAttribute("SSO_ID", sso_id);
		}
		out.println("SSO 인증 성공!!");

		//6.업무시스템 페이지 호출(세션 페이지 또는 메인페이지 지정)  --> 업무시스템에 맞게 URL 수정!
		response.sendRedirect("app01.jsp");
		//out.println("인증성공");
	}
%>
