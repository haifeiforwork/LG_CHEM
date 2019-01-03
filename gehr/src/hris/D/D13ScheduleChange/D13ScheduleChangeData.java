package hris.D.D13ScheduleChange;

import com.sns.jdf.EntityData;

public class D13ScheduleChangeData extends EntityData {
	/* 국내용 */
	public String PERNR;	 	//사원 번호
	public String ENAME;	 //사원 또는 지원자의 포맷된 이름
	public String BEGDA;	 //적용일(시작일이자 종료일)
	public String TPROG;	 //일일 근무 일정
	public String TTEXT;	 //일일근무일정 텍스트
	public String VARIA;	 	//일간근무일정 변형
	public String TPROG2;	 //	[2003]일일 근무 일정
	public String TTEXT2;	 //	[2003]일일근무일정 텍스트
	public String VARIA2;	 //	[2003]일일근무일정 변형
	/*해외추가분 T_RETURN */
	public String  RTEXT ;	 //Text for Work Schedule Rule (Planned Working Time Infotype) 
	public String  ENDDA ;	 //End Date 
	public String  VTART ;	 //Substitution Type 
	public String  DEL   ;	 //Deletion Indicator	
	public String  SOBEG ;	 //Start of planned working time	
	public String  SOEND ;	 //End of planned working time	
	public String  SOLLZ ;	 //Planned working hours	
	public String  ZBIGO ;	 //comments	
	/*해외추가분 T_RESULT */
	public String  KURZT;	 //Start Date 
	public String  STDAZ;	 //Start of planned working time	
	public String  ZMODN;	 //End of planned working time	
	public String  ZTEXT;	 //Planned working hours	
	public String  MOFID;	 //comments	
	public String  ZLINE;	 //comments	

	public String CBEGDA;	 //적용일(시작일이자 종료일)
	public String CENDDA ;	 //End Date 
    public String 	ZCHECK    ;     // Choice                                                       선택
    public String 	INFTY     ;     // Infotype
    public String 	SUBTY     ;     // Subtype
    public String 	OBJPS     ;     // Object Identification
    public String 	SPRPS     ;     // Lock Indicator for HR Master Data Record                     인포타입 종료일
    public String 	SEQNR     ;     // Number of Infotype Record with Same Key
    public String 	BEGUZ     ;     // Number of Infotype Record with Same Key
    public String 	ENDUZ     ;     // Number of Infotype Record with Same Key

    
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
	public String getSEQNR() {
		return SEQNR;
	}
	public void setSEQNR(String sEQNR) {
		SEQNR = sEQNR;
	}
	public String getZCHECK() {
		return ZCHECK;
	}
	public void setZCHECK(String zCHECK) {
		ZCHECK = zCHECK;
	}
	public String getINFTY() {
		return INFTY;
	}
	public void setINFTY(String iNFTY) {
		INFTY = iNFTY;
	}
	public String getSUBTY() {
		return SUBTY;
	}
	public void setSUBTY(String sUBTY) {
		SUBTY = sUBTY;
	}
	public String getOBJPS() {
		return OBJPS;
	}
	public void setOBJPS(String oBJPS) {
		OBJPS = oBJPS;
	}
	public String getSPRPS() {
		return SPRPS;
	}
	public void setSPRPS(String sPRPS) {
		SPRPS = sPRPS;
	}
	public String getCBEGDA() {
		return CBEGDA;
	}
	public void setCBEGDA(String cBEGDA) {
		CBEGDA = cBEGDA;
	}
	public String getCENDDA() {
		return CENDDA;
	}
	public void setCENDDA(String cENDDA) {
		CENDDA = cENDDA;
	}
	public String getZLINE() {
		return ZLINE;
	}
	public void setZLINE(String zLINE) {
		ZLINE = zLINE;
	}
	public String getKURZT() {
		return KURZT;
	}
	public void setKURZT(String kURZT) {
		KURZT = kURZT;
	}
	public String getSTDAZ() {
		return STDAZ;
	}
	public void setSTDAZ(String sTDAZ) {
		STDAZ = sTDAZ;
	}
	public String getZMODN() {
		return ZMODN;
	}
	public void setZMODN(String zMODN) {
		ZMODN = zMODN;
	}
	public String getZTEXT() {
		return ZTEXT;
	}
	public void setZTEXT(String zTEXT) {
		ZTEXT = zTEXT;
	}
	public String getMOFID() {
		return MOFID;
	}
	public void setMOFID(String mOFID) {
		MOFID = mOFID;
	}
	public String getRTEXT() {
		return RTEXT;
	}
	public void setRTEXT(String rTEXT) {
		RTEXT = rTEXT;
	}
	public String getENDDA() {
		return ENDDA;
	}
	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}
	public String getVTART() {
		return VTART;
	}
	public void setVTART(String vTART) {
		VTART = vTART;
	}
	public String getDEL() {
		return DEL;
	}
	public void setDEL(String dEL) {
		DEL = dEL;
	}
	public String getSOBEG() {
		return SOBEG;
	}
	public void setSOBEG(String sOBEG) {
		SOBEG = sOBEG;
	}
	public String getSOEND() {
		return SOEND;
	}
	public void setSOEND(String sOEND) {
		SOEND = sOEND;
	}
	public String getSOLLZ() {
		return SOLLZ;
	}
	public void setSOLLZ(String sOLLZ) {
		SOLLZ = sOLLZ;
	}
	public String getZBIGO() {
		return ZBIGO;
	}
	public void setZBIGO(String zBIGO) {
		ZBIGO = zBIGO;
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
	public String getTPROG() {
		return TPROG;
	}
	public void setTPROG(String tPROG) {
		TPROG = tPROG;
	}
	public String getTTEXT() {
		return TTEXT;
	}
	public void setTTEXT(String tTEXT) {
		TTEXT = tTEXT;
	}
	public String getVARIA() {
		return VARIA;
	}
	public void setVARIA(String vARIA) {
		VARIA = vARIA;
	}
	public String getTPROG2() {
		return TPROG2;
	}
	public void setTPROG2(String tPROG2) {
		TPROG2 = tPROG2;
	}
	public String getTTEXT2() {
		return TTEXT2;
	}
	public void setTTEXT2(String tTEXT2) {
		TTEXT2 = tTEXT2;
	}
	public String getVARIA2() {
		return VARIA2;
	}
	public void setVARIA2(String vARIA2) {
		VARIA2 = vARIA2;
	}
	
	
}
