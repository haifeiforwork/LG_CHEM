/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : �ߵ�����                                           */
/*   Program Name : �ߵ����� ��û/��ȸ/����/����                              */
/*   Program ID   : E03RetireMidOutInfoData                                         */
/*   Description  : �ߵ����� ��û/��ȸ/����/���� ������                      */
/*   Note         : [���� RFC] : ZSOLRP_RFC_MID_SEP_REQ                                                  */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
package hris.E.E03Retire;

public class E03RetireMidOutInfoData extends com.sns.jdf.EntityData{
	
	public String RETEXT;	//	�ߵ������ �����޽��� 
	
    public String AINF_SEQN;	//�������� �Ϸù�ȣ
    public String PERNR;	//��� ��ȣ 
    public String BEGDA;	//��û��
    public String REASON;	//��������]�ߵ���������ڵ�
    public String REASON_TEXT; //[��������]�ߵ���������ڵ��
    public String M_BEGDA;		//	���� �� ������
}
