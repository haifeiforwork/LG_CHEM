/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �λ�������ȸ                                                */
/*   Program Name : �λ��Ϻ� ��ȸ �� ���                                     */
/*   Program ID   : A01PersonalZHRH008SData                                     */
/*   Description  : �����̷� ������ ��ƿ��� ������                             */
/*   Note         : [���� RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A; 

public class A01PersonalZHRH008SData extends com.sns.jdf.EntityData {

    public String MC_STEXT1;  // �̸�(�����о�)
    public String OBJID_D  ;  // ����������ȣ
    public String OBJID    ;  // ����������ȣ
    public String TTEXT    ;  // ������Ʈ�̸�(������Ī)
    public String BEGDA    ;  // ������
    public String ENDDA    ;  // ������
    public String PERIOD   ;  // �Ⱓ(���������Ⱓ)
    public String ILSU     ;  // �Ϻ� ��ȿ�Ⱓ(�ϼ�)
    public String MC_STEXT ;  // �̸�(�������)
    public String PYONGGA  ;  // ��
    public String FLAG     ;  // FLAG(��ǥ=SPACE,����ǥ='X')(�����ʼ�����)
    public String DEL_FLAG ;  // �Ϲ��÷���
}