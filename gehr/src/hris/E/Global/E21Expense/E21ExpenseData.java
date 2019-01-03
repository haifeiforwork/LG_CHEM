package hris.E.Global.E21Expense;

/**
 * E21ExpenseData.java
 * 학자금/장학금 신청,조회,삭제
 *   [관련 RFC] : ZHRW_RFC_SCHOOL_FEE_LIST
 *
 * @author 김성일
 * @version 1.0, 2002/01/03
 */
public class E21ExpenseData extends com.sns.jdf.EntityData {
    public String PERNR  ;       // 결재정보 일련번호
    public String BEGDA      ;       // 사원번호
    public String AINF_SEQN      ;       // 시작일
    public String CHLD_TYPE  ;       // 신청일자
    public String CHLD_NAME      ;       // 가족레코드유형
    public String SCHL_TYPE  ;       // 하부유형
    public String SCHL_NAME      ;       // 텍스트, 20문자
    public String SCHL_GRAD  ;       // 입학축하금의 서브타입
    public String PAST_CONT  ;       // 지급구분(신규분)
    public String REIM_CONT  ;       // 지급구분(추가분)
    public String REIM_CNTH  ;       // 분기
    public String REIM_AMT  ;       // 반기
    public String REIM_AMTH  ;       // 신청년도
    public String PDATE      ;       // 성 (한글)
    public String REIM_WAERS      ;       // 이름 (한글)
    public String ATTC_NORL  ;       // 학력
    public String REIM_BET1      ;       // 학교유형텍스트
    public String REIM_RAT1      ;       // 교육기관
    public String REIM_WAR1  ;       // 학년
    public String REIM_CAL1  ;       // 신청액
    public String REIM_BET2  ;       // 지급액
    public String REIM_RAT2  ;       // 입학금
    public String REIM_WAR2      ;       // 통화키(신청액)
    public String REIM_CAL2     ;       // 통화키(지원액)
    public String REIM_BET3 ;       // 비고1
    public String REIM_RAT3 ;       // 비고2
    public String REIM_WAR3  ;       // 연말정산 반영액
    public String REIM_CAL3    ;       // 수혜횟수
    public String REIM_BET4 ;            //성별 키
    public String REIM_RAT4 ;            //자녀와의 관계
    public String REIM_WAR4 ;            //주민등록번호
    public String REIM_CAL4 ;        //POSTING일자
    public String REIM_BET5 ;            //회계전표번호
    public String REIM_RAT5    ;        //대리신청자사번
    public String REIM_WAR5    ;        //부서서무 이름
    public String REIM_CAL5 ;            //변경일
    public String REIM_TOTL ;            //사용자이름
    public String WAERS  ;       // 입학금
    public String RFDATE      ;       // 통화키(신청액)
    public String RFREASON     ;       // 통화키(지원액)
    public String RFAMT ;       // 비고1
    public String RFAMT1 ;       // 비고2
    public String RFNO  ;       // 연말정산 반영액
    public String CERT_FLAG    ;       // 수혜횟수
    public String CERT_DATE ;            //성별 키
    public String CERT_BETG ;            //자녀와의 관계
    public String CERT_BETG_C ;            //주민등록번호
    public String REQU_DATE ;        //POSTING일자
    public String BELNR ;            //회계전표번호
    public String REIM_AMTH_REST    ;        //대리신청자사번
    public String REIM_CNTH_REST    ;        //부서서무 이름
    public String REIM_TOTL_CONV ;            //변경일
    public String SUBTY ;
    public String STEXT ;            //주민등록번호
    public String SCHL_TEXT ;        //POSTING일자
    public String PERNR_D ;            //회계전표번호
    public String ZPERNR    ;        //대리신청자사번
    public String ZUNAME    ;        //부서서무 이름
    public String AEDTM ;            //변경일
    public String UNAME ;
    public String TERM_BEGD ;
    public String TERM_ENDD ;
    public String TERM_TEXT ;
    public String REIM_AMTH_CONV ;
    public String OBJPS ;

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

    public String getCHLD_TYPE() {
        return CHLD_TYPE;
    }

    public void setCHLD_TYPE(String CHLD_TYPE) {
        this.CHLD_TYPE = CHLD_TYPE;
    }

    public String getCHLD_NAME() {
        return CHLD_NAME;
    }

    public void setCHLD_NAME(String CHLD_NAME) {
        this.CHLD_NAME = CHLD_NAME;
    }

    public String getSCHL_TYPE() {
        return SCHL_TYPE;
    }

    public void setSCHL_TYPE(String SCHL_TYPE) {
        this.SCHL_TYPE = SCHL_TYPE;
    }

    public String getSCHL_NAME() {
        return SCHL_NAME;
    }

    public void setSCHL_NAME(String SCHL_NAME) {
        this.SCHL_NAME = SCHL_NAME;
    }

    public String getSCHL_GRAD() {
        return SCHL_GRAD;
    }

    public void setSCHL_GRAD(String SCHL_GRAD) {
        this.SCHL_GRAD = SCHL_GRAD;
    }

    public String getPAST_CONT() {
        return PAST_CONT;
    }

    public void setPAST_CONT(String PAST_CONT) {
        this.PAST_CONT = PAST_CONT;
    }

    public String getREIM_CONT() {
        return REIM_CONT;
    }

    public void setREIM_CONT(String REIM_CONT) {
        this.REIM_CONT = REIM_CONT;
    }

    public String getREIM_CNTH() {
        return REIM_CNTH;
    }

    public void setREIM_CNTH(String REIM_CNTH) {
        this.REIM_CNTH = REIM_CNTH;
    }

    public String getREIM_AMT() {
        return REIM_AMT;
    }

    public void setREIM_AMT(String REIM_AMT) {
        this.REIM_AMT = REIM_AMT;
    }

    public String getREIM_AMTH() {
        return REIM_AMTH;
    }

    public void setREIM_AMTH(String REIM_AMTH) {
        this.REIM_AMTH = REIM_AMTH;
    }

    public String getPDATE() {
        return PDATE;
    }

    public void setPDATE(String PDATE) {
        this.PDATE = PDATE;
    }

    public String getREIM_WAERS() {
        return REIM_WAERS;
    }

    public void setREIM_WAERS(String REIM_WAERS) {
        this.REIM_WAERS = REIM_WAERS;
    }

    public String getATTC_NORL() {
        return ATTC_NORL;
    }

    public void setATTC_NORL(String ATTC_NORL) {
        this.ATTC_NORL = ATTC_NORL;
    }

    public String getREIM_BET1() {
        return REIM_BET1;
    }

    public void setREIM_BET1(String REIM_BET1) {
        this.REIM_BET1 = REIM_BET1;
    }

    public String getREIM_RAT1() {
        return REIM_RAT1;
    }

    public void setREIM_RAT1(String REIM_RAT1) {
        this.REIM_RAT1 = REIM_RAT1;
    }

    public String getREIM_WAR1() {
        return REIM_WAR1;
    }

    public void setREIM_WAR1(String REIM_WAR1) {
        this.REIM_WAR1 = REIM_WAR1;
    }

    public String getREIM_CAL1() {
        return REIM_CAL1;
    }

    public void setREIM_CAL1(String REIM_CAL1) {
        this.REIM_CAL1 = REIM_CAL1;
    }

    public String getREIM_BET2() {
        return REIM_BET2;
    }

    public void setREIM_BET2(String REIM_BET2) {
        this.REIM_BET2 = REIM_BET2;
    }

    public String getREIM_RAT2() {
        return REIM_RAT2;
    }

    public void setREIM_RAT2(String REIM_RAT2) {
        this.REIM_RAT2 = REIM_RAT2;
    }

    public String getREIM_WAR2() {
        return REIM_WAR2;
    }

    public void setREIM_WAR2(String REIM_WAR2) {
        this.REIM_WAR2 = REIM_WAR2;
    }

    public String getREIM_CAL2() {
        return REIM_CAL2;
    }

    public void setREIM_CAL2(String REIM_CAL2) {
        this.REIM_CAL2 = REIM_CAL2;
    }

    public String getREIM_BET3() {
        return REIM_BET3;
    }

    public void setREIM_BET3(String REIM_BET3) {
        this.REIM_BET3 = REIM_BET3;
    }

    public String getREIM_RAT3() {
        return REIM_RAT3;
    }

    public void setREIM_RAT3(String REIM_RAT3) {
        this.REIM_RAT3 = REIM_RAT3;
    }

    public String getREIM_WAR3() {
        return REIM_WAR3;
    }

    public void setREIM_WAR3(String REIM_WAR3) {
        this.REIM_WAR3 = REIM_WAR3;
    }

    public String getREIM_CAL3() {
        return REIM_CAL3;
    }

    public void setREIM_CAL3(String REIM_CAL3) {
        this.REIM_CAL3 = REIM_CAL3;
    }

    public String getREIM_BET4() {
        return REIM_BET4;
    }

    public void setREIM_BET4(String REIM_BET4) {
        this.REIM_BET4 = REIM_BET4;
    }

    public String getREIM_RAT4() {
        return REIM_RAT4;
    }

    public void setREIM_RAT4(String REIM_RAT4) {
        this.REIM_RAT4 = REIM_RAT4;
    }

    public String getREIM_WAR4() {
        return REIM_WAR4;
    }

    public void setREIM_WAR4(String REIM_WAR4) {
        this.REIM_WAR4 = REIM_WAR4;
    }

    public String getREIM_CAL4() {
        return REIM_CAL4;
    }

    public void setREIM_CAL4(String REIM_CAL4) {
        this.REIM_CAL4 = REIM_CAL4;
    }

    public String getREIM_BET5() {
        return REIM_BET5;
    }

    public void setREIM_BET5(String REIM_BET5) {
        this.REIM_BET5 = REIM_BET5;
    }

    public String getREIM_RAT5() {
        return REIM_RAT5;
    }

    public void setREIM_RAT5(String REIM_RAT5) {
        this.REIM_RAT5 = REIM_RAT5;
    }

    public String getREIM_WAR5() {
        return REIM_WAR5;
    }

    public void setREIM_WAR5(String REIM_WAR5) {
        this.REIM_WAR5 = REIM_WAR5;
    }

    public String getREIM_CAL5() {
        return REIM_CAL5;
    }

    public void setREIM_CAL5(String REIM_CAL5) {
        this.REIM_CAL5 = REIM_CAL5;
    }

    public String getREIM_TOTL() {
        return REIM_TOTL;
    }

    public void setREIM_TOTL(String REIM_TOTL) {
        this.REIM_TOTL = REIM_TOTL;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }

    public String getRFDATE() {
        return RFDATE;
    }

    public void setRFDATE(String RFDATE) {
        this.RFDATE = RFDATE;
    }

    public String getRFREASON() {
        return RFREASON;
    }

    public void setRFREASON(String RFREASON) {
        this.RFREASON = RFREASON;
    }

    public String getRFAMT() {
        return RFAMT;
    }

    public void setRFAMT(String RFAMT) {
        this.RFAMT = RFAMT;
    }

    public String getRFAMT1() {
        return RFAMT1;
    }

    public void setRFAMT1(String RFAMT1) {
        this.RFAMT1 = RFAMT1;
    }

    public String getRFNO() {
        return RFNO;
    }

    public void setRFNO(String RFNO) {
        this.RFNO = RFNO;
    }

    public String getCERT_FLAG() {
        return CERT_FLAG;
    }

    public void setCERT_FLAG(String CERT_FLAG) {
        this.CERT_FLAG = CERT_FLAG;
    }

    public String getCERT_DATE() {
        return CERT_DATE;
    }

    public void setCERT_DATE(String CERT_DATE) {
        this.CERT_DATE = CERT_DATE;
    }

    public String getCERT_BETG() {
        return CERT_BETG;
    }

    public void setCERT_BETG(String CERT_BETG) {
        this.CERT_BETG = CERT_BETG;
    }

    public String getCERT_BETG_C() {
        return CERT_BETG_C;
    }

    public void setCERT_BETG_C(String CERT_BETG_C) {
        this.CERT_BETG_C = CERT_BETG_C;
    }

    public String getREQU_DATE() {
        return REQU_DATE;
    }

    public void setREQU_DATE(String REQU_DATE) {
        this.REQU_DATE = REQU_DATE;
    }

    public String getBELNR() {
        return BELNR;
    }

    public void setBELNR(String BELNR) {
        this.BELNR = BELNR;
    }

    public String getREIM_AMTH_REST() {
        return REIM_AMTH_REST;
    }

    public void setREIM_AMTH_REST(String REIM_AMTH_REST) {
        this.REIM_AMTH_REST = REIM_AMTH_REST;
    }

    public String getREIM_CNTH_REST() {
        return REIM_CNTH_REST;
    }

    public void setREIM_CNTH_REST(String REIM_CNTH_REST) {
        this.REIM_CNTH_REST = REIM_CNTH_REST;
    }

    public String getREIM_TOTL_CONV() {
        return REIM_TOTL_CONV;
    }

    public void setREIM_TOTL_CONV(String REIM_TOTL_CONV) {
        this.REIM_TOTL_CONV = REIM_TOTL_CONV;
    }

    public String getSUBTY() {
        return SUBTY;
    }

    public void setSUBTY(String SUBTY) {
        this.SUBTY = SUBTY;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getSCHL_TEXT() {
        return SCHL_TEXT;
    }

    public void setSCHL_TEXT(String SCHL_TEXT) {
        this.SCHL_TEXT = SCHL_TEXT;
    }

    public String getPERNR_D() {
        return PERNR_D;
    }

    public void setPERNR_D(String PERNR_D) {
        this.PERNR_D = PERNR_D;
    }

    public String getZPERNR() {
        return ZPERNR;
    }

    public void setZPERNR(String ZPERNR) {
        this.ZPERNR = ZPERNR;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getZUNAME() {
        return ZUNAME;
    }

    public void setZUNAME(String ZUNAME) {
        this.ZUNAME = ZUNAME;
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

    public String getTERM_BEGD() {
        return TERM_BEGD;
    }

    public void setTERM_BEGD(String TERM_BEGD) {
        this.TERM_BEGD = TERM_BEGD;
    }

    public String getTERM_ENDD() {
        return TERM_ENDD;
    }

    public void setTERM_ENDD(String TERM_ENDD) {
        this.TERM_ENDD = TERM_ENDD;
    }

    public String getTERM_TEXT() {
        return TERM_TEXT;
    }

    public void setTERM_TEXT(String TERM_TEXT) {
        this.TERM_TEXT = TERM_TEXT;
    }

    public String getREIM_AMTH_CONV() {
        return REIM_AMTH_CONV;
    }

    public void setREIM_AMTH_CONV(String REIM_AMTH_CONV) {
        this.REIM_AMTH_CONV = REIM_AMTH_CONV;
    }

    public String getOBJPS() {
        return OBJPS;
    }

    public void setOBJPS(String OBJPS) {
        this.OBJPS = OBJPS;
    }

}