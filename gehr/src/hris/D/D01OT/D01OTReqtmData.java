package hris.D.D01OT;

public class D01OTReqtmData extends com.sns.jdf.EntityData {

	public String PERNR; // ��� ��ȣ
	public String AINF_SEQN; // �������� �Ϸù�ȣ
	public String DATUM; // ����
	public String BEGUZ; // ���� �ð�
	public String ENDUZ; // ���� �ð�
	public String STDAZ; // �ʰ��ٹ��ð�
	public String TIMETX; // �ؽ�Ʈ (100����)
	public String APPR_STAT; // ���λ���
	public String STATX; // ����

	public D01OTResultData TRESULT;

	public String ISDISABLED; // üũ�ڽ� ��Ȱ�� ����

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

	public String getDATUM() {
		return DATUM;
	}

	public void setDATUM(String dATUM) {
		DATUM = dATUM;
	}

	public String getBEGUZ() {
		return BEGUZ;
	}

	public void setBEGUZ(String bEGUZ) {
		BEGUZ = bEGUZ;
	}

	public String getENDUZ() {
		return ENDUZ;
	}

	public void setENDUZ(String eNDUZ) {
		ENDUZ = eNDUZ;
	}

	public String getSTDAZ() {
		return STDAZ;
	}

	public void setSTDAZ(String sTDAZ) {
		STDAZ = sTDAZ;
	}

	public String getTIMETX() {
		return TIMETX;
	}

	public void setTIMETX(String tIMETX) {
		TIMETX = tIMETX;
	}

	public String getAPPR_STAT() {
		return APPR_STAT;
	}

	public void setAPPR_STAT(String aPPR_STAT) {
		APPR_STAT = aPPR_STAT;
	}

	public String getSTATX() {
		return STATX;
	}

	public void setSTATX(String sTATX) {
		STATX = sTATX;
	}

	public D01OTResultData getTRESULT() {
		return TRESULT;
	}

	public void setTRESULT(D01OTResultData tRESULT) {
		TRESULT = tRESULT;
	}

	public String getISDISABLED() {
		return ISDISABLED;
	}

	public void setISDISABLED(String iSDISABLED) {
		ISDISABLED = iSDISABLED;
	}

}
