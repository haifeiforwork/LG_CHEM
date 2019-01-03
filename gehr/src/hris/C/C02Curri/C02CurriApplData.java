/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� �ȳ�/��û                                          */
/*   Program Name : �������� Data                                               */
/*   Program ID   : C02CurriApplData                                            */
/*   Description  : �������� ������ ����ϴ� Data                               */
/*   Note         : [���� RFC] : ZHRE_RFC_EVENT_LIST                            */
/*   Creation     : 2002-01-15  �ڿ���                                          */
/*   Update       : 2005-03-08  ������                                          */
/*                                                                              */
/********************************************************************************/

package hris.C.C02Curri;

public class C02CurriApplData extends com.sns.jdf.EntityData {

    public String P_AINF_SEQN;  // �������� �Ϸù�ȣ
    public String P_CHAID;      // ������ƮID
    public String P_CONF_TYPE;  // �������
    public String P_FDATE;      // ������
    public String P_PERNR;      // �����ȣ
    public String P_TDATE;      // ������

    public String MANDT    ;  // Ŭ���̾�Ʈ�ѹ�
    public String PERNR    ;  // �����ȣ -
    public String BEGDA    ;  // ��û��
    public String AINF_SEQN;  // �������� �Ϸù�ȣ
    public String GWAID    ;  // ����ID
    public String GWAJUNG  ;  // ������
    public String GBEGDA   ;  // ������
    public String GENDDA   ;  // ������
    public String CHASU    ;  // ����
    public String CHAID    ;  // ����ID
    public String ENAME    ;  // �̸�
    public String ORGTX    ;  // ���������ؽ�Ʈ
    public String TITEL    ;  // ��å
    public String TRFGR    ;  // �޿��׷�
    public String TRFST    ;  // �޿�����
    public String VGLST    ;  // �񱳱޿���������
    public String TEXT     ;  // ��û����
    public String EDU_CANC ;  // �������� ��� Flag( 'X' = ��� )
    public String ZPERNR   ;  // �븮��û�� ���
    public String ZUNAME   ;  // �μ����� �̸�
    public String AEDTM    ;  // ������
    public String UNAME    ;  // ������̸�
}
