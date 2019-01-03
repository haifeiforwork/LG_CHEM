package hris.J.J01JobMatrix;

/**
 * J01ImageFileNameData.java
 * Eloffice�� Job Unit�� KSEA, Job Process Image FileName Data format
 * [���� RFC] : ZHRH_RFC_GET_IMAGE_FILENAME
 * 
 * @author  �赵��
 * @version 1.0, 2003/05/14
 */
public class J01ImageFileNameData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH110T)
    public String TASK_CODE ;     // Task Code
    public String GUBN_CODE ;     // KSEA = '1', Process = '2'�� ����
    public String BEGDA     ;     // ������
    public String SEQN_NUMB ;     // ����
    public String IMAG_NAME ;     // File ��

//  P_RESULT_P(ZHRH102S)
    public String SOBID     ;     // Position ID
    public String PERNR     ;     // ���
    public String TITEL     ;     // ����ȣĪ(����)
    public String ENAME     ;     // ����
    
//  P_RESULT_D(ZHRH103S)
    public String OBJID     ;     // ���� ID
    public String SUBTY     ;     // �󼼳��� �Ϻ�����
    public String SEQNO     ;     // �󼼳��� ����
    public String TLINE     ;     // �� DATA

    public String E_MATCH   ;     // �������� ��ġ����
    
}   
    
    