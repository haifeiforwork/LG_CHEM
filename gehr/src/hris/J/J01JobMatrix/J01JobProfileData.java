package hris.J.J01JobMatrix;

/**
 * J01JobProfileData.java
 * Job Profile Data format
 * [관련 RFC] : ZHRH_RFC_GET_JOB_PROFILE
 * 
 * @author 김도신
 * @version 1.0, 2003/02/11
 */
public class J01JobProfileData extends com.sns.jdf.EntityData {

//  P_RESULT_P(ZHRH102S)
    public String SOBID     ;     // Position ID
    public String PERNR     ;     // 사번
    public String TITEL     ;     // 직급호칭(직위)
    public String ENAME     ;     // 성명
    public String BEGDA     ;     // 현 보직 발령일
    
//  P_RESULT_D(ZHRH103S)
    public String OBJID     ;     // 직무 ID
    public String SUBTY     ;     // 상세내역 하부유형
    public String SEQNO     ;     // 상세내역 순번
    public String TLINE     ;     // 상세 DATA
    
}   
    
    