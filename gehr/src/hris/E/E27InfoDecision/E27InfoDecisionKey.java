package	hris.E.E27InfoDecision;

/**
 * E26InfoDecisionKey.java
 * 결재정보 List 를 가져오기 위한 input 데이터
 * [관련 RFC] : ZHRH_RFC_INFORMAL_APPROVAL
 * 
 * @author 이형석  
 * @version 1.0, 2001/12/13
 */
 public class E27InfoDecisionKey extends com.sns.jdf.EntityData {
    
    public String P_CONT_TYPE;    //기초신용평가 유형
    public String P_INFO_TYPE;    //인포멀 결재(0:가입, 1:탈퇴)
    public String P_APPR_STAT;    //승인상태
    public String P_PERNR    ;    //간사
    public String P_BEGDA    ;    //시작일 
    public String P_ENDDA    ;    //종료일
    public String P_APPL_DATE;    //시작일

}

