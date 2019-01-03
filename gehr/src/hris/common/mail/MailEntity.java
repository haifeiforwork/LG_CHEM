/*
 * �ۼ��� ��¥: 2005. 1. 28.
 *
 */
package hris.common.mail;

import java.util.Hashtable;

/**
 * @author �̽���
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
     * @return bcc�� �����մϴ�.
     */
    public String[] getBcc() {
        return bcc;
    }
    /**
     * @param bcc �����Ϸ��� bcc.
     */
    public void setBcc(String[] bcc) {
        this.bcc = bcc;
    }
    /**
     * @return cc�� �����մϴ�.
     */
    public String[] getCc() {
        return cc;
    }
    /**
     * @param cc �����Ϸ��� cc.
     */
    public void setCc(String[] cc) {
        this.cc = cc;
    }
    /**
     * @return content�� �����մϴ�.
     */
    public String getContent() {
        return content;
    }
    /**
     * @param content �����Ϸ��� content.
     */
    public void setContent(String content) {
        this.content = content;
    }
    /**
     * @return contentType�� �����մϴ�.
     */
    public String getContentType() {
        return contentType;
    }
    /**
     * @param contentType �����Ϸ��� contentType.
     */
    public void setContentType(String contentType) {
        this.contentType = contentType;
    }
    /**
     * @return fileName�� �����մϴ�.
     */
    public String[] getFileName() {
        return fileName;
    }
    /**
     * @param fileName �����Ϸ��� fileName.
     */
    public void setFileName(String[] fileName) {
        this.fileName = fileName;
    }
    /**
     * @return from�� �����մϴ�.
     */
    public String getFrom() {
        return from;
    }
    /**
     * @param from �����Ϸ��� from.
     */
    public void setFrom(String from) {
        this.from = from;
    }
    /**
     * @return header�� �����մϴ�.
     */
    public Hashtable getHeader() {
        return header;
    }
    /**
     * @param header �����Ϸ��� header.
     */
    public void setHeader(Hashtable header) {
        this.header = header;
    }
    /**
     * @return name�� �����մϴ�.
     */
    public String getName() {
        return name;
    }
    /**
     * @param name �����Ϸ��� name.
     */
    public void setName(String name) {
        this.name = name;
    }
    /**
     * @return subject�� �����մϴ�.
     */
    public String getSubject() {
        return subject;
    }
    /**
     * @param subject �����Ϸ��� subject.
     */
    public void setSubject(String subject) {
        this.subject = subject;
    }
    /**
     * @return to�� �����մϴ�.
     */
    public String[] getTo() {
        return to;
    }
    /**
     * @param to �����Ϸ��� to.
     */
    public void setTo(String[] to) {
        this.to = to;
    }
}
