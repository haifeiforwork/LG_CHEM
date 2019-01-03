/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ������                                             */
/*   2Depth Name  : ������ ��ȸ                                                 */
/*   Program Name : ������ ��ȸ - DC�����                                  */
/*   Program ID   : E03RetireDCSimulData                                         */
/*   Description  : ������ ��ȸ  ������ - DC�����                          */
/*   Note         : [���� RFC] : ZSOLRP_RFC_GET_DEDUCTION_WHOLE                                                 */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                       */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireDCSimulData extends com.sns.jdf.EntityData{
	public String E_INSU_TEXT; //�������� �����
	
	public String ZYEAR;	//�⵵
	public String BETRG;	//ȸ�糳�Աݾ�
	public String ADD_BETRG;	//�߰����Աݾ�
	public String SUM_BETRG; //�հ�
}
