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
import java.util.List;

public class TestLoginSV extends EHRBaseServlet
{
    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            performTask(req, res);
        }catch(GeneralException e){
           throw new GeneralException (e);
        }
    }

    private List<String> adminList = Arrays.asList("eadminkr", "eadminnj", "eadmincci", "eadmincpi", "eadmincai", "eadmincwr");
    /**
     * 사용자 테스트 용
     * @param req
     * @param res
     * @throws GeneralException
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection conn = null;
        try{
            WebUserData user = new WebUserData();
            WebUtil.getBox(req).copyToEntity(user);


            moveMsgPage(req, res, "page not found", "history.back();");
            /*테스트를 위한 sap 연결 정보 set*/
            /*SAPWrap.server = Server.valueOf(req.getParameter("sapServer"));*/

            user.empNo = DataUtil.fixEndZero( user.empNo ,8);

            Server serverType = Server.DEFAULT;
            /* sap연결 정보 셋팅 */
            EmpListRFC empListRFC = new EmpListRFC(SAPType.LOCAL, serverType);
            if(!empListRFC.setSapType(req, user, serverType)) {
                moveMsgPage(req, res, "You have no authorization to that Personal No", "history.back();");
                return;
            }

            Logger.debug("user.empNo ?????????????????>> "+ user.empNo); //00034122

            //[CSR ID:2685916] 웹취약성 수정 1차@웹취약성 취약한 요청/응답처리 20150117
            String remoteIP = req.getRemoteAddr();
            user.remoteIP = req.getRemoteAddr();

            Logger.debug(" remoteIP >>>>>>>>>>>>>>>>>>>  : "+remoteIP );

            // 사용자 권한 그룹 설정
            if (!adminList.contains(user.webUserId)) {
                moveMsgPage(req, res, "You have no authorization to that Personal No", "history.back();");
                return;
            }

            // 사번에 대한 비밀번호를 가져온다.
            String upperID = user.webUserId.toUpperCase();
            Logger.debug.println(this ," start [upperID] : "+upperID);

            LoginResultData loginResultData = getLoginYN(user, user.sapType);

            Logger.debug.println(this ," start [debug] : "+loginResultData );
            String userIP = loginResultData.E_IP;


                //if (webUserPwd.trim().equalsIgnoreCase(originPwd.trim())) {
//			if (loginResultData.isSuccess()) {
            if ("*1234".equals(user.getWebUserPwd())) {

                HttpSession session = req.getSession(false);

                if (session != null){ session.invalidate(); }

                PersonData personData;
                PersonInfoRFC personInfoRFC        = new PersonInfoRFC(user.sapType);

                boolean isContinue = false;

                try{
                    personData = (PersonData) personInfoRFC.getPersonInfo(user.empNo, "X");


                    /* eadminkr --> molga 가 kr
                    * eadminnj
                            --> persa 가 1800

                    eadmincci
                            --> persa 가 1000

                    eadmincpi
                            --> persa 가 4000*/
                    if("eadminkr".equals(user.webUserId) && Area.KR.getMolga().equals(personData.getE_MOLGA())) isContinue = true;
                    else if("eadminnj".equals(user.webUserId) && "1800".equals(personData.getE_WERKS())) isContinue = true;
                    else if("eadmincci".equals(user.webUserId) && "1000".equals(personData.getE_WERKS())) isContinue = true;
                    else if("eadmincpi".equals(user.webUserId) && "4000".equals(personData.getE_WERKS())) isContinue = true;
                    else if("eadmincai".equals(user.webUserId) && "3400".equals(personData.getE_WERKS())) isContinue = true;
                    else if("eadmincwr".equals(user.webUserId) && "2900".equals(personData.getE_WERKS())) isContinue = true;

                }catch(Exception ex){
                    Logger.error(ex);
                    throw new GeneralException(ex);
                }

                if(personData == null || StringUtils.isEmpty(personData.E_BUKRS) || !isContinue
                        /*!StringUtils.equals(userIP, remoteIP)*/ ) {
                    moveMsgPage(req, res, "You have no authorization to that Personal No", "history.back();");

                /* } else if ( !phonenumdata.E_BUKRS.equals("C100") ) {
                    moveMsgPage(req, res, "You have no authorization to that Personal No", "history.back();");
                    */
                } else {
                    user.webUserPwd       = null;
                    user.login_stat       = "Y";
                    Config conf           = new Configuration();
                    user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                    personInfoRFC.setSessionUserData(personData, user);

                    if(WebUtil.isLocal(req) && StringUtils.isBlank(user.e_area)) user.e_area = "41";
                    user.area = Area.fromMolga(user.e_area);

/*                    // 사용자 권한 그룹 설정
                    if (StringUtils.equals(upperID, "EADMIN")) {  // 관리자 메뉴 접근 권한
                        user.user_group = "01";
                    } else if ( upperID.substring(0,6).equals("EMANAG") ) {
                        user.user_group = (new SysAuthGroupRFC()).getAuthGroup(user.e_authorization);
                    }*/

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
        rfc.setSapType(sapType);
        return rfc.getLoginYN(StringUtils.upperCase(user.webUserId), user.webUserPwd);
    }
}