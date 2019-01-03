package hris.A ;

/**
 * A05AppointDetail1Data.java
 *  사원의 발령사항 내역을 담는 데이터
 *   [관련 RFC] : ZHRH_RFC_GET_IT0000_ETC
 *
 * @author 한성덕
 * @version 1.0, 2001/12/17
 * update [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18
 */
public class A05AppointDetail1Data extends com.sns.jdf.EntityData {

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	BEGDA	;//	DATS	8	발령일자
    public String 	MASSN	;//	CHAR	2	발령 유형
    public String 	MNTXT	;//	CHAR	30	발령 유형 이름
    public String 	MASSG	;//	CHAR	2	발령 사유
    public String 	MGTXT	;//	CHAR	30	발령 사유 이름
    public String 	BTRTL	;//	CHAR	4	인사 하위 영역
    public String 	BTEXT	;//	CHAR	15	근무지
    public String 	ORGEH	;//	NUMC	 8 	조직 단위
    public String 	ORGTX	;//	CHAR	 40 	소속
    public String 	PERSK	;//	CHAR	 2 	사원 하위 그룹
    public String 	PKTXT	;//	CHAR	 20 	신분
    public String 	JIKWE	;//	CHAR	 20 	직위
    public String 	JIKWT	;//	CHAR	 40 	직위명
    public String 	JIKCH	;//	CHAR	 20 	직급
    public String 	JIKCT	;//	CHAR	 40 	직급명
    public String 	JIKKB	;//	CHAR	 20 	직책
    public String 	JIKKT	;//	CHAR	 40 	직책명
    public String 	VGLST	;//	CHAR	 40 	직급/년차
    public String 	STELL	;//	NUMC	 8 	직무
    public String 	STLTX	;//	CHAR	 40 	직무명
    public String 	TRFGR	;//	CHAR	 8 	호봉 그룹
    public String 	TRFST	;//	CHAR	 2 	호봉 단계
    public String 	KEEP_TITL2	;//	CHAR	 20 	직책유지(KR)

    public String SBEGDA;

    //[CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 start
    public String JIKWT_M;  //직위명_모바일용
    public String JIKKT_M;   //직책명_모바일용
    public String JIK_M;       //직위/직책_모바일용
    //[CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 end

    public String getSBEGDA() {
        return SBEGDA;
    }

    public void setSBEGDA(String SBEGDA) {
        this.SBEGDA = SBEGDA;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getMASSN() {
        return MASSN;
    }

    public void setMASSN(String MASSN) {
        this.MASSN = MASSN;
    }

    public String getMNTXT() {
        return MNTXT;
    }

    public void setMNTXT(String MNTXT) {
        this.MNTXT = MNTXT;
    }

    public String getMASSG() {
        return MASSG;
    }

    public void setMASSG(String MASSG) {
        this.MASSG = MASSG;
    }

    public String getMGTXT() {
        return MGTXT;
    }

    public void setMGTXT(String MGTXT) {
        this.MGTXT = MGTXT;
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

    public String getVGLST() {
        return VGLST;
    }

    public void setVGLST(String VGLST) {
        this.VGLST = VGLST;
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

    public String getKEEP_TITL2() {
        return KEEP_TITL2;
    }

    public void setKEEP_TITL2(String KEEP_TITL2) {
        this.KEEP_TITL2 = KEEP_TITL2;
    }

	public String getJIKWT_M() {
		return JIKWT_M;
	}

	public void setJIKWT_M(String jIKWT_M) {
		JIKWT_M = jIKWT_M;
	}

	public String getJIKKT_M() {
		return JIKKT_M;
	}

	public void setJIKKT_M(String jIKKT_M) {
		JIKKT_M = jIKKT_M;
	}

	public String getJIK_M() {
		return JIK_M;
	}

	public void setJIK_M(String jIK_M) {
		JIK_M = jIK_M;
	}
}
