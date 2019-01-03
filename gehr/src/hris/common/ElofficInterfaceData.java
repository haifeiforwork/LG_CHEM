/*
 * 작성된 날짜: 2005. 2. 19.
 *
 */
package hris.common;

import com.sns.jdf.EntityData;

/**
 * @author 이승희
 *
 */
public class ElofficInterfaceData extends EntityData
{
    public String    CATEGORY     ;  //양식명           
    public String    MAIN_STATUS  ;  //결재 Main상태    
    public String    P_MAIN_STATUS;                     
    public String    SUB_STATUS   ;  //결재 Sub상태     
    public String    REQ_DATE     ;    //요청일         
    public String    EXPIRE_DATE  ;  //보존년한         
    public String    AUTH_DIV     ;  //공개할부서       
    public String    AUTH_EMP     ;  //공개할개인       
    public String    MODIFY       ;  //삭제구분         
    public String    F_AGREE      ;  //자동합의         
    public String    R_EMP_NO     ;  //기안자사번       
    public String    A_EMP_NO     ;  //결재자사번       
    public String    SUBJECT      ;  //양식제목         
    public String    APP_ID       ;  //결재문서ID       
    public String    URL	  ;                         
    public String    DUMMY1; //모바일 URL  ※C20110620_07375                    
    public String    TEMP	  ;  //임시변수 사용 통합결재연관없음

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
