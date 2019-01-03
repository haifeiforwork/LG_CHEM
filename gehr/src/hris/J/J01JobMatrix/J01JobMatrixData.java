package hris.J.J01JobMatrix;

/**
 * J01JobMatrixData.java
 * Job Profile Data format
 * [관련 RFC] : ZHRH_RFC_GET_FUNC_OBJ_LIST
 *              ZHRH_RFC_GET_JOB_MATRIX
 * 
 * @author  김도신
 * @version 1.0, 2003/02/11
 */
public class J01JobMatrixData extends com.sns.jdf.EntityData {

//  P_RESULT_D, P_RESULT(ZHRH100S)
    public String ORDER_N   ;     // 대분류의 순서
    public String OTYPE     ;     // 오브젝트 유형
    public String OBJID     ;     // 오브젝트 ID
    public String STEXT     ;     // 오브젝트 명
    public String SCLAS     ;     // 관련된 오브젝트 유형
    public String SOBID     ;     // 관련된 오브젝트 ID
    public String STEXT_OBJ ;     // 관련된 오브젝트 명
    public String SCLAS_LEV ;     // LEVEL 유형
    public String SOBID_LEV ;     // LEVEL ID
    public String LINK_CHK  ;     // Job Matrix에서 팀원의 해당하는 과업에 표시 여부
    public String BEGDA     ;     // 04 대분류 작업에서 사용할 JOB의 최초시작일

}
