/*
 * �ۼ��� ��¥: 2005. 2. 19.
 *
 */
package hris.common;

import com.sns.jdf.EntityData;

/**
 * @author �̽���
 *
 */
public class ElofficInterfaceData extends EntityData
{
    public String    CATEGORY     ;  //��ĸ�           
    public String    MAIN_STATUS  ;  //���� Main����    
    public String    P_MAIN_STATUS;                     
    public String    SUB_STATUS   ;  //���� Sub����     
    public String    REQ_DATE     ;    //��û��         
    public String    EXPIRE_DATE  ;  //��������         
    public String    AUTH_DIV     ;  //�����Һμ�       
    public String    AUTH_EMP     ;  //�����Ұ���       
    public String    MODIFY       ;  //��������         
    public String    F_AGREE      ;  //�ڵ�����         
    public String    R_EMP_NO     ;  //����ڻ��       
    public String    A_EMP_NO     ;  //�����ڻ��       
    public String    SUBJECT      ;  //�������         
    public String    APP_ID       ;  //���繮��ID       
    public String    URL	  ;                         
    public String    DUMMY1; //����� URL  ��C20110620_07375                    
    public String    TEMP	  ;  //�ӽú��� ��� ���հ��翬������

    public String getCATEGORY() {
        return CATEGORY;
    }

    public void setCATEGORY(String CATEGORY) {
        this.CATEGORY = CATEGORY;
    }

    public String getMAIN_STATUS() {
        return MAIN_STATUS;
    }

    public void setMAIN_STATUS(String MAIN_STATUS) {
        this.MAIN_STATUS = MAIN_STATUS;
    }

    public String getP_MAIN_STATUS() {
        return P_MAIN_STATUS;
    }

    public void setP_MAIN_STATUS(String p_MAIN_STATUS) {
        P_MAIN_STATUS = p_MAIN_STATUS;
    }

    public String getSUB_STATUS() {
        return SUB_STATUS;
    }

    public void setSUB_STATUS(String SUB_STATUS) {
        this.SUB_STATUS = SUB_STATUS;
    }

    public String getREQ_DATE() {
        return REQ_DATE;
    }

    public void setREQ_DATE(String REQ_DATE) {
        this.REQ_DATE = REQ_DATE;
    }

    public String getEXPIRE_DATE() {
        return EXPIRE_DATE;
    }

    public void setEXPIRE_DATE(String EXPIRE_DATE) {
        this.EXPIRE_DATE = EXPIRE_DATE;
    }

    public String getAUTH_DIV() {
        return AUTH_DIV;
    }

    public void setAUTH_DIV(String AUTH_DIV) {
        this.AUTH_DIV = AUTH_DIV;
    }

    public String getAUTH_EMP() {
        return AUTH_EMP;
    }

    public void setAUTH_EMP(String AUTH_EMP) {
        this.AUTH_EMP = AUTH_EMP;
    }

    public String getMODIFY() {
        return MODIFY;
    }

    public void setMODIFY(String MODIFY) {
        this.MODIFY = MODIFY;
    }

    public String getF_AGREE() {
        return F_AGREE;
    }

    public void setF_AGREE(String f_AGREE) {
        F_AGREE = f_AGREE;
    }

    public String getR_EMP_NO() {
        return R_EMP_NO;
    }

    public void setR_EMP_NO(String r_EMP_NO) {
        R_EMP_NO = r_EMP_NO;
    }

    public String getA_EMP_NO() {
        return A_EMP_NO;
    }

    public void setA_EMP_NO(String a_EMP_NO) {
        A_EMP_NO = a_EMP_NO;
    }

    public String getSUBJECT() {
        return SUBJECT;
    }

    public void setSUBJECT(String SUBJECT) {
        this.SUBJECT = SUBJECT;
    }

    public String getAPP_ID() {
        return APP_ID;
    }

    public void setAPP_ID(String APP_ID) {
        this.APP_ID = APP_ID;
    }

    public String getURL() {
        return URL;
    }

    public void setURL(String URL) {
        this.URL = URL;
    }

    public String getDUMMY1() {
        return DUMMY1;
    }

    public void setDUMMY1(String DUMMY1) {
        this.DUMMY1 = DUMMY1;
    }

    public String getTEMP() {
        return TEMP;
    }

    public void setTEMP(String TEMP) {
        this.TEMP = TEMP;
    }
}
