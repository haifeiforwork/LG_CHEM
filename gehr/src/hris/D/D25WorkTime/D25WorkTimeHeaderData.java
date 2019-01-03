package hris.D.D25WorkTime;

/**
 * D25WorkTimeHeaderData.java 2018-05-24 성환희 [WorkTime52] 실 근로시간 레포트
 * 
 * @author 성환희
 * @version 1.0, 2018/05/24
 */
public class D25WorkTimeHeaderData extends com.sns.jdf.EntityData {

	public String PERNR; // 사원 번호
	public String WEEKS; // 주차( week no.)
	public String BEGDA; // 시작일
	public String ENDDA; // 종료일
	public String GUBUN; // 구분
	public String RWKTM; // 실 근로시간

	public String YYYYMM; // 년월
	public String MONSUM; // 월합계 실제근로시간
	public String WEKAVR; // 주당 평균 실제근로시간
	public String WKDAY; // 일 수

	public String PERIOD; // 정산기간
	public String MAXTM; // 법정기준
	public String AVRTM; // 주당 평균 실 근로시간
	public String DAYS;  // 2자릿수
	public String ZOVER; // 단일 문자 표시

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
