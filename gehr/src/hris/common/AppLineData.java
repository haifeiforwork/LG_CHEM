package	hris.common;

import java.util.Date;

/**
 * AppLineData.java
 * 하나의 Row의 결재정보를 담아오기 위한 데이터
 *   [관련 RFC] :  ZHRA_RFC_FIND_DECISIONER  , ZHRA_RFC_GET_APPROVAL_INFO
 *   [R3 table] :  ZHRA003T
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class AppLineData extends com.sns.jdf.EntityData {

    public String APPL_MANDT    ;
    public String APPL_BUKRS    ;
    public String APPL_AINF_SEQN;
    public String APPL_BEGDA    ;
    public String APPL_UPMU_FLAG;
    public String APPL_UPMU_TYPE;

    public String APPL_APPU_NUMB;
    public String APPL_APPR_TYPE;    // 결재업무형태
    public String APPL_APPU_TYPE;    // 결재자 구분
    public String APPL_APPU_NAME;
    public String APPL_APPR_SEQN;    // 결재 순서
	public String APPL_PERNR    ;    // 결재자 사번
	public String APPL_ENAME    ;    // 결재자 이름
	public String APPL_ORGTX    ;
	public String APPL_TITEL    ;
	public String APPL_TITL2    ;    // 직책

	public String APPL_OTYPE    ;    // TASK ID
    public String APPL_OBJID    ;    // 업무 (TASK)
    public String APPL_STEXT    ;    // 업무 TEXT
    public String APPL_APPR_DATE;
    public String APPL_APPR_STAT;
    public String APPL_TELNUMBER;    // 결제담장자 전화번호

    public String APPL_BIGO_TEXT;    // 적요

    /* 해외 */
    public String APPL_JIKWE    ;    		// Title_of_Level CODE
    public String APPL_JIKWT    ;    		// Title_of_Level TEXT
    public String APPL_JIKKB    ;    		// Res. of office   CODE
    public String APPL_JIKKT    ;    		// Res. of office   TEXT

    //[CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 start
    public String APPL_PERSG;
    public String APPL_PERSK;
    public String APPL_JIKCH;

    public String getAPPL_PERSG() {
		return APPL_PERSG;
	}

	public void setAPPL_PERSG(String aPPL_PERSG) {
		APPL_PERSG = aPPL_PERSG;
	}

	public String getAPPL_PERSK() {
		return APPL_PERSK;
	}

	public void setAPPL_PERSK(String aPPL_PERSK) {
		APPL_PERSK = aPPL_PERSK;
	}

	public String getAPPL_JIKCH() {
		return APPL_JIKCH;
	}

	public void setAPPL_JIKCH(String aPPL_JIKCH) {
		APPL_JIKCH = aPPL_JIKCH;
	}

	//[CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 end
    // 수정 저장시, 변경전 UPMU_TYPE 값.		2008-03-07.
    public String APPL_UPMU_TYPE1;

    public Date APPL_APPR_TIME;  //		TIMS	 6 	시간
    public String APPL_CMMNT;    //		CHAR	 4,096 	의견

    public String getAPPL_MANDT() {
        return APPL_MANDT;
    }

    public void setAPPL_MANDT(String APPL_MANDT) {
        this.APPL_MANDT = APPL_MANDT;
    }

    public String getAPPL_BUKRS() {
        return APPL_BUKRS;
    }

    public void setAPPL_BUKRS(String APPL_BUKRS) {
        this.APPL_BUKRS = APPL_BUKRS;
    }

    public String getAPPL_AINF_SEQN() {
        return APPL_AINF_SEQN;
    }

    public void setAPPL_AINF_SEQN(String APPL_AINF_SEQN) {
        this.APPL_AINF_SEQN = APPL_AINF_SEQN;
    }

    public String getAPPL_BEGDA() {
        return APPL_BEGDA;
    }

    public void setAPPL_BEGDA(String APPL_BEGDA) {
        this.APPL_BEGDA = APPL_BEGDA;
    }

    public String getAPPL_UPMU_FLAG() {
        return APPL_UPMU_FLAG;
    }

    public void setAPPL_UPMU_FLAG(String APPL_UPMU_FLAG) {
        this.APPL_UPMU_FLAG = APPL_UPMU_FLAG;
    }

    public String getAPPL_UPMU_TYPE() {
        return APPL_UPMU_TYPE;
    }

    public void setAPPL_UPMU_TYPE(String APPL_UPMU_TYPE) {
        this.APPL_UPMU_TYPE = APPL_UPMU_TYPE;
    }

    public String getAPPL_APPU_NUMB() {
        return APPL_APPU_NUMB;
    }

    public void setAPPL_APPU_NUMB(String APPL_APPU_NUMB) {
        this.APPL_APPU_NUMB = APPL_APPU_NUMB;
    }

    public String getAPPL_APPR_TYPE() {
        return APPL_APPR_TYPE;
    }

    public void setAPPL_APPR_TYPE(String APPL_APPR_TYPE) {
        this.APPL_APPR_TYPE = APPL_APPR_TYPE;
    }

    public String getAPPL_APPU_TYPE() {
        return APPL_APPU_TYPE;
    }

    public void setAPPL_APPU_TYPE(String APPL_APPU_TYPE) {
        this.APPL_APPU_TYPE = APPL_APPU_TYPE;
    }

    public String getAPPL_APPU_NAME() {
        return APPL_APPU_NAME;
    }

    public void setAPPL_APPU_NAME(String APPL_APPU_NAME) {
        this.APPL_APPU_NAME = APPL_APPU_NAME;
    }

    public String getAPPL_APPR_SEQN() {
        return APPL_APPR_SEQN;
    }

    public void setAPPL_APPR_SEQN(String APPL_APPR_SEQN) {
        this.APPL_APPR_SEQN = APPL_APPR_SEQN;
    }

    public String getAPPL_PERNR() {
        return APPL_PERNR;
    }

    public void setAPPL_PERNR(String APPL_PERNR) {
        this.APPL_PERNR = APPL_PERNR;
    }

    public String getAPPL_ENAME() {
        return APPL_ENAME;
    }

    public void setAPPL_ENAME(String APPL_ENAME) {
        this.APPL_ENAME = APPL_ENAME;
    }

    public String getAPPL_ORGTX() {
        return APPL_ORGTX;
    }

    public void setAPPL_ORGTX(String APPL_ORGTX) {
        this.APPL_ORGTX = APPL_ORGTX;
    }

    public String getAPPL_TITEL() {
        return APPL_TITEL;
    }

    public void setAPPL_TITEL(String APPL_TITEL) {
        this.APPL_TITEL = APPL_TITEL;
    }

    public String getAPPL_TITL2() {
        return APPL_TITL2;
    }

    public void setAPPL_TITL2(String APPL_TITL2) {
        this.APPL_TITL2 = APPL_TITL2;
    }

    public String getAPPL_OTYPE() {
        return APPL_OTYPE;
    }

    public void setAPPL_OTYPE(String APPL_OTYPE) {
        this.APPL_OTYPE = APPL_OTYPE;
    }

    public String getAPPL_OBJID() {
        return APPL_OBJID;
    }

    public void setAPPL_OBJID(String APPL_OBJID) {
        this.APPL_OBJID = APPL_OBJID;
    }

    public String getAPPL_STEXT() {
        return APPL_STEXT;
    }

    public void setAPPL_STEXT(String APPL_STEXT) {
        this.APPL_STEXT = APPL_STEXT;
    }

    public String getAPPL_APPR_DATE() {
        return APPL_APPR_DATE;
    }

    public void setAPPL_APPR_DATE(String APPL_APPR_DATE) {
        this.APPL_APPR_DATE = APPL_APPR_DATE;
    }

    public String getAPPL_APPR_STAT() {
        return APPL_APPR_STAT;
    }

    public void setAPPL_APPR_STAT(String APPL_APPR_STAT) {
        this.APPL_APPR_STAT = APPL_APPR_STAT;
    }

    public String getAPPL_TELNUMBER() {
        return APPL_TELNUMBER;
    }

    public void setAPPL_TELNUMBER(String APPL_TELNUMBER) {
        this.APPL_TELNUMBER = APPL_TELNUMBER;
    }

    public String getAPPL_BIGO_TEXT() {
        return APPL_BIGO_TEXT;
    }

    public void setAPPL_BIGO_TEXT(String APPL_BIGO_TEXT) {
        this.APPL_BIGO_TEXT = APPL_BIGO_TEXT;
    }

    public String getAPPL_JIKWE() {
        return APPL_JIKWE;
    }

    public void setAPPL_JIKWE(String APPL_JIKWE) {
        this.APPL_JIKWE = APPL_JIKWE;
    }

    public String getAPPL_JIKWT() {
        return APPL_JIKWT;
    }

    public void setAPPL_JIKWT(String APPL_JIKWT) {
        this.APPL_JIKWT = APPL_JIKWT;
    }

    public String getAPPL_JIKKB() {
        return APPL_JIKKB;
    }

    public void setAPPL_JIKKB(String APPL_JIKKB) {
        this.APPL_JIKKB = APPL_JIKKB;
    }

    public String getAPPL_JIKKT() {
        return APPL_JIKKT;
    }

    public void setAPPL_JIKKT(String APPL_JIKKT) {
        this.APPL_JIKKT = APPL_JIKKT;
    }

    public String getAPPL_UPMU_TYPE1() {
        return APPL_UPMU_TYPE1;
    }

    public void setAPPL_UPMU_TYPE1(String APPL_UPMU_TYPE1) {
        this.APPL_UPMU_TYPE1 = APPL_UPMU_TYPE1;
    }

    public Date getAPPL_APPR_TIME() {
        return APPL_APPR_TIME;
    }

    public void setAPPL_APPR_TIME(Date APPL_APPR_TIME) {
        this.APPL_APPR_TIME = APPL_APPR_TIME;
    }

    public String getAPPL_CMMNT() {
        return APPL_CMMNT;
    }

    public void setAPPL_CMMNT(String APPL_CMMNT) {
        this.APPL_CMMNT = APPL_CMMNT;
    }
}
