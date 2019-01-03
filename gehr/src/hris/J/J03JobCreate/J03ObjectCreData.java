package hris.J.J03JobCreate;

/**
 * J03ObjectCreData.java
 * HRP1000, HRP1001, HRP1002, HRP9618 INFTY에 Object를 생성하는 Data
 * [관련 RFC] : ZHRH_RFC_CUD_OBJECTS,
 *              ZHRH_RFC_CUD_RELATIONS,
 *              ZHRH_RFC_CUD_CONTENTS,
 *              ZHRH_RFC_CUD_LEVELING
 * 
 * @author  김도신
 * @version 1.0, 2003/06/13
 */
public class J03ObjectCreData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH201S)
    public String OTYPE      ;     // 오브젝트유형
    public String OBJID      ;     // 오브젝트 ID
    public String BEGDA      ;     // 시작일
    public String ENDDA      ;     // 종료일
    public String RSIGN      ;     // 관계사양(A, B)
    public String RELAT      ;     // 오브젝트간의 관계
    public String SCLAS      ;     // 관련된 오브젝트유형
    public String SOBID      ;     // 관련오브젝트 ID
    public String PROZT      ;     // 가중비율
    public String PRIOX      ;     // 우선순위
    public String CHARA      ;     // 자격사항/필요요건 숙련도
    public String SHORT      ;     // 오브젝트약어
    public String STEXT      ;     // 오브젝트이름
    public String SUBTY      ;     // 하부유형
    public String LEVEL_CODE ;     // Level ID
    
}    