package	hris.D.D03Vocation;

/**
 * D03GetWorkdayData.java
 * ������ �ް���û ������ ��ƿ��� ������
 *   [���� RFC] : ZHRP_GET_NO_OF_WORKDAY
 *  Global ��ġ
 * @author ��α�
 * @version 1.0, 2004/07/13
 * 
 * UPDATE		: 2018-05-17 ��ȯ�� [WorkTime52] �����ް� �߰� ��
 * update       : 2018/06/08 rdcamel [CSR ID:3700538] �����ް��� ���Կ� ���� Mobile �ް���û �� ����ȭ�� ���� ��û ��
 */
public class D03GetWorkdayData extends com.sns.jdf.EntityData {
    public String PERNR		;		// �����ȣ
    public String KSOLL		;		// �����ϼ�
    public String ABWTG		;		// ����ް�
    public String ZKVRB		;		// �ܿ��ް�
    public String OCCUR		;		// �߻��ϼ�
    public String OCCUR1	;		// �����ο��ް� �߻��ϼ�
	public String ABWTG1    ;       // �����ο��ް� ����ϼ�
	public String ZKVRB1	;		// �����ο��ް� �ܿ��ϼ�
	public String OCCUR2	;		// �����������ް� �߻��ϼ�
	public String ABWTG2	;		// �����������ް� ����ϼ�
	public String ZKVRB2	;		// �����������ް� �ܿ��ϼ�
	public String ZKVRBTX	;		// �ܿ��ް� TEXT
	
	//[CSR ID:3700538] �����ް��� ���Կ� ���� Mobile �ް���û �� ����ȭ�� ���� ��û ��
	public String RDAYS;//�ܿ������ް��ϼ�
	public String RHOURS; //�ܿ������ް��ð�
	public String REMAINT;//�ܿ� �ް� �ϼ� text
	
	
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getKSOLL() {
		return KSOLL;
	}
	public void setKSOLL(String kSOLL) {
		KSOLL = kSOLL;
	}
	public String getABWTG() {
		return ABWTG;
	}
	public void setABWTG(String aBWTG) {
		ABWTG = aBWTG;
	}
	public String getZKVRB() {
		return ZKVRB;
	}
	public void setZKVRB(String zKVRB) {
		ZKVRB = zKVRB;
	}
	public String getOCCUR() {
		return OCCUR;
	}
	public void setOCCUR(String oCCUR) {
		OCCUR = oCCUR;
	}
	public String getOCCUR1() {
		return OCCUR1;
	}
	public void setOCCUR1(String oCCUR1) {
		OCCUR1 = oCCUR1;
	}
	public String getABWTG1() {
		return ABWTG1;
	}
	public void setABWTG1(String aBWTG1) {
		ABWTG1 = aBWTG1;
	}
	public String getZKVRB1() {
		return ZKVRB1;
	}
	public void setZKVRB1(String zKVRB1) {
		ZKVRB1 = zKVRB1;
	}
	public String getOCCUR2() {
		return OCCUR2;
	}
	public void setOCCUR2(String oCCUR2) {
		OCCUR2 = oCCUR2;
	}
	public String getABWTG2() {
		return ABWTG2;
	}
	public void setABWTG2(String aBWTG2) {
		ABWTG2 = aBWTG2;
	}
	public String getZKVRB2() {
		return ZKVRB2;
	}
	public void setZKVRB2(String zKVRB2) {
		ZKVRB2 = zKVRB2;
	}
	public String getZKVRBTX() {
		return ZKVRBTX;
	}
	public void setZKVRBTX(String zKVRBTX) {
		ZKVRBTX = zKVRBTX;
	}
	public String getRDAYS() {
		return RDAYS;
	}
	public void setRDAYS(String rDAYS) {
		RDAYS = rDAYS;
	}
	public String getRHOURS() {
		return RHOURS;
	}
	public void setRHOURS(String rHOURS) {
		RHOURS = rHOURS;
	}
	
}
