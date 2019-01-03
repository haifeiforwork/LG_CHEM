package	hris.A;

/**
 * A09CareerDetailData.java
 * �ٹ���� ������ ��ƿ��� ������
 *  [���� RFC] : ZHRH_RFC_CAREER
 * 
 * @author �赵��    
 * @version 1.0, 2001/12/19
 */
public class A09CareerDetailData extends com.sns.jdf.EntityData {

    public String PERNR ;//	��� ��ȣ	NUMC	8	0	PERSNO
    public String BEGDA ;//	������	DATS	8	0	BEGDA
    public String ENDDA ;//	������	DATS	8	0	ENDDA
    public String PERIOD    ;//	�Ⱓ	CHAR	40	0	ZEHRPERIOD
    public String ARBGB ;//	�ٹ�ó	CHAR	60	0	ZEHRARBGB
    public String JIKWT ;//	������	CHAR	40	0	ZEHRJIKWT
    public String STLTX ;//	������	CHAR	40	0	ZEHRSTLTX

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

    public String getARBGB() {
        return ARBGB;
    }

    public void setARBGB(String ARBGB) {
        this.ARBGB = ARBGB;
    }

    public String getJIKWT() {
        return JIKWT;
    }

    public void setJIKWT(String JIKWT) {
        this.JIKWT = JIKWT;
    }

    public String getSTLTX() {
        return STLTX;
    }

    public void setSTLTX(String STLTX) {
        this.STLTX = STLTX;
    }
}
