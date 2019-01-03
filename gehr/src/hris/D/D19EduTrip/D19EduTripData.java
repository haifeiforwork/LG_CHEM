package	hris.D.D19EduTrip;

/**
 * D19EduTripData.java
 * 개인의 교육, 출장신청 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRW_RFC_HOLIDAY_REQUEST
 *
 * @author lsa
 * @version 1.0, 2006/08/08
 */
public class D19EduTripData extends com.sns.jdf.EntityData {
    public String PERNR       ;     // 사원번호
    public String AINF_SEQN   ;     // 결재정보 일련번호
    public String BEGDA       ;	    // 신청일
    public String AWART       ;	    // 근무/휴무 유형
    public String APPL_FROM   ;     // 신청시작일
    public String APPL_TO     ;	    // 신청종료일
    public String BEGUZ       ;	    // 시작시간
    public String ENDUZ       ;	    // 종료시간
    public String REASON      ;     // 신청 사유
    public String AEDTM	      ;     //변경일
    public String UNAME	      ;     //사용자이름
    public String OVTM_CODE   ;     //사유코드
    public String OVTM_CODE2  ;     //사유코드
    public String OVTM_CODE3  ;     //사유코드
    public String OVTM_NAME   ;     //대근자
    public String REMAIN_DATE ;	    // 잔여휴가일수
    public String ZPERNR ;	    // 대리신청자사번


	public String getPERNR() {
		return PERNR;
	}
	public String getZPERNR() {
		return ZPERNR;
	}
	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getAWART() {
		return AWART;
	}
	public void setAWART(String aWART) {
		AWART = aWART;
	}
	public String getAPPL_FROM() {
		return APPL_FROM;
	}
	public void setAPPL_FROM(String aPPL_FROM) {
		APPL_FROM = aPPL_FROM;
	}
	public String getAPPL_TO() {
		return APPL_TO;
	}
	public void setAPPL_TO(String aPPL_TO) {
		APPL_TO = aPPL_TO;
	}
	public String getBEGUZ() {
		return BEGUZ;
	}
	public void setBEGUZ(String bEGUZ) {
		BEGUZ = bEGUZ;
	}
	public String getENDUZ() {
		return ENDUZ;
	}
	public void setENDUZ(String eNDUZ) {
		ENDUZ = eNDUZ;
	}
	public String getREASON() {
		return REASON;
	}
	public void setREASON(String rEASON) {
		REASON = rEASON;
	}
	public String getAEDTM() {
		return AEDTM;
	}
	public void setAEDTM(String aEDTM) {
		AEDTM = aEDTM;
	}
	public String getUNAME() {
		return UNAME;
	}
	public void setUNAME(String uNAME) {
		UNAME = uNAME;
	}
	public String getOVTM_CODE() {
		return OVTM_CODE;
	}
	public void setOVTM_CODE(String oVTM_CODE) {
		OVTM_CODE = oVTM_CODE;
	}
	public String getOVTM_CODE2() {
		return OVTM_CODE2;
	}
	public void setOVTM_CODE2(String oVTM_CODE2) {
		OVTM_CODE2 = oVTM_CODE2;
	}
	public String getOVTM_CODE3() {
		return OVTM_CODE3;
	}
	public void setOVTM_CODE3(String oVTM_CODE3) {
		OVTM_CODE3 = oVTM_CODE3;
	}
	public String getOVTM_NAME() {
		return OVTM_NAME;
	}
	public void setOVTM_NAME(String oVTM_NAME) {
		OVTM_NAME = oVTM_NAME;
	}
	public String getREMAIN_DATE() {
		return REMAIN_DATE;
	}
	public void setREMAIN_DATE(String rEMAIN_DATE) {
		REMAIN_DATE = rEMAIN_DATE;
	}


}