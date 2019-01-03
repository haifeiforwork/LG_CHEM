package hris.D.D12Rotation ;

/**
 * D12RotationData.java
 * 부서원 기본정보 / 기 저장된 근태정보 조회 
 *   [관련 RFC] : ZHRW_RFC_DAY_READER
 * @author lsa
 * @version 1.0, 2009/01/07
 */
public class D12RotationData extends com.sns.jdf.EntityData {

    public String PERNR    ;  //사원 번호                     
    public String ENAME    ;  //사원 또는 지원자의 포맷된 이름
    public String BEGDA    ;  //신청일                        
    public String SUBTY    ;  //근무/휴무 유형                
    public String ATEXT    ;  //근무/휴무 유형 텍스트         
    public String BEGUZ    ;  //시작 시간                     
    public String ENDUZ    ;  //종료 시간                     
    public String VTKEN    ;  //전일 지시자                   
    public String PBEG1    ;  //휴식 시작                     
    public String PEND1    ;  //휴식종료                      
    public String SOLLZ    ;  //계획근무시간                  
    public String REASON   ;  //신청사유                      
    public String A002_SEQN;  //경조신청 일련번호             
    public String CONG_DATE;  //경조발생일                    
    public String HOLI_CONT;  //경조휴가일수                  
    public String CONG_CODE;  //경조내역                     
	public String ADDYN	      ; //임시사용
	
	//------김종서 추가----- 2009/02/26
	public String AEDTM	      ; //현재 날짜(예.20080101)
	public String UNAME	      ; //로그온ID
	public String ZPERNR	  ; //대리신청자 사번
    public String OVTM_CODE ;   //사유코드 CSR ID:1546748   
    public String OVTM_NAME ;   //원근무자,대근자   CSR ID:1546748  
	     
}                                              
