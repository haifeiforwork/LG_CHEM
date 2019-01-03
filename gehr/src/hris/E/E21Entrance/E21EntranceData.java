package	hris.E.E21Entrance;

/**
 * E21EntranceData.java
 * 개인의 입학축하금 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRW_RFC_ENTRANCE_FEE_LIST
 * 
 * @author 김도신    
 * @version 1.0, 2002/01/03
 */
public class E21EntranceData extends com.sns.jdf.EntityData {
    public String AINF_SEQN ;			// 결재정보 일련번호
    public String PERNR     ;			// 사원번호
    public String SUBF_TYPE ;          // 입학축하금 신청구분 (1)
    public String BEGDA     ;          // 신청일
    public String PAID_DATE ;			// 지급일자
    public String FAMSA     ;			// 가족레코드유형
    public String ATEXT     ;			// 텍스트, 20문자
    public String LNMHG     ;			// 성(한글)
    public String FNMHG     ;			// 이름(한글)
    public String REGNO     ;			// 주민등록번호
    public String ACAD_CARE ;			// 학력
    public String STEXT     ;			// 학력명
    public String FASIN     ;          // 교육기관
    
    // 결재 추가 (2005-02-28 : 이승희)
    public String PAID_AMNT; // 지급액         
    public String GESC2    ; // 성별 키        
    public String KDSVH    ; // 자녀와의 관계  
    public String WAERS    ; // 통화키         
    public String POST_DATE; // POSTING일자    
    public String BELNR    ; // 회계전표번호   
    public String ZPERNR   ; // 대리신청자 사번
    public String ZUNAME   ; // 부서서무 이름  
    public String AEDTM    ; // 변경일         
    public String UNAME    ; // 사용자이름

	public String PROP_YEAR	;	//신청년도
}










