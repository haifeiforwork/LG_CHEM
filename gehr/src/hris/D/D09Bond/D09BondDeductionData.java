package hris.D.D09Bond ;

/**
 * D09BondDeductionData.java
 *  채권 압류 공제 현황을 담는 데이터
 *   [관련 RFC] : ZHRP_RFC_BOND_DEDUCTION
 * 
 * @author 한성덕
 * @version 1.0, 2002/01/23
 */
public class D09BondDeductionData extends com.sns.jdf.EntityData {
    public String BEGDA   ;  // 공제월
    public String BETRG01 ;  // 정규급여
    public String BETRG02 ;  // 정규상여
    public String BETRG04 ;  // 비정규상여
    public String BETRG03 ;  // 퇴직금
    public String G_SUM   ;  // 공제액계
}
