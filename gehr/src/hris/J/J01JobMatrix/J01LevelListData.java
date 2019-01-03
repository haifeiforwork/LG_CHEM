package hris.J.J01JobMatrix;

/**
 * J01LevelListData.java
 * Job Profile Data format
 * [관련 RFC] : ZHRH_RFC_GET_LEVEL_LIST
 * 
 * @author  김도신
 * @version 1.0, 2003/06/18
 */
public class J01LevelListData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH084T)
    public String OBJID     ;     // 오브젝트 ID
    public String STEXT     ;     // 오브젝트 명
    public String MIN_VALUE ;     // 하한 값
    public String MAX_VALUE ;     // 상한 값

}
