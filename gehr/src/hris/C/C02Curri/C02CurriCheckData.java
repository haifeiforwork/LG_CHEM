package hris.C.C02Curri;

/**
 * C02CurriCheckData .java
 * ���̼����� �̼����� �� �����ڰݿ���� �������� Data 
 *   [���� RFC] : ZHRE_RFC_PREVIOUS_EVENT, ZHRE_RFC_PRE_EVENT_CHECK
 * 
 * @author �ڿ���
 * @version 1.0, 2002/01/16
 */
public class C02CurriCheckData extends com.sns.jdf.EntityData {
    
    public String OTYPE;        //���� ������Ʈ ����  
    public String OBJID;        //���ÿ�����Ʈ ID
    public String STEXT;        //�����Ʈ �̸�
    public String BEGDA;        //������
    public String ENDDA;        //������ 
    public String STATE_ID;     //��߰�ȹ����
    public String STATETXT;     //��߰�ȹ�����ؽ�Ʈ
    public String CHARA;        //�����ڰݿ�� Level��;

}

