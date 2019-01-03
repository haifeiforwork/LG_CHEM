package hris.A;

/**
 * Created by manyjung on 2016-10-26.
 */
public class A01SelfTripFormData {

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	BEGDA	;//	DATS	8	시작일
    public String 	ENDDA	;//	DATS	8	종료일
    public String 	DEST_CITY	;//	CHAR	20	도시
    public String 	DEST_ZONE	;//	CHAR	20	국가
    public String 	PERIOD	;//	CHAR	40	기간
    public String 	RESN_FLAG	;//	CHAR	4	사유구분
    public String 	RESN_TEXT	;//	CHAR	60	사유 TEXT
    public String 	RESN_ACT	;//	CHAR	 60 	활동 내역
    public String 	RESN_ACT2	;//	CHAR	 20 	해외교육
    public String 	RESN_DESC	;//	CHAR	 250 	사유
    public String 	SORT	;//	NUMC	 2 	SORT 순서


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

    public String getDEST_CITY() {
        return DEST_CITY;
    }

    public void setDEST_CITY(String DEST_CITY) {
        this.DEST_CITY = DEST_CITY;
    }

    public String getDEST_ZONE() {
        return DEST_ZONE;
    }

    public void setDEST_ZONE(String DEST_ZONE) {
        this.DEST_ZONE = DEST_ZONE;
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

    public String getRESN_ACT() {
        return RESN_ACT;
    }

    public void setRESN_ACT(String RESN_ACT) {
        this.RESN_ACT = RESN_ACT;
    }

    public String getRESN_ACT2() {
        return RESN_ACT2;
    }

    public void setRESN_ACT2(String RESN_ACT2) {
        this.RESN_ACT2 = RESN_ACT2;
    }

    public String getRESN_DESC() {
        return RESN_DESC;
    }

    public void setRESN_DESC(String RESN_DESC) {
        this.RESN_DESC = RESN_DESC;
    }

    public String getSORT() {
        return SORT;
    }

    public void setSORT(String SORT) {
        this.SORT = SORT;
    }
}
