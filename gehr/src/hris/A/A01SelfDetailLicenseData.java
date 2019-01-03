package hris.A;

import com.sns.jdf.EntityData;

/**
 * A01SelfDetailLicenseData.java
 * �ڰ� ����Ÿ
 *   [���� RFC] : ZGHR_RFC_LICENSE_LIST
 * 
 * @author ������
 * @version 1.0, 2016/08/08
 */
public class A01SelfDetailLicenseData extends EntityData {

    public String 	PERNR	;//	NUMC	8	��� ��ȣ
    public String 	BEGDA	;//	DATS	8	������
    public String 	ENDDA	;//	DATS	8	������
    public String 	LICNCD	;//	CHAR	4	�ڰݸ��� �ڵ�
    public String 	LICNNM	;//	CHAR	60	�ڰݸ����
    public String 	OBNDAT	;//	DATS	8	�����
    public String 	LGRADE	;//	CHAR	2	�ڰݵ�� �ڵ�
    public String 	LGRDNM	;//	CHAR	10	�ڰݵ�޸�
    public String 	PBORGH	;//	CHAR	 60 	������
    public String 	LAW	;//	CHAR	 1 	�������ӻ���
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