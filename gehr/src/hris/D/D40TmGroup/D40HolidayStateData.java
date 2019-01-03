/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표												*/
/*   Program Name	:   근태집계표 휴가사용현황								*/
/*   Program ID		: D40HolidayStateData.java							*/
/*   Description		: 근태집계표 휴가사용현황									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40HolidayStateData.java
 * 현장직근태-휴가사용현황
 * [관련 RFC] :  ZGHR_RFC_TM_GET_HOLIDAY_LIST
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40HolidayStateData extends com.sns.jdf.EntityData {

	public String PERNR;	//사번
	public String KNAME;	//	한글이름
	public String ORGEH;	//조직코드
	public String ORGTX;	//	조직명
	public String TITL2;	//	호칭텍스트
	public String TITEL;	//	호칭텍스트
	public String TRFGR;	//호봉 그룹
	public String TRFST;	//호봉 단계
	public String VGLST;	//비교급여범위레벨
	public String DAT01;	//일자
	public String PERSK;	//사원 하위 그룹
	public String TITEL_S;	//경칭
	public String TITEL_T;	//경칭
	public String SHORT;	//	오브젝트 약어
	public String OCCUR;	//휴가발생일수
	public String ABWTG;	//휴가사용일수
	public String ZKVRB;	//휴가잔여일수
	public String CONSUMRATE;	//휴가사용율

	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getKNAME() {
		return KNAME;
	}
	public void setKNAME(String kNAME) {
		KNAME = kNAME;
	}
	public String getORGEH() {
		return ORGEH;
	}
	public void setORGEH(String oRGEH) {
		ORGEH = oRGEH;
	}
	public String getORGTX() {
		return ORGTX;
	}
	public void setORGTX(String oRGTX) {
		ORGTX = oRGTX;
	}
	public String getTITL2() {
		return TITL2;
	}
	public void setTITL2(String tITL2) {
		TITL2 = tITL2;
	}
	public String getTITEL() {
		return TITEL;
	}
	public void setTITEL(String tITEL) {
		TITEL = tITEL;
	}
	public String getTRFGR() {
		return TRFGR;
	}
	public void setTRFGR(String tRFGR) {
		TRFGR = tRFGR;
	}
	public String getTRFST() {
		return TRFST;
	}
	public void setTRFST(String tRFST) {
		TRFST = tRFST;
	}
	public String getVGLST() {
		return VGLST;
	}
	public void setVGLST(String vGLST) {
		VGLST = vGLST;
	}
	public String getDAT01() {
		return DAT01;
	}
	public void setDAT01(String dAT01) {
		DAT01 = dAT01;
	}
	public String getPERSK() {
		return PERSK;
	}
	public void setPERSK(String pERSK) {
		PERSK = pERSK;
	}
	public String getTITEL_S() {
		return TITEL_S;
	}
	public void setTITEL_S(String tITEL_S) {
		TITEL_S = tITEL_S;
	}
	public String getTITEL_T() {
		return TITEL_T;
	}
	public void setTITEL_T(String tITEL_T) {
		TITEL_T = tITEL_T;
	}
	public String getSHORT() {
		return SHORT;
	}
	public void setSHORT(String sHORT) {
		SHORT = sHORT;
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
	public String getZKVRB() {
		return ZKVRB;
	}
	public void setZKVRB(String zKVRB) {
		ZKVRB = zKVRB;
	}
	public String getCONSUMRATE() {
		return CONSUMRATE;
	}
	public void setCONSUMRATE(String cONSUMRATE) {
		CONSUMRATE = cONSUMRATE;
	}



}

