package hris.D.D07TimeSheet;

/**
 *	 D07TimeSheetApproverDataUsa.java
 *  Time Sheet �󼼺����, ������ ������ ��ƿ��� ������
 *  [���� RFC] : ZHRE_RFC_TIME_SHEET [USA]
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
	public String CODE;      		// Pay Date Range �ڵ�
    public String TEXT;      		// Pay Date Range �ؽ�Ʈ
    public String AINF_SEQN;		// �����ȣ
    public String PERNR;				// ������ ���
    public String ENAME;  			// ������ �̸�
    public String APPR_STAT;		// ���� ���� (���� A / �ݷ� R)
    public String APPL_BEGDA;	// Ÿ�ӽ�Ʈ ��û ������ �� ��¥ (Application ���� ��¥ - ZHR0099T�� BEGDA)

}
