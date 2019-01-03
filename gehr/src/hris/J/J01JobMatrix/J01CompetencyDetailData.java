package hris.J.J01JobMatrix;

/**
 * J01CompetencyDetailData.java
 * Job Profile Data format
 * [관련 RFC] : ZHRH_RFC_GET_COMPETENCY_DETAIL
 * 
 * @author 원도연
 * @version 1.0, 2003/05/13
 */
public class J01CompetencyDetailData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH105S)
    public String ZLEVEL     ;     // 숙련도텍스트 스케일    
    public String ZLEVEL_RAT ;     // 숙련도 number
    public String STEXT_KEY  ;     // 각숙련도별 key words
    
//  P_RESULT_D(ZHRH103S)
    public String OBJID     ;     // 직무 ID
    public String SUBTY     ;     // 상세내역 하부유형
    public String SEQNO     ;     // 상세내역 순번
    public String TLINE     ;     // 상세 DATA
    
}   
    
    