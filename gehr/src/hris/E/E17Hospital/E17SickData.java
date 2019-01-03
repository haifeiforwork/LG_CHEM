package hris.E.E17Hospital ;

/**
 * E17SickData.java
 *  사원의 의료비 상세 내역을 담는 데이터
 *   [관련 RFC] : ZHRW_RFC_LAST_RECORD[1], ZHRW_RFC_MEDIC_LIST[2]
 * 
 * @author 김성일
 * @version 1.0, 2002/01/08
 */
public class E17SickData extends com.sns.jdf.EntityData {
    public String CTRL_NUMB  ;      // 관리번호             [1,2]
    public String SICK_NAME  ;      // 상병명               [1,2]
    public String SICK_DESC1 ;      // 구체적증상           [1,2]
    public String SICK_DESC2 ;      // 구체적증상           [1,2]
    public String SICK_DESC3 ;      // 구체적증상           [1,2]
    public String SICK_DESC4 ;      // 구체적증상           [1,2]
    public String BIGO_TEXT1 ;      // 비고1                [1,2]
    public String BIGO_TEXT2 ;      // 비고2                [1,2]
    public String BIGO_TEXT3 ;      // 비고1                [1,2]
    public String BIGO_TEXT4 ;      // 비고2                [1,2]
    public String COMP_WONX  ;      // 회사지원액           [1,2]
    public String YTAX_WONX  ;      // 연말정산반영액       [1,2]
    public String WAERS      ;      // 통화키
    public String GUEN_CODE  ;      // 본인, 배우자 구분
    public String PROOF      ;      // 배우자 연말정산반영여부
    public String ENAME      ;      // 배우자, 자녀 이름
// 2005년 임단협 결과 반영(2005.05.31)
    public String OBJPS_21   ;      // 자녀 구분자
    public String REGNO      ;      // 자녀 주민번호
    public String TREA_CODE  ;      // 진료과코드 06.02.23추가
    public String TREA_TEXT  ;      // 진료과코드명 06.02.23추가
    
    public String DATUM_21   ;      // 의료비 지원이 불가능한 시작 일자

    public String SICK_DESC  ;      // 구체적증상           [   ]
    public String is_new_num ;      // 동일진료(N), 최초진료(Y) 여부 [   ]
    public String medi_count ;      // 화면상에 보여지는 진료비 행 수[   ]

    public String MANDT      ;      // 클라이언트           [ ,2]
    public String PERNR      ;      // 사원번호             [ ,2]
    public String BEGDA      ;      // 신청일               [ ,2]
    public String AINF_SEQN  ;      // 결재정보 일련번호    [ ,2]
    public String UNAME      ;      
    public String AEDTM      ;      
    // 결재 추가 
    public String RFUN_DATE  ;      //반납일자                     
    public String RFUN_RESN  ;      //반납사유                     
    public String RFUN_AMNT  ;      //지급액                       
    public String BELNR1     ;      //회계전표번호                 
    public String POST_DATE  ;      //POSTING일자                  
    public String BELNR      ;      //회계전표번호                 
    public String ZPERNR     ;      //대리신청자 사번              
    public String ZUNAME     ;      //부서서무 이름(대리신청자이름)
    //CSR ID:1357074  2008.11.13 ADD 
    public String RCPT_NUMB  ;        // 영수증번호 
    public String REGNO_21   ;        // 주민등록번호
    public String MAX_CHK    ;        // 일반플래그
    public String ORG_CTRL    ;        // 동일진료 original 관리번호 2009.01.09
    public String LAST_CTRL    ;        // 동일진료 original 의 마지막 관리번호 2009.02.03
    public String EXAM_DATE    ;        // 진료일 2009.04.14

    public String getCTRL_NUMB() {
        return CTRL_NUMB;
    }

    public void setCTRL_NUMB(String CTRL_NUMB) {
        this.CTRL_NUMB = CTRL_NUMB;
    }

    public String getSICK_NAME() {
        return SICK_NAME;
    }

    public void setSICK_NAME(String SICK_NAME) {
        this.SICK_NAME = SICK_NAME;
    }

    public String getSICK_DESC1() {
        return SICK_DESC1;
    }

    public void setSICK_DESC1(String SICK_DESC1) {
        this.SICK_DESC1 = SICK_DESC1;
    }

    public String getSICK_DESC2() {
        return SICK_DESC2;
    }

    public void setSICK_DESC2(String SICK_DESC2) {
        this.SICK_DESC2 = SICK_DESC2;
    }

    public String getSICK_DESC3() {
        return SICK_DESC3;
    }

    public void setSICK_DESC3(String SICK_DESC3) {
        this.SICK_DESC3 = SICK_DESC3;
    }

    public String getSICK_DESC4() {
        return SICK_DESC4;
    }

    public void setSICK_DESC4(String SICK_DESC4) {
        this.SICK_DESC4 = SICK_DESC4;
    }

    public String getBIGO_TEXT1() {
        return BIGO_TEXT1;
    }

    public void setBIGO_TEXT1(String BIGO_TEXT1) {
        this.BIGO_TEXT1 = BIGO_TEXT1;
    }

    public String getBIGO_TEXT2() {
        return BIGO_TEXT2;
    }

    public void setBIGO_TEXT2(String BIGO_TEXT2) {
        this.BIGO_TEXT2 = BIGO_TEXT2;
    }

    public String getBIGO_TEXT3() {
        return BIGO_TEXT3;
    }

    public void setBIGO_TEXT3(String BIGO_TEXT3) {
        this.BIGO_TEXT3 = BIGO_TEXT3;
    }

    public String getBIGO_TEXT4() {
        return BIGO_TEXT4;
    }

    public void setBIGO_TEXT4(String BIGO_TEXT4) {
        this.BIGO_TEXT4 = BIGO_TEXT4;
    }

    public String getCOMP_WONX() {
        return COMP_WONX;
    }

    public void setCOMP_WONX(String COMP_WONX) {
        this.COMP_WONX = COMP_WONX;
    }

    public String getYTAX_WONX() {
        return YTAX_WONX;
    }

    public void setYTAX_WONX(String YTAX_WONX) {
        this.YTAX_WONX = YTAX_WONX;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }

    public String getGUEN_CODE() {
        return GUEN_CODE;
    }

    public void setGUEN_CODE(String GUEN_CODE) {
        this.GUEN_CODE = GUEN_CODE;
    }

    public String getPROOF() {
        return PROOF;
    }

    public void setPROOF(String PROOF) {
        this.PROOF = PROOF;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getOBJPS_21() {
        return OBJPS_21;
    }

    public void setOBJPS_21(String OBJPS_21) {
        this.OBJPS_21 = OBJPS_21;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getTREA_CODE() {
        return TREA_CODE;
    }

    public void setTREA_CODE(String TREA_CODE) {
        this.TREA_CODE = TREA_CODE;
    }

    public String getTREA_TEXT() {
        return TREA_TEXT;
    }

    public void setTREA_TEXT(String TREA_TEXT) {
        this.TREA_TEXT = TREA_TEXT;
    }

    public String getDATUM_21() {
        return DATUM_21;
    }

    public void setDATUM_21(String DATUM_21) {
        this.DATUM_21 = DATUM_21;
    }

    public String getSICK_DESC() {
        return SICK_DESC;
    }

    public void setSICK_DESC(String SICK_DESC) {
        this.SICK_DESC = SICK_DESC;
    }

    public String getIs_new_num() {
        return is_new_num;
    }

    public void setIs_new_num(String is_new_num) {
        this.is_new_num = is_new_num;
    }

    public String getMedi_count() {
        return medi_count;
    }

    public void setMedi_count(String medi_count) {
        this.medi_count = medi_count;
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

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getUNAME() {
        return UNAME;
    }

    public void setUNAME(String UNAME) {
        this.UNAME = UNAME;
    }

    public String getAEDTM() {
        return AEDTM;
    }

    public void setAEDTM(String AEDTM) {
        this.AEDTM = AEDTM;
    }

    public String getRFUN_DATE() {
        return RFUN_DATE;
    }

    public void setRFUN_DATE(String RFUN_DATE) {
        this.RFUN_DATE = RFUN_DATE;
    }

    public String getRFUN_RESN() {
        return RFUN_RESN;
    }

    public void setRFUN_RESN(String RFUN_RESN) {
        this.RFUN_RESN = RFUN_RESN;
    }

    public String getRFUN_AMNT() {
        return RFUN_AMNT;
    }

    public void setRFUN_AMNT(String RFUN_AMNT) {
        this.RFUN_AMNT = RFUN_AMNT;
    }

    public String getBELNR1() {
        return BELNR1;
    }

    public void setBELNR1(String BELNR1) {
        this.BELNR1 = BELNR1;
    }

    public String getPOST_DATE() {
        return POST_DATE;
    }

    public void setPOST_DATE(String POST_DATE) {
        this.POST_DATE = POST_DATE;
    }

    public String getBELNR() {
        return BELNR;
    }

    public void setBELNR(String BELNR) {
        this.BELNR = BELNR;
    }

    public String getZPERNR() {
        return ZPERNR;
    }

    public void setZPERNR(String ZPERNR) {
        this.ZPERNR = ZPERNR;
    }

    public String getZUNAME() {
        return ZUNAME;
    }

    public void setZUNAME(String ZUNAME) {
        this.ZUNAME = ZUNAME;
    }

    public String getRCPT_NUMB() {
        return RCPT_NUMB;
    }

    public void setRCPT_NUMB(String RCPT_NUMB) {
        this.RCPT_NUMB = RCPT_NUMB;
    }

    public String getREGNO_21() {
        return REGNO_21;
    }

    public void setREGNO_21(String REGNO_21) {
        this.REGNO_21 = REGNO_21;
    }

    public String getMAX_CHK() {
        return MAX_CHK;
    }

    public void setMAX_CHK(String MAX_CHK) {
        this.MAX_CHK = MAX_CHK;
    }

    public String getORG_CTRL() {
        return ORG_CTRL;
    }

    public void setORG_CTRL(String ORG_CTRL) {
        this.ORG_CTRL = ORG_CTRL;
    }

    public String getLAST_CTRL() {
        return LAST_CTRL;
    }

    public void setLAST_CTRL(String LAST_CTRL) {
        this.LAST_CTRL = LAST_CTRL;
    }

    public String getEXAM_DATE() {
        return EXAM_DATE;
    }

    public void setEXAM_DATE(String EXAM_DATE) {
        this.EXAM_DATE = EXAM_DATE;
    }
}
