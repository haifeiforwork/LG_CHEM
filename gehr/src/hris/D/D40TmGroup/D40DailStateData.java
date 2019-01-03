/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계													*/
/*   Program Name	:   근태집계													*/
/*   Program ID		: D40DailStateData.java								*/
/*   Description		: 근태집계													*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40DailStateData.java
 * 현장직근태-근태집계
 * [관련 RFC] :  ZGHR_RFC_TM_GET_WORK_CONDUCT
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40DailStateData extends com.sns.jdf.EntityData {

	public String E_BEGDA;	//조회시작일
	public String E_ENDDA;	//조회종료일
	public String E_DAY_CNT;	//일자수
	public String E_INFO;	//안내문구
	public String YYYYMM;	//대상년월
	public String BEGDA;	//시작일
	public String ENDDA;	//종료일
	public String PERNR;	//사번
	public String KNAME;	//	한글이름
	public String ORGEH;	//조직코드
	public String ORGTX;	//	조직명
	public String TITL2;	//	호칭텍스트
	public String TITEL;	//	호칭텍스트
	public String TRFGR;	//호봉 그룹
	public String TRFST;	//호봉 단계
	public String VGLST;	//비교급여범위레벨
	public String DAT01;	//일자
	public String PERSK;	//사원 하위 그룹
	public String TITEL_S;	//경칭
	public String TITEL_T;	//경칭
	public String SHORT;	//오브젝트 약어
	public String STEXT;	//오브젝트 이름
	public String ENAME;	//사원 또는 지원자의 포맷된 이름
	public String REMA_HUGA;	//잔여휴가
	public String HUGA;	//휴가
	public String KHUGA;	//경조휴가
	public String HHUGA;	//하계휴가
	public String BHUG;	//보건휴가
	public String MHUG;	//모성보호휴가
	public String GONGA;	//공가(시간)
	public String KYULKN;	//결근
	public String JIGAK;	//지각
	public String JOTAE;	//조퇴
	public String WECHUL;	//외출
	public String MUNO;	//무임금
	public String GOYUK;	//교육
	public String CHULJANG;	//출장
	public String HTKGUN;	//휴일특근
	public String TTKGUN;	//토요특근
	public String MTKGUN;	//명절특근
	public String MTKGUN_T;	//명정특근(토)
	public String HYUNJANG;	//휴일연장
	public String YUNJANG;	//연장근로
	public String YAGAN;	//야간근로
	public String DANGJIC;	//당직
	public String HYANGUN;	//향군(근무외)
	public String KOYUK;	//교육(근무외)
	public String KONGSU;	//공수
	public String KONGSU_HOUR;	//공수(시간)

	public String D1;	//날짜(01,02,03 …)
	public String D2;	//날짜(01,02,03 …)
	public String D3;	//날짜(01,02,03 …)
	public String D4;	//날짜(01,02,03 …)
	public String D5;	//날짜(01,02,03 …)
	public String D6;	//날짜(01,02,03 …)
	public String D7;	//날짜(01,02,03 …)
	public String D8;	//날짜(01,02,03 …)
	public String D9;	//날짜(01,02,03 …)
	public String D10;	//날짜(01,02,03 …)
	public String D11;	//날짜(01,02,03 …)
	public String D12;	//날짜(01,02,03 …)
	public String D13;	//날짜(01,02,03 …)
	public String D14;	//날짜(01,02,03 …)
	public String D15;	//날짜(01,02,03 …)
	public String D16;	//날짜(01,02,03 …)
	public String D17;	//날짜(01,02,03 …)
	public String D18;	//날짜(01,02,03 …)
	public String D19;	//날짜(01,02,03 …)
	public String D20;	//날짜(01,02,03 …)
	public String D21;	//날짜(01,02,03 …)
	public String D22;	//날짜(01,02,03 …)
	public String D23;	//날짜(01,02,03 …)
	public String D24;	//날짜(01,02,03 …)
	public String D25;	//날짜(01,02,03 …)
	public String D26;	//날짜(01,02,03 …)
	public String D27;	//날짜(01,02,03 …)
	public String D28;	//날짜(01,02,03 …)
	public String D29;	//날짜(01,02,03 …)
	public String D30;	//날짜(01,02,03 …)
	public String D31;	//날짜(01,02,03 …)

	public String CODE;	//CODE
	public String TEXT;	//TEXT


	public String getE_BEGDA() {
		return E_BEGDA;
	}
	public void setE_BEGDA(String e_BEGDA) {
		E_BEGDA = e_BEGDA;
	}
	public String getE_ENDDA() {
		return E_ENDDA;
	}
	public void setE_ENDDA(String e_ENDDA) {
		E_ENDDA = e_ENDDA;
	}
	public String getE_DAY_CNT() {
		return E_DAY_CNT;
	}
	public void setE_DAY_CNT(String e_DAY_CNT) {
		E_DAY_CNT = e_DAY_CNT;
	}
	public String getE_INFO() {
		return E_INFO;
	}
	public void setE_INFO(String e_INFO) {
		E_INFO = e_INFO;
	}
	public String getYYYYMM() {
		return YYYYMM;
	}
	public void setYYYYMM(String yYYYMM) {
		YYYYMM = yYYYMM;
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
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getKNAME() {
		return KNAME;
	}
	public void setKNAME(String kNAME) {
		KNAME = kNAME;
	}
	public String getORGEH() {
		return ORGEH;
	}
	public void setORGEH(String oRGEH) {
		ORGEH = oRGEH;
	}
	public String getORGTX() {
		return ORGTX;
	}
	public void setORGTX(String oRGTX) {
		ORGTX = oRGTX;
	}
	public String getTITL2() {
		return TITL2;
	}
	public void setTITL2(String tITL2) {
		TITL2 = tITL2;
	}
	public String getTITEL() {
		return TITEL;
	}
	public void setTITEL(String tITEL) {
		TITEL = tITEL;
	}
	public String getTRFGR() {
		return TRFGR;
	}
	public void setTRFGR(String tRFGR) {
		TRFGR = tRFGR;
	}
	public String getTRFST() {
		return TRFST;
	}
	public void setTRFST(String tRFST) {
		TRFST = tRFST;
	}
	public String getVGLST() {
		return VGLST;
	}
	public void setVGLST(String vGLST) {
		VGLST = vGLST;
	}
	public String getDAT01() {
		return DAT01;
	}
	public void setDAT01(String dAT01) {
		DAT01 = dAT01;
	}
	public String getPERSK() {
		return PERSK;
	}
	public void setPERSK(String pERSK) {
		PERSK = pERSK;
	}
	public String getTITEL_S() {
		return TITEL_S;
	}
	public void setTITEL_S(String tITEL_S) {
		TITEL_S = tITEL_S;
	}
	public String getTITEL_T() {
		return TITEL_T;
	}
	public void setTITEL_T(String tITEL_T) {
		TITEL_T = tITEL_T;
	}
	public String getSHORT() {
		return SHORT;
	}
	public void setSHORT(String sHORT) {
		SHORT = sHORT;
	}
	public String getSTEXT() {
		return STEXT;
	}
	public void setSTEXT(String sTEXT) {
		STEXT = sTEXT;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getREMA_HUGA() {
		return REMA_HUGA;
	}
	public void setREMA_HUGA(String rEMA_HUGA) {
		REMA_HUGA = rEMA_HUGA;
	}
	public String getHUGA() {
		return HUGA;
	}
	public void setHUGA(String hUGA) {
		HUGA = hUGA;
	}
	public String getKHUGA() {
		return KHUGA;
	}
	public void setKHUGA(String kHUGA) {
		KHUGA = kHUGA;
	}
	public String getHHUGA() {
		return HHUGA;
	}
	public void setHHUGA(String hHUGA) {
		HHUGA = hHUGA;
	}
	public String getBHUG() {
		return BHUG;
	}
	public void setBHUG(String bHUG) {
		BHUG = bHUG;
	}
	public String getMHUG() {
		return MHUG;
	}
	public void setMHUG(String mHUG) {
		MHUG = mHUG;
	}
	public String getGONGA() {
		return GONGA;
	}
	public void setGONGA(String gONGA) {
		GONGA = gONGA;
	}
	public String getKYULKN() {
		return KYULKN;
	}
	public void setKYULKN(String kYULKN) {
		KYULKN = kYULKN;
	}
	public String getJIGAK() {
		return JIGAK;
	}
	public void setJIGAK(String jIGAK) {
		JIGAK = jIGAK;
	}
	public String getJOTAE() {
		return JOTAE;
	}
	public void setJOTAE(String jOTAE) {
		JOTAE = jOTAE;
	}
	public String getWECHUL() {
		return WECHUL;
	}
	public void setWECHUL(String wECHUL) {
		WECHUL = wECHUL;
	}
	public String getMUNO() {
		return MUNO;
	}
	public void setMUNO(String mUNO) {
		MUNO = mUNO;
	}
	public String getGOYUK() {
		return GOYUK;
	}
	public void setGOYUK(String gOYUK) {
		GOYUK = gOYUK;
	}
	public String getCHULJANG() {
		return CHULJANG;
	}
	public void setCHULJANG(String cHULJANG) {
		CHULJANG = cHULJANG;
	}
	public String getHTKGUN() {
		return HTKGUN;
	}
	public void setHTKGUN(String hTKGUN) {
		HTKGUN = hTKGUN;
	}
	public String getTTKGUN() {
		return TTKGUN;
	}
	public void setTTKGUN(String tTKGUN) {
		TTKGUN = tTKGUN;
	}
	public String getMTKGUN() {
		return MTKGUN;
	}
	public void setMTKGUN(String mTKGUN) {
		MTKGUN = mTKGUN;
	}
	public String getMTKGUN_T() {
		return MTKGUN_T;
	}
	public void setMTKGUN_T(String mTKGUN_T) {
		MTKGUN_T = mTKGUN_T;
	}
	public String getHYUNJANG() {
		return HYUNJANG;
	}
	public void setHYUNJANG(String hYUNJANG) {
		HYUNJANG = hYUNJANG;
	}
	public String getYUNJANG() {
		return YUNJANG;
	}
	public void setYUNJANG(String yUNJANG) {
		YUNJANG = yUNJANG;
	}
	public String getYAGAN() {
		return YAGAN;
	}
	public void setYAGAN(String yAGAN) {
		YAGAN = yAGAN;
	}
	public String getDANGJIC() {
		return DANGJIC;
	}
	public void setDANGJIC(String dANGJIC) {
		DANGJIC = dANGJIC;
	}
	public String getHYANGUN() {
		return HYANGUN;
	}
	public void setHYANGUN(String hYANGUN) {
		HYANGUN = hYANGUN;
	}
	public String getKOYUK() {
		return KOYUK;
	}
	public void setKOYUK(String kOYUK) {
		KOYUK = kOYUK;
	}
	public String getKONGSU() {
		return KONGSU;
	}
	public void setKONGSU(String kONGSU) {
		KONGSU = kONGSU;
	}
	public String getKONGSU_HOUR() {
		return KONGSU_HOUR;
	}
	public void setKONGSU_HOUR(String kONGSU_HOUR) {
		KONGSU_HOUR = kONGSU_HOUR;
	}
	public String getD1() {
		return D1;
	}
	public void setD1(String d1) {
		D1 = d1;
	}
	public String getD2() {
		return D2;
	}
	public void setD2(String d2) {
		D2 = d2;
	}
	public String getD3() {
		return D3;
	}
	public void setD3(String d3) {
		D3 = d3;
	}
	public String getD4() {
		return D4;
	}
	public void setD4(String d4) {
		D4 = d4;
	}
	public String getD5() {
		return D5;
	}
	public void setD5(String d5) {
		D5 = d5;
	}
	public String getD6() {
		return D6;
	}
	public void setD6(String d6) {
		D6 = d6;
	}
	public String getD7() {
		return D7;
	}
	public void setD7(String d7) {
		D7 = d7;
	}
	public String getD8() {
		return D8;
	}
	public void setD8(String d8) {
		D8 = d8;
	}
	public String getD9() {
		return D9;
	}
	public void setD9(String d9) {
		D9 = d9;
	}
	public String getD10() {
		return D10;
	}
	public void setD10(String d10) {
		D10 = d10;
	}
	public String getD11() {
		return D11;
	}
	public void setD11(String d11) {
		D11 = d11;
	}
	public String getD12() {
		return D12;
	}
	public void setD12(String d12) {
		D12 = d12;
	}
	public String getD13() {
		return D13;
	}
	public void setD13(String d13) {
		D13 = d13;
	}
	public String getD14() {
		return D14;
	}
	public void setD14(String d14) {
		D14 = d14;
	}
	public String getD15() {
		return D15;
	}
	public void setD15(String d15) {
		D15 = d15;
	}
	public String getD16() {
		return D16;
	}
	public void setD16(String d16) {
		D16 = d16;
	}
	public String getD17() {
		return D17;
	}
	public void setD17(String d17) {
		D17 = d17;
	}
	public String getD18() {
		return D18;
	}
	public void setD18(String d18) {
		D18 = d18;
	}
	public String getD19() {
		return D19;
	}
	public void setD19(String d19) {
		D19 = d19;
	}
	public String getD20() {
		return D20;
	}
	public void setD20(String d20) {
		D20 = d20;
	}
	public String getD21() {
		return D21;
	}
	public void setD21(String d21) {
		D21 = d21;
	}
	public String getD22() {
		return D22;
	}
	public void setD22(String d22) {
		D22 = d22;
	}
	public String getD23() {
		return D23;
	}
	public void setD23(String d23) {
		D23 = d23;
	}
	public String getD24() {
		return D24;
	}
	public void setD24(String d24) {
		D24 = d24;
	}
	public String getD25() {
		return D25;
	}
	public void setD25(String d25) {
		D25 = d25;
	}
	public String getD26() {
		return D26;
	}
	public void setD26(String d26) {
		D26 = d26;
	}
	public String getD27() {
		return D27;
	}
	public void setD27(String d27) {
		D27 = d27;
	}
	public String getD28() {
		return D28;
	}
	public void setD28(String d28) {
		D28 = d28;
	}
	public String getD29() {
		return D29;
	}
	public void setD29(String d29) {
		D29 = d29;
	}
	public String getD30() {
		return D30;
	}
	public void setD30(String d30) {
		D30 = d30;
	}
	public String getD31() {
		return D31;
	}
	public void setD31(String d31) {
		D31 = d31;
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

