/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계													*/
/*   Program Name	:   근태집계													*/
/*   Program ID		: D40DailStateData.java								*/
/*   Description		: 근태집계													*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40TmPersInAuthData.java
 * 현장직근태-부서근태담당자 조회
 * [관련 RFC] :  ZGHR_RFC_TM_PERS_IN_AUTH_LIST
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmPersInAuthData extends com.sns.jdf.EntityData {

	public String BUKRS;	//회사 코드
	public String GRUP_NUMB;	//사업장
	public String MORGEH;	//설정조직
	public String MORGEH_TX;	//설정조직명
	public String DORGEH;	//	권한조직
	public String DORGEH_TX;	//조직
	public String APERNR;	//	담당자사번
	public String ORGEH;	//담당자조직코드
	public String ORGEH_TX;	//담당자소속
	public String ENAME;	//담당자성명
	public String BEGDA;	//권한시작일
	public String ENDDA;	//	권한종료일
	public String SINCLUDE;	//하위조직포함여부
	public String SHORT;	//조직약어
	public String AEDTM;	//변경일
	public String AEZET;	//최종변경시간
	public String UNAME;	//사용자이름

	public String getBUKRS() {
		return BUKRS;
	}
	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}
	public String getGRUP_NUMB() {
		return GRUP_NUMB;
	}
	public void setGRUP_NUMB(String gRUP_NUMB) {
		GRUP_NUMB = gRUP_NUMB;
	}
	public String getMORGEH() {
		return MORGEH;
	}
	public void setMORGEH(String mORGEH) {
		MORGEH = mORGEH;
	}
	public String getMORGEH_TX() {
		return MORGEH_TX;
	}
	public void setMORGEH_TX(String mORGEH_TX) {
		MORGEH_TX = mORGEH_TX;
	}
	public String getDORGEH() {
		return DORGEH;
	}
	public void setDORGEH(String dORGEH) {
		DORGEH = dORGEH;
	}
	public String getDORGEH_TX() {
		return DORGEH_TX;
	}
	public void setDORGEH_TX(String dORGEH_TX) {
		DORGEH_TX = dORGEH_TX;
	}
	public String getAPERNR() {
		return APERNR;
	}
	public void setAPERNR(String aPERNR) {
		APERNR = aPERNR;
	}
	public String getORGEH() {
		return ORGEH;
	}
	public void setORGEH(String oRGEH) {
		ORGEH = oRGEH;
	}
	public String getORGEH_TX() {
		return ORGEH_TX;
	}
	public void setORGEH_TX(String oRGEH_TX) {
		ORGEH_TX = oRGEH_TX;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getENDDA() {
		return ENDDA;
	}
	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}
	public String getSINCLUDE() {
		return SINCLUDE;
	}
	public void setSINCLUDE(String sINCLUDE) {
		SINCLUDE = sINCLUDE;
	}
	public String getSHORT() {
		return SHORT;
	}
	public void setSHORT(String sHORT) {
		SHORT = sHORT;
	}
	public String getAEDTM() {
		return AEDTM;
	}
	public void setAEDTM(String aEDTM) {
		AEDTM = aEDTM;
	}
	public String getAEZET() {
		return AEZET;
	}
	public void setAEZET(String aEZET) {
		AEZET = aEZET;
	}
	public String getUNAME() {
		return UNAME;
	}
	public void setUNAME(String uNAME) {
		UNAME = uNAME;
	}





}

