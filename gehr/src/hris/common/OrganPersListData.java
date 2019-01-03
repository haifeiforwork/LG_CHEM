/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : ������ �˻�                                               */
/*   Program ID   : OrganPersListData.java                                      */
/*   Description  : ������ �˻� �� ��������� �������� DATA ����                */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-21 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common;

/**
 * OrganPersListData.java
 * �μ�ID�� ��ȸ�� ��� ������ ���� ������
 * [���� RFC] :  ZHRA_RFC_GET_ORGEH_PERS_LIST
 *  
 * @author �����  
 * @version 1.0, 2005/01/21 
 */ 
public class OrganPersListData extends com.sns.jdf.EntityData {
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
}

