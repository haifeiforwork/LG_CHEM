package hris.D.D12Rotation ;

/**
 * D12RotationBuild2Data.java
 * 월간부서근태 승인정보 데이터
 *   [관련 RFC] : ZHRW_RFC_DAY_CHART
 * @author 김종서
 * @version 1.0, 2009/02/24
 */
public class D12RotationBuild2Data extends com.sns.jdf.EntityData {

	public String MANDT    ;
	public String BUKRS    ;
	public String PERNR    ;  //사원 번호
    public String ENAME    ;  //사원 또는 지원자의 포맷된 이름
    public String BEGDA    ;
    public String AINF_SEQN    ;
    public String UPMU_FLAG    ;
    public String UPMU_TYPE    ;
    public String APPR_TYPE    ;
    public String APPU_TYPE    ;
    public String APPR_SEQN    ;
    public String OTYPE    ;
    public String OBJID    ;
    public String APPU_NUMB    ;
    public String APPR_DATE    ;
    public String APPR_STAT    ;
    public String getMANDT() {
		return MANDT;
	}
	public void setMANDT(String mANDT) {
		MANDT = mANDT;
	}
	public String getBUKRS() {
		return BUKRS;
	}
	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
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
	public String getUPMU_FLAG() {
		return UPMU_FLAG;
	}
	public void setUPMU_FLAG(String uPMU_FLAG) {
		UPMU_FLAG = uPMU_FLAG;
	}
	public String getUPMU_TYPE() {
		return UPMU_TYPE;
	}
	public void setUPMU_TYPE(String uPMU_TYPE) {
		UPMU_TYPE = uPMU_TYPE;
	}
	public String getAPPR_TYPE() {
		return APPR_TYPE;
	}
	public void setAPPR_TYPE(String aPPR_TYPE) {
		APPR_TYPE = aPPR_TYPE;
	}
	public String getAPPU_TYPE() {
		return APPU_TYPE;
	}
	public void setAPPU_TYPE(String aPPU_TYPE) {
		APPU_TYPE = aPPU_TYPE;
	}
	public String getAPPR_SEQN() {
		return APPR_SEQN;
	}
	public void setAPPR_SEQN(String aPPR_SEQN) {
		APPR_SEQN = aPPR_SEQN;
	}
	public String getOTYPE() {
		return OTYPE;
	}
	public void setOTYPE(String oTYPE) {
		OTYPE = oTYPE;
	}
	public String getOBJID() {
		return OBJID;
	}
	public void setOBJID(String oBJID) {
		OBJID = oBJID;
	}
	public String getAPPU_NUMB() {
		return APPU_NUMB;
	}
	public void setAPPU_NUMB(String aPPU_NUMB) {
		APPU_NUMB = aPPU_NUMB;
	}
	public String getAPPR_DATE() {
		return APPR_DATE;
	}
	public void setAPPR_DATE(String aPPR_DATE) {
		APPR_DATE = aPPR_DATE;
	}
	public String getAPPR_STAT() {
		return APPR_STAT;
	}
	public void setAPPR_STAT(String aPPR_STAT) {
		APPR_STAT = aPPR_STAT;
	}
	public String getAPPR_STAT_CHK() {
		return APPR_STAT_CHK;
	}
	public void setAPPR_STAT_CHK(String aPPR_STAT_CHK) {
		APPR_STAT_CHK = aPPR_STAT_CHK;
	}
	public String APPR_STAT_CHK    ;
}
