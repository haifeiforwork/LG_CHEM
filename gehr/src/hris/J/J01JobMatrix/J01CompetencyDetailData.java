package hris.J.J01JobMatrix;

/**
 * J01CompetencyDetailData.java
 * Job Profile Data format
 * [���� RFC] : ZHRH_RFC_GET_COMPETENCY_DETAIL
 * 
 * @author ������
 * @version 1.0, 2003/05/13
 */
public class J01CompetencyDetailData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH105S)
    public String ZLEVEL     ;     // ���õ��ؽ�Ʈ ������    
    public String ZLEVEL_RAT ;     // ���õ� number
    public String STEXT_KEY  ;     // �����õ��� key words
    
//  P_RESULT_D(ZHRH103S)
    public String OBJID     ;     // ���� ID
    public String SUBTY     ;     // �󼼳��� �Ϻ�����
    public String SEQNO     ;     // �󼼳��� ����
    public String TLINE     ;     // �� DATA
    
}   
    
    