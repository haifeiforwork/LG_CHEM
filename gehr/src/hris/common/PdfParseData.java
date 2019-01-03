package hris.common;

/**
 * PdfParseData.java
 *  �������� ����û PDF ����
 *   [���� RFC] : ZSOLYR_RFC_PDF_UPLOAD
 *
 * @author ������
 * @version 1.0, 2013/07/01
 */
public class PdfParseData extends com.sns.jdf.EntityData {
    //�����
	public String FORM_CD     ;    //�����ڵ�
    public String F_REGNO;    //�ֹε�Ϲ�ȣ
    public String F_ENAME ;    //����
    public String DAT_CD      ;    //�ڷ��ڵ�
    public String FILE_SEQ     ;    //���� ����

	//�����
    public String INSU_REGNO     ;    //�ֹε�Ϲ�ȣ_���Ǻ�����
    public String INSU_NAME     ;    //����_���Ǻ�����
    public String BETRG     ;    //�ݾ�

    //�Ƿ��
    public String BIZNO     ;    //����ڹ�ȣ
    public String BIZ_NAME  ;    //��ȣ
    public String CA_BETRG     ;    //�ݾ�

    //������
    public String EDU_TYPE     ;    //����������
    //public String BETRG     ;    //�ݾ�

    //Ư������
    //public String START_DT   ;    //����������
    public String BEGDA; //����������
    public String REPAY_YEARS   ;    //��ȯ�Ⱓ����
    public String DEBT     ;    //���Ա�
    public String FIXED_RATE_DEBT     ;    //�����ݸ����Ա�
    public String NOT_DEFER_DEBT     ;    //���ġ�Ļ�ȯ���Ա�
    public String THIS_YEAR_REDE_AMT     ;    //���س⵵ ���ݻ�ȯ��
    public String SUM     ;    //�����հ��

    //��α�
    public String DONA_CODE     ;    //�������
    //public String BIZNO     ;    //����ڹ�ȣ
    //public String BIZ_NAME     ;    //��ȣ
    //public String BETRG     ;    //�����հ��

    //�����������
    public String SAVING_GUBN ;    //���౸��
    public String FINCO     ;    //����ȸ�� �� �ڵ�
    public String PENSION_CD     ;    // ���ݱ����ڵ�
    public String ACCNO;  // ����/���ǹ�ȣ
    //public String BETRG;   // �����հ��

    //�ſ�ī��
    public String USE_PLACE_CD;   // ����
    //public String BETRG     ;    // �����հ��    //@2014 �������� �ſ�ī�� �κ� �������    public String PRE_TOT_AMT;//������_�Ϲݰ��� ���ݾ��հ�    public String PRE_MARKET_TOT_AMT;//������_�������������ݾ��հ�    public String PRE_TMONEY_TOT_AMT;//������_���߱���������ݾ��հ�    public String FIRST_TOT_AMT;//��ݱ�_���ݾ��հ�    public String SECOND_TOT_AMT;//�Ϲݱ� ���ݾ��հ�

    //OUTPUT
    //public String F_REGNO;
    //public String F_ENAME;
    //public String DAT_CD;
    public String ITEM;
    public String MESSAGE;

    //PDF���������
    public String MANDT;	//Ŭ���̾�Ʈ
    public String WORK_YEAR;	//ī��Ʈ �Ű�����
    public String PERNR;	//��� ��ȣ
    public String SEQNR;	//������ Ű�� ���� ����Ÿ�� ���ڵ� ��ȣ
    public String FILE_NAME;	//PDF File ��    public String XML_TEXT; //@2015  �������� �ű�
}
