package	hris.E.E13CyGeneral;

/**
 * E13CyStmcCodeData.java
 * ��ȭ��˻翡 ���� ������
 *   [���� RFC] : ZHRH_RFC_STMC_CODE_DF
 *
 * @author ������
 * @version 1.0, 2001/12/26
 */
public class E13CyStmcCodeData extends com.sns.jdf.EntityData {

    public String MANDT    ;   // Ŭ���̾�Ʈ
    public String SPRSL    ;   // ��� Ű
    public String BUKRS    ;   // ȸ�� �ڵ�
    public String UPMU_FLAG;   // �������� �׷� ������
    public String UPMU_TYPE;   // ��������
    public String GRUP_NUMB;   // �����
    public String HOSP_CODE;   // ���������ڵ�
    public String STMC_CODE;   // ��ȭ��˻� �ڵ�
    public String STMC_TEXT;   // ��ȭ��˻� �ؽ�Ʈ
    public String SELT_CODE;   // ���ð˻��׸� �ڵ�
    public String SELT_TEXT;   // ���ð˻��׸� �ؽ�Ʈ
    public String USE_FLAG ;   // ���� ���� ǥ��
    public String INFO_MESS;   // ���� 100
    //public String ZDEFER;   //�̿�������û����
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
