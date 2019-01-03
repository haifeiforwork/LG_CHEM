package hris.A;

/**
 *	 A20EmergencyContactsData.java
 *  비상연락망 정보를 담아오는 데이터
 *  [관련 RFC] : ZHRE_RFC_EMG_CONTACTS [USA]
 * 
 * @author jungin   
 * @version 1.0, 2010/09/30
 */

public class A20EmergencyContactsData extends com.sns.jdf.EntityData {
 
    public String RLSHP;
    public String RLSHPTX;
    public String RLNAME;
    public String ENACHN;
    public String EVORNA;
    public String EMGPH1;
    public String EMGPH2;

    public String getRLSHP() {
        return RLSHP;
    }

    public void setRLSHP(String RLSHP) {
        this.RLSHP = RLSHP;
    }

    public String getRLSHPTX() {
        return RLSHPTX;
    }

    public void setRLSHPTX(String RLSHPTX) {
        this.RLSHPTX = RLSHPTX;
    }

    public String getRLNAME() {
        return RLNAME;
    }

    public void setRLNAME(String RLNAME) {
        this.RLNAME = RLNAME;
    }

    public String getENACHN() {
        return ENACHN;
    }

    public void setENACHN(String ENACHN) {
        this.ENACHN = ENACHN;
    }

    public String getEVORNA() {
        return EVORNA;
    }

    public void setEVORNA(String EVORNA) {
        this.EVORNA = EVORNA;
    }

    public String getEMGPH1() {
        return EMGPH1;
    }

    public void setEMGPH1(String EMGPH1) {
        this.EMGPH1 = EMGPH1;
    }

    public String getEMGPH2() {
        return EMGPH2;
    }

    public void setEMGPH2(String EMGPH2) {
        this.EMGPH2 = EMGPH2;
    }
}
