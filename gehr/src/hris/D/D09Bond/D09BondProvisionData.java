package hris.D.D09Bond ;

/**
 * D09BondProvisionData.java
 *  채권 압류 지급 현황을 담는 데이터
 *   [관련 RFC] : ZHRP_RFC_BOND_RECEIPT
 * 
 * @author 한성덕
 * @version 1.0, 2002/01/24
 */
public class D09BondProvisionData extends com.sns.jdf.EntityData {
    public String BOND_TYPE ;  // 구분
    public String BEGDA     ;  // 지급일자
    public String CRED_NAME ;  // 채권자
    public String CRED_NUMB ;  // 채권자 ID - 관리번호
    public String GIVE_AMNT ;  // 지급(배정)액
    public String DPOT_CHRG ;  // 공탁수수료
    public String RECV_NAME ;  // 수령자
    public String SEQN_NUMB ;  // 관리번호
    public String BANK_TEXT ;  // 수령은행
    public String BANK_NUMB ;  // 지급계좌
    public String FIRE_FLAG ;  // 해지체크 'X'면 해지
    public String DPOT_DATE ;  // 공탁일자
}
