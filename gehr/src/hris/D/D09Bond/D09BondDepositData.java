package hris.D.D09Bond ;

/**
 * D09BondDepositData.java
 *  채권 압류 공탁 현황을 담는 데이터
 *   [관련 RFC] : ZHRP_RFC_BOND_DEPOSITION
 * 
 * @author 한성덕
 * @version 1.0, 2002/01/24
 */
public class D09BondDepositData extends com.sns.jdf.EntityData {
    public String BEGDA     ;  // 공탁일
    public String DPOT_AMNT ;  // 실공탁액
    public String DPOT_CHRG ;  // 공탁수수료
    public String CORT_TITL ;  // 공탁법원
    public String DPO1_TEXT ;  // 
    public String DPO2_TEXT ;  //
    public String GIVE_AMNT ;  // 배당정리액(수수료포함) 
}
