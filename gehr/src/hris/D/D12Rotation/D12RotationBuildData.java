package hris.D.D12Rotation ;

/**
 * D12RotationData.java
 * �����μ���������
 *   [���� RFC] : ZHRW_RFC_DAY_CHART
 * @author ������
 * @version 1.0, 2009/02/24
 */
public class D12RotationBuildData extends com.sns.jdf.EntityData {

	public String SEQNO    ;
	public String PERNR    ;  //��� ��ȣ
    public String ENAME    ;  //��� �Ǵ� �������� ���˵� �̸�
    public String BEGDA    ;  //��û��
    public String QUATA    ;  //�ܿ��ް��ϼ�
    public String SUBTY    ;
    public String ATEXT    ;
    public String ACODE    ;
    public String ATIME    ;
    public String APPR_STAT;
	public String getSEQNO() {
		return SEQNO;
	}
	public void setSEQNO(String sEQNO) {
		SEQNO = sEQNO;
	}
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getQUATA() {
		return QUATA;
	}
	public void setQUATA(String qUATA) {
		QUATA = qUATA;
	}
	public String getSUBTY() {
		return SUBTY;
	}
	public void setSUBTY(String sUBTY) {
		SUBTY = sUBTY;
	}
	public String getATEXT() {
		return ATEXT;
	}
	public void setATEXT(String aTEXT) {
		ATEXT = aTEXT;
	}
	public String getACODE() {
		return ACODE;
	}
	public void setACODE(String aCODE) {
		ACODE = aCODE;
	}
	public String getATIME() {
		return ATIME;
	}
	public void setATIME(String aTIME) {
		ATIME = aTIME;
	}
	public String getAPPR_STAT() {
		return APPR_STAT;
	}
	public void setAPPR_STAT(String aPPR_STAT) {
		APPR_STAT = aPPR_STAT;
	}


}
