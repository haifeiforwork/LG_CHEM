package hris.D ;
/**
 * D14TaxAdjustCodeData.java
 * �������� �ùķ��̼� Data �� ���������ȸ ȭ�鿡 �ѷ��� ����Ÿ
 * [RFC] ,ZHRP_RFC_READ_YEA_RESULT
 *  
 * @version 1.0 2014/01/17  C20140106_63914 ABART : ���� *, ''  �ؿ�  S �ؿܱٹ��Ⱓ(1~6��), T �ؿܱٹ��Ⱓ(7~12��) L �����ٹ��Ⱓ  �׸� �߰��Ǿ� 
 *                                     �ѱ� data����  
 * @version 3.0 2015/05/18 [CSR ID:2778743] �������� ������ȸ ȭ�� ����                                    
 *  
 */

public class D14TaxAdjustCodeData extends com.sns.jdf.EntityData {

    public String code ;    
    public String value ;    
    public String gubn ; 
    public String subCode; //@2014�������� �߰�
    public String subCode2; //@2014�������� �߰�
    public String reTax2014; //2014�������� ������

    public String ABART ;    //�޿� ��� ��Ģ�� ���� ��� ���� �׷� �׷���
    public String LGART ;    //�ӱ� ����
    public String BETRG ;    //HR �޿�����: �ݾ�
    public String CNTR1 ;	 //LGART�� second ���� @2014 �������� �߰� 20150126
    public String VOZNR;    //LGART�� second ����2 @2014 �������� �߰� 20150126
    
    public String BTZNR;    //[CSR ID:2778743] ��������� ��/�� �� �ٸ��� üũ 77�̸� (��)//2014�������� ������
}
