/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ������ �α���                                                */
/*   Program Name : ������ �α���                                     */
/*   Program ID   : AdminLoginSV.java                                    */
/*   Description  : ������ �α���                           */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ����                       */
/*                :  2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
/*                   2018/01/22  rdcamel [CSR ID:3594900] �繫�� ������� �籸�� �ý��� HR-Portal    */
/* 				  2018/05/03  rdcamel //[CSR ID:3678263] LGȭ�� �繫�� �Ǳٷνð� �Է� �ý��� �ݿ�  */
/********************************************************************************/

package servlet.hris;

import com.common.constant.Area;
import com.lgcns.encypt.EncryptUtil;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.N.AES.AESgenerUtil;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.EmpListRFC;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.TimeZone;

/**
 *
 * URL : servlet.hris.ExternalViewSV?lang=����Ű(ko,en,zh)empNo=�α��λ��&empNoKey=�α��λ����ȣȭŰ&sysid=0(����)
 *      ��Ÿ ��ȸ�� &requestPage
 *
 */
public class ExternalViewSV extends EHRBaseServlet {

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            performTask(req, res);
        }catch(GeneralException e){
           throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        //Connection conn = null;
        try{

            process(req, res, false);

            WebUserData user = WebUtil.getSessionUser(req);

            String dest = WebUtil.JspURL + "main.jsp";
            String requestPage = req.getParameter("requestPage");

            if("selfConfirm".equals(requestPage)) dest = WebUtil.ServletURL + "hris.N.essperson.A01SelfDetailNeoConfirmPopSV";
            else if("rule".equals(requestPage)) dest = WebUtil.JspURL + "help_online/help/html/"+req.getParameter("param");
            else if("faq".equals(requestPage)) dest = WebUtil.ServletURL + "hris.N.ehrFAQ.EHRfaqSV?I_PFLAG=X";
            else if("charge".equals(requestPage)) dest = WebUtil.JspURL + "common/HRChargePop.jsp?I_BUKRS=" + user.companyCode + "&I_GRUP_NUMB=" + user.e_grup_numb;
            else if("board".equals(requestPage)) dest = WebUtil.ServletURL + "hris.N.notice.EHRNoticeSV?OBJID=" + req.getParameter("OBJID");
            //������� �߷� �� ��ȸ [CSR ID:3594900]
            else if("raise".equals(requestPage)) dest = WebUtil.ServletURL + "hris.A.A05AppointDetailSV";
            //[CSR ID:3678263] LGȭ�� �繫�� �Ǳٷνð� �Է� �ý��� �ݿ�
            else if("workTime".equals(requestPage)) dest = WebUtil.ServletURL + "hris.D.D25WorkTime.D25WorkTimeFrameSV";
            
            /*else (new WebAccessLog()).setAccessLog("MAIN", user.empNo, user.empNo, user.remoteIP);*/

            redirect(res, dest);

        }catch(Exception e){
            throw new GeneralException(e);
        }// end try
    }

    /**
     * �ܺ� ���ٽ� �α��� ����
     * @param req
     * @param res
     * @throws GeneralException
     */
    protected void process(HttpServletRequest req, HttpServletResponse res, boolean isSSO) throws GeneralException {
        //Connection conn = null;
        try{

            WebUserData user = new WebUserData();
            Box box = WebUtil.getBox(req);
            box.copyToEntity(user);

            HttpSession session = req.getSession(false);


            /* �Ķ���ͷ� �Ѿ�� ��*/
            try {
                Enumeration params = req.getParameterNames();
                while (params.hasMoreElements()) {
                    String param = (String) params.nextElement();
                    String str = req.getParameter(param);

                    Logger.debug("[" + param + "]" + req.getParameter(param)  + "[" + (str == null ? "-NULL-" :  str.getClass()) + "]");
                }
            } catch (Exception e) {
                Logger.error(e);
            }

            if(isSSO) {
                user.empNo = DataUtil.fixEndZero((String) session.getAttribute("SYSTEM_ID"), 8);
            } else {
                try {
                /*String key = "sshr" + box.get("empNoKey", box.get("empkey"));
                String decryptEmpNo = AESgenerUtil.decryptAES(box.get("empNo", box.get("empno")), key);*/
                    //[CSR ID:3678263]String decryptEmpNo = decryptEmpno(box.get("empNo", box.get("empno")));
                	//[CSR ID:3678263]g-portal ���� �Ѿ���� ��ȣ����� encryptEmpNo �� �Ѿ��. box �� ���� �ϳ� �߰���.
                	String decryptEmpNo = decryptEmpno(box.get("encryptEmpNo", box.get("empNo", box.get("empno"))));
                    if(StringUtils.isBlank(decryptEmpNo)) throw new Exception();

                    user.empNo = DataUtil.fixEndZero(decryptEmpNo, 8);
                } catch(Exception e) {
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0084"), "history.back();");//�ش� ����� ���� ��ȿ�� ������ �����Ͽ����ϴ�.
                    return;
                }
            }
//            viewEmpnoKey

            //���� ���� ���� ���� Ȯ��
            WebUserData sessionUser = WebUtil.getSessionUser(req);

            //���� ������ �������� �ʰų� ���� empno ���� Ʋ���� ���� ���� ����
            if(sessionUser == null || !StringUtils.equals(sessionUser.empNo, user.empNo) ) {

            /* sap���� ���� ���� */
                EmpListRFC empListRFC = new EmpListRFC(SAPType.LOCAL);
                if (!empListRFC.setSapTypeFromParameter(req, user)) {
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0083"), "window.close();"); //�ش� ��� ������ �����ϴ�.
                    return;
//                throw new GeneralException("���� �� ������ �߻��Ͽ����ϴ�.");
                }

                Logger.debug("user.empNo ?????????????????>> " + user.empNo); //00034122

                //[CSR ID:2685916] ����༺ ���� 1��@����༺ ����� ��û/����ó�� 20150117
                user.remoteIP = req.getRemoteAddr();

                //if (webUserPwd.trim().equalsIgnoreCase(originPwd.trim())) {
                if (session != null){ session.invalidate(); }

                PersonData personData;
                PersonInfoRFC personInfoRFC = new PersonInfoRFC(user.sapType);
                try {
                    personData = personInfoRFC.getPersonInfo(user.empNo, "X");
                } catch (Exception ex) {
                    Logger.error(ex);
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0083"), "window.close();"); //�ش� ��� ������ �����ϴ�.
                    return;
//                throw new GeneralException(ex);
                }

                user.login_stat = "Y";
                Config conf = new Configuration();
                user.clientNo = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                personInfoRFC.setSessionUserData(personData, user);

                if (WebUtil.isLocal(req) && StringUtils.isBlank(user.e_area)) user.e_area = "41";
                user.area = Area.fromMolga(user.e_area);

                Logger.debug.println(this, personData);

                DataUtil.fixNull(user);
                session = req.getSession(true);
                int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                session.setMaxInactiveInterval(maxSessionTime);

                session.setAttribute("user", user);
                session.setAttribute("user_m", user);

                AESgenerUtil cu = new AESgenerUtil();
                session.setAttribute("AESKEY", cu.getKey());

            }

            /* �Ķ���ͷ� �Ѿ�� ��*/
            Logger.debug("---------- 2nd Log -------- ");
            try {
                Enumeration params = req.getParameterNames();
                while (params.hasMoreElements()) {
                    String param = (String) params.nextElement();
                    Logger.debug("[" + param + "]" + req.getParameter(param));
                }
            } catch (Exception e) {
                Logger.error(e);
            }

            WebUtil.setLang(req, user);

            user.locale = g.getLocale();
            Logger.debug("------ Spring Locale : " + WebUtils.getSessionAttribute(req, SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME));
            Logger.debug.println(this, "ok login.. user : " + user.toString());
//                    String dest = WebUtil.JspURL+"main.jsp";
        }catch(Exception e){
            Logger.error(e);
            throw new GeneralException(e);
        }// end try
    }

    protected String decryptEmpno(String encryptEmpNo) throws Exception {


        /**************************************************************/
		/* URL Parameter���� ���� ���� ��� ����                                                                         */
        /**************************************************************/
        // G-Portal���� �Ѱ��ִ� �Ķ���� �� ( GET ����� ��� URLEncoder/URLDecoder �� Ȱ���Ͽ��� ��.
        // ��� : encryptEmpNo --> (String)request.getParameter(��encryptEmpNo��);
        // �����ּ� : encryptMail --> (String)request.getParameter(��encryptMail��);
        // ���� ID : encryptUserId --> (String)request.getParameter(��encryptUserId��);

        // ��ȣȭ
        String decryptStr = EncryptUtil.decryptText(encryptEmpNo,"ThisIsIkepSecurityKey");
        Logger.debug("Decrypt datetime+empNo : " + decryptStr);

        String[] decryptArr = decryptStr.split("\\|",0);
        if(decryptArr.length < 2) {
            new GeneralException("Error Decrypt length < 0");
        }

        Logger.debug("Decrypt datetime : " + decryptArr[0]); // yyyyMMddHHmmss ������ Datetime (GMT+0), �ĸ����� ��ȿ�� ������ Ȱ��
        Logger.debug("Decrypt empNo : " + decryptArr[1]); // ��ȣȭ�� EmpNo

        /**************************************************************/
        // �Ʒ��� ��ȣȭ ������ ���� �ð��� Ȯ���ϴ� ���� ��.
        // | �� �����ڷ� datetime ( GMT+0 ������, date format-"yyyyMMddHHmmss" )�� ������ ��ȣȭ ������ ��ȿ�� Ȯ���ϼ���.
        /**************************************************************/

        TimeZone jst2 = TimeZone.getTimeZone ("GMT+0");
        Calendar receiveServerTimeMinus = Calendar.getInstance (jst2);
        Calendar receiveServerTimePlus = Calendar.getInstance (jst2);

        receiveServerTimeMinus.add(Calendar.HOUR_OF_DAY, -12);
        receiveServerTimePlus.add(Calendar.HOUR_OF_DAY, 12);

        Date minusLimit = receiveServerTimeMinus.getTime();
        Date plusLimit =  receiveServerTimePlus.getTime();

        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMddHHmmss");
        sdf2.setTimeZone(receiveServerTimeMinus.getTimeZone());

        try {
            Date paramDateTime = sdf2.parse(decryptArr[0]); // ��ȭȭ �������� dateTime �κ�
            //Date paramDateTime = sdf2.parse("20140305204256"); // ���� �߻��� ���� ���� �� ����

            if(paramDateTime.before(minusLimit)) {
                throw new Exception("Error! ��ȣȭ�� �������� �� ");
            }

            if(paramDateTime.after(plusLimit)) {
                throw new Exception("Error! ��ȣȭ �� �ð��� �̷���");
            }

        } catch (Exception e) {
            throw new Exception(e);
        }

        return decryptArr[1];
    }

}