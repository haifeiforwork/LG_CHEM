/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 신규신청                                           */
/*   Program Name : 주택자금 신규신청                                           */
/*   Program ID   : E05HouseData                                                */
/*   Description  : 주택자금신청 데이타                                         */
/*   Note         : [관련 RFC] : ZHRW_RFC_HOUSE_LOAN_MONEY                      */
/*   Creation     : 2001-12-13  김성일                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E05House;

public class E05HouseData extends com.sns.jdf.EntityData
{
    public String MANDT        ;   // 클라이언트
    public String PERNR        ;   // 사원번호
    public String BEGDA        ;   // 신청일
    public String AINF_SEQN    ;   // 결재정보 일련번호
    public String DLART        ;   // 대출유형
    public String DATBW        ;   // 승인일
    public String DARBT        ;   // 승인된 대출금액
    public String TILBG        ;   // 상환시작
    public String TILBT        ;   // 분할상환
    public String ZZRPAY_MNTH  ;   // 서식 YYYYMM에서의 기간
    public String ZZRPAY_CONT  ;   // 상환년수
    public String ZZSECU_FLAG  ;   // 보증인여부
    public String ZZFUND_CODE  ;   // 자금용도 코드
    public String ZZHIRE_TELX  ;   // 전화번호
    public String ZZHIRE_MOBILE;   // 전화번호
    public String ZZSECU_NAME  ;   // 보증인성명
    public String ZZSECU_REGNO ;   // 주민등록번호
    public String ZZSECU_TELX  ;   // 전화번호
    public String ZZRELA_CODE  ;   // 가족특성사양
    public String REQU_MONY    ;   // 신청금액
    public String MONY_RATE    ;   // 금리
    public String ZAHLD        ;   // 지급일
    public String REFN_BEGDA   ;   // 시작일
    public String REFN_ENDDA   ;   // 종료일
    public String MNTH_INTEREST;   // 월상환이자
    public String PROOF        ;   // 증빙확인
    public String POST_DATE    ;   // POSTING일자
    public String BELNR        ;   // 회계전표번호
    public String ZPERNR       ;   // 대리신청자사번
    public String ZUNAME       ;   // 부서서무 이름
    public String AEDTM        ;   // 변경일
    public String UNAME        ;   // 사용자이름
    public String DLEND        ;   // 대출종료예상일(월상환종료)
    public String ZZSECU_NAME2  ;   // 보증인성명(2)
    public String ZZSECU_REGNO2 ;   // 주민등록번호(2)
    public String ZZSECU_TELX2  ;   // 전화번호(2)
    public String ZZRELA_CODE2  ;   // 가족특성사양(2)
    public String ZCONF  ;   // 본인 동의 여부 [CSR ID:1411838] 주택자금 신청화면 변경 요청
    public String BANK_CODE  ;   // 은행구분코드 [CSR ID:1411838]
	public String getMANDT() {
		return MANDT;
	}
	public void setMANDT(String mANDT) {
		MANDT = mANDT;
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
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getDLART() {
		return DLART;
	}
	public void setDLART(String dLART) {
		DLART = dLART;
	}
	public String getDATBW() {
		return DATBW;
	}
	public void setDATBW(String dATBW) {
		DATBW = dATBW;
	}
	public String getDARBT() {
		return DARBT;
	}
	public void setDARBT(String dARBT) {
		DARBT = dARBT;
	}
	public String getTILBG() {
		return TILBG;
	}
	public void setTILBG(String tILBG) {
		TILBG = tILBG;
	}
	public String getTILBT() {
		return TILBT;
	}
	public void setTILBT(String tILBT) {
		TILBT = tILBT;
	}
	public String getZZRPAY_MNTH() {
		return ZZRPAY_MNTH;
	}
	public void setZZRPAY_MNTH(String zZRPAY_MNTH) {
		ZZRPAY_MNTH = zZRPAY_MNTH;
	}
	public String getZZRPAY_CONT() {
		return ZZRPAY_CONT;
	}
	public void setZZRPAY_CONT(String zZRPAY_CONT) {
		ZZRPAY_CONT = zZRPAY_CONT;
	}
	public String getZZSECU_FLAG() {
		return ZZSECU_FLAG;
	}
	public void setZZSECU_FLAG(String zZSECU_FLAG) {
		ZZSECU_FLAG = zZSECU_FLAG;
	}
	public String getZZFUND_CODE() {
		return ZZFUND_CODE;
	}
	public void setZZFUND_CODE(String zZFUND_CODE) {
		ZZFUND_CODE = zZFUND_CODE;
	}
	public String getZZHIRE_TELX() {
		return ZZHIRE_TELX;
	}
	public void setZZHIRE_TELX(String zZHIRE_TELX) {
		ZZHIRE_TELX = zZHIRE_TELX;
	}
	public String getZZHIRE_MOBILE() {
		return ZZHIRE_MOBILE;
	}
	public void setZZHIRE_MOBILE(String zZHIRE_MOBILE) {
		ZZHIRE_MOBILE = zZHIRE_MOBILE;
	}
	public String getZZSECU_NAME() {
		return ZZSECU_NAME;
	}
	public void setZZSECU_NAME(String zZSECU_NAME) {
		ZZSECU_NAME = zZSECU_NAME;
	}
	public String getZZSECU_REGNO() {
		return ZZSECU_REGNO;
	}
	public void setZZSECU_REGNO(String zZSECU_REGNO) {
		ZZSECU_REGNO = zZSECU_REGNO;
	}
	public String getZZSECU_TELX() {
		return ZZSECU_TELX;
	}
	public void setZZSECU_TELX(String zZSECU_TELX) {
		ZZSECU_TELX = zZSECU_TELX;
	}
	public String getZZRELA_CODE() {
		return ZZRELA_CODE;
	}
	public void setZZRELA_CODE(String zZRELA_CODE) {
		ZZRELA_CODE = zZRELA_CODE;
	}
	public String getREQU_MONY() {
		return REQU_MONY;
	}
	public void setREQU_MONY(String rEQU_MONY) {
		REQU_MONY = rEQU_MONY;
	}
	public String getMONY_RATE() {
		return MONY_RATE;
	}
	public void setMONY_RATE(String mONY_RATE) {
		MONY_RATE = mONY_RATE;
	}
	public String getZAHLD() {
		return ZAHLD;
	}
	public void setZAHLD(String zAHLD) {
		ZAHLD = zAHLD;
	}
	public String getREFN_BEGDA() {
		return REFN_BEGDA;
	}
	public void setREFN_BEGDA(String rEFN_BEGDA) {
		REFN_BEGDA = rEFN_BEGDA;
	}
	public String getREFN_ENDDA() {
		return REFN_ENDDA;
	}
	public void setREFN_ENDDA(String rEFN_ENDDA) {
		REFN_ENDDA = rEFN_ENDDA;
	}
	public String getMNTH_INTEREST() {
		return MNTH_INTEREST;
	}
	public void setMNTH_INTEREST(String mNTH_INTEREST) {
		MNTH_INTEREST = mNTH_INTEREST;
	}
	public String getPROOF() {
		return PROOF;
	}
	public void setPROOF(String pROOF) {
		PROOF = pROOF;
	}
	public String getPOST_DATE() {
		return POST_DATE;
	}
	public void setPOST_DATE(String pOST_DATE) {
		POST_DATE = pOST_DATE;
	}
	public String getBELNR() {
		return BELNR;
	}
	public void setBELNR(String bELNR) {
		BELNR = bELNR;
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
	public String getDLEND() {
		return DLEND;
	}
	public void setDLEND(String dLEND) {
		DLEND = dLEND;
	}
	public String getZZSECU_NAME2() {
		return ZZSECU_NAME2;
	}
	public void setZZSECU_NAME2(String zZSECU_NAME2) {
		ZZSECU_NAME2 = zZSECU_NAME2;
	}
	public String getZZSECU_REGNO2() {
		return ZZSECU_REGNO2;
	}
	public void setZZSECU_REGNO2(String zZSECU_REGNO2) {
		ZZSECU_REGNO2 = zZSECU_REGNO2;
	}
	public String getZZSECU_TELX2() {
		return ZZSECU_TELX2;
	}
	public void setZZSECU_TELX2(String zZSECU_TELX2) {
		ZZSECU_TELX2 = zZSECU_TELX2;
	}
	public String getZZRELA_CODE2() {
		return ZZRELA_CODE2;
	}
	public void setZZRELA_CODE2(String zZRELA_CODE2) {
		ZZRELA_CODE2 = zZRELA_CODE2;
	}
	public String getZCONF() {
		return ZCONF;
	}
	public void setZCONF(String zCONF) {
		ZCONF = zCONF;
	}
	public String getBANK_CODE() {
		return BANK_CODE;
	}
	public void setBANK_CODE(String bANK_CODE) {
		BANK_CODE = bANK_CODE;
	}



}
