/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : �������� ��û                                       */
/*   Program Name : �������� ��û/��ȸ/����/����                             */
/*   Program ID   : E03RetireRegistInfoData                                         */
/*   Description  : ��������  ��û/��ȸ/����/���� ������                       */
/*   Note         : [���� RFC] : ZSOLRP_RFC_PENSION_REQ                                                 */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireRegistInfoData extends com.sns.jdf.EntityData{
	
	public String RETEXT;	//	�������� ��û�� �����޽��� 
	
    public String AINF_SEQN;	//�������� �Ϸù�ȣ
    public String PERNR;	//��� ��ȣ 
    public String BEGDA;	//��û��
    public String REPE_GUBN;	//��������]�������� ����
    public String REPE_NAME; //[��������]�������� ���и�
    public String INSU_CODE;	//DC�� ��� ���� ���� �ڵ�
    public String INSU_NAME;	//DC�� ��� ���� �����    
    public String M_BEGDA;		//	���� �� ������
}
