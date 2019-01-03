package hris.C.C10Education;

/**
 * C10EducationEventListData.java
 * 교육 차수 리스트
 * [관련 RFC] : ZHRE_RFC_EDUCATION_EVENT_LIST
 *
 * @author  김도신
 * @version 1.0, 2005/05/28
 */
public class C10EducationEventListData extends com.sns.jdf.EntityData {
    
    public String OBJID   ;        // 차수 ID
    public String STEXT   ;        // 차수 명
    public String BEGDA   ;        // 시작일
    public String ENDDA   ;        // 종료일
    public String SDATE   ;        // 신청기간(시작일)
    public String EDATE   ;        // 신청기간(종료일)
    public String LOCATE  ;        // 교육장소
    public String IKOST   ;        // 교육비용
    public String DELET   ;        // 삭제 FLAG
    public String STATE   ;        // 상태

}                        
