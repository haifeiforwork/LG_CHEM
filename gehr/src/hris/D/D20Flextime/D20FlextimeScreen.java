package hris.D.D20Flextime;

/**
 * D20FlextimeScreen.java
 * Flextime �κ�/�������� ���� ���
 * 2018-05-10  ��ȯ��   [WorkTime52] �κ�/�������� �ٹ��� ����
 * @author ��ȯ��
 * @version 1.0, 2018/05/10
 */
public enum D20FlextimeScreen {
	A, B, NONE;
	
	public static D20FlextimeScreen lookup(String str) {
		for(D20FlextimeScreen code : D20FlextimeScreen.values()) {
			if(code.name().equals(str)) return code;
		}
		return D20FlextimeScreen.NONE;
	}
}
