package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustGibuData.java
 * �������� - Ư��������α� ����Ÿ
 * [���� RFC] : ZHRP_RFC_YEAR_DONATION
 *
 * @author lsa
 * @version 1.0, 2005/11/17
 */
public class D11TaxAdjustGibuData extends com.sns.jdf.EntityData {

    public String MANDT     ;   //Ŭ���̾�Ʈ            
    public String WORK_YEAR ;   //�������� ����         
    public String BEGDA     ;   //������                
    public String ENDDA     ;   //������                
    public String PERNR     ;   //�����ȣ              
    public String GUBUN     ;   //�޿����� 1,  eHR��û 2
    public String SEQNR     ;   //����              

    public String DONA_CODE;	//��α����� �ڵ�
    public String DONA_NAME;	//��α����� ��Ī
    public String DONA_YYMM;	//��� ����
    public String DONA_DESC;	//��α� ����
    public String DONA_SEQN;	//��α� �Ϸù�ȣ
    public String DONA_COMP;	//���ó ��ȣ(���θ�)
    public String DONA_NUMB;	//���ó ����ڵ�Ϲ�ȣ
    public String DONA_AMNT;	//��α� �ݾ�
    public String CHNTS;	//����û��������
    
    public String SUBTY   ;   // ���� ����         CSR ID:1361257
    public String F_ENAME ;  // ����              CSR ID:1361257
    public String F_REGNO ;  // �ֹε�Ϲ�ȣ CSR ID:1361257
    
    public String DONA_CRVIN ;  // @2011 �̿����� ������
    public String DONA_CRVYR ;  // @2011 ��α� �̿����� ����
    public String DONA_DEDPR ;  // @2011 ������� ������ �ݾ� 
    public String OMIT_FLAG;
}
