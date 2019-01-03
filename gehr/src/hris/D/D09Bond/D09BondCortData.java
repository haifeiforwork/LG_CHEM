package hris.D.D09Bond ;

/**
 * D09BondCortData.java
 *  채권 이력 현황을 담는 데이터
 *   [관련 RFC] : ZHRP_RFC_BOND_CORT
 * 
 * @author 한성덕
 * @version 1.0, 2002/02/28
 */
public class D09BondCortData extends com.sns.jdf.EntityData {
    public String CRED_NUMB ;      // 채권자 ID
    public String SEQN_NUMB ;      // 일련번호
    public String CORT_IDXX ;      // 법원/사건번호
    public String ATTA_CODE ;      // 법원결정내용 코드
    public String LRIV_DATE ;      // 법무팀 접수일
    public String DEVY_ADDR ;      // 송달처
    public String ATTA_TEXT ;      // 법원결정내용
}
