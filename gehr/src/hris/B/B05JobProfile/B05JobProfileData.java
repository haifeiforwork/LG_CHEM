package hris.B.B05JobProfile;

/**
 * B05JobProfileData.java
 * Job Profile Data format
 * [���� RFC] : ZHRH_RFC_GET_JOB_PROFILE
 * 
 * @author �赵��
 * @version 1.0, 2003/02/11
 */
public class B05JobProfileData extends com.sns.jdf.EntityData {

//  P_RESULT
    public String STEXT_FUNC;     // Function ��
    public String STEXT_OBJ ;     // Objective ��
    public String STEXT_JOB ;     // Job Name ��
    
//  P_RESULT_P
    public String SOBID     ;     // Position ID
    public String PERNR     ;     // ���
    public String TITEL     ;     // ����ȣĪ(����)
    public String ENAME     ;     // ����
    public String STEXT_LEV ;     // Job Grade
    public String BEGDA     ;     // �� ���� �߷���
    
//  P_RESULT_D
    public String OBJID     ;     // ���� ID
    public String SUBTY     ;     // �󼼳��� �Ϻ�����
    public String SEQNO     ;     // �󼼳��� ����
    public String TLINE     ;     // �� DATA
    
}   
    
    