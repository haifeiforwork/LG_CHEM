package hris.D.D09Bond ;

/**
 * D09BondListData.java
 *  채권 압류 현황을 담는 데이터
 *   [관련 RFC] : ZHRP_RFC_BOND_PRESENTSTATE
 * 
 * @author 한성덕
 * @version 1.0, 2002/02/27
 */
public class D09BondListData extends com.sns.jdf.EntityData {
    public String BEGDA     ;      // 접수일
    public String ENDDA     ;      // 해지일
    public String CRED_NAME ;      // 채권자
    public String CRED_NUMB ;      // 채권자 ID
    public String SEQN_NUMB ;      // 일련번호
    public String CRED_AMNT ;      // 가압류액
    public String GIVE_AMNT ;      // 지급액
    public String REST_AMNT ;      // 가압류잔액
    public String DPOT_CHRG ;      // 공탁수수료
    public String CRED_ADDR ;      // 주소
    public String MGTT_NUMB ;      // 관리번호
    public String CRED_CODE ;      // 채권사유 코드
    public String CRED_TEXT ;      // 채권사유
}
