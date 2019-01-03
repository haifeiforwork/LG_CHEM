package	hris.E.E10Personal;

/**
 * E10PentionMoneyData.java
 * 개인연금/마이라이프 지원액 조회
 *   [관련 RFC] : ZHRW_RFC_PENTION_MONEY
 * 
 * @author 김도신
 * @version 1.0, 2002/10/10
 */
public class E10PentionMoneyData extends com.sns.jdf.EntityData {

    public String MANDT   ;        // 클라이언트
    public String BURKS   ;        // 회사코드
    public String BEGDA   ;        // 시작일
    public String ENDDA   ;        // 종료일
    public String GUBUN   ;        // 연금구분
    public String DEDUCT  ;        // 공제액
    public String WAERS1  ;        // 통화키
    public String ASSIST  ;        // 지원액
    public String WAERS2  ;        // 통화키
    public String DISCOUNT;        // 할인금액
    public String WAERS3  ;        // 통화키

}