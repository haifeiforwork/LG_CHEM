package	hris.D.D03Vocation;
/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 휴가실적정보                                                */
/*   Program Name : 휴가실적정보                                                */
/*   Program ID   : D03VacationUsedData                                    */
/*   Description  : Leave management Data               */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2007-09-13  zhouguangwen  global e-hr update                                                            */
/********************************************************************************/

/**
 * D03VacationUsedData.java
 * 개인의 하계휴가 사용정보를 담아오는 데이터
 *   [관련 RFC] : ZHRW_RFC_VACATION_USED
 *
 * @author 배민규
 * @version 1.0, 2003/09/08
 */
public class D03VacationUsedData extends com.sns.jdf.EntityData {

    public String getDATUM() {
		return DATUM;
	}
	public void setDATUM(String dATUM) {
		DATUM = dATUM;
	}
	public String getLGART() {
		return LGART;
	}
	public void setLGART(String lGART) {
		LGART = lGART;
	}
	public String getANZHL() {
		return ANZHL;
	}
	public void setANZHL(String aNZHL) {
		ANZHL = aNZHL;
	}
	public String getABRTG() {
		return ABRTG;
	}
	public void setABRTG(String aBRTG) {
		ABRTG = aBRTG;
	}
	public String getJANUA() {
		return JANUA;
	}
	public void setJANUA(String jANUA) {
		JANUA = jANUA;
	}
	public String getFEBRU() {
		return FEBRU;
	}
	public void setFEBRU(String fEBRU) {
		FEBRU = fEBRU;
	}
	public String getMARCH() {
		return MARCH;
	}
	public void setMARCH(String mARCH) {
		MARCH = mARCH;
	}
	public String getAPRIL() {
		return APRIL;
	}
	public void setAPRIL(String aPRIL) {
		APRIL = aPRIL;
	}
	public String getMAY() {
		return MAY;
	}
	public void setMAY(String mAY) {
		MAY = mAY;
	}
	public String getJUNE() {
		return JUNE;
	}
	public void setJUNE(String jUNE) {
		JUNE = jUNE;
	}
	public String getJULY() {
		return JULY;
	}
	public void setJULY(String jULY) {
		JULY = jULY;
	}
	public String getAUGUS() {
		return AUGUS;
	}
	public void setAUGUS(String aUGUS) {
		AUGUS = aUGUS;
	}
	public String getSEPTE() {
		return SEPTE;
	}
	public void setSEPTE(String sEPTE) {
		SEPTE = sEPTE;
	}
	public String getOCTOB() {
		return OCTOB;
	}
	public void setOCTOB(String oCTOB) {
		OCTOB = oCTOB;
	}
	public String getNOVEM() {
		return NOVEM;
	}
	public void setNOVEM(String nOVEM) {
		NOVEM = nOVEM;
	}
	public String getDECEM() {
		return DECEM;
	}
	public void setDECEM(String dECEM) {
		DECEM = dECEM;
	}
	public String getTOTAL() {
		return TOTAL;
	}
	public void setTOTAL(String tOTAL) {
		TOTAL = tOTAL;
	}
	public String DATUM ;   // 하계휴가일자
    public String LGART ;   // 임금유형
    public String ANZHL ;   // 임금유형별 근무시간수
    public String ABRTG ;   // 급여일수


//  zgw 2007/09/13

    public String JANUA;   //January
    public String FEBRU;   //February
    public String MARCH;   //March
    public String APRIL;   //April
    public String MAY;     //May
    public String JUNE;    //June
    public String JULY;    //July
    public String AUGUS;   //August
    public String SEPTE;   //September
    public String OCTOB;   //October
    public String NOVEM;   //November
    public String DECEM;   //December
    public String TOTAL;   //TOTAL





//  zgw 2007/09/13
}