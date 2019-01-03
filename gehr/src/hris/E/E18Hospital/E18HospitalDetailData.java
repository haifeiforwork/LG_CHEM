package hris.E.E18Hospital ;

/**
 * E18HospitalDetailData.java
 *  ����� �Ƿ�� �� ������ ��� ������
 *   [���� RFC] : ZHRW_RFC_MEDIC_DETAIL
 * 
 * @author �Ѽ���
 * @version 1.0, 2002/01/03
 */
public class E18HospitalDetailData extends com.sns.jdf.EntityData {
    public String MEDI_NAME ;      // �Ƿ���
    public String TELX_NUMB ;      // ��ȭ��ȣ
    public String EXAM_DATE ;      // ������
    public String MEDI_CODE ;      // �Կ�/�ܷ�
    public String MEDI_TEXT ;      // �Կ�/�ܷ�
    public String RCPT_CODE ;      // ������ ����
    public String RCPT_TEXT ;      // ������ ����
    public String RCPT_NUMB ;      // No.
    public String EMPL_WONX ;      // ���� �ǳ��ξ�
    public String WAERS     ;      // ��ȭŰ
//  2004�� �������� ���� ����ڵ�Ϲ�ȣ �ʵ� �߰� (3.7)
    public String MEDI_NUMB ;      // �Ƿ��� ����ڵ�Ϲ�ȣ
    public String MEDI_MTHD ;      // 05.12.26 add ������� (1:����, 2:�ſ�ī��)
    public String MEDI_YEAR ;      // 05.12.26 add ������������
    public String YTAX_WONX ;      // 06.01.17 add ��������ݿ���
}
