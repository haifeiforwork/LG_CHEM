package	hris.E.E09House;

/**
 * E09HouseData.java
 * 개인의 주거지원 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRW_RFC_HOUSE_FUND_DISPLAY 
 * 
 * @author 이형석    
 * @version 1.0, 2002/12/23
 */
public class E09HouseData extends com.sns.jdf.EntityData {
    
    public String BEGDA      ;	// 시작일
    public String DATBW      ;	// 승인일
    public String ENDDA      ;	// 종료일
    public String SUBTY      ;  // 융자형태 코드
    public String STEXT      ;  // 융자형태텍스트  
    public String DARBT      ;  // 승인된 대출금액 
    public String BETRG      ;  // 상환원금
    public String REDEMPTION ;  // 잔여원금
    public String ZAHLD      ;  // 상환완료일자
    public String REDARBT    ;  // 일시상환금액
    public String OPELO      ;  // 대출밸런스
    public String FLAG       ;  // 상환완료여부 체크
    public String INTSP       ;  // 이자지원(보상명세서 추가)[CSR ID:2995203] 
    public String INTSP_YR       ;  // 이자지원액(당해)(보상명세서 추가)[CSR ID:2995203] 

}
