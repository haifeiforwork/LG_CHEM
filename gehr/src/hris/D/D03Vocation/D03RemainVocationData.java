/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �ް���������                                                */
/*   Program Name : �ް���������                                                */
/*   Program ID   : D03RemainVocationData                                    */
/*   Description  : Leave management Data               */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2007-09-13  zhouguangwen  global e-hr update                                                            */
/*				  : 2018-05-17  ��ȯ�� [WorkTime52] �����ް� �߰� ��
/*  Global��ġ */
/********************************************************************************/

package hris.D.D03Vocation;

/**
 * D03RemainVocationData.java
 * ������ �ܿ��ް��ϼ� ������ ��ƿ��� ������
 *   [���� RFC] : ZHRW_RFC_GET_REMAIN_HOLIDAY
 *
 * @author �赵��
 * @version 1.0, 2002/01/21
 */
public class D03RemainVocationData extends com.sns.jdf.EntityData {

	public String getZKVRB() {
		return ZKVRB;
	}

	public void setZKVRB(String zKVRB) {
		ZKVRB = zKVRB;
	}

	public String E_REMAIN; // ���� �ܿ��ް��ϼ�
	// public String E_REMAIN0 ; // ���ظ� �������� D-1�� �ܿ��ް��ϼ�
	// public String E_REMAIN1 ; // ���� �ܿ��ް��ϼ�
	// public String E_REMAIN2 ; // ���ظ� �������� D+1�� �ܿ��ް��ϼ�

	// public String P_FROM0 ; // ���ظ� �������� D-1�� ������
	// public String P_TOXX0 ; // ���ظ� �������� D-1�� ������
	// public String P_FROM1 ; // ���� ������
	// public String P_TOXX1 ; // ���� ������
	// public String P_FROM2 ; // ���ظ� �������� D+1�� ������
	// public String P_TOXX2 ; // ���ظ� �������� D+1�� ������

	public String E_IS_SHIFT; // ��ġ����
	public String E_RETURN;

	public String ANZHL_GEN; // Total Generated
	public String ANZHL_USE; // Total Used
	public String ANZHL_BAL; // Total Balance
	public String BUKRS; // Company Code
	public String CSDAT; // Initial Date of Continuous Service

	public String OCCUR; // ����:�����ϼ�
	public String ABWTG; // ����:����ϼ�
	public String ZKVRB; // ����:�ܿ��ϼ�

	// @rdcamel �߰� (�����ް���) 2016.12.15
	public String OCCUR3; // �����ް�
	public String ABWTG3; // �����ް� ��밹��
	public String ZKVRB3; // �ܿ�
	
	// ��ȯ�� �߰� [Worktime52] 2018.05.16
	public String ZKVRBTX; 	// �ܿ��ް� TEXT
	public String E_COMP; 	// �����ް� �켱���� ����(Null:�����ް� �켱����, X: �����ް� �켱����)

	public String getE_RETURN() {
		return E_RETURN;
	}

	public void setE_RETURN(String e_RETURN) {
		E_RETURN = e_RETURN;
	}

	public String getANZHL_GEN() {
		return ANZHL_GEN;
	}

	public void setANZHL_GEN(String aNZHL_GEN) {
		ANZHL_GEN = aNZHL_GEN;
	}

	public String getANZHL_USE() {
		return ANZHL_USE;
	}

	public void setANZHL_USE(String aNZHL_USE) {
		ANZHL_USE = aNZHL_USE;
	}

	public String getANZHL_BAL() {
		return ANZHL_BAL;
	}

	public void setANZHL_BAL(String aNZHL_BAL) {
		ANZHL_BAL = aNZHL_BAL;
	}

	public String getBUKRS() {
		return BUKRS;
	}

	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}

	public String getCSDAT() {
		return CSDAT;
	}

	public void setCSDAT(String cSDAT) {
		CSDAT = cSDAT;
	}

	public String getOCCUR() {
		return OCCUR;
	}

	public void setOCCUR(String oCCUR) {
		OCCUR = oCCUR;
	}

	public String getABWTG() {
		return ABWTG;
	}

	public void setABWTG(String aBWTG) {
		ABWTG = aBWTG;
	}

	public String getE_REMAIN() {
		return E_REMAIN;
	}

	public void setE_REMAIN(String E_REMAIN) {
		E_REMAIN = E_REMAIN;
	}

	public String getE_IS_SHIFT() {
		return E_IS_SHIFT;
	}

	public void setE_IS_SHIFT(String E_IS_SHIFT) {
		E_IS_SHIFT = E_IS_SHIFT;
	}

	// @rdcamel �߰� (�����ް���) 2016.12.15
	public void set_OCCUR3(String oCCUR3) {
		OCCUR3 = oCCUR3;
	}

	public String getOCCUR3() {
		return OCCUR3;
	}

	public void set_ABWTG3(String aBWTG3) {
		ABWTG3 = aBWTG3;
	}

	public String getABWTG3() {
		return ABWTG3;
	}

	public void set_ZKVRB3(String zKVRB3) {
		ZKVRB3 = zKVRB3;
	}

	public String getZKVRB3() {
		return ZKVRB3;
	}

	public String getZKVRBTX() {
		return ZKVRBTX;
	}

	public void setZKVRBTX(String zKVRBTX) {
		ZKVRBTX = zKVRBTX;
	}

	public String getE_COMP() {
		return E_COMP;
	}

	public void setE_COMP(String E_COMP) {
		E_COMP = E_COMP;
	}

}