package	hris.A;

/**
 * A03AccountDetail2Data.java
 * 증권계좌 조회 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_BANK_STOCK_LIST
 * 
 * @author 김도신    
 * @version 1.0, 2002/01/07
 */
public class A03AccountDetail2Data extends com.sns.jdf.EntityData {
    public String AINF_SEQN;			// 결재정보 일련번호
    public String PERNR    ;			// 사원번호
    public String BEGDA    ;      // 신청일
    public String BANK_FLAG;      // 구분(은행/증권)
    public String SECU_CODE;			// 증권회사
    public String SECU_NAME;			// 증권회사명
    public String GAPP_CONT;			// 증권계좌
}










