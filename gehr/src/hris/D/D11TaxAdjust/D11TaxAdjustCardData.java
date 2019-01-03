package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustCardData.java
 * �������� - �ſ�ī��.���ݿ�����.����� ����Ÿ
 * [���� RFC] : ZHRP_RFC_MEDI_YEA
 * 2012 ������忩���߰� 2012/12/13
 * CSR ID:C20140106_63914 ����ī�忩�� �߰�   2013/12/05
 * @author lsa    2006/11/23   
 */
public class D11TaxAdjustCardData extends com.sns.jdf.EntityData {       
	
    public String MANDT    ; //@v1.1 Ŭ���̾�Ʈ                               
    public String WORK_YEAR; //@v1.1 ī��Ʈ �Ű�����                     
    public String BEGDA    ; //@v1.1 ������                              
    public String ENDDA    ; //@v1.1 ������                              
    public String PERNR    ; //@v1.1 �����ȣ                            
    public String GUBUN    ; //@v1.1 ȸ�������� 1,  eHR��û 2            
    public String SEQNR    ; //@v1.1 ������ Ű�� ���� �������� ���ڵ��ȣ
    public String REGNO    ; //@v1.1 �ֹε�Ϲ�ȣ                        
    public String ENAME    ; //@v1.1 ��� �Ǵ� �������� �����̸�         

    public String SUBTY   ;  // ���� ����
    public String F_ENAME ;  // ����
    public String F_REGNO ;  // �ֹε�Ϲ�ȣ
    public String E_GUBUN  ;  // �������� �Է±��и�:1:�ſ�ī��,2:���ݿ�����,3:���强�����,4:����κ����          
    public String GU_NAME  ;  // �Է±��и�         
    public String BETRG   ;  // ��������
    public String BETRG_M ;  // �Ƿ�������
    public String BETRG_O ;  // �⺻������ �ƴ� ����ڿ��� ����� �Ƿ��ī�����
    public String CHNTS;     // ����û�ڷ�
    public String BETRG_B;     // ������ú�
    public String TRDMK;     // 2012 ������忩��
    
    public String CCTRA;     // CSR ID:C20140106_63914 ����ī�忩�� �߰�    
    public String OMIT_FLAG;	//����
    
    public String EXPRD;//@2014 �������� ���Ⱓ �ڵ�
    public String EXSTX;//@2014 �������� ���Ⱓ text
    
}
