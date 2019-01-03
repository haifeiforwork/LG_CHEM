package hris.D ;

/**
 * D15RetirementSimulData.java
 *  �����ݼҵ���� Simulation ������
 *   [���� RFC] : ZHRP_RFC_SIM_CALC_RSGN_AMT
 * @author �輺��
 * @version 1.0, 2002/02/06
 *                      2015/07/30 [CSR ID:2838889] ������ �ùķ��̼� ���ݷ��� ���� ��û�� ��
 */
public class D15RetirementSimulData extends com.sns.jdf.EntityData {

//    public String _�������� ;   // �������� - ������������ �ùķ��̼ǿ��� ���ܵȴ�.
    /*  �ʱⰪ�� RFC�κ��� ����  */
    public String O_GIDAT           ;   // �����ݱ����  
    public String WAGE_AVER         ;   // ����ӱ�
//  2002.11.21. �߰�
    public String AVER_DATE         ;   // ����ӱݱ����
//  2002.11.21. �߰�
    public String SERV_PROD_Y       ;   // �ټӳ�        
    public String SERV_PROD_M       ;   // �ټӿ�        
    //public String O_ZIPY01          ;   // ��������޾�1 
    //public String O_ZIPY02          ;   // ��������޾�2 
    public String O_BONDM           ;   // ä�ǰ��з�����
    public String O_HLOAN           ;   // �����ڱݰ���  
    public String GRNT_RSGN         ;   // �������Ѿ�    
    public String O_NAPPR           ;   // ������ȯ��

    /*  ����ȸ�����޾װ� �������� RFC�κ��� ����  */
    public String INS1_NAME1        ;   // ������1  
    public String JON1_AMNT1        ;   // ���Ծ�1      
    public String INS1_NAME2        ;   // ������2 
    public String JON1_AMNT2        ;   // ���Ծ�2      
    public String INS1_NAME3        ;   // ������3 
    public String JON1_AMNT3        ;   // ���Ծ�3      
    public String INS1_NAME4        ;   // ������4 
    public String JON1_AMNT4        ;   // ���Ծ�4      
    public String INS1_NAME5        ;   // ������5 
    public String JON1_AMNT5        ;   // ���Ծ�5        
    public String INS1_NAME6        ;   // ������6 
    public String JON1_AMNT6        ;   // ���Ծ�6      
    public String INS1_NAME7        ;   // ������7 
    public String JON1_AMNT7        ;   // ���Ծ�7        
    public String INS1_NAME8        ;   // ������8 
    public String JON1_AMNT8        ;   // ���Ծ�8     
    public String INS1_NAME9        ;   // ������9 
    public String JON1_AMNT9        ;   // ���Ծ�9        
    public String INS1_NAME10        ;   // ������10 
    public String JON1_AMNT10        ;   // ���Ծ�10    

    /*  �Է¹޴� �ʵ�  */
    public String fu_retireDate     ;   // ������������   

    /*  ����ؾ��ϴ� ��  */
    public String _�������ټ�       ;   // �������ټ�  
    public String _�����ֹμ�       ;   // �����ֹμ�
    public String _�����Ѿ�         ;   // �����Ѿ�      
    public String _�������޾�       ;   // �������޾�    
    public String _ȸ�����޾�       ;   // ȸ�����޾�
    
    /* 20150730 �߰� */
    public String INC_TAX; //�������ټ�(new) CSR ID:2838889
    public String RES_TAX; //�����ֹμ�(new) CSR ID:2838889
}                                              
