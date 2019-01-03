package	hris.E.E12Stock;

/**
 * E12StockCodeData.java
 * 증권계좌 코드 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_P_STOCK_CODE
 * 
 * @author 김도신    
 * @version 1.0, 2002/01/08
 */
public class E12StockCodeData extends com.sns.jdf.EntityData {
    public String MANDT    ;			// 클라이언트
    public String SPRAS    ;			// 언어키
    public String SECU_CODE;      // 증권회사
    public String SECU_NAME;      // 증권회사명
}










