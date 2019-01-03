package hris.common;

import com.sns.jdf.EntityData;

/**
 * EmpGubunData.java
 * [WorkTime52] ��� (�ٹ�)���� ���� ����
 * [���� RFC] : ZGHR_RFC_NTM_TPGUP_GET
 *
 * @author ��ȯ��
 * @version 1.0, 2018/05/16
 */
public class EmpGubunData extends EntityData {

	public String PERNR; 	// ��� ��ȣ
	public String BUKRS; 	// ȸ�� �ڵ�
	public String EMPGUB; 	// ��� ����(S:�繫��, H:������)
	public String TPGUB; 	// ��� �ٹ�����
	public String ADJPRD; 	// ����Ⱓ
	public String ADJUNT; 	// ����Ⱓ ����
	public String TWTYP; 	// �ѱٷνð� ����
	public String FXTIM; 	// �����ð�

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

	public String getBUKRS() {
		return BUKRS;
	}

	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}

	public String getEMPGUB() {
		return EMPGUB;
	}

	public void setEMPGUB(String eMPGUB) {
		EMPGUB = eMPGUB;
	}

	public String getTPGUB() {
		return TPGUB;
	}

	public void setTPGUB(String tPGUB) {
		TPGUB = tPGUB;
	}

	public String getADJPRD() {
		return ADJPRD;
	}

	public void setADJPRD(String aDJPRD) {
		ADJPRD = aDJPRD;
	}

	public String getADJUNT() {
		return ADJUNT;
	}

	public void setADJUNT(String aDJUNT) {
		ADJUNT = aDJUNT;
	}

	public String getTWTYP() {
		return TWTYP;
	}

	public void setTWTYP(String tWTYP) {
		TWTYP = tWTYP;
	}

	public String getFXTIM() {
		return FXTIM;
	}

	public void setFXTIM(String fXTIM) {
		FXTIM = fXTIM;
	}

}
