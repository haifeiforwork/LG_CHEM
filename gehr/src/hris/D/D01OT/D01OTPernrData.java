package hris.D.D01OT;

public class D01OTPernrData extends com.sns.jdf.EntityData {

	public String PERNR; // 사원 번호
	public String ENAME; // 사원 또는 지원자의 포맷된 이름

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

	public String getENAME() {
		return ENAME;
	}

	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}

}
