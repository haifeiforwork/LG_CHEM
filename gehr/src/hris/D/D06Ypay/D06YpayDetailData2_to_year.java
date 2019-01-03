package	hris.D.D06Ypay;

/**
 * D06YpayDetailData2_to_year.java
 * 2003.01.13 연말정산용으로 연급여를 만듬 
 * 과세추가내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRP_GET_PAY_INFO
 * 
 * @author 최영호    
 * @version 1.0, 2003/01/13
 * @version 1.1, 2008/09/03
 */
public class D06YpayDetailData2_to_year extends com.sns.jdf.EntityData {

    public String LGTX1 ;   // 과세추가내역1
    public String LGTX2 ;   // 과세추가내역2
    public String LGTX3 ;   // 과세추가내역3
    public String BET01 ;   // 과세액1
    public String BET02 ;   // 과세액2
    public String BET03 ;   // 과세액3
    public String YYMMDD;   // 과세 년월 
    public String BET04 ;   // 생산직비과세추 @v1.1
    public String LGTX4 ;   // 과세추가내역1
}