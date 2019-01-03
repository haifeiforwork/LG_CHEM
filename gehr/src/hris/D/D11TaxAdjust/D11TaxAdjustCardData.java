package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustCardData.java
 * 연말정산 - 신용카드.현금영수증.보험료 데이타
 * [관련 RFC] : ZHRP_RFC_MEDI_YEA
 * 2012 전통시장여부추가 2012/12/13
 * CSR ID:C20140106_63914 교통카드여부 추가   2013/12/05
 * @author lsa    2006/11/23   
 */
public class D11TaxAdjustCardData extends com.sns.jdf.EntityData {       
	
    public String MANDT    ; //@v1.1 클라이언트                               
    public String WORK_YEAR; //@v1.1 카운트 매개변수                     
    public String BEGDA    ; //@v1.1 시작일                              
    public String ENDDA    ; //@v1.1 종료일                              
    public String PERNR    ; //@v1.1 사원번호                            
    public String GUBUN    ; //@v1.1 회사지원분 1,  eHR신청 2            
    public String SEQNR    ; //@v1.1 동일한 키를 가진 정보유형 레코드번호
    public String REGNO    ; //@v1.1 주민등록번호                        
    public String ENAME    ; //@v1.1 사원 또는 지원자의 포맷이름         

    public String SUBTY   ;  // 가족 관계
    public String F_ENAME ;  // 성명
    public String F_REGNO ;  // 주민등록번호
    public String E_GUBUN  ;  // 연말정산 입력구분명:1:신용카드,2:현금영수증,3:보장성보험료,4:장애인보험료          
    public String GU_NAME  ;  // 입력구분명         
    public String BETRG   ;  // 공제대상액
    public String BETRG_M ;  // 의료기관사용액
    public String BETRG_O ;  // 기본공제가 아닌 대상자에게 지출된 의료비카드사용액
    public String CHNTS;     // 국세청자료
    public String BETRG_B;     // 사업관련비
    public String TRDMK;     // 2012 전통시장여부
    
    public String CCTRA;     // CSR ID:C20140106_63914 교통카드여부 추가    
    public String OMIT_FLAG;	//삭제
    
    public String EXPRD;//@2014 연말정산 사용기간 코드
    public String EXSTX;//@2014 연말정산 사용기간 text
    
}
