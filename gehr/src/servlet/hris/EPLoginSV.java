/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : ����α�������
/*   Program ID   : EPLoginSV.java
/*   Description  : ����α�������
/*   Note         : ����
/*   Creation     : 2005-09-26  ��α�
/*   Update       : 2005-10-20  lsa --sso���ü���returnUrl ���� �߰�
/*   Update       : 2005-10-26  portal & sso ��������......
/*                  2006-02-06  @v1.1 hr center/ �������๮���ǹ������� ���� �α��ν� returnurl���� ���Ѱܼ�����
/ *  			     2013-08-26  [CSR ID:2386689] �����ȳ� �������� �� �н����� �ۼ���Ģ �ݿ� C: 90�� �����ֱ� ���� �޼���, S: ����
/*                :  [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ����
					  [CSR ID:2591857] EPLoginSV.java ���� ����
/*                :  2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
/********************************************************************************/

package servlet.hris;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.EPLoginData;
import hris.N.AES.AESgenerUtil;
import hris.N.EHRCommonUtil;
import hris.N.WebAccessLog;
import hris.common.LoginResultData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.EmpListRFC;
import hris.common.rfc.GetPasswordRFC;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Locale;

public class EPLoginSV extends EHRBaseServlet {

    /**
     * ���� ó����
     * @param epLoginData
     */
    private void commonProcess(EPLoginData epLoginData) {
        //���� : �ް�,���ڱݵ�  �����ڵ尡 ���� ���  üũ
        if(StringUtils.isNotBlank(epLoginData.AINF_SEQN)){
            epLoginData.returnUrl = "Y";
            epLoginData.menuCode = "9999";
        }

//        $menuCode=1184$Year=$Moth= ��������
//        1221 �ϰ�����
        if(epLoginData.returnUrl.startsWith("OT") || epLoginData.returnUrl.startsWith("MW")){

            HashMap valueHM= EHRCommonUtil.dataConvert(epLoginData.returnUrl);
            epLoginData.menuCode = (String)valueHM.get("menuCode");
            epLoginData.year    = (String)valueHM.get("year");
            epLoginData.month = (String)valueHM.get("month");
            epLoginData.returnUrl ="Y";
        }
    }

    private String makeQueryStringFromEPLoginData(EPLoginData epLoginData, String ... args) {
        StringBuffer sb = new StringBuffer("?");

        for(String arg : args) {
            String value = Utils.getFieldValue(epLoginData, arg);

            if(StringUtils.isNotBlank(value)) {
                if (!sb.equals("?")) sb.append("&");
                sb.append(arg).append("=").append(value);
            }
        }

        return sb.toString();
    }

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{

            HttpSession session = req.getSession(true);
            Config conf         = new Configuration();
            //http://ehr.lgchem.com/servlet/servlet.hris.EPLoginSV?returnUrl=/help_online/rule.jsp?param=contents.html
           // http://devehr.lgchem.com8081/servlet/servlet.hris.EPLoginSV?returnUrl=/help_online/rule.jsp?param=contents.html
            Logger.debug.println(this, " EPLoginSV:*******************************************" );

          	/**
          	* ����� ����
          	*/
            Box box = WebUtil.getBox(req);
            EPLoginData epLoginData = box.createEntity(EPLoginData.class);

            //���
            epLoginData.system_id = (String)session.getAttribute("SYSTEM_ID");

            if("true".equals(epLoginData._login)) {
                session.removeAttribute("user");
                WebUtils.setSessionAttribute(req, SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME,
                        org.springframework.util.StringUtils.parseLocaleString(ServletRequestUtils.getStringParameter(req, "lang", Locale.getDefault().toString())));
            }

            epLoginData.SServer = StringUtils.defaultIfEmpty(epLoginData.SServer, conf.getString("portal.serverUrl"));

        	//���� ó�� �κ� - ���� �ް� ��
            commonProcess(epLoginData);

            Logger.debug.println(this, "[*epLoginData :" + epLoginData);

            //���ʷα��� SSO �������°�� local test �� ������ ��.
          	if(!WebUtil.isLocal(req) && epLoginData.system_id == null) {
                try {
                    String uurl = WebUtil.encode(req.getRequestURL() + makeQueryStringFromEPLoginData(epLoginData, "SServer", "returnUrl", "menuCode", "AINF_SEQN", "year", "month", "_view", "_login"));
                    //"?SServer="+SServer+"&returnUrl="+returnUrl+"&menuCode="+menuCode+"&AINF_SEQN="+AINF_SEQN+"&year="+year+"&month="+month+"&_view="+_view+"&_login="+_login);
                    Logger.debug.println(this, "[bb UURL:" + uurl);
                    res.sendRedirect(WebUtil.JspURL+"initech/sso/login_exec.jsp?UURL="+uurl);
                } catch ( Exception e ) {
                    Logger.error(e);
                }
                return;
          	}


//          EP ���� ���� check --------------------------------------------------------------------
            //������ ehr���ʷα���
            if (session == null || !isLogin(session ,epLoginData.system_id)) {
                performTask(req, res);
            } else {

                session.setAttribute("mainlogin","true");
                String dest = WebUtil.JspURL;

                //���ʷα����� ���� returnUrl = null ���� "" �� ����
                if(StringUtils.isBlank(epLoginData.returnUrl)) {
                    dest = dest + "main.jsp";
                } else {  //G���� �޴����� GBOX �ٷΰ���  �����
                    if("Y".equals(epLoginData.returnUrl)) {
                        dest = WebUtil.JspURL + "main.jsp" + makeQueryStringFromEPLoginData(epLoginData, "menuCode", "AINF_SEQN", "year", "month");
                        //menuCode="+menuCode+"&AINF_SEQN="+AINF_SEQN+"&year="+year+"&month="+month;
                    } else {
                        dest = WebUtil.JspURL + epLoginData.returnUrl;
                    }
                }

                Logger.debug.println(this ,"  before  dest =" + dest);

                printJspPage(req, res, dest.replace('^','&'));
            } // end if
        }catch(ConfigurationException e){
            Logger.debug.println(this, "perfromTesk���� �����߻�");
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            Config conf           = new Configuration();
            HttpSession session = req.getSession(true);

            String msg = ""; //[CSR ID:] ehr�ý�������༺���� ����

            Box box = WebUtil.getBox(req);
            WebUserData user = box.createEntity(WebUserData.class);
            final EPLoginData epLoginData = box.createEntity(EPLoginData.class);

            //���
            epLoginData.system_id = (String)session.getAttribute("SYSTEM_ID");
            user.empNo =  DataUtil.fixEndZero(epLoginData.system_id ,8);

            //test �� originEmpNo = "00202350";
            if (StringUtils.isBlank(epLoginData.system_id)) {
                msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                throw new GeneralException(msg);
            }

            /* sap���� ���� ���� */
            EmpListRFC empListRFC = new EmpListRFC(SAPType.LOCAL);
            if(!empListRFC.setSapType(req, user))
                throw new GeneralException("���� �� ������ �߻��Ͽ����ϴ�.");

            //���� ó�� �κ� - ���� �ް� ��
            commonProcess(epLoginData);


            epLoginData.system_id = DataUtil.fixEndZero(epLoginData.system_id, 8);

            //�����ȳ�,������ȳ� ��
            boolean isView = CollectionUtils.exists(Arrays.asList("rule.jsp", "help.jsp", "gbox_faq.jsp"), new Predicate() {
                public boolean evaluate(Object o) {
                    return StringUtils.indexOf(epLoginData.returnUrl, (String) o)  > 0;
                }
            });
            if(isView) epLoginData._view = "true";

            if("true".equals(epLoginData._view)) epLoginData.jobid = "login";

            //ó��
            if (StringUtils.isBlank(epLoginData.jobid)) {
                String dest = WebUtil.JspURL;

                //���ʷα���
                if(StringUtils.isBlank(epLoginData.returnUrl)) {
                    dest = dest + "N/ehrlogin/ehr_login.jsp?SServer=" + user.SServer;
                } else {
                    dest = dest + "N/ehrlogin/ehr_login.jsp" +
                            WebUtil.encode(makeQueryStringFromEPLoginData(epLoginData, "SServer", "returnUrl", "menuCode", "AINF_SEQN", "year", "month"));
                    //"SServer="user.SServer+"&returnUrl=" + returnUrl+"&menuCode="+menuCode+"&AINF_SEQN="+AINF_SEQN+"&year="+year+"&month="+month);
                }
                printJspPage(req, res, dest);
            } else  {
                LoginResultData loginResultData = new LoginResultData();
                //[CSR ID:2591857]

                if(epLoginData._view == null || !("true".equals(epLoginData._view))) {
	            	// [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ����
	                // ����� ���� ��й�ȣ�� �����´�.
			        //[CSR ID:2574807] Vector getUD = getPassword(originEmpNo);
                    loginResultData = getLoginYN(user);
			        //[CSR ID:2574807] String originPwd = getUD.get(0).toString();
			        // [CSR ID:2386689] �����ȳ� �������� �� �н����� �ۼ���Ģ �ݿ� C: 90�� �����ֱ� ���� �޼���, S: ����
                }


                if ("login".equals(epLoginData.jobid)) {

                    String dest = null;
                    //[CSR ID:2574807] if (originPwd.equals(webUserPwd) || _view != null && _view.equals("true")) {
                    if ("true".equals(epLoginData._view) || (loginResultData != null && loginResultData.isSuccess() )) {
                    	//  [CSR ID:2386689] �����ȳ� �������� �� �н����� �ۼ���Ģ �ݿ� C: 90�� �����ֱ� ���� �޼���, S: ����
                        //[CSR ID:2574807] if ( ( !originPwd.equals("INIT") &&  !pwdRtnCode.equals("C") ) || _view != null && _view.equals("true")) {
                    	if ( !"C".equals(loginResultData.MSGTY)  || "true".equals(epLoginData._view)) {
    			            Logger.debug.println(this ,"performTask jobid  LOGIN SUCESS");
                            PersonInfoRFC personInfoRFC        = new PersonInfoRFC(user.sapType);
                            PersonData personData;

                            personData = (PersonData)personInfoRFC.getPersonInfo(user.empNo, "X");

                            if(StringUtils.isNotBlank(personData.E_BUKRS)) {
                                user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");
                                user.login_stat       = "Y";

                                personInfoRFC.setSessionUserData(personData, user);

                                if(WebUtil.isLocal(req) && StringUtils.isBlank(user.e_area)) user.e_area = "41";

                                user.loginPlace       = "btn_eHR"; //ep���� �α������� �˸��� flag

                                WebUtil.setLang(WebUtil.getLangFromCookie(req), req, user);

                                user.locale = g.getLocale();
                                

                                // ����� ���� �׷� ����
                                //conn = DBUtil.getTransaction("HRIS");
                                //user.user_group =   (new CommonCodeDB(conn)).getAuthGroup(user.e_authorization);

                                //@v1.0 �޴����� db�� oracle���� sap�� �̰�
                                /*SysAuthGroupRFC rfc_Auth         = new SysAuthGroupRFC();
                                user.user_group = rfc_Auth.getAuthGroup(user.e_authorization);*/

                                DataUtil.fixNull(user);
                                session = req.getSession(true);
                                String remoteIP = req.getRemoteAddr();
                                session.setAttribute("remoteIP",remoteIP);
                                int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                                session.setMaxInactiveInterval(maxSessionTime);

                                if(StringUtils.isBlank(epLoginData._view)) {
                                    session.setAttribute("user",user);
                                    Logger.debug.println(this ,"EHR mainlogin");
                                    session.setAttribute("mainlogin","true");
                                } else {
                                    session.setAttribute("epuser",user);
                                    Logger.debug.println(this ,"epuser setAttribute");
                                }

                                if(StringUtils.isBlank(epLoginData.returnUrl)) {
                                	// Roll���� üũ ���� �߰� marco257 & �α��� ��� �߰� (RFC���� �۾�)
                                    (new WebAccessLog()).setRoleCheckLog(user.empNo, user.e_authorization);
                                    dest = WebUtil.JspURL + "main.jsp";

                                    // ��ȣȣ Ű session���� 2015-07-27
                                    AESgenerUtil cu = new AESgenerUtil();
                                    session.setAttribute("AESKEY",cu.getKey());
                                    //Logger.debug("::::::::::::::::::::::::::::::::::::::::::::::::::::     main.jsp ȣ�� :::::::::::::::::::::::::::::::::::::::::::::::::::::::");
                                	//dest = WebUtil.ServletURL + "hris.A.A01SelfDetailSV";
                                } else {
                                    // G �ڽ����� �α��� â�� ����  ȣ���Ұ�� ó�� 2015-07-30
                                    if(epLoginData.returnUrl.indexOf("servlet/") > 0) {
                                        dest = epLoginData.returnUrl;
                                    } else {
                                    	if(epLoginData.returnUrl.equals("Y")){
                                    		dest = WebUtil.JspURL + "main.jsp" + makeQueryStringFromEPLoginData(epLoginData, "menuCode", "AINF_SEQN", "year", "month");
                                            //?menuCode="+menuCode+"&AINF_SEQN="+AINF_SEQN+"&year="+year+"&month="+month;
                                    	}else{
	                                        dest = "/web" + epLoginData.returnUrl;
	                                        Logger.debug.println(this ," redirect.jsp 2  dest =" + dest);
                                    	}
                                    }
                                }
                                Logger.debug.println(this ,"user  :"+user.toString());

                            } else {
                                String url = "location.href='" + WebUtil.JspURL;

                                if(StringUtils.isBlank(epLoginData.returnUrl)) {
                                    url = url + "N/ehrlogin/ehr_login.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer + "';";
                                } else {
                                    url = url + "N/ehrlogin/ehr_login.jsp" +
                                            makeQueryStringFromEPLoginData(epLoginData, "SServer", "returnUrl", "menuCode", "AINF_SEQN", "year", "month") + "&SSNO=" + user.SSNO;
//                                            "?"+WebUtil.encode("SSNO=" + user.SSNO + "&SServer=" + user.SServer + "&returnUrl=" + returnUrl+"&menuCode="+menuCode+"&AINF_SEQN="+AINF_SEQN+"&year="+year+"&month="+month) + "';";
                                }
                                moveMsgPage(req, res, "���� �� ������ �߻��Ͽ����ϴ�.", url);
                            } // end if
                        } else {//passowrd �缳�� �ؾ� �ϴ� ���
    			            Logger.debug.println(this ,"performTask jobid  LOGIN SUCESS but...resetting!! pwdRtnCode : " + loginResultData.MSGTY+", pwdRtnMsg : "+loginResultData.MSGTX);
                        	/* [CSR ID:2574807]if ( originPwd.equals("INIT")  ) {
                        		msg = "��� ��ȣ�� �����ϼ��� .";
                        	}else if (   pwdRtnCode.equals("C")  ) {
                            	//  [CSR ID:2386689] �����ȳ� �������� �� �н����� �ۼ���Ģ �ݿ� C: 90�� �����ֱ� ���� �޼���, S: ����
                        		//msg = pwdRtnMsg;
                        		msg = "��й�ȣ �����ֱ�(90��)�� �������ϴ�.��� ��ȣ�� �����ϼ��� .";
                        	}else{*/
                        		msg = loginResultData.MSGTX;    // �޼��� �ڵ�� �����ؾ� �ҵ�
                        	//}

                            String url = "location.href='" + WebUtil.JspURL;

                            if(StringUtils.isBlank(epLoginData.returnUrl)) {
                                url = url + "N/ehrlogin/ehr_login.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer +"&MustPWChng=true';";
                            } else {
                                //url = url + "N/ehrlogin/ehr_login.jsp?"+WebUtil.encode("SSNO=" + user.SSNO + "&SServer=" + user.SServer +"&MustPWChng=true" + "&returnUrl=" + returnUrl) + "';";
                                url = url + "N/ehrlogin/ehr_login.jsp" +
                                        makeQueryStringFromEPLoginData(epLoginData, "SServer", "returnUrl", "menuCode", "AINF_SEQN", "year", "month") + "&MustPWChng=true&SSNO=" + user.SSNO;
//                                ""MustPWChng=true&" + WebUtil.encode("SSNO=" + user.SSNO + "&SServer=" + user.SServer +"&returnUrl=" + returnUrl+"&menuCode="+menuCode+"&AINF_SEQN="+AINF_SEQN+"&year="+year+"&month="+month) + "';";
                            }
                            Logger.debug.print(this ,"------**** msg : [" + msg + "] \t url : [" + url + "]");
//                            String url = "location.href='" + WebUtil.JspURL +"N/ehrlogin/ehr_login.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer +"&MustPWChng=true';";

                            moveMsgPage(req, res, msg, url);
                        } // end if
                    } else {
                       // if (originPwd == null || originPwd.length() < 1) {
                       //     Logger.debug.print(this ," �α��κ�й�ȣ��� : [" + originEmpNo + "] \t �н����� : [" + originPwd + "]");
                       //} // end if
                       // Logger.debug.print(this ,"1 �α��κ�й�ȣ��� : [" + originEmpNo + "] \t �н����� : [" + originPwd + "]");
                    	Logger.debug.print(this ,"1 �α��κ�й�ȣ��� : [" + user.empNo + "] \t �н�����msg : [" + loginResultData.MSGTX + "]");
                        //msg = "��й�ȣ�� Ʋ�Ƚ��ϴ�.";
                        msg = loginResultData.MSGTX;    // �޼��� �ڵ�� �����ؾ� �ҵ�

                        String url = "location.href='" + WebUtil.JspURL;

                        if(StringUtils.isBlank(epLoginData.returnUrl)) {
                            url = url + "N/ehrlogin/ehr_login.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer + "';";
                        } else {
                            url = url + "N/ehrlogin/ehr_login.jsp" + makeQueryStringFromEPLoginData(epLoginData, "SServer", "returnUrl", "menuCode", "AINF_SEQN", "year", "month");
                                    //"?SServer=" + user.SServer + "&returnUrl=" +  returnUrl +"&menuCode="+menuCode+"&AINF_SEQN="+AINF_SEQN+"&year="+year+"&month="+month+ "';";
                        }

                        moveMsgPage(req, res, msg, url);
                    } // end if

                    Logger.debug.println(this, "EPLoing Dest : " + dest);

                    // @v1.1 printJspPage(req, res, dest);
                    printJspPage(req, res, dest.replace('^','&'));

                } // end if
            } // end if
        }catch(Exception e){
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(conn ,isCommit);
        } // end try

    }

    // ��ȣȭ�� ����� �Ķ���ͷ� �޾Ƽ� ��������� �����Ѵ�. ""�� �����ϸ� ��ȿ���� ���� ����̴�
    private String calculateEmpNo(String secretEmpNo){
        try{
            String  originEmpNo     = "";
            String  firstDigit      = null;
            String  centerDigit     = null;
            String  lastDigit       = null;
            String  in_firstDigit   = null;
            String  in_centerDigit  = null;
            String  in_lastDigit    = null;
            long    d_centerDigit   = 0;
            //Logger.debug.println(this, "1 !!!secretEmpNo : " + secretEmpNo);
            // ���ڸ� �������� üũ
            // ÷���ڿ� �߰�, ������ ���ڸ� �и��Ѵ�.
            firstDigit  = secretEmpNo.substring( 0, 1 );
            centerDigit = secretEmpNo.substring( 1, (secretEmpNo.length() - 1) );
            lastDigit   = secretEmpNo.substring( (secretEmpNo.length() - 1), secretEmpNo.length() );
            //Logger.debug.println(this, "2 !!! lastDigit : " + lastDigit);
            //Logger.debug.println(this, "2 !!! getLastCharAfterSum(centerDigit) : " + getLastCharAfterSum(centerDigit));

            // ��� ���ڵ��� ���� 1�ڸ����� ������ ���ڶ� ������ Ȯ���Ѵ�
            if( ! lastDigit.equals( getLastCharAfterSum(centerDigit) ) ){
                return "";
            }
            //Logger.debug.println(this, "3 !!!d_centerDigit ������ �� : " + centerDigit);
            // ��� ���� ������ ���� ������. �̶� ������ ���������� Ȯ��...
            d_centerDigit = Long.parseLong(centerDigit);
            long modDigit = d_centerDigit % 33333;
            if( modDigit != 0) {
                return "";
            }
            d_centerDigit = d_centerDigit / 33333 ;
            centerDigit   = Long.toString(d_centerDigit);     // 33333���� ���������� �������
            //Logger.debug.println(this, "4 !!!33333���� ���������� �������centerDigit : " +centerDigit );

            // ���� �ٽ� ÷���ڿ� ������ ���ڷ� �и��ϰ�... ������ Ÿ������ �Ľ��Ѵ�.
            in_firstDigit  = centerDigit.substring( 0, 1 );
            in_centerDigit = centerDigit.substring( 1, (centerDigit.length() - 1) );
            in_lastDigit   = centerDigit.substring( (centerDigit.length() - 1), centerDigit.length() );
            //Logger.debug.println(this, "5 !!!firstDigit : " + firstDigit);
            //Logger.debug.println(this, "5 !!!in_firstDigit : " + in_firstDigit);

            // ���� ÷���ڰ� ��ȣȭ�� ���� ������ ÷���ڿ� ������ Ȯ���Ѵ�
            if( ! firstDigit.equals( in_firstDigit ) ){
                return "";
            }
            //Logger.debug.println(this, "6 !!!in_lastDigit : " + in_lastDigit);
            //Logger.debug.println(this, "6 !!! getLastCharAfterSum(in_centerDigit) ) : " +  getLastCharAfterSum(in_centerDigit) );
            // ��� ���ڵ��� ���� 1�ڸ����� ������ ���� ������ ��� ���� ����������� Ȯ���Ѵ�
            if( ! in_lastDigit.equals( getLastCharAfterSum(in_centerDigit) ) ){
                return "";
            } else {
                originEmpNo = in_centerDigit;
            }
            //Logger.debug.println(this, "7 !!!originEmpNo : " + originEmpNo);

            return originEmpNo;

        }catch(Exception ex){
            return "";
        }
    }

    // ���ڷ� ������ String�� �޾Ƽ� �� ���� 1�ڸ����� String Object�� �����Ѵ�
    private String getLastCharAfterSum(String centerDigit){

        String digit = centerDigit;
        int    sum   = 0 ;
        for(int i = 0 ; i < digit.length() ; i++ ){
            sum = sum + Integer.parseInt( digit.substring( i, i+1 ) );
        }
        String hap = Integer.toString(sum);
        return hap.substring( (hap.length()-1), hap.length() );
    }


    //  [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ����
    /**
     *
     * @param user
     * @return
     * @throws GeneralException
     */
    private LoginResultData getLoginYN(WebUserData user) throws GeneralException{
        GetPasswordRFC rfc = new GetPasswordRFC();
        return rfc.getLoginYN(user.empNo, user.webUserPwd);
    }

    protected boolean isLogin(HttpSession session ,String empNo)
    {
        hris.common.WebUserData user  = (hris.common.WebUserData)session.getAttribute("user");
//        Logger.debug.println(this ,"isLogin login_stat : " + user);
        if ( user == null || user.empNo == null || !user.empNo.equals(empNo) || !user.loginPlace.equals("btn_eHR")) {
            return false;
        } // end if
        String login_stat = user.login_stat;

        Logger.debug.println(this, "isLogin login_stat : " + login_stat);
        if ( login_stat == null || !login_stat.equals("Y") ) { return (false);  }
        else { return (true);   }

    }
}

