package hris.C.C07Language;

/**
 * C07LangDupCheckData.java
 * �������� �ߺ���û check
 * [���� RFC] : ZHRE_RFC_LANGUAGE_DUP_CHECK
 *
 * @author  �赵��
 * @version 1.0, 2003/04/15
 */
public class C07LangDupCheckData extends com.sns.jdf.EntityData {
    
    public String SBEG_DATE;        // �н�������
    public String SEND_DATE;        // �н�������
    public String INFO_FLAG;        // Infotype Data�̸� 'I', Temp Table Data�̸� 'T'
    public String AINF_SEQN;        // Temp Table�� Check�Ҷ� �����ȣ�� �������� Check�Ѵ�.(������ �ʿ�)
    
}