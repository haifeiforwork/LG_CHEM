// Decompiled by DJ v3.4.4.74 Copyright 2003 Atanas Neshkov  Date: 2007-08-30 ¿ÀÈÄ 4:02:49
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3) 
// Source File Name:   MailSender2.java

package hris.common.mail;

import com.sns.jdf.Configuration;
import com.sns.jdf.Logger;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.PersonData;
import hris.common.rfc.PersonInfoRFC;

import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Date;

// Referenced classes of package hris.common.mail:
//            MailData2, MailMgr2

public class MailSender2 extends Thread
{

    public MailSender2()
    {
        Thread thread = new Thread(this);
        thread.start();
    }

    public void run()
    {
        MailData2 maildata2 = null;
        boolean flag = false;
        try
        {
            do
            {
                int i;
                synchronized(MailMgr2.Mail_vt)
                {
                    i = MailMgr2.Mail_vt.size();
                    Logger.debug.println(this, "Thread : MailMgr.Mail_vt.size() :" + i);
                    if(i > 0)
                    {
                        maildata2 = (MailData2)MailMgr2.Mail_vt.get(0);
                        maildata2.mailNumber = MailMgr2.mailNumber;
                        MailMgr2.Mail_vt.remove(0);
                    }
                }
                if(i > 0)
                {
                    send(maildata2);
                } else
                {
                    int j = 5000;
                    try
                    {
                        Configuration configuration = new Configuration();
                        j = configuration.getInt("com.sns.jdf.mail.SLEEP");
                    }
                    catch(Exception exception1)
                    {
                        j = 5000;
                        Logger.debug.println(this, "Thread : configException :" + exception1.getMessage());
                    }
                    Logger.debug.println(this, "Thread : sleepTime :" + j);
                    Thread.sleep(j);
                }
            } while(true);
        }
        catch(Exception exception)
        {
            Logger.debug.println(this, "run())" + exception);
        }
    }

    public void send(MailData2 maildata2)
    {
        try
        {
            Configuration configuration = new Configuration();
            PersonInfoRFC phonenumrfc = new PersonInfoRFC();
            PersonData phonenumdata = new PersonData();
            String s = configuration.get("com.sns.jdf.mail.HOST");
            String s1 = configuration.get("com.sns.jdf.mail.MAILFROM");
            String s2 = configuration.get("com.sns.jdf.mail.MAILTO");
            phonenumdata = (PersonData)phonenumrfc.getPersonInfo(maildata2.user2.empNo);
            String s3 = s1;
            String s4 = s2.equalsIgnoreCase("Yes") ? phonenumdata.E_MAIL : s2;
            String s5 = "[" + maildata2.upmuname.trim() + "]" + maildata2.user2.ename.trim() + "\uB2D8\uC758 " + maildata2.upmuname.trim() + "\uC5D0 \uB300\uD55C \uACB0\uC7AC\uC694\uCCAD \uC548\uB0B4";
            String s6 = "     " + maildata2.user2.ename.trim() + "(\uC0AC\uBC88:" + maildata2.user2.empNo.trim() + ")\uB2D8\uC774 " + maildata2.upmuname.trim() + "\uC744 \uD558\uC168\uC2B5\uB2C8\uB2E4.\r\n     MDT \uC0C1\uC5D0\uC11C \uD655\uC778\uD574\uC8FC\uC2DC\uAE30 \uBC14\uB78D\uB2C8\uB2E4.";
            java.util.Properties properties = System.getProperties();
            properties.put("mail.smtp.host", s);
            Session session = Session.getDefaultInstance(properties, null);
            MimeMessage mimemessage = new MimeMessage(session);
            mimemessage.setFrom(new InternetAddress(s3));
            mimemessage.setRecipients(javax.mail.Message.RecipientType.TO, InternetAddress.parse(s4, false));
            mimemessage.setSubject(s5, "ks_c_5601-1987");
            mimemessage.setText(s6);
            mimemessage.setHeader("Content-type", "text/plain; charset = EUC_KR");
            mimemessage.setSentDate(new Date());
            Transport.send(mimemessage);
            StringBuffer stringbuffer = new StringBuffer();
            stringbuffer.append("[\uBA54\uC77C \uBC1C\uC1A1 : " + DataUtil.fixEndZero(WebUtil.printNumFormat(maildata2.mailNumber), 5) + "]\r\n");
            stringbuffer.append("[\uBCF4\uB0B4\uB294 \uC0AC\uB78C] " + s3 + "\r\n");
            stringbuffer.append("[\uBC1B\uB294   \uC0AC\uB78C] " + s4 + "\r\n");
            stringbuffer.append("[\uC81C       \uBAA9] " + s5 + "\r\n");
            stringbuffer.append("[\uB0B4       \uC6A9] " + s6);
            Logger.debug.println(stringbuffer.toString());
        }
        catch(Exception exception)
        {
            Logger.debug.println(this, "Exception : " + exception.getMessage());
            Logger.debug.println(this, "mailData : " + maildata2.toString());
        }
    }
}