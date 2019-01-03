/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : �������� ������ȯ                                       */
/*   Program Name : �������� ������ȯ                        */
/*   Program ID   : E03RetireTransInfoData                                         */
/*   Description  : ��������  ������ȯ ��û/��ȸ/����/����   ������                    */
/*   Note         : [���� RFC] : ZSOLRP_RFC_PENS_CHANGE_REQ                                                 */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireTransInfoData extends com.sns.jdf.EntityData{
	
	public String RETEXT;	//	������ȯ�� �����޽��� 
	
    public String AINF_SEQN;	//�������� �Ϸù�ȣ
    public String PERNR;	//��� ��ȣ 
    public String BEGDA;	//��û��
    public String GUBN;	//��������]������ȯ ����
    public String GUBN_TEXT; //[��������]������ȯ ���и�
    public String M_BEGDA;		//	���� �� ������
}
