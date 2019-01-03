/********************************************************************************/
/*   System Name  	: MSS                                                         													*/
/*   1Depth Name  	: Manaer's Desk                                                  												*/
/*   2Depth Name  	: 휴가실적정보                                                    															*/
/*   Program Name 	: 휴가실적정보                                               																*/
/*   Program ID   		: D03VacationGeneratedData                                              								*/
/*   Description  		: Leave management Data                         														*/
/*   Note         		:                                                             														*/
/*   Creation    		: 2010-08-04  yji                                          											*/
/********************************************************************************/

package	hris.D.D03Vocation;

/**
 * D03VacationGeneratedDataEurp.java
 * for getting Quota Generated Data
 *   [관련 RFC] : ZHRP_GET_NO_OF_WORKDAY2
 *
 * @author zgw
 * @version 2007/09/13
 */
public class D03VacationGeneratedDataEurp extends com.sns.jdf.EntityData{

	public String QYEAR;
	public String KTART;
	public String KTEXT;
	public String ANZHL;
	public String KVERB;
	public String ANZHL_BAL;
	public String DEEND;
	public String getQYEAR() {
		return QYEAR;
	}
	public void setQYEAR(String qYEAR) {
		QYEAR = qYEAR;
	}
	public String getKTART() {
		return KTART;
	}
	public void setKTART(String kTART) {
		KTART = kTART;
	}
	public String getKTEXT() {
		return KTEXT;
	}
	public void setKTEXT(String kTEXT) {
		KTEXT = kTEXT;
	}
	public String getANZHL() {
		return ANZHL;
	}
	public void setANZHL(String aNZHL) {
		ANZHL = aNZHL;
	}
	public String getKVERB() {
		return KVERB;
	}
	public void setKVERB(String kVERB) {
		KVERB = kVERB;
	}
	public String getANZHL_BAL() {
		return ANZHL_BAL;
	}
	public void setANZHL_BAL(String aNZHL_BAL) {
		ANZHL_BAL = aNZHL_BAL;
	}
	public String getDEEND() {
		return DEEND;
	}
	public void setDEEND(String dEEND) {
		DEEND = dEEND;
	}



}
