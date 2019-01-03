// Decompiled by DJ v3.4.4.74 Copyright 2003 Atanas Neshkov  Date: 2007-08-10 ¿ÀÈÄ 2:02:17
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3) 
// Source File Name:   MailMgr2.java

package hris.common.mail;

import com.sns.jdf.Logger;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E27InfoDecision.E27InfoDecisionData;
import hris.common.PersonData;
import hris.common.WebUserData;
import java.util.Vector;

// Referenced classes of package hris.common.mail:
//            InfoDecisionMailSender, InfoDecisionMailSenderDel, InfoMailSenderDel, InfoMailSender, 
//            MailData, MailData2, MailSender2, MailSenderDel

public class MailMgr2
{

    public MailMgr2()
    {
    }

    public static void infoDecisionMail(WebUserData webuserdata, E27InfoDecisionData e27infodecisiondata, String s)
    {
        Logger.debug.println("infoDecisionMail call: \uC2E0\uCCAD");
        MailData maildata = new MailData();
        maildata.user = webuserdata;
        maildata.data = e27infodecisiondata;
        maildata.upmuname = s;
        synchronized(MailInfode_vt)
        {
            mailNumber++;
            MailInfode_vt.addElement(maildata);
        }
        Logger.debug.println("[\uBA54\uC77C\uBC1C\uC1A1:" + DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber), 5) + "]" + e27infodecisiondata.ENAME + "(\uC0AC\uBC88:" + e27infodecisiondata.PERNR.trim() + ")\uB2D8\uC758 " + s + "\uC5D0 \uAD00\uD55C \uACB0\uC7AC\uC644\uB8CC \uBA54\uC77C");
        infodecisionmailsender = new InfoDecisionMailSender();
    }

    public static void infoDecisionMailDel(WebUserData webuserdata, E27InfoDecisionData e27infodecisiondata, String s)
    {
        Logger.debug.println("infoDecisionMailDel call: \uC2E0\uCCAD \uCDE8\uC18C");
        MailData maildata = new MailData();
        maildata.user = webuserdata;
        maildata.data = e27infodecisiondata;
        maildata.upmuname = s;
        synchronized(MailInfode_vt)
        {
            mailNumber++;
            MailInfode_vt.addElement(maildata);
        }
        Logger.debug.println("[\uBA54\uC77C\uBC1C\uC1A1:" + DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber), 5) + "]" + e27infodecisiondata.ENAME + "(\uC0AC\uBC88:" + e27infodecisiondata.PERNR.trim() + ")\uB2D8\uC758 " + s + " \uCDE8\uC18C\uC5D0 \uAD00\uD55C \uACB0\uC7AC\uC644\uB8CC \uBA54\uC77C");
        infodecisionmailsenderdel = new InfoDecisionMailSenderDel();
    }

    public static void infosendMail(WebUserData webuserdata, String s, String s1)
    {
        Logger.debug.println("infosendMail call: \uC2E0\uCCAD");
        MailData maildata = new MailData();
        maildata.user = webuserdata;
        maildata.gempNo = s;
        maildata.upmuname = s1;
        synchronized(MailInfo_vt)
        {
            mailNumber++;
            MailInfo_vt.addElement(maildata);
        }
        Logger.debug.println("[\uBA54\uC77C\uBC1C\uC1A1:" + DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber), 5) + "]" + webuserdata.ename + "(\uC0AC\uBC88:" + webuserdata.empNo.trim() + ")\uB2D8\uC758 " + s1 + "\uC5D0 \uAD00\uD55C \uBA54\uC77C");
        infomailsender = new InfoMailSender();
    }

    public static void infosendMailDel(WebUserData webuserdata, String s, String s1)
    {
        Logger.debug.println("infosendMailDel call: \uC2E0\uCCAD \uCDE8\uC18C");
        MailData maildata = new MailData();
        maildata.user = webuserdata;
        maildata.gempNo = s;
        maildata.upmuname = s1;
        synchronized(MailInfo_vt)
        {
            mailNumber++;
            MailInfo_vt.addElement(maildata);
        }
        Logger.debug.println("[\uBA54\uC77C\uBC1C\uC1A1:" + DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber), 5) + "]" + webuserdata.ename + "(\uC0AC\uBC88:" + webuserdata.empNo.trim() + ")\uB2D8\uC758 " + s1 + " \uCDE8\uC18C\uC5D0 \uAD00\uD55C \uBA54\uC77C");
        infomailsenderdel = new InfoMailSenderDel();
    }

    public static void sendMail(WebUserData webuserdata, PersonData phonenumdata, String s)
    {
        Logger.debug.println("sendMail call: \uC2E0\uCCAD");
        MailData2 maildata2 = new MailData2();
        maildata2.user2 = webuserdata;
        maildata2.phonenumdata2 = phonenumdata;
        maildata2.upmuname = s;
        synchronized(Mail_vt)
        {
            mailNumber++;
            Mail_vt.addElement(maildata2);
        }
        Logger.debug.println("[\uBA54\uC77C\uBC1C\uC1A1:" + DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber), 5) + "]" + webuserdata.ename + "(\uC0AC\uBC88:" + webuserdata.empNo.trim() + ")\uB2D8\uC758 " + s + "\uC5D0 \uAD00\uD55C \uBA54\uC77C");
        mailsender = new MailSender2();
    }

    public static void sendMailDel(WebUserData webuserdata, Vector vector, String s)
    {
        Logger.debug.println("sendMailDel call: \uC2E0\uCCAD \uCDE8\uC18C");
        MailData maildata = new MailData();
        maildata.user = webuserdata;
        maildata.AppLineData_vt = vector;
        maildata.upmuname = s;
        synchronized(Mail_vt)
        {
            mailNumber++;
            Mail_vt.addElement(maildata);
        }
        Logger.debug.println("[\uC2E0\uCCAD \uCDE8\uC18C \uBA54\uC77C\uBC1C\uC1A1:" + DataUtil.fixEndZero(WebUtil.printNumFormat(mailNumber), 5) + "]" + webuserdata.ename + "(\uC0AC\uBC88:" + webuserdata.empNo.trim() + ")\uB2D8\uC758 " + s + " \uCDE8\uC18C\uC5D0 \uAD00\uD55C \uBA54\uC77C");
        mailsenderdel = new MailSenderDel();
    }

    private static MailSender2 mailsender = null;
    private static MailSenderDel mailsenderdel = null;
    private static InfoMailSender infomailsender = null;
    private static InfoMailSenderDel infomailsenderdel = null;
    private static InfoDecisionMailSender infodecisionmailsender = null;
    private static InfoDecisionMailSenderDel infodecisionmailsenderdel = null;
    public static Vector Mail_vt = new Vector();
    public static Vector MailInfo_vt = new Vector();
    public static Vector MailInfode_vt = new Vector();
    public static long mailNumber = 0L;

}