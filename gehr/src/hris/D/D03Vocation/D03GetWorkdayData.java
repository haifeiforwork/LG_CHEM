package	hris.D.D03Vocation;

/**
 * D03GetWorkdayData.java
 * 개인의 휴가신청 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRP_GET_NO_OF_WORKDAY
 *  Global 일치
 * @author 배민규
 * @version 1.0, 2004/07/13
 * 
 * UPDATE		: 2018-05-17 성환희 [WorkTime52] 보상휴가 추가 건
 * update       : 2018/06/08 rdcamel [CSR ID:3700538] 보상휴가제 도입에 따른 Mobile 휴가신청 및 결재화면 수정 요청 건
 */
public class D03GetWorkdayData extends com.sns.jdf.EntityData {
    public String PERNR		;		// 사원번호
    public String KSOLL		;		// 근태일수
    public String ABWTG		;		// 사용휴가
    public String ZKVRB		;		// 잔여휴가
    public String OCCUR		;		// 발생일수
    public String OCCUR1	;		// 사전부여휴가 발생일수
	public String ABWTG1    ;       // 사전부여휴가 사용일수
	public String ZKVRB1	;		// 사전부여휴가 잔여일수
	public String OCCUR2	;		// 선택적보상휴가 발생일수
	public String ABWTG2	;		// 선택적보상휴가 사용일수
	public String ZKVRB2	;		// 선택적보상휴가 잔여일수
	public String ZKVRBTX	;		// 잔여휴가 TEXT
	
	//[CSR ID:3700538] 보상휴가제 도입에 따른 Mobile 휴가신청 및 결재화면 수정 요청 건
	public String RDAYS;//잔여보상휴가일수
	public String RHOURS; //잔여보상휴가시간
	public String REMAINT;//잔여 휴가 일수 text
	
	
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getKSOLL() {
		return KSOLL;
	}
	public void setKSOLL(String kSOLL) {
		KSOLL = kSOLL;
	}
	public String getABWTG() {
		return ABWTG;
	}
	public void setABWTG(String aBWTG) {
		ABWTG = aBWTG;
	}
	public String getZKVRB() {
		return ZKVRB;
	}
	public void setZKVRB(String zKVRB) {
		ZKVRB = zKVRB;
	}
	public String getOCCUR() {
		return OCCUR;
	}
	public void setOCCUR(String oCCUR) {
		OCCUR = oCCUR;
	}
	public String getOCCUR1() {
		return OCCUR1;
	}
	public void setOCCUR1(String oCCUR1) {
		OCCUR1 = oCCUR1;
	}
	public String getABWTG1() {
		return ABWTG1;
	}
	public void setABWTG1(String aBWTG1) {
		ABWTG1 = aBWTG1;
	}
	public String getZKVRB1() {
		return ZKVRB1;
	}
	public void setZKVRB1(String zKVRB1) {
		ZKVRB1 = zKVRB1;
	}
	public String getOCCUR2() {
		return OCCUR2;
	}
	public void setOCCUR2(String oCCUR2) {
		OCCUR2 = oCCUR2;
	}
	public String getABWTG2() {
		return ABWTG2;
	}
	public void setABWTG2(String aBWTG2) {
		ABWTG2 = aBWTG2;
	}
	public String getZKVRB2() {
		return ZKVRB2;
	}
	public void setZKVRB2(String zKVRB2) {
		ZKVRB2 = zKVRB2;
	}
	public String getZKVRBTX() {
		return ZKVRBTX;
	}
	public void setZKVRBTX(String zKVRBTX) {
		ZKVRBTX = zKVRBTX;
	}
	public String getRDAYS() {
		return RDAYS;
	}
	public void setRDAYS(String rDAYS) {
		RDAYS = rDAYS;
	}
	public String getRHOURS() {
		return RHOURS;
	}
	public void setRHOURS(String rHOURS) {
		RHOURS = rHOURS;
	}
	
}
