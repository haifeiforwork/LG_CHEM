package hris.E.E20Congra;

/**
 * E20CongcondData.java
 * 경조금조회
 * [관련 RFC] : ZHRW_RFC_CONGCOND_DISPLAY
 * @author 박영락
 * @version 1.0, 2001/12/20
 * @version v1.1, 2005/11/03 C2005101901000000340 :회수내역추가 
 */
public class E20CongcondData extends com.sns.jdf.EntityData
{
    public String CONG_CODE;       // 경조내역              
    public String RELA_CODE;       // 경조대상자관계코드    
    public String HOLI_CONT;       // 경조휴가              
    public String RELA_NAME;       // 경조대상자관계코드명  
    public String EREL_NAME;       // 경조대상성명          
    public String CONG_DATE;       // 경조발생일            
    public String WAGE_WONX;       // 통상임금              
    public String CONG_RATE;       // 지급율                
    public String CONG_WONX;       // 경조금                
    public String PROV_DATE;       // 지급일                
    public String BANK_NAME;       // 이체은행명            
    public String BANKN    ;       // 은행계좌번호          
    public String WORK_YEAR;       // 근속년                
    public String WORK_MNTH;       // 근속월                
    public String RTRO_MNTH;       // 지급년월(소급분)      
    public String RTRO_WONX;       // 소급차액              
    public String CONG_NAME;       // 경조내역코드명        
    public String BEGDA    ;       // 시작일(신청일)
    public String POST_DATE;       // 최종결재일
    public String RFUN_DATE;       // 반납일자     v1.1
    public String RFUN_RESN;       // 반납사유     v1.1
    public String RFUN_AMNT;       // 지급액       v1.1
    public String BELNR1;          // 회계전표번호 v1.1
    
}