package	hris.D.D03Vocation;

/**
 * D03VocationData.java
 * ������ �ް���û ������ ��ƿ��� ������
 *   [���� RFC] : ZHRW_RFC_HOLIDAY_REQUEST
 * 
 * @author �赵��    
 * @version 1.0, 2002/01/21
 */
public class D03VocationData extends com.sns.jdf.EntityData {

	public String AINF_SEQN   ;     // �������� �Ϸù�ȣ 
    public String PERNR       ;     // �����ȣ
    public String BEGDA       ;			// ��û��
    public String AWART       ;			// �ٹ�/�޹� ����        
    public String REASON      ;     // ��û ����             
    public String APPL_FROM   ;     // ��û������                
    public String APPL_TO     ;			// ��û������                
    public String BEGUZ       ;			// ���۽ð�              
    public String ENDUZ       ;			// ����ð�              
    public String REMAIN_DATE ;			// �ܿ��ް��ϼ�         
    public String DEDUCT_DATE ;     // �����ϼ�
    public String PBEZ4       ;     // ��û���ް��ϼ�
    public String  APPL_REAS       ;     // ��û ����
    //������ �ް� ��û���� �߰��� �ʵ� (2004.10.27)
    public String RMDDA       ;     // ����Ȯ���� - ��꿹���Ϸ� ���

    //**********���� (20050304:�����)**********
    public String ZPERNR    ;   //�븮��û�� ���
    public String ZUNAME    ;   //�μ����� �̸� 
    public String AEDTM     ;   //������         
    public String UNAME     ;   //������̸�  
    public String CONG_CODE ;   //��������    
    public String OVTM_CODE ;   //�����ڵ� CSR ID:1546748   
    public String OVTM_NAME ;   //���ٹ���,�����   CSR ID:1546748  
    public String A002_SEQN ;   //������û �Ϸù�ȣ   CSR ID:1546748  

    public String ANZHL_BAL  ;
    public String ATEXT       ;
    public String P_STDAZ       ;
    public String I_STDAZ       ;
    public String ABSN_DATE ;
    public String AINF_SEQN2 ;
    public String STDAZ       ;
    public String ABRTG       ;

    //���� �ް� ��û�� ��û����ڸ� ����.	2008-01-11.
    public String CELTY       ;		//�����ް� ���� . ȥ��. ��
    public String CELTX       ;		//�����ް� TEXT
    public String FAMY_CODE ;	//��������
    public String FAMY_TEXT ;	//�������� TEXT
    
    public String I_NTM;	// 'X'
    
    public String getP_STDAZ() {
		return P_STDAZ;
	}
	public void setP_STDAZ(String p_STDAZ) {
		P_STDAZ = p_STDAZ;
	}
	public String getI_STDAZ() {
		return I_STDAZ;
	}
	public void setI_STDAZ(String i_STDAZ) {
		I_STDAZ = i_STDAZ;
	}
	public String getAPPL_REAS() {
		return APPL_REAS;
	}
	public void setAPPL_REAS(String aPPL_REAS) {
		APPL_REAS = aPPL_REAS;
	}
	public String getANZHL_BAL() {
		return ANZHL_BAL;
	}
	public void setANZHL_BAL(String aNZHL_BAL) {
		ANZHL_BAL = aNZHL_BAL;
	}
	public String getATEXT() {
		return ATEXT;
	}
	public void setATEXT(String aTEXT) {
		ATEXT = aTEXT;
	}
	public String getp_STDAZ() {
		return P_STDAZ;
	}
	public void setp_STDAZ(String p_STDAZ) {
		P_STDAZ = p_STDAZ;
	}
	public String geti_STDAZ() {
		return I_STDAZ;
	}
	public void seti_STDAZ(String i_STDAZ) {
		I_STDAZ = i_STDAZ;
	}
	public String getABSN_DATE() {
		return ABSN_DATE;
	}
	public void setABSN_DATE(String aBSN_DATE) {
		ABSN_DATE = aBSN_DATE;
	}
	public String getAINF_SEQN2() {
		return AINF_SEQN2;
	}
	public void setAINF_SEQN2(String aINF_SEQN2) {
		AINF_SEQN2 = aINF_SEQN2;
	}
	public String getSTDAZ() {
		return STDAZ;
	}
	public void setSTDAZ(String sTDAZ) {
		STDAZ = sTDAZ;
	}
	public String getABRTG() {
		return ABRTG;
	}
	public void setABRTG(String aBRTG) {
		ABRTG = aBRTG;
	}
	public String getCELTY() {
		return CELTY;
	}
	public void setCELTY(String cELTY) {
		CELTY = cELTY;
	}
	public String getCELTX() {
		return CELTX;
	}
	public void setCELTX(String cELTX) {
		CELTX = cELTX;
	}
	public String getFAMY_CODE() {
		return FAMY_CODE;
	}
	public void setFAMY_CODE(String fAMY_CODE) {
		FAMY_CODE = fAMY_CODE;
	}
	public String getFAMY_TEXT() {
		return FAMY_TEXT;
	}
	public void setFAMY_TEXT(String fAMY_TEXT) {
		FAMY_TEXT = fAMY_TEXT;
	}
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
	public String getAWART() {
		return AWART;
	}
	public void setAWART(String aWART) {
		AWART = aWART;
	}
	public String getREASON() {
		return REASON;
	}
	public void setREASON(String rEASON) {
		REASON = rEASON;
	}
	public String getAPPL_FROM() {
		return APPL_FROM;
	}
	public void setAPPL_FROM(String aPPL_FROM) {
		APPL_FROM = aPPL_FROM;
	}
	public String getAPPL_TO() {
		return APPL_TO;
	}
	public void setAPPL_TO(String aPPL_TO) {
		APPL_TO = aPPL_TO;
	}
	public String getBEGUZ() {
		return BEGUZ;
	}
	public void setBEGUZ(String bEGUZ) {
		BEGUZ = bEGUZ;
	}
	public String getENDUZ() {
		return ENDUZ;
	}
	public void setENDUZ(String eNDUZ) {
		ENDUZ = eNDUZ;
	}
	public String getREMAIN_DATE() {
		return REMAIN_DATE;
	}
	public void setREMAIN_DATE(String rEMAIN_DATE) {
		REMAIN_DATE = rEMAIN_DATE;
	}
	public String getDEDUCT_DATE() {
		return DEDUCT_DATE;
	}
	public void setDEDUCT_DATE(String dEDUCT_DATE) {
		DEDUCT_DATE = dEDUCT_DATE;
	}
	public String getPBEZ4() {
		return PBEZ4;
	}
	public void setPBEZ4(String pBEZ4) {
		PBEZ4 = pBEZ4;
	}
	public String getRMDDA() {
		return RMDDA;
	}
	public void setRMDDA(String rMDDA) {
		RMDDA = rMDDA;
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
	public String getCONG_CODE() {
		return CONG_CODE;
	}
	public void setCONG_CODE(String cONG_CODE) {
		CONG_CODE = cONG_CODE;
	}
	public String getOVTM_CODE() {
		return OVTM_CODE;
	}
	public void setOVTM_CODE(String oVTM_CODE) {
		OVTM_CODE = oVTM_CODE;
	}
	public String getOVTM_NAME() {
		return OVTM_NAME;
	}
	public void setOVTM_NAME(String oVTM_NAME) {
		OVTM_NAME = oVTM_NAME;
	}
	public String getA002_SEQN() {
		return A002_SEQN;
	}
	public void setA002_SEQN(String a002_SEQN) {
		A002_SEQN = a002_SEQN;
	}
	public String getI_NTM() {
		return I_NTM;
	}
	public void setI_NTM(String i_NTM) {
		I_NTM = i_NTM;
	}

} 