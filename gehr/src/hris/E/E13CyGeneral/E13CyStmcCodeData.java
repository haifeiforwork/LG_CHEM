package	hris.E.E13CyGeneral;

/**
 * E13CyStmcCodeData.java
 * 소화기검사에 대한 데이터
 *   [관련 RFC] : ZHRH_RFC_STMC_CODE_DF
 *
 * @author 이형석
 * @version 1.0, 2001/12/26
 */
public class E13CyStmcCodeData extends com.sns.jdf.EntityData {

    public String MANDT    ;   // 클라이언트
    public String SPRSL    ;   // 언어 키
    public String BUKRS    ;   // 회사 코드
    public String UPMU_FLAG;   // 업무구분 그룹 지시자
    public String UPMU_TYPE;   // 업무구분
    public String GRUP_NUMB;   // 사업장
    public String HOSP_CODE;   // 검진병원코드
    public String STMC_CODE;   // 소화기검사 코드
    public String STMC_TEXT;   // 소화기검사 텍스트
    public String SELT_CODE;   // 선택검사항목 코드
    public String SELT_TEXT;   // 선택검사항목 텍스트
    public String USE_FLAG ;   // 단일 문자 표시
    public String INFO_MESS;   // 문자 100
    //public String ZDEFER;   //이월검진신청여부
	public String getMANDT() {
		return MANDT;
	}
	public void setMANDT(String mANDT) {
		MANDT = mANDT;
	}
	public String getSPRSL() {
		return SPRSL;
	}
	public void setSPRSL(String sPRSL) {
		SPRSL = sPRSL;
	}
	public String getBUKRS() {
		return BUKRS;
	}
	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}
	public String getUPMU_FLAG() {
		return UPMU_FLAG;
	}
	public void setUPMU_FLAG(String uPMU_FLAG) {
		UPMU_FLAG = uPMU_FLAG;
	}
	public String getUPMU_TYPE() {
		return UPMU_TYPE;
	}
	public void setUPMU_TYPE(String uPMU_TYPE) {
		UPMU_TYPE = uPMU_TYPE;
	}
	public String getGRUP_NUMB() {
		return GRUP_NUMB;
	}
	public void setGRUP_NUMB(String gRUP_NUMB) {
		GRUP_NUMB = gRUP_NUMB;
	}
	public String getHOSP_CODE() {
		return HOSP_CODE;
	}
	public void setHOSP_CODE(String hOSP_CODE) {
		HOSP_CODE = hOSP_CODE;
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
	public String getUSE_FLAG() {
		return USE_FLAG;
	}
	public void setUSE_FLAG(String uSE_FLAG) {
		USE_FLAG = uSE_FLAG;
	}
	public String getINFO_MESS() {
		return INFO_MESS;
	}
	public void setINFO_MESS(String iNFO_MESS) {
		INFO_MESS = iNFO_MESS;
	}


}
