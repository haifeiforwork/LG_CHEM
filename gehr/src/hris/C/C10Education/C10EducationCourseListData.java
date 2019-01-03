package hris.C.C10Education;

/**
 * C10EducationCourseListData.java
 * 어학지원 중복신청 check
 * [관련 RFC] : ZHRE_RFC_EDUCATION_COURSE_LIST
 *
 * @author  김도신
 * @version 1.0, 2005/05/27
 */
public class C10EducationCourseListData extends com.sns.jdf.EntityData {
    
    public String OBJID   ;        // 과정 ID
    public String STEXT   ;        // 과정 명
    public String CNT_TOT ;        // 총강좌
    public String CNT_END ;        // 종료강좌
    public String CNT_REM ;        // 잔여강좌

}