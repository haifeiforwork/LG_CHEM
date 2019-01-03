package hris.E.E21Expense;

/**
 * E21ExpenseData.java
 * 학자금/장학금 신청,조회,삭제
 *   [관련 RFC] : ZHRW_RFC_SCHOOL_FEE_LIST
 * @author 김성일
 * @version 1.0, 2002/01/03
 * 				  1.1  SJY 2014/10/23 대학 학자금 변경 [CSR ID:2634836] 학자금 신청 시스템 개발 요청
 *                2018/01/08 cykim	[CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건
 */
public class E21ExpenseData extends com.sns.jdf.EntityData {
    public String AINF_SEQN  ;       // 결재정보 일련번호
    public String PERNR      ;       // 사원번호
    public String BEGDA      ;       // 시작일
    public String PAID_DATE  ;       // 신청일자
    public String FAMSA      ;       // 가족레코드유형
    public String OBJC_CODE  ;       // 하부유형
    public String ATEXT      ;       // 텍스트, 20문자
    public String SUBF_TYPE  ;       // 입학축하금의 서브타입
    public String PAY1_TYPE  ;       // 지급구분(신규분)
    public String PAY2_TYPE  ;       // 지급구분(추가분)
    public String PERD_TYPE  ;       // 분기
    public String HALF_TYPE  ;       // 반기
    public String PROP_YEAR  ;       // 신청년도
    public String LNMHG      ;       // 성 (한글)
    public String FNMHG      ;       // 이름 (한글)
    public String ACAD_CARE  ;       // 학력
    public String STEXT      ;       // 학교유형텍스트
    public String FASIN      ;       // 교육기관
    public String ACAD_YEAR  ;       // 학년
    public String PROP_AMNT  ;       // 신청액
    public String PAID_AMNT  ;       // 지급액
    public String ENTR_FIAG  ;       // 입학금
    public String WAERS      ;       // 통화키(신청액)
    public String WAERS1     ;       // 통화키(지원액)
    public String BIGO_TEXT1 ;       // 비고1
    public String BIGO_TEXT2 ;       // 비고2
    public String YTAX_WONX  ;       // 연말정산 반영액
    public String P_COUNT    ;       // 수혜횟수
    public String GESC2 ;            //성별 키
    public String KDSVH ;            //자녀와의 관계
    public String REGNO ;            //주민등록번호
    public String POST_DATE ;        //POSTING일자
    public String BELNR ;            //회계전표번호
    public String ZPERNR    ;        //대리신청자사번
    public String ZUNAME    ;        //부서서무 이름
    public String AEDTM ;            //변경일
    public String UNAME ;            //사용자이름

    /*[CSR ID:3569058] 학과필드 추가 start*/
    public String FRTXT;			//전공텍스트
    /*[CSR ID:3569058] 학과필드 추가 end*/

    public String getFRTXT() {
		return FRTXT;
	}
	public void setFRTXT(String fRTXT) {
		FRTXT = fRTXT;
	}

	/*
     * 1.1 START
     */
    public String SCHCODE;  //대학코드
    public String ABRSCHOOL; //유학학자금 유무
    /*
     * 1.1 END
     */
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getPAID_DATE() {
		return PAID_DATE;
	}
	public void setPAID_DATE(String pAID_DATE) {
		PAID_DATE = pAID_DATE;
	}
	public String getFAMSA() {
		return FAMSA;
	}
	public void setFAMSA(String fAMSA) {
		FAMSA = fAMSA;
	}
	public String getOBJC_CODE() {
		return OBJC_CODE;
	}
	public void setOBJC_CODE(String oBJC_CODE) {
		OBJC_CODE = oBJC_CODE;
	}
	public String getATEXT() {
		return ATEXT;
	}
	public void setATEXT(String aTEXT) {
		ATEXT = aTEXT;
	}
	public String getSUBF_TYPE() {
		return SUBF_TYPE;
	}
	public void setSUBF_TYPE(String sUBF_TYPE) {
		SUBF_TYPE = sUBF_TYPE;
	}
	public String getPAY1_TYPE() {
		return PAY1_TYPE;
	}
	public void setPAY1_TYPE(String pAY1_TYPE) {
		PAY1_TYPE = pAY1_TYPE;
	}
	public String getPAY2_TYPE() {
		return PAY2_TYPE;
	}
	public void setPAY2_TYPE(String pAY2_TYPE) {
		PAY2_TYPE = pAY2_TYPE;
	}
	public String getPERD_TYPE() {
		return PERD_TYPE;
	}
	public void setPERD_TYPE(String pERD_TYPE) {
		PERD_TYPE = pERD_TYPE;
	}
	public String getHALF_TYPE() {
		return HALF_TYPE;
	}
	public void setHALF_TYPE(String hALF_TYPE) {
		HALF_TYPE = hALF_TYPE;
	}
	public String getPROP_YEAR() {
		return PROP_YEAR;
	}
	public void setPROP_YEAR(String pROP_YEAR) {
		PROP_YEAR = pROP_YEAR;
	}
	public String getLNMHG() {
		return LNMHG;
	}
	public void setLNMHG(String lNMHG) {
		LNMHG = lNMHG;
	}
	public String getFNMHG() {
		return FNMHG;
	}
	public void setFNMHG(String fNMHG) {
		FNMHG = fNMHG;
	}
	public String getACAD_CARE() {
		return ACAD_CARE;
	}
	public void setACAD_CARE(String aCAD_CARE) {
		ACAD_CARE = aCAD_CARE;
	}
	public String getSTEXT() {
		return STEXT;
	}
	public void setSTEXT(String sTEXT) {
		STEXT = sTEXT;
	}
	public String getFASIN() {
		return FASIN;
	}
	public void setFASIN(String fASIN) {
		FASIN = fASIN;
	}
	public String getACAD_YEAR() {
		return ACAD_YEAR;
	}
	public void setACAD_YEAR(String aCAD_YEAR) {
		ACAD_YEAR = aCAD_YEAR;
	}
	public String getPROP_AMNT() {
		return PROP_AMNT;
	}
	public void setPROP_AMNT(String pROP_AMNT) {
		PROP_AMNT = pROP_AMNT;
	}
	public String getPAID_AMNT() {
		return PAID_AMNT;
	}
	public void setPAID_AMNT(String pAID_AMNT) {
		PAID_AMNT = pAID_AMNT;
	}
	public String getENTR_FIAG() {
		return ENTR_FIAG;
	}
	public void setENTR_FIAG(String eNTR_FIAG) {
		ENTR_FIAG = eNTR_FIAG;
	}
	public String getWAERS() {
		return WAERS;
	}
	public void setWAERS(String wAERS) {
		WAERS = wAERS;
	}
	public String getWAERS1() {
		return WAERS1;
	}
	public void setWAERS1(String wAERS1) {
		WAERS1 = wAERS1;
	}
	public String getBIGO_TEXT1() {
		return BIGO_TEXT1;
	}
	public void setBIGO_TEXT1(String bIGO_TEXT1) {
		BIGO_TEXT1 = bIGO_TEXT1;
	}
	public String getBIGO_TEXT2() {
		return BIGO_TEXT2;
	}
	public void setBIGO_TEXT2(String bIGO_TEXT2) {
		BIGO_TEXT2 = bIGO_TEXT2;
	}
	public String getYTAX_WONX() {
		return YTAX_WONX;
	}
	public void setYTAX_WONX(String yTAX_WONX) {
		YTAX_WONX = yTAX_WONX;
	}
	public String getP_COUNT() {
		return P_COUNT;
	}
	public void setP_COUNT(String p_COUNT) {
		P_COUNT = p_COUNT;
	}
	public String getGESC2() {
		return GESC2;
	}
	public void setGESC2(String gESC2) {
		GESC2 = gESC2;
	}
	public String getKDSVH() {
		return KDSVH;
	}
	public void setKDSVH(String kDSVH) {
		KDSVH = kDSVH;
	}
	public String getREGNO() {
		return REGNO;
	}
	public void setREGNO(String rEGNO) {
		REGNO = rEGNO;
	}
	public String getPOST_DATE() {
		return POST_DATE;
	}
	public void setPOST_DATE(String pOST_DATE) {
		POST_DATE = pOST_DATE;
	}
	public String getBELNR() {
		return BELNR;
	}
	public void setBELNR(String bELNR) {
		BELNR = bELNR;
	}
	public String getZPERNR() {
		return ZPERNR;
	}
	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
	}
	public String getZUNAME() {
		return ZUNAME;
	}
	public void setZUNAME(String zUNAME) {
		ZUNAME = zUNAME;
	}
	public String getAEDTM() {
		return AEDTM;
	}
	public void setAEDTM(String aEDTM) {
		AEDTM = aEDTM;
	}
	public String getUNAME() {
		return UNAME;
	}
	public void setUNAME(String uNAME) {
		UNAME = uNAME;
	}
	public String getSCHCODE() {
		return SCHCODE;
	}
	public void setSCHCODE(String sCHCODE) {
		SCHCODE = sCHCODE;
	}
	public String getABRSCHOOL() {
		return ABRSCHOOL;
	}
	public void setABRSCHOOL(String aBRSCHOOL) {
		ABRSCHOOL = aBRSCHOOL;
	}



}