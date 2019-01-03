<%@page import="com.initech.eam.api.NXNLSAPI"%>
<%@page import="com.initech.eam.smartenforcer.SECode"%>
<%@page import="java.util.Vector"%>
<%@page import="com.initech.eam.nls.CookieManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.log4j.PropertyConfigurator"%>
<%@page import="com.initech.eam.api.NXContext"%>
<%!
/**[INISAFE NEXESS JAVA AGENT]**********************************************************************
* �����ý��� ���� ���� (���� ȯ�濡 �°� ����)
***************************************************************************************************/


/***[SERVICE CONFIGURATION]***********************************************************************
* �Ʒ� ������ ���ý��ۿ� �°� �����ϼ���.
***************************************************************************************************/
	private String SERVICE_NAME = "EHR";
	private String SERVER_URL 	= "http://marco.lgchem.com";
	private String SERVER_PORT = "8088";
	private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/web/N/login_exec.jsp";
/*************************************************************************************************/


/***[SSO CONFIGURATION]**]***********************************************************************
* 
* �Ʒ� ������ sso.lgchem.com�� �������� ���ð�
* ���߼������� �׽�Ʈ �ÿ��� ������ �������� PC hosts�� ������ �߰��� �ּ���
* ��� �ҽ��ڵ带 ��ġ ��Ű�� hosts ������ �����ؼ� �׽�Ʈ�� �����ϱ� �����Դϴ�.
* 
* #���� �׽�Ʈ�� ���
* 165.244.254.165   sso.lgchem.com
* 
***************************************************************************************************/
	private String NLS_URL 		 = "http://sso.lgchem.com";
	private String NLS_PORT 	 = "8001";
	private String NLS_LOGIN_URL = NLS_URL + ":" + NLS_PORT + "/nls3/clientLogin.jsp";
	private String NLS_LOGOUT_URL= NLS_URL + ":" + NLS_PORT + "/nls3/NCLogout.jsp";
	private String NLS_ERROR_URL = NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";
	private static String ND_URL1 = "http://sso.lgchem.com:5480";
	private static String ND_URL2 = "http://sso.lgchem.com:5480";

	private static Vector PROVIDER_LIST = new Vector();

	private static final int COOKIE_SESSTION_TIME_OUT = 3000000;

	// ���� Ÿ�� (ID/PW ��� : 1, ������ : 3)
	private String TOA = "1";
	private String SSO_DOMAIN = ".lgchem.com";

	private static final int timeout = 15000;
	private static NXContext context = null;
	static{
		List<String> serverurlList = new ArrayList<String>();
		serverurlList.add(ND_URL1);
		serverurlList.add(ND_URL2);

		context = new NXContext(serverurlList,timeout);
		CookieManager.setEncStatus(true);

		/***[PROVIDER_LIST]**]***********************************************************************
		* �̺κи� ���߰� ��� �޶����ϴ�.
		***************************************************************************************************/
		PROVIDER_LIST.add("ssodev.lgchem.com"); //����
		//PROVIDER_LIST.add("sso.lgchem.com"); //�
	}

	// ���� SSO ID ��ȸ
	public String getSsoId(HttpServletRequest request) {
		String sso_id = null;
		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
		return sso_id;
	}
	// ���� SSO �α��������� �̵�
	public void goLoginPage(HttpServletResponse response)throws Exception {
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
		response.sendRedirect(NLS_LOGIN_URL);
	}

	// �������� ������ üũ �ϱ� ���Ͽ� ���Ǵ� API
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSTION_TIME_OUT,PROVIDER_LIST);
		} catch(Exception npe) {
		}
		return retCode;
	}

	// SSO ���������� URL
	public void goErrorPage(HttpServletResponse response, int error_code)throws Exception {
		//CookieManager.removeNexessCookie(SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}

%>
