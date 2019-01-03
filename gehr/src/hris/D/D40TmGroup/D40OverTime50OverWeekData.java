/********************************************************************************/
/*																				*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  부서근태												*/
/*   2Depth Name		:  초과근무												*/
/*   Program Name	:  초과근무													*/
/*   Program ID		:  D40OverTime50OverWeekData.java							*/
/*   Description		:  초과근무 												*/
/*   Note				:             											*/
/*   Creation			:  2018-06-18  성환희 [Worktime52]                       */
/*   Update				:  											         	*/
/*                                                                              */
/********************************************************************************/

package hris.D.D40TmGroup;

/**
 * D40OverTime50OverWeekData.java 현장직근태-초과근무 [관련 RFC] : ZGHR_RFC_TM_OVERTIME
 *
 * @author 성환희
 * @version 1.0, 2018/06/18
 */
public class D40OverTime50OverWeekData extends com.sns.jdf.EntityData {

	public String PERNR; // 사원 번호
	public String ENAME; // 사원 또는 지원자의 포맷된 이름
	public String BEGDA; // 시작일
	public String ENDDA; // 종료일
	public String WWKTM; // 수

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
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

	public String getWWKTM() {
		return WWKTM;
	}

	public void setWWKTM(String wWKTM) {
		WWKTM = wWKTM;
	}

}
