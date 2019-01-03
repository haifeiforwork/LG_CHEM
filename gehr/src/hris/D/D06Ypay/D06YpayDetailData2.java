package	hris.D.D06Ypay;

/**
 * D06YpayDetailData2.java
 * 과세추가내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRP_GET_PAY_INFO
 * 
 * @author 최영호    
 * @version 1.0, 2002/07/23
 */
public class D06YpayDetailData2 extends com.sns.jdf.EntityData {

    public String LGTX1 ;   // 과세추가내역1
    public String LGTX2 ;   // 과세추가내역2
    public String LGTX3 ;   // 과세추가내역3
    public String BET01 ;   // 과세액1
    public String BET02 ;   // 과세액2
    public String BET03 ;   // 과세액3
    public String YYMMDD;   // 과세 년월 
}