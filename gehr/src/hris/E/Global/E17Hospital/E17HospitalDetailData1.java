/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Benefit Management
/*   Program Name 	: Medical Fee
/*   Program ID   		: E17HospitalDetailData1
/*   Description  		: 의료비 신청 내용을 담는 데이터
/*   Note         		:
/*   Creation    		:
/*   Update				: 2009-05-18 jungin @v1.2 [C20090514_56175] 보험가입 여부 'ZINSU' 필드 추가.
/*	  Update             : 2013-12-19 lixinxin @v1.3 [C20131211_51591] 医疗申请画面增加字段*/

/********************************************************************************/

package hris.E.Global.E17Hospital;

public class E17HospitalDetailData1 extends com.sns.jdf.EntityData {
	public String PERNR 						;
	public String BEGDA 					;
	public String AINF_SEQN 				;
	public String PERS_GUBN 				;
	public String FAMI_CODE 				;
	public String PERS_TYPE 				;
	public String ENAME 					;
	public String DISEASE 					;
	public String LLINESS1 					;
	public String LLINESS2 					;

	public String LLINESS3 					;
	public String EXDATE 					;
	public String MTYPE 					;
	public String FEXAM 					;
	public String EXPENSE 					;
	public String WAERS 					;
	public String PLIMIT 					;
	public String PAMT 						;
	public String PAMT_C 					;
	public String PRATE 						;
	public String PAAMT 					;
	public String PDATE 					;
	public String RFDATE 					;
	public String RFREASON 				;
	public String RFAMT 					;
	public String RFAMT1 					;
	public String RFNO 						;
	public String HIRDATE 					;
	public String CERT_FLAG 				;
	public String CERT_DATE 				;
	public String CERT_BETG 				;
	public String BELNR 						;
	public String REQU_DATE 				;
	public String PAAMT_BALANCE 		;
	public String PERNR_D					;
	public String ZPERNR 					;
	public String ZUNAME 					;
	public String UNAME 					;
	public String AEDTM 					;
	public String WAERS1 					;
	public String PAMT_BALANCE 		;
	public String CERT_BETG_C 			;
	/*	2013-12-19 lixinxin @v1.3 [C20131211_51591] 医疗申请画面增加字段 添加字段 begin*/
	public String MED_LOCATION 			;
	public String MED_REASON 			;
	public String MED_ELIANAPR 			;
	public String MED_TYPE 			;
	public String MED_PRESCRIPTION 			;
	public String MED_DIAGNOSIS 			;
	/* 2013-12-19 lixinxin @v1.3 [C20131211_51591] 医疗申请画面增加字段  end*/
	public String ZINSU 						;		// 보험 가입여부		IN='In'/Out='O'
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
	public String getPERS_GUBN() {
		return PERS_GUBN;
	}
	public void setPERS_GUBN(String pERS_GUBN) {
		PERS_GUBN = pERS_GUBN;
	}
	public String getFAMI_CODE() {
		return FAMI_CODE;
	}
	public void setFAMI_CODE(String fAMI_CODE) {
		FAMI_CODE = fAMI_CODE;
	}
	public String getPERS_TYPE() {
		return PERS_TYPE;
	}
	public void setPERS_TYPE(String pERS_TYPE) {
		PERS_TYPE = pERS_TYPE;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getDISEASE() {
		return DISEASE;
	}
	public void setDISEASE(String dISEASE) {
		DISEASE = dISEASE;
	}
	public String getLLINESS1() {
		return LLINESS1;
	}
	public void setLLINESS1(String lLINESS1) {
		LLINESS1 = lLINESS1;
	}
	public String getLLINESS2() {
		return LLINESS2;
	}
	public void setLLINESS2(String lLINESS2) {
		LLINESS2 = lLINESS2;
	}
	public String getLLINESS3() {
		return LLINESS3;
	}
	public void setLLINESS3(String lLINESS3) {
		LLINESS3 = lLINESS3;
	}
	public String getEXDATE() {
		return EXDATE;
	}
	public void setEXDATE(String eXDATE) {
		EXDATE = eXDATE;
	}
	public String getMTYPE() {
		return MTYPE;
	}
	public void setMTYPE(String mTYPE) {
		MTYPE = mTYPE;
	}
	public String getFEXAM() {
		return FEXAM;
	}
	public void setFEXAM(String fEXAM) {
		FEXAM = fEXAM;
	}
	public String getEXPENSE() {
		return EXPENSE;
	}
	public void setEXPENSE(String eXPENSE) {
		EXPENSE = eXPENSE;
	}
	public String getWAERS() {
		return WAERS;
	}
	public void setWAERS(String wAERS) {
		WAERS = wAERS;
	}
	public String getPLIMIT() {
		return PLIMIT;
	}
	public void setPLIMIT(String pLIMIT) {
		PLIMIT = pLIMIT;
	}
	public String getPAMT() {
		return PAMT;
	}
	public void setPAMT(String pAMT) {
		PAMT = pAMT;
	}
	public String getPAMT_C() {
		return PAMT_C;
	}
	public void setPAMT_C(String pAMT_C) {
		PAMT_C = pAMT_C;
	}
	public String getPRATE() {
		return PRATE;
	}
	public void setPRATE(String pRATE) {
		PRATE = pRATE;
	}
	public String getPAAMT() {
		return PAAMT;
	}
	public void setPAAMT(String pAAMT) {
		PAAMT = pAAMT;
	}
	public String getPDATE() {
		return PDATE;
	}
	public void setPDATE(String pDATE) {
		PDATE = pDATE;
	}
	public String getRFDATE() {
		return RFDATE;
	}
	public void setRFDATE(String rFDATE) {
		RFDATE = rFDATE;
	}
	public String getRFREASON() {
		return RFREASON;
	}
	public void setRFREASON(String rFREASON) {
		RFREASON = rFREASON;
	}
	public String getRFAMT() {
		return RFAMT;
	}
	public void setRFAMT(String rFAMT) {
		RFAMT = rFAMT;
	}
	public String getRFAMT1() {
		return RFAMT1;
	}
	public void setRFAMT1(String rFAMT1) {
		RFAMT1 = rFAMT1;
	}
	public String getRFNO() {
		return RFNO;
	}
	public void setRFNO(String rFNO) {
		RFNO = rFNO;
	}
	public String getHIRDATE() {
		return HIRDATE;
	}
	public void setHIRDATE(String hIRDATE) {
		HIRDATE = hIRDATE;
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
	public String getREQU_DATE() {
		return REQU_DATE;
	}
	public void setREQU_DATE(String rEQU_DATE) {
		REQU_DATE = rEQU_DATE;
	}
	public String getPAAMT_BALANCE() {
		return PAAMT_BALANCE;
	}
	public void setPAAMT_BALANCE(String pAAMT_BALANCE) {
		PAAMT_BALANCE = pAAMT_BALANCE;
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
	public String getWAERS1() {
		return WAERS1;
	}
	public void setWAERS1(String wAERS1) {
		WAERS1 = wAERS1;
	}
	public String getPAMT_BALANCE() {
		return PAMT_BALANCE;
	}
	public void setPAMT_BALANCE(String pAMT_BALANCE) {
		PAMT_BALANCE = pAMT_BALANCE;
	}
	public String getCERT_BETG_C() {
		return CERT_BETG_C;
	}
	public void setCERT_BETG_C(String cERT_BETG_C) {
		CERT_BETG_C = cERT_BETG_C;
	}
	public String getMED_LOCATION() {
		return MED_LOCATION;
	}
	public void setMED_LOCATION(String mED_LOCATION) {
		MED_LOCATION = mED_LOCATION;
	}
	public String getMED_REASON() {
		return MED_REASON;
	}
	public void setMED_REASON(String mED_REASON) {
		MED_REASON = mED_REASON;
	}
	public String getMED_ELIANAPR() {
		return MED_ELIANAPR;
	}
	public void setMED_ELIANAPR(String mED_ELIANAPR) {
		MED_ELIANAPR = mED_ELIANAPR;
	}
	public String getMED_TYPE() {
		return MED_TYPE;
	}
	public void setMED_TYPE(String mED_TYPE) {
		MED_TYPE = mED_TYPE;
	}
	public String getMED_PRESCRIPTION() {
		return MED_PRESCRIPTION;
	}
	public void setMED_PRESCRIPTION(String mED_PRESCRIPTION) {
		MED_PRESCRIPTION = mED_PRESCRIPTION;
	}
	public String getMED_DIAGNOSIS() {
		return MED_DIAGNOSIS;
	}
	public void setMED_DIAGNOSIS(String mED_DIAGNOSIS) {
		MED_DIAGNOSIS = mED_DIAGNOSIS;
	}
	public String getZINSU() {
		return ZINSU;
	}
	public void setZINSU(String zINSU) {
		ZINSU = zINSU;
	}




}
