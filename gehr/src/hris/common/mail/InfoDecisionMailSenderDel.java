package hris.common.mail;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

import com.sns.jdf.*;
import  com.sns.jdf.util.*;

import hris.common.*;
import hris.common.rfc.*;


/**
 * InfoDecisionMailSenderDel.java
 * �����ְ��翡�� JavaMail ��Ű���� ����Ͽ� ������ ������ �ִ� Class
 *
 * @author ������
 * @version 1.0, 2001/12/13
 */
public class InfoDecisionMailSenderDel extends Thread {

    public InfoDecisionMailSenderDel() {

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

     try{
        while(true) {
            synchronized(MailMgr.MailInfode_vt) {
                vtsize = MailMgr.MailInfode_vt.size();
                Logger.debug.println(this,"Thread : MailMgr.MailInfode_vt.size() :"+vtsize);

                if( vtsize > 0 ) {
                    maildata = (MailData)MailMgr.MailInfode_vt.get(0);
                    maildata.mailNumber = MailMgr.mailNumber;
                    MailMgr.MailInfode_vt.remove(0);

                }
            }

            if( vtsize > 0 ) {

               this.send(maildata);

            } else {
              Config conf = new Configuration();
              Thread.sleep(conf.getInt("com.sns.jdf.mail.SLEEP"));
            }
        }
     } catch(Exception e) {Logger.debug.println(this,"run())"+e);}

    }

    public void send(MailData maildata) throws GeneralException {

        try{

            Config           conf           = new Configuration();
            PersonInfoRFC numfunc        = new PersonInfoRFC();
            PersonData phonenumdata   = new PersonData();
            PersonData phonenumdata1   = new PersonData();


            phonenumdata = (PersonData)numfunc.getPersonInfo(maildata.data.PERNR);
            phonenumdata1 = (PersonData)numfunc.getPersonInfo(maildata.user.empNo);

            String HOST     = conf.get("com.sns.jdf.mail.HOST");
            String MAILFROM = phonenumdata1.E_MAIL;
            String MAILTO   = conf.get("com.sns.jdf.mail.MAILTO");

            String mailto   = MAILTO.equalsIgnoreCase("Yes") ? phonenumdata.E_MAIL : MAILTO;
            String subject  = "["+maildata.upmuname.trim()+" ���]"+maildata.data.ENAME.trim()+"���� "+ maildata.upmuname.trim() +"�� ���� ��Ҿȳ�";


            // 2004.09.22 LGȭ�и��Ͽ��� text ������ ����� ǥ������ ���ؼ� html code �������� ���� ����.
            //String content  = "     "+maildata.data.ENAME.trim()+"(���:"+maildata.data.PERNR.trim()+")���� "+ maildata.upmuname.trim() +"�� ����ϼ̽��ϴ�.";
            String content  = "<table><tr><td width=17>&nbsp;</td><td>"+maildata.data.ENAME.trim()+"(���:"+maildata.data.PERNR.trim()+")���� "+ maildata.upmuname.trim() +"�� ����ϼ̽��ϴ�.</td></tr></table>";


            Properties props = System.getProperties();
            props.put("mail.smtp.host",HOST);

            Session msgSession = Session.getDefaultInstance(props, null);

            MimeMessage msg = new MimeMessage(msgSession);
            msg.setFrom(new InternetAddress(MAILFROM));
            msg.setRecipients(Message.RecipientType.TO,InternetAddress.parse(mailto , false));

            msg.setSubject(subject,"ks_c_5601-1987");
            msg.setText(content);
            msg.setHeader("Content-type","text/html; charset = EUC_KR");
            msg.setSentDate(new Date());
            Transport.send(msg);

            StringBuffer sb = new StringBuffer();
            sb.append("[���� �߼� : "+DataUtil.fixEndZero(WebUtil.printNumFormat(maildata.mailNumber),5)+"]\r\n");
            sb.append("[������ ���] "+MAILFROM+"\r\n");
            sb.append("[�޴�   ���] "+mailto+"\r\n");
            sb.append("[��       ��] "+subject+"\r\n");
            sb.append("[��       ��] "+content);

            Logger.debug.println(sb.toString());

          } catch(Exception e) {
              throw new GeneralException(e);
        }

    }

}

