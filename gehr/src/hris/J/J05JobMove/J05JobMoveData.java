package hris.J.J05JobMove;

/**
 * J05JobMoveData.java
 * Function - Objective - 대분류 - Job List를 조회하는 Data
 * [관련 RFC] : ZHRH_RFC_GET_JOB_MOVE
 * 
 * @author  김도신
 * @version 1.0, 2003/06/27
 */
public class J05JobMoveData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH112S)
    public String OBJID_F     ;     // Function ID
    public String OBJID_O     ;     // Objective ID
    public String OBJID_D     ;     // 대분류 ID
    public String OBJID       ;     // Job ID
    public String STEXT       ;     // Job 명
    public String BEGDA       ;     // Job 시작일
    public String HOLDER_FLAG ;     // Objective 변경여부 - Objective 변경시 Job Holder를 한계결정하기위해서

}   
    
    