package	hris.D.D03Vocation;

/**
 * D03OvertimeCode2Data.java
 * ���������ڵ� ��ƿ��� ������
 *   [���� RFC] : ZHRP_RFC_OVERTIME_CODE
 * 
 * @author LSA    
 * @version 1.0, 2006/01/18
 */
public class D03OvertimeCode2Data extends com.sns.jdf.EntityData {

    public String MANDT	    ; //3	 Ŭ���̾�Ʈ
    public String BUKRS	    ; //4	 ȸ���ڵ�
    public String MENU_CODE	; //2	 �޴�����
    public String OVTM_CODE	; //2	 ZHRC108T	�����ڵ�
    public String OVTM_CODE2; //2	 �����ڵ�
    public String OVTM_TEXT2; //30 �����ؽ�Ʈ
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
	public String getOVTM_CODE2() {
		return OVTM_CODE2;
	}
	public void setOVTM_CODE2(String oVTM_CODE2) {
		OVTM_CODE2 = oVTM_CODE2;
	}
	public String getOVTM_TEXT2() {
		return OVTM_TEXT2;
	}
	public void setOVTM_TEXT2(String oVTM_TEXT2) {
		OVTM_TEXT2 = oVTM_TEXT2;
	}
 

}