package hris.A;

import com.sns.jdf.EntityData;

/**
 * A01SelfDetailArmyData.java
 * 병역 데이타
 *   [관련 RFC] :  ZGHR_RFC_MILITARY_LIST_KR
 *
 * @author 정진만
 * @version 1.0, 2016/08/08
 */
public class A01SelfDetailArmyData extends EntityData {

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	BEGDA	;//	DATS	8	시작일
    public String 	ENDDA	;//	DATS	8	종료일
    public String 	PERIOD	;//	CHAR	40	복무기간
    public String 	SERUT	;//	CHAR	30	근무부대
    public String 	TRAN_TYPE	;//	CHAR	4	전역구분
    public String 	TRAN_TEXT	;//	CHAR	10	실역구분
    public String 	SERTY	;//	CHAR	2	병역유형
    public String 	SERTX	;//	CHAR	 20 	군별
    public String 	MRANK	;//	CHAR	 2 	계급
    public String 	RKTXT	;//	CHAR	 30 	계급명
    public String 	PREAS	;//	CHAR	 2 	마스터 데이터 변경 사유
    public String 	RTEXT	;//	CHAR	 30 	전역사유
    public String 	IDNUM	;//	CHAR	 15 	병역군번
    public String 	JOBCL	;//	CHAR	 4 	보직 분류
    public String 	JBTXT	;//	CHAR	 30 	주특기
    public String 	RSEXP	;//	CHAR	 40 	병역의무 면제사유

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

    public String getSERUT() {
        return SERUT;
    }

    public void setSERUT(String SERUT) {
        this.SERUT = SERUT;
    }

    public String getTRAN_TYPE() {
        return TRAN_TYPE;
    }

    public void setTRAN_TYPE(String TRAN_TYPE) {
        this.TRAN_TYPE = TRAN_TYPE;
    }

    public String getTRAN_TEXT() {
        return TRAN_TEXT;
    }

    public void setTRAN_TEXT(String TRAN_TEXT) {
        this.TRAN_TEXT = TRAN_TEXT;
    }

    public String getSERTY() {
        return SERTY;
    }

    public void setSERTY(String SERTY) {
        this.SERTY = SERTY;
    }

    public String getSERTX() {
        return SERTX;
    }

    public void setSERTX(String SERTX) {
        this.SERTX = SERTX;
    }

    public String getMRANK() {
        return MRANK;
    }

    public void setMRANK(String MRANK) {
        this.MRANK = MRANK;
    }

    public String getRKTXT() {
        return RKTXT;
    }

    public void setRKTXT(String RKTXT) {
        this.RKTXT = RKTXT;
    }

    public String getPREAS() {
        return PREAS;
    }

    public void setPREAS(String PREAS) {
        this.PREAS = PREAS;
    }

    public String getRTEXT() {
        return RTEXT;
    }

    public void setRTEXT(String RTEXT) {
        this.RTEXT = RTEXT;
    }

    public String getIDNUM() {
        return IDNUM;
    }

    public void setIDNUM(String IDNUM) {
        this.IDNUM = IDNUM;
    }

    public String getJOBCL() {
        return JOBCL;
    }

    public void setJOBCL(String JOBCL) {
        this.JOBCL = JOBCL;
    }

    public String getJBTXT() {
        return JBTXT;
    }

    public void setJBTXT(String JBTXT) {
        this.JBTXT = JBTXT;
    }

    public String getRSEXP() {
        return RSEXP;
    }

    public void setRSEXP(String RSEXP) {
        this.RSEXP = RSEXP;
    }
}