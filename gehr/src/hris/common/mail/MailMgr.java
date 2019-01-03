package hris.common.mail;

import java.util.Vector;

import com.sns.jdf.*;
import com.sns.jdf.util.*;

import hris.common.*;
import hris.common.mail.*;
import hris.E.E27InfoDecision.*;
/**
 * MailMgr.java
 * ������ ������ �ִ� ������ �޾� ������ ������ �ִ� Class �� ȣ���ϴ� class
 *
 * @author ������
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

        Logger.debug.println("sendMail call: ��û");

        MailData md  = new MailData();

        md.user = user;
        md.AppLineData_vt = AppLineData_vt;
        md.upmuname = upmuname;

        synchronized(Mail_vt){
            mailNumber = mailNumber+1;
            Mail_vt.addElement(md);
        }

        Logger.debug.println("[���Ϲ߼�:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+user.ename+"(���:"+user.empNo.trim()+")���� "+upmuname+"�� ���� ����");

        mailsender = new MailSender();
    }

    public static void sendMailDel(WebUserData user, Vector AppLineData_vt, String upmuname) {

        Logger.debug.println("sendMailDel call: ��û ���");

        MailData md  = new MailData();

        md.user = user;
        md.AppLineData_vt = AppLineData_vt;
        md.upmuname = upmuname;

        synchronized(Mail_vt){
            mailNumber = mailNumber+1;
            Mail_vt.addElement(md);
        }

        Logger.debug.println("[��û ��� ���Ϲ߼�:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+user.ename+"(���:"+user.empNo.trim()+")���� "+upmuname+" ��ҿ� ���� ����");

        mailsenderdel = new MailSenderDel();
    }

    public static void infosendMail(WebUserData user, String gempNo, String upmuname, String stext) {

        Logger.debug.println("infosendMail call: ��û");

        MailData md  = new MailData();

        md.user = user;
        md.gempNo = gempNo;
        md.upmuname = upmuname;
        md.stext = stext;

        synchronized(MailInfo_vt){
            mailNumber = mailNumber+1;
            MailInfo_vt.addElement(md);
        }

        Logger.debug.println("[���Ϲ߼�:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+user.ename+"(���:"+user.empNo.trim()+")���� "+upmuname+"�� ���� ����");

        infomailsender = new InfoMailSender();
    }

    public static void infosendMailDel(WebUserData user, String gempNo, String upmuname, String stext) {

        Logger.debug.println("infosendMailDel call: ��û ���");

        MailData md  = new MailData();

        md.user = user;
        md.gempNo = gempNo;
        md.upmuname = upmuname;
        md.stext = stext;

        synchronized(MailInfo_vt){
            mailNumber = mailNumber+1;
            MailInfo_vt.addElement(md);
        }

        Logger.debug.println("[���Ϲ߼�:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+user.ename+"(���:"+user.empNo.trim()+")���� "+upmuname+" ��ҿ� ���� ����");

        infomailsenderdel = new InfoMailSenderDel();
    }

    public static void infoDecisionMail(WebUserData user, E27InfoDecisionData data, String upmuname) {

        Logger.debug.println("infoDecisionMail call: ��û");

        MailData md  = new MailData();

        md.user = user;
        md.data = data;
        md.upmuname = upmuname;

        synchronized(MailInfode_vt){
            mailNumber = mailNumber+1;
            MailInfode_vt.addElement(md);
        }

        Logger.debug.println("[���Ϲ߼�:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+data.ENAME+"(���:"+data.PERNR.trim()+")���� "+upmuname+"�� ���� ����Ϸ� ����");

        infodecisionmailsender = new InfoDecisionMailSender();
    }

    public static void infoDecisionMailDel(WebUserData user, E27InfoDecisionData data, String upmuname) {

        Logger.debug.println("infoDecisionMailDel call: ��û ���");

        MailData md  = new MailData();

        md.user = user;
        md.data = data;
        md.upmuname = upmuname;

        synchronized(MailInfode_vt){
            mailNumber = mailNumber+1;
            MailInfode_vt.addElement(md);
        }

        Logger.debug.println("[���Ϲ߼�:"+DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber),5)+"]"+data.ENAME+"(���:"+data.PERNR.trim()+")���� "+upmuname+" ��ҿ� ���� ����Ϸ� ����");

        infodecisionmailsenderdel = new InfoDecisionMailSenderDel();
    }

    // 2004.10.14 - ��й�ȣ ã�� ����
    public static void pwsendMail(WebUserData user, String originPwd) {

        Logger.debug.println("sendMail call: ��û");

        MailData md  = new MailData();

        md.user = user;
        md.stext = originPwd;  // Password
   
        synchronized(Mail_vt){
            mailNumber = mailNumber+1;
            Mail_vt.addElement(md);
        }

        Logger.debug.println("[���Ϲ߼�: ESS �н����� Ȯ�ο� ���� ����");

        pwsearchmailsender = new PWSearchMailSender();
    }
}
        