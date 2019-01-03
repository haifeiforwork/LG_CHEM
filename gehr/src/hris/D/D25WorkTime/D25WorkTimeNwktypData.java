package hris.D.D25WorkTime;

/**
 * D25WorkTimeNwktypData.java
 * 2018-05-24  성환희    [WorkTime52] 실 근로시간 레포트
 * @author 성환희
 * @version 1.0, 2018/05/24
 */
public class D25WorkTimeNwktypData extends com.sns.jdf.EntityData {

	public String FLDNM; // 필드명
	public String BUKRS; // 회사 코드
	public String EMPGUB; // 사원 구분
	public String NWKTYP; // 비근무 유형
	public String NWKTXT; // 비근무 유형 명
	public String RWKDUD; // 실근무시간 차감

	public String getFLDNM() {
		return FLDNM;
	}

	public void setFLDNM(String fLDNM) {
		FLDNM = fLDNM;
	}

	public String getBUKRS() {
		return BUKRS;
	}

	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}

	public String getEMPGUB() {
		return EMPGUB;
	}

	public void setEMPGUB(String eMPGUB) {
		EMPGUB = eMPGUB;
	}

	public String getNWKTYP() {
		return NWKTYP;
	}

	public void setNWKTYP(String nWKTYP) {
		NWKTYP = nWKTYP;
	}

	public String getNWKTXT() {
		return NWKTXT;
	}

	public void setNWKTXT(String nWKTXT) {
		NWKTXT = nWKTXT;
	}

	public String getRWKDUD() {
		return RWKDUD;
	}

	public void setRWKDUD(String rWKDUD) {
		RWKDUD = rWKDUD;
	}

}
