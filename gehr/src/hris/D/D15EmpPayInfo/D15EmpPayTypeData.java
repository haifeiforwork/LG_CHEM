package hris.D.D15EmpPayInfo;

import com.sns.jdf.EntityData;

public class D15EmpPayTypeData extends EntityData {
	public String LGART;	//임금 유형
	public String LGTXT;	//임금 유형 설명
	public String ABTYZ;	//사원 하위 그룹 그루핑의 1차 임금 유형 및 임금 유지보수
	public String WKTYZ;	//주요임금유형 및 임금유지보수에 대한 인사하위영역
	public String KOMBI;	//유효한 입력조합

	/*해외*/
	public String INFTY;	//		CHAR	4	Infotype

	public String getINFTY() {
		return INFTY;
	}

	public void setINFTY(String INFTY) {
		this.INFTY = INFTY;
	}

	public String getLGART() {
		return LGART;
	}

	public void setLGART(String LGART) {
		this.LGART = LGART;
	}

	public String getLGTXT() {
		return LGTXT;
	}

	public void setLGTXT(String LGTXT) {
		this.LGTXT = LGTXT;
	}

	public String getABTYZ() {
		return ABTYZ;
	}

	public void setABTYZ(String ABTYZ) {
		this.ABTYZ = ABTYZ;
	}

	public String getWKTYZ() {
		return WKTYZ;
	}

	public void setWKTYZ(String WKTYZ) {
		this.WKTYZ = WKTYZ;
	}

	public String getKOMBI() {
		return KOMBI;
	}

	public void setKOMBI(String KOMBI) {
		this.KOMBI = KOMBI;
	}
}
