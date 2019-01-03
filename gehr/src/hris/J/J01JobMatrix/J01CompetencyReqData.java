package hris.J.J01JobMatrix;

/**
 * J01CompetencyReqData.java
 * Competency Requirements Data format
 * [���� RFC] : ZHRH_RFC_GET_COMPETENCY_REQ
 * 
 * @author �赵��
 * @version 1.0, 2003/02/13
 */
public class J01CompetencyReqData extends com.sns.jdf.EntityData {

//  P_RESULT_Q(ZHRH104S)
    public String OBJID_G   ;     // �ڰݿ�� Group ID
    public String STEXT     ;     // �ڰݿ�� Group ��
    public String SOBID     ;     // �ڰݿ�� ID
    public String STEXT_Q   ;     // �ڰݿ�� ��
    public String ZLEVEL    ;     // �䱸����
    public String STEXT_KEY ;     // Key Words

//  P_RESULT_D(ZHRH103S)
    public String OBJID     ;     // �ڰݿ�� ID
    public String SUBTY     ;     // �󼼳��� �Ϻ�����
    public String SEQNO     ;     // �󼼳��� ����
    public String TLINE     ;     // �� DATA
    
}
