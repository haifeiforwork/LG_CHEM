package	hris.A;

/**
 * A03AccountDetail3Data.java
 * F/B ���ΰ��� ������ ��ƿ��� ������
 *   [���� RFC] : ZHRH_RFC_BANK_STOCK_LIST
 * 
 * @author ��α�    
 * @version 1.0, 2004/05/27
 */
public class A03AccountDetail3Data extends com.sns.jdf.EntityData {
    public String MANDT;			// Ŭ���̾�Ʈ
    public String LIFNR;			// ����ó �Ǵ� ä���� ������ȣ
    public String BANKS;			// ���౹��Ű
    public String BANKL;			// ���� Ű
    public String BANKN;			// ������¹�ȣ(��BANKN+1(17))
    public String BKONT;			// �������Ű
    public String BVTYP;			// �ŷ�ó��������
    public String XEZER;			// ������: �߽ɱ����� �ֽ��ϱ�?
    public String BKREF;			// ������� ���� ������
    public String KOINH;			// �����(��������)
    public String EBPP_ACCNAME;		// ������� ����������̸�
    public String EBPP_BVSTATUS;	// Biller Direct���� ����� ����
}
