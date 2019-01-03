package hris.D.D25WorkTime;

/**
 * D25WorkTimeTweeksData.java 2018-05-28 성환희 [WorkTime52] 실근무 실적현황
 * 
 * @author 성환희
 * @version 1.0, 2018/05/28
 */
public class D25WorkTimeTweeksData extends com.sns.jdf.EntityData {

	public String WEEKS; // 주차( week no.)
	public String WBEGDA; // 시작일
	public String WENDDA; // 종료일
	public String TWEEKS; // 주차 No.
	public String TPERIOD; // 기간 조합

	public String getWEEKS() {
		return WEEKS;
	}

	public void setWEEKS(String wEEKS) {
		WEEKS = wEEKS;
	}

	public String getWBEGDA() {
		return WBEGDA;
	}

	public void setWBEGDA(String wBEGDA) {
		WBEGDA = wBEGDA;
	}

	public String getWENDDA() {
		return WENDDA;
	}

	public void setWENDDA(String wENDDA) {
		WENDDA = wENDDA;
	}

	public String getTWEEKS() {
		return TWEEKS;
	}

	public void setTWEEKS(String tWEEKS) {
		TWEEKS = tWEEKS;
	}

	public String getTPERIOD() {
		return TPERIOD;
	}

	public void setTPERIOD(String tPERIOD) {
		TPERIOD = tPERIOD;
	}

}
