package hris.E.E05House;

/**
 * E05LoanMoneyData.java
 * 주택융자한도금액
 *   [관련 RFC] : ZHRW_RFC_HOUSE_LOAN_MONEY
 * 
 * @author 김성일 
 * @version 1.0, 2001/12/13
 */
public class E05LoanMoneyData extends com.sns.jdf.EntityData
{
    public String MANDT     ;       // 클라이언트
    public String BUKRS     ;       // 회사코드
    public String LOAN_CODE ;       // 주택융자코드
    public String MIN_YEAR  ;       // 근속년수(MIN)
    public String MAX_YEAR  ;       // 근속년수(MAX)
    public String LOAN_MONY ;       // 융자한도 금액
    public String REMARK_TXT;       // 이자율(융자한도)

}
