package	hris.D.D03Vocation;

/**
 * D03VocationData.java
 * 개인의 휴가신청 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRW_RFC_HOLIDAY_REQUEST
 * 
 * @author 김도신    
 * @version 1.0, 2002/01/21
 */
public class D03VocationData extends com.sns.jdf.EntityData {

	public String AINF_SEQN   ;     // 결재정보 일련번호 
    public String PERNR       ;     // 사원번호
    public String BEGDA       ;			// 신청일
    public String AWART       ;			// 근무/휴무 유형        
    public String REASON      ;     // 신청 사유             
    public String APPL_FROM   ;     // 신청시작일                
    public String APPL_TO     ;			// 신청종료일                
    public String BEGUZ       ;			// 시작시간              
    public String ENDUZ       ;			// 종료시간              
    public String REMAIN_DATE ;			// 잔여휴가일수         
    public String DEDUCT_DATE ;     // 공제일수
    public String PBEZ4       ;     // 신청한휴가일수
    public String  APPL_REAS       ;     // 신청 사유
    //산전후 휴가 신청으로 추가된 필드 (2004.10.27)
    public String RMDDA       ;     // 병가확정일 - 출산예정일로 사용

    //**********수정 (20050304:유용원)**********
    public String ZPERNR    ;   //대리신청자 사번
    public String ZUNAME    ;   //부서서무 이름 
    public String AEDTM     ;   //변경일         
    public String UNAME     ;   //사용자이름  
    public String CONG_CODE ;   //경조내역    
    public String OVTM_CODE ;   //사유코드 CSR ID:1546748   
    public String OVTM_NAME ;   //원근무자,대근자   CSR ID:1546748  
    public String A002_SEQN ;   //경조신청 일련번호   CSR ID:1546748  

    public String ANZHL_BAL  ;
    public String ATEXT       ;
    public String P_STDAZ       ;
    public String I_STDAZ       ;
    public String ABSN_DATE ;
    public String AINF_SEQN2 ;
    public String STDAZ       ;
    public String ABRTG       ;

    //경조 휴가 신청시 신청대상자를 저장.	2008-01-11.
    public String CELTY       ;		//경조휴가 종류 . 혼가. 상가
    public String CELTX       ;		//경제휴가 TEXT
    public String FAMY_CODE ;	//가족유형
    public String FAMY_TEXT ;	//가족유형 TEXT
    
    public String I_NTM;	// 'X'
    
    public String getP_STDAZ() {
		return P_STDAZ;
	}
	public void setP_STDAZ(String p_STDAZ) {
		P_STDAZ = p_STDAZ;
	}
	public String getI_STDAZ() {
		return I_STDAZ;
	}
	public void setI_STDAZ(String i_STDAZ) {
		I_STDAZ = i_STDAZ;
	}
	public String getAPPL_REAS() {
		return APPL_REAS;
	}
	public void setAPPL_REAS(String aPPL_REAS) {
		APPL_REAS = aPPL_REAS;
	}
	public String getANZHL_BAL() {
		return ANZHL_BAL;
	}
	public void setANZHL_BAL(String aNZHL_BAL) {
		ANZHL_BAL = aNZHL_BAL;
	}
	public String getATEXT() {
		return ATEXT;
	}
	public void setATEXT(String aTEXT) {
		ATEXT = aTEXT;
	}
	public String getp_STDAZ() {
		return P_STDAZ;
	}
	public void setp_STDAZ(String p_STDAZ) {
		P_STDAZ = p_STDAZ;
	}
	public String geti_STDAZ() {
		return I_STDAZ;
	}
	public void seti_STDAZ(String i_STDAZ) {
		I_STDAZ = i_STDAZ;
	}
	public String getABSN_DATE() {
		return ABSN_DATE;
	}
	public void setABSN_DATE(String aBSN_DATE) {
		ABSN_DATE = aBSN_DATE;
	}
	public String getAINF_SEQN2() {
		return AINF_SEQN2;
	}
	public void setAINF_SEQN2(String aINF_SEQN2) {
		AINF_SEQN2 = aINF_SEQN2;
	}
	public String getSTDAZ() {
		return STDAZ;
	}
	public void setSTDAZ(String sTDAZ) {
		STDAZ = sTDAZ;
	}
	public String getABRTG() {
		return ABRTG;
	}
	public void setABRTG(String aBRTG) {
		ABRTG = aBRTG;
	}
	public String getCELTY() {
		return CELTY;
	}
	public void setCELTY(String cELTY) {
		CELTY = cELTY;
	}
	public String getCELTX() {
		return CELTX;
	}
	public void setCELTX(String cELTX) {
		CELTX = cELTX;
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
	public String getREASON() {
		return REASON;
	}
	public void setREASON(String rEASON) {
		REASON = rEASON;
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
	public String getREMAIN_DATE() {
		return REMAIN_DATE;
	}
	public void setREMAIN_DATE(String rEMAIN_DATE) {
		REMAIN_DATE = rEMAIN_DATE;
	}
	public String getDEDUCT_DATE() {
		return DEDUCT_DATE;
	}
	public void setDEDUCT_DATE(String dEDUCT_DATE) {
		DEDUCT_DATE = dEDUCT_DATE;
	}
	public String getPBEZ4() {
		return PBEZ4;
	}
	public void setPBEZ4(String pBEZ4) {
		PBEZ4 = pBEZ4;
	}
	public String getRMDDA() {
		return RMDDA;
	}
	public void setRMDDA(String rMDDA) {
		RMDDA = rMDDA;
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
	public String getCONG_CODE() {
		return CONG_CODE;
	}
	public void setCONG_CODE(String cONG_CODE) {
		CONG_CODE = cONG_CODE;
	}
	public String getOVTM_CODE() {
		return OVTM_CODE;
	}
	public void setOVTM_CODE(String oVTM_CODE) {
		OVTM_CODE = oVTM_CODE;
	}
	public String getOVTM_NAME() {
		return OVTM_NAME;
	}
	public void setOVTM_NAME(String oVTM_NAME) {
		OVTM_NAME = oVTM_NAME;
	}
	public String getA002_SEQN() {
		return A002_SEQN;
	}
	public void setA002_SEQN(String a002_SEQN) {
		A002_SEQN = a002_SEQN;
	}
	public String getI_NTM() {
		return I_NTM;
	}
	public void setI_NTM(String i_NTM) {
		I_NTM = i_NTM;
	}

} 