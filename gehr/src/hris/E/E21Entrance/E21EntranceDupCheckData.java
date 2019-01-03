package hris.E.E21Entrance;

/**
 * E21EntranceDupCheckData.java
 * �������ϱ� �ߺ���û check
 * [���� RFC] : ZHRW_RFC_ENTRANCE_DUP_CHECK
 *
 * @author  �赵��
 * @version 1.0, 2003/03/18
 */
public class E21EntranceDupCheckData extends com.sns.jdf.EntityData {
    
    public String SUBF_TYPE;        // �������ϱ��� ����Ÿ��
    public String ACAD_CARE;        // �з�
    public String REGNO    ;        // �ֹε�Ϲ�ȣ
    public String INFO_FLAG;        // Infotype Data�̸� 'I', Temp Table Data�̸� 'T'
    public String AINF_SEQN;        // Temp Table�� Check�Ҷ� �����ȣ�� �������� Check�Ѵ�.(������ �ʿ�)
    
}