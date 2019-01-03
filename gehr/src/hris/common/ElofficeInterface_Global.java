/*
 * 작성된 날짜: 2005. 2. 2.
 *
 */
package hris.common;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.Properties;

import com.sns.jdf.*;
import com.sns.jdf.Logger;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.common.mail.*;
import hris.common.rfc.PhoneNumRFC;

/**
 * @author 이승희
 *
 */
public class ElofficeInterface_Global
{
    private Properties ptBody;
    private String  fileName = "NoticeMail1.html";
    private String  from_empNo;
    private String  to_empNo;
    private String  subject;
    private String  Message =   "";
    
    /**
     * @param ptBody
     */
    public ElofficeInterface_Global(Properties ptBody) throws ConfigurationException
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
        
        //멜 발송
        if (!sendMail(from_empNo ,to_empNo ,subject ,fileName ,ptBody)) {
            Message += "E-Mail 발송 에러";
            isSuccess = false;
        } // end if
        
        if (!sendEloffice()) {
            Message += "ElOffice 전자 결재 에러 발생 ";
            isSuccess = false;
        } // end if
        return isSuccess;
    }
    
    public boolean sendMail(String from_empNo, String to_empNo, String subject,
            String fileName, Properties ptMailBody) 
    {
        
        PhoneNumRFC     numfunc        =    new PhoneNumRFC();
        PhoneNumData    pd             =    null;
        MailEntity      me             =    new MailEntity();
        boolean     isSuccess  = false; 
        
        try {
            pd = (PhoneNumData)numfunc.getPhoneNum(from_empNo);
            
            me.setFrom(pd.E_MAIL);
            me.setName(pd.E_ENAME+"("+pd.E_ORGTX+")");
            
            pd = (PhoneNumData)numfunc.getPhoneNum(to_empNo);
            String[]    to = new String[1];
            to[0] = pd.E_MAIL;
            me.setTo(to);
            me.setSubject(subject);
            
            if (fileName != null) {
                Config conf     = new Configuration();
                String tempPath     = conf.get("com.sns.jdf.mail.TEMPPATH");
                tempPath += fileName;
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
            Logger.debug.println(this ,DataUtil.getStackTrace(e));
        }
        return isSuccess;
    }
   
    public boolean sendEloffice()
    {
        boolean isSuccess = true;
        String ElofficeURL =   "http://" + ptBody.getProperty("SServer" ,"");
        
        StringBuffer sbUrl =  new StringBuffer(1024);
        
        String parameters[] = { "Subject" ,"DocID" , "LinkURL" ,"HDocStatus" , "WriterSabun" 
                    ,"HCurApproverSabun" , "HDoneApproverSabun" ,"HrealApproverListSabun" ,"HRefListSabun" };
        try {
            
            sbUrl.append(ElofficeURL);
            
            for (int i = 0; i < parameters.length; i++) {
                String string = parameters[i];
                sbUrl.append(string + "="+ i);
                if (i != parameters.length - 1) {
                    sbUrl.append("&");
                } // end if
            } // end for
            
            URL url = new URL(sbUrl.toString());
            URLConnection urlCnn = url.openConnection();
            urlCnn.connect();
            BufferedReader in = new BufferedReader(new InputStreamReader(urlCnn.getInputStream()));
            
            String strHtml;
            
            while ((strHtml = in.readLine()) != null) {
                Logger.debug.println(strHtml);
            } // end while
            
        } catch (Exception e) {
            Logger.debug.println(this ,DataUtil.getStackTrace(e));
            isSuccess = false;
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
