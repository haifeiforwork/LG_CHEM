package hris.E.E17Hospital ;

/**
 * E17ChildData.java
 *  사원의 자녀 리스트를 담는 데이터
 *   [관련 RFC] : ZHRW_RFC_P_GUEN_CODE
 *
 * @author 김도신
 * @version 1.0, 2005/05/31
 * update: 	2018-04-23 cykim [CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건
 */
public class E17ChildData extends com.sns.jdf.EntityData {

    public String SUBTY    ;      // 가족유형
    public String OBJPS_21 ;      // 자녀 순번
    public String REGNO    ;      // 자녀 주민번호
    public String ENAME    ;      // 자녀 이름
    public String DATUM_20 ;      // 의료비 지원이 불가능한 시작 일자
    // [CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 @배우자/본인/자녀 의료비 신청시 제어를 위해 결혼기념일, 입사일자 필드 추가. start
    public String BEGDA;			//입사일자
    public String FAMDT;			//결혼기념일

    public String getBEGDA() {
		return BEGDA;
	}

	public void setBEGDA(String BEGDA) {
		this.BEGDA = BEGDA;
	}

	public String getFAMDT() {
		return FAMDT;
	}

	public void setFAMDT(String FAMDT) {
		this.FAMDT = FAMDT;
	}
	// [CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 @배우자/본인/자녀 의료비 신청시 제어를 위해 결혼기념일, 입사일자 필드 추가. end

	public String getSUBTY() {
        return SUBTY;
    }

    public void setSUBTY(String SUBTY) {
        this.SUBTY = SUBTY;
    }

    public String getOBJPS_21() {
        return OBJPS_21;
    }

    public void setOBJPS_21(String OBJPS_21) {
        this.OBJPS_21 = OBJPS_21;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getDATUM_20() {
        return DATUM_20;
    }

    public void setDATUM_20(String DATUM_20) {
        this.DATUM_20 = DATUM_20;
    }
}
