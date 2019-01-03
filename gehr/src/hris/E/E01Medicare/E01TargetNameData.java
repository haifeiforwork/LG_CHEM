package hris.E.E01Medicare;

/**
 * E01TargetNameData.java
 * �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û�� �̸��� ��ȸ�� �ϴ� ������
 *   [���� RFC] : ZHRW_RFC_P_GET_TARGET_NAME
 *
 * @author �ڿ���
 * @version 1.0, 2002/01/28
 */
public class E01TargetNameData extends com.sns.jdf.EntityData {

    public String SUBTY;      //�Ϻ�����
    public String OBJPS;      //������Ʈ�ĺ�
    public String FNMHG;      //�̸�
    public String LNMHG;      //��
	public String getSUBTY() {
		return SUBTY;
	}
	public void setSUBTY(String sUBTY) {
		SUBTY = sUBTY;
	}
	public String getOBJPS() {
		return OBJPS;
	}
	public void setOBJPS(String oBJPS) {
		OBJPS = oBJPS;
	}
	public String getFNMHG() {
		return FNMHG;
	}
	public void setFNMHG(String fNMHG) {
		FNMHG = fNMHG;
	}
	public String getLNMHG() {
		return LNMHG;
	}
	public void setLNMHG(String lNMHG) {
		LNMHG = lNMHG;
	}


}