/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태그룹 지정											*/
/*   Program Name	:   근태그룹 지정											*/
/*   Program ID		: D40TmGroupData.java									*/
/*   Description		: 근태그룹 지정												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40TmGroupData.java
 * 근태그룹 지정
 * [관련 RFC] :  ZGHR_RFC_TM_TIME_GRUP
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmGroupData extends com.sns.jdf.EntityData {

	public String PERNR;		 // 	사원 번호
	public String SEQNO;		 // 	근태그룹코드
	public String TIME_GRUP;		 //	근태그룹명
	public String TOTAL;		 // 	  	인원
	public String BEGDA;		 // 	  	시작일
	public String ENDDA;		 // 	  	종료일
	public String AEDTM;		 // 	  	변경일
	public String AEZET;		 // 	최종변경시간
	public String UNAME;	 // 	사용자이름

	public String I_PERNR;	// 	사원 번호
	public String I_DATUM;	// 	일자
	public String I_SPRSL;	// 	언어 키
	public String I_GTYPE;	// 	처리구분
	public String I_PABRJ;	// 	연도
	public String I_PABRP;	// 	월
	public String I_SEQNO;	//	근태그룹 Key

	public String CODE;	//
	public String TEXT;	//
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getSEQNO() {
		return SEQNO;
	}
	public void setSEQNO(String sEQNO) {
		SEQNO = sEQNO;
	}
	public String getTIME_GRUP() {
		return TIME_GRUP;
	}
	public void setTIME_GRUP(String tIME_GRUP) {
		TIME_GRUP = tIME_GRUP;
	}
	public String getTOTAL() {
		return TOTAL;
	}
	public void setTOTAL(String tOTAL) {
		TOTAL = tOTAL;
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
	public String getI_PERNR() {
		return I_PERNR;
	}
	public void setI_PERNR(String i_PERNR) {
		I_PERNR = i_PERNR;
	}
	public String getI_DATUM() {
		return I_DATUM;
	}
	public void setI_DATUM(String i_DATUM) {
		I_DATUM = i_DATUM;
	}
	public String getI_SPRSL() {
		return I_SPRSL;
	}
	public void setI_SPRSL(String i_SPRSL) {
		I_SPRSL = i_SPRSL;
	}
	public String getI_GTYPE() {
		return I_GTYPE;
	}
	public void setI_GTYPE(String i_GTYPE) {
		I_GTYPE = i_GTYPE;
	}
	public String getI_PABRJ() {
		return I_PABRJ;
	}
	public void setI_PABRJ(String i_PABRJ) {
		I_PABRJ = i_PABRJ;
	}
	public String getI_PABRP() {
		return I_PABRP;
	}
	public void setI_PABRP(String i_PABRP) {
		I_PABRP = i_PABRP;
	}
	public String getI_SEQNO() {
		return I_SEQNO;
	}
	public void setI_SEQNO(String i_SEQNO) {
		I_SEQNO = i_SEQNO;
	}
	public String getCODE() {
		return CODE;
	}
	public void setCODE(String cODE) {
		CODE = cODE;
	}
	public String getTEXT() {
		return TEXT;
	}
	public void setTEXT(String tEXT) {
		TEXT = tEXT;
	}




}

