package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustPensionData.java
 * 연말정산 -  월세 데이터
 * [관련 RFC] : ZSOLYR_RFC_YEAR_PENSION_SAVING
 *
 * @author lsa
 * @version 1.0, 1.0, 2010/12/08
 * @version 1.0, 2013/12/10 CSR ID:C20140106_63914 임대인성명, 임대인주민등록번호, 입대차계약서 상 주소지  추가 
 */
public class D11TaxAdjustRentData extends com.sns.jdf.EntityData {
	
    public String MANDT	 ;   //클라이언트                                 
    public String WORK_YEAR; //카운트 매개변수                            
    public String ENDDA	 ;   //종료일                                     
    public String BEGDA	 ;   //시작일                                     
    public String PERNR	 ;   //사원 번호                                  
    public String SUBTY	 ;   //하위 유형                    
    public String SEQNR	 ;   //동일한 키를 가진 인포타입 레코드 번호       
    public String RCBEG	 ;   //임대계약시작일자          
    public String RCEND	 ;   //임대계약종료일자                 
    public String NAM01	 ;   //NTS로부터의 비용 금액 정보                 
    public String CUR01	 ;   //비용 통화 키          
     
    public String PNSTY	 ;   //  CSR ID:C20140106_63914 월세공제 
    public String LDNAM	 ;   //  CSR ID:C20140106_63914 임대인 성명
    public String LDREG	 ;   //  CSR ID:C20140106_63914 주민등록번호 (한국)
    public String ADDRE	 ;   //  CSR ID:C20140106_63914 임대차계약서 상 주소지
    public String PNSTX	 ;   //  CSR ID:C20140106_63914월세공제 내역 (01 :월세, 02:전세)
    
    public String HOUTY	 ;   //  @2014 연말정산 주택유형코드
    public String HOSTX	 ;   //  @2014 연말정산 주택유형TEXT
    public String FLRAR	 ;   // @2014 연말정산 주택계약면적
}
  