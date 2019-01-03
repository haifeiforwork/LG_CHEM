/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인포멀가입현황                                              */
/*   Program Name : 인포멀가입현황                                              */
/*   Program ID   : E26InfoStateData                                            */
/*   Description  : 인포멀 가입현황, 탈퇴신청에 대한 데이터                     */
/*   Note         : [관련 RFC] : ZHRH_RFC_INFORMAL_JOIN                         */
/*   Creation     : 2001-12-26  이형석                                          */
/*   Update       : 2005-03-02  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E26InfoState;

public class E26InfoStateData extends com.sns.jdf.EntityData {

    public String AINF_SEQN;  // 결재정보 일련번호
    public String BEGDA    ;  // 시작일
    public String ENDDA    ;  // 종료일
    public String APPL_DATE;  // 승인일(신청일)
    public String MGART    ;  // 구성원유형
    public String STEXT    ;  // 하부유형이름
    public String BETRG    ;  // 회비
    public String LGART    ;  // 임금유형
    public String PERN_NUMB;  // 간사
    public String ENAME    ;  // 사원 또는 지원자 이름
    public String TITEL    ;  // 직위
    public String USRID    ;  // 통신 ID/번호
    public String ENTR_DATE;  // 가입일
    public String WAERS    ;  // 통화키
    public String INFO_TYPE;  // 인포멀 결재(0:가입, 1:탈퇴)
    public String ZPERNR   ;  // 대리신청자사번
    public String ZUNAME   ;  // 부서서무 이름
    public String AEDTM    ;  // 변경일
    public String UNAME    ;  // 사용자이름
    public String PERNR    ;  // 사원번호
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
	public String getENDDA() {
		return ENDDA;
	}
	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}
	public String getAPPL_DATE() {
		return APPL_DATE;
	}
	public void setAPPL_DATE(String aPPL_DATE) {
		APPL_DATE = aPPL_DATE;
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
	public String getBETRG() {
		return BETRG;
	}
	public void setBETRG(String bETRG) {
		BETRG = bETRG;
	}
	public String getLGART() {
		return LGART;
	}
	public void setLGART(String lGART) {
		LGART = lGART;
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
	public String getTITEL() {
		return TITEL;
	}
	public void setTITEL(String tITEL) {
		TITEL = tITEL;
	}
	public String getUSRID() {
		return USRID;
	}
	public void setUSRID(String uSRID) {
		USRID = uSRID;
	}
	public String getENTR_DATE() {
		return ENTR_DATE;
	}
	public void setENTR_DATE(String eNTR_DATE) {
		ENTR_DATE = eNTR_DATE;
	}
	public String getWAERS() {
		return WAERS;
	}
	public void setWAERS(String wAERS) {
		WAERS = wAERS;
	}
	public String getINFO_TYPE() {
		return INFO_TYPE;
	}
	public void setINFO_TYPE(String iNFO_TYPE) {
		INFO_TYPE = iNFO_TYPE;
	}
	public String getZPERNR() {
		return ZPERNR;
	}
	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
	}
	public String getZUNAME() {
		return ZUNAME;
	}
	public void setZUNAME(String zUNAME) {
		ZUNAME = zUNAME;
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
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}


}
