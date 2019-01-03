package hris.E.E22Expense;

/**
 * E22ExpenseListData.java
 * �������ϱ�/���ڱ�/���б� ��ȸ
 * [���� RFC] : ZGHR_RFC_SCHOLARSHIP_DISPLAY
 * @author �ֿ�ȣ
 * @version 1.0, 2002/01/04
 * 					1.1  SJY 2014/10/23 ���� ���ڱ� ���� [CSR ID:2634836] ���ڱ� ��û �ý��� ���� ��û
 * 					2018/01/08 cykim	[CSR ID:3569058] Global HR Portal ���б� ��ûȭ�� ���� ��û�� ��
 */
public class E22ExpenseListData extends com.sns.jdf.EntityData {
    public String SUBF_TYPE ;       // �������ϱ�/���ڱ�/���б� ���� �ڵ�
    public String STEXT     ;       // �������ϱ�/���ڱ�/���б� �̸�
    public String FAMSA     ;       // ��������
    public String OBJC_CODE ;       // �Ϻ�����
    public String ATEXT     ;       // ��������TEXT
    public String GESC1     ;       // ����Ű
    public String GESC2     ;       // ����Ű
    public String ACAD_CARE ;       // �з�
    public String TEXT4     ;       // �з�TEXT
    public String FASIN     ;       // �������
    public String REGNO     ;       // �ֹε�Ϲ�ȣ
    public String ACAD_YEAR ;       // �г�
    public String PROP_AMNT ;       // ��û��
    public String ENTR_FIAG ;       // ���б�
    public String PAY1_TYPE ;       // ���ޱ���(�űԺ�)
    public String PAY2_TYPE ;       // ���ޱ���(�߰���)
    public String PERD_TYPE ;       // �б�
    public String HALF_TYPE ;       // �ݱ�
    public String PROP_YEAR ;       // ��û�⵵
    public String LNMHG     ;       // ��(�ѱ�)
    public String FNMHG     ;       // �̸�(�ѱ�)
    public String PAID_AMNT ;       // ���޾�
    public String PAID_DATE ;       // ��û����
    public String BEGDA     ;       // ������(���� ������)
    public String ENDDA     ;       // ������
    public String BIGO_TEXT1;       // ���1
    public String BIGO_TEXT2;       // ���2
    public String RFUN_DATE ;       // �ݳ�����
    public String RFUN_RESN ;       // �ݳ�����
    public String RFUN_AMNT ;       // �ݳ���
    public String RFUN_FLAG ;       // ����Ƚ����������
    public String WAERS     ;       // ��ȭŰ(��û��)
    public String WAERS1    ;       // ��ȭŰ(������)
    public String YTAX_WONX ;       // �������� �ݿ���
    public String P_COUNT   ;       // ����Ƚ��
    public String POST_DATE ;       // ����������
    public String AINF_SEQN ;       // �����ȣ

    /*[CSR ID:3569058] �а��ʵ� �߰� start*/
    public String FRTXT;			//�����ؽ�Ʈ
    /*[CSR ID:3569058] �а��ʵ� �߰� end*/

    /*
     * 1.1 START
     */
    public String SCHCODE;  //�����ڵ�
	public String ABRSCHOOL; //�������ڱ� ����
    /*
     * 1.1 END
     */

	public String getFRTXT() {
		return FRTXT;
	}

	public void setFRTXT(String fRTXT) {
		FRTXT = fRTXT;
	}

    public String getSUBF_TYPE() {
        return SUBF_TYPE;
    }

    public void setSUBF_TYPE(String SUBF_TYPE) {
        this.SUBF_TYPE = SUBF_TYPE;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getFAMSA() {
        return FAMSA;
    }

    public void setFAMSA(String FAMSA) {
        this.FAMSA = FAMSA;
    }

    public String getOBJC_CODE() {
        return OBJC_CODE;
    }

    public void setOBJC_CODE(String OBJC_CODE) {
        this.OBJC_CODE = OBJC_CODE;
    }

    public String getATEXT() {
        return ATEXT;
    }

    public void setATEXT(String ATEXT) {
        this.ATEXT = ATEXT;
    }

    public String getGESC1() {
        return GESC1;
    }

    public void setGESC1(String GESC1) {
        this.GESC1 = GESC1;
    }

    public String getGESC2() {
        return GESC2;
    }

    public void setGESC2(String GESC2) {
        this.GESC2 = GESC2;
    }

    public String getACAD_CARE() {
        return ACAD_CARE;
    }

    public void setACAD_CARE(String ACAD_CARE) {
        this.ACAD_CARE = ACAD_CARE;
    }

    public String getTEXT4() {
        return TEXT4;
    }

    public void setTEXT4(String TEXT4) {
        this.TEXT4 = TEXT4;
    }

    public String getFASIN() {
        return FASIN;
    }

    public void setFASIN(String FASIN) {
        this.FASIN = FASIN;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getACAD_YEAR() {
        return ACAD_YEAR;
    }

    public void setACAD_YEAR(String ACAD_YEAR) {
        this.ACAD_YEAR = ACAD_YEAR;
    }

    public String getPROP_AMNT() {
        return PROP_AMNT;
    }

    public void setPROP_AMNT(String PROP_AMNT) {
        this.PROP_AMNT = PROP_AMNT;
    }

    public String getENTR_FIAG() {
        return ENTR_FIAG;
    }

    public void setENTR_FIAG(String ENTR_FIAG) {
        this.ENTR_FIAG = ENTR_FIAG;
    }

    public String getPAY1_TYPE() {
        return PAY1_TYPE;
    }

    public void setPAY1_TYPE(String PAY1_TYPE) {
        this.PAY1_TYPE = PAY1_TYPE;
    }

    public String getPAY2_TYPE() {
        return PAY2_TYPE;
    }

    public void setPAY2_TYPE(String PAY2_TYPE) {
        this.PAY2_TYPE = PAY2_TYPE;
    }

    public String getPERD_TYPE() {
        return PERD_TYPE;
    }

    public void setPERD_TYPE(String PERD_TYPE) {
        this.PERD_TYPE = PERD_TYPE;
    }

    public String getHALF_TYPE() {
        return HALF_TYPE;
    }

    public void setHALF_TYPE(String HALF_TYPE) {
        this.HALF_TYPE = HALF_TYPE;
    }

    public String getPROP_YEAR() {
        return PROP_YEAR;
    }

    public void setPROP_YEAR(String PROP_YEAR) {
        this.PROP_YEAR = PROP_YEAR;
    }

    public String getLNMHG() {
        return LNMHG;
    }

    public void setLNMHG(String LNMHG) {
        this.LNMHG = LNMHG;
    }

    public String getFNMHG() {
        return FNMHG;
    }

    public void setFNMHG(String FNMHG) {
        this.FNMHG = FNMHG;
    }

    public String getPAID_AMNT() {
        return PAID_AMNT;
    }

    public void setPAID_AMNT(String PAID_AMNT) {
        this.PAID_AMNT = PAID_AMNT;
    }

    public String getPAID_DATE() {
        return PAID_DATE;
    }

    public void setPAID_DATE(String PAID_DATE) {
        this.PAID_DATE = PAID_DATE;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
    }

    public String getBIGO_TEXT1() {
        return BIGO_TEXT1;
    }

    public void setBIGO_TEXT1(String BIGO_TEXT1) {
        this.BIGO_TEXT1 = BIGO_TEXT1;
    }

    public String getBIGO_TEXT2() {
        return BIGO_TEXT2;
    }

    public void setBIGO_TEXT2(String BIGO_TEXT2) {
        this.BIGO_TEXT2 = BIGO_TEXT2;
    }

    public String getRFUN_DATE() {
        return RFUN_DATE;
    }

    public void setRFUN_DATE(String RFUN_DATE) {
        this.RFUN_DATE = RFUN_DATE;
    }

    public String getRFUN_RESN() {
        return RFUN_RESN;
    }

    public void setRFUN_RESN(String RFUN_RESN) {
        this.RFUN_RESN = RFUN_RESN;
    }

    public String getRFUN_AMNT() {
        return RFUN_AMNT;
    }

    public void setRFUN_AMNT(String RFUN_AMNT) {
        this.RFUN_AMNT = RFUN_AMNT;
    }

    public String getRFUN_FLAG() {
        return RFUN_FLAG;
    }

    public void setRFUN_FLAG(String RFUN_FLAG) {
        this.RFUN_FLAG = RFUN_FLAG;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }

    public String getWAERS1() {
        return WAERS1;
    }

    public void setWAERS1(String WAERS1) {
        this.WAERS1 = WAERS1;
    }

    public String getYTAX_WONX() {
        return YTAX_WONX;
    }

    public void setYTAX_WONX(String YTAX_WONX) {
        this.YTAX_WONX = YTAX_WONX;
    }

    public String getP_COUNT() {
        return P_COUNT;
    }

    public void setP_COUNT(String P_COUNT) {
        this.P_COUNT = P_COUNT;
    }

    public String getPOST_DATE() {
        return POST_DATE;
    }

    public void setPOST_DATE(String POST_DATE) {
        this.POST_DATE = POST_DATE;
    }

    public String getSCHCODE() {
        return SCHCODE;
    }

    public void setSCHCODE(String SCHCODE) {
        this.SCHCODE = SCHCODE;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getABRSCHOOL() {
        return ABRSCHOOL;
    }

    public void setABRSCHOOL(String ABRSCHOOL) {
        this.ABRSCHOOL = ABRSCHOOL;
    }

}