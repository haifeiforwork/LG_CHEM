/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 어학 인정점수 조회                                   */
/*   Program ID   : F23DeptLanguageData                                         */
/*   Description  : 부서별 어학 인정점수 조회를 위한 DATA 파일                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-27 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F; 

/**
 * F23DeptLanguageData
 *  부서별 어학 인정점수 내용을 담는 데이터
 * 
 * @author 유용원
 * @version 1.0, 
 */
public class F23DeptLanguageData extends com.sns.jdf.EntityData {

    /* 해외 */
    public String 	ANNUL	;//	CHAR	 2 	Level Years
    public String 	LGT01	;//	CHAR	 60 	CET
    public String 	LGT03	;//	CHAR	 60 	TOEIC
    public String 	LGT07	;//	CHAR	 60 	JLPT
    public String 	LGT08	;//	CHAR	 60 	NSS
    public String 	LGT09	;//	CHAR	 60 	KPT
    public String 	LGT12	;//	CHAR	 60 	TOPIK

    /* 국내 */
    public String	PERNR	;//	NUMC	8	사원 번호
    public String	ORGEH	;//	NUMC	8	조직 단위
    public String	ORGTX	;//	CHAR	40	소속명
    public String	ENAME	;//	CHAR	40	사원 또는 지원자의 포맷된 이름
    public String	BUKRS	;//	CHAR	4	회사 코드
    public String	WERKS	;//	CHAR	4	인사 영역
    public String	NAME1	;//	CHAR	30	인사 영역 텍스트
    public String	BTRTL	;//	CHAR	4	인사 하위 영역
    public String	BTEXT	;//	CHAR	 15 	인사 하위 영역 텍스트
    public String	PERSG	;//	CHAR	 1 	사원 그룹
    public String	PGTXT	;//	CHAR	 20 	사원 그룹 이름
    public String	PERSK	;//	CHAR	 2 	사원 하위 그룹
    public String	PKTXT	;//	CHAR	 20 	사원 하위 그룹 이름
    public String	STELL	;//	NUMC	 8 	직무
    public String	STLTX	;//	CHAR	 40 	직무명
    public String	DAT01	;//	DATS	 8 	그룹입사일
    public String	DAT02	;//	DATS	 8 	회사입사일
    public String	DAT03	;//	DATS	 8 	현직위승진일
    public String	DAT04	;//	DATS	 8 	근속기준일
    public String	JIKWE	;//	CHAR	 20 	직위
    public String	JIKWT	;//	CHAR	 40 	직위명
    public String	JIKCH	;//	CHAR	 20 	직급
    public String	JIKCT	;//	CHAR	 40 	직급명
    public String	JIKKB	;//	CHAR	 20 	직책
    public String	JIKKT	;//	CHAR	 40 	직책명
    public String	MOLGA	;//	CHAR	 2 	국가 그루핑
    public String	PHONE_NUM	;//	CHAR	 20 	담당자의 전화번호
    public String	TRFGR	;//	CHAR	 8 	호봉 그룹
    public String	TRFST	;//	CHAR	 2 	호봉 단계
    public String	VGLST	;//	CHAR	 2 	비교급여범위레벨
    public String	SHORT	;//	CHAR	 12 	오브젝트 약어
    public String	TOEIC	;//	CHAR	 3 	TOEIC
    public String	TOEFL	;//	CHAR	 3 	TOEFL
    public String	JPT	;//	CHAR	 3 	JPT
    public String	HSK	;//	CHAR	 3 	HSK
    public String	LGA_LAP_ORAL	;//	CHAR	 3 	LGA ORA
    public String	LGA_LAP_WR	;//	CHAR	 3 	LGA WR
    public String	SEPT	;//	CHAR	 3 	SEPT
    public String	NHSK	;//	CHAR	 3 	신HSK

    public String getANNUL() {
        return ANNUL;
    }

    public void setANNUL(String ANNUL) {
        this.ANNUL = ANNUL;
    }

    public String getLGT01() {
        return LGT01;
    }

    public void setLGT01(String LGT01) {
        this.LGT01 = LGT01;
    }

    public String getLGT03() {
        return LGT03;
    }

    public void setLGT03(String LGT03) {
        this.LGT03 = LGT03;
    }

    public String getLGT07() {
        return LGT07;
    }

    public void setLGT07(String LGT07) {
        this.LGT07 = LGT07;
    }

    public String getLGT08() {
        return LGT08;
    }

    public void setLGT08(String LGT08) {
        this.LGT08 = LGT08;
    }

    public String getLGT09() {
        return LGT09;
    }

    public void setLGT09(String LGT09) {
        this.LGT09 = LGT09;
    }

    public String getLGT12() {
        return LGT12;
    }

    public void setLGT12(String LGT12) {
        this.LGT12 = LGT12;
    }

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

    public String getTRFGR() {
        return TRFGR;
    }

    public void setTRFGR(String TRFGR) {
        this.TRFGR = TRFGR;
    }

    public String getTRFST() {
        return TRFST;
    }

    public void setTRFST(String TRFST) {
        this.TRFST = TRFST;
    }

    public String getVGLST() {
        return VGLST;
    }

    public void setVGLST(String VGLST) {
        this.VGLST = VGLST;
    }

    public String getSHORT() {
        return SHORT;
    }

    public void setSHORT(String SHORT) {
        this.SHORT = SHORT;
    }

    public String getTOEIC() {
        return TOEIC;
    }

    public void setTOEIC(String TOEIC) {
        this.TOEIC = TOEIC;
    }

    public String getTOEFL() {
        return TOEFL;
    }

    public void setTOEFL(String TOEFL) {
        this.TOEFL = TOEFL;
    }

    public String getJPT() {
        return JPT;
    }

    public void setJPT(String JPT) {
        this.JPT = JPT;
    }

    public String getHSK() {
        return HSK;
    }

    public void setHSK(String HSK) {
        this.HSK = HSK;
    }

    public String getLGA_LAP_ORAL() {
        return LGA_LAP_ORAL;
    }

    public void setLGA_LAP_ORAL(String LGA_LAP_ORAL) {
        this.LGA_LAP_ORAL = LGA_LAP_ORAL;
    }

    public String getLGA_LAP_WR() {
        return LGA_LAP_WR;
    }

    public void setLGA_LAP_WR(String LGA_LAP_WR) {
        this.LGA_LAP_WR = LGA_LAP_WR;
    }

    public String getSEPT() {
        return SEPT;
    }

    public void setSEPT(String SEPT) {
        this.SEPT = SEPT;
    }

    public String getNHSK() {
        return NHSK;
    }

    public void setNHSK(String NHSK) {
        this.NHSK = NHSK;
    }
}
