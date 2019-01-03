package	hris.D.D05Mpay;

/**
 * D05MpayDetailData2.java
 * 지급내역/공제내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZGHR_GET_PAY_INFO
 *  T_PAYLST
 * @author 최영호    
 * @version 1.0, 2002/01/28
 */
public class D05MpayDetailData2 extends com.sns.jdf.EntityData {

    public String LGTXT ;   // 지급내역
    public String LGTX1 ;   // 공제내역
    public String ANZHL ;   // 시간
    public String BET01 ;   // 지급액
    public String BET02 ;   // 공제액
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
