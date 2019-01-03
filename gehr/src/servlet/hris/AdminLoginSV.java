/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 관리자 로그인                                                */
/*   Program Name : 관리자 로그인                                     */
/*   Program ID   : AdminLoginSV.java                                    */
/*   Description  : 관리자 로그인                           */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정                       */
/*                :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
/********************************************************************************/

package servlet.hris;

import com.common.constant.Area;
import com.common.constant.Server;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.N.AES.AESgenerUtil;
import hris.N.WebAccessLog;
import hris.common.LoginResultData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.EmpListRFC;
import hris.common.rfc.GetPasswordRFC;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;

public class AdminLoginSV extends EHRBaseServlet
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
        try{
            WebUserData user = new WebUserData();
            WebUtil.getBox(req).copyToEntity(user);


            /*테스트를 위한 sap 연결 정보 set*/
            /*SAPWrap.server = Server.valueOf(req.getParameter("sapServer"));*/

            user.empNo = DataUtil.fixEndZero( user.empNo ,8);

            Server serverType = Server.valueOf(req.getParameter("sapServer"));

            String sysid = req.getParameter("sysid");

            EmpListRFC empListRFC = new EmpListRFC(SAPType.LOCAL, serverType);

            if(StringUtils.isBlank(sysid)) {

            /* sap연결 정보 셋팅 */
                if (!empListRFC.setSapType(req, user, serverType)) {
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0085"), "history.back();"); //접속 중 오류가 발생하였습니다.
                    return;
                }
            } else {

                if (!empListRFC.setSapTypeFromParameter(req, user)) {
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0083"), "window.close();"); //해당 사원 정보가 없습니다.
                    return;
//                throw new GeneralException("접속 중 오류가 발생하였습니다.");
                }
            }


            Logger.debug("user.empNo ?????????????????>> "+ user.empNo); //00034122

            //[CSR ID:2685916] 웹취약성 수정 1차@웹취약성 취약한 요청/응답처리 20150117
            String remoteIP = req.getRemoteAddr();
            user.remoteIP = req.getRemoteAddr();
            //user.remoteIP   = "10.34.99.167";

            Logger.debug(" remoteIP >>>>>>>>>>>>>>>>>>>  : "+remoteIP );

            // 사용자 권한 그룹 설정
            if (!StringUtils.equalsIgnoreCase(user.webUserId, "eadmin") &&
                    StringUtils.indexOfIgnoreCase(user.webUserId, "emanag") < 0) {
                moveMsgPage(req, res, g.getMessage("MSG.COMMON.0085"), "history.back();"); //접속 중 오류가 발생하였습니다.
            }

            // 사번에 대한 비밀번호를 가져온다.
            String upperID = user.webUserId.toUpperCase();
            Logger.debug.println(this ," start [upperID] : "+upperID);

            LoginResultData loginResultData = getLoginYN(user, user.sapType);

            Logger.debug.println(this ," start [debug] : "+loginResultData );
            String userIP = loginResultData.E_IP;


            /*if (WebUtil.isLocal(req) || "165.244.254.210".equals(req.getServerName()) || req.getServerName().indexOf("devgehr.lgchem.com") > -1
                    || req.getServerName().indexOf("devlocal.lgchem.com") > -1
                    || req.getServerName().indexOf("gehr.lgchem.com") > -1) { //local에만 적용*/
            if (WebUtil.isLocal(req)) { //local에만 적용
                if(Arrays.asList("eadmin", "eadmin", "emanag88").contains(user.webUserId) || StringUtils.indexOfIgnoreCase(user.webUserId, "emanag") > -1) {

                    remoteIP = userIP;

                    /* 추후 오픈 시 삭제 */
                    /*
                    if(StringUtils.indexOf(user.sapType.name(), "LOCAL") > -1)  user.webUserPwd = "1234";
                    else user.webUserPwd = "erphr08";
                    */
                }
            }



            Logger.debug("[loginResultData.isSuccess()] : " + loginResultData.isSuccess());
            //if (webUserPwd.trim().equalsIgnoreCase(originPwd.trim())) {
            if (loginResultData.isSuccess()) {
                HttpSession session = req.getSession(false);

                if (session != null){ session.invalidate(); }

                PersonData personData;
                PersonInfoRFC personInfoRFC        = new PersonInfoRFC(user.sapType);
                try{
                    personData = (PersonData) personInfoRFC.getPersonInfo(user.empNo, "X");
                }catch(Exception ex){
                    Logger.error(ex);
                    throw new GeneralException(ex);
                }

                Logger.debug("[get personData] : " + personData);
                Logger.debug("[ip check ] : " + userIP + ", " + remoteIP);

                if(personData == null || StringUtils.isEmpty(personData.E_BUKRS) ||
                        !StringUtils.equals(userIP, remoteIP) ) {
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0085"), "history.back();"); //접속 중 오류가 발생하였습니다.
                    return;
                /* } else if ( !phonenumdata.E_BUKRS.equals("C100") ) {
                    moveMsgPage(req, res, "접속 중 오류가 발생하였습니다.", "history.back();");
                    */
                } else {
                    Logger.debug("[session set start]");
                    user.webUserPwd       = null;
                    user.login_stat       = "Y";
                    Config conf           = new Configuration();
                    user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                    personInfoRFC.setSessionUserData(personData, user);

                    if(WebUtil.isLocal(req) && StringUtils.isBlank(user.e_area)) user.e_area = "41";
                    user.area = Area.fromMolga(user.e_area);

                    // 사용자 권한 그룹 설정
                    if (StringUtils.equals(upperID, "EADMIN")) {  // 관리자 메뉴 접근 권한
                        user.user_group = "01";
                    } else if ( upperID.substring(0,6).equals("EMANAG") ) {
                        Logger.debug("1");
                        /*user.user_group = (new SysAuthGroupRFC()).getAuthGroup(user.e_authorization);*/
                    }

                    Logger.debug.println(this ,personData);

                    DataUtil.fixNull(user);
                    session = req.getSession(true);
                    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                    session.setMaxInactiveInterval(maxSessionTime);
                    session.setAttribute("user",user);
                    //manager메뉴에서 기본적으로 본인이 나오게 수정(8/18의사결정 by 박지영 B)
                    session.setAttribute("user_m", user);
//                  암호호 키 session저장 2015-07-27
                    AESgenerUtil cu = new AESgenerUtil();
                    session.setAttribute("AESKEY",cu.getKey());

                    //locale setting
                    WebUtil.setLang(req, user);

                    user.locale = g.getLocale();
                    Logger.debug("------ Spring Locale : " + WebUtils.getSessionAttribute(req, SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME));
                    Logger.debug.println(this, "ok login.. user : "+user.toString() );
//                    String dest = WebUtil.JspURL+"main.jsp";
                    String dest = WebUtil.ServletURL + "hris.sys.SysMenuTopSV";

                    //(new WebAccessLog()).setAccessLog("MAIN", user.empNo, user.empNo, user.remoteIP);

                    (new WebAccessLog()).setRoleCheckLog(user.empNo, user.e_authorization);



                    Logger.debug("[session set end]");
                    printJspPage(req, res, dest);
                }
            } else {
                moveMsgPage(req, res, StringUtils.trim(loginResultData.MSGTX), "history.back();");
            }
        }catch(Exception e){
            Logger.error(e);
            throw new GeneralException(e);
        }// end try
    }

    //[CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정
    private LoginResultData getLoginYN(WebUserData user, SAPType sapType) throws GeneralException{
        GetPasswordRFC rfc = new GetPasswordRFC();
        //rfc.setSapType(sapType);
        rfc.setSapType(SAPType.LOCAL);
        return rfc.getLoginYN(StringUtils.upperCase(user.webUserId), user.webUserPwd);
    }
}