/********************************************************************************/
/*                                                                              																*/
/*   System Name  	: MSS                                                         													*/
/*   1Depth Name  	: Manaer's Desk                                                  												*/
/*   2Depth Name  	: »ﬁ∞°Ω«¿˚¡§∫∏                                                    															*/
/*   Program Name 	: »ﬁ∞°Ω«¿˚¡§∫∏                                               																*/
/*   Program ID   		: D03VacationGeneratedData                                              								*/
/*   Description  		: Leave management Data                         														*/
/*   Note         		:                                                             														*/
/*   Creation    		: 2002-01-21  chldudgh                                          											*/
/*   Update       		: 2007-09-13  zhouguangwen  global e-hr update                                         			*/
/*   						: 2008-03-25  ±Ë¡§¿Œ                                       															*/
/*							  [CSRπ¯»£ : C20080325_39053] Welfare Leave(∫π∏Æ»ﬁ∞°) « µÂ√ﬂ∞°								*/
/********************************************************************************/

package hris.D.D03Vocation;

/**
 * D03VacationGeneratedData.java
 * for getting Quota Generated Data
 *   [∞¸∑√ RFC] : ZHRP_GET_NO_OF_WORKDAY
 *
 * @author zgw
 * @version 2007/09/13
 * update date : 2017/12/18 rdcamel [CSR ID:3544114] [LGCTW]Request of Global HR Portal system Compensatory Leave(‹Õ˝Ã £) function increasing 
 */
public class D03VacationGeneratedData extends com.sns.jdf.EntityData{

	public String getCOMGE() {
		return COMGE;
	}
	public void setCOMGE(String cOMGE) {
		COMGE = cOMGE;
	}
	public String getCOMUS() {
		return COMUS;
	}
	public void setCOMUS(String cOMUS) {
		COMUS = cOMUS;
	}
	public String getCOMBA() {
		return COMBA;
	}
	public void setCOMBA(String cOMBA) {
		COMBA = cOMBA;
	}
	public String getCOMVA() {
		return COMVA;
	}
	public void setCOMVA(String cOMVA) {
		COMVA = cOMVA;
	}
	public String getCOAGE() {
		return COAGE;
	}
	public void setCOAGE(String cOAGE) {
		COAGE = cOAGE;
	}
	public String getCOAUS() {
		return COAUS;
	}
	public void setCOAUS(String cOAUS) {
		COAUS = cOAUS;
	}
	public String getCOABA() {
		return COABA;
	}
	public void setCOABA(String cOABA) {
		COABA = cOABA;
	}
	public String getCOAVA() {
		return COAVA;
	}
	public void setCOAVA(String cOAVA) {
		COAVA = cOAVA;
	}
	public String getCYAGE() {
		return CYAGE;
	}
	public void setCYAGE(String cYAGE) {
		CYAGE = cYAGE;
	}
	public String getCYAUS() {
		return CYAUS;
	}
	public void setCYAUS(String cYAUS) {
		CYAUS = cYAUS;
	}
	public String getCYABA() {
		return CYABA;
	}
	public void setCYABA(String cYABA) {
		CYABA = cYABA;
	}
	public String getCYAVA() {
		return CYAVA;
	}
	public void setCYAVA(String cYAVA) {
		CYAVA = cYAVA;
	}
	public String getWUAGE() {
		return WUAGE;
	}
	public void setWUAGE(String wUAGE) {
		WUAGE = wUAGE;
	}
	public String getWUAUS() {
		return WUAUS;
	}
	public void setWUAUS(String wUAUS) {
		WUAUS = wUAUS;
	}
	public String getWUABA() {
		return WUABA;
	}
	public void setWUABA(String wUABA) {
		WUABA = wUABA;
	}
	public String getWUAVA() {
		return WUAVA;
	}
	public void setWUAVA(String wUAVA) {
		WUAVA = wUAVA;
	}
	public String getWFAGE() {
		return WFAGE;
	}
	public void setWFAGE(String wFAGE) {
		WFAGE = wFAGE;
	}
	public String getWFAUS() {
		return WFAUS;
	}
	public void setWFAUS(String wFAUS) {
		WFAUS = wFAUS;
	}
	public String getWFABA() {
		return WFABA;
	}
	public void setWFABA(String wFABA) {
		WFABA = wFABA;
	}
	public String getWFAVA() {
		return WFAVA;
	}
	public void setWFAVA(String wFAVA) {
		WFAVA = wFAVA;
	}
	public String COMGE;     //carry over/monthly leave generated
	public String COMUS;     //carry over monthly leave/used
	public String COMBA;     //carry over monthly leave/balance
	public String COMVA;     //carry over monthly leave/validity limit
	public String COAGE;     //carry over annual leave/generated
	public String COAUS;     //carry over annual leave/used
	public String COABA;     //carry over annual leave/balance
	public String COAVA;     //carry over annual leave/validity limit
	public String CYAGE;     //current year annual leave/generated
	public String CYAUS;     //current year annual leave/used
	public String CYABA;     //current year annual leave/balance
	public String CYAVA;     //current year annual leave/validity limit


    /***************************************************
    *    Welfare Leave(∫π∏Æ»ﬁ∞°) « µÂ√ﬂ∞°.
    *    [CSRπ¯»£ : C20080325_39053]
    *    2008-03-25.	±Ë¡§¿Œ.
    ***************************************************/
	public String WUAGE ;
	public String WUAUS;
	public String WUABA;
	public String WUAVA;
	public String WFAGE ;
	public String WFAUS;
	public String WFABA;
	public String WFAVA;
	
	 /***************************************************
	    *    Compensatory Leave øÎ « µÂ√ﬂ∞°.
	    *    [CSR ID:3544114] [LGCTW]Request of Global HR Portal system Compensatory Leave(‹Õ˝Ã £) function increasing 
	    *    2017-12-18 ¿Ã¡ˆ¿∫(rdcamel)
	    ***************************************************/
	public String CLLGE ;//Compensatory Leave Generated-Last Payroll period
	public String CLLUS;//Compensatory Leave Used-Last Payroll period
	public String CLLBA;//Compensatory Leave Balance-Last Payroll period
	public String CLLVA;//Compensatory Leave valid date-Last Payroll period
	public String CLCGE;//Compensatory Leave Generated-This Payroll period
	public String CLCUS;//Compensatory Leave Used-This Payroll period
	public String CLCBA;//Compensatory Leave Balance-This Payroll period
	public String CLCVA;//Compensatory Leave valid date-This Payroll period
	

}
