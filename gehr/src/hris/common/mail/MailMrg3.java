/*
 * 작성된 날짜: 2005. 1. 28.
 *
 */
package hris.common.mail;

import java.util.*;
import java.io.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

import com.sns.jdf.*;

/**
 * @author 이승희
 *
 */
public class MailMrg3
{
    public boolean sendMailToUsers(MailEntity mb) throws GeneralException 
    {
        
        boolean isSuccess = false;
        Transport trans = null;
        
        String[] to_list = mb.getTo();
        String[] bcc_list = mb.getBcc();        
        String[] cc_list = mb.getCc();      
        try {

            Config           conf           = new Configuration();
            String HOST     = conf.get("com.sns.jdf.mail.HOST");
            String MAILTO   = conf.get("com.sns.jdf.mail.MAILTO");
            
            Properties props = new Properties();
            props.put("mail.smtp.host",HOST);               // smtp서버의 주소
            //props.put("mail.smtp.auth","true");           //smtp서버에 인증을 시도한다.
            
            Session session = Session.getDefaultInstance(props,null);
            session.setDebug(false);
            
            MimeMessage message = new MimeMessage(session);
            
            // 보내는 사람 
            InternetAddress from = new InternetAddress(mb.getFrom(),mb.getName(),"utf-8");
            message.setFrom(from);
            
            //제목 설정 
            message.setSubject(mb.getSubject() ,"utf-8");
            
            if (MAILTO.equalsIgnoreCase("Yes")) {
                //  To (받는사람)
                if(to_list != null){
                    InternetAddress[] to = new InternetAddress[to_list.length];
                    for(int i=0;i<to_list.length;i++) {
                        to[i] = new InternetAddress(to_list[i]);
                        Logger.debug.println(this, " sendMailToUsers   [i]: " +i +"to[i]:"+to[i]);      
                    }
                    message.setRecipients(Message.RecipientType.TO, to);
                    
                }
            } else {
                // test
                Logger.debug.println(this, " sendMailToUsers test : " +MAILTO);      
                InternetAddress to = new InternetAddress(MAILTO);
                message.setRecipient(Message.RecipientType.TO, to);
            } // end if
            
            
            
            // Bcc (숨은참조)
            if(bcc_list != null){
                InternetAddress[] bcc = new InternetAddress[bcc_list.length];
                
                for(int i=0;i<bcc_list.length;i++) {
                    bcc[i] = new InternetAddress(bcc_list[i]);
                }
                message.setRecipients(Message.RecipientType.BCC, bcc);
            }
            
            // cc (참조)
            if(cc_list != null){
                InternetAddress[] cc = new InternetAddress[cc_list.length];
                
                for(int i=0;i<cc_list.length;i++) {
                    cc[i] = new InternetAddress(cc_list[i]);
                }
                message.setRecipients(Message.RecipientType.CC, cc);
            }
            
                       
            /**** 사용자 정의 HEADER 추가 **
                message = (MimeMessage)addMailHeader(message,mb.getHeader());
                mbp1.setContent(mb.getContent(),mb.getContentType()+"; charset=utf-8");
                mbp1.removeHeader("Content-Transfer-Encoding");
                mbp1.addHeader("Content-Transfer-Encoding", "quoted-printable");
            */
            
            // 첨부 화일
            String[] fileName = mb.getFileName();
            message.removeHeader("Content-type");
            message.setHeader("Content-type", "text/html; charset=utf-8");
            Multipart mp = new MimeMultipart("related");
                        
            if(fileName ==  null || fileName.length < 1){
                //message.setContent(mb.getContent(),"text/html; charset=utf-8");
                
                MimeBodyPart mbp = new MimeBodyPart();
                mbp.setContent(mb.getContent(),"text/html; charset=utf-8");
                mp.addBodyPart(mbp); // 내용 추가
                
            } else {
                MimeBodyPart mbp = new MimeBodyPart();
                mbp.setContent(mb.getContent(),"text/html; charset=utf-8");
                mp.addBodyPart(mbp); // 내용 추가
                
                for(int i=0; i< fileName.length; i++){
                    if(fileName[i] != null) {
                        mbp = new MimeBodyPart();
                        FileDataSource fds = new FileDataSource(fileName[i]);
                        mbp.setDataHandler(new DataHandler(fds));
                        mbp.setFileName(fds.getName());
                        mp.addBodyPart(mbp);
                    } // end if
                }
            }
            message.setContent(mp);
            message.saveChanges();
            Transport.send(message);
            isSuccess = true;
        } catch (Exception e){
            throw new GeneralException(e);
        }
        Logger.debug.println(this ,"멜 전송 성공");
        return isSuccess;
    }
    
    public String toKor(String e){
        String kor = null;
        try{
            kor = new String(e.getBytes("8859_1"),"KSC5601");
        }catch(UnsupportedEncodingException ue){
            Logger.error(ue);
        }
        return kor;
    }
    
    
        
        
    
    
    /**
     * 사용자 정의 Header setting
     * @param Object partObj, Hashtable header
     * @return Object 
     */
    private Object addMailHeader(Object partObj, Hashtable header) throws Exception{
        
        if(header == null){
            return partObj;
        }
        
        /*** header name ***/
        Enumeration headerName = header.keys();
        String headerNameStr = "";
        
        for(int i=0; headerName.hasMoreElements(); i++) {
            
            /*** header name String ****/
            headerNameStr = (String)headerName.nextElement();
            
            /**** MimeBodyPart(file attach) ****/
            if(partObj instanceof MimeBodyPart){
                ((MimeBodyPart)partObj).removeHeader(headerNameStr);
                ((MimeBodyPart)partObj).addHeader(headerNameStr,(String)header.get(headerNameStr));
                
                /**** MimeMessage ****/
            }else if(partObj instanceof MimeMessage){
                ((MimeMessage)partObj).removeHeader(headerNameStr);
                ((MimeMessage)partObj).addHeader(headerNameStr,(String)header.get(headerNameStr));
                
            }
            
        }  // end of for(...)
        
        return partObj;
    }
    
}
