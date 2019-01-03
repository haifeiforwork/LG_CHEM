package hris.B.B05JobProfile;

/**
 * B05CompetencyReqData.java
 * Competency Requirements Data format
 * [관련 RFC] : ZHRH_RFC_GET_COMPETENCY_REQ
 * 
 * @author 김도신
 * @version 1.0, 2003/02/13
 */
public class B05CompetencyReqData extends com.sns.jdf.EntityData {

//  P_RESULT
    public String STEXT_FUNC;     // Function 명
    public String STEXT_OBJ ;     // Objective 명
    public String STEXT_JOB ;     // Job Name 명
    
//  P_RESULT_Q
    public String OBJID_G   ;     // 자격요건 Group ID
    public String STEXT     ;     // 자격요건 Group 명
    public String SOBID     ;     // 자격요건 ID
    public String STEXT_Q   ;     // 자격요건 명
    public String ZLEVEL    ;     // 요구수준
    public String STEXT_KEY ;     // Key Words

//  P_RESULT_D
    public String OBJID     ;     // 자격요건 ID
    public String SUBTY     ;     // 상세내역 하부유형
    public String SEQNO     ;     // 상세내역 순번
    public String TLINE     ;     // 상세 DATA
    
}
