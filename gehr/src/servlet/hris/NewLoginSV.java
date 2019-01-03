/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : 비밀번호 변경
/*   Program ID   : NewLoginSV.java
/*   Description  : 사원로그인정보
/*   Note         : 없음
/*   Creation     : 2005-09-26  배민규
/*   Update       : 2005-10-20  lsa --sso관련수정returnUrl 로직 추가
/*                :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정
/*                :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
/********************************************************************************/
package servlet.hris;

import com.sns.jdf.*;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.ChangePasswordResultData;
import hris.common.WebUserData;
import hris.common.rfc.ChgPasswordRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;

public class NewLoginSV extends EHRBaseServlet
{

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(true);
            Config conf         = new Configuration();

//          EP 통합 인증 check --------------------------------------------------------------------
          	String now_url = req.getRequestURL().toString();

          	String uurl = WebUtil.encode(now_url) ;

          	/**
          	* 사용자 정보
          	*/
          	//사용자 통합 아이디
          	String sso_id    = (String)session.getAttribute("SSO_ID");
          	//사번
          	String system_id = (String)session.getAttribute("SYSTEM_ID");
          	String returnUrl = (String)req.getParameter("returnUrl");
          	String SServer   = (String)req.getParameter("SServer");

            Logger.debug.println(this, "[bb system_id:" + system_id);
            Logger.debug.println(this, "[bb sso_id:" + sso_id);
          	Logger.debug.println(this, "[bb returnUrl:" + returnUrl);
          	Logger.debug.println(this, "[bb SServer:" + SServer);
          	Logger.debug.println(this, "[bb UURL:" + uurl);

          	/**
          	* SSO에서 전달받은 세션을 검사한다.
          	* session이 존재하지 않는다면, 통합인증 페이지로 이동한다.
          	**/

            //if (returnUrl == null )
          	//     returnUrl = (String)session.getAttribute("returnUrl");
          	//else
          	//     session.setAttribute("returnUrl", returnUrl);
            //if (SServer == null )
          	//     SServer = (String)session.getAttribute("SServer");
          	//else
          	//     session.setAttribute("SServer", SServer);
         	  //Logger.debug.println(this, "[bb  session SServer:" + SServer);

            //최초로그인 인증없는경우
          	if (system_id == null) {
                try {
                	  uurl = uurl + "?SServer="+SServer+"&returnUrl="+returnUrl;
                    res.sendRedirect(WebUtil.JspURL+"/initech/sso/login_exec.jsp?UURL="+uurl);
                Logger.debug.println(this, "[bb  session SServer: " + SServer+"uurl:"+uurl);

                } catch ( Exception e ) {
                }
          		  return;
          	}


//            String secretEmpNo = DataUtil.fixEndZero(req.getParameter("SSNO") ,8);
            String originEmpNo = system_id;

          //  String returnUrl = (String)req.getParameter("returnUrl");
//          EP 통합 인증 check --------------------------------------------------------------------
            //인증후 ehr최초로그인
            if (session== null || !isLogin(session ,originEmpNo)) {
                performTask(req, res);
            } else {
                String dest = WebUtil.JspURL;

                //최초로그인후 연결
                if( returnUrl == null ) {
                    dest = dest + "main.jsp";
                    	Logger.debug.println(this, "[LINE84 returnUrl NULL dest:" + dest);
                } else {  //ep 메뉴에서 연결시
                    //dest = dest + returnUrl;
                    dest = dest + returnUrl.substring(1);
                         	Logger.debug.println(this, "[LINE88 returnUrl NOT NULL dest:" +dest+" returnUrl:"+returnUrl);

                }

//                String dest = WebUtil.JspURL+"main.jsp";
                printJspPage(req, res, dest);
            } // end if
        }catch(ConfigurationException e){
            Logger.debug.println(this, "perfromTesk에서 에러발생");
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection conn = null;
        boolean isCommit = false;

        try{
            Config conf           = new Configuration();
            HttpSession session = req.getSession(true);
            if (session != null) {
//                session.invalidate();
            } // end if

            Box box = WebUtil.getBox(req);
            WebUserData user = new WebUserData();

            box.copyToEntity(user);

            String originEmpNo = null;
            String secretEmpNo = user.SSNO;
            String msg = ""; //[CSR ID:] ehr시스템웹취약성진단 수정

          	//String returnUrl = (String)session.getAttribute("returnUrl");
          	//String SServer   = (String)session.getAttribute("SServer");

            originEmpNo = (String)session.getAttribute("SYSTEM_ID");

            if (originEmpNo == null || originEmpNo.trim().length() < 1) {
                //String msg = "유효한 사원번호가 아닙니다.";
                msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                throw new GeneralException(msg);
            } else {
                originEmpNo = DataUtil.fixEndZero(originEmpNo, 8);
            } // end if

            String jobid = box.get("jobid");
            if (jobid == null || jobid.equals("")) {
                String dest = WebUtil.JspURL;
                    	Logger.debug.println(this, "[ LINE139   jobid NULL  jobid:" + jobid);
                //최초로그인
                if( user.returnUrl == null  || user.returnUrl.equals("") ) {
                    //dest = dest + "newlogin.jsp";
                    dest = dest + "newlogin.jsp?SServer=" + user.SServer;
                   // 	Logger.debug.println(this, "[ LINE138 user.returnUrl NULL dest:" + dest);

                } else {
                    dest = dest + "newlogin.jsp?SServer=" + user.SServer+"&returnUrl=" + user.returnUrl;
                  //  	Logger.debug.println(this, "[ LINE142 user.returnUrl NOT NULL dest:" + dest);
                }

                printJspPage(req, res, dest);
            } else  {

                // 사번에 대한 비밀번호를 가져온다.
		        //Vector getUD = getPassword(originEmpNo);
		        //String originPwd = getUD.get(0).toString();
//            	[CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정 항목 추가
                String webUserPwd = box.getString("webUserPwd");
                String newWebUserPwd1 = box.getString("new_webUserPwd1");
                String newWebUserPwd2 = box.getString("new_webUserPwd2");

                if (jobid.equals("chngpw")) {

                    /*[CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정
                        String msg;
                     	if (originPwd.equals(webUserPwd)) {
                        String newWebUserPwd = box.getString("new_webUserPwd1");
                        if ("U".equals(chgPassword(originEmpNo ,newWebUserPwd))) {
                            msg = "비밀번호가 수정되었습니다.";
                        } else {
                            msg = "비밀번호가 수정되지 않았습니다.";
                        } // end if
                    } else {
                        msg = "현재 비밀번호가 틀렸습니다.";
                    } // end if
                    */
                    ChangePasswordResultData changeResult = chgPassword(originEmpNo, webUserPwd, newWebUserPwd1, newWebUserPwd2);
                    String url="";
                    String dest = WebUtil.JspURL +"common/msg.jsp";
                    if(changeResult.isSuccess()){
                    	url = "self.close();";
                    	req.setAttribute("msg", changeResult.MSGTX);
                        req.setAttribute("url", url);
                        printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
                    }else{
                    	//url = WebUtil.JspURL + "newpopup.jsp?jobidGG=chngpw&msgGG="+rtnChgPsMsg;
                    	/*url = WebUtil.JspURL + "newpopup.jsp";
                    	req.setAttribute("msg", rtnChgPsMsg);
                    	req.setAttribute("jobid", "chngpw");
                        req.setAttribute("url", url);

                        printJspPage(req, res, url);*/

                    	url = "history.back();";
        			    req.setAttribute("msg", changeResult.MSGTX);
        			    req.setAttribute("url", url);
                        printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
                    }


                } else if (jobid.equals("login")) {
/* [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정  호출하는 곳 없어서 과감히 주석처리!
                    String dest;
                    String msg;
                    if (originPwd.equals(webUserPwd)) {
                        if (!originPwd.equals("INIT")) {
                            PersonInfoRFC      numfunc        = new PersonInfoRFC();
                            PersonData     phonenumdata;

                            phonenumdata = (PersonData)numfunc.getPersonInfo(originEmpNo);
                            if( phonenumdata.E_BUKRS !=null && !phonenumdata.E_BUKRS.equals("") ) {
                                user.empNo            = originEmpNo;
                                user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");
                                user.login_stat       = "Y";

                                user.companyCode      = phonenumdata.E_BUKRS ;
                                user.ename            = phonenumdata.E_ENAME ;
                                user.e_titel          = phonenumdata.E_TITEL ;
                                user.e_titl2          = phonenumdata.E_TITL2 ;
                                user.e_orgtx          = phonenumdata.E_ORGTX ;
                                user.e_is_chief       = phonenumdata.E_IS_CHIEF ;
                                user.e_stras          = phonenumdata.E_STRAS ;
                                user.e_locat          = phonenumdata.E_LOCAT ;
                                user.e_regno          = phonenumdata.E_REGNO ;
                                user.e_oversea        = phonenumdata.E_OVERSEA ;
                                user.e_phone_num      = phonenumdata.E_PHONE_NUM ;
                                user.e_trfar          = phonenumdata.E_TRFAR ;
                                user.e_trfgr          = phonenumdata.E_TRFGR ;
                                user.e_trfst          = phonenumdata.E_TRFST ;
                                user.e_vglgr          = phonenumdata.E_VGLGR ;
                                user.e_vglst          = phonenumdata.E_VGLST ;
                                user.e_dat03          = phonenumdata.E_DAT03 ;
                                user.e_persk          = phonenumdata.E_PERSK ;
                                user.e_deptc          = phonenumdata.E_DEPTC ;
                                user.e_retir          = phonenumdata.E_RETIR ;
                                user.e_grup_numb      = phonenumdata.E_GRUP_NUMB ;
                                user.e_gansa          = phonenumdata.E_GANSA ;          // 20030623 CYH 추가함.
                                user.e_orgeh          = phonenumdata.E_ORGEH;           // 20050214 추가함.
                                user.e_representative = phonenumdata.E_REPRESENTATIVE;  // 20050214 추가함.
                                user.e_authorization  = phonenumdata.E_AUTHORIZATION;   // 20050214 추가함.
                                user.e_objid          = phonenumdata.E_OBJID ;          // 20050412 추가함.
                                user.e_obtxt          = phonenumdata.E_OBTXT ;          // 20050412 추가함.
                                user.e_werks          = phonenumdata.E_WERKS ;          // 20050413 추가함. 인사영역(EC00 이면 해외법인)
                                user.e_recon          = phonenumdata.E_RECON ;          // 20050414 추가함. 퇴직구분('D'-사망'S'-미혼'Y'-퇴직)
                                user.e_reday          = phonenumdata.E_REDAY ;          // 20050414 추가함. 퇴직일자
                                user.e_mail           = phonenumdata.E_MAIL  ;          // 20050420 추가.
                                user.e_timeadmin  = phonenumdata.E_TIMEADMIN;   // 20090622 추가함.

                                user.loginPlace       = "btn_eHR"; //ep통한 로그인임을 알리는 flag

                                // 사용자 권한 그룹 설정
                                conn = DBUtil.getTransaction("HRIS");
                                user.user_group =   (new CommonCodeDB(conn)).getAuthGroup(user.e_authorization);
                                //Logger.debug.println(this ,"lsa session==>user.e_authorization = " + user.e_authorization);
                                //Logger.debug.println(this ,"user.user_group = " + user.user_group);
                                isCommit = true;

                                DataUtil.fixNull(user);

                                session = req.getSession(true);

                                int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                                session.setMaxInactiveInterval(maxSessionTime);

                                session.setAttribute("user",user);

                                //Logger.debug.println(this, "[ user : "+user.toString() +"  ****]");
                                //Logger.debug.println(this, "[ phonenumdata  : "+phonenumdata.toString() +"  ****]");
                                //Logger.debug.println(this, "[------line 227 user.returnUrl : ["+user.returnUrl +"]");
                                //if(user.returnUrl == null  || user.returnUrl.equals(""))
                                //{
                                //    Logger.debug.println(this, "LINE 253 ****  user.returnUrl null ==="  );
                                //}
                                //if(user.returnUrl.equals("null"))
                                //{
                                //    Logger.debug.println(this, "LINE 253 $$$$  user.returnUrl STRING null ===" );
                                //}
                                if(user.returnUrl == null  || user.returnUrl.equals(""))
                                {
                                    dest = WebUtil.JspURL + "main.jsp";
                                  //  Logger.debug.println(this, "LINE 253 dest: user.returnUrl null 2" + dest);
                                }
                                else //if(user.returnUrl != null)
                                {
                                    dest = WebUtil.JspURL + "redirect.jsp.delete?returnUrl=" + user.returnUrl;
                                   // Logger.debug.println(this, "LINE 258 dest: user.returnUrl not null1" + dest);
                                }

                                //dest = WebUtil.JspURL+"main.jsp";

                            } else {
                                msg = "사원번호를 확인하여 주십시요.";
                                req.setAttribute("msg", msg);

                                String url = "location.href='" + WebUtil.JspURL;

                                if( user.returnUrl == null  || user.returnUrl.equals("") ) {
                                    url = url + "newlogin.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer + "';";
                                } else {
                                    url = url + "newlogin.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer + "&returnUrl=" + user.returnUrl + "';";
                                }

//                                String url = "location.href='" + WebUtil.JspURL +"newlogin.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer +"';";
                                req.setAttribute("url", url);
                                dest = WebUtil.JspURL +"common/msg.jsp";
                            } // end if
                        } else {
                            msg = "비밀 번호를 수정하세요 .";
                            req.setAttribute("msg", msg);

                            String url = "location.href='" + WebUtil.JspURL;

                            if( user.returnUrl == null  || user.returnUrl.equals("") ) {
                                url = url + "newlogin.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer +"&MustPWChng=true';";
                            } else {
                                url = url + "newlogin.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer +"&MustPWChng=true" + "&returnUrl=" + user.returnUrl + "';";
                            }

//                            String url = "location.href='" + WebUtil.JspURL +"newlogin.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer +"&MustPWChng=true';";
                            req.setAttribute("url", url);
                            dest = WebUtil.JspURL +"common/msg.jsp";
                        } // end if
                    } else {
                        if (originPwd == null || originPwd.length() < 1) {
                            Logger.debug.print(this ," 로그인비밀번호사번 : [" + originEmpNo + "] \t 패스워드 : [" + originPwd + "]");
                        } // end if

                        msg = "비밀번호가 틀렸습니다.";
                        req.setAttribute("msg", msg);

                        String url = "location.href='" + WebUtil.JspURL;

                        if( user.returnUrl == null  || user.returnUrl.equals("") ) {
                            url = url + "newlogin.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer + "';";
                        } else {
                            url = url + "newlogin.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer + "&returnUrl=" + user.returnUrl + "';";
                        }

//                        String url = "location.href='" + WebUtil.JspURL +"newlogin.jsp?SSNO=" + user.SSNO + "&SServer=" + user.SServer +"';";
                        req.setAttribute("url", url);
                        dest = WebUtil.JspURL +"common/msg.jsp";
                    } // end if
                    Logger.debug.println(this ," 315 라인 dest =" + dest);
                    printJspPage(req, res, dest);
*/                } // end if
            } // end if
        }catch(Exception e){
            throw new GeneralException(e);
        } finally {
            DBUtil.close(conn ,isCommit);
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


    //  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정 추가됨.
    private ChangePasswordResultData chgPassword(String webUserId, String webUserPwd, String newWebUserPwd1, String newWebUserPwd2) throws GeneralException{
        ChgPasswordRFC rfc = new ChgPasswordRFC();
        return rfc.chgPassword(webUserId,webUserPwd, newWebUserPwd1, newWebUserPwd2);
    }

    protected boolean isLogin(HttpSession session ,String empNo)
    {
        hris.common.WebUserData user  = (hris.common.WebUserData)session.getAttribute("user");
        Logger.debug.println(this ,user);
        if ( user == null || user.empNo == null || !user.empNo.equals(empNo) || !user.loginPlace.equals("btn_eHR")) {
            return false;
        } // end if
        String login_stat = user.login_stat;

        Logger.debug.println(this, "isLogin login_stat : " + login_stat);
        if ( login_stat == null || !login_stat.equals("Y") ) { return (false);  }
        else { return (true);   }

    }
}
