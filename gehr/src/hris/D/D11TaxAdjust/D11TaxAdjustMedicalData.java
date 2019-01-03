package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustMedicalData.java
 * �������� - Ư������ �Ƿ�� ����Ÿ
 * [���� RFC] : ZSOLYR_RFC_MEDI_YEA
 *
 * @author ������
 * @version 1.0, 2004/11/24
 * @version 1.1, 2005/11/23 lsa ����
 */
public class D11TaxAdjustMedicalData extends com.sns.jdf.EntityData {

    public String MANDT    ; //@v1.1 Ŭ���̾�Ʈ
    public String WORK_YEAR; //@v1.1 ī��Ʈ �Ű�����
    public String BEGDA    ; //@v1.1 ������
    public String ENDDA    ; //@v1.1 ������
    public String PERNR    ; //@v1.1 �����ȣ
    public String GUBUN    ; //@v1.1 ȸ�������� 1,  eHR��û 2
    public String SEQNR    ; //@v1.1 ������ Ű�� ���� �������� ���ڵ��ȣ
    public String REGNO    ; //@v1.1 �ֹε�Ϲ�ȣ
    public String ENAME    ; //@v1.1 ��� �Ǵ� �������� �����̸�

    public String SUBTY   ;  // ���� ����
    public String F_ENAME ;  // ����
    public String F_REGNO ;  // �ֹε�Ϲ�ȣ
    public String BIZNO   ;  // ����ڵ�Ϲ�ȣ
    public String BIZ_NAME;  // ��ȣ
    public String CNT     ;  // �Ǽ�
    public String BETRG   ;  // �ݾ�
    public String CC_BETRG;  // @v1.2�ſ�ī���
    public String CR_BETRG;  // @v1.2���ݿ�������
    public String CA_BETRG;  // @v1.2����
    public String CC_CNT;  // @v1.2�ſ�ī���
    public String CR_CNT;  // @v1.2���ݿ�������
    public String CA_CNT;  // @v1.2����
    public String OLDD    ;  // ��ο�� ����ڿ���
    public String OBST    ;  // ����ڿ���
    public String CONTENT ;  // �Ƿ�񳻿�
    public String CHNTS;	//����û��������
    public String METYP;	//�Ƿ������ڵ�
    public String METYP_NAME;	//�Ƿ������ڵ��
    public String OMIT_FLAG;	//���� �÷���
    public String GLASS_CHK;	//�Ȱ�����Ʈ������� 2011
    public String DIFPG_CHK; //���ӽü��� ���� �߰� @2015 ��������

}
