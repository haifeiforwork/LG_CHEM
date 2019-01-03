package	hris.D.D06Ypay;

/**
 * D06YpayDetailData4.java
 * export1정보를 담아오는 데이터
 *   [관련 RFC] : ZHRP_GET_PAY_INFO
 * 
 * @author 최영호    
 * @version 1.0, 2002/11/13
 */
public class D06YpayDetailData4 extends com.sns.jdf.EntityData {

    public String PERNR ;   // 사원번호
    public String ENAME ;   // 사원명
    public String BUKRS ;   // 회사코드
    public String ORGEH ;   // 소속부서코드
    public String ORGTX ;   // 조직단위텍스트
    public String BET01 ;   // 총지급액
    public String BET02 ;   // 공제총액
    public String BET03 ;   // 차감지급액
    public String BET04 ;   // 국내생계비
    public String BET05 ;   // 국내주택비
    public String BET06 ;   // 국내총액
    public String BET07 ;   // 국내갑근세
    public String BET08 ;   // 국내주민세
    public String BET09 ;   // 세후총액
    public String BET10 ;   // 해외수당
    public String BET11 ;   // 급지수당
    public String BET12 ;   // 국내net
    public String BET13 ;   // 국내입금액
    public String BET14 ;   // 해외송금액
    public String BET15 ;   // 해외송금액(현지화)
    public String BET18 ;   // 기능직 일급금액
    public String BET19 ;   // 생산직비과세  11월 13일 추가 CYH
    public String WRK01 ;   // 근태일수
    public String WRK02 ;   // 사용휴가일수
    public String WRK03 ;   // 잔여휴가일수
    public String ZRATE ;   // 환률
    public String ZCURR ;   // 사용통화

}