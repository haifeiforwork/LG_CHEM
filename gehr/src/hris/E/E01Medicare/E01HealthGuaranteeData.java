/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 피부양자 신청                                      */
/*   Program Name : 건강보험 피부양자 신청                                      */
/*   Program ID   : E01HealthGuaranteeData                                      */
/*   Description  : 건강보험 피부양자 자격(취득/상실) 신청 데이터               */
/*   Note         : [관련 RFC] : ZHRW_RFC_HEALTH_GUARANTEE                      */
/*   Creation     : 2002-01-29  김도신                                          */
/*   Update       : 2005-02-22  윤정현                                          */
/*                                                                              */
/********************************************************************************/
package hris.E.E01Medicare;

public class E01HealthGuaranteeData extends com.sns.jdf.EntityData {

    public String MANDT         ;  // 클라이언트
    public String PERNR         ;  // 사원번호
    public String AINF_SEQN     ;  // 결재정보 일련번호
    public String BEGDA         ;  // 신청일
    public String INDX_NUMB     ;  // 순번
    public String APPL_TYPE     ;  // 건강보험 피부양자 자격/취득 신청구분
    public String SUBTY         ;  // 하부유형
    public String OBJPS         ;  // 오브젝트식별
    public String ACCQ_LOSS_DATE;  // 취득/상실일자
    public String ACCQ_LOSS_TYPE;  // 건강보험 피부양자 자격 신청(취득/상실)구분
    public String HITCH_TYPE    ;  // 장애인 종별 부호
    public String HITCH_GRADE   ;  // 장애등급
    public String HITCH_DATE    ;  // 장애등록일
    public String PUBLIC_DTE    ;  // 발행일
    public String ZPERNR        ;  // 대리신청자 사번
    public String ZUNAME        ;  // 부서서무 이름
    public String AEDTM         ;  // 변경일
    public String APRT_CODE     ;  // 증빙확인
    public String ENAME         ;  // 사원 또는 지원자의 포맷이름
    public String UNAME         ;  // 사용자이름
    public String APPL_TEXT     ;  // 건강보험 피부양자 신청구분 텍스트
    public String ACCQ_LOSS_TEXT;  // 건강보험 피부양자 취득 상실 텍스트
    public String HITCH_TEXT    ;  // 장애인 종별 부호 취득 텍스트
	public String getMANDT() {
		return MANDT;
	}
	public void setMANDT(String mANDT) {
		MANDT = mANDT;
	}
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getINDX_NUMB() {
		return INDX_NUMB;
	}
	public void setINDX_NUMB(String iNDX_NUMB) {
		INDX_NUMB = iNDX_NUMB;
	}
	public String getAPPL_TYPE() {
		return APPL_TYPE;
	}
	public void setAPPL_TYPE(String aPPL_TYPE) {
		APPL_TYPE = aPPL_TYPE;
	}
	public String getSUBTY() {
		return SUBTY;
	}
	public void setSUBTY(String sUBTY) {
		SUBTY = sUBTY;
	}
	public String getOBJPS() {
		return OBJPS;
	}
	public void setOBJPS(String oBJPS) {
		OBJPS = oBJPS;
	}
	public String getACCQ_LOSS_DATE() {
		return ACCQ_LOSS_DATE;
	}
	public void setACCQ_LOSS_DATE(String aCCQ_LOSS_DATE) {
		ACCQ_LOSS_DATE = aCCQ_LOSS_DATE;
	}
	public String getACCQ_LOSS_TYPE() {
		return ACCQ_LOSS_TYPE;
	}
	public void setACCQ_LOSS_TYPE(String aCCQ_LOSS_TYPE) {
		ACCQ_LOSS_TYPE = aCCQ_LOSS_TYPE;
	}
	public String getHITCH_TYPE() {
		return HITCH_TYPE;
	}
	public void setHITCH_TYPE(String hITCH_TYPE) {
		HITCH_TYPE = hITCH_TYPE;
	}
	public String getHITCH_GRADE() {
		return HITCH_GRADE;
	}
	public void setHITCH_GRADE(String hITCH_GRADE) {
		HITCH_GRADE = hITCH_GRADE;
	}
	public String getHITCH_DATE() {
		return HITCH_DATE;
	}
	public void setHITCH_DATE(String hITCH_DATE) {
		HITCH_DATE = hITCH_DATE;
	}
	public String getPUBLIC_DTE() {
		return PUBLIC_DTE;
	}
	public void setPUBLIC_DTE(String pUBLIC_DTE) {
		PUBLIC_DTE = pUBLIC_DTE;
	}
	public String getZPERNR() {
		return ZPERNR;
	}
	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
	}
	public String getZUNAME() {
		return ZUNAME;
	}
	public void setZUNAME(String zUNAME) {
		ZUNAME = zUNAME;
	}
	public String getAEDTM() {
		return AEDTM;
	}
	public void setAEDTM(String aEDTM) {
		AEDTM = aEDTM;
	}
	public String getAPRT_CODE() {
		return APRT_CODE;
	}
	public void setAPRT_CODE(String aPRT_CODE) {
		APRT_CODE = aPRT_CODE;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getUNAME() {
		return UNAME;
	}
	public void setUNAME(String uNAME) {
		UNAME = uNAME;
	}
	public String getAPPL_TEXT() {
		return APPL_TEXT;
	}
	public void setAPPL_TEXT(String aPPL_TEXT) {
		APPL_TEXT = aPPL_TEXT;
	}
	public String getACCQ_LOSS_TEXT() {
		return ACCQ_LOSS_TEXT;
	}
	public void setACCQ_LOSS_TEXT(String aCCQ_LOSS_TEXT) {
		ACCQ_LOSS_TEXT = aCCQ_LOSS_TEXT;
	}
	public String getHITCH_TEXT() {
		return HITCH_TEXT;
	}
	public void setHITCH_TEXT(String hITCH_TEXT) {
		HITCH_TEXT = hITCH_TEXT;
	}


}
