package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustFamilyData.java
 * 연말정산 - 부양가족공제 데이터
 * [관련 RFC] : ZHRP_RFC_YEAR_FAMILY
 *
 * @author lsa
 * @version 1.0, 2005/11/24
 * @version 1.0, 2013/12/10 CSR ID:C20140106_63914 대중교통  추가 
 */
public class D11TaxAdjustFamilyData extends com.sns.jdf.EntityData {

    public String MANDT     ;  //클라이언트   
    public String WORK_YEAR ;  //연말정산 연도
    public String BEGDA     ;  //시작일       
    public String ENDDA     ;  //종료일       
    public String PERNR     ;  //사원번호     
    public String SEQNR     ;  //순번  
    public String FAMI_RLAT ;  //관계         
    public String FAMI_RLNM ;  //관계 명칭    
    public String FAMI_OBJP ;  //관계의 순번  
    public String FAMI_NAME ;  //이름         
    public String FAMI_REGN ;  //주민등록번호 
    public String FAMI_F001 ;  //보험료       
    public String FAMI_F002 ;  //의료비       
    public String FAMI_F003 ;  //교육비       
    public String FAMI_F004 ;  //신용카드등   
//  인적공제 정보를 추가한다. 
    public String FAMI_B001 ;  //기본공제여부
    public String FAMI_B002 ;  //장애인여부
    public String FAMI_B003 ;  //자녀양육비여부
    public String CHNTS ;  //

    public String E_GUBUN ;    //구분
    public String INSUR;       //보험료
    public String MEDIC;       //의료비
    public String EDUCA ;      //교육비       
    public String CREDIT;      //신용카드
    public String CASHR;       //현금영수증        
    public String GIBU;        //기부금    
    public String DEBIT;       //직불카드등    
    public String CCREDIT;  //C20121213_34842 전통시장사용분     
    public String TRDMK;  //C20121213_34842 전통시장여부    
    
    public String PCREDIT;  //C20140106_63914 대중교통사용분     
    public String CCTRA;  //C20140106_63914  대중교통여부     
    
}
  