/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �λ�������ȸ                                                */
/*   Program Name : �λ��Ϻ� ��ȸ �� ���                                     */
/*   Program ID   : A01PersonalZHRH003SData                                     */
/*   Description  : �ڰݸ��� ������ ��ƿ��� ������                             */
/*   Note         : [���� RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A;
 
public class A01PersonalZHRH003SData extends com.sns.jdf.EntityData {

    public String LICN_NAME;  // �ڰ�����
    public String OBN_DATE ;  // �����
    public String GRAD_NAME;  // �ڰݵ�޸�
    public String PUBL_ORGH;  // ����ó
    public String FLAG     ;  // FLAG(��ǥ=SPACE,����ǥ='X')(�������ӿ���)
}