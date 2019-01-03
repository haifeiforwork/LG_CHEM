package hris.D.D25WorkTime;

/**
 * D25WorkTimeBodyData.java
 * 2018-05-24  ��ȯ��    [WorkTime52] �� �ٷνð� ����Ʈ
 * @author ��ȯ��
 * @version 1.0, 2018/05/24
 */
public class D25WorkTimeBodyData extends com.sns.jdf.EntityData {

	public String PERNR; // ��� ��ȣ
	public String DATUM; // ����
	public String SKIP;  // ���� ���� ǥ��
	public String DAYTX; // ����
	public String NORTM; // ����ٹ�
	public String OVRTM; // �ʰ��ٹ�
	public String EDUTM; // �����ð�
	public String BRKTM; // �ް�
	public String NWKTM; // ��ٹ�
	public String NWKTM01; // ��ٹ�01
	public String NWKTM02; // ��ٹ�02
	public String NWKTM03; // ��ٹ�03
	public String NWKTM04; // ��ٹ�04
	public String NWKTM05; // ��ٹ�05
	public String NWKTM06; // ��ٹ�06
	public String NWKTM07; // ��ٹ�07
	public String NWKTM08; // ��ٹ�08
	public String NWKTM09; // ��ٹ�09
	public String NWKTM10; // ��ٹ�10
	public String NWKTM11; // ��ٹ�11
	public String NWKTM12; // ��ٹ�12
	public String NWKTM13; // ��ٹ�13
	public String NWKTM14; // ��ٹ�14
	public String NWKTM15; // ��ٹ�15
	public String NWKTM16; // ��ٹ�16
	public String NWKTM17; // ��ٹ�17
	public String NWKTM18; // ��ٹ�18
	public String NWKTM19; // ��ٹ�19
	public String NWKTM20; // ��ٹ�20
	public String RWKTM; // �� �ٷνð�
	public String ZWEEK; // ����( week no.)
	public String RWSUMA; // ���� �ٹ��ð� ����
	public String BASOVR; // �⺻�ٹ��ð� �ʰ�
	
	private String fixZero(String input) {
		return (input.indexOf(".") == 0) ? "0" + input : input;
	}

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

	public String getDATUM() {
		return DATUM;
	}

	public void setDATUM(String dATUM) {
		DATUM = dATUM;
	}

	public String getSKIP() {
		return SKIP;
	}

	public void setSKIP(String sKIP) {
		SKIP = sKIP;
	}

	public String getDAYTX() {
		return DAYTX;
	}

	public void setDAYTX(String dAYTX) {
		DAYTX = dAYTX;
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
		return fixZero(EDUTM);
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

	public String getNWKTM01() {
		return fixZero(NWKTM01);
	}

	public void setNWKTM01(String nWKTM01) {
		NWKTM01 = nWKTM01;
	}

	public String getNWKTM02() {
		return fixZero(NWKTM02);
	}

	public void setNWKTM02(String nWKTM02) {
		NWKTM02 = nWKTM02;
	}

	public String getNWKTM03() {
		return fixZero(NWKTM03);
	}

	public void setNWKTM03(String nWKTM03) {
		NWKTM03 = nWKTM03;
	}

	public String getNWKTM04() {
		return fixZero(NWKTM04);
	}

	public void setNWKTM04(String nWKTM04) {
		NWKTM04 = nWKTM04;
	}

	public String getNWKTM05() {
		return fixZero(NWKTM05);
	}

	public void setNWKTM05(String nWKTM05) {
		NWKTM05 = nWKTM05;
	}

	public String getNWKTM06() {
		return fixZero(NWKTM06);
	}

	public void setNWKTM06(String nWKTM06) {
		NWKTM06 = nWKTM06;
	}

	public String getNWKTM07() {
		return fixZero(NWKTM07);
	}

	public void setNWKTM07(String nWKTM07) {
		NWKTM07 = nWKTM07;
	}

	public String getNWKTM08() {
		return fixZero(NWKTM08);
	}

	public void setNWKTM08(String nWKTM08) {
		NWKTM08 = nWKTM08;
	}

	public String getNWKTM09() {
		return fixZero(NWKTM09);
	}

	public void setNWKTM09(String nWKTM09) {
		NWKTM09 = nWKTM09;
	}

	public String getNWKTM10() {
		return fixZero(NWKTM10);
	}

	public void setNWKTM10(String nWKTM10) {
		NWKTM10 = nWKTM10;
	}

	public String getNWKTM11() {
		return fixZero(NWKTM11);
	}

	public void setNWKTM11(String nWKTM11) {
		NWKTM11 = nWKTM11;
	}

	public String getNWKTM12() {
		return fixZero(NWKTM12);
	}

	public void setNWKTM12(String nWKTM12) {
		NWKTM12 = nWKTM12;
	}

	public String getNWKTM13() {
		return fixZero(NWKTM13);
	}

	public void setNWKTM13(String nWKTM13) {
		NWKTM13 = nWKTM13;
	}

	public String getNWKTM14() {
		return fixZero(NWKTM14);
	}

	public void setNWKTM14(String nWKTM14) {
		NWKTM14 = nWKTM14;
	}

	public String getNWKTM15() {
		return fixZero(NWKTM15);
	}

	public void setNWKTM15(String nWKTM15) {
		NWKTM15 = nWKTM15;
	}

	public String getNWKTM16() {
		return fixZero(NWKTM16);
	}

	public void setNWKTM16(String nWKTM16) {
		NWKTM16 = nWKTM16;
	}

	public String getNWKTM17() {
		return fixZero(NWKTM17);
	}

	public void setNWKTM17(String nWKTM17) {
		NWKTM17 = nWKTM17;
	}

	public String getNWKTM18() {
		return fixZero(NWKTM18);
	}

	public void setNWKTM18(String nWKTM18) {
		NWKTM18 = nWKTM18;
	}

	public String getNWKTM19() {
		return fixZero(NWKTM19);
	}

	public void setNWKTM19(String nWKTM19) {
		NWKTM19 = nWKTM19;
	}

	public String getNWKTM20() {
		return fixZero(NWKTM20);
	}

	public void setNWKTM20(String nWKTM20) {
		NWKTM20 = nWKTM20;
	}

	public String getRWKTM() {
		return fixZero(RWKTM);
	}

	public void setRWKTM(String rWKTM) {
		RWKTM = rWKTM;
	}

	public String getZWEEK() {
		return ZWEEK;
	}

	public void setZWEEK(String zWEEK) {
		ZWEEK = zWEEK;
	}

	public String getRWSUMA() {
		return RWSUMA;
	}

	public void setRWSUMA(String rWSUMA) {
		RWSUMA = rWSUMA;
	}

	public String getBASOVR() {
		return BASOVR;
	}

	public void setBASOVR(String bASOVR) {
		BASOVR = bASOVR;
	}

}
