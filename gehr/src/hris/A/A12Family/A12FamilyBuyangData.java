package	hris.A.A12Family;

/**
 * A12FamilyBuyangData.java
 * 부양가족 신청 데이터
 *   [관련 RFC] : ZHRH_RFC_FAMILY_BUYANG
 * 
 * @author 김도신    
 * @version 1.0, 2002/01/30
 */
public class A12FamilyBuyangData extends com.sns.jdf.EntityData {

    public String PERNR    ;    // 사원번호
    public String BEGDA    ;    // 신청일
    public String AINF_SEQN;    // 결재정보 일련번호
    public String GUBUN    ;    // 부양가족 'X' 가족수당 ' '
    public String SUBTY    ;    // 하부유형
    public String STEXT    ;    // 하부유형이름
    public String OBJPS    ;    // 오브젝트식별
    public String FNMHG    ;    // 이름(한글)
    public String LNMHG    ;    // 성(한글)
    public String REGNO    ;    // 주민등록번호
    public String FAJOB    ;    // 가족구성원의 직무
    public String DPTID    ;    // 부양가족 구성원에 대한 지시자
    public String LIVID    ;    // 가족과 함께 거주하는 지시자
    public String HNDID    ;    // 장애인에 대한 지시자
    public String CHDID    ;    // 자녀보호비용을 위한 면제지시자
    public String HELID    ;    // 건강보험지시자
    public String FAMID    ;    // 가족수당 지시자
    
//  2002.10.31 가족수당상실 일자
    public String APPL_DATE;    // 가족수당 적용 일자
    public String LOSS_DATE;    // 가족수당 상실 일자
    
    public String ZUNAME   ;    // 부서서무 이름
    public String AEDTM    ;    // 변경일
    public String UNAME    ;    // 사용자이름

//  2003.02.24 부양가족 해지사유 추가정보
    public String CANC_DATE;    // 해지일자
    public String CANC_CODE;    // 해지코드
    public String CANC_ETCD;    // 해지코드 기타 선택시 기타사유입력
    
// 결재 관련 추가 
    public String ZPERNR;        // 대리 신청자 사번
    public String DPTYP;         // 부양 가족 유형
    public String BALID ;   // 기초 수급자 부양가족 지시자

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

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getGUBUN() {
        return GUBUN;
    }

    public void setGUBUN(String GUBUN) {
        this.GUBUN = GUBUN;
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

    public String getOBJPS() {
        return OBJPS;
    }

    public void setOBJPS(String OBJPS) {
        this.OBJPS = OBJPS;
    }

    public String getFNMHG() {
        return FNMHG;
    }

    public void setFNMHG(String FNMHG) {
        this.FNMHG = FNMHG;
    }

    public String getLNMHG() {
        return LNMHG;
    }

    public void setLNMHG(String LNMHG) {
        this.LNMHG = LNMHG;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getFAJOB() {
        return FAJOB;
    }

    public void setFAJOB(String FAJOB) {
        this.FAJOB = FAJOB;
    }

    public String getDPTID() {
        return DPTID;
    }

    public void setDPTID(String DPTID) {
        this.DPTID = DPTID;
    }

    public String getLIVID() {
        return LIVID;
    }

    public void setLIVID(String LIVID) {
        this.LIVID = LIVID;
    }

    public String getHNDID() {
        return HNDID;
    }

    public void setHNDID(String HNDID) {
        this.HNDID = HNDID;
    }

    public String getCHDID() {
        return CHDID;
    }

    public void setCHDID(String CHDID) {
        this.CHDID = CHDID;
    }

    public String getHELID() {
        return HELID;
    }

    public void setHELID(String HELID) {
        this.HELID = HELID;
    }

    public String getFAMID() {
        return FAMID;
    }

    public void setFAMID(String FAMID) {
        this.FAMID = FAMID;
    }

    public String getAPPL_DATE() {
        return APPL_DATE;
    }

    public void setAPPL_DATE(String APPL_DATE) {
        this.APPL_DATE = APPL_DATE;
    }

    public String getLOSS_DATE() {
        return LOSS_DATE;
    }

    public void setLOSS_DATE(String LOSS_DATE) {
        this.LOSS_DATE = LOSS_DATE;
    }

    public String getZUNAME() {
        return ZUNAME;
    }

    public void setZUNAME(String ZUNAME) {
        this.ZUNAME = ZUNAME;
    }

    public String getAEDTM() {
        return AEDTM;
    }

    public void setAEDTM(String AEDTM) {
        this.AEDTM = AEDTM;
    }

    public String getUNAME() {
        return UNAME;
    }

    public void setUNAME(String UNAME) {
        this.UNAME = UNAME;
    }

    public String getCANC_DATE() {
        return CANC_DATE;
    }

    public void setCANC_DATE(String CANC_DATE) {
        this.CANC_DATE = CANC_DATE;
    }

    public String getCANC_CODE() {
        return CANC_CODE;
    }

    public void setCANC_CODE(String CANC_CODE) {
        this.CANC_CODE = CANC_CODE;
    }

    public String getCANC_ETCD() {
        return CANC_ETCD;
    }

    public void setCANC_ETCD(String CANC_ETCD) {
        this.CANC_ETCD = CANC_ETCD;
    }

    public String getZPERNR() {
        return ZPERNR;
    }

    public void setZPERNR(String ZPERNR) {
        this.ZPERNR = ZPERNR;
    }

    public String getDPTYP() {
        return DPTYP;
    }

    public void setDPTYP(String DPTYP) {
        this.DPTYP = DPTYP;
    }

    public String getBALID() {
        return BALID;
    }

    public void setBALID(String BALID) {
        this.BALID = BALID;
    }
}

