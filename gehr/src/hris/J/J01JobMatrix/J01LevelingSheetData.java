package hris.J.J01JobMatrix;

/**
 * J01LevelingSheetData.java
 * Job Leveling Sheet Data format
 * [관련 RFC] : ZHRH_RFC_GET_LEVELING_SHEET
 * 
 * @author  김도신
 * @version 1.0, 2003/05/13
 */
public class J01LevelingSheetData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH107S)
    public String DSORT_CODE ;     // 대분류ID
    public String DSORT_NAME ;     // 대분류명
    public String ELEME_CODE ;     // 평가요소ID
    public String ELEME_NAME ;     // 평가요소명
    public String LEVEL_CODE0;     // Level ID
    public String TDNAME     ;     // 대분류ID + 평가요소ID

//  P_RESULT_D(ZHRH103S)
    public String OBJID      ;     // 직무 ID
    public String SUBTY      ;     // 상세내역 하부유형
    public String SEQNO      ;     // 상세내역 순번
    public String TLINE      ;     // 상세 DATA
    
//  P_RESULT_L(ZHRH082T)
    public String LEVEL_CODE ;     // Level ID
    public String LEVEL_NAME ;     // Level 명
    public String LEVEL_GRAD ;     // Level 값
    
}   
    
    