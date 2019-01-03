package hris.E.E17Hospital ;

/**
 * E17HospitalData.java
 *  사원의 의료비 상세 내역을 담는 데이터
 *   [관련 RFC] : ZHRW_RFC_MEDIC_LIST
 * 
 * @author 김성일
 * @version 1.0, 2002/01/08
 */
public class E17HospitalData extends com.sns.jdf.EntityData {
    public String BEGDA     ;      // 시작일
    public String MANDT     ;      // 클라이언트           
    public String PERNR     ;      // 사원번호
    public String CTRL_NUMB ;      // 관리번호
    public String AINF_SEQN ;      // 결재정보 일련번호
    public String MEDI_NAME ;      // 의료기관
    public String TELX_NUMB ;      // 전화번호
    public String EXAM_DATE ;      // 진료일
    public String MEDI_CODE ;      // 입원/외래
    public String MEDI_TEXT ;      // 입원/외래
    public String RCPT_CODE ;      // 영수증 구분
    public String RCPT_TEXT ;      // 영수증 구분
    public String RCPT_NUMB ;      // No. 영수증번호
    public String EMPL_WONX ;      // 본인 실납부액
    public String WAERS     ;      // 통화키
    public String COMP_WONX ;      // 회사지원액
//  2004년 연말정산 이후 사업자등록번호 필드 추가 (3.7)
    public String MEDI_NUMB ;      // 의료기관 사업자등록번호
    public String MEDI_MTHD ;      // 05.12.26 add 결재수단 (1:현금, 2:신용카드)
    public String MEDI_YEAR ;      // 05.12.26 add 연말정산제외
    public String YTAX_WONX ;      // 06.01.17 add 연말정산반영액

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

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

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getMEDI_NAME() {
        return MEDI_NAME;
    }

    public void setMEDI_NAME(String MEDI_NAME) {
        this.MEDI_NAME = MEDI_NAME;
    }

    public String getTELX_NUMB() {
        return TELX_NUMB;
    }

    public void setTELX_NUMB(String TELX_NUMB) {
        this.TELX_NUMB = TELX_NUMB;
    }

    public String getEXAM_DATE() {
        return EXAM_DATE;
    }

    public void setEXAM_DATE(String EXAM_DATE) {
        this.EXAM_DATE = EXAM_DATE;
    }

    public String getMEDI_CODE() {
        return MEDI_CODE;
    }

    public void setMEDI_CODE(String MEDI_CODE) {
        this.MEDI_CODE = MEDI_CODE;
    }

    public String getMEDI_TEXT() {
        return MEDI_TEXT;
    }

    public void setMEDI_TEXT(String MEDI_TEXT) {
        this.MEDI_TEXT = MEDI_TEXT;
    }

    public String getRCPT_CODE() {
        return RCPT_CODE;
    }

    public void setRCPT_CODE(String RCPT_CODE) {
        this.RCPT_CODE = RCPT_CODE;
    }

    public String getRCPT_TEXT() {
        return RCPT_TEXT;
    }

    public void setRCPT_TEXT(String RCPT_TEXT) {
        this.RCPT_TEXT = RCPT_TEXT;
    }

    public String getRCPT_NUMB() {
        return RCPT_NUMB;
    }

    public void setRCPT_NUMB(String RCPT_NUMB) {
        this.RCPT_NUMB = RCPT_NUMB;
    }

    public String getEMPL_WONX() {
        return EMPL_WONX;
    }

    public void setEMPL_WONX(String EMPL_WONX) {
        this.EMPL_WONX = EMPL_WONX;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }

    public String getCOMP_WONX() {
        return COMP_WONX;
    }

    public void setCOMP_WONX(String COMP_WONX) {
        this.COMP_WONX = COMP_WONX;
    }

    public String getMEDI_NUMB() {
        return MEDI_NUMB;
    }

    public void setMEDI_NUMB(String MEDI_NUMB) {
        this.MEDI_NUMB = MEDI_NUMB;
    }

    public String getMEDI_MTHD() {
        return MEDI_MTHD;
    }

    public void setMEDI_MTHD(String MEDI_MTHD) {
        this.MEDI_MTHD = MEDI_MTHD;
    }

    public String getMEDI_YEAR() {
        return MEDI_YEAR;
    }

    public void setMEDI_YEAR(String MEDI_YEAR) {
        this.MEDI_YEAR = MEDI_YEAR;
    }

    public String getYTAX_WONX() {
        return YTAX_WONX;
    }

    public void setYTAX_WONX(String YTAX_WONX) {
        this.YTAX_WONX = YTAX_WONX;
    }
}
