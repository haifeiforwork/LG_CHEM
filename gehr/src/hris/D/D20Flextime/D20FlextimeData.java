package hris.D.D20Flextime;

/**
 * D20FlextimeData.java ������ Flextime ��û ������ ��ƿ��� ������ [���� RFC] :
 * ZGHR_RFC_FLEXTIME_REQUEST 2017-08-01 eunha [CSR ID:3438118] flexible time �ý���
 * Update 	: 2018-05-09 ��ȯ�� [WorkTime52] �κ�/�������� �ٹ��� ����
 * 
 * @author eunha
 * @version 1.0, 2017/08/02
 */
public class D20FlextimeData extends com.sns.jdf.EntityData {

	public String PERNR; // ��� ��ȣ
	public String AINF_SEQN; // �������� �Ϸù�ȣ
	public String BEGDA; // ��û��
	public String FLEX_BEG; // ���� 6�� �����ʵ�
	public String FLEX_END; // ���� 6�� �����ʵ�
	public String SCHKZ; // �ٹ� ���� ��Ģ
	public String ZEDESCR; // Description
	public String ZPERNR;
	public String AEDTM;
	public String UNAME;

	// [CSR ID:3525213] Flextime �ý��� ���� ��û start
	public String FLEX_BEGDA; // ������
	public String FLEX_ENDDA; // ������

	// [WorkTime52] �κ�/�������� �ٹ��� ����
	public String FLEX_BEGTM; // �ٹ����۽ð�
	public String FLEX_ENDTM; // �ٹ�����ð�
	public String CR_UNAME; // ������
	public String CR_DATE; // ������
	public String CR_TIME; // �����ð�

	public String I_NTM;

	public String getI_NTM() {
		return I_NTM;
	}

	public void setI_NTM(String i_NTM) {
		I_NTM = i_NTM;
	}

	public String getFLEX_BEGTM() {
		return FLEX_BEGTM;
	}

	public void setFLEX_BEGTM(String fLEX_BEGTM) {
		FLEX_BEGTM = fLEX_BEGTM;
	}

	public String getFLEX_ENDTM() {
		return FLEX_ENDTM;
	}

	public void setFLEX_ENDTM(String fLEX_ENDTM) {
		FLEX_ENDTM = fLEX_ENDTM;
	}

	public String getCR_UNAME() {
		return CR_UNAME;
	}

	public void setCR_UNAME(String cR_UNAME) {
		CR_UNAME = cR_UNAME;
	}

	public String getCR_DATE() {
		return CR_DATE;
	}

	public void setCR_DATE(String cR_DATE) {
		CR_DATE = cR_DATE;
	}

	public String getCR_TIME() {
		return CR_TIME;
	}

	public void setCR_TIME(String cR_TIME) {
		CR_TIME = cR_TIME;
	}

	public String getFLEX_BEGDA() {
		return FLEX_BEGDA;
	}

	public void setFLEX_BEGDA(String fLEX_BEGDA) {
		FLEX_BEGDA = fLEX_BEGDA;
	}

	public String getFLEX_ENDDA() {
		return FLEX_ENDDA;
	}

	public void setFLEX_ENDDA(String fLEX_ENDDA) {
		FLEX_ENDDA = fLEX_ENDDA;
	}

	// [CSR ID:3525213] Flextime �ý��� ���� ��û end
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

	public String getBEGDA() {
		return BEGDA;
	}

	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}

	public String getFLEX_BEG() {
		return FLEX_BEG;
	}

	public void setFLEX_BEG(String fLEX_BEG) {
		FLEX_BEG = fLEX_BEG;
	}

	public String getFLEX_END() {
		return FLEX_END;
	}

	public void setFLEX_END(String fLEX_END) {
		FLEX_END = fLEX_END;
	}

	public String getSCHKZ() {
		return SCHKZ;
	}

	public void setSCHKZ(String sCHKZ) {
		SCHKZ = sCHKZ;
	}

	public String getZEDESCR() {
		return ZEDESCR;
	}

	public void setZEDESCR(String zEDESCR) {
		ZEDESCR = zEDESCR;
	}

	public String getZPERNR() {
		return ZPERNR;
	}

	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
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

}