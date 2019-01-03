package	hris.D.D05Mpay;

/**
 * D05MpayDetailData3.java
 * 과세추가내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZGHR_GET_PAY_INFO
 *  T_TAXLST
 * @author 최영호    
 * @version 1.0, 2002/01/28
 */
public class D05MpayDetailData3 extends com.sns.jdf.EntityData {

    public String LGTX1 ;   // 과세추가내역1
    public String LGTX2 ;   // 과세추가내역2
    public String LGTX3 ;   // 과세추가내역3
    public String BET01 ;   // 과세액1
    public String BET02 ;   // 과세액2
    public String BET03 ;   // 과세액3
    public String BET04 ;   // 과세액1
    public String BET05 ;   // 과세액2
    public String BET06 ;   // 과세액3
	public String getLGTX1() {
		return LGTX1;
	}
	public void setLGTX1(String lGTX1) {
		LGTX1 = lGTX1;
	}
	public String getLGTX2() {
		return LGTX2;
	}
	public void setLGTX2(String lGTX2) {
		LGTX2 = lGTX2;
	}
	public String getLGTX3() {
		return LGTX3;
	}
	public void setLGTX3(String lGTX3) {
		LGTX3 = lGTX3;
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
	public String getBET03() {
		return BET03;
	}
	public void setBET03(String bET03) {
		BET03 = bET03;
	}
	public String getBET04() {
		return BET04;
	}
	public void setBET04(String bET04) {
		BET04 = bET04;
	}
	public String getBET05() {
		return BET05;
	}
	public void setBET05(String bET05) {
		BET05 = bET05;
	}
	public String getBET06() {
		return BET06;
	}
	public void setBET06(String bET06) {
		BET06 = bET06;
	}
    
}