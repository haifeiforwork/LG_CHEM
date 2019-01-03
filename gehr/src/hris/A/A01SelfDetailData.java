package hris.A;

/**
 * A01SelfDetailData.java
 * 개인인적사항조회 데이타
 * [관련 RFC] : ZHRH_RFC_INSA01
 *
 * @author 김성일
 * @version 1.0, 2001/12/17
 * update [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18
 */
public class A01SelfDetailData extends com.sns.jdf.EntityData {
    public String ORGEH;//	NUMC	8	조직 단위
    public String CNAME1;//	CHAR	80	성명(조합)
    public String CNAME2;//	CHAR	80	성명(조합)
    public String ENAME;//	CHAR	40	성명(조합)
    public String WERKS;//	CHAR	4	인사 영역
    public String NAME1;//	CHAR	30	회사
    public String BTRTL;//	CHAR	 4 	인사 하위 영역
    public String PERSG;//	CHAR	 1 	사원 그룹
    public String PGTXT;//	CHAR	 20 	신분그룹
    public String PERSK;//	CHAR	 2 	사원 하위 그룹
    public String PKTXT;//	CHAR	 20 	신분
    public String STELL;//	NUMC	 8 	직무
    public String DAT04;//	DATS	 8 	근속기준일
    public String JIKWE;//	CHAR	 20 	직위
    public String JIKWT;//	CHAR	 40 	직위명
    public String JIKCH;//	CHAR	 20 	직급
    public String JIKCT;//	CHAR	 40 	직급명
    public String JIKKB;//	CHAR	 20 	직책
    public String JIKKT;//	CHAR	 40 	직책명


    public String PERNR;  // 사원번호
    public String ORGTX;  // 조직단위텍스트
    public String KNAME;  // 한글이름
    public String YNAME;  // 영어이름
    public String CNAME;  // 한자이름

    public String TITEL;  // 제목
    public String GBDAT;  // 생년월일
    public String REGNO;  // 한국등록번호
    public String DAT02;  // 일자유형에 대한 일자

    public String MGTXT;  // 발령사유명
    public String STLTX;  // 직무명
    public String DAT03;  // 일자유형에 대한 일자
    public String SLABS;  // 입사시학력
    public String TITL2;  // 직책2

    public String BEGDA;  // 시작일
    public String BTEXT;  // 인사하위영역 텍스트
    public String VGLST;  // 급호/년차
    public String DAT01;  // 일자유형에 대한 일자
    public String LANDX;  // 국가이름

    public String STRAS;  // 주소
    public String PSTLZ;  // 우편번호
    public String STRAS1;  // 주소
    public String PSTLZ1;  // 우편번호
    public String NMF01;  // 값

    public String NMF02;  // 값
    public String NMF06;  // 값
    public String NMF07;  // 값
    public String FLAG;  // 일반플래그
    public String STEXT;  // 숙련도 텍스트

    public String FLAG1;  // 실제납품일이 예상일을 지났을 경우의 지시자
    public String HBBY_TEXT;  // 문자 20
    public String FTEXT;  // 결혼유무
    public String LIVE_TEXT;  // 문자 20
    public String KTEXT;  // 종파, 설명

    public String HBBY_TEXT1;  // 문자 20
    public String CONTX;  // 국가유공자 kr텍스트
    public String TRAN_TEXT;  // 전역구분 TEXT
    public String SERTX;  // KR 병역의무유형 텍스트
    public String IDNUM;  // 병역식별번호

    public String RTEXT;  // 변경사유텍스트(기본급인포타입)
    public String RKTXT;  // 계급텍스트 KR
    public String PERIOD;  // 기간
    public String JBTXT;  // 병역직급분류 텍스트 KR
    public String SERUT;  // 근무부대

    public String RSEXP;  // 병역의무 면제사유

    public String PHOTO;
    public String AGECN;    //	ZEHRAGE	CHAR	3	0	연령

    public String GBORT;  //출생지


    public String RACKY;    //		CHAR	 2 	Ethnic group
    public String LTEXT;    //		CHAR	 50 	민족 Text
    public String PCODE	;    //	CHAR	 2 	Political status
    public String  PTEXT;    //		CHAR	 40 	정치성향
    public String  CTEDT;    //		DATS	 8 	계약만료일
    public String  CTEDTX;    //		CHAR	 40 	계약만료일(변환)

    public String BUTXT;
    public String CFNUM;    //발행번호

    //[CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 start
    public String JIKWT_M;  //직위명_모바일용
    public String JIKKT_M;   //직책명_모바일용
    public String JIK_M;       //직위/직책_모바일용
    //[CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 end

    public String getCFNUM() {
        return CFNUM;
    }

    public void setCFNUM(String CFNUM) {
        this.CFNUM = CFNUM;
    }

    public String getBUTXT() {
        return BUTXT;
    }

    public void setBUTXT(String BUTXT) {
        this.BUTXT = BUTXT;
    }

    public String getAGECN() {
        return AGECN;
    }

    public void setAGECN(String AGECN) {
        this.AGECN = AGECN;
    }

    public String getORGEH() {
        return ORGEH;
    }

    public void setORGEH(String ORGEH) {
        this.ORGEH = ORGEH;
    }

    public String getCNAME1() {
        return CNAME1;
    }

    public void setCNAME1(String CNAME1) {
        this.CNAME1 = CNAME1;
    }

    public String getCNAME2() {
        return CNAME2;
    }

    public void setCNAME2(String CNAME2) {
        this.CNAME2 = CNAME2;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
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

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getORGTX() {
        return ORGTX;
    }

    public void setORGTX(String ORGTX) {
        this.ORGTX = ORGTX;
    }

    public String getKNAME() {
        return KNAME;
    }

    public void setKNAME(String KNAME) {
        this.KNAME = KNAME;
    }

    public String getYNAME() {
        return YNAME;
    }

    public void setYNAME(String YNAME) {
        this.YNAME = YNAME;
    }

    public String getCNAME() {
        return CNAME;
    }

    public void setCNAME(String CNAME) {
        this.CNAME = CNAME;
    }

    public String getTITEL() {
        return TITEL;
    }

    public void setTITEL(String TITEL) {
        this.TITEL = TITEL;
    }

    public String getGBDAT() {
        return GBDAT;
    }

    public void setGBDAT(String GBDAT) {
        this.GBDAT = GBDAT;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getPTEXT() {
        return PTEXT;
    }

    public void setPTEXT(String PTEXT) {
        this.PTEXT = PTEXT;
    }

    public String getDAT02() {
        return DAT02;
    }

    public void setDAT02(String DAT02) {
        this.DAT02 = DAT02;
    }

    public String getMGTXT() {
        return MGTXT;
    }

    public void setMGTXT(String MGTXT) {
        this.MGTXT = MGTXT;
    }

    public String getSTLTX() {
        return STLTX;
    }

    public void setSTLTX(String STLTX) {
        this.STLTX = STLTX;
    }

    public String getDAT03() {
        return DAT03;
    }

    public void setDAT03(String DAT03) {
        this.DAT03 = DAT03;
    }

    public String getSLABS() {
        return SLABS;
    }

    public void setSLABS(String SLABS) {
        this.SLABS = SLABS;
    }

    public String getTITL2() {
        return TITL2;
    }

    public void setTITL2(String TITL2) {
        this.TITL2 = TITL2;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getBTEXT() {
        return BTEXT;
    }

    public void setBTEXT(String BTEXT) {
        this.BTEXT = BTEXT;
    }

    public String getVGLST() {
        return VGLST;
    }

    public void setVGLST(String VGLST) {
        this.VGLST = VGLST;
    }

    public String getDAT01() {
        return DAT01;
    }

    public void setDAT01(String DAT01) {
        this.DAT01 = DAT01;
    }

    public String getLANDX() {
        return LANDX;
    }

    public void setLANDX(String LANDX) {
        this.LANDX = LANDX;
    }

    public String getSTRAS() {
        return STRAS;
    }

    public void setSTRAS(String STRAS) {
        this.STRAS = STRAS;
    }

    public String getPSTLZ() {
        return PSTLZ;
    }

    public void setPSTLZ(String PSTLZ) {
        this.PSTLZ = PSTLZ;
    }

    public String getSTRAS1() {
        return STRAS1;
    }

    public void setSTRAS1(String STRAS1) {
        this.STRAS1 = STRAS1;
    }

    public String getPSTLZ1() {
        return PSTLZ1;
    }

    public void setPSTLZ1(String PSTLZ1) {
        this.PSTLZ1 = PSTLZ1;
    }

    public String getNMF01() {
        return NMF01;
    }

    public void setNMF01(String NMF01) {
        this.NMF01 = NMF01;
    }

    public String getNMF02() {
        return NMF02;
    }

    public void setNMF02(String NMF02) {
        this.NMF02 = NMF02;
    }

    public String getNMF06() {
        return NMF06;
    }

    public void setNMF06(String NMF06) {
        this.NMF06 = NMF06;
    }

    public String getNMF07() {
        return NMF07;
    }

    public void setNMF07(String NMF07) {
        this.NMF07 = NMF07;
    }

    public String getFLAG() {
        return FLAG;
    }

    public void setFLAG(String FLAG) {
        this.FLAG = FLAG;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getFLAG1() {
        return FLAG1;
    }

    public void setFLAG1(String FLAG1) {
        this.FLAG1 = FLAG1;
    }

    public String getHBBY_TEXT() {
        return HBBY_TEXT;
    }

    public void setHBBY_TEXT(String HBBY_TEXT) {
        this.HBBY_TEXT = HBBY_TEXT;
    }

    public String getFTEXT() {
        return FTEXT;
    }

    public void setFTEXT(String FTEXT) {
        this.FTEXT = FTEXT;
    }

    public String getLIVE_TEXT() {
        return LIVE_TEXT;
    }

    public void setLIVE_TEXT(String LIVE_TEXT) {
        this.LIVE_TEXT = LIVE_TEXT;
    }

    public String getKTEXT() {
        return KTEXT;
    }

    public void setKTEXT(String KTEXT) {
        this.KTEXT = KTEXT;
    }

    public String getHBBY_TEXT1() {
        return HBBY_TEXT1;
    }

    public void setHBBY_TEXT1(String HBBY_TEXT1) {
        this.HBBY_TEXT1 = HBBY_TEXT1;
    }

    public String getCONTX() {
        return CONTX;
    }

    public void setCONTX(String CONTX) {
        this.CONTX = CONTX;
    }

    public String getTRAN_TEXT() {
        return TRAN_TEXT;
    }

    public void setTRAN_TEXT(String TRAN_TEXT) {
        this.TRAN_TEXT = TRAN_TEXT;
    }

    public String getSERTX() {
        return SERTX;
    }

    public void setSERTX(String SERTX) {
        this.SERTX = SERTX;
    }

    public String getIDNUM() {
        return IDNUM;
    }

    public void setIDNUM(String IDNUM) {
        this.IDNUM = IDNUM;
    }

    public String getRTEXT() {
        return RTEXT;
    }

    public void setRTEXT(String RTEXT) {
        this.RTEXT = RTEXT;
    }

    public String getRKTXT() {
        return RKTXT;
    }

    public void setRKTXT(String RKTXT) {
        this.RKTXT = RKTXT;
    }

    public String getPERIOD() {
        return PERIOD;
    }

    public void setPERIOD(String PERIOD) {
        this.PERIOD = PERIOD;
    }

    public String getJBTXT() {
        return JBTXT;
    }

    public void setJBTXT(String JBTXT) {
        this.JBTXT = JBTXT;
    }

    public String getSERUT() {
        return SERUT;
    }

    public void setSERUT(String SERUT) {
        this.SERUT = SERUT;
    }

    public String getRSEXP() {
        return RSEXP;
    }

    public void setRSEXP(String RSEXP) {
        this.RSEXP = RSEXP;
    }

    public String getPHOTO() {
        return PHOTO;
    }

    public void setPHOTO(String PHOTO) {
        this.PHOTO = PHOTO;
    }


    public String getLTEXT() {
        return LTEXT;
    }

    public void setLTEXT(String LTEXT) {
        this.LTEXT = LTEXT;
    }

    public String getCTEDTX() {
        return CTEDTX;
    }

    public void setCTEDTX(String CTEDTX) {
        this.CTEDTX = CTEDTX;
    }

    public String getGBORT() {
        return GBORT;
    }

    public void setGBORT(String GBORT) {
        this.GBORT = GBORT;
    }

    public String getRACKY() {
        return RACKY;
    }

    public void setRACKY(String RACKY) {
        this.RACKY = RACKY;
    }

    public String getPCODE() {
        return PCODE;
    }

    public void setPCODE(String PCODE) {
        this.PCODE = PCODE;
    }

    public String getCTEDT() {
        return CTEDT;
    }

    public void setCTEDT(String CTEDT) {
        this.CTEDT = CTEDT;
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