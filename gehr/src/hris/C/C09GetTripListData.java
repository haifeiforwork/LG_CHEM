package hris.C;

/**
 * C03LearnDetailData.java
 *  ����� ���� �̷� ������ ��� ������
 *   [���� RFC] : ZHRE_RFC_EDUCATION
 * 
 * @author �Ѽ���
 * @version 1.0, 2001/12/20
 */
public class C09GetTripListData extends com.sns.jdf.EntityData {

    public String 	PERNR	;//	NUMC	8	��� ��ȣ
    public String 	BEGDA	;//	DATS	8	������
    public String 	ENDDA	;//	DATS	8	������
    public String 	PERIOD	;//	CHAR	40	�Ⱓ
    public String 	RESN_FLAG	;//	CHAR	4	��������
    public String 	RESN_TEXT	;//	CHAR	60	Ȱ���о�
    public String 	DEST_ZONE	;//	CHAR	20	����
    public String 	CRCL_UNIT	;//	CHAR	60	��ü
    public String 	WAY1_ZONE	;//	CHAR	 20 	������
    public String 	WAY2_ZONE	;//	CHAR	 20 	������2
    public String 	EDUC_WONX	;//	CURR	 13 	�ҿ���
    public String 	RESN_DESC	;//	CHAR	 250 	Ư�����
    public String 	WAERS	;//	CUKY	 5 	��ȭ Ű

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

    public String getPERIOD() {
        return PERIOD;
    }

    public void setPERIOD(String PERIOD) {
        this.PERIOD = PERIOD;
    }

    public String getRESN_FLAG() {
        return RESN_FLAG;
    }

    public void setRESN_FLAG(String RESN_FLAG) {
        this.RESN_FLAG = RESN_FLAG;
    }

    public String getRESN_TEXT() {
        return RESN_TEXT;
    }

    public void setRESN_TEXT(String RESN_TEXT) {
        this.RESN_TEXT = RESN_TEXT;
    }

    public String getDEST_ZONE() {
        return DEST_ZONE;
    }

    public void setDEST_ZONE(String DEST_ZONE) {
        this.DEST_ZONE = DEST_ZONE;
    }

    public String getCRCL_UNIT() {
        return CRCL_UNIT;
    }

    public void setCRCL_UNIT(String CRCL_UNIT) {
        this.CRCL_UNIT = CRCL_UNIT;
    }

    public String getWAY1_ZONE() {
        return WAY1_ZONE;
    }

    public void setWAY1_ZONE(String WAY1_ZONE) {
        this.WAY1_ZONE = WAY1_ZONE;
    }

    public String getWAY2_ZONE() {
        return WAY2_ZONE;
    }

    public void setWAY2_ZONE(String WAY2_ZONE) {
        this.WAY2_ZONE = WAY2_ZONE;
    }

    public String getEDUC_WONX() {
        return EDUC_WONX;
    }

    public void setEDUC_WONX(String EDUC_WONX) {
        this.EDUC_WONX = EDUC_WONX;
    }

    public String getRESN_DESC() {
        return RESN_DESC;
    }

    public void setRESN_DESC(String RESN_DESC) {
        this.RESN_DESC = RESN_DESC;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }
}
