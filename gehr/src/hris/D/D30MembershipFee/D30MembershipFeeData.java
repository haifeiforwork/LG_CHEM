package hris.D.D30MembershipFee;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-10-11.
 */
public class D30MembershipFeeData extends EntityData{

    public String	YYYYMM	;//	O	NUMC	6	Month
    public String	ENAME	;//		CHAR	40	Name
    public String	MGTXT	;//		CHAR	25	Member type Text
    public String	ZMSG	;//	O	CHAR	255	Message
    public String	PERNR	;//	O	NUMC	8	Personnel number
    public String	BEGDA	;//		DATS	8	Start Date
    public String	AINF_SEQN	;//	O	CHAR	10	descision number
    public String	ZGUBUN	;//		CHAR	1	Payment/Deduction/Member Fee type
    public String	SEQNR	;//		NUMC	3	Sequence
    public String	PDATE	;//	O	DATS	8	Pay date for awards
    public String	INFTY	;//	O	CHAR	4	Infotype
    public String	LGART	;//	O	CHAR	4	Wage Type
    public String	MGART	;//	O	CHAR	4	Member type
    public String	BETRG	;//	O	CURR	9	Amount
    public String	ANZHL	;//		DEC	7	Number
    public String	WAERS	;//	O	CUKY	5	Currency Key
    public String	ZQUIT	;//	O	CHAR	1	Quit	X':Quit, '':Join
    public String	ZBIGO	;//		CHAR	50	comments
    public String	APPR_STAT	;//		CHAR	1	Confirm Status
    public String	ZPERNR	;//		NUMC	8	Personnel number
    public String	ZUNAME	;//		CHAR	20	Orgeh Asistance
    public String	AEDTM	;//		DATS	8	Changed on
    public String	UNAME	;//		CHAR	12	User Name

    public String RETIRE_YN;

    public String ZMONTH;

    public String getRETIRE_YN() {
        return RETIRE_YN;
    }

    public void setRETIRE_YN(String RETIRE_YN) {
        this.RETIRE_YN = RETIRE_YN;
    }

    public String getZMONTH() {
        return ZMONTH;
    }

    public void setZMONTH(String ZMONTH) {
        this.ZMONTH = ZMONTH;
    }

    public String getYYYYMM() {
        return YYYYMM;
    }

    public void setYYYYMM(String YYYYMM) {
        this.YYYYMM = YYYYMM;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getMGTXT() {
        return MGTXT;
    }

    public void setMGTXT(String MGTXT) {
        this.MGTXT = MGTXT;
    }

    public String getZMSG() {
        return ZMSG;
    }

    public void setZMSG(String ZMSG) {
        this.ZMSG = ZMSG;
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

    public String getZGUBUN() {
        return ZGUBUN;
    }

    public void setZGUBUN(String ZGUBUN) {
        this.ZGUBUN = ZGUBUN;
    }

    public String getSEQNR() {
        return SEQNR;
    }

    public void setSEQNR(String SEQNR) {
        this.SEQNR = SEQNR;
    }

    public String getPDATE() {
        return PDATE;
    }

    public void setPDATE(String PDATE) {
        this.PDATE = PDATE;
    }

    public String getINFTY() {
        return INFTY;
    }

    public void setINFTY(String INFTY) {
        this.INFTY = INFTY;
    }

    public String getLGART() {
        return LGART;
    }

    public void setLGART(String LGART) {
        this.LGART = LGART;
    }

    public String getMGART() {
        return MGART;
    }

    public void setMGART(String MGART) {
        this.MGART = MGART;
    }

    public String getBETRG() {
        return BETRG;
    }

    public void setBETRG(String BETRG) {
        this.BETRG = BETRG;
    }

    public String getANZHL() {
        return ANZHL;
    }

    public void setANZHL(String ANZHL) {
        this.ANZHL = ANZHL;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }

    public String getZQUIT() {
        return ZQUIT;
    }

    public void setZQUIT(String ZQUIT) {
        this.ZQUIT = ZQUIT;
    }

    public String getZBIGO() {
        return ZBIGO;
    }

    public void setZBIGO(String ZBIGO) {
        this.ZBIGO = ZBIGO;
    }

    public String getAPPR_STAT() {
        return APPR_STAT;
    }

    public void setAPPR_STAT(String APPR_STAT) {
        this.APPR_STAT = APPR_STAT;
    }

    public String getZPERNR() {
        return ZPERNR;
    }

    public void setZPERNR(String ZPERNR) {
        this.ZPERNR = ZPERNR;
    }

    public String getZUNAME() {
        return ZUNAME;
    }

    public void setZUNAME(String ZUNAME) {
        this.ZUNAME = ZUNAME;
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
