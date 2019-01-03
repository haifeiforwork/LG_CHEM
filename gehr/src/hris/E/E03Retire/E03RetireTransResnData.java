/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : �������� ������ȯ                                       */
/*   Program Name : �������� ������ȯ ���� ��ȸ                         */
/*   Program ID   : E03RetireTransResnData                                         */
/*   Description  : �������� ������ȯ ���� ��ȸ ������                     */
/*   Note         : [���� RFC] : ZSOLRP_GET_TEXT                                                 */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireTransResnData extends com.sns.jdf.EntityData{
	public String GUBN;	//��������]������ȯ ����
	public String GUBN_TEXT;	//��������]������ȯ ���и�
	public String PERIOD;		//��������]������ȯ �ֱ�
	public String CHANCE;		//��������]������ȯ �ñ�	
	public String GUBN_RESN;	//��������]������ȯ ���
}
