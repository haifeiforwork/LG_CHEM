package hris.common;

import com.sns.jdf.EntityData;

/**
 * EmpGubunData.java
 * [WorkTime52] 사원 (근무)구분 산출 구조
 * [관련 RFC] : ZGHR_RFC_NTM_TPGUP_GET
 *
 * @author 성환희
 * @version 1.0, 2018/05/16
 */
public class EmpGubunData extends EntityData {

	public String PERNR; 	// 사원 번호
	public String BUKRS; 	// 회사 코드
	public String EMPGUB; 	// 사원 구분(S:사무직, H:현장직)
	public String TPGUB; 	// 사원 근무구분
	public String ADJPRD; 	// 정산기간
	public String ADJUNT; 	// 정산기간 단위
	public String TWTYP; 	// 총근로시간 유형
	public String FXTIM; 	// 고정시간

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
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

	public String getTPGUB() {
		return TPGUB;
	}

	public void setTPGUB(String tPGUB) {
		TPGUB = tPGUB;
	}

	public String getADJPRD() {
		return ADJPRD;
	}

	public void setADJPRD(String aDJPRD) {
		ADJPRD = aDJPRD;
	}

	public String getADJUNT() {
		return ADJUNT;
	}

	public void setADJUNT(String aDJUNT) {
		ADJUNT = aDJUNT;
	}

	public String getTWTYP() {
		return TWTYP;
	}

	public void setTWTYP(String tWTYP) {
		TWTYP = tWTYP;
	}

	public String getFXTIM() {
		return FXTIM;
	}

	public void setFXTIM(String fXTIM) {
		FXTIM = fXTIM;
	}

}
