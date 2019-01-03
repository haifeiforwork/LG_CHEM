/********************************************************************************/
/*		System Name 	: g-HR
/*   	1Depth Name 	: Organization & Staffing
/*   	2Depth Name 	: Personnel Info
/*   	Program Name	: Expiry of Contract
/*   	Program ID   	: F31Dept4YearValuationData.java
/*   	Description  	: 계약만료현황 조회를 위한 DATA 파일
/*   	Note         		: 없음
/*   	Creation     	: 2010-07-22 yji
/*		Update			: 2010-10-13 jungin	@v1.0 기간(개월수) 변수 추가
/*							: 2010-11-05 jungin @v1.1 LGCPI법인 Agency, Bill Rate, OT Bill Rate 변수 추가
/********************************************************************************/

package hris.F;

/**
 * F72ExpiryOfContractDataEurp
 *  계약만료현황 내용을 담는 데이터
 *
 * @author yji
 * @version 1.0, 2010-07-22
 */
public class F72ExpiryOfContractDataEurp extends com.sns.jdf.EntityData {

    public String 	PERNR	;
    public String 	ORGEH	;
    public String 	ORGTX	;
    public String 	ENAME	;
    public String 	BUKRS	;
    public String 	WERKS	;
    public String 	NAME1	;
    public String 	BTRTL	;
    public String 	BTEXT	;
    public String 	PERSG	;
    public String 	PGTXT	;
    public String 	PERSK	;
    public String 	PKTXT	;
    public String 	STELL	;
    public String 	STLTX	;
    public String 	DAT01	;
    public String 	DAT02	;
    public String 	DAT03	;
    public String 	DAT04	;
    public String 	JIKWE	;
    public String 	JIKWT	;
    public String 	JIKCH	;
    public String 	JIKCT	;
    public String 	JIKKB	;
    public String 	JIKKT	;
    public String 	MOLGA	;
    public String 	PHONE_NUM;
    public String 	VGLST	;
    public String 	ANNUL	;
    public String 	BEGDA	;
    public String 	ENDDA	;
    public String 	CTTYP	;
    public String 	CTTXT	;
    public String 	DURAT	;
    public String 	OBJID	;
    public String 	STEXT	;
    public String 	BILRTE	;
    public String 	BWAERS	;
    public String 	OTBRTE	;
    public String 	OWAERS	;

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getORGEH() {
        return ORGEH;
    }

    public void setORGEH(String ORGEH) {
        this.ORGEH = ORGEH;
    }

    public String getORGTX() {
        return ORGTX;
    }

    public void setORGTX(String ORGTX) {
        this.ORGTX = ORGTX;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getBUKRS() {
        return BUKRS;
    }
    public void setBUKRS(String BUKRS) {
    	this.BUKRS = BUKRS;
    }
    public String getWERKS() {
        return WERKS;
    }
    public void setWERKS(String WERKS) {
        this.WERKS = WERKS;
    }

    public String getNAME1() {
        return NAME1;
    }

    public void setNAME1(String NAME1) {
        this.NAME1 = NAME1;
    }

    public String getBTRTL() {
        return BTRTL;
    }

    public void setBTRTL(String BTRTL) {
        this.BTRTL = BTRTL;
    }

    public String getBTEXT() {
        return BTEXT;
    }

    public void setBTEXT(String BTEXT) {
        this.BTEXT = BTEXT;
    }

    public String getPERSG() {
        return PERSG;
    }

    public void setPERSG(String PERSG) {
        this.PERSG = PERSG;
    }

    public String getPGTXT() {
        return PGTXT;
    }

    public void setPGTXT(String PGTXT) {
        this.PGTXT = PGTXT;
    }

    public String getPERSK() {
        return PERSK;
    }

    public void setPERSK(String PERSK) {
        this.PERSK = PERSK;
    }

    public String getPKTXT() {
        return PKTXT;
    }

    public void setPKTXT(String PKTXT) {
        this.PKTXT = PKTXT;
    }

    public String getSTELL() {
        return STELL;
    }

    public void setSTELL(String STELL) {
        this.STELL = STELL;
    }

    public String getSTLTX() {
        return STLTX;
    }

    public void setSTLTX(String STLTX) {
        this.STLTX = STLTX;
    }

    public String getDAT01() {
        return DAT01;
    }

    public void setDAT01(String DAT01) {
        this.DAT01 = DAT01;
    }

    public String getDAT02() {
        return DAT02;
    }

    public void setDAT02(String DAT02) {
        this.DAT02 = DAT02;
    }

    public String getDAT03() {
        return DAT03;
    }

    public void setDAT03(String DAT03) {
        this.DAT03 = DAT03;
    }

    public String getDAT04() {
        return DAT04;
    }

    public void setDAT04(String DAT04) {
        this.DAT04 = DAT04;
    }

    public String getJIKWE() {
        return JIKWE;
    }

    public void setJIKWE(String JIKWE) {
        this.JIKWE = JIKWE;
    }

    public String getJIKWT() {
        return JIKWT;
    }

    public void setJIKWT(String JIKWT) {
        this.JIKWT = JIKWT;
    }

    public String getJIKCH() {
        return JIKCH;
    }

    public void setJIKCH(String JIKCH) {
        this.JIKCH = JIKCH;
    }

    public String getJIKCT() {
        return JIKCT;
    }

    public void setJIKCT(String JIKCT) {
        this.JIKCT = JIKCT;
    }

    public String getJIKKB() {
        return JIKKB;
    }

    public void setJIKKB(String JIKKB) {
        this.JIKKB = JIKKB;
    }

    public String getJIKKT() {
        return JIKKT;
    }

    public void setJIKKT(String JIKKT) {
        this.JIKKT = JIKKT;
    }

    public String getMOLGA() {
        return MOLGA;
    }

    public void setMOLGA(String MOLGA) {
        this.MOLGA = MOLGA;
    }

    public String getPHONE_NUM() {
        return PHONE_NUM;
    }

    public void setPHONE_NUM(String PHONE_NUM) {
        this.PHONE_NUM = PHONE_NUM;
    }

    public String getVGLST() {
        return VGLST;
    }

    public void setVGLST(String VGLST) {
        this.VGLST = VGLST;
    }

    public String getANNUL() {
        return ANNUL;
    }

    public void setANNUL(String ANNUL) {
        this.ANNUL = ANNUL;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
    }

    public String getCTTYP() {
        return CTTYP;
    }

    public void setCTTYP(String CTTYP) {
        this.CTTYP = CTTYP;
    }

    public String getCTTXT() {
        return CTTXT;
    }

    public void setCTTXT(String CTTXT) {
        this.CTTXT = CTTXT;
    }

    public String getDURAT() {
        return DURAT;
    }

    public void setDURAT(String DURAT) {
        this.DURAT = DURAT;
    }

    public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getBILRTE() {
        return BILRTE;
    }

    public void setBILRTE(String BILRTE) {
        this.BILRTE = BILRTE;
    }

    public String getBWAERS() {
        return BWAERS;
    }

    public void setBWAERS(String BWAERS) {
        this.BWAERS = BWAERS;
    }

    public String getOTBRTE() {
        return OTBRTE;
    }

    public void setOTBRTE(String OTBRTE) {
        this.OTBRTE = OTBRTE;
    }

    public String getOWAERS() {
        return OWAERS;
    }

    public void setOWAERS(String OWAERS) {
        this.OWAERS = OWAERS;
    }
}
