package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustPensionCodeData.java
 * 연말정산 - 연금구분,유형 코드 데이타
 * [관련 RFC] : ZSOLYR_RFC_YEAR_PENSION_PE
 *
 * @author lsa    2010/12/10   
 */
public class D11TaxAdjustPensionCodeData extends com.sns.jdf.EntityData {       
	
    public String GOJE_CODE ;  //공제코드	                                                                                     
    public String GOJE_TEXT ;  //공제                                                                                                 
    public String PREIN_FLAG;  //종전근무지 사용 여부	                                                                             
    public String FINCO_FLAG;  //금융기관 사용 여부	                                                                                    
    public String ACCNO_FLAG;  //계좌번호 사용 여부	                                                                             

    
}
