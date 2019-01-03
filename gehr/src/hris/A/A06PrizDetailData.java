package	hris.A;

/**
 * A06ReWardData.java
 *  포상 List 를 담아오는 데이터
 *   [관련 RFC] : ZHRA_RFC_REWARD
 * 
 * @author 최영호    
 * @version 1.0, 2001/12/17
 */
public class A06PrizDetailData extends com.sns.jdf.EntityData {

    /* 해외 */
    public String 	AWRD_NAME	;//	ZAWRD_NAME	CHAR	60	0	Award name
    public String 	AWDTP	;//	AWDTP	CHAR	4	0	Award type
    public String 	AWDTX	;//	AWDTX	CHAR	30	0	Award description
    public String 	AWRD_DESC	;//	ZAWRD_DESC	CHAR	1000	0	Description

    /* 국내 */
    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	PRIZ_TYPE	;//	CHAR	4	포상유형
    public String 	PRIZ_GRAD	;//	CHAR	4	포상등급
    public String 	PRIZ_UNIT	;//	CHAR	1	수상단위
    public String 	PRIZ_UNIT2	;//	CHAR	1	수상단위
    public String 	BODY_UNIT	;//	CHAR	4	시상주체
    public String 	ISSU_ORGN	;//	CHAR	30	발행처
    public String 	PRIZ_RESN	;//	CHAR	60	수상내역
    public String 	PRIZ_AMNT	;//	CURR	 13 	포상금액
    public String 	WAERS	;//	CUKY	 5 	통화 키
    public String 	PAID_TYPE	;//	CHAR	 1 	급여합산
    public String 	TAXS_TYPE	;//	CHAR	 1 	과세여부
    public String 	OTHR_TYPE	;//	CHAR	 1 	기타
    public String 	GRAD_QNTY	;//	CHAR	 10 	포상점수
    public String 	CMNT_DESC	;//	CHAR	 40 	비고
    public String 	BEGDA	;//	DATS	 8 	시작일
    public String 	PRIZ_DESC	;//	CHAR	 30 	포상항목	(상위 TEXT1~3 조합)
    public String 	GRAD_TEXT	;//	CHAR	 30 	포상등급
    public String 	BODY_NAME	;//	CHAR	 10 	시상주체명
    public String 	CPRIZ_AMNT	;//	CHAR	 20 	환산금액

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getPRIZ_TYPE() {
        return PRIZ_TYPE;
    }

    public void setPRIZ_TYPE(String PRIZ_TYPE) {
        this.PRIZ_TYPE = PRIZ_TYPE;
    }

    public String getPRIZ_GRAD() {
        return PRIZ_GRAD;
    }

    public void setPRIZ_GRAD(String PRIZ_GRAD) {
        this.PRIZ_GRAD = PRIZ_GRAD;
    }

    public String getPRIZ_UNIT() {
        return PRIZ_UNIT;
    }

    public void setPRIZ_UNIT(String PRIZ_UNIT) {
        this.PRIZ_UNIT = PRIZ_UNIT;
    }

    public String getPRIZ_UNIT2() {
        return PRIZ_UNIT2;
    }

    public void setPRIZ_UNIT2(String PRIZ_UNIT2) {
        this.PRIZ_UNIT2 = PRIZ_UNIT2;
    }

    public String getBODY_UNIT() {
        return BODY_UNIT;
    }

    public void setBODY_UNIT(String BODY_UNIT) {
        this.BODY_UNIT = BODY_UNIT;
    }

    public String getISSU_ORGN() {
        return ISSU_ORGN;
    }

    public void setISSU_ORGN(String ISSU_ORGN) {
        this.ISSU_ORGN = ISSU_ORGN;
    }

    public String getPRIZ_RESN() {
        return PRIZ_RESN;
    }

    public void setPRIZ_RESN(String PRIZ_RESN) {
        this.PRIZ_RESN = PRIZ_RESN;
    }

    public String getPRIZ_AMNT() {
        return PRIZ_AMNT;
    }

    public void setPRIZ_AMNT(String PRIZ_AMNT) {
        this.PRIZ_AMNT = PRIZ_AMNT;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }

    public String getPAID_TYPE() {
        return PAID_TYPE;
    }

    public void setPAID_TYPE(String PAID_TYPE) {
        this.PAID_TYPE = PAID_TYPE;
    }

    public String getTAXS_TYPE() {
        return TAXS_TYPE;
    }

    public void setTAXS_TYPE(String TAXS_TYPE) {
        this.TAXS_TYPE = TAXS_TYPE;
    }

    public String getOTHR_TYPE() {
        return OTHR_TYPE;
    }

    public void setOTHR_TYPE(String OTHR_TYPE) {
        this.OTHR_TYPE = OTHR_TYPE;
    }

    public String getGRAD_QNTY() {
        return GRAD_QNTY;
    }

    public void setGRAD_QNTY(String GRAD_QNTY) {
        this.GRAD_QNTY = GRAD_QNTY;
    }

    public String getCMNT_DESC() {
        return CMNT_DESC;
    }

    public void setCMNT_DESC(String CMNT_DESC) {
        this.CMNT_DESC = CMNT_DESC;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getPRIZ_DESC() {
        return PRIZ_DESC;
    }

    public void setPRIZ_DESC(String PRIZ_DESC) {
        this.PRIZ_DESC = PRIZ_DESC;
    }

    public String getGRAD_TEXT() {
        return GRAD_TEXT;
    }

    public void setGRAD_TEXT(String GRAD_TEXT) {
        this.GRAD_TEXT = GRAD_TEXT;
    }

    public String getBODY_NAME() {
        return BODY_NAME;
    }

    public void setBODY_NAME(String BODY_NAME) {
        this.BODY_NAME = BODY_NAME;
    }

    public String getCPRIZ_AMNT() {
        return CPRIZ_AMNT;
    }

    public void setCPRIZ_AMNT(String CPRIZ_AMNT) {
        this.CPRIZ_AMNT = CPRIZ_AMNT;
    }

    public String getAWRD_NAME() {
        return AWRD_NAME;
    }

    public void setAWRD_NAME(String AWRD_NAME) {
        this.AWRD_NAME = AWRD_NAME;
    }

    public String getAWDTP() {
        return AWDTP;
    }

    public void setAWDTP(String AWDTP) {
        this.AWDTP = AWDTP;
    }

    public String getAWDTX() {
        return AWDTX;
    }

    public void setAWDTX(String AWDTX) {
        this.AWDTX = AWDTX;
    }

    public String getAWRD_DESC() {
        return AWRD_DESC;
    }

    public void setAWRD_DESC(String AWRD_DESC) {
        this.AWRD_DESC = AWRD_DESC;
    }
}