package hris.J.J03JobCreate;

/**
 * J03ContentsCreData.java
 * HRP1002 INFTY에 내역을 생성하는 Data
 * [관련 RFC] : ZHRH_RFC_CUD_CONTENTS
 * 
 * @author  김도신
 * @version 1.0, 2003/06/13
 */
public class J03ContentsCreData extends com.sns.jdf.EntityData {

//  P_CONTENTS(ZHRH103S)
    public String OBJID ;     // 오브젝트 ID
    public String SUBTY ;     // 하부유형
    public String SEQNO ;     // 순번
    public String TLINE ;     // 내역(정보유형 1002의 길이 79 라인)

}   
    
    