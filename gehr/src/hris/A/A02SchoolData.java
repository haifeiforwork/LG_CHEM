package	hris.A;

/**
 * A02SchoolData.java
 *  학력사항 List 를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_INSA02
 *
 * @author 박영락
 * @version 1.0, 2001/12/17
 * @[CSR ID:2991671] g-mobile 내 인사정보 조회 기능 추가 개발 요청  2016-01-27
 */
public class A02SchoolData extends com.sns.jdf.EntityData {

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	BEGDA	;//	DATS	8	시작일
    public String 	ENDDA	;//	DATS	8	종료일
    public String 	PERIOD	;//	CHAR	40	기간
    public String 	SLART	;//	CHAR	2	교육기관
    public String 	SLTXT	;//	CHAR	20	학력
    public String 	SCHCD	;//	CHAR	4	학교코드
    public String 	SCHTX	;//	CHAR	60	학교명
    public String 	SLTP1	;//	NUMC	 5 	전공
    public String 	SLTP1X	;//	CHAR	 40 	전공명
    public String 	SLTP2	;//	NUMC	 5 	부전공
    public String 	SLTP2X	;//	CHAR	 40 	부전공명
    public String 	SLABS	;//	CHAR	 2 	졸업구분
    public String 	SLATX	;//	CHAR	 80 	졸업구분명
    public String 	SOJAE	;//	CHAR	 100 	소재지
    public String 	EMARK	;//	CHAR	 4 	입사시학력

    //public String SLART_TEXT ; //학교 구분(대학원/대학교/고등학교...) [CSR ID:2991671]

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

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
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

    public String getSLABS() {
        return SLABS;
    }

    public void setSLABS(String SLABS) {
        this.SLABS = SLABS;
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
}