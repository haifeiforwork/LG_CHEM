/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ο���                                                    */
/*   Program Name : ���ο���/���̶����� �ؾ��û                                */
/*   Program ID   : E11AnnulmentBuildSV                                         */
/*   Description  : ���ο���/���̶����� ��ȸ/��û/����                          */
/*   Note         : [���� RFC] : ZHRW_RFC_PENTION_APPLICATION [1],              */
/*                               ZHRW_RFC_PENTION_DISPLAY [2]                   */
/*   Creation     : 2002-02-04  �ڿ���                                          */
/*   Update       : 2005-02-25  ������                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E11Personal;

public class E11PersonalData extends com.sns.jdf.EntityData {

    public String MANDT      ;  // Ŭ���̾�Ʈ
    public String PERNR      ;  // �����ȣ
    public String BEGDA      ;  // ������
    public String ENDDA      ;  // ������
    public String AINF_SEQN  ;  // �������� �Ϸù�ȣ
    public String APPL_TYPE  ;  // ��û����(1:��û, 2:�ؾ�)[1]
    public String PENT_TYPE  ;  // ���ݱ���
    public String BANK_TYPE  ;  // �������
    public String ENTR_DATE  ;  // ��û��
    public String ENTR_TERM  ;  // ���ԱⰣ
    public String MNTH_AMNT  ;  // �����Ծ�
    public String PERL_AMNT  ;  // ���γ��Ծ�
    public String CMPY_AMNT  ;  // ȸ�糳�Ծ�
    public String CMPY_FROM  ;  // ������
    public String CMPY_TOXX  ;  // ����������(������)

    public String CMPY_DATE  ;  // ȸ�������ѵ���
    public String ZPENT_TEXT1;  // ���ο��� �ؽ�Ʈ
    public String ZPENT_TEXT2;  // ������� �ؽ�Ʈ
    public String CLOSE_DATE ;  // ����������
    public String ZPERNR     ;  // �븮��û�� ���
    public String ZUNAME     ;  // �μ����� �̸�
    public String AEDTM      ;  // ������
    public String UNAME      ;  // ������̸�

    public String SUMM_AMNT  ;  // ���Դ���
    public String RESM_TERM  ;  // �ܿ���//���
    public String LAST_MNTH  ;  // ���Կ�
    
    //�߰�
    public String ABDN_DATE  ;  //�ؾ���
    public String PENT_TEXT  ;  //���ݱ��� �ؽ�Ʈ
    public String BANK_TEXT  ;  //�����Ⱓ �ؽ�Ʈ
    public String STATUS     ;  //�����¸� ��Ÿ�� ����, ������, ����Ϸ�
}
