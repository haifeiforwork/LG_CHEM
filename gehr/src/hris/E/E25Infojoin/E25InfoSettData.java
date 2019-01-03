package	hris.E.E25Infojoin;

/**
 * E25InfoSettData.java
 * 인포멀간사 결재에 대한 DATA
 *   [관련 RFC] : ZHRH_RFC_INFORMAL_SETT
 *
 * @author 이형석
 * @version 1.0, 2001/12/26
 */
public class E25InfoSettData extends com.sns.jdf.EntityData {

    public String AINF_SEQN ;   // 결재정보일련번호
    public String MGART     ;   // 구성원 유형
    public String STEXT     ;   // 오브젝트 이름
    public String PERN_NUMB ;   // 간사
    public String ENAME     ;   // 간사이름
    public String ORGEH     ;   // 소속부서
    public String ORGTX     ;   // 조직단위텍스트
    public String TITEL     ;   // 직책
    public String APPR_DATE ;   // 승인일
    public String APPR_STAT ;   // 승인상태
    public String USRID     ;   // 통신I/D번호
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getMGART() {
		return MGART;
	}
	public void setMGART(String mGART) {
		MGART = mGART;
	}
	public String getSTEXT() {
		return STEXT;
	}
	public void setSTEXT(String sTEXT) {
		STEXT = sTEXT;
	}
	public String getPERN_NUMB() {
		return PERN_NUMB;
	}
	public void setPERN_NUMB(String pERN_NUMB) {
		PERN_NUMB = pERN_NUMB;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getORGEH() {
		return ORGEH;
	}
	public void setORGEH(String oRGEH) {
		ORGEH = oRGEH;
	}
	public String getORGTX() {
		return ORGTX;
	}
	public void setORGTX(String oRGTX) {
		ORGTX = oRGTX;
	}
	public String getTITEL() {
		return TITEL;
	}
	public void setTITEL(String tITEL) {
		TITEL = tITEL;
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
	public String getUSRID() {
		return USRID;
	}
	public void setUSRID(String uSRID) {
		USRID = uSRID;
	}


}