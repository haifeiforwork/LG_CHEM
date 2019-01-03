/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : 사원로그인정보
/*   Program ID   : EPLoginSV.java
/*   Description  : 사원로그인정보
/*   Note         : 없음
/*   Creation     : 2005-09-26  배민규
/*   Update       : 2005-10-20  lsa --sso관련수정returnUrl 로직 추가
/*   Update       : 2005-10-26  portal & sso 연계위해......
/*                  2006-02-06  @v1.1 hr center/ 결재진행문서의문서에서 최초 로그인시 returnurl값을 못넘겨수정함
/ *  			     2013-08-26  [CSR ID:2386689] 제도안내 문구변경 및 패스워드 작성규칙 반영 C: 90일 변경주기 도래 메세지, S: 정상
/*                :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정
					  [CSR ID:2591857] EPLoginSV.java 파일 수정
/*                :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
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
     * 공통 처리자
     * @param epLoginData
     */
    private void commonProcess(EPLoginData epLoginData) {
        //메일 : 휴가,학자금등  결재코드가 있을 경우  체크
        if(StringUtils.isNotBlank(epLoginData.AINF_SEQN)){
            epLoginData.returnUrl = "Y";
            epLoginData.menuCode = "9999";
        }

//        $menuCode=1184$Year=$Moth= 월간근태
//        1221 일간근태
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
          	* 사용자 정보
          	*/
            Box box = WebUtil.getBox(req);
            EPLoginData epLoginData = box.createEntity(EPLoginData.class);

            //사번
            epLoginData.system_id = (String)session.getAttribute("SYSTEM_ID");

            if("true".equals(epLoginData._login)) {
                session.removeAttribute("user");
                WebUtils.setSessionAttribute(req, SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME,
                        org.springframework.util.StringUtils.parseLocaleString(ServletRequestUtils.getStringParameter(req, "lang", Locale.getDefault().toString())));
            }

            epLoginData.SServer = StringUtils.defaultIfEmpty(epLoginData.SServer, conf.getString("portal.serverUrl"));

        	//공토 처리 부분 - 근태 휴가 등
            commonProcess(epLoginData);

            Logger.debug.println(this, "[*epLoginData :" + epLoginData);

            //최초로그인 SSO 인증없는경우 local test 시 지워야 함.
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


//          EP 통합 인증 check --------------------------------------------------------------------
            //인증후 ehr최초로그인
            if (session == null || !isLogin(session ,epLoginData.system_id)) {
                performTask(req, res);
            } else {

                session.setAttribute("mainlogin","true");
                String dest = WebUtil.JspURL;

                //최초로그인후 연결 returnUrl = null 에서 "" 로 변경
                if(StringUtils.isBlank(epLoginData.returnUrl)) {
                    dest = dest + "main.jsp";
                } else {  //G포털 메뉴에서 GBOX 바로가기  연결시
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
            Logger.debug.println(this, "perfromTesk에서 에러발생");
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            Config conf           = new Configuration();
            HttpSession session = req.getSession(true);

            String msg = ""; //[CSR ID:] ehr시스템웹취약성진단 수정

            Box box = WebUtil.getBox(req);
            WebUserData user = box.createEntity(WebUserData.class);
            final EPLoginData epLoginData = box.createEntity(EPLoginData.class);

            //사번
            epLoginData.system_id = (String)session.getAttribute("SYSTEM_ID");
            user.empNo =  DataUtil.fixEndZero(epLoginData.system_id ,8);

            //test 시 originEmpNo = "00202350";
            if (StringUtils.isBlank(epLoginData.system_id)) {
                msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                throw new GeneralException(msg);
            }

            /* sap연결 정보 셋팅 */
            EmpListRFC empListRFC = new EmpListRFC(SAPType.LOCAL);
            if(!empListRFC.setSapType(req, user))
                throw new GeneralException("접속 중 오류가 발생하였습니다.");

            //공토 처리 부분 - 근태 휴가 등
            commonProcess(epLoginData);


            epLoginData.system_id = DataUtil.fixEndZero(epLoginData.system_id, 8);

            //제도안내,사용방법안내 등
            boolean isView = CollectionUtils.exists(Arrays.asList("rule.jsp", "help.jsp", "gbox_faq.jsp"), new Predicate() {
                public boolean evaluate(Object o) {
                    return StringUtils.indexOf(epLoginData.returnUrl, (String) o)  > 0;
                }
            });
            if(isView) epLoginData._view = "true";

            if("true".equals(epLoginData._view)) epLoginData.jobid = "login";

            //처음
            if (StringUtils.isBlank(epLoginData.jobid)) {
                String dest = WebUtil.JspURL;

                //최초로그인
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
	            	// [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정
	                // 사번에 대한 비밀번호를 가져온다.
			        //[CSR ID:2574807] Vector getUD = getPassword(originEmpNo);
                    loginResultData = getLoginYN(user);
			        //[CSR ID:2574807] String originPwd = getUD.get(0).toString();
			        // [CSR ID:2386689] 제도안내 문구변경 및 패스워드 작성규칙 반영 C: 90일 변경주기 도래 메세지, S: 정상
                }


                if ("login".equals(epLoginData.jobid)) {

                    String dest = null;
                    //[CSR ID:2574807] if (originPwd.equals(webUserPwd) || _view != null && _view.equals("true")) {
                    if ("true".equals(epLoginData._view) || (loginResultData != null && loginResultData.isSuccess() )) {
                    	//  [CSR ID:2386689] 제도안내 문구변경 및 패스워드 작성규칙 반영 C: 90일 변경주기 도래 메세지, S: 정상
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

                                user.loginPlace       = "btn_eHR"; //ep통한 로그인임을 알리는 flag

                                WebUtil.setLang(WebUtil.getLangFromCookie(req), req, user);

                                user.locale = g.getLocale();
                                

                                // 사용자 권한 그룹 설정
                                //conn = DBUtil.getTransaction("HRIS");
                                //user.user_group =   (new CommonCodeDB(conn)).getAuthGroup(user.e_authorization);

                                //@v1.0 메뉴관련 db를 oracle에서 sap로 이관
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
                                	// Roll권한 체크 로직 추가 marco257 & 로그인 기록 추가 (RFC에서 작업)
                                    (new WebAccessLog()).setRoleCheckLog(user.empNo, user.e_authorization);
                                    dest = WebUtil.JspURL + "main.jsp";

                                    // 암호호 키 session저장 2015-07-27
                                    AESgenerUtil cu = new AESgenerUtil();
                                    session.setAttribute("AESKEY",cu.getKey());
                                    //Logger.debug("::::::::::::::::::::::::::::::::::::::::::::::::::::     main.jsp 호츨 :::::::::::::::::::::::::::::::::::::::::::::::::::::::");
                                	//dest = WebUtil.ServletURL + "hris.A.A01SelfDetailSV";
                                } else {
                                    // G 박스에서 로그인 창을 거쳐  호출할경우 처리 2015-07-30
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
                                moveMsgPage(req, res, "접속 중 오류가 발생하였습니다.", url);
                            } // end if
                        } else {//passowrd 재설정 해야 하는 경우
    			            Logger.debug.println(this ,"performTask jobid  LOGIN SUCESS but...resetting!! pwdRtnCode : " + loginResultData.MSGTY+", pwdRtnMsg : "+loginResultData.MSGTX);
                        	/* [CSR ID:2574807]if ( originPwd.equals("INIT")  ) {
                        		msg = "비밀 번호를 수정하세요 .";
                        	}else if (   pwdRtnCode.equals("C")  ) {
                            	//  [CSR ID:2386689] 제도안내 문구변경 및 패스워드 작성규칙 반영 C: 90일 변경주기 도래 메세지, S: 정상
                        		//msg = pwdRtnMsg;
                        		msg = "비밀번호 변경주기(90일)가 지났습니다.비밀 번호를 수정하세요 .";
                        	}else{*/
                        		msg = loginResultData.MSGTX;    // 메세지 코드로 변경해야 할듯
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
                       //     Logger.debug.print(this ," 로그인비밀번호사번 : [" + originEmpNo + "] \t 패스워드 : [" + originPwd + "]");
                       //} // end if
                       // Logger.debug.print(this ,"1 로그인비밀번호사번 : [" + originEmpNo + "] \t 패스워드 : [" + originPwd + "]");
                    	Logger.debug.print(this ,"1 로그인비밀번호사번 : [" + user.empNo + "] \t 패스워드msg : [" + loginResultData.MSGTX + "]");
                        //msg = "비밀번호가 틀렸습니다.";
                        msg = loginResultData.MSGTX;    // 메세지 코드로 변경해야 할듯

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

    // 암호화된 사번을 파라미터로 받아서 원래사번을 리턴한다. ""을 리턴하면 유효하지 않은 사번이다
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
            // 숫자만 들어오는지 체크
            // 첨숫자와 중간, 마지막 숫자를 분리한다.
            firstDigit  = secretEmpNo.substring( 0, 1 );
            centerDigit = secretEmpNo.substring( 1, (secretEmpNo.length() - 1) );
            lastDigit   = secretEmpNo.substring( (secretEmpNo.length() - 1), secretEmpNo.length() );
            //Logger.debug.println(this, "2 !!! lastDigit : " + lastDigit);
            //Logger.debug.println(this, "2 !!! getLastCharAfterSum(centerDigit) : " + getLastCharAfterSum(centerDigit));

            // 가운데 숫자들의 합의 1자리수가 마지막 숫자랑 같은지 확인한다
            if( ! lastDigit.equals( getLastCharAfterSum(centerDigit) ) ){
                return "";
            }
            //Logger.debug.println(this, "3 !!!d_centerDigit 나뉘기 전 : " + centerDigit);
            // 가운데 수를 정해진 수로 나눈다. 이때 나누어 떨어지는지 확인...
            d_centerDigit = Long.parseLong(centerDigit);
            long modDigit = d_centerDigit % 33333;
            if( modDigit != 0) {
                return "";
            }
            d_centerDigit = d_centerDigit / 33333 ;
            centerDigit   = Long.toString(d_centerDigit);     // 33333으로 나눠진후의 가운데숫자
            //Logger.debug.println(this, "4 !!!33333으로 나눠진후의 가운데숫자centerDigit : " +centerDigit );

            // 몫을 다시 첨숫자와 마지막 숫자로 분리하고... 데이터 타입으로 파싱한다.
            in_firstDigit  = centerDigit.substring( 0, 1 );
            in_centerDigit = centerDigit.substring( 1, (centerDigit.length() - 1) );
            in_lastDigit   = centerDigit.substring( (centerDigit.length() - 1), centerDigit.length() );
            //Logger.debug.println(this, "5 !!!firstDigit : " + firstDigit);
            //Logger.debug.println(this, "5 !!!in_firstDigit : " + in_firstDigit);

            // 몫의 첨숫자가 암호화된 이전 숫자의 첨숫자와 같은지 확인한다
            if( ! firstDigit.equals( in_firstDigit ) ){
                return "";
            }
            //Logger.debug.println(this, "6 !!!in_lastDigit : " + in_lastDigit);
            //Logger.debug.println(this, "6 !!! getLastCharAfterSum(in_centerDigit) ) : " +  getLastCharAfterSum(in_centerDigit) );
            // 가운데 숫자들의 합의 1자리수가 마지막 수랑 같으면 가운데 수를 원래사번으로 확정한다
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

    // 숫자로 구성된 String을 받아서 그 합의 1자리수를 String Object로 리턴한다
    private String getLastCharAfterSum(String centerDigit){

        String digit = centerDigit;
        int    sum   = 0 ;
        for(int i = 0 ; i < digit.length() ; i++ ){
            sum = sum + Integer.parseInt( digit.substring( i, i+1 ) );
        }
        String hap = Integer.toString(sum);
        return hap.substring( (hap.length()-1), hap.length() );
    }


    //  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정
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

