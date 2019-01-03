package	hris.D.D03Vocation;

/**
 * D03VocationData.java
 * 개인의 휴가신청 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRW_RFC_HOLIDAY_REQUEST
 *
 * @author 김도신
 * @version 1.0, 2002/01/21
 */
public class D03HolidayAbsenceData extends com.sns.jdf.EntityData {
    public String BEGDA    ;     // Request Date
    public String AINF_SEQN;     // descision number
    public String FAMY_CODE;	 // descision number
    public String FAMY_TEXT;	 // Family Code Text
    public String ENAME;	     // Formatted Name of Employee or Applicant
    public String CELDT;	     // Date
    public String CELTX;	     // Celty Code Text 
    public String CELTY;	     // Celebration Code
    public String ABSN_DATE;	 // Absence Day
    
    
    public String getCELTY() {
		return CELTY;
	}

	public void setCELTY(String cELTY) {
		CELTY = cELTY;
	}


	public String getBEGDA() {
		return BEGDA;
	}

	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}

	public String getAINF_SEQN() {
		return AINF_SEQN;
	}

	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}

	public String getFAMY_CODE() {
		return FAMY_CODE;
	}

	public void setFAMY_CODE(String fAMY_CODE) {
		FAMY_CODE = fAMY_CODE;
	}

	public String getFAMY_TEXT() {
		return FAMY_TEXT;
	}

	public void setFAMY_TEXT(String fAMY_TEXT) {
		FAMY_TEXT = fAMY_TEXT;
	}

	public String getENAME() {
		return ENAME;
	}

	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}

	public String getCELDT() {
		return CELDT;
	}

	public void setCELDT(String cELDT) {
		CELDT = cELDT;
	}

	public String getABSN_DATE() {
		return ABSN_DATE;
	}

	public void setABSN_DATE(String aBSN_DATE) {
		ABSN_DATE = aBSN_DATE;
	}

	public String getCELTX() {
		return CELTX;
	}

	public void setCELTX(String cELTX) {
		CELTX = cELTX;
	}
    
}
