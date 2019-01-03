package	hris.D.D06Ypay;

/**
 * D06YpayTaxDetailData_to_year.java
 * 2003.01.13 연말정산용으로 연급여를 만듬 
 * 연말정산 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRP_RFC_READ_YEA_RESULT
 * 
 * @author 최영호    
 * @version 1.0, 2003/01/13
 */
public class D06YpayTaxDetailData_to_year extends com.sns.jdf.EntityData {

    public String YAI ;   // 갑근세
    public String YAR ;   // 주민세
    public String YAS ;   // 농특세
    public String TAX ;   // 세액조정액  5월 22일 추가 
    public String YIC ;   // 인정이자분 7월 25일 추가 
    public String YFE ;   // 고용보험료 환급액 2003.01.15
}
