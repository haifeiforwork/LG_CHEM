package hris.A;

/**
 * A22resultOfProfileData.java
 * 임원 profile 데이타
 *   [관련 RFC] : ZHRA_IMWON_PROFILE
 *
 * @author 이지은
 * @version 1.0, 2016/06/10  [CSR ID:3089281] 임원 1Page 프로파일 시스템 개발 요청의 건.
 */
public class A22resultOfProfileData extends com.sns.jdf.EntityData {

    public String 	ENAME	;//	CHAR	 40 	사원 또는 지원자의 포맷된 이름
    public String 	GBDAT	;//	DATS	 8 	생년월일
    public String 	DAT01	;//	DATS	 8 	회사입사일
    public String 	DAT02	;//	DATS	 8 	임원선임일
    public String 	DAT03	;//	DATS	 8 	현직위승진일
    public String 	DAT04	;//	DATS	 8 	현직책 선임일
    public String 	CENAME	;//	CHAR	 80 	성명(직위)
    public String 	CGBDAT	;//	CHAR	 60 	생년월일(연령)
    public String 	CDAT01	;//	CHAR	 60 	입사일자(근속)
    public String 	PHOTO	;//	CHAR	 4,096 	사진정보

    public String 	YEAR1	;//	NUMC	 4 	최근년도
    public String 	YEAR2	;//	NUMC	 4 	최근년도 - 1
    public String 	YEAR3	;//	NUMC	 4 	최근년도 - 2
    public String 	MBOAP1	;//	CHAR	 1 	성과평가
    public String 	MBOAP2	;//	CHAR	 1 	성과평가 - 1년도
    public String 	MBOAP3	;//	CHAR	 1 	성과평가 - 2년도
    public String 	LEADAP1	;//	CHAR	 1 	리더십평가
    public String 	LEADAP2	;//	CHAR	 1 	리더십평가 - 1년도
    public String 	LEADAP3	;//	CHAR	 1 	리더십평가 - 2년도
    public String 	MISSAP1	;//	CHAR	 1 	미션평가
    public String 	MISSAP2	;//	CHAR	 1 	미션평가 - 1년도
    public String 	MISSAP3	;//	CHAR	 1 	미션평가 - 2년도

    public String 	PERIOD	;//	CHAR	 40 	기간
    public String 	SLART	;//	CHAR	 2 	교육기관
    public String 	SLTXT	;//	CHAR	 20 	교육 기관 텍스트
    public String 	SCHCD	;//	CHAR	 4 	학교코드
    public String 	SCHTX	;//	CHAR	 60 	학교명
    public String 	SLTP1	;//	NUMC	 5 	전공
    public String 	SLTP1X	;//	CHAR	 40 	전공텍스트
    public String 	SLTP2	;//	NUMC	 5 	전공
    public String 	SLTP2X	;//	CHAR	 40 	전공텍스트
    public String 	SLATX	;//	CHAR	 80 	증명서 텍스트
    public String 	SOJAE	;//	CHAR	 100 	소재지
    public String 	EMARK	;//	CHAR	 4 	최종 등급


    public String 	PERNR	;//	NUMC	 8 	사원 번호
    public String 	MASSN	;//	CHAR	 2 	발령 유형
    public String 	MNTXT	;//	CHAR	 30 	발령 유형 이름
    public String 	MASSG	;//	CHAR	 2 	발령 사유
    public String 	MGTXT	;//	CHAR	 30 	발령 사유 이름
    public String 	BTRTL	;//	CHAR	 4 	인사 하위 영역
    public String 	BTEXT	;//	CHAR	 15 	인사 하위 영역 텍스트
    public String 	ORGEH	;//	NUMC	 8 	조직 단위
    public String 	ORGTX	;//	CHAR	 40 	오브젝트 이름
    public String 	PERSK	;//	CHAR	 2 	사원 하위 그룹
    public String 	PKTXT	;//	CHAR	 20 	사원 하위 그룹 이름
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
    public String 	VGLST2	;//	CHAR	 2 	비교급여범위레벨
    public String 	SBEGDA	;//	DATS	 8 	시작일
    public String 	CTITL2	;//	CHAR	 80 	직책(조직포함)
    public String 	PRANK	;//	CHAR	 2 	우선순위

    public String 	SUBTY	;//	CHAR	 4 	하위 유형
    public String 	STEXT	;//	CHAR	 40 	하위유형명칭
    public String 	BEGDA	;//	DATS	 8 	시작일
    public String 	ENDDA	;//	DATS	 8 	종료일
    public String 	SLABS	;//	CHAR	 40 	학위
    public String 	FTEXT	;//	CHAR	 40 	전공명
    public String 	SCORE	;//	CHAR	 40 	점수
    public String 	SORT	;//	NUMC	 4 	Sort 키
    public String 	CRESULT	;//	CHAR	 100 	결과 조합

    public String 	TDFORMAT	;//	CHAR	 2 	태그열
    public String 	TDLINE	;//	CHAR	 132 	텍스트라인


    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getGBDAT() {
        return GBDAT;
    }

    public void setGBDAT(String GBDAT) {
        this.GBDAT = GBDAT;
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

    public String getCENAME() {
        return CENAME;
    }

    public void setCENAME(String CENAME) {
        this.CENAME = CENAME;
    }

    public String getCGBDAT() {
        return CGBDAT;
    }

    public void setCGBDAT(String CGBDAT) {
        this.CGBDAT = CGBDAT;
    }

    public String getCDAT01() {
        return CDAT01;
    }

    public void setCDAT01(String CDAT01) {
        this.CDAT01 = CDAT01;
    }

    public String getPHOTO() {
        return PHOTO;
    }

    public void setPHOTO(String PHOTO) {
        this.PHOTO = PHOTO;
    }

    public String getYEAR1() {
        return YEAR1;
    }

    public void setYEAR1(String YEAR1) {
        this.YEAR1 = YEAR1;
    }

    public String getYEAR2() {
        return YEAR2;
    }

    public void setYEAR2(String YEAR2) {
        this.YEAR2 = YEAR2;
    }

    public String getYEAR3() {
        return YEAR3;
    }

    public void setYEAR3(String YEAR3) {
        this.YEAR3 = YEAR3;
    }

    public String getMBOAP1() {
        return MBOAP1;
    }

    public void setMBOAP1(String MBOAP1) {
        this.MBOAP1 = MBOAP1;
    }

    public String getMBOAP2() {
        return MBOAP2;
    }

    public void setMBOAP2(String MBOAP2) {
        this.MBOAP2 = MBOAP2;
    }

    public String getMBOAP3() {
        return MBOAP3;
    }

    public void setMBOAP3(String MBOAP3) {
        this.MBOAP3 = MBOAP3;
    }

    public String getLEADAP1() {
        return LEADAP1;
    }

    public void setLEADAP1(String LEADAP1) {
        this.LEADAP1 = LEADAP1;
    }

    public String getLEADAP2() {
        return LEADAP2;
    }

    public void setLEADAP2(String LEADAP2) {
        this.LEADAP2 = LEADAP2;
    }

    public String getLEADAP3() {
        return LEADAP3;
    }

    public void setLEADAP3(String LEADAP3) {
        this.LEADAP3 = LEADAP3;
    }

    public String getMISSAP1() {
        return MISSAP1;
    }

    public void setMISSAP1(String MISSAP1) {
        this.MISSAP1 = MISSAP1;
    }

    public String getMISSAP2() {
        return MISSAP2;
    }

    public void setMISSAP2(String MISSAP2) {
        this.MISSAP2 = MISSAP2;
    }

    public String getMISSAP3() {
        return MISSAP3;
    }

    public void setMISSAP3(String MISSAP3) {
        this.MISSAP3 = MISSAP3;
    }

    public String getPERIOD() {
        return PERIOD;
    }

    public void setPERIOD(String PERIOD) {
        this.PERIOD = PERIOD;
    }

    public String getSLART() {
        return SLART;
    }

    public void setSLART(String SLART) {
        this.SLART = SLART;
    }

    public String getSLTXT() {
        return SLTXT;
    }

    public void setSLTXT(String SLTXT) {
        this.SLTXT = SLTXT;
    }

    public String getSCHCD() {
        return SCHCD;
    }

    public void setSCHCD(String SCHCD) {
        this.SCHCD = SCHCD;
    }

    public String getSCHTX() {
        return SCHTX;
    }

    public void setSCHTX(String SCHTX) {
        this.SCHTX = SCHTX;
    }

    public String getSLTP1() {
        return SLTP1;
    }

    public void setSLTP1(String SLTP1) {
        this.SLTP1 = SLTP1;
    }

    public String getSLTP1X() {
        return SLTP1X;
    }

    public void setSLTP1X(String SLTP1X) {
        this.SLTP1X = SLTP1X;
    }

    public String getSLTP2() {
        return SLTP2;
    }

    public void setSLTP2(String SLTP2) {
        this.SLTP2 = SLTP2;
    }

    public String getSLTP2X() {
        return SLTP2X;
    }

    public void setSLTP2X(String SLTP2X) {
        this.SLTP2X = SLTP2X;
    }

    public String getSLATX() {
        return SLATX;
    }

    public void setSLATX(String SLATX) {
        this.SLATX = SLATX;
    }

    public String getSOJAE() {
        return SOJAE;
    }

    public void setSOJAE(String SOJAE) {
        this.SOJAE = SOJAE;
    }

    public String getEMARK() {
        return EMARK;
    }

    public void setEMARK(String EMARK) {
        this.EMARK = EMARK;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
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

    public String getVGLST2() {
        return VGLST2;
    }

    public void setVGLST2(String VGLST2) {
        this.VGLST2 = VGLST2;
    }

    public String getSBEGDA() {
        return SBEGDA;
    }

    public void setSBEGDA(String SBEGDA) {
        this.SBEGDA = SBEGDA;
    }

    public String getCTITL2() {
        return CTITL2;
    }

    public void setCTITL2(String CTITL2) {
        this.CTITL2 = CTITL2;
    }

    public String getPRANK() {
        return PRANK;
    }

    public void setPRANK(String PRANK) {
        this.PRANK = PRANK;
    }

    public String getSUBTY() {
        return SUBTY;
    }

    public void setSUBTY(String SUBTY) {
        this.SUBTY = SUBTY;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
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

    public String getSLABS() {
        return SLABS;
    }

    public void setSLABS(String SLABS) {
        this.SLABS = SLABS;
    }

    public String getFTEXT() {
        return FTEXT;
    }

    public void setFTEXT(String FTEXT) {
        this.FTEXT = FTEXT;
    }

    public String getSCORE() {
        return SCORE;
    }

    public void setSCORE(String SCORE) {
        this.SCORE = SCORE;
    }

    public String getSORT() {
        return SORT;
    }

    public void setSORT(String SORT) {
        this.SORT = SORT;
    }

    public String getCRESULT() {
        return CRESULT;
    }

    public void setCRESULT(String CRESULT) {
        this.CRESULT = CRESULT;
    }

    public String getTDFORMAT() {
        return TDFORMAT;
    }

    public void setTDFORMAT(String TDFORMAT) {
        this.TDFORMAT = TDFORMAT;
    }

    public String getTDLINE() {
        return TDLINE;
    }

    public void setTDLINE(String TDLINE) {
        this.TDLINE = TDLINE;
    }
}