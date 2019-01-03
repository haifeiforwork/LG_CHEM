package hris.C.C02Curri;

/**
 * C02CurriInfoData.java
 * ���������ȳ� ������ �������� Data
 *   [���� RFC] : ZHRE_RFC_EVENT_INFORMATION
 * 3���� RFC��� Data���� ����
 * @author �ڿ���
 * @version 1.0, 2002/01/14
 */
public class C02CurriInfoData extends com.sns.jdf.EntityData {
    //INPUT
    public String I_BUSEO;          //�μ�������ƮID
    public String I_DESCRIPTION;    //������Ʈ���
    public String I_FDATE;          //������
    public String I_GROUP;          //�׷������ƮID
    public String I_LOCATE;         //��ġ������ƮID
    public String I_TDATE;          //������

    //OUTPUT
    public String GWAJUNG;//������
    public String GWAID;    //����ID
    public String CHASU;    //������
    public String CHAID;     //����ID
    public String SHORT;    //������Ʈ���
    public String BEGDA;    //������
    public String ENDDA;    //������
    public String EXTRN;    //����
    public String KAPZ2;    //���������ο�(����)
    public String RESRV;    //�����ڼ�
    public String LOCATE;   //���
    public String BUSEO;    //�ְ��μ�
    public String SDATE;    //��û�Ⱓ(������)
    public String EDATE;    //��û�Ⱓ(������)
    public String DELET;    //����ǥ��
    public String PELSU;    //�ʼ�����ǥ��
    public String GIGWAN; //��ܱ��������
    public String IKOST;    //�系���

    //�߰�
    public String STATE;    //����
    public String LERN_CODE;//E-LEARNING CODE
}