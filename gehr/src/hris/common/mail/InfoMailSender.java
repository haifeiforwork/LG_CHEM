package hris.common.mail;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;

import hris.common.*;
import hris.common.rfc.*;


/**
 * MailSend.java
 * 인포멀간사에게 JavaMail 패키지를 사용하여 메일을 보낼수 있는 Class
 *
 * @author 이형석
 * @version 1.0, 2001/12/13
 */
public class InfoMailSender extends Thread {

    public InfoMailSender() {

        Thread t = new Thread(this);
        t.start();
    }

    /**
     * 값을 받아 메일을 보낼 수 있는 method
     * @param java.lang.Object hris.common.mail MailData Object.
     * @return java.lang.Boolean
     * @exception com.sns.jdf.GeneralException
     */

    public void run() {

        MailData maildata = null;
        int vtsize = 0;

        try{
            while(true) {
                synchronized(MailMgr.MailInfo_vt) {
                    vtsize = MailMgr.MailInfo_vt.size();

                    Logger.debug.println(this,"Thread : MailMgr.MailInfo_vt.size() :"+vtsize);

                    if( vtsize > 0 ) {
                        maildata = (MailData)MailMgr.MailInfo_vt.get(0);
                        maildata.mailNumber = MailMgr.mailNumber;
                        MailMgr.MailInfo_vt.remove(0);

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

            String HOST     = conf.get("com.sns.jdf.mail.HOST");
            String MAILFROM = conf.get("com.sns.jdf.mail.MAILFROM");
            String MAILTO   = conf.get("com.sns.jdf.mail.MAILTO");

            phonenumdata = (PersonData)numfunc.getPersonInfo(maildata.gempNo);

            String mailfrom = MAILFROM;
            String mailto   = MAILTO.equalsIgnoreCase("Yes") ? phonenumdata.E_MAIL : MAILTO;
            String subject  = "[인포멀 "+maildata.upmuname.trim()+"]"+maildata.user.ename.trim()+"님의 인포멀 "+ maildata.upmuname.trim() +"에 대한 결재요청 안내";

            // 2004.09.22 LG화학메일에서 text 형식을 제대로 표현하지 못해서 html code 형식으로 메일 보냄.
            //String content  = "       &nbsp;&nbsp;&nbsp;"+maildata.user.ename.trim()+"(사번:"+maildata.user.empNo.trim()+" / 소속:"+maildata.user.e_orgtx.trim()+" )님이 "+ maildata.stext.trim() +" "+ maildata.upmuname.trim() +"을 하셨습니다.\r\n     &nbsp;&nbsp;&nbsp;ESS 상에서 확인해주시기 바랍니다.       ";
            String content  = "<table><tr><td width=17>&nbsp;</td><td>"+maildata.user.ename.trim()+"(사번:"+maildata.user.empNo.trim()+" / 소속:"+maildata.user.e_orgtx.trim()+")님이 "+ maildata.stext.trim() +" "+ maildata.upmuname.trim() +"을 하셨습니다.</td></tr><tr><td width=17>&nbsp;</td><td>ESS 상에서 확인해주시기 바랍니다.</a></td></tr></table>";

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
            msg.setContentID("ESS");
            Transport.send(msg);

            StringBuffer sb = new StringBuffer();
            sb.append("[메일 발송 : "+DataUtil.fixEndZero(WebUtil.printNumFormat(maildata.mailNumber),5)+"]\r\n");
            sb.append("[보내는 사람] "+mailfrom+"\r\n");
            sb.append("[받는   사람] "+mailto+"\r\n");
            sb.append("[제       목] "+subject+"\r\n");
            sb.append("[내       용] "+content);

            Logger.debug.println(sb.toString());

          } catch(Exception e) {
              throw new GeneralException(e);
        }
    }
}
