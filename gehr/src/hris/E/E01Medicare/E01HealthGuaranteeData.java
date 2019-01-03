/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ǰ����� �Ǻξ��� ��û                                      */
/*   Program Name : �ǰ����� �Ǻξ��� ��û                                      */
/*   Program ID   : E01HealthGuaranteeData                                      */
/*   Description  : �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û ������               */
/*   Note         : [���� RFC] : ZHRW_RFC_HEALTH_GUARANTEE                      */
/*   Creation     : 2002-01-29  �赵��                                          */
/*   Update       : 2005-02-22  ������                                          */
/*                                                                              */
/********************************************************************************/
package hris.E.E01Medicare;

public class E01HealthGuaranteeData extends com.sns.jdf.EntityData {

    public String MANDT         ;  // Ŭ���̾�Ʈ
    public String PERNR         ;  // �����ȣ
    public String AINF_SEQN     ;  // �������� �Ϸù�ȣ
    public String BEGDA         ;  // ��û��
    public String INDX_NUMB     ;  // ����
    public String APPL_TYPE     ;  // �ǰ����� �Ǻξ��� �ڰ�/��� ��û����
    public String SUBTY         ;  // �Ϻ�����
    public String OBJPS         ;  // ������Ʈ�ĺ�
    public String ACCQ_LOSS_DATE;  // ���/�������
    public String ACCQ_LOSS_TYPE;  // �ǰ����� �Ǻξ��� �ڰ� ��û(���/���)����
    public String HITCH_TYPE    ;  // ����� ���� ��ȣ
    public String HITCH_GRADE   ;  // ��ֵ��
    public String HITCH_DATE    ;  // ��ֵ����
    public String PUBLIC_DTE    ;  // ������
    public String ZPERNR        ;  // �븮��û�� ���
    public String ZUNAME        ;  // �μ����� �̸�
    public String AEDTM         ;  // ������
    public String APRT_CODE     ;  // ����Ȯ��
    public String ENAME         ;  // ��� �Ǵ� �������� �����̸�
    public String UNAME         ;  // ������̸�
    public String APPL_TEXT     ;  // �ǰ����� �Ǻξ��� ��û���� �ؽ�Ʈ
    public String ACCQ_LOSS_TEXT;  // �ǰ����� �Ǻξ��� ��� ��� �ؽ�Ʈ
    public String HITCH_TEXT    ;  // ����� ���� ��ȣ ��� �ؽ�Ʈ
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
	public String getINDX_NUMB() {
		return INDX_NUMB;
	}
	public void setINDX_NUMB(String iNDX_NUMB) {
		INDX_NUMB = iNDX_NUMB;
	}
	public String getAPPL_TYPE() {
		return APPL_TYPE;
	}
	public void setAPPL_TYPE(String aPPL_TYPE) {
		APPL_TYPE = aPPL_TYPE;
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
	public String getACCQ_LOSS_DATE() {
		return ACCQ_LOSS_DATE;
	}
	public void setACCQ_LOSS_DATE(String aCCQ_LOSS_DATE) {
		ACCQ_LOSS_DATE = aCCQ_LOSS_DATE;
	}
	public String getACCQ_LOSS_TYPE() {
		return ACCQ_LOSS_TYPE;
	}
	public void setACCQ_LOSS_TYPE(String aCCQ_LOSS_TYPE) {
		ACCQ_LOSS_TYPE = aCCQ_LOSS_TYPE;
	}
	public String getHITCH_TYPE() {
		return HITCH_TYPE;
	}
	public void setHITCH_TYPE(String hITCH_TYPE) {
		HITCH_TYPE = hITCH_TYPE;
	}
	public String getHITCH_GRADE() {
		return HITCH_GRADE;
	}
	public void setHITCH_GRADE(String hITCH_GRADE) {
		HITCH_GRADE = hITCH_GRADE;
	}
	public String getHITCH_DATE() {
		return HITCH_DATE;
	}
	public void setHITCH_DATE(String hITCH_DATE) {
		HITCH_DATE = hITCH_DATE;
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
	public String getAPRT_CODE() {
		return APRT_CODE;
	}
	public void setAPRT_CODE(String aPRT_CODE) {
		APRT_CODE = aPRT_CODE;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getUNAME() {
		return UNAME;
	}
	public void setUNAME(String uNAME) {
		UNAME = uNAME;
	}
	public String getAPPL_TEXT() {
		return APPL_TEXT;
	}
	public void setAPPL_TEXT(String aPPL_TEXT) {
		APPL_TEXT = aPPL_TEXT;
	}
	public String getACCQ_LOSS_TEXT() {
		return ACCQ_LOSS_TEXT;
	}
	public void setACCQ_LOSS_TEXT(String aCCQ_LOSS_TEXT) {
		ACCQ_LOSS_TEXT = aCCQ_LOSS_TEXT;
	}
	public String getHITCH_TEXT() {
		return HITCH_TEXT;
	}
	public void setHITCH_TEXT(String hITCH_TEXT) {
		HITCH_TEXT = hITCH_TEXT;
	}


}
