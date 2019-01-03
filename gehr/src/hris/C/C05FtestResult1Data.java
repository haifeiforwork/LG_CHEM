package	hris.C;

/**
 * C05FtestResult1Data.java
 * 개인의 어학능력 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRE_RFC_LANGUAGE_ABILITY
 *
 * @author 김도신
 * @version 1.0, 2002/01/14
 * @version 1.1, 2006/01/06
 * @version 1.1, 2013/12/18 C20131202_46202  0010:TOEIC Speaking,0011:OPIc,0012:JLPT
 * @version 1.2, 2016/02/11 [CSR ID:2981372] SAP/ERP 및 G Portal(e-HR) 어학성적 추가 요청의 건
 */
public class C05FtestResult1Data extends com.sns.jdf.EntityData {

    public String	FLDSCR	;//	CHAR	 250 	항목별 점수
    public String	ZTOTL_SCOR	;//	CHAR	 3 	TOTAL
    public String	SORT	;//	NUMC	 2 	SORT 순서


    public String TENAM;
    public String RATING;
    public String PSTEXT;
    public String LANTX;
    public String PTEXT2;
    public String TETYP;
    public String ENDDA;


    public String 	BEGDA	;//	DATS	8	시작일
    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	TRFGR	;//	CHAR	8	호봉 그룹
    public String 	LANG_TYPE	;//	CHAR	4	어학레코드 유형
    public String 	LISN_SCOR	;//	CHAR	3	L/C
    public String 	HEAR_SCOR	;//	CHAR	3	청력
    public String 	WRIT_SCOR	;//	CHAR	3	WRITING
    public String 	EXPR_SCOR	;//	CHAR	 3 	어법
    public String 	READ_SCOR	;//	CHAR	 3 	R/C
    public String 	UNDR_SCOR	;//	CHAR	 3 	독해
    public String 	SUMM_SCOR	;//	CHAR	 3 	종합
    public String 	COMP_SCOR	;//	CHAR	 3 	작문
    public String 	ORAL_SCOR	;//	CHAR	 3 	구술
    public String 	LANG_LEVL	;//	CHAR	 3 	등급
    public String 	STRU_SCOR	;//	CHAR	 3 	STRUCTURE
    public String 	TOTL_SCOR	;//	NUMC	 3 	(ZTOTL_SCOR -> NUMC(3)으로 변경)
    public String 	SEPT_LEVL	;//	CHAR	 3 	SEPT LEVEL
    public String 	LGAX_SCOR	;//	CHAR	 3 	ORAL SCORE
    public String 	LAPX_SCOR	;//	CHAR	 3 	WRITTEN SCORE
    public String 	SEPT_SCOR	;//	DEC	 5 	WEIGHTED SCORE
    public String 	LAST_FLAG	;//	CHAR	 1 	인정점수 FLAG
    public String 	TEPS_SCOR1	;//	NUMC	 3 	청해점수
    public String 	TEPS_LEVL1	;//	CHAR	 3 	청해등급
    public String 	TEPS_SCOR2	;//	NUMC	 3 	문법점수
    public String 	TEPS_LEVL2	;//	CHAR	 3 	문법등급
    public String 	TEPS_SCOR3	;//	NUMC	 3 	어휘점수
    public String 	TEPS_LEVL3	;//	CHAR	 3 	어휘등급
    public String 	TEPS_SCOR4	;//	NUMC	 3 	독해점수
    public String 	TEPS_LEVL4	;//	CHAR	 3 	독해등급
    public String 	TEPS_AMNT	;//	NUMC	 3 	TEPS 기준점수
    public String 	TEPS_LEVL	;//	CHAR	 3 	TEPS 총점등급
    public String 	SPEA_SCOR	;//	CHAR	 3 	SPEAKING
    public String 	WRIT_SCOR1	;//	CHAR	 3 	WRITING
    public String 	OPIC_LEVL	;//	CHAR	 3 	OPIc 등급
    public String 	JLPT_LEVL	;//	CHAR	 2 	JLPT Level
    public String 	LANG_SCOR	;//	CHAR	 3 	JLPT 언어지식
    public String 	READ_SCOR1	;//	CHAR	 3 	JLPT 독해
    public String 	LISN_SCOR1	;//	CHAR	 3 	JLPT 청해
    public String 	WRIT_LEVL	;//	CHAR	 3 	WRITING LEVEL
    public String 	SPEA_LEVL	;//	CHAR	 3 	SPEAKING_LEVEL
    public String 	TSC_LEVEL	;//	NUMC	 2 	말하기 레벨
    public String 	SJPT_LEVEL	;//	NUMC	 2 	말하기 레벨
    public String 	ZD_LEVEL	;//	CHAR	 2 	제2외국어 Level
    public String 	DALF_LEVEL	;//	CHAR	 2 	제2외국어 Level
    public String 	DELF_LEVEL	;//	CHAR	 2 	제2외국어 Level
    public String 	DELE_LEVEL	;//	CHAR	 2 	제2외국어 Level
    public String 	CELPE_BRAS	;//	CHAR	 2 	포르투칼어 Level
    public String 	TORFL_LEVEL	;//	CHAR	 2 	러시아어 Level
    public String 	STEXT	;//	CHAR	 40 	하위 유형 이름
    public String 	SEPT_TEXT	;//	CHAR	 22 	텍스트 문자열 22 문자
    public String 	LGAX_TEXT	;//	CHAR	 22 	텍스트 문자열 22 문자
    public String 	LAPX_TEXT	;//	CHAR	 22 	텍스트 문자열 22 문자
    public String 	OPIC_TEXT	;//	CHAR	 20 	OPIc 등급
    public String 	OPIC_TEXT2	;//	CHAR	 20 	OPIc 등급 풀네임
    public String 	TSC_TEXT	;//	CHAR	 20 	TSC 등급Text
    public String 	SJPT_TEXT	;//	CHAR	 20 	SJPT 등급 Text
    public String 	ZD_TEXT	;//	CHAR	 20 	ZD 등급 TEXT
    public String 	DALF_TEXT	;//	CHAR	 20 	DALF 등급 Text
    public String 	DELF_TEXT	;//	CHAR	 20 	DELF 등급 TEXT
    public String 	DELE_TEXT	;//	CHAR	 20 	DELE 등급 Text
    public String 	CELPE_TEXT	;//	CHAR	 40 	CELPE-BRAS 등급 Text
    public String 	TORFL_TEXT	;//	CHAR	 40 	TORFL 등급 Text

    public String getTENAM() {
        return TENAM;
    }

    public void setTENAM(String TENAM) {
        this.TENAM = TENAM;
    }

    public String getRATING() {
        return RATING;
    }

    public void setRATING(String RATING) {
        this.RATING = RATING;
    }

    public String getPSTEXT() {
        return PSTEXT;
    }

    public void setPSTEXT(String PSTEXT) {
        this.PSTEXT = PSTEXT;
    }

    public String getLANTX() {
        return LANTX;
    }

    public void setLANTX(String LANTX) {
        this.LANTX = LANTX;
    }

    public String getPTEXT2() {
        return PTEXT2;
    }

    public void setPTEXT2(String PTEXT2) {
        this.PTEXT2 = PTEXT2;
    }

    public String getTETYP() {
        return TETYP;
    }

    public void setTETYP(String TETYP) {
        this.TETYP = TETYP;
    }

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getTRFGR() {
        return TRFGR;
    }

    public void setTRFGR(String TRFGR) {
        this.TRFGR = TRFGR;
    }

    public String getLANG_TYPE() {
        return LANG_TYPE;
    }

    public void setLANG_TYPE(String LANG_TYPE) {
        this.LANG_TYPE = LANG_TYPE;
    }

    public String getLISN_SCOR() {
        return LISN_SCOR;
    }

    public void setLISN_SCOR(String LISN_SCOR) {
        this.LISN_SCOR = LISN_SCOR;
    }

    public String getHEAR_SCOR() {
        return HEAR_SCOR;
    }

    public void setHEAR_SCOR(String HEAR_SCOR) {
        this.HEAR_SCOR = HEAR_SCOR;
    }

    public String getWRIT_SCOR() {
        return WRIT_SCOR;
    }

    public void setWRIT_SCOR(String WRIT_SCOR) {
        this.WRIT_SCOR = WRIT_SCOR;
    }

    public String getEXPR_SCOR() {
        return EXPR_SCOR;
    }

    public void setEXPR_SCOR(String EXPR_SCOR) {
        this.EXPR_SCOR = EXPR_SCOR;
    }

    public String getREAD_SCOR() {
        return READ_SCOR;
    }

    public void setREAD_SCOR(String READ_SCOR) {
        this.READ_SCOR = READ_SCOR;
    }

    public String getUNDR_SCOR() {
        return UNDR_SCOR;
    }

    public void setUNDR_SCOR(String UNDR_SCOR) {
        this.UNDR_SCOR = UNDR_SCOR;
    }

    public String getSUMM_SCOR() {
        return SUMM_SCOR;
    }

    public void setSUMM_SCOR(String SUMM_SCOR) {
        this.SUMM_SCOR = SUMM_SCOR;
    }

    public String getCOMP_SCOR() {
        return COMP_SCOR;
    }

    public void setCOMP_SCOR(String COMP_SCOR) {
        this.COMP_SCOR = COMP_SCOR;
    }

    public String getORAL_SCOR() {
        return ORAL_SCOR;
    }

    public void setORAL_SCOR(String ORAL_SCOR) {
        this.ORAL_SCOR = ORAL_SCOR;
    }

    public String getLANG_LEVL() {
        return LANG_LEVL;
    }

    public void setLANG_LEVL(String LANG_LEVL) {
        this.LANG_LEVL = LANG_LEVL;
    }

    public String getSTRU_SCOR() {
        return STRU_SCOR;
    }

    public void setSTRU_SCOR(String STRU_SCOR) {
        this.STRU_SCOR = STRU_SCOR;
    }

    public String getTOTL_SCOR() {
        return TOTL_SCOR;
    }

    public void setTOTL_SCOR(String TOTL_SCOR) {
        this.TOTL_SCOR = TOTL_SCOR;
    }

    public String getSEPT_LEVL() {
        return SEPT_LEVL;
    }

    public void setSEPT_LEVL(String SEPT_LEVL) {
        this.SEPT_LEVL = SEPT_LEVL;
    }

    public String getLGAX_SCOR() {
        return LGAX_SCOR;
    }

    public void setLGAX_SCOR(String LGAX_SCOR) {
        this.LGAX_SCOR = LGAX_SCOR;
    }

    public String getLAPX_SCOR() {
        return LAPX_SCOR;
    }

    public void setLAPX_SCOR(String LAPX_SCOR) {
        this.LAPX_SCOR = LAPX_SCOR;
    }

    public String getSEPT_SCOR() {
        return SEPT_SCOR;
    }

    public void setSEPT_SCOR(String SEPT_SCOR) {
        this.SEPT_SCOR = SEPT_SCOR;
    }

    public String getLAST_FLAG() {
        return LAST_FLAG;
    }

    public void setLAST_FLAG(String LAST_FLAG) {
        this.LAST_FLAG = LAST_FLAG;
    }

    public String getTEPS_SCOR1() {
        return TEPS_SCOR1;
    }

    public void setTEPS_SCOR1(String TEPS_SCOR1) {
        this.TEPS_SCOR1 = TEPS_SCOR1;
    }

    public String getTEPS_LEVL1() {
        return TEPS_LEVL1;
    }

    public void setTEPS_LEVL1(String TEPS_LEVL1) {
        this.TEPS_LEVL1 = TEPS_LEVL1;
    }

    public String getTEPS_SCOR2() {
        return TEPS_SCOR2;
    }

    public void setTEPS_SCOR2(String TEPS_SCOR2) {
        this.TEPS_SCOR2 = TEPS_SCOR2;
    }

    public String getTEPS_LEVL2() {
        return TEPS_LEVL2;
    }

    public void setTEPS_LEVL2(String TEPS_LEVL2) {
        this.TEPS_LEVL2 = TEPS_LEVL2;
    }

    public String getTEPS_SCOR3() {
        return TEPS_SCOR3;
    }

    public void setTEPS_SCOR3(String TEPS_SCOR3) {
        this.TEPS_SCOR3 = TEPS_SCOR3;
    }

    public String getTEPS_LEVL3() {
        return TEPS_LEVL3;
    }

    public void setTEPS_LEVL3(String TEPS_LEVL3) {
        this.TEPS_LEVL3 = TEPS_LEVL3;
    }

    public String getTEPS_SCOR4() {
        return TEPS_SCOR4;
    }

    public void setTEPS_SCOR4(String TEPS_SCOR4) {
        this.TEPS_SCOR4 = TEPS_SCOR4;
    }

    public String getTEPS_LEVL4() {
        return TEPS_LEVL4;
    }

    public void setTEPS_LEVL4(String TEPS_LEVL4) {
        this.TEPS_LEVL4 = TEPS_LEVL4;
    }

    public String getTEPS_AMNT() {
        return TEPS_AMNT;
    }

    public void setTEPS_AMNT(String TEPS_AMNT) {
        this.TEPS_AMNT = TEPS_AMNT;
    }

    public String getTEPS_LEVL() {
        return TEPS_LEVL;
    }

    public void setTEPS_LEVL(String TEPS_LEVL) {
        this.TEPS_LEVL = TEPS_LEVL;
    }

    public String getSPEA_SCOR() {
        return SPEA_SCOR;
    }

    public void setSPEA_SCOR(String SPEA_SCOR) {
        this.SPEA_SCOR = SPEA_SCOR;
    }

    public String getWRIT_SCOR1() {
        return WRIT_SCOR1;
    }

    public void setWRIT_SCOR1(String WRIT_SCOR1) {
        this.WRIT_SCOR1 = WRIT_SCOR1;
    }

    public String getOPIC_LEVL() {
        return OPIC_LEVL;
    }

    public void setOPIC_LEVL(String OPIC_LEVL) {
        this.OPIC_LEVL = OPIC_LEVL;
    }

    public String getJLPT_LEVL() {
        return JLPT_LEVL;
    }

    public void setJLPT_LEVL(String JLPT_LEVL) {
        this.JLPT_LEVL = JLPT_LEVL;
    }

    public String getLANG_SCOR() {
        return LANG_SCOR;
    }

    public void setLANG_SCOR(String LANG_SCOR) {
        this.LANG_SCOR = LANG_SCOR;
    }

    public String getREAD_SCOR1() {
        return READ_SCOR1;
    }

    public void setREAD_SCOR1(String READ_SCOR1) {
        this.READ_SCOR1 = READ_SCOR1;
    }

    public String getLISN_SCOR1() {
        return LISN_SCOR1;
    }

    public void setLISN_SCOR1(String LISN_SCOR1) {
        this.LISN_SCOR1 = LISN_SCOR1;
    }

    public String getWRIT_LEVL() {
        return WRIT_LEVL;
    }

    public void setWRIT_LEVL(String WRIT_LEVL) {
        this.WRIT_LEVL = WRIT_LEVL;
    }

    public String getSPEA_LEVL() {
        return SPEA_LEVL;
    }

    public void setSPEA_LEVL(String SPEA_LEVL) {
        this.SPEA_LEVL = SPEA_LEVL;
    }

    public String getTSC_LEVEL() {
        return TSC_LEVEL;
    }

    public void setTSC_LEVEL(String TSC_LEVEL) {
        this.TSC_LEVEL = TSC_LEVEL;
    }

    public String getSJPT_LEVEL() {
        return SJPT_LEVEL;
    }

    public void setSJPT_LEVEL(String SJPT_LEVEL) {
        this.SJPT_LEVEL = SJPT_LEVEL;
    }

    public String getZD_LEVEL() {
        return ZD_LEVEL;
    }

    public void setZD_LEVEL(String ZD_LEVEL) {
        this.ZD_LEVEL = ZD_LEVEL;
    }

    public String getDALF_LEVEL() {
        return DALF_LEVEL;
    }

    public void setDALF_LEVEL(String DALF_LEVEL) {
        this.DALF_LEVEL = DALF_LEVEL;
    }

    public String getDELF_LEVEL() {
        return DELF_LEVEL;
    }

    public void setDELF_LEVEL(String DELF_LEVEL) {
        this.DELF_LEVEL = DELF_LEVEL;
    }

    public String getDELE_LEVEL() {
        return DELE_LEVEL;
    }

    public void setDELE_LEVEL(String DELE_LEVEL) {
        this.DELE_LEVEL = DELE_LEVEL;
    }

    public String getCELPE_BRAS() {
        return CELPE_BRAS;
    }

    public void setCELPE_BRAS(String CELPE_BRAS) {
        this.CELPE_BRAS = CELPE_BRAS;
    }

    public String getTORFL_LEVEL() {
        return TORFL_LEVEL;
    }

    public void setTORFL_LEVEL(String TORFL_LEVEL) {
        this.TORFL_LEVEL = TORFL_LEVEL;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getSEPT_TEXT() {
        return SEPT_TEXT;
    }

    public void setSEPT_TEXT(String SEPT_TEXT) {
        this.SEPT_TEXT = SEPT_TEXT;
    }

    public String getLGAX_TEXT() {
        return LGAX_TEXT;
    }

    public void setLGAX_TEXT(String LGAX_TEXT) {
        this.LGAX_TEXT = LGAX_TEXT;
    }

    public String getLAPX_TEXT() {
        return LAPX_TEXT;
    }

    public void setLAPX_TEXT(String LAPX_TEXT) {
        this.LAPX_TEXT = LAPX_TEXT;
    }

    public String getOPIC_TEXT() {
        return OPIC_TEXT;
    }

    public void setOPIC_TEXT(String OPIC_TEXT) {
        this.OPIC_TEXT = OPIC_TEXT;
    }

    public String getOPIC_TEXT2() {
        return OPIC_TEXT2;
    }

    public void setOPIC_TEXT2(String OPIC_TEXT2) {
        this.OPIC_TEXT2 = OPIC_TEXT2;
    }

    public String getTSC_TEXT() {
        return TSC_TEXT;
    }

    public void setTSC_TEXT(String TSC_TEXT) {
        this.TSC_TEXT = TSC_TEXT;
    }

    public String getSJPT_TEXT() {
        return SJPT_TEXT;
    }

    public void setSJPT_TEXT(String SJPT_TEXT) {
        this.SJPT_TEXT = SJPT_TEXT;
    }

    public String getZD_TEXT() {
        return ZD_TEXT;
    }

    public void setZD_TEXT(String ZD_TEXT) {
        this.ZD_TEXT = ZD_TEXT;
    }

    public String getDALF_TEXT() {
        return DALF_TEXT;
    }

    public void setDALF_TEXT(String DALF_TEXT) {
        this.DALF_TEXT = DALF_TEXT;
    }

    public String getDELF_TEXT() {
        return DELF_TEXT;
    }

    public void setDELF_TEXT(String DELF_TEXT) {
        this.DELF_TEXT = DELF_TEXT;
    }

    public String getDELE_TEXT() {
        return DELE_TEXT;
    }

    public void setDELE_TEXT(String DELE_TEXT) {
        this.DELE_TEXT = DELE_TEXT;
    }

    public String getCELPE_TEXT() {
        return CELPE_TEXT;
    }

    public void setCELPE_TEXT(String CELPE_TEXT) {
        this.CELPE_TEXT = CELPE_TEXT;
    }

    public String getTORFL_TEXT() {
        return TORFL_TEXT;
    }

    public void setTORFL_TEXT(String TORFL_TEXT) {
        this.TORFL_TEXT = TORFL_TEXT;
    }

    public String getFLDSCR() {
        return FLDSCR;
    }

    public void setFLDSCR(String FLDSCR) {
        this.FLDSCR = FLDSCR;
    }

    public String getZTOTL_SCOR() {
        return ZTOTL_SCOR;
    }

    public void setZTOTL_SCOR(String ZTOTL_SCOR) {
        this.ZTOTL_SCOR = ZTOTL_SCOR;
    }

    public String getSORT() {
        return SORT;
    }

    public void setSORT(String SORT) {
        this.SORT = SORT;
    }
}
