/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ� ��ȯ��û                                           */
/*   Program Name : �����ڱ� ��ȯ��û                                           */
/*   Program ID   : E06RehouseData                                              */
/*   Description  : �����ڱݽ�û��ȯ ����Ÿ                                     */
/*   Note         : [���� RFC] : ZHRA_RFC_GET_FUND_REFUND_APP                   */
/*   Creation     : 2001-12-26  ������                                          */
/*   Update       : 2005-03-04  ������                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E06Rehouse;

public class E06RehouseData extends com.sns.jdf.EntityData
{
    public String MANDT       ;  // Ŭ���̾�Ʈ
    public String PERNR       ;  // �����ȣ
    public String BEGDA       ;  // ��û��
    public String AINF_SEQN   ;  // �������� �Ϸù�ȣ
    public String DLART       ;  // ��������
    
    public String REPT_DATE   ;  // ��ȯ�� �Ա�����
    public String BUDAT       ;  // ��ǥ������
    public String RPAY_AMNT   ;  // ��ȯ����
    public String INTR_AMNT   ;  // �����ڱ� ����
    public String TOTL_AMNT   ;  // �Ѿ�
    public String DARBT       ;  // ���ε� ����ݾ�
    public String DATBW       ;  // ������
    public String ALREADY_AMNT;  // ���ȯ�ݾ�
    public String ZZSECU_FLAG ;  // �����ο���
    public String NEWKO       ;  // �Ѱ����������
    public String SLIP_NUMB   ;  // ȸ����ǥ��ȣ
    public String POST_DATE   ;  // POSTING����
    public String BELNR       ;  // ȸ����ǥ��ȣ
    public String ZPERNR      ;  // �븮��û�� ���
    public String ZUNAME      ;  // �μ����� �̸�
    public String AEDTM       ;  // ������
    public String UNAME       ;  // ������̸�
    
    public String REMAIN_AMNT   ;  // ������̸�
    public String E_ALREADY_AMNT;  //���ȯ��
    public String E_DARBT       ;  //���ε� ����ݾ�
    public String E_DATBW       ;  //������
    public String E_INTR_AMNT   ;  //��������     
    public String E_REMAIN_AMNT ;  //�����ܾ�
    public String E_RPAY_AMNT   ;  //��ȯ����
    public String E_TOTAL_AMNT  ;  //�հ�     
    public String E_ZZSECU_FLAG ;  //��������
    public String E_ZZSECU_TXT  ;  //��������
    public String E_REPT_DATE   ;  //��¥
}

