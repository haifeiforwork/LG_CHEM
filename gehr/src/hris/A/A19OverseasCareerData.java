/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �ؿܰ���                                                    */
/*   Program Name : �ؿܰ��� ��ȸ                                               */
/*   Program ID   : A19OverseasCareerData                                       */
/*   Description  : �ؿܰ��� ������ ��ƿ��� ������                             */
/*   Note         : [���� RFC] : ZHRA_RFC_TRIP_LIST                             */
/*   Creation     : 2005-01-10  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package	hris.A;

public class A19OverseasCareerData extends com.sns.jdf.EntityData {

    public String PERNR     ;  // �����ȣ
    public String BEGDA     ;  // ������
    public String ENDDA     ;  // ������
    public String RESN_FLAG ;  // ��������
    public String RESN_TEXT ;  // ����(Ȱ���о�)
    public String RESN_DESC1;  // ����1(Ư�����1)
    public String RESN_DESC2;  // ����2(Ư�����2)
    public String DEST_ZONE ;  // ������(����)
    public String WAY1_ZONE ;  // ������
    public String WAY2_ZONE ;  // ������2
    public String CRCL_UNIT ;  // ��ü
    public String EDUC_WONX ;  // �ҿ���
}
