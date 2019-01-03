package hris.D.D09ContractExtension;

/**
 *	 D09ExtensionData.java
 *  Contract Extension 정보를 담아오는 데이터
 *  [관련 RFC] : ZHRE_RFC_CONTRACT_EXTENSION [USA]
 * 
 * @author jungin   
 * @version 1.0, 2010/10/13
 */

public class D09ExtensionData extends com.sns.jdf.EntityData {

    public String	STLTX	;//	CHAR	 25 	Job Title
    public String	CTTXT	;//	 CHAR 	 20 	Text for contract type (Contract Elements infotype)
    public String	MANDT	;//	CLNT	 3 	Client
    public String	PERNR	;//	NUMC	 8 	Personnel number
    public String	BEGDA	;//	DATS	 8 	Request Date
    public String	AINF_SEQN	;//	CHAR	 10 	descision number
    public String	STELL	;//	NUMC	 8 	Job
    public String	CTTYP	;//	CHAR	 2 	Contract Type
    public String	CBEGDA	;//	DATS	 8 	Start Date
    public String	CTEDT	;//	DATS	 8 	Contract End Date
    public String	OBJID	;//	NUMC	 8 	Object ID
    public String	BILRTE	;//	CURR	 15,2 	Bill Rate
    public String	BWAERS	;//	CUKY	 5 	Currency Key
    public String	OTBRTE	;//	CURR	 15,2 	OT Bill Rate
    public String	OWAERS	;//	CUKY	 5 	Currency Key
    public String	EMPRTE	;//	CURR	 15,2 	Emp.Rate
    public String	EWAERS	;//	CUKY	 5 	Currency Key
    public String	EXARTE	;//	CURR	 15,2 	Extra-Rate
    public String	XWAERS	;//	CUKY	 5 	Currency Key
    public String	TABNR	;//	CHAR	 32 	Reference Number to Table Part
    public String	CERT_FLAG	;//	CHAR	 1 	Documentary Evidence
    public String	CERT_DATE	;//	DATS	 8 	Submit Date
    public String	PAYTYPE	;//	CHAR	 1 	Pay Type
    public String	TLINE	;//	CHAR	 255 	Text, 255 Characters
    public String	APPR_STAT	;//	CHAR	 1 	Confirm Status
    public String	PERNR_D	;//	CHAR	 10 	Personnel Number
    public String	ZUNAME	;//	CHAR	 20 	Orgeh Asistance
    public String	ZPERNR	;//	NUMC	 8 	Agency Pernr
    public String	AEDTM	;//	DATS	 8 	Changed on
    public String	UNAME	;//	CHAR	 12 	User Name
    public String	APPL_TYPE	;//	CHAR	 2 	Work Flow Type
    public String	STEXT	;//	CHAR	 40 	Object Name
    public String	CTLTD	;//	CHAR	 1 	Indicator for fixed-term contract
    public String	PTTXT	;//	CHAR	 20 	Pay Type Text
    public String	PERIOD	;//	CHAR	 40 	Period


    public String getSTLTX() {
        return STLTX;
    }

    public void setSTLTX(String STLTX) {
        this.STLTX = STLTX;
    }

    public String getCTTXT() {
        return CTTXT;
    }

    public void setCTTXT(String CTTXT) {
        this.CTTXT = CTTXT;
    }

    public String getMANDT() {
        return MANDT;
    }

    public void setMANDT(String MANDT) {
        this.MANDT = MANDT;
    }

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

    public String getSTELL() {
        return STELL;
    }

    public void setSTELL(String STELL) {
        this.STELL = STELL;
    }

    public String getCTTYP() {
        return CTTYP;
    }

    public void setCTTYP(String CTTYP) {
        this.CTTYP = CTTYP;
    }

    public String getCBEGDA() {
        return CBEGDA;
    }

    public void setCBEGDA(String CBEGDA) {
        this.CBEGDA = CBEGDA;
    }

    public String getCTEDT() {
        return CTEDT;
    }

    public void setCTEDT(String CTEDT) {
        this.CTEDT = CTEDT;
    }

    public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }

    public String getBILRTE() {
        return BILRTE;
    }

    public void setBILRTE(String BILRTE) {
        this.BILRTE = BILRTE;
    }

    public String getBWAERS() {
        return BWAERS;
    }

    public void setBWAERS(String BWAERS) {
        this.BWAERS = BWAERS;
    }

    public String getOTBRTE() {
        return OTBRTE;
    }

    public void setOTBRTE(String OTBRTE) {
        this.OTBRTE = OTBRTE;
    }

    public String getOWAERS() {
        return OWAERS;
    }

    public void setOWAERS(String OWAERS) {
        this.OWAERS = OWAERS;
    }

    public String getEMPRTE() {
        return EMPRTE;
    }

    public void setEMPRTE(String EMPRTE) {
        this.EMPRTE = EMPRTE;
    }

    public String getEWAERS() {
        return EWAERS;
    }

    public void setEWAERS(String EWAERS) {
        this.EWAERS = EWAERS;
    }

    public String getEXARTE() {
        return EXARTE;
    }

    public void setEXARTE(String EXARTE) {
        this.EXARTE = EXARTE;
    }

    public String getXWAERS() {
        return XWAERS;
    }

    public void setXWAERS(String XWAERS) {
        this.XWAERS = XWAERS;
    }

    public String getTABNR() {
        return TABNR;
    }

    public void setTABNR(String TABNR) {
        this.TABNR = TABNR;
    }

    public String getCERT_FLAG() {
        return CERT_FLAG;
    }

    public void setCERT_FLAG(String CERT_FLAG) {
        this.CERT_FLAG = CERT_FLAG;
    }

    public String getCERT_DATE() {
        return CERT_DATE;
    }

    public void setCERT_DATE(String CERT_DATE) {
        this.CERT_DATE = CERT_DATE;
    }

    public String getPAYTYPE() {
        return PAYTYPE;
    }

    public void setPAYTYPE(String PAYTYPE) {
        this.PAYTYPE = PAYTYPE;
    }

    public String getTLINE() {
        return TLINE;
    }

    public void setTLINE(String TLINE) {
        this.TLINE = TLINE;
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

    public String getAPPL_TYPE() {
        return APPL_TYPE;
    }

    public void setAPPL_TYPE(String APPL_TYPE) {
        this.APPL_TYPE = APPL_TYPE;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getCTLTD() {
        return CTLTD;
    }

    public void setCTLTD(String CTLTD) {
        this.CTLTD = CTLTD;
    }

    public String getPTTXT() {
        return PTTXT;
    }

    public void setPTTXT(String PTTXT) {
        this.PTTXT = PTTXT;
    }

    public String getPERIOD() {
        return PERIOD;
    }

    public void setPERIOD(String PERIOD) {
        this.PERIOD = PERIOD;
    }
}
