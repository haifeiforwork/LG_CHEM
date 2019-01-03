package hris.J.J01JobMatrix;

/**
 * J01HeaderStextData.java
 * Header Stext Data format
 * [관련 RFC] : ZHRH_RFC_GET_HEADER_STEXT
 * 
 * @author  김도신
 * @version 1.0, 2003/05/15
 */
public class J01HeaderStextData extends com.sns.jdf.EntityData {

//  P_STEXT(ZHRH101S)
    public String OBJID_FUNC ;     // Function ID
    public String STEXT_FUNC ;     // Function 명
    public String OBJID_OBJ  ;     // Objective ID
    public String STEXT_OBJ  ;     // Objective 명
    public String OBJID_JOB  ;     // Job Name ID
    public String STEXT_JOB  ;     // Job Name 명
    
}
