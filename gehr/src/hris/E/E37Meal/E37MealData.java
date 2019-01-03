package hris.E.E37Meal ;

/**
 * E37MealData.java
 *  사원의 식대 상세 내역을 담는 데이터
 *   [관련 RFC] : ZHRA_RFC_MEAL_APP
 * 
 * @author lsa
 * @version 1.0, 2009/11/25
 */
public class E37MealData extends com.sns.jdf.EntityData {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
    public String PERNR    ;      //사번(13자리 식대관리)         
    public String BEGDA    ;      //신청일                        
    public String AINF_SEQN;      //결재정보 일련번호             
    public String APLY_FLAG;      //신청구분                      
    public String APLY_MNTH;      //분석기간 - 월                 
    public String ORGEH    ;      //조직 단위                     
    public String ENAME    ;      //사원 또는 지원자의 포맷된 이름
    public String TKCT_CONT;      //현물지급일수                  
    public String TKCT_WONX;      //현물지급액  ,카드충전액                  
    public String CASH_CONT;      //현금보상일수                  
    public String CASH_WONX;      //현금보상액                    
    public String BANKS    ;      //은행 국가 키                  
    public String BANKL    ;      //은행 키                       
    public String BANKN    ;      //은행 계정 번호                
    public String BKONT    ;      //은행 관리 키                  
    public String BVTYP    ;      //파트너 은행 유형              
    public String POST_DATE;      //POSTING일자                   
    public String BELNR    ;      //회계 전표 번호                
    public String ZPERNR   ;      //                              
    public String ZUNAME   ;      //부서서무 이름                 
    public String BIGO_TXT ;      //구체적증상                     
    public String THNG_MONY ;      //현물 (1끼당 금액)                     
    public String CASH_MONY ;      //현물보상 기준금액                    
    
}
