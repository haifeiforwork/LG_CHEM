/*
 * 작성된 날짜: 2005. 1. 28.
 *
 */
package hris.common.mail;

import java.util.Hashtable;

/**
 * @author 이승희
 *
 */
public class MailEntity 
{
    private String from;
    private String name;   
    private String to[],bcc[],cc[];
    private String subject;
    private String content;
    private Hashtable header;
    private String fileName[];
    private String contentType = "text/plain";  //default
    
    /**
     * 
     */
    public MailEntity() {
        
    }
    
    /**
     * @return bcc을 리턴합니다.
     */
    public String[] getBcc() {
        return bcc;
    }
    /**
     * @param bcc 설정하려는 bcc.
     */
    public void setBcc(String[] bcc) {
        this.bcc = bcc;
    }
    /**
     * @return cc을 리턴합니다.
     */
    public String[] getCc() {
        return cc;
    }
    /**
     * @param cc 설정하려는 cc.
     */
    public void setCc(String[] cc) {
        this.cc = cc;
    }
    /**
     * @return content을 리턴합니다.
     */
    public String getContent() {
        return content;
    }
    /**
     * @param content 설정하려는 content.
     */
    public void setContent(String content) {
        this.content = content;
    }
    /**
     * @return contentType을 리턴합니다.
     */
    public String getContentType() {
        return contentType;
    }
    /**
     * @param contentType 설정하려는 contentType.
     */
    public void setContentType(String contentType) {
        this.contentType = contentType;
    }
    /**
     * @return fileName을 리턴합니다.
     */
    public String[] getFileName() {
        return fileName;
    }
    /**
     * @param fileName 설정하려는 fileName.
     */
    public void setFileName(String[] fileName) {
        this.fileName = fileName;
    }
    /**
     * @return from을 리턴합니다.
     */
    public String getFrom() {
        return from;
    }
    /**
     * @param from 설정하려는 from.
     */
    public void setFrom(String from) {
        this.from = from;
    }
    /**
     * @return header을 리턴합니다.
     */
    public Hashtable getHeader() {
        return header;
    }
    /**
     * @param header 설정하려는 header.
     */
    public void setHeader(Hashtable header) {
        this.header = header;
    }
    /**
     * @return name을 리턴합니다.
     */
    public String getName() {
        return name;
    }
    /**
     * @param name 설정하려는 name.
     */
    public void setName(String name) {
        this.name = name;
    }
    /**
     * @return subject을 리턴합니다.
     */
    public String getSubject() {
        return subject;
    }
    /**
     * @param subject 설정하려는 subject.
     */
    public void setSubject(String subject) {
        this.subject = subject;
    }
    /**
     * @return to을 리턴합니다.
     */
    public String[] getTo() {
        return to;
    }
    /**
     * @param to 설정하려는 to.
     */
    public void setTo(String[] to) {
        this.to = to;
    }
}
