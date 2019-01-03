package hris.A;

import com.sns.jdf.EntityData;

/**
 * A01SelfDetailData.java
 * 개인인적사항조회 데이타
 *   [관련 RFC] : ZGHR_RFC_PERSONEL_EXTRA
 * 
 * @author 정진만
 * @version 1.0, 2016/08/08
 */
public class A01SelfDetailExtraData extends EntityData {

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	NATIO	;//	CHAR	15	국적
    public String 	LANDX	;//	CHAR	15	국적명
    public String 	GBORT	;//	CHAR	25	출생지
    public String 	GBDAT	;//	DATS	8	생년월일
    public String 	AGECN	;//	CHAR	3	연령
    public String 	GESCH	;//	CHAR	1	성별 키
    public String 	GESCX	;//	CHAR	10	성별
    public String 	FAMST	;//	CHAR	 1 	결혼 여부 키
    public String 	FATXT	;//	CHAR	 6 	결혼상태
    public String 	FAMDT	;//	DATS	 8 	결혼기념일
    public String 	KONFE	;//	CHAR	 2 	종파 키
    public String 	KTEXT	;//	CHAR	 25 	공교
    public String 	RACKY	;//	CHAR	 2 	Ethnic group
    public String 	LTEXT	;//	CHAR	 50 	민족 Text
    public String 	PCODE	;//	CHAR	 2 	Political status
    public String 	PTEXT	;//	CHAR	 40 	정치성향
    public String 	CTEDT	;//	DATS	 8 	계약만료일
    public String 	CTEDTX	;//	CHAR	 40 	계약만료일(변환)

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getNATIO() {
        return NATIO;
    }

    public void setNATIO(String NATIO) {
        this.NATIO = NATIO;
    }

    public String getLANDX() {
        return LANDX;
    }

    public void setLANDX(String LANDX) {
        this.LANDX = LANDX;
    }

    public String getGBORT() {
        return GBORT;
    }

    public void setGBORT(String GBORT) {
        this.GBORT = GBORT;
    }

    public String getGBDAT() {
        return GBDAT;
    }

    public void setGBDAT(String GBDAT) {
        this.GBDAT = GBDAT;
    }

    public String getAGECN() {
        return AGECN;
    }

    public void setAGECN(String AGECN) {
        this.AGECN = AGECN;
    }

    public String getGESCH() {
        return GESCH;
    }

    public void setGESCH(String GESCH) {
        this.GESCH = GESCH;
    }

    public String getGESCX() {
        return GESCX;
    }

    public void setGESCX(String GESCX) {
        this.GESCX = GESCX;
    }

    public String getFAMST() {
        return FAMST;
    }

    public void setFAMST(String FAMST) {
        this.FAMST = FAMST;
    }

    public String getFATXT() {
        return FATXT;
    }

    public void setFATXT(String FATXT) {
        this.FATXT = FATXT;
    }

    public String getFAMDT() {
        return FAMDT;
    }

    public void setFAMDT(String FAMDT) {
        this.FAMDT = FAMDT;
    }

    public String getKONFE() {
        return KONFE;
    }

    public void setKONFE(String KONFE) {
        this.KONFE = KONFE;
    }

    public String getKTEXT() {
        return KTEXT;
    }

    public void setKTEXT(String KTEXT) {
        this.KTEXT = KTEXT;
    }

    public String getRACKY() {
        return RACKY;
    }

    public void setRACKY(String RACKY) {
        this.RACKY = RACKY;
    }

    public String getLTEXT() {
        return LTEXT;
    }

    public void setLTEXT(String LTEXT) {
        this.LTEXT = LTEXT;
    }

    public String getPCODE() {
        return PCODE;
    }

    public void setPCODE(String PCODE) {
        this.PCODE = PCODE;
    }

    public String getPTEXT() {
        return PTEXT;
    }

    public void setPTEXT(String PTEXT) {
        this.PTEXT = PTEXT;
    }

    public String getCTEDT() {
        return CTEDT;
    }

    public void setCTEDT(String CTEDT) {
        this.CTEDT = CTEDT;
    }

    public String getCTEDTX() {
        return CTEDTX;
    }

    public void setCTEDTX(String CTEDTX) {
        this.CTEDTX = CTEDTX;
    }
}