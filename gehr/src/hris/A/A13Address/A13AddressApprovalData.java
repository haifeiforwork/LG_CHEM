package hris.A.A13Address;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-09-13.
 */
public class A13AddressApprovalData extends EntityData {

    public String 	PERNR	;//	NUMC	 8 	Personnel number	대상자 사번
    public String 	BEGDA	;//	 DATS 	 8 	Request Date
    public String 	AINF_SEQN	;//	CHAR	 10 	descision number
    public String 	ANSSA	;//	CHAR	 4 	Address Record Type
    public String 	NAME2	;//	CHAR	 40 	Contact Name
    public String 	STRAS	;//	CHAR	 60 	Street and House Number
    public String 	ORT01	;//	CHAR	 40 	City
    public String 	ORT02	;//	CHAR	 40 	District
    public String 	PSTLZ	;//	CHAR	 10 	Postal Code
    public String 	LAND1	;//	CHAR	 3 	Country Key
    public String 	TELNR	;//	CHAR	 14 	Telephone Number
    public String 	ENTKM	;//	DEC	 3 	Distance in Kilometers
    public String 	WKWNG	;//	CHAR	 1 	Company Housing
    public String 	BUSRT	;//	CHAR	 3 	Bus Route
    public String 	LOCAT	;//	CHAR	 40 	2nd Address Line
    public String 	ADR03	;//	CHAR	 40 	Street 2
    public String 	ADR04	;//	CHAR	 40 	Street 3
    public String 	STATE	;//	CHAR	 3 	Region (State, Province, County)
    public String 	HSNMR	;//	CHAR	 10 	House Number
    public String 	POSTA	;//	CHAR	 10 	Identification of an apartment in a building
    public String 	BLDNG	;//	CHAR	 10 	Building (number or code)
    public String 	FLOOR	;//	CHAR	 10 	Floor in building
    public String 	STRDS	;//	CHAR	 2 	Street Abbreviation
    public String 	ENTK2	;//	DEC	 3 	Distance in Kilometers
    public String 	COM01	;//	CHAR	 4 	Communication Type
    public String 	NUM01	;//	CHAR	 20 	Communication Number
    public String 	COM02	;//	CHAR	 4 	Communication Type
    public String 	NUM02	;//	CHAR	 20 	Communication Number
    public String 	COM03	;//	CHAR	 4 	Communication Type
    public String 	NUM03	;//	CHAR	 20 	Communication Number
    public String 	COM04	;//	CHAR	 4 	Communication Type
    public String 	NUM04	;//	CHAR	 20 	Communication Number
    public String 	COM05	;//	CHAR	 4 	Communication Type
    public String 	NUM05	;//	CHAR	 20 	Communication Number
    public String 	COM06	;//	CHAR	 4 	Communication Type
    public String 	NUM06	;//	CHAR	 20 	Communication Number
    public String 	INDRL	;//	CHAR	 2 	Indicator for relationship (specification code)
    public String 	COUNC	;//	CHAR	 3 	County Code
    public String 	RCTVC	;//	CHAR	 6 	Municipal city code
    public String 	OR2KK	;//	CHAR	 40 	Second address line (Katakana)
    public String 	CONKK	;//	CHAR	 40 	Contact Person (Katakana) (Japan)
    public String 	OR1KK	;//	CHAR	 40 	First address line (Katakana)
    public String 	RAILW	;//	NUMC	 1 	Social Subscription Railway
    public String 	ZZPITFLD	;//	CHAR	 1 	Address for PIT documents
    public String 	ZZBANKFD	;//	CHAR	 1 	Address for Bank documents
    public String 	ZZOTHRFD	;//	CHAR	 1 	Address for others documents
    public String 	APPR_STAT	;//	CHAR	 1 	Confirm Status
    public String 	PERNR_D	;//	CHAR	 10 	Personnel Number
    public String 	ZUNAME	;//	CHAR	 20 	Orgeh Asistance
    public String 	ZPERNR	;//	NUMC	 8 	Agency Pernr
    public String 	AEDTM	;//	DATS	 8 	Changed on
    public String 	UNAME	;//	CHAR	 12 	User Name

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getANSSA() {
        return ANSSA;
    }

    public void setANSSA(String ANSSA) {
        this.ANSSA = ANSSA;
    }

    public String getNAME2() {
        return NAME2;
    }

    public void setNAME2(String NAME2) {
        this.NAME2 = NAME2;
    }

    public String getSTRAS() {
        return STRAS;
    }

    public void setSTRAS(String STRAS) {
        this.STRAS = STRAS;
    }

    public String getORT01() {
        return ORT01;
    }

    public void setORT01(String ORT01) {
        this.ORT01 = ORT01;
    }

    public String getORT02() {
        return ORT02;
    }

    public void setORT02(String ORT02) {
        this.ORT02 = ORT02;
    }

    public String getPSTLZ() {
        return PSTLZ;
    }

    public void setPSTLZ(String PSTLZ) {
        this.PSTLZ = PSTLZ;
    }

    public String getLAND1() {
        return LAND1;
    }

    public void setLAND1(String LAND1) {
        this.LAND1 = LAND1;
    }

    public String getTELNR() {
        return TELNR;
    }

    public void setTELNR(String TELNR) {
        this.TELNR = TELNR;
    }

    public String getENTKM() {
        return ENTKM;
    }

    public void setENTKM(String ENTKM) {
        this.ENTKM = ENTKM;
    }

    public String getWKWNG() {
        return WKWNG;
    }

    public void setWKWNG(String WKWNG) {
        this.WKWNG = WKWNG;
    }

    public String getBUSRT() {
        return BUSRT;
    }

    public void setBUSRT(String BUSRT) {
        this.BUSRT = BUSRT;
    }

    public String getLOCAT() {
        return LOCAT;
    }

    public void setLOCAT(String LOCAT) {
        this.LOCAT = LOCAT;
    }

    public String getADR03() {
        return ADR03;
    }

    public void setADR03(String ADR03) {
        this.ADR03 = ADR03;
    }

    public String getADR04() {
        return ADR04;
    }

    public void setADR04(String ADR04) {
        this.ADR04 = ADR04;
    }

    public String getSTATE() {
        return STATE;
    }

    public void setSTATE(String STATE) {
        this.STATE = STATE;
    }

    public String getHSNMR() {
        return HSNMR;
    }

    public void setHSNMR(String HSNMR) {
        this.HSNMR = HSNMR;
    }

    public String getPOSTA() {
        return POSTA;
    }

    public void setPOSTA(String POSTA) {
        this.POSTA = POSTA;
    }

    public String getBLDNG() {
        return BLDNG;
    }

    public void setBLDNG(String BLDNG) {
        this.BLDNG = BLDNG;
    }

    public String getFLOOR() {
        return FLOOR;
    }

    public void setFLOOR(String FLOOR) {
        this.FLOOR = FLOOR;
    }

    public String getSTRDS() {
        return STRDS;
    }

    public void setSTRDS(String STRDS) {
        this.STRDS = STRDS;
    }

    public String getENTK2() {
        return ENTK2;
    }

    public void setENTK2(String ENTK2) {
        this.ENTK2 = ENTK2;
    }

    public String getCOM01() {
        return COM01;
    }

    public void setCOM01(String COM01) {
        this.COM01 = COM01;
    }

    public String getNUM01() {
        return NUM01;
    }

    public void setNUM01(String NUM01) {
        this.NUM01 = NUM01;
    }

    public String getCOM02() {
        return COM02;
    }

    public void setCOM02(String COM02) {
        this.COM02 = COM02;
    }

    public String getNUM02() {
        return NUM02;
    }

    public void setNUM02(String NUM02) {
        this.NUM02 = NUM02;
    }

    public String getCOM03() {
        return COM03;
    }

    public void setCOM03(String COM03) {
        this.COM03 = COM03;
    }

    public String getNUM03() {
        return NUM03;
    }

    public void setNUM03(String NUM03) {
        this.NUM03 = NUM03;
    }

    public String getCOM04() {
        return COM04;
    }

    public void setCOM04(String COM04) {
        this.COM04 = COM04;
    }

    public String getNUM04() {
        return NUM04;
    }

    public void setNUM04(String NUM04) {
        this.NUM04 = NUM04;
    }

    public String getCOM05() {
        return COM05;
    }

    public void setCOM05(String COM05) {
        this.COM05 = COM05;
    }

    public String getNUM05() {
        return NUM05;
    }

    public void setNUM05(String NUM05) {
        this.NUM05 = NUM05;
    }

    public String getCOM06() {
        return COM06;
    }

    public void setCOM06(String COM06) {
        this.COM06 = COM06;
    }

    public String getNUM06() {
        return NUM06;
    }

    public void setNUM06(String NUM06) {
        this.NUM06 = NUM06;
    }

    public String getINDRL() {
        return INDRL;
    }

    public void setINDRL(String INDRL) {
        this.INDRL = INDRL;
    }

    public String getCOUNC() {
        return COUNC;
    }

    public void setCOUNC(String COUNC) {
        this.COUNC = COUNC;
    }

    public String getRCTVC() {
        return RCTVC;
    }

    public void setRCTVC(String RCTVC) {
        this.RCTVC = RCTVC;
    }

    public String getOR2KK() {
        return OR2KK;
    }

    public void setOR2KK(String OR2KK) {
        this.OR2KK = OR2KK;
    }

    public String getCONKK() {
        return CONKK;
    }

    public void setCONKK(String CONKK) {
        this.CONKK = CONKK;
    }

    public String getOR1KK() {
        return OR1KK;
    }

    public void setOR1KK(String OR1KK) {
        this.OR1KK = OR1KK;
    }

    public String getRAILW() {
        return RAILW;
    }

    public void setRAILW(String RAILW) {
        this.RAILW = RAILW;
    }

    public String getZZPITFLD() {
        return ZZPITFLD;
    }

    public void setZZPITFLD(String ZZPITFLD) {
        this.ZZPITFLD = ZZPITFLD;
    }

    public String getZZBANKFD() {
        return ZZBANKFD;
    }

    public void setZZBANKFD(String ZZBANKFD) {
        this.ZZBANKFD = ZZBANKFD;
    }

    public String getZZOTHRFD() {
        return ZZOTHRFD;
    }

    public void setZZOTHRFD(String ZZOTHRFD) {
        this.ZZOTHRFD = ZZOTHRFD;
    }

    public String getAPPR_STAT() {
        return APPR_STAT;
    }

    public void setAPPR_STAT(String APPR_STAT) {
        this.APPR_STAT = APPR_STAT;
    }

    public String getPERNR_D() {
        return PERNR_D;
    }

    public void setPERNR_D(String PERNR_D) {
        this.PERNR_D = PERNR_D;
    }

    public String getZUNAME() {
        return ZUNAME;
    }

    public void setZUNAME(String ZUNAME) {
        this.ZUNAME = ZUNAME;
    }

    public String getZPERNR() {
        return ZPERNR;
    }

    public void setZPERNR(String ZPERNR) {
        this.ZPERNR = ZPERNR;
    }

    public String getAEDTM() {
        return AEDTM;
    }

    public void setAEDTM(String AEDTM) {
        this.AEDTM = AEDTM;
    }

    public String getUNAME() {
        return UNAME;
    }

    public void setUNAME(String UNAME) {
        this.UNAME = UNAME;
    }
}
