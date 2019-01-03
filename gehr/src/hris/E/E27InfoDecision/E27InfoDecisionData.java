package	hris.E.E27InfoDecision;

/**
 * E26InfoDecisionData.java
 * 인포멀 가입 및 탈퇴에 대한  결재정보에 대한 Data
 *   [관련 RFC] : ZHRH_RFC_INFORMAL_APPROVAL
 * 
 * @author 이형석  
 * @version 1.0, 2001/12/13
 */
 public class E27InfoDecisionData extends com.sns.jdf.EntityData {
    
    public String AINF_SEQN ;    //결재정보 일련번호
    public String MGART     ;    //구성원유형
    public String STEXT     ;    //오브젝트이름
    public String INFO_TYPE ;    //인포멀 결재(0:가입, 1:탈퇴
    public String INFO_TEXT ;    //신청구분 텍스트 
    public String BEGDA     ;    //시작일
    public String PERNR     ;    //사원번호
    public String ENAME     ;    //사원 또는 지원자의 포맷이름       
    public String APPR_STAT ;    //승인상태 
    public String APPR_TEXT ;    //승인상태 텍스트
    public String APPL_DATE ;    //가입일 
    public String BETRG     ;    //연봉금액
}
