package hris.F;

/**
 * F76DeptEmergencyContactsDataUsa.java
 * 부서별 비상연락망 내용을 담는 데이터
 * [관련 RFC] : ZHRA_RFC_EMG_CONTACTS
 * Organization & Staffing > Personnel Info > Emergency Contacts [USA]
 * 
 * @author jungin
 * @version 1.0, 2010/10/11
 */

public class F76DeptEmergencyContactsDataUsa extends com.sns.jdf.EntityData {

	public String 	PERNR	;//	NUMC	8	사원 번호
	public String 	ORGEH	;//	NUMC	8	조직 단위
	public String 	ORGTX	;//	CHAR	40	소속명
	public String 	ENAME	;//	CHAR	40	사원 또는 지원자의 포맷된 이름
	public String 	BUKRS	;//	CHAR	4	회사 코드
	public String 	WERKS	;//	CHAR	4	인사 영역
	public String 	NAME1	;//	CHAR	30	인사 영역 텍스트
	public String 	BTRTL	;//	CHAR	4	인사 하위 영역
	public String 	BTEXT	;//	CHAR	 15 	인사 하위 영역 텍스트
	public String 	PERSG	;//	CHAR	 1 	사원 그룹
	public String 	PGTXT	;//	CHAR	 20 	사원 그룹 이름
	public String 	PERSK	;//	CHAR	 2 	사원 하위 그룹
	public String 	PKTXT	;//	CHAR	 20 	사원 하위 그룹 이름
	public String 	STELL	;//	NUMC	 8 	직무
	public String 	STLTX	;//	CHAR	 40 	직무명
	public String 	DAT01	;//	DATS	 8 	그룹입사일
	public String 	DAT02	;//	DATS	 8 	회사입사일
	public String 	DAT03	;//	DATS	 8 	현직위승진일
	public String 	DAT04	;//	DATS	 8 	근속기준일
	public String 	JIKWE	;//	CHAR	 20 	직위
	public String 	JIKWT	;//	CHAR	 40 	직위명
	public String 	JIKCH	;//	CHAR	 20 	직급
	public String 	JIKCT	;//	CHAR	 40 	직급명
	public String 	JIKKB	;//	CHAR	 20 	직책
	public String 	JIKKT	;//	CHAR	 40 	직책명
	public String 	MOLGA	;//	CHAR	 2 	국가 그루핑
	public String 	PHONE_NUM	;//	CHAR	 20 	담당자의 전화번호
	public String 	VGLST	;//	CHAR	 8 	Level/Annual
	public String 	ANNUL	;//	CHAR	 2 	Level Years
	public String 	RLSHP	;//	NUMC	 1 	Relationship
	public String 	RLSHPTX	;//	CHAR	 30 	관계
	public String 	RLNAME	;//	CHAR	 40 	관계인 이름
	public String 	ENACHN	;//	CHAR	 40 	Last Name
	public String 	EVORNA	;//	CHAR	 40 	First Name
	public String 	EMGPH1	;//	CHAR	 14 	Emerg.Ph#1
	public String 	EMGPH2	;//	CHAR	 14 	Emerg.Ph#2


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

	public String getRLSHP() {
		return RLSHP;
	}

	public void setRLSHP(String RLSHP) {
		this.RLSHP = RLSHP;
	}

	public String getRLSHPTX() {
		return RLSHPTX;
	}

	public void setRLSHPTX(String RLSHPTX) {
		this.RLSHPTX = RLSHPTX;
	}

	public String getRLNAME() {
		return RLNAME;
	}

	public void setRLNAME(String RLNAME) {
		this.RLNAME = RLNAME;
	}

	public String getENACHN() {
		return ENACHN;
	}

	public void setENACHN(String ENACHN) {
		this.ENACHN = ENACHN;
	}

	public String getEVORNA() {
		return EVORNA;
	}

	public void setEVORNA(String EVORNA) {
		this.EVORNA = EVORNA;
	}

	public String getEMGPH1() {
		return EMGPH1;
	}

	public void setEMGPH1(String EMGPH1) {
		this.EMGPH1 = EMGPH1;
	}

	public String getEMGPH2() {
		return EMGPH2;
	}

	public void setEMGPH2(String EMGPH2) {
		this.EMGPH2 = EMGPH2;
	}
}
