package hris.common;
/**
 * AccountData.java
 *   계좌번호, 은행명
 *   [관련 RFC] : ZHRW_RFC_GET_ACCOUNT_INFO
 *
 * @author 김성일
 * @version 1.0, 2002/01/05
 */
public class AccountData extends com.sns.jdf.EntityData
{
    public String LIFNR;       // 구매처 또는 채권자 계정번호
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
	public String BANKS;       // 은행국가키
    public String BANKL;       // 은행 키
    public String BANKN;       // 은행계좌번호
    public String BKONT;       // 은행관리키
    public String BVTYP;       // 거래처은행유형
    public String XEZER;       // 지시자: 추심권한이 있습니까?
    public String BKREF;       // 은행명세에 관한 참조명세
    public String KOINH;       // 예금주명
    public String BANKA;       // 은행명
}