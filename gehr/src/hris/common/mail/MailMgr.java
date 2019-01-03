package hris.common.mail;

import java.util.Vector;

import com.sns.jdf.*;
import com.sns.jdf.util.*;

import hris.common.*;
import hris.common.mail.*;
import hris.E.E27InfoDecision.*;
/**
 * MailMgr.java
 * 메일을 보낼수 있는 정보를 받아 메일을 보낼수 있는 Class 를 호출하는 class
 *
 * @author 이형석
 * @version 1.0, 2001/12/13
 */

public class MailMgr{

    private static MailSender                mailsender                = null;
    private static MailSenderDel             mailsenderdel             = null;
    private static InfoMailSender            infomailsender            = null;
    private static InfoMailSenderDel         infomailsenderdel         = null;
    private static InfoDecisionMailSender    infodecisionmailsender    = null;
    private static InfoDecisionMailSenderDel infodecisionmailsenderdel = null;
    private static PWSearchMailSender        pwsearchmailsender = null;

    public  static Vector                    Mail_vt                   = new Vector();
    public  static Vector                    MailInfo_vt               = new Vector();
    public  static Vector                    MailInfode_vt             = new Vector();

    public  static long       mailNumber = 00000;

    public static void sendMail(WebUserData user, Vector AppLineData_vt, String upmuname) {

        Logger.debug.println("sendMail call: 신청");

        MailData md  = new MailData();

        md.user = user;
        md.AppLineData_vt = AppLineData_vt;
        md.upmuname = upmuname;

        synchronized(Mail_vt){
            mailNumber = mailNumber+1;
            Mail_vt.addElement(md);
        }

        Logger.debug.println("[메일발송:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+user.ename+"(사번:"+user.empNo.trim()+")님의 "+upmuname+"에 관한 메일");

        mailsender = new MailSender();
    }

    public static void sendMailDel(WebUserData user, Vector AppLineData_vt, String upmuname) {

        Logger.debug.println("sendMailDel call: 신청 취소");

        MailData md  = new MailData();

        md.user = user;
        md.AppLineData_vt = AppLineData_vt;
        md.upmuname = upmuname;

        synchronized(Mail_vt){
            mailNumber = mailNumber+1;
            Mail_vt.addElement(md);
        }

        Logger.debug.println("[신청 취소 메일발송:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+user.ename+"(사번:"+user.empNo.trim()+")님의 "+upmuname+" 취소에 관한 메일");

        mailsenderdel = new MailSenderDel();
    }

    public static void infosendMail(WebUserData user, String gempNo, String upmuname, String stext) {

        Logger.debug.println("infosendMail call: 신청");

        MailData md  = new MailData();

        md.user = user;
        md.gempNo = gempNo;
        md.upmuname = upmuname;
        md.stext = stext;

        synchronized(MailInfo_vt){
            mailNumber = mailNumber+1;
            MailInfo_vt.addElement(md);
        }

        Logger.debug.println("[메일발송:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+user.ename+"(사번:"+user.empNo.trim()+")님의 "+upmuname+"에 관한 메일");

        infomailsender = new InfoMailSender();
    }

    public static void infosendMailDel(WebUserData user, String gempNo, String upmuname, String stext) {

        Logger.debug.println("infosendMailDel call: 신청 취소");

        MailData md  = new MailData();

        md.user = user;
        md.gempNo = gempNo;
        md.upmuname = upmuname;
        md.stext = stext;

        synchronized(MailInfo_vt){
            mailNumber = mailNumber+1;
            MailInfo_vt.addElement(md);
        }

        Logger.debug.println("[메일발송:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+user.ename+"(사번:"+user.empNo.trim()+")님의 "+upmuname+" 취소에 관한 메일");

        infomailsenderdel = new InfoMailSenderDel();
    }

    public static void infoDecisionMail(WebUserData user, E27InfoDecisionData data, String upmuname) {

        Logger.debug.println("infoDecisionMail call: 신청");

        MailData md  = new MailData();

        md.user = user;
        md.data = data;
        md.upmuname = upmuname;

        synchronized(MailInfode_vt){
            mailNumber = mailNumber+1;
            MailInfode_vt.addElement(md);
        }

        Logger.debug.println("[메일발송:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+data.ENAME+"(사번:"+data.PERNR.trim()+")님의 "+upmuname+"에 관한 결재완료 메일");

        infodecisionmailsender = new InfoDecisionMailSender();
    }

    public static void infoDecisionMailDel(WebUserData user, E27InfoDecisionData data, String upmuname) {

        Logger.debug.println("infoDecisionMailDel call: 신청 취소");

        MailData md  = new MailData();

        md.user = user;
        md.data = data;
        md.upmuname = upmuname;

        synchronized(MailInfode_vt){
            mailNumber = mailNumber+1;
            MailInfode_vt.addElement(md);
        }

        Logger.debug.println("[메일발송:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+data.ENAME+"(사번:"+data.PERNR.trim()+")님의 "+upmuname+" 취소에 관한 결재완료 메일");

        infodecisionmailsenderdel = new InfoDecisionMailSenderDel();
    }

    // 2004.10.14 - 비밀번호 찾기 메일
    public static void pwsendMail(WebUserData user, String originPwd) {

        Logger.debug.println("sendMail call: 신청");

        MailData md  = new MailData();

        md.user = user;
        md.stext = originPwd;  // Password
   
        synchronized(Mail_vt){
            mailNumber = mailNumber+1;
            Mail_vt.addElement(md);
        }

        Logger.debug.println("[메일발송: ESS 패스워드 확인에 관한 메일");

        pwsearchmailsender = new PWSearchMailSender();
    }
}
        