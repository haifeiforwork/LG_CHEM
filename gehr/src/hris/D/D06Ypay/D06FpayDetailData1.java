package	hris.D.D06Ypay;

/**
 * D06FpayDetailData1.java
 * 지급내역/공제내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRP_GET_PAY_INFO
 * 
 * @author 최영호    
 * @version 1.0, 2002/02/04
 */
public class D06FpayDetailData1 extends com.sns.jdf.EntityData {

    public String LGTXT ;   // 지급내역
    public String LGTX1 ;   // 공제내역
    public String ANZHL ;   // 시간
    public String BET01 ;   // 지급액
    public String BET02 ;   // 공제액

}