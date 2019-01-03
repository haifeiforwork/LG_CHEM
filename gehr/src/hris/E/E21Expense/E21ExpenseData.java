package hris.E.E21Expense;

/**
 * E21ExpenseData.java
 * ���ڱ�/���б� ��û,��ȸ,����
 *   [���� RFC] : ZHRW_RFC_SCHOOL_FEE_LIST
 * @author �輺��
 * @version 1.0, 2002/01/03
 * 				  1.1  SJY 2014/10/23 ���� ���ڱ� ���� [CSR ID:2634836] ���ڱ� ��û �ý��� ���� ��û
 *                2018/01/08 cykim	[CSR ID:3569058] Global HR Portal ���б� ��ûȭ�� ���� ��û�� ��
 */
public class E21ExpenseData extends com.sns.jdf.EntityData {
    public String AINF_SEQN  ;       // �������� �Ϸù�ȣ
    public String PERNR      ;       // �����ȣ
    public String BEGDA      ;       // ������
    public String PAID_DATE  ;       // ��û����
    public String FAMSA      ;       // �������ڵ�����
    public String OBJC_CODE  ;       // �Ϻ�����
    public String ATEXT      ;       // �ؽ�Ʈ, 20����
    public String SUBF_TYPE  ;       // �������ϱ��� ����Ÿ��
    public String PAY1_TYPE  ;       // ���ޱ���(�űԺ�)
    public String PAY2_TYPE  ;       // ���ޱ���(�߰���)
    public String PERD_TYPE  ;       // �б�
    public String HALF_TYPE  ;       // �ݱ�
    public String PROP_YEAR  ;       // ��û�⵵
    public String LNMHG      ;       // �� (�ѱ�)
    public String FNMHG      ;       // �̸� (�ѱ�)
    public String ACAD_CARE  ;       // �з�
    public String STEXT      ;       // �б������ؽ�Ʈ
    public String FASIN      ;       // �������
    public String ACAD_YEAR  ;       // �г�
    public String PROP_AMNT  ;       // ��û��
    public String PAID_AMNT  ;       // ���޾�
    public String ENTR_FIAG  ;       // ���б�
    public String WAERS      ;       // ��ȭŰ(��û��)
    public String WAERS1     ;       // ��ȭŰ(������)
    public String BIGO_TEXT1 ;       // ���1
    public String BIGO_TEXT2 ;       // ���2
    public String YTAX_WONX  ;       // �������� �ݿ���
    public String P_COUNT    ;       // ����Ƚ��
    public String GESC2 ;            //���� Ű
    public String KDSVH ;            //�ڳ���� ����
    public String REGNO ;            //�ֹε�Ϲ�ȣ
    public String POST_DATE ;        //POSTING����
    public String BELNR ;            //ȸ����ǥ��ȣ
    public String ZPERNR    ;        //�븮��û�ڻ��
    public String ZUNAME    ;        //�μ����� �̸�
    public String AEDTM ;            //������
    public String UNAME ;            //������̸�

    /*[CSR ID:3569058] �а��ʵ� �߰� start*/
    public String FRTXT;			//�����ؽ�Ʈ
    /*[CSR ID:3569058] �а��ʵ� �߰� end*/

    public String getFRTXT() {
		return FRTXT;
	}
	public void setFRTXT(String fRTXT) {
		FRTXT = fRTXT;
	}

	/*
     * 1.1 START
     */
    public String SCHCODE;  //�����ڵ�
    public String ABRSCHOOL; //�������ڱ� ����
    /*
     * 1.1 END
     */
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
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
	public String getPAID_DATE() {
		return PAID_DATE;
	}
	public void setPAID_DATE(String pAID_DATE) {
		PAID_DATE = pAID_DATE;
	}
	public String getFAMSA() {
		return FAMSA;
	}
	public void setFAMSA(String fAMSA) {
		FAMSA = fAMSA;
	}
	public String getOBJC_CODE() {
		return OBJC_CODE;
	}
	public void setOBJC_CODE(String oBJC_CODE) {
		OBJC_CODE = oBJC_CODE;
	}
	public String getATEXT() {
		return ATEXT;
	}
	public void setATEXT(String aTEXT) {
		ATEXT = aTEXT;
	}
	public String getSUBF_TYPE() {
		return SUBF_TYPE;
	}
	public void setSUBF_TYPE(String sUBF_TYPE) {
		SUBF_TYPE = sUBF_TYPE;
	}
	public String getPAY1_TYPE() {
		return PAY1_TYPE;
	}
	public void setPAY1_TYPE(String pAY1_TYPE) {
		PAY1_TYPE = pAY1_TYPE;
	}
	public String getPAY2_TYPE() {
		return PAY2_TYPE;
	}
	public void setPAY2_TYPE(String pAY2_TYPE) {
		PAY2_TYPE = pAY2_TYPE;
	}
	public String getPERD_TYPE() {
		return PERD_TYPE;
	}
	public void setPERD_TYPE(String pERD_TYPE) {
		PERD_TYPE = pERD_TYPE;
	}
	public String getHALF_TYPE() {
		return HALF_TYPE;
	}
	public void setHALF_TYPE(String hALF_TYPE) {
		HALF_TYPE = hALF_TYPE;
	}
	public String getPROP_YEAR() {
		return PROP_YEAR;
	}
	public void setPROP_YEAR(String pROP_YEAR) {
		PROP_YEAR = pROP_YEAR;
	}
	public String getLNMHG() {
		return LNMHG;
	}
	public void setLNMHG(String lNMHG) {
		LNMHG = lNMHG;
	}
	public String getFNMHG() {
		return FNMHG;
	}
	public void setFNMHG(String fNMHG) {
		FNMHG = fNMHG;
	}
	public String getACAD_CARE() {
		return ACAD_CARE;
	}
	public void setACAD_CARE(String aCAD_CARE) {
		ACAD_CARE = aCAD_CARE;
	}
	public String getSTEXT() {
		return STEXT;
	}
	public void setSTEXT(String sTEXT) {
		STEXT = sTEXT;
	}
	public String getFASIN() {
		return FASIN;
	}
	public void setFASIN(String fASIN) {
		FASIN = fASIN;
	}
	public String getACAD_YEAR() {
		return ACAD_YEAR;
	}
	public void setACAD_YEAR(String aCAD_YEAR) {
		ACAD_YEAR = aCAD_YEAR;
	}
	public String getPROP_AMNT() {
		return PROP_AMNT;
	}
	public void setPROP_AMNT(String pROP_AMNT) {
		PROP_AMNT = pROP_AMNT;
	}
	public String getPAID_AMNT() {
		return PAID_AMNT;
	}
	public void setPAID_AMNT(String pAID_AMNT) {
		PAID_AMNT = pAID_AMNT;
	}
	public String getENTR_FIAG() {
		return ENTR_FIAG;
	}
	public void setENTR_FIAG(String eNTR_FIAG) {
		ENTR_FIAG = eNTR_FIAG;
	}
	public String getWAERS() {
		return WAERS;
	}
	public void setWAERS(String wAERS) {
		WAERS = wAERS;
	}
	public String getWAERS1() {
		return WAERS1;
	}
	public void setWAERS1(String wAERS1) {
		WAERS1 = wAERS1;
	}
	public String getBIGO_TEXT1() {
		return BIGO_TEXT1;
	}
	public void setBIGO_TEXT1(String bIGO_TEXT1) {
		BIGO_TEXT1 = bIGO_TEXT1;
	}
	public String getBIGO_TEXT2() {
		return BIGO_TEXT2;
	}
	public void setBIGO_TEXT2(String bIGO_TEXT2) {
		BIGO_TEXT2 = bIGO_TEXT2;
	}
	public String getYTAX_WONX() {
		return YTAX_WONX;
	}
	public void setYTAX_WONX(String yTAX_WONX) {
		YTAX_WONX = yTAX_WONX;
	}
	public String getP_COUNT() {
		return P_COUNT;
	}
	public void setP_COUNT(String p_COUNT) {
		P_COUNT = p_COUNT;
	}
	public String getGESC2() {
		return GESC2;
	}
	public void setGESC2(String gESC2) {
		GESC2 = gESC2;
	}
	public String getKDSVH() {
		return KDSVH;
	}
	public void setKDSVH(String kDSVH) {
		KDSVH = kDSVH;
	}
	public String getREGNO() {
		return REGNO;
	}
	public void setREGNO(String rEGNO) {
		REGNO = rEGNO;
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
	public String getSCHCODE() {
		return SCHCODE;
	}
	public void setSCHCODE(String sCHCODE) {
		SCHCODE = sCHCODE;
	}
	public String getABRSCHOOL() {
		return ABRSCHOOL;
	}
	public void setABRSCHOOL(String aBRSCHOOL) {
		ABRSCHOOL = aBRSCHOOL;
	}



}