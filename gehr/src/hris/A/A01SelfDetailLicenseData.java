package hris.A;

import com.sns.jdf.EntityData;

/**
 * A01SelfDetailLicenseData.java
 * 자격 데이타
 *   [관련 RFC] : ZGHR_RFC_LICENSE_LIST
 * 
 * @author 정진만
 * @version 1.0, 2016/08/08
 */
public class A01SelfDetailLicenseData extends EntityData {

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	BEGDA	;//	DATS	8	시작일
    public String 	ENDDA	;//	DATS	8	종료일
    public String 	LICNCD	;//	CHAR	4	자격면허 코드
    public String 	LICNNM	;//	CHAR	60	자격면허명
    public String 	OBNDAT	;//	DATS	8	취득일
    public String 	LGRADE	;//	CHAR	2	자격등급 코드
    public String 	LGRDNM	;//	CHAR	10	자격등급명
    public String 	PBORGH	;//	CHAR	 60 	발행기관
    public String 	LAW	;//	CHAR	 1 	법정선임사유
    public String EXDATE;
    public String FLAG;
    public String LNUMBER;

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
    }

    public String getLICNCD() {
        return LICNCD;
    }

    public void setLICNCD(String LICNCD) {
        this.LICNCD = LICNCD;
    }

    public String getLICNNM() {
        return LICNNM;
    }

    public void setLICNNM(String LICNNM) {
        this.LICNNM = LICNNM;
    }

    public String getOBNDAT() {
        return OBNDAT;
    }

    public void setOBNDAT(String OBNDAT) {
        this.OBNDAT = OBNDAT;
    }

    public String getLGRADE() {
        return LGRADE;
    }

    public void setLGRADE(String LGRADE) {
        this.LGRADE = LGRADE;
    }

    public String getLGRDNM() {
        return LGRDNM;
    }

    public void setLGRDNM(String LGRDNM) {
        this.LGRDNM = LGRDNM;
    }

    public String getPBORGH() {
        return PBORGH;
    }

    public void setPBORGH(String PBORGH) {
        this.PBORGH = PBORGH;
    }

    public String getLAW() {
        return LAW;
    }

    public void setLAW(String LAW) {
        this.LAW = LAW;
    }

    public String getFLAG() {
        return FLAG;
    }

    public void setFLAG(String FLAG) {
        this.FLAG = FLAG;
    }

    public String getEXDATE() {
        return EXDATE;
    }

    public void setEXDATE(String EXDATE) {
        this.EXDATE = EXDATE;
    }

    public String getLNUMBER() {
        return LNUMBER;
    }

    public void setLNUMBER(String LNUMBER) {
        this.LNUMBER = LNUMBER;
    }
}