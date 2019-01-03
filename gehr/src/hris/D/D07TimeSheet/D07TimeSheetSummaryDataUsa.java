package hris.D.D07TimeSheet;

/**
 *	 D07TimeSheetSummaryDataUsa.java
 *  Time Sheet내, Hours Summary 정보를 담아오는 데이터
 *  [관련 RFC] : ZHRE_RFC_TIME_SHEET [USA]
 *
 * @author jungin
 * @version 1.0, 2010/10/12
 */

public class D07TimeSheetSummaryDataUsa extends com.sns.jdf.EntityData {

    public String LGTXT;		// Time Type
    public String WKHRS;		// Hours
	public String getLGTXT() {
		return LGTXT;
	}
	public void setLGTXT(String lGTXT) {
		LGTXT = lGTXT;
	}
	public String getWKHRS() {
		return WKHRS;
	}
	public void setWKHRS(String wKHRS) {
		WKHRS = wKHRS;
	}

}
