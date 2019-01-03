package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustDeductData.java
 * �������� - Ư������, Ư������ ������, ��Ÿ/���װ��� ������
 * [���� RFC] : ZHRP_RFC_YEAR_SPECIAL, ZHRP_RFC_YEAR_EDU, ZHRP_RFC_YEAR_TAX
 *
 * @author �赵��
 * @version 1.0, 2002/11/20
 */
public class D11TaxAdjustDeductData extends com.sns.jdf.EntityData {

    public String GUBN_CODE  ;   // �������� ����
    public String GOJE_CODE  ;   // �����ڵ�
    public String GUBN_TEXT  ;   // ���� �ؽ�Ʈ
    //public String SUBTY      ;   // �Ϻ�����
    public String STEXT      ;   // �Ϻ������̸�
    //public String ENAME      ;   // ��� �Ǵ� �������� �����̸�
    //public String REGNO      ;   // �ֹε�Ϲ�ȣ
    //public String FASAR      ;   // ������������ �з�
    public String FATXT      ;   // �з¸�
    public String ADD_BETRG  ;   // HR �޿�����: �ݾ�
    public String ACT_BETRG  ;   // HR �޿�����: �ݾ�
    public String AUTO_BETRG ;   // HR �޿�����: �ݾ�
    public String AUTO_TEXT  ;   // �ڵ��г���
    public String GOJE_FLAG  ;   // �÷���
    public String FTEXT      ;   // �ʵ��ؽ�Ʈ
    public String FLAG       ;   //
    //public String CHNTS;	 //����û��������
    public String REQ_H;	 //������ ���� üũ
    //public String OMIT_FLAG;	//���� �÷���
    //public String EXSTY;	//@2011 �������Ժ��


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
    public String FASAR ; //�з�
    public String BETRG; //�ݾ�
    public String CHNTS;	 //����û��������
    public String ACT_CHECK;	//����� ������ ������
    public String OMIT_FLAG;	//���� �÷���
    public String EXSTY;	//@2011 �������Ժ��    //[CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� ��    public String LOAN;	//@2017 ���ڱݻ�ȯ
}