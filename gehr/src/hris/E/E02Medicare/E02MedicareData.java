/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ǰ����� ��߱�                                             */
/*   Program Name : �ǰ����� ��߱�/�߰��߱�/������׺��� ��û                  */
/*   Program ID   : E02MedicareData                                             */
/*   Description  : �ǰ������� ����/��߱� ��û/����/��ȸ�� �ϴ� ������         */
/*   Note         : [���� RFC] : ZHRW_RFC_HEALTH_INSURANCE                      */
/*   Creation     : 2002-01-28  �ڿ���                                          */
/*   Update       : 2005-02-28  ������                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E02Medicare;

public class E02MedicareData extends com.sns.jdf.EntityData {

    public String MANDT      ;  //Ŭ���̾�Ʈ��ȣ
    public String PERNR      ;  //�����ȣ
    public String AINF_SEQN  ;  //�������� �Ϸù�ȣ
    public String BEGDA      ;  //������
    public String SUBTY      ;  //�Ϻ�����
    public String OBJPS      ;  //������Ʈ�ĺ�
    public String ENAME      ;  //����Ǵ��������̸�
    public String APPL_TYPE2 ;  //�ǰ������û����
    public String APPL_TYPE3 ;  //������׺����׸�
    public String ETC_TEXT3  ;  //������׺��� ��Ÿ �ؽ�Ʈ
    public String CHNG_BEFORE;  //������������
    public String CHNG_AFTER ;  //�����ĵ�����
    public String APPL_TYPE4 ;  //�߰��߱� �׸� �ڵ�
    public String ADD_NUM    ;  //�߱޺μ�(�߰��߱�)
    public String ETC_TEXT4  ;  //�߰��߱� ��Ÿ �ؽ�Ʈ
    public String APPL_TYPE5 ;  //��߱� ���� �׸� �ڵ�
    public String ETC_TEXT5  ;  //��߱� ��Ÿ �ؽ�Ʈ
    public String ADD_NUM1   ;  //�߱޺μ�(��߱�)
    public String PUBLIC_DTE ;  //������
    public String ZPERNR     ;  //�븮��û�� ���
    public String ZUNAME     ;  //�μ��̸�
    public String AEDTM      ;  //������
    public String UNAME      ;  //������̸�
    public String APPL_TEXT2 ;  //��û�����ؽ�Ʈ
    public String APPL_TEXT3 ;  //������׺����ؽ�Ʈ
    public String APPL_TEXT4 ;  //�߰��߱� �ؽ�Ʈ
    public String APPL_TEXT5 ;  //��߱��ؽ�Ʈ
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
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getSUBTY() {
		return SUBTY;
	}
	public void setSUBTY(String sUBTY) {
		SUBTY = sUBTY;
	}
	public String getOBJPS() {
		return OBJPS;
	}
	public void setOBJPS(String oBJPS) {
		OBJPS = oBJPS;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getAPPL_TYPE2() {
		return APPL_TYPE2;
	}
	public void setAPPL_TYPE2(String aPPL_TYPE2) {
		APPL_TYPE2 = aPPL_TYPE2;
	}
	public String getAPPL_TYPE3() {
		return APPL_TYPE3;
	}
	public void setAPPL_TYPE3(String aPPL_TYPE3) {
		APPL_TYPE3 = aPPL_TYPE3;
	}
	public String getETC_TEXT3() {
		return ETC_TEXT3;
	}
	public void setETC_TEXT3(String eTC_TEXT3) {
		ETC_TEXT3 = eTC_TEXT3;
	}
	public String getCHNG_BEFORE() {
		return CHNG_BEFORE;
	}
	public void setCHNG_BEFORE(String cHNG_BEFORE) {
		CHNG_BEFORE = cHNG_BEFORE;
	}
	public String getCHNG_AFTER() {
		return CHNG_AFTER;
	}
	public void setCHNG_AFTER(String cHNG_AFTER) {
		CHNG_AFTER = cHNG_AFTER;
	}
	public String getAPPL_TYPE4() {
		return APPL_TYPE4;
	}
	public void setAPPL_TYPE4(String aPPL_TYPE4) {
		APPL_TYPE4 = aPPL_TYPE4;
	}
	public String getADD_NUM() {
		return ADD_NUM;
	}
	public void setADD_NUM(String aDD_NUM) {
		ADD_NUM = aDD_NUM;
	}
	public String getETC_TEXT4() {
		return ETC_TEXT4;
	}
	public void setETC_TEXT4(String eTC_TEXT4) {
		ETC_TEXT4 = eTC_TEXT4;
	}
	public String getAPPL_TYPE5() {
		return APPL_TYPE5;
	}
	public void setAPPL_TYPE5(String aPPL_TYPE5) {
		APPL_TYPE5 = aPPL_TYPE5;
	}
	public String getETC_TEXT5() {
		return ETC_TEXT5;
	}
	public void setETC_TEXT5(String eTC_TEXT5) {
		ETC_TEXT5 = eTC_TEXT5;
	}
	public String getADD_NUM1() {
		return ADD_NUM1;
	}
	public void setADD_NUM1(String aDD_NUM1) {
		ADD_NUM1 = aDD_NUM1;
	}
	public String getPUBLIC_DTE() {
		return PUBLIC_DTE;
	}
	public void setPUBLIC_DTE(String pUBLIC_DTE) {
		PUBLIC_DTE = pUBLIC_DTE;
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
	public String getAPPL_TEXT2() {
		return APPL_TEXT2;
	}
	public void setAPPL_TEXT2(String aPPL_TEXT2) {
		APPL_TEXT2 = aPPL_TEXT2;
	}
	public String getAPPL_TEXT3() {
		return APPL_TEXT3;
	}
	public void setAPPL_TEXT3(String aPPL_TEXT3) {
		APPL_TEXT3 = aPPL_TEXT3;
	}
	public String getAPPL_TEXT4() {
		return APPL_TEXT4;
	}
	public void setAPPL_TEXT4(String aPPL_TEXT4) {
		APPL_TEXT4 = aPPL_TEXT4;
	}
	public String getAPPL_TEXT5() {
		return APPL_TEXT5;
	}
	public void setAPPL_TEXT5(String aPPL_TEXT5) {
		APPL_TEXT5 = aPPL_TEXT5;
	}

}
