package hris.A.A18Deduct ;

/**
 * A18CertiPrintBusiData.java
 * 근로소득원천징수영수증:사업장 정보(T_BUSINESSPLACE)
 * [RFC] ,ZHRP_RFC_READ_YEA_RESULT_PRINT
 * 
 * @author  김도신 
 * @version 1.0, 2005/09/29
 */
public class A18CertiPrintBusiData extends com.sns.jdf.EntityData {
    public String BUKRS        ; // 회사코드      
    public String BRANCH       ; // 사업장        
    public String NAME         ; // 성            
    public String CGC_NUMBER   ; // CGC 코드      
    public String ADRNR        ; // 주소          
    public String STCD1        ; // 주민등록번호  
    public String STCD2        ; // 사업자등록번호
    public String KR_REPRES    ; // 대표자성명    
    public String KR_BUSTYPE   ; // 사업유형(업태)
    public String KR_INDTYPE   ; // 산업유형(업종)
    public String KR_TAXOFF    ; // 세무서        
    public String TAXOFF       ; // 세무서        
    public String ADDRESS_LINE ; // 문자 100      
    public String POSTAL_CODE  ; // 도시우편번호  
    public String PHONE_NUMBER ; // 문자 20       
}
