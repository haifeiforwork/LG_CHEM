package hris.common;
/**
 * AccountData.java
 *   ���¹�ȣ, �����
 *   [���� RFC] : ZHRW_RFC_GET_ACCOUNT_INFO
 *
 * @author �輺��
 * @version 1.0, 2002/01/05
 */
public class AccountData extends com.sns.jdf.EntityData
{
    public String LIFNR;       // ����ó �Ǵ� ä���� ������ȣ
    public String getLIFNR() {
		return LIFNR;
	}
	public void setLIFNR(String lIFNR) {
		LIFNR = lIFNR;
	}
	public String getBANKS() {
		return BANKS;
	}
	public void setBANKS(String bANKS) {
		BANKS = bANKS;
	}
	public String getBANKL() {
		return BANKL;
	}
	public void setBANKL(String bANKL) {
		BANKL = bANKL;
	}
	public String getBANKN() {
		return BANKN;
	}
	public void setBANKN(String bANKN) {
		BANKN = bANKN;
	}
	public String getBKONT() {
		return BKONT;
	}
	public void setBKONT(String bKONT) {
		BKONT = bKONT;
	}
	public String getBVTYP() {
		return BVTYP;
	}
	public void setBVTYP(String bVTYP) {
		BVTYP = bVTYP;
	}
	public String getXEZER() {
		return XEZER;
	}
	public void setXEZER(String xEZER) {
		XEZER = xEZER;
	}
	public String getBKREF() {
		return BKREF;
	}
	public void setBKREF(String bKREF) {
		BKREF = bKREF;
	}
	public String getKOINH() {
		return KOINH;
	}
	public void setKOINH(String kOINH) {
		KOINH = kOINH;
	}
	public String getBANKA() {
		return BANKA;
	}
	public void setBANKA(String bANKA) {
		BANKA = bANKA;
	}
	public String BANKS;       // ���౹��Ű
    public String BANKL;       // ���� Ű
    public String BANKN;       // ������¹�ȣ
    public String BKONT;       // �������Ű
    public String BVTYP;       // �ŷ�ó��������
    public String XEZER;       // ������: �߽ɱ����� �ֽ��ϱ�?
    public String BKREF;       // ������� ���� ������
    public String KOINH;       // �����ָ�
    public String BANKA;       // �����
}