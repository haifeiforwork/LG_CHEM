package hris.J.J03JobCreate;

/**
 * J03RequireLevelData.java
 * 생성시 리턴되는 작업 Message Data
 * [관련 RFC] : ZHRH_RFC_GET_REQUIRE_LEVEL,
 * 
 * @author  원도연
 * @version 1.0, 2003/06/16
 */
public class J03QKData extends com.sns.jdf.EntityData {

//  L_RESUTL(ZHRH110S)
    public String OTYPE;     // 오브젝트유형
    public String OBJID;     // 오브젝트 번호
    public String STEXT;     // 오브젝트이름
}   
    
    