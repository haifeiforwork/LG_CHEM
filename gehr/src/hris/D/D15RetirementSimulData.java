package hris.D ;

/**
 * D15RetirementSimulData.java
 *  퇴직금소득공제 Simulation 데이터
 *   [관련 RFC] : ZHRP_RFC_SIM_CALC_RSGN_AMT
 * @author 김성일
 * @version 1.0, 2002/02/06
 *                      2015/07/30 [CSR ID:2838889] 퇴직금 시뮬레이션 세금로직 변경 요청의 건
 */
public class D15RetirementSimulData extends com.sns.jdf.EntityData {

//    public String _퇴직수당 ;   // 퇴직수당 - 명예퇴직수당은 시뮬레이션에서 제외된다.
    /*  초기값을 RFC로부터 받자  */
    public String O_GIDAT           ;   // 퇴직금기산일  
    public String WAGE_AVER         ;   // 평균임금
//  2002.11.21. 추가
    public String AVER_DATE         ;   // 평균임금기산일
//  2002.11.21. 추가
    public String SERV_PROD_Y       ;   // 근속년        
    public String SERV_PROD_M       ;   // 근속월        
    //public String O_ZIPY01          ;   // 보험사지급액1 
    //public String O_ZIPY02          ;   // 보험사지급액2 
    public String O_BONDM           ;   // 채권가압류공제
    public String O_HLOAN           ;   // 주택자금공제  
    public String GRNT_RSGN         ;   // 퇴직금총액    
    public String O_NAPPR           ;   // 퇴직전환금

    /*  보험회사지급액과 보험사명을 RFC로부터 받자  */
    public String INS1_NAME1        ;   // 보험사명1  
    public String JON1_AMNT1        ;   // 가입액1      
    public String INS1_NAME2        ;   // 보험사명2 
    public String JON1_AMNT2        ;   // 가입액2      
    public String INS1_NAME3        ;   // 보험사명3 
    public String JON1_AMNT3        ;   // 가입액3      
    public String INS1_NAME4        ;   // 보험사명4 
    public String JON1_AMNT4        ;   // 가입액4      
    public String INS1_NAME5        ;   // 보험사명5 
    public String JON1_AMNT5        ;   // 가입액5        
    public String INS1_NAME6        ;   // 보험사명6 
    public String JON1_AMNT6        ;   // 가입액6      
    public String INS1_NAME7        ;   // 보험사명7 
    public String JON1_AMNT7        ;   // 가입액7        
    public String INS1_NAME8        ;   // 보험사명8 
    public String JON1_AMNT8        ;   // 가입액8     
    public String INS1_NAME9        ;   // 보험사명9 
    public String JON1_AMNT9        ;   // 가입액9        
    public String INS1_NAME10        ;   // 보험사명10 
    public String JON1_AMNT10        ;   // 가입액10    

    /*  입력받는 필드  */
    public String fu_retireDate     ;   // 예상퇴직일자   

    /*  계산해야하는 값  */
    public String _퇴직갑근세       ;   // 퇴직갑근세  
    public String _퇴직주민세       ;   // 퇴직주민세
    public String _공제총액         ;   // 공제총액      
    public String _차감지급액       ;   // 차감지급액    
    public String _회사지급액       ;   // 회사지급액
    
    /* 20150730 추가 */
    public String INC_TAX; //퇴직갑근세(new) CSR ID:2838889
    public String RES_TAX; //퇴직주민세(new) CSR ID:2838889
}                                              
