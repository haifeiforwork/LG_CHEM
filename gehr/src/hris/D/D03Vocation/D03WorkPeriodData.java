package	hris.D.D03Vocation;

/**
 * D03WorkPeriodData.java
 * 개인 기간 작업 스케줄 취득 데이터
 *   [관련 RFC] : ZHRP_RFC_GET_WORK_PERIOD
 *   Global 일치
 * 
 * @author 김도신    
 * @version 1.0, 2002/01/24
 */
public class D03WorkPeriodData extends com.sns.jdf.EntityData {
    public String BEGDA   ;     // 시작일
    public String BEGUZ   ;     // 시간 데이터 엘리먼트
    public String ENDUZ   ;			// 시간 데이터 엘리먼트
    public String FLAG    ;			// '01' : 초과근무, '02' : 일과스케줄
    public String CHK_0340;     // 휴일비근무 신청가능한지 체크
    public String DAY;     // @csr1 월요일 1, 화요일 2, 수요일 3, ..토:6  일요일 7
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getBEGUZ() {
		return BEGUZ;
	}
	public void setBEGUZ(String bEGUZ) {
		BEGUZ = bEGUZ;
	}
	public String getENDUZ() {
		return ENDUZ;
	}
	public void setENDUZ(String eNDUZ) {
		ENDUZ = eNDUZ;
	}
	public String getFLAG() {
		return FLAG;
	}
	public void setFLAG(String fLAG) {
		FLAG = fLAG;
	}
	public String getCHK_0340() {
		return CHK_0340;
	}
	public void setCHK_0340(String cHK_0340) {
		CHK_0340 = cHK_0340;
	}
	public String getDAY() {
		return DAY;
	}
	public void setDAY(String dAY) {
		DAY = dAY;
	}

}