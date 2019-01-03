/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ� �űԽ�û                                           */
/*   Program Name : �����ڱ� �űԽ�û                                           */
/*   Program ID   : E05HouseData                                                */
/*   Description  : �����ڱݽ�û ����Ÿ                                         */
/*   Note         : [���� RFC] : ZHRW_RFC_HOUSE_LOAN_MONEY                      */
/*   Creation     : 2001-12-13  �輺��                                          */
/*   Update       : 2005-03-04  ������                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E05House;

public class E05HouseData extends com.sns.jdf.EntityData
{
    public String MANDT        ;   // Ŭ���̾�Ʈ
    public String PERNR        ;   // �����ȣ
    public String BEGDA        ;   // ��û��
    public String AINF_SEQN    ;   // �������� �Ϸù�ȣ
    public String DLART        ;   // ��������
    public String DATBW        ;   // ������
    public String DARBT        ;   // ���ε� ����ݾ�
    public String TILBG        ;   // ��ȯ����
    public String TILBT        ;   // ���һ�ȯ
    public String ZZRPAY_MNTH  ;   // ���� YYYYMM������ �Ⱓ
    public String ZZRPAY_CONT  ;   // ��ȯ���
    public String ZZSECU_FLAG  ;   // �����ο���
    public String ZZFUND_CODE  ;   // �ڱݿ뵵 �ڵ�
    public String ZZHIRE_TELX  ;   // ��ȭ��ȣ
    public String ZZHIRE_MOBILE;   // ��ȭ��ȣ
    public String ZZSECU_NAME  ;   // �����μ���
    public String ZZSECU_REGNO ;   // �ֹε�Ϲ�ȣ
    public String ZZSECU_TELX  ;   // ��ȭ��ȣ
    public String ZZRELA_CODE  ;   // ����Ư�����
    public String REQU_MONY    ;   // ��û�ݾ�
    public String MONY_RATE    ;   // �ݸ�
    public String ZAHLD        ;   // ������
    public String REFN_BEGDA   ;   // ������
    public String REFN_ENDDA   ;   // ������
    public String MNTH_INTEREST;   // ����ȯ����
    public String PROOF        ;   // ����Ȯ��
    public String POST_DATE    ;   // POSTING����
    public String BELNR        ;   // ȸ����ǥ��ȣ
    public String ZPERNR       ;   // �븮��û�ڻ��
    public String ZUNAME       ;   // �μ����� �̸�
    public String AEDTM        ;   // ������
    public String UNAME        ;   // ������̸�
    public String DLEND        ;   // �������Ό����(����ȯ����)
    public String ZZSECU_NAME2  ;   // �����μ���(2)
    public String ZZSECU_REGNO2 ;   // �ֹε�Ϲ�ȣ(2)
    public String ZZSECU_TELX2  ;   // ��ȭ��ȣ(2)
    public String ZZRELA_CODE2  ;   // ����Ư�����(2)
    public String ZCONF  ;   // ���� ���� ���� [CSR ID:1411838] �����ڱ� ��ûȭ�� ���� ��û
    public String BANK_CODE  ;   // ���౸���ڵ� [CSR ID:1411838]
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
