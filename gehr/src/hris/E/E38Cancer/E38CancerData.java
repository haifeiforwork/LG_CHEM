package	hris.E.E38Cancer;

/**
 * E15GeneralData.java
 * 암검진 신청에 대한 데이터
 *   [관련 RFC] : ZGHR_RFC_BANK_HOSP_AREA_LIST_N
 *
 * @author lsa
 * @version 1.0, 2013/06/21 C20130620_53407
 */
public class E38CancerData extends com.sns.jdf.EntityData {

    public String BEGDA;        //신청일
    public String PERNR ;       // 사원번호
    public String AINF_SEQN;    // 결재정보 일련번호
    public String CONF_DATE;    // 확정일자
    public String EZAM_DATE;    // 검진날짜
    public String EXAM_YEAR;    // 검진년도
    public String GUEN_CODE;    // 구분
    public String AREA_CODE;    // 지역코드
    public String HOSP_CODE;    // 검진병원코드
    public String ZHOM_NUMB;    // 전화(자택)
    public String COMP_NUMB;    // 전화(회사)
    public String REAL_DATE ;   //실검진일자
    public String ZUNAME;       // 사업장
    public String AEDTM;        // 부서서무 이름
    public String UNAME;        // 사용자이름
    public String GUEN_NAME;    // 증권회사명
    public String HOSP_NAME;    // 지부구분명
    public String AREA_NAME;    // 지부구분명
    public String STAT_TYPE;
    public String APPR_STAT;    // 결재 상태 - .
    public String ZPERNR;       // 대리 신청자

    public String M_FLAG    ;   // 본인 검진대상자 여부
    public String F_FLAG    ;   // 배우자 검진 대상자 여부

    public String E_M_FLAG    ;   // 본인 검진대상자 여부
    public String E_F_FLAG    ;   // 배우자 검진 대상자 여부

    public String STMC_CODE;	//위검사항목 코드
    public String STMC_TEXT;	//위검사항목 텍스트
    public String SELT_CODE;	//선택검사항목 코드
    public String SELT_TEXT;	//선택검사항목 텍스트
    public String STRAS	   ;    //상세 주소/번지
    public String GRUP_NUMB;    //사업장코드
    public String BIGO;         //비고
    public String STMC_CODE1;	//위검사항목 코드1
    public String ZCONFIRM;	//동의서 확인 여부
    public String ZDEFER;   // 검진신청여부
    public String ZCANCER;   // 추가암검진(7종암) 여부
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getCONF_DATE() {
		return CONF_DATE;
	}
	public void setCONF_DATE(String cONF_DATE) {
		CONF_DATE = cONF_DATE;
	}
	public String getEZAM_DATE() {
		return EZAM_DATE;
	}
	public void setEZAM_DATE(String eZAM_DATE) {
		EZAM_DATE = eZAM_DATE;
	}
	public String getEXAM_YEAR() {
		return EXAM_YEAR;
	}
	public void setEXAM_YEAR(String eXAM_YEAR) {
		EXAM_YEAR = eXAM_YEAR;
	}
	public String getGUEN_CODE() {
		return GUEN_CODE;
	}
	public void setGUEN_CODE(String gUEN_CODE) {
		GUEN_CODE = gUEN_CODE;
	}
	public String getAREA_CODE() {
		return AREA_CODE;
	}
	public void setAREA_CODE(String aREA_CODE) {
		AREA_CODE = aREA_CODE;
	}
	public String getHOSP_CODE() {
		return HOSP_CODE;
	}
	public void setHOSP_CODE(String hOSP_CODE) {
		HOSP_CODE = hOSP_CODE;
	}
	public String getZHOM_NUMB() {
		return ZHOM_NUMB;
	}
	public void setZHOM_NUMB(String zHOM_NUMB) {
		ZHOM_NUMB = zHOM_NUMB;
	}
	public String getCOMP_NUMB() {
		return COMP_NUMB;
	}
	public void setCOMP_NUMB(String cOMP_NUMB) {
		COMP_NUMB = cOMP_NUMB;
	}
	public String getREAL_DATE() {
		return REAL_DATE;
	}
	public void setREAL_DATE(String rEAL_DATE) {
		REAL_DATE = rEAL_DATE;
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
	public String getGUEN_NAME() {
		return GUEN_NAME;
	}
	public void setGUEN_NAME(String gUEN_NAME) {
		GUEN_NAME = gUEN_NAME;
	}
	public String getHOSP_NAME() {
		return HOSP_NAME;
	}
	public void setHOSP_NAME(String hOSP_NAME) {
		HOSP_NAME = hOSP_NAME;
	}
	public String getAREA_NAME() {
		return AREA_NAME;
	}
	public void setAREA_NAME(String aREA_NAME) {
		AREA_NAME = aREA_NAME;
	}
	public String getSTAT_TYPE() {
		return STAT_TYPE;
	}
	public void setSTAT_TYPE(String sTAT_TYPE) {
		STAT_TYPE = sTAT_TYPE;
	}
	public String getAPPR_STAT() {
		return APPR_STAT;
	}
	public void setAPPR_STAT(String aPPR_STAT) {
		APPR_STAT = aPPR_STAT;
	}
	public String getZPERNR() {
		return ZPERNR;
	}
	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
	}
	public String getM_FLAG() {
		return M_FLAG;
	}
	public void setM_FLAG(String m_FLAG) {
		M_FLAG = m_FLAG;
	}
	public String getF_FLAG() {
		return F_FLAG;
	}
	public void setF_FLAG(String f_FLAG) {
		F_FLAG = f_FLAG;
	}
	public String getE_M_FLAG() {
		return E_M_FLAG;
	}
	public void setE_M_FLAG(String e_M_FLAG) {
		E_M_FLAG = e_M_FLAG;
	}
	public String getE_F_FLAG() {
		return E_F_FLAG;
	}
	public void setE_F_FLAG(String e_F_FLAG) {
		E_F_FLAG = e_F_FLAG;
	}
	public String getSTMC_CODE() {
		return STMC_CODE;
	}
	public void setSTMC_CODE(String sTMC_CODE) {
		STMC_CODE = sTMC_CODE;
	}
	public String getSTMC_TEXT() {
		return STMC_TEXT;
	}
	public void setSTMC_TEXT(String sTMC_TEXT) {
		STMC_TEXT = sTMC_TEXT;
	}
	public String getSELT_CODE() {
		return SELT_CODE;
	}
	public void setSELT_CODE(String sELT_CODE) {
		SELT_CODE = sELT_CODE;
	}
	public String getSELT_TEXT() {
		return SELT_TEXT;
	}
	public void setSELT_TEXT(String sELT_TEXT) {
		SELT_TEXT = sELT_TEXT;
	}
	public String getSTRAS() {
		return STRAS;
	}
	public void setSTRAS(String sTRAS) {
		STRAS = sTRAS;
	}
	public String getGRUP_NUMB() {
		return GRUP_NUMB;
	}
	public void setGRUP_NUMB(String gRUP_NUMB) {
		GRUP_NUMB = gRUP_NUMB;
	}
	public String getBIGO() {
		return BIGO;
	}
	public void setBIGO(String bIGO) {
		BIGO = bIGO;
	}
	public String getSTMC_CODE1() {
		return STMC_CODE1;
	}
	public void setSTMC_CODE1(String sTMC_CODE1) {
		STMC_CODE1 = sTMC_CODE1;
	}
	public String getZCONFIRM() {
		return ZCONFIRM;
	}
	public void setZCONFIRM(String zCONFIRM) {
		ZCONFIRM = zCONFIRM;
	}
	public String getZDEFER() {
		return ZDEFER;
	}
	public void setZDEFER(String zDEFER) {
		ZDEFER = zDEFER;
	}
	public String getZCANCER() {
		return ZCANCER;
	}
	public void setZCANCER(String zCANCER) {
		ZCANCER = zCANCER;
	}




}
