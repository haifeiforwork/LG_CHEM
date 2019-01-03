package hris.C ;

/**
 * C03LearnDetailData.java
 *  사원의 교육 이력 사항을 담는 데이터
 *   [관련 RFC] : ZHRE_RFC_EDUCATION
 * 
 * @author 한성덕
 * @version 1.0, 2001/12/20
 */
public class C03LearnDetailData extends com.sns.jdf.EntityData {

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	DVEID	;//	NUMC	8	교육과정 코드
    public String 	DVSTX	;//	CHAR	40	교육과정 이름
    public String 	BEGDA	;//	DATS	8	시작일
    public String 	ENDDA	;//	DATS	8	종료일
    public String 	PERIOD	;//	CHAR	40	기간
    public String 	TESTX	;//	CHAR	40	교육기관
    public String 	STATE_ID	;//	CHAR	1	이수여부
    public String 	TASTX	;//	CHAR	 10 	교육평가결과
    public String 	TCODE	;//	CHAR	 2 	필수교육 유형 코드
    public String 	ATTXT	;//	CHAR	 40 	필수과정 유형명칭
    public String 	TFORM	;//	CHAR	 40 	교육형태

    public String LVSTX;

    public String getLVSTX() {
        return LVSTX;
    }

    public void setLVSTX(String LVSTX) {
        this.LVSTX = LVSTX;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getDVEID() {
        return DVEID;
    }

    public void setDVEID(String DVEID) {
        this.DVEID = DVEID;
    }

    public String getDVSTX() {
        return DVSTX;
    }

    public void setDVSTX(String DVSTX) {
        this.DVSTX = DVSTX;
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

    public String getTESTX() {
        return TESTX;
    }

    public void setTESTX(String TESTX) {
        this.TESTX = TESTX;
    }

    public String getSTATE_ID() {
        return STATE_ID;
    }

    public void setSTATE_ID(String STATE_ID) {
        this.STATE_ID = STATE_ID;
    }

    public String getTASTX() {
        return TASTX;
    }

    public void setTASTX(String TASTX) {
        this.TASTX = TASTX;
    }

    public String getTCODE() {
        return TCODE;
    }

    public void setTCODE(String TCODE) {
        this.TCODE = TCODE;
    }

    public String getATTXT() {
        return ATTXT;
    }

    public void setATTXT(String ATTXT) {
        this.ATTXT = ATTXT;
    }

    public String getTFORM() {
        return TFORM;
    }

    public void setTFORM(String TFORM) {
        this.TFORM = TFORM;
    }
}
