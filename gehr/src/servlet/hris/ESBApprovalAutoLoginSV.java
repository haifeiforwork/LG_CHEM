/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  : Work Center
/*   2Depth Name  : ���ڰ��� > ������ȸ
/*   Program Name : ELOFFICE�� ���ڰ����� ���CLICK�� ����
/*   Program ID   : ESBApprovalAutoLoginSV.java
/*   Description  : ���ڰ���(������/�����߹������� ����)
/*   Note         : ����
/*   Creation     :
/*   Update       : 2006-05-17  @v1.1 requestName:���ڰ����ĺ������� ���ư������� ó���� ���� ����
/*                :  2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
/*			            2017-05-25 eunha [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ  */
/********************************************************************************/
package servlet.hris;

import com.common.Utils;
import com.initech.eam.api.*;
import com.initech.eam.base.APIException;
import com.initech.eam.base.EmptyResultException;
import com.initech.eam.nls.CookieManager;
import com.initech.eam.smartenforcer.SECode;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.G.rfc.ApprovalHeaderRFC;
import hris.common.EmpData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineInput;
import hris.common.approval.ApprovalLineRFC;
import hris.common.rfc.EmpListRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.DocumentInfo;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

public class ESBApprovalAutoLoginSV extends EHRBaseServlet
{

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            performTask(req, res);
        }catch(GeneralException e){
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection conn = null;
        boolean isCommit = false;
        String dest;

        try{
            HttpSession session = req.getSession(true);

//          EP ���� ���� check --------------------------------------------------------------------
          	String now_url = req.getRequestURL().toString();
          	Logger.debug.println("\n------------------------------- now_url : "+now_url);
//          	String uurl = WebUtil.encode(now_url);

          	/**
          	 * 1.�����ؾ��� ����
				���Ž� : http://legacy.lgchem.com/test.jsp?appint=R
				���հ���: http://uapproval.lgchem.com:7010/lgchem/front.appint.cmd.RetrieveAppintDoListCmd.lgc?tar=3

				2.������������ ����
				���Ž� : http://legacy.lgchem.com/test.jsp?appint=M
				���հ���:http://uapproval.lgchem.com:7010/lgchem/front.appint.cmd.RetrieveAppintIngDocListCmd.lgc?tar=4

				3.����Ϸ� ����
				���Ž� : http://legacy.lgchem.com/test.jsp?appint=F
				���հ���:http://uapproval.lgchem.com:7010/lgchem/front.appint.cmd.RetrieveAppintEndDocListCmd.lgc?tar=5

				4.���� ����Ϸ� ����
				���Ž� : http://legacy.lgchem.com/test.jsp?appint=TF
				���հ���:http://uapproval.lgchem.com:7010/lgchem/front.appint.cmd.RetrieveAppintTodayDocListCmd.lgc?tar=2

				5.�ۼ����� ����
				���Ž� : http://legacy.lgchem.com/test.jsp?appint=W
				���հ���:http://uapproval.lgchem.com:7010/lgchem/approval.front.document.RetrieveMyIngDocListCmd.lgc?tar=9
          	 */
          	String appint = (String)req.getParameter("appint");
          	String appint_url = (String)req.getParameter("appint_url");

          	/**
          	* ����� ����
          	*/
          	//����� ���� ���̵�
          	String sso_id    = (String)session.getAttribute("SSO_ID");

            //_login=true�̸� session ����
          	String _login = (String)req.getParameter("_login") == null ? "" : (String)req.getParameter("_login");
          	String _view = (String)req.getParameter("_view") == null ? "" : (String)req.getParameter("_view");

          	if(_login.equals("true"))
            {
//          	    session.invalidate();
              	    session.removeAttribute("user");
              	    Logger.debug.println(this, "[EHR]user:" + session.getAttribute("user"));
            }
          	//���
          	String system_id = (String)session.getAttribute("SYSTEM_ID");
          	String returnUrl = (String)req.getParameter("returnUrl");
          	String SServer   = (String)req.getParameter("SServer");
          	String AINF_SEQN    = (String)req.getParameter("AINF_SEQN");
            String msg = ""; //[CSR ID:] ehr�ý�������༺���� ����
            if(AINF_SEQN.length() > 0)
            {
                if(AINF_SEQN.indexOf("?eHR=") > 0)
                	AINF_SEQN = AINF_SEQN.substring(0,10)  ;
            }

            /* SSO �α׺κ� ���� */
            /*try {
                String encF = CookieManager.getCookieValue("InitechEamCookieEnc", req);

                Logger.debug.println(this, "[encF]:" + encF);
                if ("T".equals(encF)) {
                    CookieManager.setEncStatus(true);
                } else {
                    CookieManager.setEncStatus(false);
                }

                Logger.debug.println(this, "[SECode.USER_ID]:" + CookieManager.getCookieValue(SECode.USER_ID, req));

                Cookie[] cookies = req.getCookies();

                if(cookies != null) {
                    for(Cookie cookie : cookies) {
                        Logger.debug.println(this, "cookie [" + cookie.getName() + "] : " + cookie.getValue());
                    }
                }

                Logger.debug.println(this, "getSsoId(req) : " + getSsoId(req));

                //4.��Ű ��ȿ�� Ȯ�� :0(����)
                String retCode = getEamSessionCheck(req,res);
                Logger.debug.println(this, "========= retCode : " + retCode);


            } catch (Exception e) {
                Logger.error(e);
            }*/
            /* SSO �α׺κ� �� */

            Logger.debug.println(this, "[bb system_id:" + system_id);
            Logger.debug.println(this, "[bb sso_id:" + sso_id);
          	Logger.debug.println(this, "[bb returnUrl:" + returnUrl);
          	Logger.debug.println(this, "[bb SServer:" + SServer);
          	Logger.debug.println(this, "[bb AINF_SEQN:" + AINF_SEQN);
          	Logger.debug.println("\n------------------------------- system_id : "+system_id);

          	 //system_id="00202350";
          	// sso_id="kyuyong";

            /*Cookie[] cookies = req.getCookies();

            if(cookies != null) {
                for(Cookie cookie : cookies) {
                    Logger.debug.println(this, "cookie [" + cookie.getName() + "] : " + cookie.getValue());

                    if("tempLGDPID".equals(cookie.getName() )) {
                        String userId = cookie.getValue();
                    }

                }
            }*/

//          ���ʷα��� �������°��
          	if (system_id == null) {

                system_id = getUserExField(getSsoId(req), "SASABUNNEW"); //SSO�� ���� ������� ��ȸ
                Logger.debug.println(this, "getUserExField : " + system_id);

          	   /* *//* �ٽ� �ѹ� �����´� *//*
                String[] sso_data = getSystemAccount(getSsoId(req));

                Logger.debug.println(this, "sso_data[] : " + sso_data);
                if (sso_data != null) {
                    //4.1. �ܺΰ��� ������ �ִ� ��� ó��
                    system_id = sso_data[0];
                    Logger.debug.println(this, "sso_data != null system_id : " + system_id);
                }*/

                /* �׷��� ������ SSO �α��� �������� �̵� �Ѵ� */
                if (system_id == null) {
                    try {
                        String uurl = WebUtil.encode(now_url + "?AINF_SEQN=" + AINF_SEQN + "&appint=" + appint + "&appint_url" + appint_url + "&SServer=" + SServer + "&returnUrl=" + returnUrl + "&_view=" + _view + "&_login=" + _login);
                        Logger.debug.println(this, "[bb UURL:" + uurl);
                        res.sendRedirect(WebUtil.JspURL + "/initech/sso/login_exec.jsp?UURL=" + uurl);
                        Logger.debug.println(this, "[bb  session SServer: " + SServer + "uurl:" + uurl);

                    } catch (Exception e) {
                    }
                    return;
                }
          	}

            system_id = DataUtil.fixEndZero(system_id, 8);

            Logger.debug.println("\n------------------------------- ������� ���� ---------AINF_SEQN--"+AINF_SEQN);



            WebUserData user = new WebUserData();

            Box box = WebUtil.getBox(req);

          	Logger.debug.println("\n------------------------------- ������� ���� -2--------box--"+box.toString());

            //����
           //SServer   = "epdev.lgchem.com:8101";


			Config conf  = new Configuration();
            //�
            //SServer   = "portal.lgchem.com";
			SServer   = conf.getString("portal.serverUrl");

            boolean isNotApp   = box.getBoolean("isNotApp");
            if(appint !=null && appint.equals("M")){
            	isNotApp = true;
            }else{
            	isNotApp = false;
            }
            user.empNo = DataUtil.convertEmpNo(system_id);

            Logger.debug.println( this ," appint = " + appint  );
            Logger.debug.println( this ," emppNo = " + user.empNo  );

            Logger.debug.println( this ,"portal.serverUr    SServer = " +  SServer );

            Logger.debug.println( this ,"     AINF_SEQN = " + AINF_SEQN+", isNotApp:"+isNotApp);
            //@v1.1 06.05.17 ���ڰ���frame���� ��� �������� ����

            String returnPage = "http://uapproval.lgchem.com:7010/lgchem/front.appint.cmd.RetrieveAppintMainDocListCmd.lgc?tar=2";
            if(appint_url!=null){
            	if(!appint_url.equals("null")){
            		returnPage = appint_url;
            	}
            }
            Logger.debug.println("\n--------------- ESB   AINF_SEQN : "+AINF_SEQN+"\nempNo : "+user.empNo+"\nreturnPage : "+returnPage+"\nisNotApp : "+isNotApp);


/*
            ��ġ���� - �α��� �� �󼼷�
            String detailPage = makeDetailPageURL(AINF_SEQN ,empNo ,returnPage ,isNotApp);
*/

            Logger.debug.println(this ,"returnPage:"+returnPage);

            try{
                EmpListRFC empListRFC = new EmpListRFC(SAPType.LOCAL);
                Vector<EmpData> empList = empListRFC.getEmpList(user.empNo);

                /* sap���� ���� ���� */
                if (!empListRFC.setSapType(req, user))
                    throw new GeneralException(g.getMessage("MSG.COMMON.0085"));

                /**
                 * ����� 2�� �̻��� ��� ��� ����� ���������� �����ȣ�� ������
                 */
                if(Utils.getSize(empList) > 1 && StringUtils.isNotBlank(AINF_SEQN)) {
                    if("7".equals(StringUtils.substring(AINF_SEQN, 0, 1))) user.sapType = SAPType.GLOBAL;
                    else user.sapType = SAPType.LOCAL;

                    String empNoResult = getEmpNo(user, AINF_SEQN, empList);
                    if(empNoResult == null && user.sapType == SAPType.LOCAL) {
                        user.sapType = SAPType.GLOBAL;
                        empNoResult = getEmpNo(user, AINF_SEQN, empList);
                    }

                    if(StringUtils.isNotBlank(empNoResult)) {
                        user.empNo = empNoResult;
                    } else {
                        /* ���� �ؿ� ��� ���� ���� ���� ������ȣ�� ���� ���� �ؿܸ� ���� */
                        if("7".equals(StringUtils.substring(AINF_SEQN, 0, 1))) user.sapType = SAPType.GLOBAL;
                        else user.sapType = SAPType.LOCAL;
                    }
                }


               /* if("7".equals(StringUtils.substring(AINF_SEQN, 0, 1))) {
                *//* sap���� ���� ���� *//*
                    user.sapType = SAPType.GLOBAL;
                } else {
                *//* sap�� if (!empListRFC.setSapType(req, user))�� ���� ���� *//*

                        throw new GeneralException(g.getMessage("MSG.COMMON.0085"));

                }*/

                PersonInfoRFC personInfoRFC        = new PersonInfoRFC(user.sapType);
                PersonData personData   = new PersonData();
                personData = (PersonData)personInfoRFC.getPersonInfo(user.empNo, "X");
                if( personData.E_BUKRS == null|| personData.E_BUKRS.equals("") ) {

                    //String msg = "�����ȣ�� Ȯ���Ͽ� �ֽʽÿ�.";
                    msg = g.getMessage("MSG.COMMON.0085");//"���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                    String url = "histroy.back(-1);";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest =  WebUtil.JspURL +"common/msg.jsp";
                } else {

                    //Config conf           = new Configuration();
                    user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                    user.login_stat       = "Y";

                    /* ���� */
                    personInfoRFC.setSessionUserData(personData, user);

                    /* ��� ���� */
                    WebUtil.setLang(WebUtil.getLangFromCookie(req), req, user);
                    /* ��� ���� */

                    user.loginPlace       = "ElOffice";
                    /*user.empNo            = empNo;*/
                    user.SServer          = SServer;

                    // Logger.debug.println(this ,user);
                    // ����� ���� �׷� ����
                    // user.e_authorization = "ALL";
                    //conn = DBUtil.getTransaction("HRIS");
                    //user.user_group =   (new CommonCodeDB(conn)).getAuthGroup(user.e_authorization);

                    //@v1.0 �޴����� db�� oracle���� sap�� �̰�
                    /*SysAuthGroupRFC rfc_Auth         = new SysAuthGroupRFC();
                    user.user_group = rfc_Auth.getAuthGroup(user.e_authorization);*/

                    isCommit = true;

                    DataUtil.fixNull(user);
                    session = req.getSession(true);

                    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                    session.setMaxInactiveInterval(maxSessionTime);
                    session.setAttribute("user",user);

                    String detailPage = makeDetailPageURL(AINF_SEQN ,user.empNo ,returnPage ,isNotApp);

                    if (detailPage == null ||  detailPage.equals("")) {
                        //String msg = " �ش� ������ ���� �� �� �����ϴ�.";
                        msg = g.getMessage("MSG.COMMON.0085"); //[CSR ID:] ehr�ý�������༺���� ����
                        String url = "history.back(-1);";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        dest =  WebUtil.JspURL +"common/msg.jsp";
                    } else {
                        req.setAttribute("url","location.href = '" + detailPage +  "';");
                        dest =  WebUtil.JspURL +"common/msg.jsp";
                    }

                } // end if
            }catch(Exception ex){
                Logger.err.println(this,"Data Not Found");
                //String msg = "���� �� ������ �߻��Ͽ����ϴ�.";
                msg = g.getMessage("MSG.COMMON.0085"); //[CSR ID:] ehr�ý�������༺���� ����
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest =  WebUtil.JspURL +"common/msg.jsp";
            } // end try & catch
            printJspPage(req, res, dest);
        }catch(Exception ConfigurationException){
            Logger.error(ConfigurationException);
            Logger.err.println(this,"Data Not Found");
            String msg = g.getMessage("MSG.COMMON.0085");
            String url = "history.back();";
            req.setAttribute("msg", msg);
            req.setAttribute("url", url);
            dest =  WebUtil.JspURL +"common/msg.jsp";
            printJspPage(req, res, dest);
        } finally {
            //DBUtil.close(conn ,isCommit);
        } // end try
    }


    private String makeDetailPageURL(String AINF_SEQN ,String empNo ,String requestName,boolean isNotApp) throws GeneralException {

        StringBuffer detailPage = new StringBuffer(256);
        // ���� ������ ����

        DocumentInfo docInfo = new DocumentInfo(AINF_SEQN ,empNo ,isNotApp);
        if (!docInfo.isHaveAuth()) {
            Logger.info.println(this ,empNo + "�� " + AINF_SEQN + " ������ ������ �� �����ϴ�");
            return null;
        } // end if
        /*
        EmpNO + is AINF_SEQN+ " Cannot access to document"
        empNo + "������?" + AINF_SEQN + "����
         */

        /*return WebUtil.makeGotoUrl(docInfo.getUPMU_TYPE() ,docInfo.getType() ,AINF_SEQN ,requestName);*/
        return WebUtil.approvalMappingURL(docInfo, AINF_SEQN, requestName);
    }

    private String getEmpNo(WebUserData user, String AINF_SEQN, Vector<EmpData> empList) {
        try {

            EmpListRFC empListRFC = new EmpListRFC(user.sapType);

            ApprovalHeaderRFC approvalHeaderRFC = new ApprovalHeaderRFC(user.sapType);

            ApprovalHeader header = null;

            header = approvalHeaderRFC.getApprovalHeader(AINF_SEQN, user.empNo);

            /* ��û�� ���� Ȯ�� */
            EmpData empData = empListRFC.findEmpData(empList, header.PERNR);

            if(empData != null) {
                return empData.PERNR;
            } else {
                /* ������ ���� Ȯ�� */
                ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC(user.sapType);
                Vector<ApprovalLineData> approvalLienList = approvalLineRFC.getApprovalLine(new ApprovalLineInput(AINF_SEQN));

                for(ApprovalLineData row : approvalLienList) {
                    empData = empListRFC.findEmpData(empList, row.APPU_NUMB);
                    if(empData != null) {
                        return empData.PERNR;
                    }
                }
            }

            /* ������ο� ���� ��� �ؿ��� ��� �ؿ� ��� ����*/
            if(user.sapType == SAPType.GLOBAL) {
                for(EmpData row : empList) {
                    if("2".equals(row.PFLAG)) return row.PERNR;
                }
            }

        } catch (GeneralException e) {
            Logger.error(e);
        }

        return null;
    }


    private static final int COOKIE_SESSTION_TIME_OUT = 3000000;
    public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response){
        String retCode = "";
        Vector PROVIDER_LIST = new Vector();
        try {
            retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSTION_TIME_OUT,PROVIDER_LIST);
        } catch(Exception npe) {
            Logger.error(npe);
        }
        return retCode;
    }

    private static String NLS_URL = "http://sso.lgchem.com";
    private String SERVICE_NAME = "EHRS";
    public String[] getSystemAccount(String sso_id) {
        NXContext nx_context = null;
        NXUser nx_user = null;
        NXAccount nx_account = null;
        String[] strA = null;

        try {
            nx_context = new NXContext(NLS_URL+":5480");  //@v1.1
            nx_user = new NXUser(nx_context);

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
            Logger.error(ae);
            //a
        }

        return strA;
    }

    static private NXContext context = null;

    public NXContext getContext()
    {
        try
        {
            List serverurlList = new ArrayList();
            serverurlList.add("http://sso.lgchem.com:5480/");

            context = new NXContext(serverurlList);
        }
        catch (Exception e)
        {
			//[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
        	//System.out.println("==>" + e.toString() + "<===getContext<br>");
            //e.printStackTrace();
        	Logger.err.println(DataUtil.getStackTrace(e));
			//[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ  end
        }
        return context;
    }

    public String getSsoId(HttpServletRequest request) {
        String sso_id = null;
        sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
        return sso_id;
    }

    public String getUserExField(String userid, String exName) throws Exception {
        if(userid==null||userid.length()<1) return null;

        NXContext context = null;
        NXExternalField nxef = null;
        String returnValue = null;

        try {
            context = getContext();
            NXUserAPI userAPI = new NXUserAPI(context);
            nxef = userAPI.getUserExternalField(userid, exName);
            returnValue = (String) nxef.getValue();
        } catch (EmptyResultException e) {
            Logger.error(e);
        } catch (IllegalArgumentException e) {
            Logger.error(e);
        }
        return returnValue;
    }


}