package	hris.A.A17Licence;

/**
 * A17LicenceBuildData.java
 * 자격증 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_LICN_LIST
 * 
 * @author 최영호    
 * @version 1.0, 2002/01/11
 * 수정(20050223:유용원)
 */

public class A17LicenceData extends com.sns.jdf.EntityData {

    /* 해외 */
    public String 	GRADE	;//	ZGRADE	CHAR	60	0	License & Grade
    public String 	LNUMBER	;//	ZLNUMBER	CHAR	60	0	License No.
    public String 	ACDATE	;//	ZACDATE	DATS	8	0	Date of acquisition
    public String 	EXDATE	;//	ZEXDATE	DATS	8	0	Date of expriy
    public String 	AUTHORITY	;//	ZAUTORITY	CHAR	60	0	Authority
    public String 	LAW	;//	ZLAW	CHAR	1	0	Assignment by law
    public String 	LOCATION	;//	ZLOCATION	CHAR	60	0	Equipment/Location
    public String 	ASREASON	;//	ZASREASON	CHAR	60	0	Assignment reasons
    public String 	PERNR_D	;//	ZPERNR	CHAR	10	0	Personnel Number

    /* 국내 */
    public String 	PERNR	;//	NUMC	 8 	사원 번호
    public String 	BEGDA	;//	 DATS 	 8 	시작일
    public String 	AINF_SEQN	;//	CHAR	 10 	결재정보 일련번호
    public String 	LICN_TYPE	;//	CHAR	 1 	자격증구분
    public String 	GUBN_NAME	;//	CHAR	20	자격증구분명
    public String 	FILD_TYPE	;//	CHAR	 2 	분야
    public String 	FILD_NAME	;//	CHAR	 20 	분야명
    public String 	LICN_CODE	;//	CHAR	 4 	자격증
    public String 	LICN_NAME	;//	CHAR	 50 	자격증명
    public String 	LICN_GRAD	;//	CHAR	 2 	자격등급
    public String 	GRAD_NAME	;//	CHAR	 10 	자격등급명
    public String 	OBN_DATE	;//	DATS	 8 	취득일
    public String 	LICN_NUMB	;//	CHAR	 20 	자격증번호
    public String 	PUBL_ORGH	;//	CHAR	 30 	발행처
    public String 	ORGEH	;//	NUMC	 8 	조직 단위
    public String 	ORGTX	;//	CHAR	 40 	오브젝트 이름
    public String 	CERT_FLAG	;//	CHAR	 1 	증빙
    public String 	CERT_DATE	;//	DATS	 8 	증빙제출일
    public String 	PAY_DATE	;//	DATS	 8 	지급일자
    public String 	GIVE_RATE1	;//	CHAR	 3 	지급율
    public String 	LICN_AMNT	;//	CURR	 13,2 	금액
    public String 	WAERS	;//	CUKY	 5 	통화 키
    public String 	EQUI_NAME	;//	CHAR	 40 	설비
    public String 	ESTA_AREA	;//	CHAR	 40 	위치
    public String 	PRIZ_TEXT	;//	CHAR	 60 	비고
    public String 	ZPERNR	;//	NUMC	 8 	대리신청자 사번
    public String 	ZUNAME	;//	CHAR	 12 	부서서무 이름
    public String 	AEDTM	;//	DATS	 8 	변경일
    public String 	UNAME	;//	CHAR	 12 	사용자이름

    public String getGRADE() {
        return GRADE;
    }

    public void setGRADE(String GRADE) {
        this.GRADE = GRADE;
    }

    public String getLNUMBER() {
        return LNUMBER;
    }

    public void setLNUMBER(String LNUMBER) {
        this.LNUMBER = LNUMBER;
    }

    public String getACDATE() {
        return ACDATE;
    }

    public void setACDATE(String ACDATE) {
        this.ACDATE = ACDATE;
    }

    public String getEXDATE() {
        return EXDATE;
    }

    public void setEXDATE(String EXDATE) {
        this.EXDATE = EXDATE;
    }

    public String getAUTHORITY() {
        return AUTHORITY;
    }

    public void setAUTHORITY(String AUTHORITY) {
        this.AUTHORITY = AUTHORITY;
    }

    public String getLAW() {
        return LAW;
    }

    public void setLAW(String LAW) {
        this.LAW = LAW;
    }

    public String getLOCATION() {
        return LOCATION;
    }

    public void setLOCATION(String LOCATION) {
        this.LOCATION = LOCATION;
    }

    public String getASREASON() {
        return ASREASON;
    }

    public void setASREASON(String ASREASON) {
        this.ASREASON = ASREASON;
    }

    public String getPERNR_D() {
        return PERNR_D;
    }

    public void setPERNR_D(String PERNR_D) {
        this.PERNR_D = PERNR_D;
    }

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

    public String getLICN_TYPE() {
        return LICN_TYPE;
    }

    public void setLICN_TYPE(String LICN_TYPE) {
        this.LICN_TYPE = LICN_TYPE;
    }

    public String getGUBN_NAME() {
        return GUBN_NAME;
    }

    public void setGUBN_NAME(String GUBN_NAME) {
        this.GUBN_NAME = GUBN_NAME;
    }

    public String getFILD_TYPE() {
        return FILD_TYPE;
    }

    public void setFILD_TYPE(String FILD_TYPE) {
        this.FILD_TYPE = FILD_TYPE;
    }

    public String getFILD_NAME() {
        return FILD_NAME;
    }

    public void setFILD_NAME(String FILD_NAME) {
        this.FILD_NAME = FILD_NAME;
    }

    public String getLICN_CODE() {
        return LICN_CODE;
    }

    public void setLICN_CODE(String LICN_CODE) {
        this.LICN_CODE = LICN_CODE;
    }

    public String getLICN_NAME() {
        return LICN_NAME;
    }

    public void setLICN_NAME(String LICN_NAME) {
        this.LICN_NAME = LICN_NAME;
    }

    public String getLICN_GRAD() {
        return LICN_GRAD;
    }

    public void setLICN_GRAD(String LICN_GRAD) {
        this.LICN_GRAD = LICN_GRAD;
    }

    public String getGRAD_NAME() {
        return GRAD_NAME;
    }

    public void setGRAD_NAME(String GRAD_NAME) {
        this.GRAD_NAME = GRAD_NAME;
    }

    public String getOBN_DATE() {
        return OBN_DATE;
    }

    public void setOBN_DATE(String OBN_DATE) {
        this.OBN_DATE = OBN_DATE;
    }

    public String getLICN_NUMB() {
        return LICN_NUMB;
    }

    public void setLICN_NUMB(String LICN_NUMB) {
        this.LICN_NUMB = LICN_NUMB;
    }

    public String getPUBL_ORGH() {
        return PUBL_ORGH;
    }

    public void setPUBL_ORGH(String PUBL_ORGH) {
        this.PUBL_ORGH = PUBL_ORGH;
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

    public String getCERT_FLAG() {
        return CERT_FLAG;
    }

    public void setCERT_FLAG(String CERT_FLAG) {
        this.CERT_FLAG = CERT_FLAG;
    }

    public String getCERT_DATE() {
        return CERT_DATE;
    }

    public void setCERT_DATE(String CERT_DATE) {
        this.CERT_DATE = CERT_DATE;
    }

    public String getPAY_DATE() {
        return PAY_DATE;
    }

    public void setPAY_DATE(String PAY_DATE) {
        this.PAY_DATE = PAY_DATE;
    }

    public String getGIVE_RATE1() {
        return GIVE_RATE1;
    }

    public void setGIVE_RATE1(String GIVE_RATE1) {
        this.GIVE_RATE1 = GIVE_RATE1;
    }

    public String getLICN_AMNT() {
        return LICN_AMNT;
    }

    public void setLICN_AMNT(String LICN_AMNT) {
        this.LICN_AMNT = LICN_AMNT;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }

    public String getEQUI_NAME() {
        return EQUI_NAME;
    }

    public void setEQUI_NAME(String EQUI_NAME) {
        this.EQUI_NAME = EQUI_NAME;
    }

    public String getESTA_AREA() {
        return ESTA_AREA;
    }

    public void setESTA_AREA(String ESTA_AREA) {
        this.ESTA_AREA = ESTA_AREA;
    }

    public String getPRIZ_TEXT() {
        return PRIZ_TEXT;
    }

    public void setPRIZ_TEXT(String PRIZ_TEXT) {
        this.PRIZ_TEXT = PRIZ_TEXT;
    }

    public String getZPERNR() {
        return ZPERNR;
    }

    public void setZPERNR(String ZPERNR) {
        this.ZPERNR = ZPERNR;
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
}










