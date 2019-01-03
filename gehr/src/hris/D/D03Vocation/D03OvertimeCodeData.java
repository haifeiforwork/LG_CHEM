package	hris.D.D03Vocation;

/**
 * D03OvertimeCodeData.java
 * ���������ڵ� ��ƿ��� ������
 *   [���� RFC] : ZHRP_RFC_OVERTIME_CODE
 * 
 * @author LSA    
 * @version 1.0, 2006/01/18
 */
public class D03OvertimeCodeData extends com.sns.jdf.EntityData {

    public String MANDT	    ; //3	 Ŭ���̾�Ʈ
    public String BUKRS	    ; //4	 ȸ���ڵ�
    public String MENU_CODE	; //2	 �޴�����
    public String OVTM_CODE	; //2	 �����ڵ�
    public String OVTM_TEXT	; //30 �����ؽ�Ʈ   
	public String getMANDT() {
		return MANDT;
	}
	public void setMANDT(String mANDT) {
		MANDT = mANDT;
	}
	public String getBUKRS() {
		return BUKRS;
	}
	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}
	public String getMENU_CODE() {
		return MENU_CODE;
	}
	public void setMENU_CODE(String mENU_CODE) {
		MENU_CODE = mENU_CODE;
	}
	public String getOVTM_CODE() {
		return OVTM_CODE;
	}
	public void setOVTM_CODE(String oVTM_CODE) {
		OVTM_CODE = oVTM_CODE;
	}
	public String getOVTM_TEXT() {
		return OVTM_TEXT;
	}
	public void setOVTM_TEXT(String oVTM_TEXT) {
		OVTM_TEXT = oVTM_TEXT;
	}
    
}