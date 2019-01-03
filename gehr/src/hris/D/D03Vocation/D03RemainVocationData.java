/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 휴가실적정보                                                */
/*   Program Name : 휴가실적정보                                                */
/*   Program ID   : D03RemainVocationData                                    */
/*   Description  : Leave management Data               */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2007-09-13  zhouguangwen  global e-hr update                                                            */
/*				  : 2018-05-17  성환희 [WorkTime52] 보상휴가 추가 건
/*  Global일치 */
/********************************************************************************/

package hris.D.D03Vocation;

/**
 * D03RemainVocationData.java
 * 개인의 잔여휴가일수 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRW_RFC_GET_REMAIN_HOLIDAY
 *
 * @author 김도신
 * @version 1.0, 2002/01/21
 */
public class D03RemainVocationData extends com.sns.jdf.EntityData {

	public String getZKVRB() {
		return ZKVRB;
	}

	public void setZKVRB(String zKVRB) {
		ZKVRB = zKVRB;
	}

	public String E_REMAIN; // 올해 잔여휴가일수
	// public String E_REMAIN0 ; // 올해를 기준으로 D-1년 잔여휴가일수
	// public String E_REMAIN1 ; // 올해 잔여휴가일수
	// public String E_REMAIN2 ; // 올해를 기준으로 D+1년 잔여휴가일수

	// public String P_FROM0 ; // 올해를 기준으로 D-1년 시작일
	// public String P_TOXX0 ; // 올해를 기준으로 D-1년 종료일
	// public String P_FROM1 ; // 올해 시작일
	// public String P_TOXX1 ; // 올해 종료일
	// public String P_FROM2 ; // 올해를 기준으로 D+1년 시작일
	// public String P_TOXX2 ; // 올해를 기준으로 D+1년 종료일

	public String E_IS_SHIFT; // 장치교대
	public String E_RETURN;

	public String ANZHL_GEN; // Total Generated
	public String ANZHL_USE; // Total Used
	public String ANZHL_BAL; // Total Balance
	public String BUKRS; // Company Code
	public String CSDAT; // Initial Date of Continuous Service

	public String OCCUR; // 국내:생성일수
	public String ABWTG; // 국내:사용일수
	public String ZKVRB; // 국내:잔여일수

	// @rdcamel 추가 (유연휴가제) 2016.12.15
	public String OCCUR3; // 유연휴가
	public String ABWTG3; // 유연휴가 사용갯수
	public String ZKVRB3; // 잔여
	
	// 성환희 추가 [Worktime52] 2018.05.16
	public String ZKVRBTX; 	// 잔여휴가 TEXT
	public String E_COMP; 	// 보상휴가 우선선택 여부(Null:연차휴가 우선선택, X: 보상휴가 우선선택)

	public String getE_RETURN() {
		return E_RETURN;
	}

	public void setE_RETURN(String e_RETURN) {
		E_RETURN = e_RETURN;
	}

	public String getANZHL_GEN() {
		return ANZHL_GEN;
	}

	public void setANZHL_GEN(String aNZHL_GEN) {
		ANZHL_GEN = aNZHL_GEN;
	}

	public String getANZHL_USE() {
		return ANZHL_USE;
	}

	public void setANZHL_USE(String aNZHL_USE) {
		ANZHL_USE = aNZHL_USE;
	}

	public String getANZHL_BAL() {
		return ANZHL_BAL;
	}

	public void setANZHL_BAL(String aNZHL_BAL) {
		ANZHL_BAL = aNZHL_BAL;
	}

	public String getBUKRS() {
		return BUKRS;
	}

	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}

	public String getCSDAT() {
		return CSDAT;
	}

	public void setCSDAT(String cSDAT) {
		CSDAT = cSDAT;
	}

	public String getOCCUR() {
		return OCCUR;
	}

	public void setOCCUR(String oCCUR) {
		OCCUR = oCCUR;
	}

	public String getABWTG() {
		return ABWTG;
	}

	public void setABWTG(String aBWTG) {
		ABWTG = aBWTG;
	}

	public String getE_REMAIN() {
		return E_REMAIN;
	}

	public void setE_REMAIN(String E_REMAIN) {
		E_REMAIN = E_REMAIN;
	}

	public String getE_IS_SHIFT() {
		return E_IS_SHIFT;
	}

	public void setE_IS_SHIFT(String E_IS_SHIFT) {
		E_IS_SHIFT = E_IS_SHIFT;
	}

	// @rdcamel 추가 (유연휴가제) 2016.12.15
	public void set_OCCUR3(String oCCUR3) {
		OCCUR3 = oCCUR3;
	}

	public String getOCCUR3() {
		return OCCUR3;
	}

	public void set_ABWTG3(String aBWTG3) {
		ABWTG3 = aBWTG3;
	}

	public String getABWTG3() {
		return ABWTG3;
	}

	public void set_ZKVRB3(String zKVRB3) {
		ZKVRB3 = zKVRB3;
	}

	public String getZKVRB3() {
		return ZKVRB3;
	}

	public String getZKVRBTX() {
		return ZKVRBTX;
	}

	public void setZKVRBTX(String zKVRBTX) {
		ZKVRBTX = zKVRBTX;
	}

	public String getE_COMP() {
		return E_COMP;
	}

	public void setE_COMP(String E_COMP) {
		E_COMP = E_COMP;
	}

}