package	hris.D.D05Mpay;

/**
 * D05MpayDetailData2.java
 * ���޳���/�������� ������ ��ƿ��� ������
 *   [���� RFC] : ZGHR_GET_PAY_INFO
 *  T_PAYLST
 * @author �ֿ�ȣ    
 * @version 1.0, 2002/01/28
 */
public class D05MpayDetailData2 extends com.sns.jdf.EntityData {

    public String LGTXT ;   // ���޳���
    public String LGTX1 ;   // ��������
    public String ANZHL ;   // �ð�
    public String BET01 ;   // ���޾�
    public String BET02 ;   // ������
	public String getLGTXT() {
		return LGTXT;
	}
	public void setLGTXT(String lGTXT) {
		LGTXT = lGTXT;
	}
	public String getLGTX1() {
		return LGTX1;
	}
	public void setLGTX1(String lGTX1) {
		LGTX1 = lGTX1;
	}
	public String getANZHL() {
		return ANZHL;
	}
	public void setANZHL(String aNZHL) {
		ANZHL = aNZHL;
	}
	public String getBET01() {
		return BET01;
	}
	public void setBET01(String bET01) {
		BET01 = bET01;
	}
	public String getBET02() {
		return BET02;
	}
	public void setBET02(String bET02) {
		BET02 = bET02;
	}

}
