<%-- --------------------------------------------------------------------------
 - Display     : none
 - File Name   : config.jsp
 - Description : 환경 설정(20050902 장애처리 추가)
 - Include     : none
 - Submit      : none
 - Transaction : none
 - DB          : none
 - Author      : 가원호
 - Last Update : 2005/09/02
 -               2005/11/28   @v1.1 가원호 ND -> NLS 로 변수 수정
 -				 2015/04/03   Nexess 4.0 버전 업그레이드
-------------------------------------------------------------------------- --%>

<%@ page
	contentType="text/html;charset=UTF-8"
	import="sun.misc.*,
			java.util.*,
			java.math.*,
			java.net.*,
			com.initech.eam.nls.*,
			com.initech.eam.nls.CookieManager,
			com.initech.eam.api.*,
			com.initech.eam.base.*,
			com.initech.eam.nls.command.*,
			com.initech.eam.smartenforcer.*,	
			com.initech.eam.smartenforcer.SECode,
			javax.servlet.*,
			javax.servlet.http.*"			
%>

<%!

	/*--------------------------------------------------------------------------------------'
	'
	' ASCP config.jsp 설정
	' 아래 주석을 확인하시어 수정으로 표기된 부분은 수정해주시기 바랍니다.
	'
	'-------------------------------------------------------------------------------------*/


	//[시스템 담당자 확인]수정1.업무시스템의 호스트명을 할당 

	//아래의 이름에 해당하는 어플리케이션이 자원으로 등록되어 있어야 함
	//아래 이름의 어플리케이션에 해당하는 SSO Account를 꺼내오게 되어있음
	private String SERVICE_NAME = "EHRS";
	
	//[시스템 담당자 확인]수정2.업무시스템의 포트제외한 URL(IP번호 불가) 할당
	private String SERVER_URL = "http://sso.lgchem.com";

	//[시스템 담당자 확인]수정3.업무시스템의 http 접속 포트번호 할당
	private String SERVER_PORT = "8001";
	
	//[시스템 담당자 확인]수정4.ASCP페이지의 경로, 해당 변수들을 고려해 뒷부분 작성
	private String ASCP_URL
		= SERVER_URL + ":" + SERVER_PORT + "/initech/sso/login_exec.jsp";

	//[추가 20050901]SSO 장애시 자체 로그인 페이지 또는 장애메세지 페이지 URL(API 방식 적용시)
	private String SSO_FAIL_URL = "http://system.lgchem.com:8001/lgchem/fail.html";
	
	//기본값 유지
	private String[] SKIP_URL
		= {"", "/", "/index.html", "/index.htm", "/index.jsp", "/index.asp"};


	/*--------------------------------------------------------------------------------------'
	'
	'아래 설정은 SSO NLS서버 및 ND서버 환경 정보로 2005.07.05 현재 epdev.lgchem.com으로 
	'설정 되어 있음
	'추후 실서버로 변경시 실서버 정보로 변경이 필요함
	'
	'--------------------------------------------------------------------------------------*/

	//[시스템 담당자 확인]수정5.SSO NLS 서버 도메인 네임 -- 현재 개발서버로 할당되어있음. 추후 실서버정보로 변경
	private static String NLS_URL = "http://sso.lgchem.com";
	
	//[시스템 담당자 확인]수정6.SSO NLS 서버 도메인 네임
	private String NLS_PORT = "8001";
	
	// 기본값 유지
	private String NLS_LOGIN_URL
		= NLS_URL + ":" + NLS_PORT + "/nls3/clientLogin.jsp";
	
	// 기본값 유지
	private String NLS_LOGOUT_URL
		= NLS_URL + ":" + NLS_PORT + "/nls3/LogOut.jsp";
	// 기본값 유지
	private String NLS_ERROR_URL
		= NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";
		
	//[시스템 담당자 확인]수정7.Nexess Daemon URL(포트제외) -- 추후 이중화 할 경우 두번째 URL설정.
	//private static String ND_URL = "http://lgchsso1.lgchem.com";
	//private static String ND_URL2 = "http://lgchsso2.lgchem.com";
	private static String ND_URL = "http://sso.lgchem.com";
	private static String ND_URL2 = "http://sso.lgchem.com";
	
	// ID/PW type : 수정사항 없음
	private String TOA = "1";
	
	// domain (.lgchem.com) : 수정사항 없음
	private String NLS_DOMAIN = ".lgchem.com";
	private String AP_DOMAIN = ".lgchem.com";

	//장애판단을 위한 CHECK_IP(API 방식 적용시) IP 또는 URL(http://제외)
	private String CHECK_IP = "sso.lgchem.com";
	
	// 2015.04.06 Nexess 4 업그레이드 추가 변수
	private static Vector PROVIDER_LIST = new Vector();
	
	static {
		PROVIDER_LIST.add("sso.lgchem.com");
	}

	// LoadBalancing Number
	//private static int ran_cnt = 0;

	/*-----------------------------------------------------------------------
	' 여기까지 config.asp의 설정은 끝입니다. 수고 하셨습니다.
	'----------------------------------------------------------------------*/
%>

<%!
	public NXContext getContext()
	{
		NXContext context = null;
		try
		{
			List serverurlList = new ArrayList();
			serverurlList.add(ND_URL+":5480/");
			serverurlList.add(ND_URL2+":5480/");
			context = new NXContext(serverurlList);
		}
		catch (Exception e)
		{

		}	
	
		return context;
	}
	
	public void goLoginPage(HttpServletResponse response, String uurl)
	throws Exception {
		
		com.initech.eam.nls.CookieManager.addCookie(SECode.USER_URL, uurl, NLS_DOMAIN, response);
		com.initech.eam.nls.CookieManager.addCookie(SECode.R_TOA, TOA, NLS_DOMAIN, response);
		response.sendRedirect(NLS_LOGIN_URL);				
			
	}

	public void goErrorPage(HttpServletResponse response, int error_code)
	throws Exception {
		CookieManager.removeNexessCookie(NLS_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}

	public String getSsoId(HttpServletRequest request) {
		//2015.04.03 토큰 암호화 여부에 따라 검증옵션 설정
		String encF = CookieManager.getCookieValue("InitechEamCookieEnc" , request);
		if("T".equals(encF)) { 
			CookieManager.setEncStatus(true);
		}else{
			CookieManager.setEncStatus(false);
		}

		String sso_id = null;

		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);

		
		return sso_id;
	}

	/**
	 * check default page
	 */
	public String checkUurl(String uurl) {
		String uri = null;
		URL url = null;

		try {
			url = new URL(uurl);
			uri = url.getPath();
		} catch (Exception e) {
			// URI 인 경우
			uri = uurl;
		}

		for (int i = 0; i < SKIP_URL.length; i++) {
			if (SKIP_URL[i].equals(uri)) {
				uurl = null;
				break;
			}
		}

		return uurl;
	}

	/**
	 * SE 가 있을 경우에 사용
	 */
	public int checkSsoId(HttpServletRequest request,
	HttpServletResponse response) throws Exception {
		int return_code = 0;

		return_code = CookieManager.readNexessCookie(request, response,
			NLS_DOMAIN);
		return return_code;
	}


//외부계정 사용자 정보를 가져오는 기능
	public String[] getSystemAccount(String sso_id) {	
		NXContext nx_context = null;
		NXUser nx_user = null;
		NXAccount nx_account = null;
		String[] strA = null;

        	nx_context = new NXContext(NLS_URL+":5480");  //@v1.1
		nx_user = new NXUser(nx_context);		


		try {
			nx_account = nx_user.getUserAccount(sso_id, SERVICE_NAME);					
			if(nx_account==null){
				strA = null;
			}else{			
				strA = new String[2];
				strA[0] = nx_account.getAccountName();
				strA[1] = nx_account.getAccountPassword();



			}
		} catch (APIException ae) {
			strA = null;
			//a
		}

		return strA;
	}

	public String getSsoDomain(HttpServletRequest request) throws Exception {
		String sso_domain = null;

		sso_domain = NLSHelper.getCookieDomain(request);
		return sso_domain;
	}
	
	//통합인증 세션을 체크 하기 위하여 사용되는 API
	/*
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response)
	{
		String retCode = "";
		NXContext context = null;
		try
		{
			context = getContext();						
			NXNLSAPI nxNLSAPI = new NXNLSAPI(context);
			retCode = nxNLSAPI.readNexessCookie(request, response, 0, 0); 
		}		
		catch(Exception npe) 
		{	
			np
		}	
		return retCode;		
	}
	*/

	// 2015.04.06 Nexess 4 통합인증 세션을 체크 하기 위하여 사용되는 API
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookie(request, response, 10, 360000, PROVIDER_LIST);
		} catch(Exception npe) {
		}
		return retCode;
	}

	/**
	* 20050901 추가 API 방식에서 장애 판단(SE 적용시 필요 없음)
	*/
	public boolean connectionTest(String host, int port){

		try{

			Socket c_socket = new Socket(host,port);

			return true;

		} catch(Exception ce){

			return false;
		}
	}
	
%>
