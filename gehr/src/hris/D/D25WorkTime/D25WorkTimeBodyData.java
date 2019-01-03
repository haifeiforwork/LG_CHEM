package hris.D.D25WorkTime;

/**
 * D25WorkTimeBodyData.java
 * 2018-05-24  성환희    [WorkTime52] 실 근로시간 레포트
 * @author 성환희
 * @version 1.0, 2018/05/24
 */
public class D25WorkTimeBodyData extends com.sns.jdf.EntityData {

	public String PERNR; // 사원 번호
	public String DATUM; // 일자
	public String SKIP;  // 단일 문자 표시
	public String DAYTX; // 일자
	public String NORTM; // 정상근무
	public String OVRTM; // 초과근무
	public String EDUTM; // 교육시간
	public String BRKTM; // 휴게
	public String NWKTM; // 비근무
	public String NWKTM01; // 비근무01
	public String NWKTM02; // 비근무02
	public String NWKTM03; // 비근무03
	public String NWKTM04; // 비근무04
	public String NWKTM05; // 비근무05
	public String NWKTM06; // 비근무06
	public String NWKTM07; // 비근무07
	public String NWKTM08; // 비근무08
	public String NWKTM09; // 비근무09
	public String NWKTM10; // 비근무10
	public String NWKTM11; // 비근무11
	public String NWKTM12; // 비근무12
	public String NWKTM13; // 비근무13
	public String NWKTM14; // 비근무14
	public String NWKTM15; // 비근무15
	public String NWKTM16; // 비근무16
	public String NWKTM17; // 비근무17
	public String NWKTM18; // 비근무18
	public String NWKTM19; // 비근무19
	public String NWKTM20; // 비근무20
	public String RWKTM; // 실 근로시간
	public String ZWEEK; // 주차( week no.)
	public String RWSUMA; // 평일 근무시간 누적
	public String BASOVR; // 기본근무시간 초과
	
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
