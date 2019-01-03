package hris.D.D12Rotation;

import java.sql.Time;

import com.sns.jdf.EntityData;

public class D12RotationBuildCnData extends EntityData {

    public String 	ZCHECK    ;     // Choice                                                       선택
    public String 	ZLINE    ;     //
    public String 	PERNR     ;     // Personnel Number                                             사번
    public String 	INFTY     ;     // Infotype
    public String 	SUBTY     ;     // Subtype
    public String 	OBJPS     ;     // Object Identification
    public String 	SPRPS     ;     // Lock Indicator for HR Master Data Record                     인포타입 종료일
    public String 	ENDDA     ;     // End Date                                                     인포타입 시작일
    public String 	BEGDA     ;     // Start Date
    public String 	SEQNR     ;     // Number of Infotype Record with Same Key
    public String 	BEGUZ     ;     // Start Time                                                   시작시간
    public String 	ENDUZ     ;     // End Time                                                     종료시간
    public String 	VTKEN     ;     // Previous Day Indicator                                       전일지시자
    public String 	STDAZ     ;     // Overtime hours
    public String 	PBEG1     ;     // Start of Break                                               휴식시작1
    public String 	PEND1     ;     // End of Break                                                 휴식종료1
    public String 	PBEZ1     ;     // Paid Break Period
    public String 	PUNB1     ;     // Unpaid Break Period
    public String 	PBEG2     ;     // Start of Break                                               휴식시작2
    public String 	PEND2     ;     // End of Break                                                 휴식종료2
    public String 	PBEZ2     ;     // Paid Break Period
    public String 	PUNB2     ;     // Unpaid Break Period
    public String 	PBEG3     ;     // Start of Break
    public String 	PEND3     ;     // End of Break
    public String 	PBEZ3     ;     // Paid Break Period
    public String 	PUNB3     ;     // Unpaid Break Period
    public String 	PBEG4     ;     // Start of Break
    public String 	PEND4     ;     // End of Break
    public String 	PBEZ4     ;     // Paid Break Period
    public String 	PUNB4     ;     // Unpaid Break Period
    public String 	VERSL     ;     // Overtime Compensation Type
    public String 	AUFKZ     ;     // Extra Pay Indicator
    public String 	BWGRL     ;     // Valuation Basis for Different Payment
    public String 	TRFGR     ;     // Pay Scale Group
    public String 	TRFST     ;     // Pay Scale Level
    public String 	PRAKN     ;     // Premium Number
    public String 	PRAKZ     ;     // Premium Indicator
    public String 	OTYPE     ;     // Object Type
    public String 	PLANS     ;     // Position
    public String 	EXBEL     ;     // External Document Number
    public String 	HRSIF     ;     // Set number of hours
    public String 	WAERS     ;     // Currency Key
    public String 	WTART     ;     // Work tax area
    public String 	TDLANGU   ;     // Definition Set for IDs
    public String 	TDSUBLA   ;     // Definition Subset for IDs
    public String 	TDTYPE    ;     // Time Data ID Type
    public String 	CBEGDA    ;     // Start Date                                                   시작일자
    public String 	CENDDA    ;     // End Date                                                     종료일자
    public String 	ENAME     ;     // Field name                                                   성명
    public String 	OTTIM     ;     // Number                                                       초과근무시간
    public String 	RTEXT     ;     // Text for Work Schedule Rule (Planned Working Time Infotype)  근무일정규칙
    public String 	TTEXT     ;     // Daily Work Schedule Text                                     일일근무일정
    public String 	SOBEG     ;     // Start of planned working time                                시작시간
    public String 	SOEND     ;     // End of planned working time                                  종료시간
    public String 	SOLLZ     ;     // Planned working hours                                        근무시간
    public String 	REASON    ;     // Infotype Text                                                사유
	public String 	ZMSG      ;     // Message Text                                                 비고
    public String 	CVTKEN    ;
    public String 	CBEGUZ    ;
    public String 	CENDUZ    ;
    public String 	CPBEG1    ;
    public String 	CPEND1    ;
    public String 	CPBEG2    ;
    public String 	CPEND2    ;
    public String 	CREASON   ;
    public String 	CPERNR   ;
    public String 	CENAME   ;
	public String getZCHECK() {
		return ZCHECK;
	}
	public void setZCHECK(String zCHECK) {
		ZCHECK = zCHECK;
	}
	public String getZLINE() {
		return ZLINE;
	}
	public void setZLINE(String zLINE) {
		ZLINE = zLINE;
	}
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
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
	public String getENDDA() {
		return ENDDA;
	}
	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getSEQNR() {
		return SEQNR;
	}
	public void setSEQNR(String sEQNR) {
		SEQNR = sEQNR;
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
	public String getVTKEN() {
		return VTKEN;
	}
	public void setVTKEN(String vTKEN) {
		VTKEN = vTKEN;
	}
	public String getSTDAZ() {
		return STDAZ;
	}
	public void setSTDAZ(String sTDAZ) {
		STDAZ = sTDAZ;
	}
	public String getPBEG1() {
		return PBEG1;
	}
	public void setPBEG1(String pBEG1) {
		PBEG1 = pBEG1;
	}
	public String getPEND1() {
		return PEND1;
	}
	public void setPEND1(String pEND1) {
		PEND1 = pEND1;
	}
	public String getPBEZ1() {
		return PBEZ1;
	}
	public void setPBEZ1(String pBEZ1) {
		PBEZ1 = pBEZ1;
	}
	public String getPUNB1() {
		return PUNB1;
	}
	public void setPUNB1(String pUNB1) {
		PUNB1 = pUNB1;
	}
	public String getPBEG2() {
		return PBEG2;
	}
	public void setPBEG2(String pBEG2) {
		PBEG2 = pBEG2;
	}
	public String getPEND2() {
		return PEND2;
	}
	public void setPEND2(String pEND2) {
		PEND2 = pEND2;
	}
	public String getPBEZ2() {
		return PBEZ2;
	}
	public void setPBEZ2(String pBEZ2) {
		PBEZ2 = pBEZ2;
	}
	public String getPUNB2() {
		return PUNB2;
	}
	public void setPUNB2(String pUNB2) {
		PUNB2 = pUNB2;
	}
	public String getPBEG3() {
		return PBEG3;
	}
	public void setPBEG3(String pBEG3) {
		PBEG3 = pBEG3;
	}
	public String getPEND3() {
		return PEND3;
	}
	public void setPEND3(String pEND3) {
		PEND3 = pEND3;
	}
	public String getPBEZ3() {
		return PBEZ3;
	}
	public void setPBEZ3(String pBEZ3) {
		PBEZ3 = pBEZ3;
	}
	public String getPUNB3() {
		return PUNB3;
	}
	public void setPUNB3(String pUNB3) {
		PUNB3 = pUNB3;
	}
	public String getPBEG4() {
		return PBEG4;
	}
	public void setPBEG4(String pBEG4) {
		PBEG4 = pBEG4;
	}
	public String getPEND4() {
		return PEND4;
	}
	public void setPEND4(String pEND4) {
		PEND4 = pEND4;
	}
	public String getPBEZ4() {
		return PBEZ4;
	}
	public void setPBEZ4(String pBEZ4) {
		PBEZ4 = pBEZ4;
	}
	public String getPUNB4() {
		return PUNB4;
	}
	public void setPUNB4(String pUNB4) {
		PUNB4 = pUNB4;
	}
	public String getVERSL() {
		return VERSL;
	}
	public void setVERSL(String vERSL) {
		VERSL = vERSL;
	}
	public String getAUFKZ() {
		return AUFKZ;
	}
	public void setAUFKZ(String aUFKZ) {
		AUFKZ = aUFKZ;
	}
	public String getBWGRL() {
		return BWGRL;
	}
	public void setBWGRL(String bWGRL) {
		BWGRL = bWGRL;
	}
	public String getTRFGR() {
		return TRFGR;
	}
	public void setTRFGR(String tRFGR) {
		TRFGR = tRFGR;
	}
	public String getTRFST() {
		return TRFST;
	}
	public void setTRFST(String tRFST) {
		TRFST = tRFST;
	}
	public String getPRAKN() {
		return PRAKN;
	}
	public void setPRAKN(String pRAKN) {
		PRAKN = pRAKN;
	}
	public String getPRAKZ() {
		return PRAKZ;
	}
	public void setPRAKZ(String pRAKZ) {
		PRAKZ = pRAKZ;
	}
	public String getOTYPE() {
		return OTYPE;
	}
	public void setOTYPE(String oTYPE) {
		OTYPE = oTYPE;
	}
	public String getPLANS() {
		return PLANS;
	}
	public void setPLANS(String pLANS) {
		PLANS = pLANS;
	}
	public String getEXBEL() {
		return EXBEL;
	}
	public void setEXBEL(String eXBEL) {
		EXBEL = eXBEL;
	}
	public String getHRSIF() {
		return HRSIF;
	}
	public void setHRSIF(String hRSIF) {
		HRSIF = hRSIF;
	}
	public String getWAERS() {
		return WAERS;
	}
	public void setWAERS(String wAERS) {
		WAERS = wAERS;
	}
	public String getWTART() {
		return WTART;
	}
	public void setWTART(String wTART) {
		WTART = wTART;
	}
	public String getTDLANGU() {
		return TDLANGU;
	}
	public void setTDLANGU(String tDLANGU) {
		TDLANGU = tDLANGU;
	}
	public String getTDSUBLA() {
		return TDSUBLA;
	}
	public void setTDSUBLA(String tDSUBLA) {
		TDSUBLA = tDSUBLA;
	}
	public String getTDTYPE() {
		return TDTYPE;
	}
	public void setTDTYPE(String tDTYPE) {
		TDTYPE = tDTYPE;
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
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getOTTIM() {
		return OTTIM;
	}
	public void setOTTIM(String oTTIM) {
		OTTIM = oTTIM;
	}
	public String getRTEXT() {
		return RTEXT;
	}
	public void setRTEXT(String rTEXT) {
		RTEXT = rTEXT;
	}
	public String getTTEXT() {
		return TTEXT;
	}
	public void setTTEXT(String tTEXT) {
		TTEXT = tTEXT;
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
	public String getREASON() {
		return REASON;
	}
	public void setREASON(String rEASON) {
		REASON = rEASON;
	}
	public String getZMSG() {
		return ZMSG;
	}
	public void setZMSG(String zMSG) {
		ZMSG = zMSG;
	}
	public String getCVTKEN() {
		return CVTKEN;
	}
	public void setCVTKEN(String cVTKEN) {
		CVTKEN = cVTKEN;
	}
	public String getCBEGUZ() {
		return CBEGUZ;
	}
	public void setCBEGUZ(String cBEGUZ) {
		CBEGUZ = cBEGUZ;
	}
	public String getCENDUZ() {
		return CENDUZ;
	}
	public void setCENDUZ(String cENDUZ) {
		CENDUZ = cENDUZ;
	}
	public String getCPBEG1() {
		return CPBEG1;
	}
	public void setCPBEG1(String cPBEG1) {
		CPBEG1 = cPBEG1;
	}
	public String getCPEND1() {
		return CPEND1;
	}
	public void setCPEND1(String cPEND1) {
		CPEND1 = cPEND1;
	}
	public String getCPBEG2() {
		return CPBEG2;
	}
	public void setCPBEG2(String cPBEG2) {
		CPBEG2 = cPBEG2;
	}
	public String getCPEND2() {
		return CPEND2;
	}
	public void setCPEND2(String cPEND2) {
		CPEND2 = cPEND2;
	}
	public String getCREASON() {
		return CREASON;
	}
	public void setCREASON(String cREASON) {
		CREASON = cREASON;
	}
	public String getCPERNR() {
		return CPERNR;
	}
	public void setCPERNR(String cPERNR) {
		CPERNR = cPERNR;
	}
	public String getCENAME() {
		return CENAME;
	}
	public void setCENAME(String cENAME) {
		CENAME = cENAME;
	}

}
