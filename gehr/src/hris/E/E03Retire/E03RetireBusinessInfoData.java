/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : ���ݻ���ں���                                                 */
/*   Program Name : ���ݻ������ȸ                                   */
/*   Program ID   : E03RetireBusinessInfoData                                         */
/*   Description  : ���κ� ���ݻ���� ������                                */
/*   Note         : [���� RFC] : ZSOLRP_GET_REPEGUBN                                                  */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireBusinessInfoData extends com.sns.jdf.EntityData
{
	public String E_INSU_CODE;	//	���翬�ݻ��ڵ� 
	
	public String RETEXT;	//	���翬�ݻ纯��� �����޽��� 
	
	public String AINF_SEQN;	//	�����ȣ
    public String PERNR;		//	���
    public String BEGDA;		//	������
    public String INSU_CODE;	//	���ݻ��ڵ�
    public String INSU_NAME;	//	���ݻ��Ī
    public String M_BEGDA;		//	���� �� ������
}	
