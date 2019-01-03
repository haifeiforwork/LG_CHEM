package hris.J.J03JobCreate;

/**
 * J03RequireLevelData.java
 * 생성시 리턴되는 작업 Message Data
 * [관련 RFC] : ZHRH_RFC_GET_REQUIRE_LEVEL,
 * 
 * @author  원도연
 * @version 1.0, 2003/06/16
 */
public class J03RequireLevelData extends com.sns.jdf.EntityData {

//  L_RESUTL(ZHRH109S)
    public String SCALE_ID ;     // 스케일 ID
    public String RATING   ;     // 품질범위숙련도
    public String PSTEXT   ;     // 숙련도텍스트 스케일
}   
    
    