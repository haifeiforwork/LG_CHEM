package hris.J.J03JobCreate;

/**
 * J03MessageData.java
 * 생성시 리턴되는 작업 Message Data
 * [관련 RFC] : ZHRH_RFC_CUD_OBJECTS,
 *              ZHRH_RFC_CUD_RELATIONS,
 *              ZHRH_RFC_CUD_CONTENTS,
 *              ZHRH_RFC_CUD_LEVELING
 * 
 * @author  김도신
 * @version 1.0, 2003/06/13
 */
public class J03MessageData extends com.sns.jdf.EntityData {

//  P_MESSTAB(ZHRH200S)
    public String MSGSPRA ;     // 메세지 언어 ID
    public String MSGID   ;     // Batch 입력 메세지 ID
    public String MSGNR   ;     // Batch 입력 메세지번호
    public String MSGTEXT ;     // BDC MESSAGE TEXT

}   
    
    