package hris.common;
/**
 * UplusSmsData.java
 *  
 * [R3 table] : ������ ȭȯ��û�� SMS�߼�
 *
 * @author lsa
 * @version 1.0, 2014/04/28
 */
public class UplusSmsData extends com.sns.jdf.EntityData {
	public String TR_SENDSTAT;		//�߼ۻ��� 0:�߼۴��,1: ���ۿϷ�,2:������ſϷ�	
    public String TR_MSGTYPE;		//������������ 0:�Ϲ�,1:�ݹ�URL �޼���
    public String TR_PHONE;			//������ �ڵ�����ȣ
    public String TR_CALLBACK;		//�۽��� ��ȭ��ȣ
    public String TR_MSG;				//�޼��� 
    
}
