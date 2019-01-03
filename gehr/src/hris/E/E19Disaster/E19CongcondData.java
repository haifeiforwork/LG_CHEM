/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ؽ�û                                                    */
/*   Program Name : ���ؽ�û                                                    */
/*   Program ID   : E19CongcondData                                             */
/*   Description  : ������ ���� ���� ����Ÿ & ��������ڰ��� ����Ÿ & ��������ȸ*/
/*                  & ������ ���� ���� �߰� ����Ÿ & �����ݽ�û                 */
/*   Note         : [���� RFC] : ZHRW_RFC_P_CONGCOND_RATE[1],                   */
/*                  ZHRW_RFC_P_CONGCOND_RELA[2], ZHRW_RFC_CONGCOND_DISPLAY[3],  */
/*                  ZHRW_RFC_CONGCOND_COMMWAGE[4], ZHRW_RFC_CONGCOND_REQUEST[5] */
/*   Creation     : 2002-03-07  �輺��                                          */
/*   Update       : 2005-02-25  ������                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E19Disaster;

public class E19CongcondData extends com.sns.jdf.EntityData {
    public String AINF_SEQN;  // �������� �Ϸù�ȣ   [        5]
    public String BANKN    ;  // ������¹�ȣ        [    3,4,5]
    public String BANK_NAME;  // ��ü�����          [    3,4,5]
    public String CONG_CODE;  // ��������            [1,2,3,  5] �ش� RFC�� Export table�� field��
    public String CONG_NAME;  // ���������ڵ��      [    3    ]
    public String CONG_DATE;  // �����߻���          [    3,  5]
    public String CONG_RATE;  // ������              [    3,  5]
    public String CCON_RATE;  // ������              [1        ]
    public String CONG_WONX;  // ������              [    3,  5]
    public String EREL_NAME;  // ������󼺸�        [    3,  5]
    public String HOLI_CONT;  // �����ް�            [1,  3,  5]
    public String PROV_DATE;  // ������              [    3,  5]
    public String RELA_CODE;  // ��������ڰ����ڵ�  [1,2,3,  5]
    public String RELA_NAME;  // ��������ڰ����ڵ��[  2,3    ]
    public String RTRO_MNTH;  // ���޳��(�ұ޺�)    [    3,  5]
    public String RTRO_WONX;  // �ұ�����            [    3,  5]
    public String WAGE_WONX;  // ����ӱ�            [    3,4,5]
    public String WORK_YEAR;  // �ټӳ�              [    3,4,5]
    public String WORK_MNTH;  // �ټӿ�              [    3,4,5]
    public String PERNR    ;  // ���                [        5]
    public String BEGDA    ;  // ������(��û��)      [    3,  5]
    public String LIFNR    ;  // ����ó �Ǵ� ä���� ������ȣ [  5]
    public String BANKL    ;  // �����ȣ            [        5]
    public String PROOF    ;  // ����Ȯ��
    public String POST_DATE;  // POSTING����
    public String BELNR    ;  // ȸ����ǥ��ȣ

    public String ZPERNR   ;  // �븮��û�ڻ��
    public String ZUNAME   ;  // �μ����� �̸�
    public String DISA_RESN;  // ���س����ڵ� CYH 20030918

    public String AEDTM;      // ������                [        5]
    public String UNAME;      // ������ ���           [        5]
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getBANKN() {
		return BANKN;
	}
	public void setBANKN(String bANKN) {
		BANKN = bANKN;
	}
	public String getBANK_NAME() {
		return BANK_NAME;
	}
	public void setBANK_NAME(String bANK_NAME) {
		BANK_NAME = bANK_NAME;
	}
	public String getCONG_CODE() {
		return CONG_CODE;
	}
	public void setCONG_CODE(String cONG_CODE) {
		CONG_CODE = cONG_CODE;
	}
	public String getCONG_NAME() {
		return CONG_NAME;
	}
	public void setCONG_NAME(String cONG_NAME) {
		CONG_NAME = cONG_NAME;
	}
	public String getCONG_DATE() {
		return CONG_DATE;
	}
	public void setCONG_DATE(String cONG_DATE) {
		CONG_DATE = cONG_DATE;
	}
	public String getCONG_RATE() {
		return CONG_RATE;
	}
	public void setCONG_RATE(String cONG_RATE) {
		CONG_RATE = cONG_RATE;
	}
	public String getCCON_RATE() {
		return CCON_RATE;
	}
	public void setCCON_RATE(String cCON_RATE) {
		CCON_RATE = cCON_RATE;
	}
	public String getCONG_WONX() {
		return CONG_WONX;
	}
	public void setCONG_WONX(String cONG_WONX) {
		CONG_WONX = cONG_WONX;
	}
	public String getEREL_NAME() {
		return EREL_NAME;
	}
	public void setEREL_NAME(String eREL_NAME) {
		EREL_NAME = eREL_NAME;
	}
	public String getHOLI_CONT() {
		return HOLI_CONT;
	}
	public void setHOLI_CONT(String hOLI_CONT) {
		HOLI_CONT = hOLI_CONT;
	}
	public String getPROV_DATE() {
		return PROV_DATE;
	}
	public void setPROV_DATE(String pROV_DATE) {
		PROV_DATE = pROV_DATE;
	}
	public String getRELA_CODE() {
		return RELA_CODE;
	}
	public void setRELA_CODE(String rELA_CODE) {
		RELA_CODE = rELA_CODE;
	}
	public String getRELA_NAME() {
		return RELA_NAME;
	}
	public void setRELA_NAME(String rELA_NAME) {
		RELA_NAME = rELA_NAME;
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
	public String getWAGE_WONX() {
		return WAGE_WONX;
	}
	public void setWAGE_WONX(String wAGE_WONX) {
		WAGE_WONX = wAGE_WONX;
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
	public String getLIFNR() {
		return LIFNR;
	}
	public void setLIFNR(String lIFNR) {
		LIFNR = lIFNR;
	}
	public String getBANKL() {
		return BANKL;
	}
	public void setBANKL(String bANKL) {
		BANKL = bANKL;
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
}