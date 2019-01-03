package hris.D.D01OT;

public class D01OTHeaderData extends com.sns.jdf.EntityData {

	public String PERNR; // 사원 번호
	public String MAXTM; // 최대근무가능시간
	public String BASTM; // 기본근무시간
	public String RWKTM; // 실 근로시간
	public String OTMBA; // 초과근로(정산)
	public String OTMAC; // 초과근로(결재)
	public String OTMAP; // 초과근로(결재중)

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

	public String getMAXTM() {
		return MAXTM;
	}

	public void setMAXTM(String mAXTM) {
		MAXTM = mAXTM;
	}

	public String getBASTM() {
		return BASTM;
	}

	public void setBASTM(String bASTM) {
		BASTM = bASTM;
	}

	public String getRWKTM() {
		return RWKTM;
	}

	public void setRWKTM(String rWKTM) {
		RWKTM = rWKTM;
	}

	public String getOTMBA() {
		return OTMBA;
	}

	public void setOTMBA(String oTMBA) {
		OTMBA = oTMBA;
	}

	public String getOTMAC() {
		return OTMAC;
	}

	public void setOTMAC(String oTMAC) {
		OTMAC = oTMAC;
	}

	public String getOTMAP() {
		return OTMAP;
	}

	public void setOTMAP(String oTMAP) {
		OTMAP = oTMAP;
	}

}
