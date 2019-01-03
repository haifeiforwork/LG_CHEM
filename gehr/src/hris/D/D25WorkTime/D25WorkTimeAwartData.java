package hris.D.D25WorkTime;

/**
 * D25WorkTimeAwartData.java
 * 2018-05-24  성환희    [WorkTime52] 실 근로시간 레포트
 * @author 성환희
 * @version 1.0, 2018/05/24
 */
public class D25WorkTimeAwartData extends com.sns.jdf.EntityData {

	public String AWART; // 근무유형
	public String ATEXT; // 근무유형명

	public String getAWART() {
		return AWART;
	}

	public void setAWART(String aWART) {
		AWART = aWART;
	}

	public String getATEXT() {
		return ATEXT;
	}

	public void setATEXT(String aTEXT) {
		ATEXT = aTEXT;
	}

}
