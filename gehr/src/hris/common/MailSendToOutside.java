/*
 * 작성된 날짜: 2014. 4. 22. eloffice메일을 사용하여 외부직원에게 메일발송 
 */
package hris.common;

import hris.common.mail.MailEntity;
import hris.common.mail.MailMrg3;
import hris.common.mail.MakeMailBody;
import hris.common.rfc.PersonInfoRFC;

import java.util.Properties;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.ConfigurationException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * @author 20140416_24713
 *
 */
public class MailSendToOutside
{
    private Properties ptBody;
    private String  fileName = "FlowerMailBuild.htmll";
    private String  from_empNo;
    private String  to_empNo;
    private String  subject;
    private String  Message =   "";
    
    /**
     * @param ptBody
     */
    public MailSendToOutside(Properties ptBody) throws ConfigurationException
    {
        Config conf  = new Configuration();
        ptBody.setProperty("ResponseURL" ,conf.getString("com.sns.jdf.mail.ResponseURL"));
        ptBody.setProperty("ImageURL" ,WebUtil.ImageURL);
        this.ptBody = ptBody;
    }
    
    public boolean process()
    {
        boolean isSuccess = true;
        
        // 멜 
        setFrom_empNo(ptBody.getProperty("from_empNo"));        // 멜 발송자 사번
        setTo_empNo(ptBody.getProperty("to_empNo"));            // 멜 수신자 사번
        
        setFileName(ptBody.getProperty("FileName" ,fileName));  // 콘테츠 내용 파일
        
        setSubject(ptBody.getProperty("subject"));
        Logger.debug.println(this, " MailSendToOutside =ptBody "+ptBody.toString() );      
        //멜 발송
        if (!sendMail(from_empNo ,to_empNo ,subject ,fileName ,ptBody)) {
            Message += "E-Mail 발송 에러";
            isSuccess = false;
        } // end if
        return isSuccess;
    }
    
    public boolean sendMail(String from_empNo, String to_empNo, String subject,
            String fileName, Properties ptMailBody) 
    {
        
        PersonInfoRFC numfunc        =    new PersonInfoRFC();
        PersonData pd             =    null;
        MailEntity      me             =    new MailEntity();
        boolean     isSuccess  = false; 
        
        try {
            pd = (PersonData)numfunc.getPersonInfo(from_empNo);
            
            me.setFrom(pd.E_MAIL);
            //me.setName(pd.E_ENAME+"("+pd.E_ORGTX+")");
            //eloffic메일쪽에서  string 짜를때 겹치는 문자인()를 null 변한하는 로직 추가
            //String aa = "EP.E&E영업팀(경인1P)";
            //me.setName(pd.E_ENAME+"("+aa.replace('(',' ').replace(')',' ')+")");
            me.setName(pd.E_ENAME+"("+pd.E_ORGTX.replace('(',' ').replace(')',' ')+")");
            
            //pd = (PersonData)numfunc.getPersonInfo(to_empNo);
             String[]    to = new String[1];
            //to[0] = pd.E_MAIL;
            to[0] = to_empNo;
            me.setTo(to);
            me.setSubject(subject);
            Logger.debug.println(this, " sendMail me: "+me.toString() );      
            Logger.debug.println(this, " sendMail getName: "+me.getName() +" sendMail getFrom: "+me.getFrom()+"to[0]:"+to[0]);    
            
            if (fileName != null) {
                Config conf     = new Configuration();
                String tempPath     = conf.get("com.sns.jdf.mail.TEMPPATH");
                tempPath += fileName;
                Logger.debug.println(this, " tempPath: "+tempPath+"ptMailBody:"+ptMailBody.toString() );      
                                
                if (ptMailBody == null) {
                    ptMailBody = new Properties();
                } // end if
                MakeMailBody mmb = new MakeMailBody(tempPath ,ptMailBody);
                me.setContent(mmb.MakeContents());
                
            } else {
                me.setContent("  ");
            } // end if
            
            (new MailMrg3()).sendMailToUsers(me);
            
            isSuccess  = true;
            
        } catch (Exception e) {
            Logger.err.println(this ,DataUtil.getStackTrace(e));
        }
        return isSuccess;
    }
   
    
    
    /**
     * @return fileName을 리턴합니다.
     */
    public String getFileName()
    {
        return fileName;
    }
    /**
     * @param fileName 설정하려는 fileName.
     */
    public void setFileName(String fileName)
    {
        this.fileName = fileName;
    }
    
    /**
     * @return from_empNo을 리턴합니다.
     */
    public String getFrom_empNo()
    {
        return from_empNo;
    }
    /**
     * @param from_empNo 설정하려는 from_empNo.
     */
    public void setFrom_empNo(String from_empNo)
    {
        this.from_empNo = from_empNo;
    }
    /**
     * @return subject을 리턴합니다.
     */
    public String getSubject()
    {
        return subject;
    }
    /**
     * @param subject 설정하려는 subject.
     */
    public void setSubject(String subject)
    {
        this.subject = subject;
    }
    /**
     * @return to_empNo을 리턴합니다.
     */
    public String getTo_empNo()
    {
        return to_empNo;
    }
    /**
     * @param to_empNo 설정하려는 to_empNo.
     */
    public void setTo_empNo(String to_empNo)
    {
        this.to_empNo = to_empNo;
    }
    /**
     * @return message을 리턴합니다.
     */
    public String getMessage()
    {
        return Message;
    }
    /**
     * @param message 설정하려는 message.
     */
    public void setMessage(String message)
    {
        Message = message;
    }
}
