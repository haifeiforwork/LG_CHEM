package hris.D.D25WorkTime;

/**
 * D25WorkTimeHeaderData.java 2018-05-24 ��ȯ�� [WorkTime52] �� �ٷνð� ����Ʈ
 * 
 * @author ��ȯ��
 * @version 1.0, 2018/05/24
 */
public class D25WorkTimeHeaderData extends com.sns.jdf.EntityData {

	public String PERNR; // ��� ��ȣ
	public String WEEKS; // ����( week no.)
	public String BEGDA; // ������
	public String ENDDA; // ������
	public String GUBUN; // ����
	public String RWKTM; // �� �ٷνð�

	public String YYYYMM; // ���
	public String MONSUM; // ���հ� �����ٷνð�
	public String WEKAVR; // �ִ� ��� �����ٷνð�
	public String WKDAY; // �� ��

	public String PERIOD; // ����Ⱓ
	public String MAXTM; // ��������
	public String AVRTM; // �ִ� ��� �� �ٷνð�
	public String DAYS;  // 2�ڸ���
	public String ZOVER; // ���� ���� ǥ��

	private String fixZero(String input) {
		return (input.indexOf(".") == 0) ? "0" + input : input;
	}

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

	public String getWEEKS() {
		return WEEKS;
	}

	public void setWEEKS(String wEEKS) {
		WEEKS = wEEKS;
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

	public String getGUBUN() {
		return GUBUN;
	}

	public void setGUBUN(String gUBUN) {
		GUBUN = gUBUN;
	}

	public String getRWKTM() {
		return fixZero(RWKTM);
	}

	public void setRWKTM(String rWKTM) {
		RWKTM = rWKTM;
	}

	public String getYYYYMM() {
		return YYYYMM;
	}

	public void setYYYYMM(String yYYYMM) {
		YYYYMM = yYYYMM;
	}

	public String getMONSUM() {
		return MONSUM;
	}

	public void setMONSUM(String mONSUM) {
		MONSUM = mONSUM;
	}

	public String getWEKAVR() {
		return WEKAVR;
	}

	public void setWEKAVR(String wEKAVR) {
		WEKAVR = wEKAVR;
	}

	public String getWKDAY() {
		return WKDAY;
	}

	public void setWKDAY(String wKDAY) {
		WKDAY = wKDAY;
	}

	public String getPERIOD() {
		return PERIOD;
	}

	public void setPERIOD(String pERIOD) {
		PERIOD = pERIOD;
	}

	public String getMAXTM() {
		return fixZero(MAXTM);
	}

	public void setMAXTM(String mAXTM) {
		MAXTM = mAXTM;
	}

	public String getAVRTM() {
		return fixZero(AVRTM);
	}

	public void setAVRTM(String aVRTM) {
		AVRTM = aVRTM;
	}

	public String getDAYS() {
		return DAYS;
	}

	public void setDAYS(String dAYS) {
		DAYS = dAYS;
	}

	public String getZOVER() {
		return ZOVER;
	}

	public void setZOVER(String zOVER) {
		ZOVER = zOVER;
	}

}
