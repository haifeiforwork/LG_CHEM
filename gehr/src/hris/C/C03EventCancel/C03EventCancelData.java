/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ��������  ��û   ���                                    */
/*   Program Name : �������� Data                                               */
/*   Program ID   : C03EventCancelData                                            */
/*   Description  : �������� ������ ����ϴ� Data                               */
/*   Note         : [���� RFC] : ZHRD_RFC_EVENT_CANCLE_APPROVAL                            */
/*   Creation     : 2013-06-11  lsa                                          */
/*   Update       :                                            */
/*                                                                              */
/********************************************************************************/

package hris.C.C03EventCancel;

public class C03EventCancelData extends com.sns.jdf.EntityData {

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
    public String EDU_CANC ;  //  ��� ���� ����
    public String CANC_NUM ;  // ��� ��û Ƚ��                
    public String CHPERNR  ;  // ��� ��ȣ                     
    public String CHENAME  ;  // ��� �Ǵ� �������� ���˵� �̸�
    public String CHORGTX  ;  // ���� ���� ����                
    public String CHTITEL  ;  // ����                          
    public String CHPHONE  ;  // ��� ID/��ȣ                  
    public String CHEMAIL  ;  // ���: �� ID/��ȣ              
    public String ZPERNR   ;  // �븮��û�� ���               
 
}
