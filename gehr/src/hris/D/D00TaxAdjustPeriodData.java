package hris.D ;

/**
 * D00TaxAdjustPeriodData.java
 * �������� �Ⱓ Data 
 *   [���� RFC] : ZHRW_RFC_P_ACCURATE_ACCOUNT
 * 
 * @author �輺�� 
 * @version 1.0, 2002/02/04
 */
public class D00TaxAdjustPeriodData extends com.sns.jdf.EntityData { 
    public String MANDT       ;  // Ŭ���̾�Ʈ
    public String BUKRS        ;  // ȸ���ڵ�
    public String YEA_YEAR   ;  // ��������⵵
    public String APPL_FROM ;  // �������� ��û/���� ������
    public String APPL_TOXX ;  // �������� ��û/���� ������
    public String SIMU_FROM ;  // �������� �ù����̼� ������
    public String SIMU_TOXX ;  // �������� �ù����̼� ������
    public String DISP_FROM ;  // �������� ������ȸ ������
    public String DISP_TOXX ;  // �������� ������ȸ ������
    public String YEAR_OPEN ;  // �ٷμҵ� ��õ¡����û ���۰��ɳ���� 2012����������߰�
}
