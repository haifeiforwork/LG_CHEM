package	hris.E.E05House;

/**
 * E05HouseBankCodeData.java
 * 은행계좌 코드 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_LOAN_BANK_CODE
 * E05HouseBankCodeData.java
 * @author lsa
 * @version 1.0, 2012/04/12
 */
public class E05HouseBankCodeData extends com.sns.jdf.EntityData {
    public String MANDT    ;			// 클라이언트
    public String SPRSL    ;			// 언어키
    public String BUKRS    ;      // 회사코드
    public String UPMU_FLAG;      // 업무구분 그룹 지시자
    public String UPMU_TYPE;			// 업무구분
    public String GRUP_NUMB;			// 사업장
    public String BANK_CODE;			// 은행구분코드
    public String BANK_NAME;			// 이체은행명
    public String BEGDA    ;			// 시작일
    public String ENDDA    ;			// 종료일
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
	public String getBANK_CODE() {
		return BANK_CODE;
	}
	public void setBANK_CODE(String bANK_CODE) {
		BANK_CODE = bANK_CODE;
	}
	public String getBANK_NAME() {
		return BANK_NAME;
	}
	public void setBANK_NAME(String bANK_NAME) {
		BANK_NAME = bANK_NAME;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getENDDA() {
		return ENDDA;
	}
	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}

}










