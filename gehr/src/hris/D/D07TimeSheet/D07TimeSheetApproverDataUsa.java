package hris.D.D07TimeSheet;

/**
 *	 D07TimeSheetApproverDataUsa.java
 *  Time Sheet 상세보기시, 결재자 정보를 담아오는 데이터
 *  [관련 RFC] : ZHRE_RFC_TIME_SHEET [USA]
 *
 * @author jungin
 * @version 1.0, 2010/10/12
 */

public class D07TimeSheetApproverDataUsa extends com.sns.jdf.EntityData {

    public String getCODE() {
		return CODE;
	}
	public void setCODE(String cODE) {
		CODE = cODE;
	}
	public String getTEXT() {
		return TEXT;
	}
	public void setTEXT(String tEXT) {
		TEXT = tEXT;
	}
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
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
	public String getAPPR_STAT() {
		return APPR_STAT;
	}
	public void setAPPR_STAT(String aPPR_STAT) {
		APPR_STAT = aPPR_STAT;
	}
	public String getAPPL_BEGDA() {
		return APPL_BEGDA;
	}
	public void setAPPL_BEGDA(String aPPL_BEGDA) {
		APPL_BEGDA = aPPL_BEGDA;
	}
	public String CODE;      		// Pay Date Range 코드
    public String TEXT;      		// Pay Date Range 텍스트
    public String AINF_SEQN;		// 결재번호
    public String PERNR;				// 결재자 사번
    public String ENAME;  			// 결재자 이름
    public String APPR_STAT;		// 결재 상태 (결재 A / 반려 R)
    public String APPL_BEGDA;	// 타임시트 신청 저장을 한 날짜 (Application 저장 날짜 - ZHR0099T의 BEGDA)

}
