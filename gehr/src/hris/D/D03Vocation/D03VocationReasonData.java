package	hris.D.D03Vocation;

/**
 * D03WorkPeriodData.java
 * 개인 기간 작업 스케줄 취득 데이터
 *   [관련 RFC] : ZHRP_RFC_GET_WORK_PERIOD
 *
 * @author 김도신
 * @version 1.0, 2002/01/24
 */
public class D03VocationReasonData extends com.sns.jdf.EntityData {
    public String SCODE   ;     // 코드
    public String STEXT   ;     // 텍스트
	public String getSCODE() {
		return SCODE;
	}
	public void setSCODE(String sCODE) {
		SCODE = sCODE;
	}
	public String getSTEXT() {
		return STEXT;
	}
	public void setSTEXT(String sTEXT) {
		STEXT = sTEXT;
	}

}