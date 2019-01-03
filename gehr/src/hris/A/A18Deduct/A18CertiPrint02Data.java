package hris.A.A18Deduct ;

/**
 * A18CertiPrint02Data.java
 * 갑종근로소득 영수증:급여 정보(T_RESULT)
 * [RFC] ,ZHRP_RFC_READ_YEA_RESULT_PRIN2
 * 
 * @author  김도신 
 * @version 1.0, 2005/09/29
 */
public class A18CertiPrint02Data extends com.sns.jdf.EntityData {
    public String YYYYMM   ; // 연월
    public String TOT_PAY  ; // 급여액
    public String TOT_TAX  ; // 세액
    public String YYYYMMDD ; // 납부연월일
}
