package	hris.D.D06Ypay;

/**
 * D06YpayDetailData3.java
 * 과세추가내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRP_GET_PAY_INFO
 * 
 * @author 최영호    
 * @version 1.0, 2002/07/23
 */
public class D06YpayDetailData3 extends com.sns.jdf.EntityData {

    public String LGTX1 ;   // 노조비내역
    public String LGTX2 ;   // 노조비내역
    public String LGTX3 ;   // 노조비내역
    public String BET01 ;   // 노조비
    public String BET02 ;   // 노조비
    public String BET03 ;   // 노조비
    public String YYMMDD;   // 해당 년월 
}