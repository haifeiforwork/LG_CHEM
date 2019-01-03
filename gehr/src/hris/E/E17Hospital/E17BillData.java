package hris.E.E17Hospital ;

/**
 * E17BillData.java
 *  사원의 진료비 계산서 내역을 담는 데이터
 *   [관련 RFC] : ZHRW_RFC_MEDIC_LIST
 * 
 * @author 김성일
 * @version 1.0, 2002/01/08
 */
public class E17BillData extends com.sns.jdf.EntityData {
//  public String BEGDA     ;      // 시작일
    public String MANDT     ;      // 클라이언트           
    public String PERNR     ;      // 사원번호
    public String CTRL_NUMB ;      // 관리번호
    public String RCPT_NUMB ;      // 영수증번호
    public String AINF_SEQN ;      // 결재정보 일련번호
    public String TOTL_WONX ;      // 총 진료비
    public String ASSO_WONX ;      // 조합 부담금
    public String EMPL_WONX ;      // 본인 부담금
    public String MEAL_WONX ;      // 식대
    public String APNT_WONX ;      // 지정 진료비
    public String ROOM_WONX ;      // 상급 병실료 차액
    public String CTXX_WONX ;      // C T 검사비
    public String MRIX_WONX ;      // M R I 검사비
    public String SWAV_WONX ;      // 초음파 검사비
    public String DISC_WONX ;      // 할인금액 
    public String ETC1_WONX ;      // 기타1 의 금액
    public String ETC1_TEXT ;      // 기타1 의 항목명
    public String ETC2_WONX ;      // 기타2 의 금액
    public String ETC2_TEXT ;      // 기타2 의 항목명
    public String ETC3_WONX ;      // 기타3 의 금액
    public String ETC3_TEXT ;      // 기타3 의 항목명
    public String ETC4_WONX ;      // 기타4 의 금액
    public String ETC4_TEXT ;      // 기타4 의 항목명
    public String ETC5_WONX ;      // 기타5 의 금액
    public String ETC5_TEXT ;      // 기타5 의 항목명
    public String WAERS     ;      // 통화키

    public String getMANDT() {
        return MANDT;
    }

    public void setMANDT(String MANDT) {
        this.MANDT = MANDT;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getCTRL_NUMB() {
        return CTRL_NUMB;
    }

    public void setCTRL_NUMB(String CTRL_NUMB) {
        this.CTRL_NUMB = CTRL_NUMB;
    }

    public String getRCPT_NUMB() {
        return RCPT_NUMB;
    }

    public void setRCPT_NUMB(String RCPT_NUMB) {
        this.RCPT_NUMB = RCPT_NUMB;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getTOTL_WONX() {
        return TOTL_WONX;
    }

    public void setTOTL_WONX(String TOTL_WONX) {
        this.TOTL_WONX = TOTL_WONX;
    }

    public String getASSO_WONX() {
        return ASSO_WONX;
    }

    public void setASSO_WONX(String ASSO_WONX) {
        this.ASSO_WONX = ASSO_WONX;
    }

    public String getEMPL_WONX() {
        return EMPL_WONX;
    }

    public void setEMPL_WONX(String EMPL_WONX) {
        this.EMPL_WONX = EMPL_WONX;
    }

    public String getMEAL_WONX() {
        return MEAL_WONX;
    }

    public void setMEAL_WONX(String MEAL_WONX) {
        this.MEAL_WONX = MEAL_WONX;
    }

    public String getAPNT_WONX() {
        return APNT_WONX;
    }

    public void setAPNT_WONX(String APNT_WONX) {
        this.APNT_WONX = APNT_WONX;
    }

    public String getROOM_WONX() {
        return ROOM_WONX;
    }

    public void setROOM_WONX(String ROOM_WONX) {
        this.ROOM_WONX = ROOM_WONX;
    }

    public String getCTXX_WONX() {
        return CTXX_WONX;
    }

    public void setCTXX_WONX(String CTXX_WONX) {
        this.CTXX_WONX = CTXX_WONX;
    }

    public String getMRIX_WONX() {
        return MRIX_WONX;
    }

    public void setMRIX_WONX(String MRIX_WONX) {
        this.MRIX_WONX = MRIX_WONX;
    }

    public String getSWAV_WONX() {
        return SWAV_WONX;
    }

    public void setSWAV_WONX(String SWAV_WONX) {
        this.SWAV_WONX = SWAV_WONX;
    }

    public String getDISC_WONX() {
        return DISC_WONX;
    }

    public void setDISC_WONX(String DISC_WONX) {
        this.DISC_WONX = DISC_WONX;
    }

    public String getETC1_WONX() {
        return ETC1_WONX;
    }

    public void setETC1_WONX(String ETC1_WONX) {
        this.ETC1_WONX = ETC1_WONX;
    }

    public String getETC1_TEXT() {
        return ETC1_TEXT;
    }

    public void setETC1_TEXT(String ETC1_TEXT) {
        this.ETC1_TEXT = ETC1_TEXT;
    }

    public String getETC2_WONX() {
        return ETC2_WONX;
    }

    public void setETC2_WONX(String ETC2_WONX) {
        this.ETC2_WONX = ETC2_WONX;
    }

    public String getETC2_TEXT() {
        return ETC2_TEXT;
    }

    public void setETC2_TEXT(String ETC2_TEXT) {
        this.ETC2_TEXT = ETC2_TEXT;
    }

    public String getETC3_WONX() {
        return ETC3_WONX;
    }

    public void setETC3_WONX(String ETC3_WONX) {
        this.ETC3_WONX = ETC3_WONX;
    }

    public String getETC3_TEXT() {
        return ETC3_TEXT;
    }

    public void setETC3_TEXT(String ETC3_TEXT) {
        this.ETC3_TEXT = ETC3_TEXT;
    }

    public String getETC4_WONX() {
        return ETC4_WONX;
    }

    public void setETC4_WONX(String ETC4_WONX) {
        this.ETC4_WONX = ETC4_WONX;
    }

    public String getETC4_TEXT() {
        return ETC4_TEXT;
    }

    public void setETC4_TEXT(String ETC4_TEXT) {
        this.ETC4_TEXT = ETC4_TEXT;
    }

    public String getETC5_WONX() {
        return ETC5_WONX;
    }

    public void setETC5_WONX(String ETC5_WONX) {
        this.ETC5_WONX = ETC5_WONX;
    }

    public String getETC5_TEXT() {
        return ETC5_TEXT;
    }

    public void setETC5_TEXT(String ETC5_TEXT) {
        this.ETC5_TEXT = ETC5_TEXT;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }
}
