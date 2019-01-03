package	hris.D.D03Vocation;

/**
 * D03OvertimeCodeData.java
 * 근태유형코드 담아오는 데이터
 *   [관련 RFC] : ZHRP_RFC_OVERTIME_CODE
 * 
 * @author LSA    
 * @version 1.0, 2006/01/18
 */
public class D03OvertimeCodeData extends com.sns.jdf.EntityData {

    public String MANDT	    ; //3	 클라이언트
    public String BUKRS	    ; //4	 회사코드
    public String MENU_CODE	; //2	 메뉴구분
    public String OVTM_CODE	; //2	 사유코드
    public String OVTM_TEXT	; //30 사유텍스트   
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