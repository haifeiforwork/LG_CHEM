package hris.E.E19Congra;

/**
 * E19CongcondData.java
 * 경조금 지급 기준 데이타 & 경조대상자관계 데이타 & 경조금조회 & 경조금 지급 기준 추가 데이타 & 경조금신청
 *   [관련 RFC] : ZHRW_RFC_P_CONGCOND_RATE[1], ZHRW_RFC_P_CONGCOND_RELA[2], ZHRW_RFC_CONGCOND_DISPLAY[3],
 *                ZHRW_RFC_CONGCOND_COMMWAGE[4], ZHRW_RFC_CONGCOND_REQUEST[5], ZHRA_RFC_GET_LIFNR[6]
 * @author 김성일
 * @version 1.0, 2001/12/18
 */
public class E19CongcondGlobalData extends com.sns.jdf.EntityData
{
	public String PERNR;
	public String BEGDA;
	public String AINF_SEQN;
	public String CELTY;
	public String FAMY_CODE;
	public String FAMSA;
	public String ENAME;
	public String CELDT;
	public String SUBTD;
	public String SYEAR;
	public String REMRA;
	public String BASE_FLAG;
	public String BASE_AMNT;
	public String PAYM_RATE;
	public String PAYM_AMNT;
	public String PAYM_DATE;
	public String CLAC_AMNT;
	public String FIXD_PAY;
	public String ABSN_DATE;
	public String AWART;
	public String PAYM_BETG;
	public String ABSN_DAYS;
	public String REFU_DATE;
	public String REFU_RASN;
	public String REFU_AMNT;
	public String REFU_ACNO;
	public String CURRENCY;
	public String CERT_FLAG;
	public String CERT_DATE;
	public String CERT_BETG;
	public String BELNR;
	public String PERNR_D;
	public String ZPERNR;
	public String ZUNAME;
	public String PAYM_RAT;
	public String SMNTH;
	public String UNAME;
	public String AEDTM;
	public String OBJPS;

	//경조금 신청시 최대 지급한도.	2008-01-21
	public String MAXM_PAY;		//최대 지급한도.

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

	public String getCELTY() {
		return CELTY;
	}

	public void setCELTY(String cELTY) {
		CELTY = cELTY;
	}

	public String getFAMY_CODE() {
		return FAMY_CODE;
	}

	public void setFAMY_CODE(String fAMY_CODE) {
		FAMY_CODE = fAMY_CODE;
	}

	public String getFAMSA() {
		return FAMSA;
	}

	public void setFAMSA(String fAMSA) {
		FAMSA = fAMSA;
	}

	public String getENAME() {
		return ENAME;
	}

	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}

	public String getCELDT() {
		return CELDT;
	}

	public void setCELDT(String cELDT) {
		CELDT = cELDT;
	}

	public String getSUBTD() {
		return SUBTD;
	}

	public void setSUBTD(String sUBTD) {
		SUBTD = sUBTD;
	}

	public String getSYEAR() {
		return SYEAR;
	}

	public void setSYEAR(String sYEAR) {
		SYEAR = sYEAR;
	}

	public String getREMRA() {
		return REMRA;
	}

	public void setREMRA(String rEMRA) {
		REMRA = rEMRA;
	}

	public String getBASE_FLAG() {
		return BASE_FLAG;
	}

	public void setBASE_FLAG(String bASE_FLAG) {
		BASE_FLAG = bASE_FLAG;
	}

	public String getBASE_AMNT() {
		return BASE_AMNT;
	}

	public void setBASE_AMNT(String bASE_AMNT) {
		BASE_AMNT = bASE_AMNT;
	}

	public String getPAYM_RATE() {
		return PAYM_RATE;
	}

	public void setPAYM_RATE(String pAYM_RATE) {
		PAYM_RATE = pAYM_RATE;
	}

	public String getPAYM_AMNT() {
		return PAYM_AMNT;
	}

	public void setPAYM_AMNT(String pAYM_AMNT) {
		PAYM_AMNT = pAYM_AMNT;
	}

	public String getPAYM_DATE() {
		return PAYM_DATE;
	}

	public void setPAYM_DATE(String pAYM_DATE) {
		PAYM_DATE = pAYM_DATE;
	}

	public String getCLAC_AMNT() {
		return CLAC_AMNT;
	}

	public void setCLAC_AMNT(String cLAC_AMNT) {
		CLAC_AMNT = cLAC_AMNT;
	}

	public String getFIXD_PAY() {
		return FIXD_PAY;
	}

	public void setFIXD_PAY(String fIXD_PAY) {
		FIXD_PAY = fIXD_PAY;
	}

	public String getABSN_DATE() {
		return ABSN_DATE;
	}

	public void setABSN_DATE(String aBSN_DATE) {
		ABSN_DATE = aBSN_DATE;
	}

	public String getAWART() {
		return AWART;
	}

	public void setAWART(String aWART) {
		AWART = aWART;
	}

	public String getPAYM_BETG() {
		return PAYM_BETG;
	}

	public void setPAYM_BETG(String pAYM_BETG) {
		PAYM_BETG = pAYM_BETG;
	}

	public String getABSN_DAYS() {
		return ABSN_DAYS;
	}

	public void setABSN_DAYS(String aBSN_DAYS) {
		ABSN_DAYS = aBSN_DAYS;
	}

	public String getREFU_DATE() {
		return REFU_DATE;
	}

	public void setREFU_DATE(String rEFU_DATE) {
		REFU_DATE = rEFU_DATE;
	}

	public String getREFU_RASN() {
		return REFU_RASN;
	}

	public void setREFU_RASN(String rEFU_RASN) {
		REFU_RASN = rEFU_RASN;
	}

	public String getREFU_AMNT() {
		return REFU_AMNT;
	}

	public void setREFU_AMNT(String rEFU_AMNT) {
		REFU_AMNT = rEFU_AMNT;
	}

	public String getREFU_ACNO() {
		return REFU_ACNO;
	}

	public void setREFU_ACNO(String rEFU_ACNO) {
		REFU_ACNO = rEFU_ACNO;
	}

	public String getCURRENCY() {
		return CURRENCY;
	}

	public void setCURRENCY(String cURRENCY) {
		CURRENCY = cURRENCY;
	}

	public String getCERT_FLAG() {
		return CERT_FLAG;
	}

	public void setCERT_FLAG(String cERT_FLAG) {
		CERT_FLAG = cERT_FLAG;
	}

	public String getCERT_DATE() {
		return CERT_DATE;
	}

	public void setCERT_DATE(String cERT_DATE) {
		CERT_DATE = cERT_DATE;
	}

	public String getCERT_BETG() {
		return CERT_BETG;
	}

	public void setCERT_BETG(String cERT_BETG) {
		CERT_BETG = cERT_BETG;
	}

	public String getBELNR() {
		return BELNR;
	}

	public void setBELNR(String bELNR) {
		BELNR = bELNR;
	}

	public String getPERNR_D() {
		return PERNR_D;
	}

	public void setPERNR_D(String pERNR_D) {
		PERNR_D = pERNR_D;
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

	public String getPAYM_RAT() {
		return PAYM_RAT;
	}

	public void setPAYM_RAT(String pAYM_RAT) {
		PAYM_RAT = pAYM_RAT;
	}

	public String getSMNTH() {
		return SMNTH;
	}

	public void setSMNTH(String sMNTH) {
		SMNTH = sMNTH;
	}

	public String getUNAME() {
		return UNAME;
	}

	public void setUNAME(String uNAME) {
		UNAME = uNAME;
	}

	public String getAEDTM() {
		return AEDTM;
	}

	public void setAEDTM(String aEDTM) {
		AEDTM = aEDTM;
	}

	public String getOBJPS() {
		return OBJPS;
	}

	public void setOBJPS(String oBJPS) {
		OBJPS = oBJPS;
	}

	public String getMAXM_PAY() {
		return MAXM_PAY;
	}

	public void setMAXM_PAY(String mAXM_PAY) {
		MAXM_PAY = mAXM_PAY;
	}


}