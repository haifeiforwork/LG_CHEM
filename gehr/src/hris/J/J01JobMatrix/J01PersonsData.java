package hris.J.J01JobMatrix;

/**
 * J01PersonsData.java
 * ������ �������Ʈ�� ��ȸ�Ѵ�. �ش��ϴ� Objective�� �ش��ϴ� ����� ��ȸ�Ѵ�.
 * [���� RFC] : ZHRH_RFC_GET_PERSONS
 * 
 * @author  �赵��
 * @version 1.0, 2003/04/23
 */
public class J01PersonsData extends com.sns.jdf.EntityData {

//  P_RESULT_D(ZHRH038S)
    public String PERNR      ;     // ���
    public String ENAME      ;     // ����
    public String ORGEH      ;     // �����ڵ�
    public String ORGTX      ;     // ������
    public String TITEL      ;     // ����
    public String OBJID      ;     // Objective ID
//  WEB������ ����ϴ� ����
    public String CHK_HOLDER ;     // ������ Job Holder ���� ����
    public String BEGDA      ;     // ������ Job Holder ���� ����

}
