package hris.E.E22Expense;

/**
 * E22ExpenseListData.java
 * 입학축하금/학자금/장학금 조회
 * [관련 RFC] : ZGHR_RFC_SCHOLARSHIP_DISPLAY
 * @author 최영호
 * @version 1.0, 2002/01/04
 * 					1.1  SJY 2014/10/23 대학 학자금 변경 [CSR ID:2634836] 학자금 신청 시스템 개발 요청
 * 					2018/01/08 cykim	[CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건
 */
public class E22ExpenseListData extends com.sns.jdf.EntityData {
    public String SUBF_TYPE ;       // 입학축하금/학자금/장학금 구분 코드
    public String STEXT     ;       // 입학축하금/학자금/장학금 이름
    public String FAMSA     ;       // 가족유형
    public String OBJC_CODE ;       // 하부유형
    public String ATEXT     ;       // 가족유형TEXT
    public String GESC1     ;       // 성별키
    public String GESC2     ;       // 성별키
    public String ACAD_CARE ;       // 학력
    public String TEXT4     ;       // 학력TEXT
    public String FASIN     ;       // 교육기관
    public String REGNO     ;       // 주민등록번호
    public String ACAD_YEAR ;       // 학년
    public String PROP_AMNT ;       // 신청액
    public String ENTR_FIAG ;       // 입학금
    public String PAY1_TYPE ;       // 지급구분(신규분)
    public String PAY2_TYPE ;       // 지급구분(추가분)
    public String PERD_TYPE ;       // 분기
    public String HALF_TYPE ;       // 반기
    public String PROP_YEAR ;       // 신청년도
    public String LNMHG     ;       // 성(한글)
    public String FNMHG     ;       // 이름(한글)
    public String PAID_AMNT ;       // 지급액
    public String PAID_DATE ;       // 신청일자
    public String BEGDA     ;       // 시작일(최종 결제일)
    public String ENDDA     ;       // 종료일
    public String BIGO_TEXT1;       // 비고1
    public String BIGO_TEXT2;       // 비고2
    public String RFUN_DATE ;       // 반납일자
    public String RFUN_RESN ;       // 반납사유
    public String RFUN_AMNT ;       // 반납액
    public String RFUN_FLAG ;       // 수혜횟수차감여부
    public String WAERS     ;       // 통화키(신청액)
    public String WAERS1    ;       // 통화키(지원액)
    public String YTAX_WONX ;       // 연말정산 반영액
    public String P_COUNT   ;       // 수혜횟수
    public String POST_DATE ;       // 최종결재일
    public String AINF_SEQN ;       // 결재번호

    /*[CSR ID:3569058] 학과필드 추가 start*/
    public String FRTXT;			//전공텍스트
    /*[CSR ID:3569058] 학과필드 추가 end*/

    /*
     * 1.1 START
     */
    public String SCHCODE;  //대학코드
	public String ABRSCHOOL; //유학학자금 유무
    /*
     * 1.1 END
     */

	public String getFRTXT() {
		return FRTXT;
	}

	public void setFRTXT(String fRTXT) {
		FRTXT = fRTXT;
	}

    public String getSUBF_TYPE() {
        return SUBF_TYPE;
    }

    public void setSUBF_TYPE(String SUBF_TYPE) {
        this.SUBF_TYPE = SUBF_TYPE;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getFAMSA() {
        return FAMSA;
    }

    public void setFAMSA(String FAMSA) {
        this.FAMSA = FAMSA;
    }

    public String getOBJC_CODE() {
        return OBJC_CODE;
    }

    public void setOBJC_CODE(String OBJC_CODE) {
        this.OBJC_CODE = OBJC_CODE;
    }

    public String getATEXT() {
        return ATEXT;
    }

    public void setATEXT(String ATEXT) {
        this.ATEXT = ATEXT;
    }

    public String getGESC1() {
        return GESC1;
    }

    public void setGESC1(String GESC1) {
        this.GESC1 = GESC1;
    }

    public String getGESC2() {
        return GESC2;
    }

    public void setGESC2(String GESC2) {
        this.GESC2 = GESC2;
    }

    public String getACAD_CARE() {
        return ACAD_CARE;
    }

    public void setACAD_CARE(String ACAD_CARE) {
        this.ACAD_CARE = ACAD_CARE;
    }

    public String getTEXT4() {
        return TEXT4;
    }

    public void setTEXT4(String TEXT4) {
        this.TEXT4 = TEXT4;
    }

    public String getFASIN() {
        return FASIN;
    }

    public void setFASIN(String FASIN) {
        this.FASIN = FASIN;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getACAD_YEAR() {
        return ACAD_YEAR;
    }

    public void setACAD_YEAR(String ACAD_YEAR) {
        this.ACAD_YEAR = ACAD_YEAR;
    }

    public String getPROP_AMNT() {
        return PROP_AMNT;
    }

    public void setPROP_AMNT(String PROP_AMNT) {
        this.PROP_AMNT = PROP_AMNT;
    }

    public String getENTR_FIAG() {
        return ENTR_FIAG;
    }

    public void setENTR_FIAG(String ENTR_FIAG) {
        this.ENTR_FIAG = ENTR_FIAG;
    }

    public String getPAY1_TYPE() {
        return PAY1_TYPE;
    }

    public void setPAY1_TYPE(String PAY1_TYPE) {
        this.PAY1_TYPE = PAY1_TYPE;
    }

    public String getPAY2_TYPE() {
        return PAY2_TYPE;
    }

    public void setPAY2_TYPE(String PAY2_TYPE) {
        this.PAY2_TYPE = PAY2_TYPE;
    }

    public String getPERD_TYPE() {
        return PERD_TYPE;
    }

    public void setPERD_TYPE(String PERD_TYPE) {
        this.PERD_TYPE = PERD_TYPE;
    }

    public String getHALF_TYPE() {
        return HALF_TYPE;
    }

    public void setHALF_TYPE(String HALF_TYPE) {
        this.HALF_TYPE = HALF_TYPE;
    }

    public String getPROP_YEAR() {
        return PROP_YEAR;
    }

    public void setPROP_YEAR(String PROP_YEAR) {
        this.PROP_YEAR = PROP_YEAR;
    }

    public String getLNMHG() {
        return LNMHG;
    }

    public void setLNMHG(String LNMHG) {
        this.LNMHG = LNMHG;
    }

    public String getFNMHG() {
        return FNMHG;
    }

    public void setFNMHG(String FNMHG) {
        this.FNMHG = FNMHG;
    }

    public String getPAID_AMNT() {
        return PAID_AMNT;
    }

    public void setPAID_AMNT(String PAID_AMNT) {
        this.PAID_AMNT = PAID_AMNT;
    }

    public String getPAID_DATE() {
        return PAID_DATE;
    }

    public void setPAID_DATE(String PAID_DATE) {
        this.PAID_DATE = PAID_DATE;
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

    public String getRFUN_FLAG() {
        return RFUN_FLAG;
    }

    public void setRFUN_FLAG(String RFUN_FLAG) {
        this.RFUN_FLAG = RFUN_FLAG;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }

    public String getWAERS1() {
        return WAERS1;
    }

    public void setWAERS1(String WAERS1) {
        this.WAERS1 = WAERS1;
    }

    public String getYTAX_WONX() {
        return YTAX_WONX;
    }

    public void setYTAX_WONX(String YTAX_WONX) {
        this.YTAX_WONX = YTAX_WONX;
    }

    public String getP_COUNT() {
        return P_COUNT;
    }

    public void setP_COUNT(String P_COUNT) {
        this.P_COUNT = P_COUNT;
    }

    public String getPOST_DATE() {
        return POST_DATE;
    }

    public void setPOST_DATE(String POST_DATE) {
        this.POST_DATE = POST_DATE;
    }

    public String getSCHCODE() {
        return SCHCODE;
    }

    public void setSCHCODE(String SCHCODE) {
        this.SCHCODE = SCHCODE;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getABRSCHOOL() {
        return ABRSCHOOL;
    }

    public void setABRSCHOOL(String ABRSCHOOL) {
        this.ABRSCHOOL = ABRSCHOOL;
    }

}