/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ����														*/
/*   Program Name	:   ������ �˻� �� �������								*/
/*   Program ID		: D40OrganInsertData.java								*/
/*   Description		: ������ �˻� �� ������� 									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40OrganPersListData.java
 * ������ �˻� �� �������
 * [���� RFC] :  ZGHR_RFC_TM_GET_ORGEH_PERS
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40OrganPersListData extends com.sns.jdf.EntityData {
    public String PERNR  ;   //�����ȣ
    public String ENAME  ;   //��� �̸�
    public String ORGEH  ;   //�ҼӺμ�
    public String ORGTX  ;   //�ҼӺμ� �ؽ�Ʈ
    public String STELL  ;   //����
    public String STLTX  ;   //������
    public String BTRTL  ;   //�λ���������
    public String BTEXT  ;   //�λ��������� �ؽ�Ʈ
    public String STAT2  ;   //������	  3:�����, 0:������, 1,2:������

    public String JIKWE;   //	ZEHRJIKWE	CHAR	20	0	����
    public String JIKWT;   //	ZEHRJIKWT	CHAR	40	0	������
    public String  JIKCH;   //	ZEHRJIKCH	CHAR	20	0	����
    public String JIKCT;   //	ZEHRJIKCT	CHAR	40	0	���޸�
    public String JIKKB	;   //ZEHRJIKKB	CHAR	20	0	��å
    public String  JIKKT;   //	ZEHRJIKKT	CHAR	40	0	��å��
    public String  OBJID;   //	ZEHRJIKKT	CHAR	40	0	��å��
    public String  PGTXT;   //	����
}

