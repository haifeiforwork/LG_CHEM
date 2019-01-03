package hris.J.J03JobCreate;

/**
 * J03PEntryListData.java
 * 생성시 리턴되는 작업 Message Data
 * [관련 RFC] : ZHRH_RFC_GET_PENTRY_LIST
 * 
 * @author  김도신
 * @version 1.0, 2003/06/23
 */
public class J03PEntryListData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH111S)
    public String OBJID_F ;     // Function ID
    public String STEXT_F ;     // Function 명
    public String OBJID_O ;     // Objectives ID
    public String STEXT_O ;     // Objectives 명
    public String OBJID_D ;     // 대분류 ID
    public String STEXT_D ;     // 대분류 명

}
    
    