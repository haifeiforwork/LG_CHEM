package hris.J.J01JobMatrix;

/**
 * J01JobMatrixData.java
 * Job Profile Data format
 * [���� RFC] : ZHRH_RFC_GET_FUNC_OBJ_LIST
 *              ZHRH_RFC_GET_JOB_MATRIX
 * 
 * @author  �赵��
 * @version 1.0, 2003/02/11
 */
public class J01JobMatrixData extends com.sns.jdf.EntityData {

//  P_RESULT_D, P_RESULT(ZHRH100S)
    public String ORDER_N   ;     // ��з��� ����
    public String OTYPE     ;     // ������Ʈ ����
    public String OBJID     ;     // ������Ʈ ID
    public String STEXT     ;     // ������Ʈ ��
    public String SCLAS     ;     // ���õ� ������Ʈ ����
    public String SOBID     ;     // ���õ� ������Ʈ ID
    public String STEXT_OBJ ;     // ���õ� ������Ʈ ��
    public String SCLAS_LEV ;     // LEVEL ����
    public String SOBID_LEV ;     // LEVEL ID
    public String LINK_CHK  ;     // Job Matrix���� ������ �ش��ϴ� ������ ǥ�� ����
    public String BEGDA     ;     // 04 ��з� �۾����� ����� JOB�� ���ʽ�����

}
