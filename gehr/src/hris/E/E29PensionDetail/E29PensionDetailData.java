package	hris.E.E29PensionDetail;

/**
 * PensionDetailData.java
 * 개인별 누계내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRW_PENSION_TOTAL_DISPLAY 
 * 
 * @author 이형석    
 * @version 1.0, 2002/01/29
 */
public class E29PensionDetailData extends com.sns.jdf.EntityData {
    
    public String E_LNMHG    ;	   // 성 (한글)
    public String E_FNMHG    ;	   // 이름 (한글)
    public String E_REGNO    ;     // 주민등록번호 
    public String E_GRADE    ;     // 등급 
    public String E_BEGDA    ;     //시작일 
    public String E_MY_PAYMENT;    // 본인부담금
    public String E_FIRM_PAYMENT;  // 회사부담금
    public String E_TOTAL_PAYMENT; // 총불입금액
    public String E_RETIRE_PAYMENT; // 퇴직전환금
    public String E_PENI_AMNT ; 
    public String E_PENC_AMNT ;
    public String E_PENB_AMNT ;
    public String PAYDT;        //시작일
    public String GRADE;        //등급
    public String LGART;        //임금유형
    public String BETRG;        //HR 급여관리: 금액
    
}

