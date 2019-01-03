package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustGibuData.java
 * 연말정산 - 특별공제기부금 데이타
 * [관련 RFC] : ZHRP_RFC_YEAR_DONATION
 *
 * @author lsa
 * @version 1.0, 2005/11/17
 */
public class D11TaxAdjustGibuData extends com.sns.jdf.EntityData {

    public String MANDT     ;   //클라이언트            
    public String WORK_YEAR ;   //연말정산 연도         
    public String BEGDA     ;   //시작일                
    public String ENDDA     ;   //종료일                
    public String PERNR     ;   //사원번호              
    public String GUBUN     ;   //급여공제 1,  eHR신청 2
    public String SEQNR     ;   //순번              

    public String DONA_CODE;	//기부금유형 코드
    public String DONA_NAME;	//기부금유형 명칭
    public String DONA_YYMM;	//기부 연월
    public String DONA_DESC;	//기부금 내용
    public String DONA_SEQN;	//기부금 일련번호
    public String DONA_COMP;	//기부처 상호(법인명)
    public String DONA_NUMB;	//기부처 사업자등록번호
    public String DONA_AMNT;	//기부금 금액
    public String CHNTS;	//국세청증빙여부
    
    public String SUBTY   ;   // 가족 관계         CSR ID:1361257
    public String F_ENAME ;  // 성명              CSR ID:1361257
    public String F_REGNO ;  // 주민등록번호 CSR ID:1361257
    
    public String DONA_CRVIN ;  // @2011 이월공제 지시자
    public String DONA_CRVYR ;  // @2011 기부금 이월공제 연도
    public String DONA_DEDPR ;  // @2011 전년까지 공제된 금액 
    public String OMIT_FLAG;
}
