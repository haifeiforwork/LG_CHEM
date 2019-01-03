package	hris.E.E05House;

/**
 * E05HouseBankCodeData.java
 * ������� �ڵ� ������ ��ƿ��� ������
 *   [���� RFC] : ZHRH_RFC_LOAN_BANK_CODE
 * E05HouseBankCodeData.java
 * @author lsa
 * @version 1.0, 2012/04/12
 */
public class E05HouseBankCodeData extends com.sns.jdf.EntityData {
    public String MANDT    ;			// Ŭ���̾�Ʈ
    public String SPRSL    ;			// ���Ű
    public String BUKRS    ;      // ȸ���ڵ�
    public String UPMU_FLAG;      // �������� �׷� ������
    public String UPMU_TYPE;			// ��������
    public String GRUP_NUMB;			// �����
    public String BANK_CODE;			// ���౸���ڵ�
    public String BANK_NAME;			// ��ü�����
    public String BEGDA    ;			// ������
    public String ENDDA    ;			// ������
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










