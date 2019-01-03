package	hris.common;

/**
 * AppLineKey.java
 * �ϳ��� Row�� ���������� �������� ���� Key
 *   [���� RFC] :  ZHRA_RFC_FIND_DECISIONER  
 *
 * @author �輺��  
 * @version 1.0, 2001/12/13
 */
public class AppLineKey extends com.sns.jdf.EntityData {

    public String APPR_TYPE;    //��������
    public String I_DATE   ;    //��û����(���ø����̼�����)
    public String I_PERNR  ;    //�����ȣ
    public String UPMU_FLAG;    //��������������
	public String UPMU_TYPE;    //��������
    public String from_date;    //��û�� From
    public String to_date  ;    //��û�� To
    public String APPR_STAT;    //�������
    public String ANZHL;    //�������
    public String E_ABRTG;    //�������
    public String DAYS;    //�������
    public String AWART;    //�������
}
