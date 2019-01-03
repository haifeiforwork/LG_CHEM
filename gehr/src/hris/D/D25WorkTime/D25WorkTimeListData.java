package hris.D.D25WorkTime;

/**
 * D25WorkTimeListData.java 2018-05-28 ��ȯ�� [WorkTime52] �Ǳٹ� ������Ȳ
 * 
 * @author ��ȯ��
 * @version 1.0, 2018/05/28
 */
public class D25WorkTimeListData extends com.sns.jdf.EntityData {

	public String ENAME; // �ؽ�Ʈ (40 ����)
	public String PERNR; // �ؽ�Ʈ (40 ����)
	public String ORGTX; // �ҼӸ�
	public String JIKKT; // ��å��

	public String NORTM; // ����ٹ��ð�
	public String OVRTM; // �ʰ��ٹ��ð�
	public String EDUTM; // �����ð�
	public String BRKTM; // �ްԽð�
	public String NWKTM; // ��ٹ��ð�
	public String MONSUM;// ���հ� �����ٷνð�
	public String AVRTM; // �ִ� ��� �����ٷνð�

	public String NORTM1; // ����ٹ��ð�
	public String OVRTM1; // �ʰ��ٹ��ð�
	public String EDUTM1; // �����ð�
	public String BRKTM1; // �ްԽð�
	public String NWKTM1; // ��ٹ��ð�
	public String MONSUM1;// ���հ� �����ٷνð�
	public String RWKTM1; // �� �ٷνð�
	public String NORTM2; // ����ٹ��ð�
	public String OVRTM2; // �ʰ��ٹ��ð�
	public String EDUTM2; // �����ð�
	public String BRKTM2; // �ްԽð�
	public String NWKTM2; // ��ٹ��ð�
	public String MONSUM2;// ���հ� �����ٷνð�
	public String RWKTM2; // �� �ٷνð�
	public String NORTM3; // ����ٹ��ð�
	public String OVRTM3; // �ʰ��ٹ��ð�
	public String EDUTM3; // �����ð�
	public String BRKTM3; // �ްԽð�
	public String NWKTM3; // ��ٹ��ð�
	public String MONSUM3;// ���հ� �����ٷνð�
	public String RWKTM3; // �� �ٷνð�
	public String NORTM4; // ����ٹ��ð�
	public String OVRTM4; // �ʰ��ٹ��ð�
	public String EDUTM4; // �����ð�
	public String BRKTM4; // �ްԽð�
	public String NWKTM4; // ��ٹ��ð�
	public String RWKTM4; // �� �ٷνð�
	public String NORTM5; // ����ٹ��ð�
	public String OVRTM5; // �ʰ��ٹ��ð�
	public String EDUTM5; // �����ð�
	public String BRKTM5; // �ްԽð�
	public String NWKTM5; // ��ٹ��ð�
	public String RWKTM5; // �� �ٷνð�
	public String NORTM6; // ����ٹ��ð�
	public String OVRTM6; // �ʰ��ٹ��ð�
	public String EDUTM6; // �����ð�
	public String BRKTM6; // �ްԽð�
	public String NWKTM6; // ��ٹ��ð�
	public String RWKTM6; // �� �ٷνð�

	public String TMONSUM;// ���հ� �����ٷνð�
	public String TAVRTM; // �ִ� ��� �����ٷνð�
	public String WKDAY;  // ��
	
	private String fixZero(String input) {
		return (input.indexOf(".") == 0) ? "0" + input : input;
	}

	public String getENAME() {
		return ENAME;
	}

	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

	public String getORGTX() {
		return ORGTX;
	}

	public void setORGTX(String oRGTX) {
		ORGTX = oRGTX;
	}

	public String getJIKKT() {
		return JIKKT;
	}

	public void setJIKKT(String jIKKT) {
		JIKKT = jIKKT;
	}

	public String getNORTM() {
		return fixZero(NORTM);
	}

	public void setNORTM(String nORTM) {
		NORTM = nORTM;
	}

	public String getOVRTM() {
		return fixZero(OVRTM);
	}

	public void setOVRTM(String oVRTM) {
		OVRTM = oVRTM;
	}

	public String getEDUTM() {
		return EDUTM;
	}

	public void setEDUTM(String eDUTM) {
		EDUTM = eDUTM;
	}

	public String getBRKTM() {
		return fixZero(BRKTM);
	}

	public void setBRKTM(String bRKTM) {
		BRKTM = bRKTM;
	}

	public String getNWKTM() {
		return fixZero(NWKTM);
	}

	public void setNWKTM(String nWKTM) {
		NWKTM = nWKTM;
	}

	public String getMONSUM() {
		return fixZero(MONSUM);
	}

	public void setMONSUM(String mONSUM) {
		MONSUM = mONSUM;
	}

	public String getAVRTM() {
		return fixZero(AVRTM);
	}

	public void setAVRTM(String aVRTM) {
		AVRTM = aVRTM;
	}

	public String getNORTM1() {
		return fixZero(NORTM1);
	}

	public void setNORTM1(String nORTM1) {
		NORTM1 = nORTM1;
	}

	public String getOVRTM1() {
		return fixZero(OVRTM1);
	}

	public void setOVRTM1(String oVRTM1) {
		OVRTM1 = oVRTM1;
	}

	public String getEDUTM1() {
		return EDUTM1;
	}

	public void setEDUTM1(String eDUTM1) {
		EDUTM1 = eDUTM1;
	}

	public String getBRKTM1() {
		return fixZero(BRKTM1);
	}

	public void setBRKTM1(String bRKTM1) {
		BRKTM1 = bRKTM1;
	}

	public String getNWKTM1() {
		return fixZero(NWKTM1);
	}

	public void setNWKTM1(String nWKTM1) {
		NWKTM1 = nWKTM1;
	}

	public String getMONSUM1() {
		return fixZero(MONSUM1);
	}

	public void setMONSUM1(String mONSUM1) {
		MONSUM1 = mONSUM1;
	}

	public String getRWKTM1() {
		return fixZero(RWKTM1);
	}

	public void setRWKTM1(String rWKTM1) {
		RWKTM1 = rWKTM1;
	}

	public String getNORTM2() {
		return fixZero(NORTM2);
	}

	public void setNORTM2(String nORTM2) {
		NORTM2 = nORTM2;
	}

	public String getOVRTM2() {
		return fixZero(OVRTM2);
	}

	public void setOVRTM2(String oVRTM2) {
		OVRTM2 = oVRTM2;
	}

	public String getEDUTM2() {
		return EDUTM2;
	}

	public void setEDUTM2(String eDUTM2) {
		EDUTM2 = eDUTM2;
	}

	public String getBRKTM2() {
		return fixZero(BRKTM2);
	}

	public void setBRKTM2(String bRKTM2) {
		BRKTM2 = bRKTM2;
	}

	public String getNWKTM2() {
		return fixZero(NWKTM2);
	}

	public void setNWKTM2(String nWKTM2) {
		NWKTM2 = nWKTM2;
	}

	public String getMONSUM2() {
		return fixZero(MONSUM2);
	}

	public void setMONSUM2(String mONSUM2) {
		MONSUM2 = mONSUM2;
	}

	public String getRWKTM2() {
		return fixZero(RWKTM2);
	}

	public void setRWKTM2(String rWKTM2) {
		RWKTM2 = rWKTM2;
	}

	public String getNORTM3() {
		return fixZero(NORTM3);
	}

	public void setNORTM3(String nORTM3) {
		NORTM3 = nORTM3;
	}

	public String getOVRTM3() {
		return fixZero(OVRTM3);
	}

	public void setOVRTM3(String oVRTM3) {
		OVRTM3 = oVRTM3;
	}

	public String getEDUTM3() {
		return EDUTM3;
	}

	public void setEDUTM3(String eDUTM3) {
		EDUTM3 = eDUTM3;
	}

	public String getBRKTM3() {
		return fixZero(BRKTM3);
	}

	public void setBRKTM3(String bRKTM3) {
		BRKTM3 = bRKTM3;
	}

	public String getNWKTM3() {
		return fixZero(NWKTM3);
	}

	public void setNWKTM3(String nWKTM3) {
		NWKTM3 = nWKTM3;
	}

	public String getMONSUM3() {
		return fixZero(MONSUM3);
	}

	public void setMONSUM3(String mONSUM3) {
		MONSUM3 = mONSUM3;
	}

	public String getRWKTM3() {
		return fixZero(RWKTM3);
	}

	public void setRWKTM3(String rWKTM3) {
		RWKTM3 = rWKTM3;
	}

	public String getNORTM4() {
		return fixZero(NORTM4);
	}

	public void setNORTM4(String nORTM4) {
		NORTM4 = nORTM4;
	}

	public String getOVRTM4() {
		return fixZero(OVRTM4);
	}

	public void setOVRTM4(String oVRTM4) {
		OVRTM4 = oVRTM4;
	}

	public String getEDUTM4() {
		return EDUTM4;
	}

	public void setEDUTM4(String eDUTM4) {
		EDUTM4 = eDUTM4;
	}

	public String getBRKTM4() {
		return fixZero(BRKTM4);
	}

	public void setBRKTM4(String bRKTM4) {
		BRKTM4 = bRKTM4;
	}

	public String getNWKTM4() {
		return fixZero(NWKTM4);
	}

	public void setNWKTM4(String nWKTM4) {
		NWKTM4 = nWKTM4;
	}

	public String getRWKTM4() {
		return fixZero(RWKTM4);
	}

	public void setRWKTM4(String rWKTM4) {
		RWKTM4 = rWKTM4;
	}

	public String getNORTM5() {
		return fixZero(NORTM5);
	}

	public void setNORTM5(String nORTM5) {
		NORTM5 = nORTM5;
	}

	public String getOVRTM5() {
		return fixZero(OVRTM5);
	}

	public void setOVRTM5(String oVRTM5) {
		OVRTM5 = oVRTM5;
	}

	public String getEDUTM5() {
		return EDUTM5;
	}

	public void setEDUTM5(String eDUTM5) {
		EDUTM5 = eDUTM5;
	}

	public String getBRKTM5() {
		return fixZero(BRKTM5);
	}

	public void setBRKTM5(String bRKTM5) {
		BRKTM5 = bRKTM5;
	}

	public String getNWKTM5() {
		return fixZero(NWKTM5);
	}

	public void setNWKTM5(String nWKTM5) {
		NWKTM5 = nWKTM5;
	}

	public String getRWKTM5() {
		return fixZero(RWKTM5);
	}

	public void setRWKTM5(String rWKTM5) {
		RWKTM5 = rWKTM5;
	}

	public String getNORTM6() {
		return fixZero(NORTM6);
	}

	public void setNORTM6(String nORTM6) {
		NORTM6 = nORTM6;
	}

	public String getOVRTM6() {
		return fixZero(OVRTM6);
	}

	public void setOVRTM6(String oVRTM6) {
		OVRTM6 = oVRTM6;
	}

	public String getEDUTM6() {
		return EDUTM6;
	}

	public void setEDUTM6(String eDUTM6) {
		EDUTM6 = eDUTM6;
	}

	public String getBRKTM6() {
		return fixZero(BRKTM6);
	}

	public void setBRKTM6(String bRKTM6) {
		BRKTM6 = bRKTM6;
	}

	public String getNWKTM6() {
		return fixZero(NWKTM6);
	}

	public void setNWKTM6(String nWKTM6) {
		NWKTM6 = nWKTM6;
	}

	public String getRWKTM6() {
		return fixZero(RWKTM6);
	}

	public void setRWKTM6(String rWKTM6) {
		RWKTM6 = rWKTM6;
	}

	public String getTMONSUM() {
		return fixZero(TMONSUM);
	}

	public void setTMONSUM(String tMONSUM) {
		TMONSUM = tMONSUM;
	}

	public String getTAVRTM() {
		return fixZero(TAVRTM);
	}

	public void setTAVRTM(String tAVRTM) {
		TAVRTM = tAVRTM;
	}

	public String getWKDAY() {
		return fixZero(WKDAY);
	}

	public void setWKDAY(String wKDAY) {
		WKDAY = wKDAY;
	}

}
