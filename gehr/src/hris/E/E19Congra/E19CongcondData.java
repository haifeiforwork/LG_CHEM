package hris.E.E19Congra;

/**
 * E19CongcondData.java
 * ������ ���� ���� ����Ÿ & ��������ڰ��� ����Ÿ & ��������ȸ & ������ ���� ���� �߰� ����Ÿ & �����ݽ�û
 *   [���� RFC] : ZHRW_RFC_P_CONGCOND_RATE[1], ZHRW_RFC_P_CONGCOND_RELA[2], ZHRW_RFC_CONGCOND_DISPLAY[3],
 *                ZHRW_RFC_CONGCOND_COMMWAGE[4], ZHRW_RFC_CONGCOND_REQUEST[5], ZHRA_RFC_GET_LIFNR[6]
 * @author �輺��
 * @version 1.0, 2001/12/18
*                  2014-04-21  CSR ID: 20140416_24713 ȭȯ��ü�߰�
 */
public class E19CongcondData extends com.sns.jdf.EntityData
{
    public String CONG_CODE;       // ��������              [1,2,3,  5] �ش� RFC�� Export table�� field��
    public String RELA_CODE;       // ��������ڰ����ڵ�    [1,2,3,  5]
    public String CCON_RATE;       // ������                [1        ]
    public String HOLI_CONT;       // �����ް�              [1,  3,  5]
    public String RELA_NAME;       // ��������ڰ����ڵ��  [  2,3    ]
    public String EREL_NAME;       // ������󼺸�          [    3,  5]
    public String CONG_DATE;       // �����߻���            [    3,  5]
    public String WAGE_WONX;       // ����ӱ�              [    3,4,5]
    public String CONG_RATE;       // ������                [    3,  5]
    public String CONG_WONX;       // ������                [    3,  5]
    public String PROV_DATE;       // ������                [    3,  5]
    public String BANK_NAME;       // ��ü�����          [    3,4,5]
    public String BANKN    ;       // ������¹�ȣ       [    3,4,5,6]
    public String WORK_YEAR;       // �ټӳ�                [    3,4,5]
    public String WORK_MNTH;       // �ټӿ�                [    3,4,5]
    public String RTRO_MNTH;       // ���޳��(�ұ޺�)[    3,  5]
    public String RTRO_WONX;       // �ұ�����              [    3,  5]
    public String CONG_NAME;       // ���������ڵ��    [    3    ]
    public String BEGDA    ;       // ������(��û��)  [    3,  5]

    public String PERNR    ;       // ���                     [        5]
    public String AINF_SEQN;       // �������� �Ϸù�ȣ[        5]

    public String LIFNR		;       // ����ó �Ǵ� ä���� ������ȣ[ 5,6]
	public String NAME1		;		// LIFNR + ����			[	6]
	public String BANKS		;		// ���౹��Ű				[	6]
    public String BANKL		;       // �����ȣ				[ 5,6]
    public String BANKA		;       // �����					[ 5,6]
    // ���� �߰�  2005�� 2�� 1��
    public String PROOF;           // ����Ȯ��              [        5]
    public String POST_DATE;       // POSTING����       [        5]
    public String BELNR;           // ȸ����ǥ��ȣ        [        5]
    public String ZUNAME;          // �μ����� �̸�       [        5]
    public String ZPERNR;          // �븮 ��û��          [        5]
    public String DISA_RESN;       // ���ؿ��γ���        [        5]
    public String AEDTM;           // ������                  [        5]
    public String UNAME;           // ������ ���          [        5]

    public String BVTYP;           // �ŷ�ó��������
    public String BVTXT;           // ��������
    public String REGNO;           // ����������ֹι�ȣ
    public String REASON_CD;           // ȸ�� ������ ���� �� ����

    public String ZPERNR2;	//20140416_24713 �븮��û�ڻ��
    public String ZUNAME2;	//20140416_24713 �μ����� �̸�
    public String ZGRUP_NUMB_O;	//20140416_24713 �����
    public String ZPHONE_NUM;	//20140416_24713 �ֹ��� ��ȭ��ȣ
    public String ZCELL_NUM;	//20140416_24713 �ֹ��� �޴���ȭ (������ ���� ������ �Է�)
    public String ZUNAME_R;	//20140416_24713 ����� ������
    public String ZCELL_NUM_R;	//20140416_24713 ����ó
    public String ZGRUP_NUMB_R;	//20140416_24713 �����
    public String ZUNION_FLAG;	//20140416_24713 ���տ�����
    public String ZTRANS_DATE;	//20140416_24713 �������
    public String ZTRANS_TIME;	//20140416_24713 ��۽ð�
    public String ZTRANS_ADDR;	//20140416_24713 ������ּ�(50��) - �˻����� TEXT
    public String ZTRANS_ETC;	//20140416_24713 ��Ÿ�䱸����(50��)
    public String ZTRANS_SEQ;	//20140416_24713 ��ü SEQ
    public String ZTRANS_PSEQ;	//20140416_24713 ����� SEQ
	public String getCONG_CODE() {
		return CONG_CODE;
	}
	public void setCONG_CODE(String cONG_CODE) {
		CONG_CODE = cONG_CODE;
	}
	public String getRELA_CODE() {
		return RELA_CODE;
	}
	public void setRELA_CODE(String rELA_CODE) {
		RELA_CODE = rELA_CODE;
	}
	public String getCCON_RATE() {
		return CCON_RATE;
	}
	public void setCCON_RATE(String cCON_RATE) {
		CCON_RATE = cCON_RATE;
	}
	public String getHOLI_CONT() {
		return HOLI_CONT;
	}
	public void setHOLI_CONT(String hOLI_CONT) {
		HOLI_CONT = hOLI_CONT;
	}
	public String getRELA_NAME() {
		return RELA_NAME;
	}
	public void setRELA_NAME(String rELA_NAME) {
		RELA_NAME = rELA_NAME;
	}
	public String getEREL_NAME() {
		return EREL_NAME;
	}
	public void setEREL_NAME(String eREL_NAME) {
		EREL_NAME = eREL_NAME;
	}
	public String getCONG_DATE() {
		return CONG_DATE;
	}
	public void setCONG_DATE(String cONG_DATE) {
		CONG_DATE = cONG_DATE;
	}
	public String getWAGE_WONX() {
		return WAGE_WONX;
	}
	public void setWAGE_WONX(String wAGE_WONX) {
		WAGE_WONX = wAGE_WONX;
	}
	public String getCONG_RATE() {
		return CONG_RATE;
	}
	public void setCONG_RATE(String cONG_RATE) {
		CONG_RATE = cONG_RATE;
	}
	public String getCONG_WONX() {
		return CONG_WONX;
	}
	public void setCONG_WONX(String cONG_WONX) {
		CONG_WONX = cONG_WONX;
	}
	public String getPROV_DATE() {
		return PROV_DATE;
	}
	public void setPROV_DATE(String pROV_DATE) {
		PROV_DATE = pROV_DATE;
	}
	public String getBANK_NAME() {
		return BANK_NAME;
	}
	public void setBANK_NAME(String bANK_NAME) {
		BANK_NAME = bANK_NAME;
	}
	public String getBANKN() {
		return BANKN;
	}
	public void setBANKN(String bANKN) {
		BANKN = bANKN;
	}
	public String getWORK_YEAR() {
		return WORK_YEAR;
	}
	public void setWORK_YEAR(String wORK_YEAR) {
		WORK_YEAR = wORK_YEAR;
	}
	public String getWORK_MNTH() {
		return WORK_MNTH;
	}
	public void setWORK_MNTH(String wORK_MNTH) {
		WORK_MNTH = wORK_MNTH;
	}
	public String getRTRO_MNTH() {
		return RTRO_MNTH;
	}
	public void setRTRO_MNTH(String rTRO_MNTH) {
		RTRO_MNTH = rTRO_MNTH;
	}
	public String getRTRO_WONX() {
		return RTRO_WONX;
	}
	public void setRTRO_WONX(String rTRO_WONX) {
		RTRO_WONX = rTRO_WONX;
	}
	public String getCONG_NAME() {
		return CONG_NAME;
	}
	public void setCONG_NAME(String cONG_NAME) {
		CONG_NAME = cONG_NAME;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getLIFNR() {
		return LIFNR;
	}
	public void setLIFNR(String lIFNR) {
		LIFNR = lIFNR;
	}
	public String getNAME1() {
		return NAME1;
	}
	public void setNAME1(String nAME1) {
		NAME1 = nAME1;
	}
	public String getBANKS() {
		return BANKS;
	}
	public void setBANKS(String bANKS) {
		BANKS = bANKS;
	}
	public String getBANKL() {
		return BANKL;
	}
	public void setBANKL(String bANKL) {
		BANKL = bANKL;
	}
	public String getBANKA() {
		return BANKA;
	}
	public void setBANKA(String bANKA) {
		BANKA = bANKA;
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
	public String getZUNAME() {
		return ZUNAME;
	}
	public void setZUNAME(String zUNAME) {
		ZUNAME = zUNAME;
	}
	public String getZPERNR() {
		return ZPERNR;
	}
	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
	}
	public String getDISA_RESN() {
		return DISA_RESN;
	}
	public void setDISA_RESN(String dISA_RESN) {
		DISA_RESN = dISA_RESN;
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
	public String getBVTYP() {
		return BVTYP;
	}
	public void setBVTYP(String bVTYP) {
		BVTYP = bVTYP;
	}
	public String getBVTXT() {
		return BVTXT;
	}
	public void setBVTXT(String bVTXT) {
		BVTXT = bVTXT;
	}
	public String getREGNO() {
		return REGNO;
	}
	public void setREGNO(String rEGNO) {
		REGNO = rEGNO;
	}
	public String getREASON_CD() {
		return REASON_CD;
	}
	public void setREASON_CD(String rEASON_CD) {
		REASON_CD = rEASON_CD;
	}
	public String getZPERNR2() {
		return ZPERNR2;
	}
	public void setZPERNR2(String zPERNR2) {
		ZPERNR2 = zPERNR2;
	}
	public String getZUNAME2() {
		return ZUNAME2;
	}
	public void setZUNAME2(String zUNAME2) {
		ZUNAME2 = zUNAME2;
	}
	public String getZGRUP_NUMB_O() {
		return ZGRUP_NUMB_O;
	}
	public void setZGRUP_NUMB_O(String zGRUP_NUMB_O) {
		ZGRUP_NUMB_O = zGRUP_NUMB_O;
	}
	public String getZPHONE_NUM() {
		return ZPHONE_NUM;
	}
	public void setZPHONE_NUM(String zPHONE_NUM) {
		ZPHONE_NUM = zPHONE_NUM;
	}
	public String getZCELL_NUM() {
		return ZCELL_NUM;
	}
	public void setZCELL_NUM(String zCELL_NUM) {
		ZCELL_NUM = zCELL_NUM;
	}
	public String getZUNAME_R() {
		return ZUNAME_R;
	}
	public void setZUNAME_R(String zUNAME_R) {
		ZUNAME_R = zUNAME_R;
	}
	public String getZCELL_NUM_R() {
		return ZCELL_NUM_R;
	}
	public void setZCELL_NUM_R(String zCELL_NUM_R) {
		ZCELL_NUM_R = zCELL_NUM_R;
	}
	public String getZGRUP_NUMB_R() {
		return ZGRUP_NUMB_R;
	}
	public void setZGRUP_NUMB_R(String zGRUP_NUMB_R) {
		ZGRUP_NUMB_R = zGRUP_NUMB_R;
	}
	public String getZUNION_FLAG() {
		return ZUNION_FLAG;
	}
	public void setZUNION_FLAG(String zUNION_FLAG) {
		ZUNION_FLAG = zUNION_FLAG;
	}
	public String getZTRANS_DATE() {
		return ZTRANS_DATE;
	}
	public void setZTRANS_DATE(String zTRANS_DATE) {
		ZTRANS_DATE = zTRANS_DATE;
	}
	public String getZTRANS_TIME() {
		return ZTRANS_TIME;
	}
	public void setZTRANS_TIME(String zTRANS_TIME) {
		ZTRANS_TIME = zTRANS_TIME;
	}
	public String getZTRANS_ADDR() {
		return ZTRANS_ADDR;
	}
	public void setZTRANS_ADDR(String zTRANS_ADDR) {
		ZTRANS_ADDR = zTRANS_ADDR;
	}
	public String getZTRANS_ETC() {
		return ZTRANS_ETC;
	}
	public void setZTRANS_ETC(String zTRANS_ETC) {
		ZTRANS_ETC = zTRANS_ETC;
	}
	public String getZTRANS_SEQ() {
		return ZTRANS_SEQ;
	}
	public void setZTRANS_SEQ(String zTRANS_SEQ) {
		ZTRANS_SEQ = zTRANS_SEQ;
	}
	public String getZTRANS_PSEQ() {
		return ZTRANS_PSEQ;
	}
	public void setZTRANS_PSEQ(String zTRANS_PSEQ) {
		ZTRANS_PSEQ = zTRANS_PSEQ;
	}



}