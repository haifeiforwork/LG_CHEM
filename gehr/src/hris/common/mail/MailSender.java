package hris.common.mail;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

import com.sns.jdf.*;
import  com.sns.jdf.util.*;

import hris.common.*;
import hris.common.rfc.*;


/**
 * MailSend.java
 * JavaMail ��Ű���� ����Ͽ� ������ ������ �ִ� Class
 *
 * @author ������
 * @version 1.0, 2001/12/13
 */
public class MailSender extends Thread {

    public MailSender() {
        Thread t = new Thread(this);
        t.start();
    }

    /**
     * ���� �޾� ������ ���� �� �ִ� method
     * @param java.lang.Object hris.common.mail MailData Object.
     * @return java.lang.Boolean
     * @exception com.sns.jdf.GeneralException
     */

    public void run() {

        MailData maildata = null;
        int vtsize = 0;

     try {
        while(true) {
            synchronized(MailMgr.Mail_vt) {
                vtsize = MailMgr.Mail_vt.size();

                Logger.debug.println(this,"Thread : MailMgr.Mail_vt.size() :"+vtsize);

                if( vtsize > 0 ) {
                    maildata = (MailData)MailMgr.Mail_vt.get(0);
                    maildata.mailNumber = MailMgr.mailNumber;
                    MailMgr.Mail_vt.remove(0);
                }
            }

            if( vtsize > 0 ) {
               this.send(maildata);
            } else {
                int sleepTime = 5000;
                try {
                    Config conf = new Configuration();
                    sleepTime = conf.getInt("com.sns.jdf.mail.SLEEP");
                } catch (Exception ex) {
                    sleepTime = 5000;
                    Logger.debug.println(this,"Thread : configException :" + ex.getMessage());
                }
                Logger.debug.println(this,"Thread : sleepTime :" + sleepTime);
                Thread.sleep(sleepTime);
            }
        }
     } catch(Exception e) {Logger.debug.println(this,"run())"+e);}

    }

    public void send(MailData maildata) {
        try{
            Config           conf           = new Configuration();
            PersonInfoRFC numfunc        = new PersonInfoRFC();
            PersonData phonenumdata   = new PersonData();
            String HOST     = conf.get("com.sns.jdf.mail.HOST");
            String MAILFROM = conf.get("com.sns.jdf.mail.MAILFROM");
            String MAILTO   = conf.get("com.sns.jdf.mail.MAILTO");

            for (int i =0 ; i < maildata.AppLineData_vt.size() ; i++) {
                AppLineData appline = (AppLineData)maildata.AppLineData_vt.get(i);

                if(appline.APPL_APPR_SEQN.equals("01")&&appline.APPL_APPU_TYPE.equals("01")) {
                    phonenumdata = (PersonData)numfunc.getPersonInfo(appline.APPL_APPU_NUMB);

                    String mailfrom = MAILFROM;
                    String mailto   = MAILTO.equalsIgnoreCase("Yes") ? phonenumdata.E_MAIL : MAILTO;
                    String subject  = "["+maildata.upmuname.trim()+"]"+maildata.user.ename.trim()+"���� "+ maildata.upmuname.trim() +"�� ���� �����û �ȳ�";

                    // 2004.09.22 LGȭ�и��Ͽ��� text ������ ����� ǥ������ ���ؼ� html code �������� ���� ����.
                    //String content  = "     "+maildata.user.ename.trim()+"(���:"+maildata.user.empNo.trim()+")���� "+ maildata.upmuname.trim() +"�� �ϼ̽��ϴ�.\r\n     MDT �󿡼� Ȯ�����ֽñ� �ٶ��ϴ�.";
                    String content  = "<table><tr><td width=17>&nbsp;</td><td>"+maildata.user.ename.trim()+"(���:"+maildata.user.empNo.trim()+")���� "+ maildata.upmuname.trim() +"�� �ϼ̽��ϴ�.</td></tr><tr><td width=17>&nbsp;</td><td>MDT �󿡼� Ȯ�����ֽñ� �ٶ��ϴ�.</a></td></tr></table>";


                    Properties props = System.getProperties();
                    props.put("mail.smtp.host",HOST);
                    Session msgSession = Session.getDefaultInstance(props, null);

                    MimeMessage msg = new MimeMessage(msgSession);
                    msg.setFrom(new InternetAddress(mailfrom));
                    msg.setRecipients(Message.RecipientType.TO,InternetAddress.parse( mailto, false));
                    msg.setSubject(subject,"ks_c_5601-1987");
                    msg.setText(content);
                    msg.setHeader("Content-type","text/html; charset = EUC_KR");
                    msg.setSentDate(new Date());
                    Transport.send(msg);

                    StringBuffer sb = new StringBuffer();
                    sb.append("[���� �߼� : "+DataUtil.fixEndZero(WebUtil.printNumFormat(maildata.mailNumber),5)+"]\r\n");
                    sb.append("[������ ���] "+mailfrom+"\r\n");
                    sb.append("[�޴�   ���] "+mailto+"\r\n");
                    sb.append("[��       ��] "+subject+"\r\n");
                    sb.append("[��       ��] "+content);

                    Logger.debug.println(sb.toString());
                }
            }
        } catch(Exception e) {
              Logger.debug.println(this, "Exception : " + e.getMessage());
              Logger.debug.println(this, "mailData : " + maildata.toString());
//              throw new GeneralException(e);
        }

    }

}


