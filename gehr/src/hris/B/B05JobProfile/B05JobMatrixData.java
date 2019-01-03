package hris.B.B05JobProfile;

/**
 * B05JobMatrixData.java
 * Job Profile Data format
 * [관련 RFC] : ZHRH_RFC_GET_FUNC_OBJ_LIST
 *              ZHRH_RFC_GET_JOB_MATRIX
 *              ZHRH_RFC_GET_LEVEL_LIST
 * 
 * @author 김도신
 * @version 1.0, 2003/02/11
 */
public class B05JobMatrixData extends com.sns.jdf.EntityData {

    public String ORDER_N   ;     // 대분류의 순서
    public String OTYPE     ;     // 오브젝트 유형
    public String OBJID     ;     // 오브젝트 ID
    public String STEXT     ;     // 오브젝트 명
    public String SCLAS     ;     // 관련된 오브젝트 유형
    public String SOBID     ;     // 관련된 오브젝트 ID
    public String STEXT_OBJ ;     // 관련된 오브젝트 명
    public String SCLAS_LEV ;     // LEVEL 유형
    public String SOBID_LEV ;     // LEVEL ID

}
