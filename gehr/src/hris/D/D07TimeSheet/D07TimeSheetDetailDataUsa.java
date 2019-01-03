package hris.D.D07TimeSheet;

/**
 *	 D07TimeSheetDetailDataUsa.java
 *  Time Sheet 정보를 담아오는 데이터
 *  [관련 RFC] : ZHRE_RFC_TIME_SHEET [USA]
 *
 * @author jungin
 * @version 1.0, 2010/10/12
 */

public class D07TimeSheetDetailDataUsa extends com.sns.jdf.EntityData {

    public String PERNR;      		// 사원번호
    public String BEGDA;      		// 신청일
    public String AINF_SEQN;		// 결재정보 일련번호
    public String WKDAT;			//
    public String SEQNR;			// sequence No.
    public String WEEKDAY_L;  	//
    public String WKHRS;      		//
    public String DYTOT;			//
    public String AWART;      		//
    public String ATEXT;      		//
    public String KOSTL;      		//
    public String POSID;      		//
    public String PSPNR;      		//
    public String WEEKNO;      	//
    public String TBEGDA;			//
    public String TENDDA;			//
    public String EXMPT;			//
    public String OTHRS;			//
    public String WTEXT;      		//
    public String APPR_STAT;     //
    public String PERNR_D;      	//
    public String ZUNAME;			//
    public String ZPERNR;			//
    public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
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
	public String getWKDAT() {
		return WKDAT;
	}
	public void setWKDAT(String wKDAT) {
		WKDAT = wKDAT;
	}
	public String getSEQNR() {
		return SEQNR;
	}
	public void setSEQNR(String sEQNR) {
		SEQNR = sEQNR;
	}
	public String getWEEKDAY_L() {
		return WEEKDAY_L;
	}
	public void setWEEKDAY_L(String wEEKDAY_L) {
		WEEKDAY_L = wEEKDAY_L;
	}
	public String getWKHRS() {
		return WKHRS;
	}
	public void setWKHRS(String wKHRS) {
		WKHRS = wKHRS;
	}
	public String getDYTOT() {
		return DYTOT;
	}
	public void setDYTOT(String dYTOT) {
		DYTOT = dYTOT;
	}
	public String getAWART() {
		return AWART;
	}
	public void setAWART(String aWART) {
		AWART = aWART;
	}
	public String getATEXT() {
		return ATEXT;
	}
	public void setATEXT(String aTEXT) {
		ATEXT = aTEXT;
	}
	public String getKOSTL() {
		return KOSTL;
	}
	public void setKOSTL(String kOSTL) {
		KOSTL = kOSTL;
	}
	public String getPOSID() {
		return POSID;
	}
	public void setPOSID(String pOSID) {
		POSID = pOSID;
	}
	public String getPSPNR() {
		return PSPNR;
	}
	public void setPSPNR(String pSPNR) {
		PSPNR = pSPNR;
	}
	public String getWEEKNO() {
		return WEEKNO;
	}
	public void setWEEKNO(String wEEKNO) {
		WEEKNO = wEEKNO;
	}
	public String getTBEGDA() {
		return TBEGDA;
	}
	public void setTBEGDA(String tBEGDA) {
		TBEGDA = tBEGDA;
	}
	public String getTENDDA() {
		return TENDDA;
	}
	public void setTENDDA(String tENDDA) {
		TENDDA = tENDDA;
	}
	public String getEXMPT() {
		return EXMPT;
	}
	public void setEXMPT(String eXMPT) {
		EXMPT = eXMPT;
	}
	public String getOTHRS() {
		return OTHRS;
	}
	public void setOTHRS(String oTHRS) {
		OTHRS = oTHRS;
	}
	public String getWTEXT() {
		return WTEXT;
	}
	public void setWTEXT(String wTEXT) {
		WTEXT = wTEXT;
	}
	public String getAPPR_STAT() {
		return APPR_STAT;
	}
	public void setAPPR_STAT(String aPPR_STAT) {
		APPR_STAT = aPPR_STAT;
	}
	public String getPERNR_D() {
		return PERNR_D;
	}
	public void setPERNR_D(String pERNR_D) {
		PERNR_D = pERNR_D;
	}
	public String getZUNAME() {
		return ZUNAME;
	}
	public void setZUNAME(String zUNAME) {
		ZUNAME = zUNAME;
	}
	public String getZPERNR() {
		return ZPERNR;
	}
	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
	}
	public String getPBEZ3() {
		return PBEZ3;
	}
	public void setPBEZ3(String pBEZ3) {
		PBEZ3 = pBEZ3;
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
	public String getWEBFLAG() {
		return WEBFLAG;
	}
	public void setWEBFLAG(String wEBFLAG) {
		WEBFLAG = wEBFLAG;
	}
	public String PBEZ3;      		//
    public String AEDTM;      		//
    public String UNAME;      		//
    public String WEBFLAG;		// Default Row 삭제 여부 플래그 (X:삭제불가)

}
