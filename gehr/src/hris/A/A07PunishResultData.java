package hris.A;

/**
 * APunishResultData.java
 * ¡������ȸ
 *   [���� RFC] : ZHR_RFC_PUNISH_RESULT
 * 
 * @author ������ 
 * @version 1.0, 2001/12/17
 */
public class A07PunishResultData extends com.sns.jdf.EntityData {

    public String 	PERNR	;//	NUMC	8	��� ��ȣ
    public String 	PUNTY	;//	CHAR	3	¡��ó�� ����
    public String 	PUNTX	;//	CHAR	40	¡��ó�� �ؽ�Ʈ
    public String 	DISC_DATE	;//	DATS	8	¡�����Ȯ����
    public String 	BEGDA	;//	DATS	8	������
    public String 	ENDDA	;//	DATS	8	������
    public String 	PUNRS	;//	CHAR	30	ó�й�� �������
    public String 	TEXT1	;//	CHAR	72	����Ÿ�� �ؽ�Ʈ��⿡�� ����
    public String 	TEXT2	;//	CHAR	 72 	����Ÿ�� �ؽ�Ʈ��⿡�� ����
    public String 	TEXT3	;//	CHAR	 72 	����Ÿ�� �ؽ�Ʈ��⿡�� ����
    public String 	APPLY_FLAG	;//	CHAR	 1 	�ݿ�����
    public String 	ZDISC_DAYS	;//	CHAR	 20 	¡��Ⱓ
    public String 	PUNTY_TYPE	;//	CHAR	 60 	¡���׸�
    public String 	PUNTY_DEATH	;//	CHAR	 8 	�θ�����_���
    public String 	PUNTY_INJURY	;//	CHAR	 8 	�θ�����_�λ�
    public String 	PROPERTY_DAMAGE	;//	CURR	 13 	�������
    public String 	ITTEXT	;//	CHAR	 220 	����Ÿ�� TEXT	(���� TEXT1~3 ����)

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getPUNTY() {
        return PUNTY;
    }

    public void setPUNTY(String PUNTY) {
        this.PUNTY = PUNTY;
    }

    public String getPUNTX() {
        return PUNTX;
    }

    public void setPUNTX(String PUNTX) {
        this.PUNTX = PUNTX;
    }

    public String getDISC_DATE() {
        return DISC_DATE;
    }

    public void setDISC_DATE(String DISC_DATE) {
        this.DISC_DATE = DISC_DATE;
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

    public String getPUNRS() {
        return PUNRS;
    }

    public void setPUNRS(String PUNRS) {
        this.PUNRS = PUNRS;
    }

    public String getTEXT1() {
        return TEXT1;
    }

    public void setTEXT1(String TEXT1) {
        this.TEXT1 = TEXT1;
    }

    public String getTEXT2() {
        return TEXT2;
    }

    public void setTEXT2(String TEXT2) {
        this.TEXT2 = TEXT2;
    }

    public String getTEXT3() {
        return TEXT3;
    }

    public void setTEXT3(String TEXT3) {
        this.TEXT3 = TEXT3;
    }

    public String getAPPLY_FLAG() {
        return APPLY_FLAG;
    }

    public void setAPPLY_FLAG(String APPLY_FLAG) {
        this.APPLY_FLAG = APPLY_FLAG;
    }

    public String getZDISC_DAYS() {
        return ZDISC_DAYS;
    }

    public void setZDISC_DAYS(String ZDISC_DAYS) {
        this.ZDISC_DAYS = ZDISC_DAYS;
    }

    public String getPUNTY_TYPE() {
        return PUNTY_TYPE;
    }

    public void setPUNTY_TYPE(String PUNTY_TYPE) {
        this.PUNTY_TYPE = PUNTY_TYPE;
    }

    public String getPUNTY_DEATH() {
        return PUNTY_DEATH;
    }

    public void setPUNTY_DEATH(String PUNTY_DEATH) {
        this.PUNTY_DEATH = PUNTY_DEATH;
    }

    public String getPUNTY_INJURY() {
        return PUNTY_INJURY;
    }

    public void setPUNTY_INJURY(String PUNTY_INJURY) {
        this.PUNTY_INJURY = PUNTY_INJURY;
    }

    public String getPROPERTY_DAMAGE() {
        return PROPERTY_DAMAGE;
    }

    public void setPROPERTY_DAMAGE(String PROPERTY_DAMAGE) {
        this.PROPERTY_DAMAGE = PROPERTY_DAMAGE;
    }

    public String getITTEXT() {
        return ITTEXT;
    }

    public void setITTEXT(String ITTEXT) {
        this.ITTEXT = ITTEXT;
    }
}
