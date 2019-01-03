package hris.D.D20Flextime;

/**
 * D20FlextimeScreen.java
 * Flextime 부분/완전선택 구분 상수
 * 2018-05-10  성환희   [WorkTime52] 부분/완전선택 근무제 변경
 * @author 성환희
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
