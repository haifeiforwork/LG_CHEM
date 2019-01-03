package	hris.D.D06Ypay;

/**
 * D06YpayDetailData.java
 * 연급여내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRP_RFC_GET_TOTAL_SALARY
 * 
 * @author 최영호    
 * @version 1.0, 2002/01/30
 */
public class D06YpayDetailData extends com.sns.jdf.EntityData {

    public String ZYYMM;   // 년월일
    public String BET01;   // 급여
    public String BET02;   // 상여
    public String BET03;   // 성과급
    public String BET04;   // 지급계
    public String BET05;   // 갑근세
    public String BET06;   // 주민세
    public String BET07;   // 건강보험료
    public String BET08;   // 고용보험료
    public String BET09;   // 국민연금
    public String BET10;   // 과세반영금액
    public String BET11;   // 공제계  (5월 5일 수정)
    public String BET12;   // 차감지급액  (5월 5일 수정)
    
}                  
