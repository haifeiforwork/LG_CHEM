package hris.J.J01JobMatrix;

/**
 * J01JobProfileData.java
 * Job Profile Data format
 * [���� RFC] : ZHRH_RFC_GET_JOB_PROFILE
 * 
 * @author �赵��
 * @version 1.0, 2003/02/11
 */
public class J01JobProfileData extends com.sns.jdf.EntityData {

//  P_RESULT_P(ZHRH102S)
    public String SOBID     ;     // Position ID
    public String PERNR     ;     // ���
    public String TITEL     ;     // ����ȣĪ(����)
    public String ENAME     ;     // ����
    public String BEGDA     ;     // �� ���� �߷���
    
//  P_RESULT_D(ZHRH103S)
    public String OBJID     ;     // ���� ID
    public String SUBTY     ;     // �󼼳��� �Ϻ�����
    public String SEQNO     ;     // �󼼳��� ����
    public String TLINE     ;     // �� DATA
    
}   
    
    